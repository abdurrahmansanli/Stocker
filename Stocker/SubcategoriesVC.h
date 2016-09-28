//
//  SubcategoriesVC.h
//  Stocker
//
//  Created by abdurrahman on 9/27/16.
//  Copyright (c) 2016 Veripark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SubcategoriesVC : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *arrayData;

@end
