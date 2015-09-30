//
//  SupplierLookup.m
//  SupplyChainPrototype
//
//  Created by Robert Kerr on 3/29/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.
//

#import "SupplierLookup.h"

@implementation SupplierLookup

-(SupplierLookup *) initWithParameters:(NSDictionary*)parameters
{
    self = [super init];
    
    if (self) {
        if ([parameters objectForKey:@"SupplierID"] != [NSNull null])
            _SupplierID = parameters[@"SupplierID"];
        if ([parameters objectForKey:@"Name"] != [NSNull null])
            _Name = parameters[@"Name"];
        if ([parameters objectForKey:@"Region"] != [NSNull null])
            _Region = parameters[@"Region"];
    }
    return self;
}


@end
