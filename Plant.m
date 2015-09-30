//
//  Plant.m
//  SupplyChainPrototype
//
//  Created by Rob Kerr on 3/29/14.
//  Copyright (c) 2014 Rob Kerr. All rights reserved.
//

#import "Plant.h"

@implementation Plant

-(Plant *) initWithParameters:(NSDictionary*)parameters
{
    self = [super init];
    
    if (self) {
        if ([parameters objectForKey:@"Id"] != [NSNull null])
            _Id = [NSNumber numberWithInt:[parameters[@"Id"] intValue]];
        if ([parameters objectForKey:@"SupplierID"] != [NSNull null])
            _SupplierID = parameters[@"SupplierID"];
        if ([parameters objectForKey:@"Name"] != [NSNull null])
            _Name = parameters[@"Name"];
        if ([parameters objectForKey:@"Region"] != [NSNull null])
            _Region = parameters[@"Region"];
        if ([parameters objectForKey:@"PTVL"] != [NSNull null])
            _PTVL = parameters[@"PTVL"];
        if ([parameters objectForKey:@"Nameplate"] != [NSNull null])
            _Nameplate = parameters[@"Nameplate"];
        if ([parameters objectForKey:@"Latitude"] != [NSNull null])
            _Latitude = [NSNumber numberWithFloat:[parameters[@"Latitude"] floatValue]];
        if ([parameters objectForKey:@"Longitude"] != [NSNull null])
            _Longitude = [NSNumber numberWithFloat:[parameters[@"Longitude"] floatValue]];
    }
    return self;
}

@end
