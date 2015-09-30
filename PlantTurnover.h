//
//  PlantTurnover.h
//  SupplyChainPrototype
//
//  Created by Robert Kerr on 3/29/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlantTurnover : NSObject

@property (nonatomic, strong) NSString *SupplierID;
@property (nonatomic, strong) NSNumber *Turnover;
@property (nonatomic, strong) NSNumber *VehCumUsage;
@property (nonatomic, strong) NSNumber *AnnualizedVolume;
@property (nonatomic, strong) NSNumber *AvgPiecePrice;
@property (nonatomic, strong) NSNumber *RelativeSize;       // 1.0 = this is the largest in the list, 0.25 = this is the smallest

-(PlantTurnover *) initWithParameters:(NSDictionary*)parameters;

@end
