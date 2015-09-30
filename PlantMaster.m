//
//  PlantMaster.m
//  SupplyChainPrototype
//
//  Created by Robert Kerr on 3/29/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.
//

#import "PlantMaster.h"

@implementation PlantMaster

-(PlantMaster *) initWithParameters:(NSDictionary*)parameters
{
    self = [super init];
    
    if (self) {
        if ([parameters objectForKey:@"Id"] != [NSNull null])
            _Id = [NSNumber numberWithInt:[parameters[@"Id"] intValue]];
        if ([parameters objectForKey:@"SupplierID"] != [NSNull null])
            _SupplierID = parameters[@"SupplierID"];
        if ([parameters objectForKey:@"Name"] != [NSNull null])
            _Name = [parameters[@"Name"] capitalizedString];
        if ([parameters objectForKey:@"Region"] != [NSNull null])
            _Region = parameters[@"Region"];
        if ([parameters objectForKey:@"Latitude"] != [NSNull null])
            _Latitude = [NSNumber numberWithFloat:[parameters[@"Latitude"] floatValue]];
        if ([parameters objectForKey:@"Longitude"] != [NSNull null])
            _Longitude = [NSNumber numberWithFloat:[parameters[@"Longitude"] floatValue]];
        
        if (_SupplierID != nil && _Name != nil)
        {
            NSMutableString *s = [[NSMutableString alloc] initWithString:[_Name lowercaseString]];
            [s appendString:@" ("];
            [s appendString:[_SupplierID lowercaseString]];
            [s appendString:@")"];
            _DescriptionAndCode = s;
        }

    }
    return self;
}


@end
