//
//  StockAndIndexLimited.h
//  Stocker
//
//  Created by abdurrahman on 9/28/16.
//  Copyright (c) 2016 Veripark. All rights reserved.
//

#import <JSONModel/JSONModel.h>

/*
 {
 Fund = "4499970000.00";
 Gain = "3977154387.00";
 Name = "IS BANKASI (C)";
 Symbol = ISCTR;
 }
*/

@interface StockAndIndexLimited : JSONModel

@property (nonatomic,strong) NSString<Optional>* Fund;
@property (nonatomic,strong) NSString<Optional>* Gain;
@property (nonatomic,strong) NSString<Optional>* Name;
@property (nonatomic,strong) NSString<Optional>* Symbol;

@end
