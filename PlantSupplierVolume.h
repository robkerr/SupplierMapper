//
//  PlantSupplier.h
//  SupplyChainPrototype
//
//  Created by Robert Kerr on 3/29/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlantTurnover.h"
#import "DataService.h"

@interface PlantSupplierVolume : NSObject

@property (nonatomic, strong) NSString *SupplierID;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *City;
@property (nonatomic, strong) NSString *State;
@property (nonatomic, strong) NSString *Country;
@property (nonatomic, strong) NSString *Region;
@property (nonatomic, strong) NSString *LocationText;
@property (nonatomic, strong) NSNumber *Latitude;
@property (nonatomic, strong) NSNumber *Longitude;
@property (nonatomic, strong) NSNumber *SixMoWeightedAvg;
@property (nonatomic, strong) NSNumber *Turnover;
@property (nonatomic, strong) NSNumber *VehCumUsage;
@property (nonatomic, strong) NSNumber *AnnualizedVolume;
@property (nonatomic, strong) NSNumber *AvgPiecePrice;
@property (nonatomic, strong) NSNumber *RelativeSize;       // 1.0 = this is the largest in the list, 0.25 = this is the smallest
@property (nonatomic, assign) int PinType;  // 0=Plant, 1=Supplier
@property (nonatomic, strong) NSNumber *DistanceFromPartnerMiles;
@property (nonatomic, strong) NSString *DistanceFromPartnerLabel;

-(PlantSupplierVolume *) initWithParameters:(NSDictionary*)parameters;
-(PlantSupplierVolume *) initWithPlantTurnover:(PlantTurnover*)turnover WithDataService:(DataService *)dataService;

+(NSString *)CsvFileHeader;
-(NSString *)CsvDataRow;

@end
