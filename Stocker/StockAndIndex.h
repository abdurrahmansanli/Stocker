//
//  StockAndIndex.h
//  Stocker
//
//  Created by abdurrahman on 9/27/16.
//  Copyright (c) 2016 Veripark. All rights reserved.
//

#import <JSONModel/JSONModel.h>

/*
 <StockandIndex>
 <Symbol>MIPAZ</Symbol>
 <Price>1.34</Price>
 <Difference>-0.01</Difference>
 <Volume>698235.77</Volume>
 <Buying>1.32</Buying>
 <Selling>1.34</Selling>
 <Hour>174349</Hour>
 <DayPeakPrice>1.37</DayPeakPrice>
 <DayLowestPrice>1.31</DayLowestPrice>
 <Total>0</Total>
 <IsIndex>false</IsIndex>
 </StockandIndex>
 */

@interface StockAndIndex : JSONModel

@property (nonatomic,strong) NSString<Optional>* Symbol;
@property (nonatomic,strong) NSString<Optional>* Price;
@property (nonatomic,strong) NSString<Optional>* Difference;
@property (nonatomic,strong) NSString<Optional>* Volume;
@property (nonatomic,strong) NSString<Optional>* Buying;
@property (nonatomic,strong) NSString<Optional>* Selling;
@property (nonatomic,strong) NSString<Optional>* Hour;
@property (nonatomic,strong) NSString<Optional>* DayPeakPrice;
@property (nonatomic,strong) NSString<Optional>* DayLowestPrice;
@property (nonatomic,strong) NSString<Optional>* Total;
@property (nonatomic,strong) NSString<Optional>* IsIndex;

@end
