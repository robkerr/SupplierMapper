//
//  ProductCodeMaster.m
//  SupplyChainPrototype
//
//  Created by Robert Kerr on 3/29/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.
//

#import "ProductCodeMaster.h"

@implementation ProductCodeMaster

-(ProductCodeMaster *) initWithParameters:(NSDictionary*)parameters
{
    self = [super init];
    
    if (self) {
        if ([parameters objectForKey:@"Id"] != [NSNull null])
            _Id = [NSNumber numberWithInt:[parameters[@"Id"] intValue]];
        if ([parameters objectForKey:@"ProductCode"] != [NSNull null])
            _ProductCode = parameters[@"ProductCode"];
        if ([parameters objectForKey:@"Description"] != [NSNull null])
            _Description = parameters[@"Description"];
        
        if (_ProductCode != nil && _Description != nil)
        {
            NSMutableString *s = [[NSMutableString alloc] initWithString:[_Description lowercaseString]];
            [s appendString:@" ("];
            [s appendString:[_ProductCode lowercaseString]];
            [s appendString:@")"];
            _DescriptionAndCode = s;
        }
        
    }
    return self;
}


@end
