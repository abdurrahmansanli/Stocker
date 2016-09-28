//
//  MainVC.m
//  Stocker
//
//  Created by abdurrahman on 9/27/16.
//  Copyright (c) 2016 Veripark. All rights reserved.
//

#import "MainVC.h"
#import "SubcategoriesVC.h"

@interface MainVC ()

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)buttonActionIMKBHisse:(id)sender {
    SubcategoriesVC *subcategoriesVC = [SubcategoriesVC new];
    [self.navigationController pushViewController:subcategoriesVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
