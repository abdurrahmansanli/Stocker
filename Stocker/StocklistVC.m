//
//  StocklistVC.m
//  Stocker
//
//  Created by abdurrahman on 9/27/16.
//  Copyright (c) 2016 Veripark. All rights reserved.
//

#import "StocklistVC.h"
#import "ServiceConnector.h"
#import "StocklistTVC.h"
#import "StockAndIndex.h"
#import "StockDetailVC.h"

@interface StocklistVC ()

@end

@implementation StocklistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [GenericUIKit addNavigationBarButton:@"searchButton" target:self action:@selector(searchButton) width:20 height:20];
    self.navigationItem.leftBarButtonItem = [GenericUIKit addNavigationBarButton:@"backButton" target:self action:@selector(backButton) width:20 height:20];
    [self.textFieldSearch addTarget:self action:@selector(searchFieldEdited) forControlEvents:UIControlEventEditingChanged];
    self.viewSearchBorder.layer.borderWidth = 1;
    self.viewSearchBorder.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.viewSearchBorder.layer.cornerRadius = 6;
    [self.tableView registerNib:[UINib nibWithNibName:@"StocklistTVC" bundle:nil] forCellReuseIdentifier:@"StocklistTVC"];
    self.arrayData = [NSMutableArray new];
    self.arrayDataFiltered = [NSMutableArray new];
    [self loadData];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:self.textFieldSearch]) {
        if (range.location>=8) {
            return NO;
        } else {
            return YES;
        }
    }
    return YES;
}

- (void)searchFieldEdited {
    [self filterResultsWithString:self.textFieldSearch.text];
}

- (void)filterResultsWithString:(NSString*)string {
    if (string.length>0) {
        NSMutableArray *filteredResults = [NSMutableArray new];
        for (StockAndIndex *stockAndIndex in self.arrayData) {
            if ([stockAndIndex.Symbol rangeOfString:string options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [filteredResults addObject:stockAndIndex];
            }
        }
        self.arrayDataFiltered = filteredResults;
        [self.tableView reloadData];
    } else {
        self.arrayDataFiltered = self.arrayData;
        [self.tableView reloadData];
    }
}

- (void)backButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchButton {
    if (self.constraintSearchViewTopSpacing.constant==-50) {
        self.constraintSearchViewTopSpacing.constant=0;
        [self.textFieldSearch becomeFirstResponder];
    } else {
        self.constraintSearchViewTopSpacing.constant=-50;
        self.textFieldSearch.text = @"";
        [self searchFieldEdited];
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}

- (void)loadData {
    [self showProgressHud];
    [ServiceConnector getToken:^(NSString *token) {
        [ServiceConnector soapRequestWithURL:@"http://mobileexam.veripark.com/mobileforeks/service.asmx" body:[NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:GetForexStocksandIndexesInfo><tem:request><tem:IsIPAD>true</tem:IsIPAD><tem:DeviceID>test</tem:DeviceID><tem:DeviceType>ipad</tem:DeviceType><tem:RequestKey>%@</tem:RequestKey><tem:Period>Day</tem:Period></tem:request></tem:GetForexStocksandIndexesInfo></soapenv:Body></soapenv:Envelope>",token] success:^(NSDictionary *responseDict) {
            
            NSDictionary *body = [responseDict objectForKey:@"soap:Body"];
            NSDictionary *getForexStocksandIndexesInfoResponse = [body objectForKey:@"GetForexStocksandIndexesInfoResponse"];
            NSDictionary *getForexStocksandIndexesInfoResult = [getForexStocksandIndexesInfoResponse objectForKey:@"GetForexStocksandIndexesInfoResult"];
            NSDictionary *stocknIndexesResponseList = [getForexStocksandIndexesInfoResult objectForKey:@"StocknIndexesResponseList"];
            NSArray *stockandIndex = [stocknIndexesResponseList objectForKey:@"StockandIndex"];
            
            for (NSDictionary *dict in stockandIndex) {
                NSError *error;
                StockAndIndex *stockAndIndex = [[StockAndIndex alloc] initWithDictionary:dict error:&error];
                if (!self.boolAccendingOnly && !self.boolDescendingOnly) {
                    [self.arrayData addObject:stockAndIndex];
                } else if (self.boolAccendingOnly) {
                    if (![stockAndIndex.Difference containsString:@"-"] && ![stockAndIndex.Difference isEqualToString:@"0.00"]) {
                        [self.arrayData addObject:stockAndIndex];
                    }
                } else if (self.boolDescendingOnly) {
                    if ([stockAndIndex.Difference containsString:@"-"]) {
                        [self.arrayData addObject:stockAndIndex];
                    }
                }
            }
            self.arrayDataFiltered = self.arrayData;
            [self hideProgressHud];
            [self.tableView reloadData];
        } failure:^{
            [self hideProgressHud];
        }];
    } failure:^{
        [self hideProgressHud];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayDataFiltered count];
}

- (NSString*)getTimeFromSeconds:(NSString*)seconds {
    int totalTime = seconds.intValue;
    int hours = totalTime / 3600;
    int minutes = (totalTime % 3600) / 60;
    return [NSString stringWithFormat:@"%d:%d",hours,minutes];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StocklistTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"StocklistTVC" forIndexPath:indexPath];
    StockAndIndex *stockAndIndex = [self.arrayDataFiltered objectAtIndex:indexPath.row];
    cell.label1.text = stockAndIndex.Price;
    cell.label2.text = stockAndIndex.Difference;
    cell.label3.text = stockAndIndex.Volume;
    cell.label4.text = stockAndIndex.Buying;
    cell.label5.text = stockAndIndex.Selling;
    cell.label6.text = [self getTimeFromSeconds:stockAndIndex.Hour];
    cell.labelSymbol.text = stockAndIndex.Symbol;
    if ([stockAndIndex.Difference containsString:@"-"]) {
        cell.image1.image = [UIImage imageNamed:@"downArrow"];
        cell.labelTotal.text = stockAndIndex.DayLowestPrice;
    } else if (![stockAndIndex.Price isEqualToString:@"0.00"]) {
        cell.image1.image = [UIImage imageNamed:@"upArrow"];
        cell.labelTotal.text = stockAndIndex.DayPeakPrice;
    } else {
        cell.labelTotal.text = stockAndIndex.DayPeakPrice;
    }
    if (indexPath.row%2==0) {
        cell.backgroundColor = [GenericUIKit colorFromHexString:@"#ededed"];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StockDetailVC *stockDetailVC = [StockDetailVC new];
    stockDetailVC.stockAndIndex = [self.arrayData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:stockDetailVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    UIImage *image = [UIImage imageNamed:@"veriparkLogo"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
    self.navigationItem.titleView.frame = CGRectMake(0, 0, 0, 30);
    self.navigationItem.titleView.contentMode = UIViewContentModeScaleAspectFit;
}

@end
