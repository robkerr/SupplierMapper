//
//  PlantMaster.h
//  SupplyChainPrototype
//
//  Created by Robert Kerr on 3/29/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlantMaster : NSObject

@property (nonatomic, strong) NSNumber *Id;
@property (nonatomic, strong) NSString *SupplierID;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *Region;
@property (nonatomic, strong) NSNumber *Latitude;
@property (nonatomic, strong) NSNumber *Longitude;

@property (nonatomic, strong) NSString *DescriptionAndCode;

-(PlantMaster *) initWithParameters:(NSDictionary*)parameters;


@end
