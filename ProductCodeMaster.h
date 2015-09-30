//
//  ProductCodeMaster.h
//  SupplyChainPrototype
//
//  Created by Robert Kerr on 3/29/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductCodeMaster : NSObject

@property (nonatomic, strong) NSNumber *Id;
@property (nonatomic, strong) NSString *ProductCode;
@property (nonatomic, strong) NSString *Description;

@property (nonatomic, strong) NSString *DescriptionAndCode;


-(ProductCodeMaster *) initWithParameters:(NSDictionary*)parameters;

@end
