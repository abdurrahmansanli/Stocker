//
//  BaseViewController.h
//  Stocker
//
//  Created by abdurrahman on 9/27/16.
//  Copyright (c) 2016 Veripark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "ServiceConnector.h"
#import "SVProgressHUD.h"
#import "GenericUIKit.h"

@interface BaseViewController : UIViewController

- (void)showProgressHud;
- (void)hideProgressHud;

@end
