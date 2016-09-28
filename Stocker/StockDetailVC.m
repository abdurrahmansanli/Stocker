//
//  StockDetailVC.m
//  Stocker
//
//  Created by abdurrahman on 9/27/16.
//  Copyright (c) 2016 Veripark. All rights reserved.
//

#import "StockDetailVC.h"

@interface StockDetailVC ()
{
    double maxY;
    double minY;
    double maxX;
    double minX;
}
@end

@implementation StockDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [GenericUIKit addNavigationBarButton:@"backButton" target:self action:@selector(backButton) width:20 height:20];
    self.arrayGraphData = [NSMutableArray new];
    [self loadData];
}

- (void)backButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData {
    [self showProgressHud];
    [ServiceConnector getToken:^(NSString *token) {
        [ServiceConnector soapRequestWithURL:@"http://mobileexam.veripark.com/mobileforeks/service.asmx" body:[NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\"><soapenv:Header/><soapenv:Body><tem:GetForexStocksandIndexesInfo><tem:request><tem:IsIPAD>true</tem:IsIPAD><tem:DeviceID>test</tem:DeviceID><tem:DeviceType>ipad</tem:DeviceType><tem:RequestKey>%@</tem:RequestKey><tem:RequestedSymbol>%@</tem:RequestedSymbol><tem:Period>Month</tem:Period></tem:request></tem:GetForexStocksandIndexesInfo></soapenv:Body></soapenv:Envelope>",token,self.stockAndIndex.Symbol] success:^(NSDictionary *responseDict) {
            
            NSDictionary *body = [responseDict objectForKey:@"soap:Body"];
            NSDictionary *getForexStocksandIndexesInfoResponse = [body objectForKey:@"GetForexStocksandIndexesInfoResponse"];
            NSDictionary *getForexStocksandIndexesInfoResult = [getForexStocksandIndexesInfoResponse objectForKey:@"GetForexStocksandIndexesInfoResult"];
            NSDictionary *stocknIndexesGraphicInfos = [getForexStocksandIndexesInfoResult objectForKey:@"StocknIndexesGraphicInfos"];
            NSArray *stockandIndexGraphic = [stocknIndexesGraphicInfos objectForKey:@"StockandIndexGraphic"];
            
            for (NSDictionary *dict in stockandIndexGraphic) {
                NSError *error;
                StockAndIndexGraphic *stockAndIndexGraphic = [[StockAndIndexGraphic alloc] initWithDictionary:dict error:&error];
                [self.arrayGraphData addObject:stockAndIndexGraphic];
            }
            
            NSMutableArray *dates = [NSMutableArray new];
            NSMutableArray *values = [NSMutableArray new];
            
            for (StockAndIndexGraphic *stockAndIndexGraphic in self.arrayGraphData) {
                [dates addObject:stockAndIndexGraphic.Date];
                [values addObject:stockAndIndexGraphic.Price];
            }
            
            maxX = 0;
            maxY = 0;
            minX = 0;
            minY = 0;
            
            for (int k=0;k<values.count;k++) {
                NSString *value = [values objectAtIndex:k];
                if (value.doubleValue>maxY) {
                    NSString *str = [values objectAtIndex:k];
                    maxY = str.doubleValue;
                }
            }
            
            minY = maxY;
            
            for (int k=0;k<values.count;k++) {
                NSString *value = [values objectAtIndex:k];
                if (value.doubleValue<minY) {
                    NSString *str = [values objectAtIndex:k];
                    minY = str.doubleValue;
                }
            }
            
            maxX = dates.count;
            
            if (dates.count>0 && values.count>0) {
                [self drawChartWithXValues:dates yValues:values];
                
                for (int k=0;k<dates.count;k++) {
                    UILabel *str = [[UILabel alloc] initWithFrame:CGRectMake(k*(self.viewChartArea.frame.size.width/dates.count), (self.viewChartArea.frame.size.height+10), 20, 30)];
                    NSString *date = [self stringToDate:[dates objectAtIndex:k]];
                    str.text = date;
                    str.font = [str.font fontWithSize:12];
                    [self.viewChartArea addSubview:str];
                }
                
                NSMutableArray *arrayOfYElements = values;
                NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
                [arrayOfYElements sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];

                for (int k=0;k<arrayOfYElements.count;k++) {
                    UILabel *str = [[UILabel alloc] initWithFrame:CGRectMake(-30, k*(self.viewChartArea.frame.size.height/arrayOfYElements.count), 50, 20)];
                    NSString *text = [arrayOfYElements objectAtIndex:k];
                    str.text = [text substringToIndex:4];
                    str.font = [str.font fontWithSize:12];
                    [self.viewChartArea addSubview:str];
                }
            }
            
            [self loadStaticData];
            [self hideProgressHud];
        } failure:^{
            [self hideProgressHud];
        }];
    } failure:^{
        [self hideProgressHud];
    }];
}

-(NSString*)stringToDate:(NSString *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSString *stringTime = date;
    
    NSDate *dateTime = [formatter dateFromString:stringTime];
    
    [formatter setDateFormat : @"dd"];
    NSString *dateString = [formatter stringFromDate:dateTime];
    
    return dateString;
}

- (void)drawChartWithXValues:(NSArray*)xValues yValues:(NSArray*)yValues {
    [self drawRectFromPoint:CGPointMake(0, self.viewChartArea.frame.size.height) endingPoint:CGPointMake(0,0)];
    [self drawRectFromPoint:CGPointMake(0, self.viewChartArea.frame.size.height) endingPoint:CGPointMake(self.viewChartArea.frame.size.width,self.viewChartArea.frame.size.height)];
    
    for (int k=0;k+1<yValues.count;k++) {
        NSString *val1 = [yValues objectAtIndex:k];
        NSString *val2 = [yValues objectAtIndex:k+1];
        [self addNewDrawingPoingFrom:CGPointMake(k, val1.doubleValue) to:CGPointMake(k+1, val2.doubleValue)];
    }
}

- (void)addNewDrawingPoingFrom:(CGPoint)from to:(CGPoint)to {
    [self drawRectFromPoint:CGPointMake([self getXPlacementOfValue:from.x inMax:maxX], [self getYPlacementOfValue:from.y inMax:maxY]) endingPoint:CGPointMake([self getXPlacementOfValue:to.x inMax:maxX], [self getYPlacementOfValue:to.y inMax:maxY])];
}

- (CGFloat)getXPlacementOfValue:(CGFloat)value inMax:(CGFloat)inMax {
    return (value*self.viewChartArea.frame.size.width)/inMax;
}

- (CGFloat)getYPlacementOfValue:(CGFloat)value inMax:(CGFloat)inMax {
    return ((inMax-value)*self.viewChartArea.frame.size.height)/inMax;
}

- (void)drawRectFromPoint:(CGPoint)startingPoint endingPoint:(CGPoint)endingPoint {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startingPoint];
    [path addLineToPoint:endingPoint];

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor blackColor] CGColor];
    shapeLayer.lineWidth = 2.0;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];

    [self.viewChartArea.layer addSublayer:shapeLayer];
}

- (void)loadStaticData {
    self.labelSymbol.text = self.stockAndIndex.Symbol;
    self.labelPrice.text = self.stockAndIndex.Price;
    self.labelChange.text = self.stockAndIndex.Difference;
    self.labelDailyMax.text = self.stockAndIndex.DayPeakPrice;
    self.labelDailyMin.text = self.stockAndIndex.DayLowestPrice;
    self.labelLast.text = self.stockAndIndex.Buying;
    self.labelVolume.text = self.stockAndIndex.Volume;
    self.labelCount.text = self.stockAndIndex.Total;
    if ([self.stockAndIndex.Difference containsString:@"-"]) {
        self.imageChange.image = [UIImage imageNamed:@"downArrow"];
    } else if (![self.stockAndIndex.Difference isEqualToString:@"0.00"]) {
        self.imageChange.image = [UIImage imageNamed:@"upArrow"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    UIImage *image = [UIImage imageNamed:@"veriparkLogo"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
    self.navigationItem.titleView.frame = CGRectMake(0, 0, 0, 30);
    self.navigationItem.titleView.contentMode = UIViewContentModeScaleAspectFit;
}

@end
