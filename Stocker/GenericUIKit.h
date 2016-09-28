//
//  GenericUIKit.h
//  Stocker
//
//  Created by abdurrahman on 9/27/16.
//  Copyright (c) 2016 Veripark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GenericUIKit : NSObject

+ (UIBarButtonItem*)addNavigationBarButton:(NSString*)imageName target:(id)target action:(SEL)action width:(CGFloat)width height:(CGFloat)height;
+ (UIColor *)colorFromHexString:(NSString *)hexString;

@end
