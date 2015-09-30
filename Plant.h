//
//  Plant.h
//  SupplyChainPrototype
//
//  Created by Rob Kerr on 3/29/14.
//  Copyright (c) 2014 Rob Kerr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Plant : NSObject

@property (nonatomic, strong) NSNumber *Id;
@property (nonatomic, strong) NSString *SupplierID;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *Region;
@property (nonatomic, strong) NSString *PTVL;
@property (nonatomic, strong) NSString *Nameplate;
@property (nonatomic, strong) NSNumber *Latitude;
@property (nonatomic, strong) NSNumber *Longitude;

-(Plant *) initWithParameters:(NSDictionary*)parameters;

@end
