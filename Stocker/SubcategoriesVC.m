//
//  SubcategoriesVC.m
//  Stocker
//
//  Created by abdurrahman on 9/27/16.
//  Copyright (c) 2016 Veripark. All rights reserved.
//

#import "SubcategoriesVC.h"
#import "ServiceConnector.h"
#import "CategoryTVC.h"
#import "StockAndIndex.h"
#import "StocklistVC.h"

@interface SubcategoriesVC ()

@end

@implementation SubcategoriesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [GenericUIKit addNavigationBarButton:@"backButton" target:self action:@selector(backButton) width:20 height:20];
    self.navigationItem.rightBarButtonItem = [GenericUIKit addNavigationBarButton:nil target:self action:nil width:20 height:20];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"CategoryTVC" bundle:nil] forCellReuseIdentifier:@"CategoryTVC"];
    self.arrayData = [NSMutableArray new];
    [self.arrayData addObject:@"Hisse Ve Endeksler"];
    [self.arrayData addObject:@"İMKB Yükselenler"];
    [self.arrayData addObject:@"İMKB Düşenler"];
    [self.arrayData addObject:@"İMKB Hacme Göre -30"];
    [self.arrayData addObject:@"İMKB Hacme Göre -50"];
    [self.arrayData addObject:@"İMKB Hacme Göre -100"];
    [self.tableView setContentInset:UIEdgeInsetsMake(20,0,0,0)];
    [self.tableView reloadData];
}

- (void)backButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryTVC" forIndexPath:indexPath];
    cell.label.text = [self.arrayData objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            StocklistVC *stocklistVC = [StocklistVC new];
            [self.navigationController pushViewController:stocklistVC animated:YES];
        }
            break;
        case 1:
        {
            StocklistVC *stocklistVC = [StocklistVC new];
            stocklistVC.boolAccendingOnly = YES;
            [self.navigationController pushViewController:stocklistVC animated:YES];
        }
            break;
        case 2:
        {
            StocklistVC *stocklistVC = [StocklistVC new];
            stocklistVC.boolDescendingOnly = YES;
            [self.navigationController pushViewController:stocklistVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UIImage *image = [UIImage imageNamed:@"veriparkLogo"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
    self.navigationItem.titleView.frame = CGRectMake(0, 0, 0, 30);
    self.navigationItem.titleView.contentMode = UIViewContentModeScaleAspectFit;
}

@end
