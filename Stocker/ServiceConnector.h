//
//  ServiceConnector.h
//  Stocker
//
//  Created by abdurrahman on 9/27/16.
//  Copyright (c) 2016 Veripark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceConnector : NSObject

+ (void)soapRequestWithURL:(NSString*)url
                      body:(NSString*)body
                   success:(void(^)(NSDictionary* responseDict))success
                   failure:(void(^)())failure;

+ (void)getToken:(void(^)(NSString* token))success
         failure:(void(^)())failure;

@end
