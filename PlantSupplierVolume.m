//
//  PlantSupplier.m
//  SupplyChainPrototype
//
//  Created by Robert Kerr on 3/29/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.
//

#import "PlantSupplierVolume.h"
#import "PlantMaster.h"


@implementation PlantSupplierVolume

-(PlantSupplierVolume *) initWithParameters:(NSDictionary*)parameters
{
    self = [super init];
    
    if (self) {
        if ([parameters objectForKey:@"SupplierID"] != [NSNull null])
            _SupplierID = parameters[@"SupplierID"];
        if ([parameters objectForKey:@"Name"] != [NSNull null])
            _Name = parameters[@"Name"];
        if ([parameters objectForKey:@"City"] != [NSNull null])
            _City = parameters[@"City"];
        if ([parameters objectForKey:@"State"] != [NSNull null])
            _State = parameters[@"State"];
        if ([parameters objectForKey:@"Country"] != [NSNull null])
            _Country = parameters[@"Country"];
        if ([parameters objectForKey:@"Region"] != [NSNull null])
            _Region = parameters[@"Region"];
        if ([parameters objectForKey:@"Latitude"] != [NSNull null])
            _Latitude = [NSNumber numberWithFloat:[parameters[@"Latitude"] floatValue]];
        if ([parameters objectForKey:@"Longitude"] != [NSNull null])
            _Longitude = [NSNumber numberWithFloat:[parameters[@"Longitude"] floatValue]];
        if ([parameters objectForKey:@"Turnover"] != [NSNull null])
            _Turnover = [NSNumber numberWithDouble:[parameters[@"Turnover"] doubleValue]];
        if ([parameters objectForKey:@"SixMoWeightedAvg"] != [NSNull null])
            _SixMoWeightedAvg = [NSNumber numberWithDouble:[parameters[@"SixMoWeightedAvg"] doubleValue]];
        if ([parameters objectForKey:@"VehCumUsage"] != [NSNull null])
            _VehCumUsage = [NSNumber numberWithDouble:[parameters[@"VehCumUsage"] doubleValue]];
        if ([parameters objectForKey:@"AnnualizedVolume"] != [NSNull null])
            _AnnualizedVolume = [NSNumber numberWithDouble:[parameters[@"AnnualizedVolume"] doubleValue]];
        if ([parameters objectForKey:@"AvgPiecePrice"] != [NSNull null])
            _AvgPiecePrice = [NSNumber numberWithDouble:[parameters[@"AvgPiecePrice"] doubleValue]];
        
                
        
    }
    return self;
}

-(PlantSupplierVolume *) initWithPlantTurnover:(PlantTurnover*)turnover WithDataService:(DataService *)dataService
{
    self = [super init];
    
    if (self) {
        _SupplierID = turnover.SupplierID;
        _Turnover = turnover.Turnover;
        _VehCumUsage = turnover.VehCumUsage;
        _AnnualizedVolume = turnover.AnnualizedVolume;
        _AvgPiecePrice = turnover.AvgPiecePrice;
        
        
        PlantMaster *plant = [dataService.plantMasterItems objectForKey:_SupplierID];
        if (plant != nil)
        {
            _Name = plant.Name;
            _Region = plant.Region;
            _LocationText = plant.Region;
            _Latitude = plant.Latitude;
            _Longitude = plant.Longitude;
        }
    }
    
    return self;
}

+(NSString *)CsvFileHeader
{
    return @"SupplierID,Name,Latitude,Longitude,SixMoWeightedAvg,Turnover,VehCumUsage,AnnualizedVolume,AvgPiecePrice,RelativeSize\n";
}
-(NSString *)CsvDataRow
{
    return [NSString stringWithFormat:@"%@,%@,%f,%f,%f,%f,%f,%f,%f\n",
            _SupplierID,
            _Name,
            _Latitude.doubleValue,
            _Longitude.doubleValue,
            _Turnover.doubleValue,
            _SixMoWeightedAvg.doubleValue,
            _VehCumUsage.doubleValue,
            _AnnualizedVolume.doubleValue,
            _AvgPiecePrice.doubleValue];
}




@end
