//
//  SupplierCountry.h
//  SupplyChainPrototype
//
//  Created by Robert Kerr on 3/29/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupplierCountry : NSObject

@property (nonatomic, strong) NSNumber *Id;
@property (nonatomic, strong) NSString *Country;

-(SupplierCountry *) initWithParameters:(NSDictionary*)parameters;

@end
