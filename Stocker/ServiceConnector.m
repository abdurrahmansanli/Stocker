//
//  ServiceConnector.m
//  Stocker
//
//  Created by abdurrahman on 9/27/16.
//  Copyright (c) 2016 Veripark. All rights reserved.
//

#import "ServiceConnector.h"
#import "AFNetworking.h"
#import "XMLDictionary.h"

@implementation ServiceConnector

+ (void)soapRequestWithURL:(NSString*)url
                      body:(NSString*)body
                   success:(void(^)(NSDictionary* responseDict))success
                   failure:(void(^)())failure {
    NSURL *baseURL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:baseURL];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *xmlDictionary = [NSDictionary dictionaryWithXMLData:responseObject];
        success(xmlDictionary);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure();
        NSLog(@"REQUEST FAILED. \nBody: %@",body);
    }];
    
    [operation start];
}

+ (void)getToken:(void(^)(NSString* token))success
         failure:(void(^)())failure {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd:MM:yyyy HH:mm"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    [ServiceConnector soapRequestWithURL:@"http://mobileexam.veripark.com/mobileforeks/service.asmx" body:[NSString stringWithFormat:@"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><Encrypt xmlns=\"http://tempuri.org/\"><request>RequestIsValid%@</request></Encrypt></soap:Body></soap:Envelope>",currentDate] success:^(NSDictionary *responseDict) {
        NSDictionary *body = [responseDict objectForKey:@"soap:Body"];
        NSDictionary *encryptResponse = [body objectForKey:@"EncryptResponse"];
        NSString *encryptResult = [encryptResponse objectForKey:@"EncryptResult"];
        success(encryptResult);
    } failure:^{
        failure();
        NSLog(@"GET TOKEN FAILED");
    }];
}

@end