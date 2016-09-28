//
//  GenericUIKit.m
//  Stocker
//
//  Created by abdurrahman on 9/27/16.
//  Copyright (c) 2016 Veripark. All rights reserved.
//

#import "GenericUIKit.h"

@implementation GenericUIKit

+ (UIBarButtonItem*)addNavigationBarButton:(NSString*)imageName target:(id)target action:(SEL)action width:(CGFloat)width height:(CGFloat)height {
    UIImage* image3 = [UIImage imageNamed:imageName];
    CGRect frameimg = CGRectMake(0, 0, width, height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:target action:action
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *closeButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    return closeButton;
}

+ (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
