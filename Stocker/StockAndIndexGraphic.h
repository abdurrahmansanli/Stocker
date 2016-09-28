//
//  StockAndIndexGraphic.h
//  Stocker
//
//  Created by abdurrahman on 9/28/16.
//  Copyright (c) 2016 Veripark. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface StockAndIndexGraphic : JSONModel

@property (nonatomic,strong) NSString<Optional>* Price;
@property (nonatomic,strong) NSString<Optional>* Date;

@end
