//
//  SupplierLookup.h
//  SupplyChainPrototype
//
//  Created by Robert Kerr on 3/29/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupplierLookup : NSObject

@property (nonatomic, strong) NSString *SupplierID;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *Region;

-(SupplierLookup *) initWithParameters:(NSDictionary*)parameters;

@end
