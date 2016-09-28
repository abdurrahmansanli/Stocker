//
//  StockDetailVC.h
//  Stocker
//
//  Created by abdurrahman on 9/27/16.
//  Copyright (c) 2016 Veripark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "StockAndIndex.h"
#import "StockAndIndexGraphic.h"

@interface StockDetailVC : BaseViewController

@property (nonatomic, strong) StockAndIndex *stockAndIndex;
@property (weak, nonatomic) IBOutlet UILabel *labelSymbol;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelChange;
@property (weak, nonatomic) IBOutlet UIImageView *imageChange;
@property (weak, nonatomic) IBOutlet UILabel *labelDailyMax;
@property (weak, nonatomic) IBOutlet UILabel *labelDailyMin;
@property (weak, nonatomic) IBOutlet UILabel *labelLast;
@property (weak, nonatomic) IBOutlet UILabel *labelVolume;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;

@property (strong, nonatomic) NSMutableArray *arrayGraphData;
@property (weak, nonatomic) IBOutlet UIView *viewChartArea;

@end
