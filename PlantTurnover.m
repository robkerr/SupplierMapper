//
//  PlantTurnover.m
//  SupplyChainPrototype
//
//  Created by Robert Kerr on 3/29/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.
//

#import "PlantTurnover.h"

@implementation PlantTurnover

-(PlantTurnover *) initWithParameters:(NSDictionary*)parameters
{
    self = [super init];
    
    if (self) {
        if ([parameters objectForKey:@"PlantSupplierID"] != [NSNull null])
            _SupplierID = parameters[@"PlantSupplierID"];
        if ([parameters objectForKey:@"Turnover"] != [NSNull null])
            _Turnover = [NSNumber numberWithDouble:[parameters[@"Turnover"] doubleValue]];
        if ([parameters objectForKey:@"VehCumUsage"] != [NSNull null])
            _VehCumUsage = [NSNumber numberWithDouble:[parameters[@"VehCumUsage"] doubleValue]];
        if ([parameters objectForKey:@"AnnualizedVolume"] != [NSNull null])
            _AnnualizedVolume = [NSNumber numberWithDouble:[parameters[@"AnnualizedVolume"] doubleValue]];
        if ([parameters objectForKey:@"AvgPiecePrice"] != [NSNull null])
            _AvgPiecePrice = [NSNumber numberWithDouble:[parameters[@"AvgPiecePrice"] doubleValue]];
    }
    return self;
}


@end
