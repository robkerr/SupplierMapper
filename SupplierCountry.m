//
//  SupplierCountry.m
//  SupplyChainPrototype
//
//  Created by Robert Kerr on 3/29/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.
//

#import "SupplierCountry.h"

@implementation SupplierCountry

-(SupplierCountry *) initWithParameters:(NSDictionary*)parameters
{
    self = [super init];
    
    if (self) {
        if ([parameters objectForKey:@"Id"] != [NSNull null])
            _Id = [NSNumber numberWithInt:[parameters[@"Id"] intValue]];
        if ([parameters objectForKey:@"Country"] != [NSNull null])
            _Country = parameters[@"Country"];
    }
    return self;
}

@end
