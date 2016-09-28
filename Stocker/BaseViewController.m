//
//  BaseViewController.m
//  Stocker
//
//  Created by abdurrahman on 9/27/16.
//  Copyright (c) 2016 Veripark. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)showProgressHud {
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD setForegroundColor:[UIColor redColor]];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
}

- (void)hideProgressHud {
    [SVProgressHUD dismiss];
}

@end
