//
//  StocklistVC.h
//  Stocker
//
//  Created by abdurrahman on 9/27/16.
//  Copyright (c) 2016 Veripark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface StocklistVC : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewSearchBorder;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSearch;

@property (nonatomic, strong) NSMutableArray *arrayData;
@property (nonatomic, strong) NSMutableArray *arrayDataFiltered;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSearchViewTopSpacing;
@property (nonatomic) BOOL boolAccendingOnly;
@property (nonatomic) BOOL boolDescendingOnly;

@end
