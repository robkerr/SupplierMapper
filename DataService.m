
#import "DataService.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

#import <MapKit/MapKit.h>
#import "PlantMaster.h"
#import "ProductCodeMaster.h"
#import "Supplier.h"
#import "SupplierCountry.h"
#import "PlantTurnover.h"
#import "PlantSupplierVolume.h"
#import "SupplierLookup.h"



#pragma mark * Private interace


@interface DataService() <MSFilter>

@property (nonatomic, strong)   MSTable *tblSomeTable;
@property (nonatomic)           NSInteger busyCount;

@end


#pragma mark * Implementation


@implementation DataService



+ (DataService *)defaultService
{
    // Create a singleton instance of DataService
    static DataService* service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[DataService alloc] init];
    });
    
    return service;
}

-(DataService *)init
{
    self = [super init];
    
    if (self)
    {
        // Initialize the Mobile Service client with your URL and key
        MSClient *client =
            [MSClient clientWithApplicationURLString:@"https://supplychainpoc.azure-mobile.net/"
                                     applicationKey:@""];
        
        // Add a Mobile Service filter to enable the busy indicator
        self.client = [client clientWithFilter:self];
        
        // Create one more more MSTable instance 
        self.tblSomeTable = [_client tableWithName:@"TableNameHere"];
        
        _plantMasterItems = [NSMutableDictionary new];
        _selectedPlantMasterItems = [NSMutableDictionary new];
        
        _ProductCodeMasterItems = [NSMutableArray new];
        _selectedProductCodeMasterItems = [NSMutableDictionary new];

        _supplierItems = [NSMutableDictionary new];
        _selectedSupplierItems = [NSMutableDictionary new];

        _supplierCountries = [NSMutableArray new];
        _selectedSupplierCountries = [NSMutableDictionary new];

        self.busyCount = 0;
    }
    
    return self;
}

- (void)getPlants:(QSCompletionBlock)completion
{
    MSTable *table = [_client tableWithName:@"PlantMaster"];
    MSQuery * query = [table query];
    
    NSMutableArray *orderBy = [NSMutableArray array];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"Name" ascending:YES];
    [orderBy addObject:sort];

    query.orderBy = orderBy;
    query.includeTotalCount = YES; // Request the total item count
    query.fetchLimit = 1000;
    
    // Invoke the MSQuery instance directly, rather than using the MSTable helper methods.
    [query readWithCompletion:^(NSArray *results, NSInteger totalCount, NSError *error) {

        [_plantMasterItems removeAllObjects];
        NSMutableDictionary *rawSearchList = [NSMutableDictionary new];
        
        for (NSDictionary *rowParameters in results)
        {
            PlantMaster *item = [[PlantMaster alloc] initWithParameters:rowParameters];
            [_plantMasterItems setObject:item forKey:item.SupplierID];
            
            if ([rawSearchList objectForKey:item.SupplierID]==nil)
                [rawSearchList setObject:item forKey:item.SupplierID];
            if ([rawSearchList objectForKey:item.DescriptionAndCode]==nil)
                [rawSearchList setObject:item forKey:item.DescriptionAndCode];
        }
        
        // sort the search list by key and place in a search list
        _plantSearchList = [[rawSearchList allKeys] sortedArrayUsingSelector: @selector(compare:)];
        
        // Let the caller know that we finished
         completion();
     }];
    
}

- (void)getSuppliers:(QSCompletionBlock)completion
{
    [self.client
     invokeAPI:@"getsupplierlookup"
     body:nil
     HTTPMethod:@"POST"
     parameters:nil
     headers:nil
     completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
         
         [_supplierItems removeAllObjects];
         NSMutableDictionary *rawSearchList = [NSMutableDictionary new];
         
         for (NSDictionary *rowParameters in result)
         {
             Supplier *item = [[Supplier alloc] initWithParameters:rowParameters];
             [_supplierItems setObject:item forKey:item.SupplierID];
             
             if ([rawSearchList objectForKey:item.SupplierID]==nil)
                 [rawSearchList setObject:item forKey:item.SupplierID];
             if ([rawSearchList objectForKey:item.DescriptionAndCode]==nil)
                 [rawSearchList setObject:item forKey:item.DescriptionAndCode];
         }

         // Save final output, which is an NSArray of twice as many objects, since we have each one in the list twice (once for code, once for description)
         _supplierSearchList = [[rawSearchList allKeys] sortedArrayUsingSelector: @selector(compare:)];
         
         // Let the caller know that we finished
         completion();
     }];
}


- (void)getProductCodeMaster:(QSCompletionBlock)completion
{
    MSTable *table = [_client tableWithName:@"ProductCodeMaster"];
    MSQuery * query = [table query];
    
    NSMutableArray *orderBy = [NSMutableArray array];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"Description" ascending:YES];
    [orderBy addObject:sort];
    
    query.orderBy = orderBy;
    query.includeTotalCount = YES; // Request the total item count
    query.fetchLimit = 1000;
    
    // Invoke the MSQuery instance directly, rather than using the MSTable helper methods.
    [query readWithCompletion:^(NSArray *results, NSInteger totalCount, NSError *error) {
        
        NSMutableDictionary *rawSearchList = [NSMutableDictionary new];
        NSMutableArray *rows = [[NSMutableArray alloc]init];
        
        for (NSDictionary *rowParameters in results)
        {
            ProductCodeMaster *item = [[ProductCodeMaster alloc] initWithParameters:rowParameters];
            [rows addObject:item];
            [rawSearchList setObject:item forKey:item.ProductCode];
            [rawSearchList setObject:item forKey:item.Description];
        }
        
        _ProductCodeMasterItems = [rows mutableCopy];

        _pccSearchList = [[rawSearchList allKeys] sortedArrayUsingSelector: @selector(compare:)];
        
        // Let the caller know that we finished
        completion();
    }];
    
}

- (void)getSupplierCountries:(QSCompletionBlock)completion
{
    MSTable *table = [_client tableWithName:@"SupplierCountry"];
    MSQuery * query = [table query];
    
    NSMutableArray *orderBy = [NSMutableArray array];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"Country" ascending:YES];
    [orderBy addObject:sort];
    
    query.orderBy = orderBy;
    query.includeTotalCount = YES; // Request the total item count
    query.fetchLimit = 1000;
    
    // Invoke the MSQuery instance directly, rather than using the MSTable helper methods.
    [query readWithCompletion:^(NSArray *results, NSInteger totalCount, NSError *error) {
        
        NSMutableArray *rows = [[NSMutableArray alloc]init];
        
        for (NSDictionary *rowParameters in results)
        {
            SupplierCountry *item = [[SupplierCountry alloc] initWithParameters:rowParameters];
            [rows addObject:item];
        }
        
        _supplierCountries = [rows mutableCopy];
        
        
        // Let the caller know that we finished
        completion();
    }];
    
}



/**************************************************************************************
 *
 *      Get plant turnover list, optionally filtered by plant and ProductCode codes
 *
 **************************************************************************************/
- (void)getPlantTurnover:(QSCompletionBlock)completion
{
    NSMutableDictionary *parms = [NSMutableDictionary new];
    _plantTurnoverItems = [NSArray new];
    NSMutableArray *plantVolumeItems = [NSMutableArray new];
    
    if (self.selectedPlantMasterItems.count>0)
    {
        NSMutableString *plants = [NSMutableString new];
        
        for (PlantMaster *plant in [_selectedPlantMasterItems allValues])
        {
            if (plants.length>0)
                [plants appendString:@","];
            
            [plants appendString:plant.SupplierID];
        }
        
        [parms setObject:plants forKey:@"plantList"];
    }
    else
        [parms setObject:@"" forKey:@"plantList"];

    if (self.selectedProductCodeMasterItems.count>0)
    {
        NSMutableString *pccs = [NSMutableString new];
        
        for (ProductCodeMaster *pcc in [_selectedProductCodeMasterItems allValues])
        {
            if (pccs.length>0)
                [pccs appendString:@","];
            
            [pccs appendString:pcc.ProductCode];
        }
        
        [parms setObject:pccs forKey:@"pccList"];
    }
    else
        [parms setObject:@"" forKey:@"pccList"];

    [self.client
     invokeAPI:@"getplantturnover"
     body:nil
     HTTPMethod:@"POST"
     parameters:parms
     headers:nil
     completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
         
         NSNumber *largest, *smallest;
         largest = [NSNumber numberWithDouble:DBL_MIN];
         smallest = [NSNumber numberWithDouble:DBL_MAX];
         
         
         if (error) {
             NSLog(@"Error %@", error );
         } else
         {
             NSMutableArray* rows = [[NSMutableArray alloc] init];
             
             for (NSDictionary* rowParameters in result)
             {
                 PlantTurnover *item = [[PlantTurnover alloc] initWithParameters: rowParameters];
                 
                 if (item.Turnover.doubleValue > largest.doubleValue)
                     largest = item.Turnover;
                 if (item.Turnover.doubleValue < smallest.doubleValue)
                     smallest = item.Turnover;
                 
                 PlantSupplierVolume *vol = [[PlantSupplierVolume alloc]initWithPlantTurnover:item WithDataService:self];
                 if (vol != nil)
                     [plantVolumeItems addObject:vol];
                 
                 [rows addObject:item];
             }
             
             _plantTurnoverItems = [rows copy];
             _plantSupplierItems = [plantVolumeItems copy];
             
             // now set the relative size of each item compared with largest/smallest
             double range = largest.doubleValue - smallest.doubleValue;
             for (PlantTurnover *item in _plantTurnoverItems)
             {
                 double relativeSize = 0.0;
                 if (range>0)
                     relativeSize = (item.Turnover.doubleValue - smallest.doubleValue) / range;
                 
                 item.RelativeSize = [NSNumber numberWithDouble:relativeSize];
             }
         }
         
         completion();
     }];
}

/**************************************************************************************
 *
 *      Get plant supplier list
 *
 **************************************************************************************/
- (void)getPlantSupplierVolumeForLocation:(NSString *)SupplierID OfType:(int)PlantOrSupplier :(QSCompletionBlock)completion
{
    CLLocationCoordinate2D gsdbLoc;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"#,##0"];
    
    // get the lat/long of whatever SupplierID is
    if (PlantOrSupplier==0)
    {
        PlantMaster *plant = [_plantMasterItems objectForKey:SupplierID];
        if (plant!=nil)
        {
            gsdbLoc = CLLocationCoordinate2DMake(plant.Latitude.floatValue, plant.Longitude.floatValue);
        }
    } else if (PlantOrSupplier==1)
    {
        Supplier *supp = [_supplierItems objectForKey:SupplierID];
        if (supp!=nil)
        {
            gsdbLoc = CLLocationCoordinate2DMake(supp.Latitude.floatValue, supp.Longitude.floatValue);
        }
    }

    // set the parameters for the web service call
    NSMutableDictionary *parms = [NSMutableDictionary new];
    _plantSupplierItems = [NSArray new];
    
    [parms setObject:SupplierID forKey:@"gsdbList"];
    
    if (self.selectedProductCodeMasterItems.count>0)
    {
        NSMutableString *pccs = [NSMutableString new];
        
        for (ProductCodeMaster *pcc in [_selectedProductCodeMasterItems allValues])
        {
            if (pccs.length>0)
                [pccs appendString:@","];
            
            [pccs appendString:pcc.ProductCode];
        }
        
        [parms setObject:pccs forKey:@"pccList"];
    }
    else
        [parms setObject:@"" forKey:@"pccList"];

    NSString *methodName = nil;
    
    if (PlantOrSupplier==0)
        methodName = @"getplantsuppliers";
    else
        methodName = @"getsupplierplants";
    
    
    [self.client
     invokeAPI:methodName
     body:nil
     HTTPMethod:@"POST"
     parameters:parms
     headers:nil
     completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
         
         NSNumber *largest, *smallest;
         largest = [NSNumber numberWithDouble:DBL_MIN];
         smallest = [NSNumber numberWithDouble:DBL_MAX];
         
         
         if (error) {
             NSLog(@"Error %@", error );
         } else
         {
             NSMutableArray* rows = [[NSMutableArray alloc] init];
             
             for (NSDictionary* rowParameters in result)
             {
                 
                 PlantSupplierVolume *item = [[PlantSupplierVolume alloc] initWithParameters: rowParameters];
                 
                 if (item.Turnover.doubleValue > largest.doubleValue)
                     largest = item.Turnover;
                 if (item.Turnover.doubleValue < smallest.doubleValue)
                     smallest = item.Turnover;
                 
                 if (PlantOrSupplier==1 && item.SupplierID != nil)
                 {
                     PlantMaster *plant = [_plantMasterItems objectForKey:item.SupplierID];
                     
                     if (plant != nil)
                     {
                         item.PinType = 0;
                         item.Name = plant.Name;
                         item.Latitude = plant.Latitude;
                         item.Longitude = plant.Longitude;
                         
                         NSMutableString *loc = [NSMutableString new];
                         if (plant.Region.length > 0 )
                         {
                             if (loc.length>0) [loc appendString:@", "];
                             [loc appendString:plant.Region];
                         }
                         
                         if (loc.length>0)
                             item.LocationText = loc;
                         

                     }
                 }
                 else if (PlantOrSupplier==0 && item.SupplierID != nil)
                 {
                     Supplier *supplier = [_supplierItems objectForKey:item.SupplierID];
                     
                     if (supplier != nil)
                     {
                         NSMutableString *loc = [NSMutableString new];
                         if (supplier.City.length>0)
                             [loc appendString:loc];
                         
                         if (supplier.State.length>0)
                         {
                             if (loc.length>0) [loc appendString:@", "];
                             [loc appendString:supplier.State];
                         }
                         if (supplier.Country.length>0)
                         {
                             if (loc.length>0) [loc appendString:@", "];
                             [loc appendString:supplier.Country];
                         }
                         if (supplier.Region.length>0)
                         {
                             if (loc.length>0) [loc appendString:@", "];
                             [loc appendString:supplier.Region];
                         }
                         
                         if (loc.length>0)
                             item.LocationText = loc;
                         
                         item.PinType = 1;
                         item.Name = supplier.Name;
                         item.Latitude = supplier.Latitude;
                         item.Longitude = supplier.Longitude;
                         item.SixMoWeightedAvg = supplier.SixMoWeightedAvg;
                     }
                 }
                 
                 // calculate distance from partner
                 CLLocationCoordinate2D siteLoc = CLLocationCoordinate2DMake(item.Latitude.floatValue, item.Longitude.floatValue);
                 item.DistanceFromPartnerMiles = [self milesfromPlace:gsdbLoc andToPlace:siteLoc];
                 item.DistanceFromPartnerLabel = [numberFormatter stringFromNumber:item.DistanceFromPartnerMiles];
                 
                 [rows addObject:item];
             }
             
             _plantSupplierItems = [rows copy];
             
             // now set the relative size of each item compared with largest/smallest
             double range = largest.doubleValue - smallest.doubleValue;
             for (PlantSupplierVolume *item in _plantSupplierItems)
             {
                 double relativeSize = 0.0;
                 if (range>0)
                     relativeSize = (item.Turnover.doubleValue - smallest.doubleValue) / range;
                 
                 item.RelativeSize = [NSNumber numberWithDouble:relativeSize];
             }
         }
         
         completion();
     }];
}

-(NSNumber *)milesfromPlace:(CLLocationCoordinate2D)from andToPlace:(CLLocationCoordinate2D)to  {
    
    CLLocation *userloc = [[CLLocation alloc]initWithLatitude:from.latitude longitude:from.longitude];
    CLLocation *dest = [[CLLocation alloc]initWithLatitude:to.latitude longitude:to.longitude];
    
    CLLocationDistance dist = [userloc distanceFromLocation:dest] * 0.00062137;
    
    //NSLog(@"%f",dist);
    NSString *distance = [NSString stringWithFormat:@"%f",dist];
    
    return [NSNumber numberWithFloat:[distance floatValue]];
    
}

- (void)busy:(BOOL)busy
{
    // assumes always executes on UI thread
    if (busy)
    {
        if (self.busyCount == 0 && self.busyUpdate != nil)
        {
            self.busyUpdate(YES);
        }
        self.busyCount ++;
    }
    else
    {
        if (self.busyCount == 1 && self.busyUpdate != nil)
        {
            self.busyUpdate(FALSE);
        }
        self.busyCount--;
    }
}

- (void)logErrorIfNotNil:(NSError *) error
{
    if (error)
    {
        NSLog(@"ERROR %@", error);
    }
}


#pragma mark * MSFilter methods


- (void)handleRequest:(NSURLRequest *)request
                 next:(MSFilterNextBlock)next
             response:(MSFilterResponseBlock)response
{
    // A wrapped response block that decrements the busy counter
    MSFilterResponseBlock wrappedResponse = ^(NSHTTPURLResponse *innerResponse, NSData *data, NSError *error)
    {
        [self busy:NO];
        response(innerResponse, data, error);
    };
    
    // Increment the busy counter before sending the request
    [self busy:YES];
    next(request, wrappedResponse);
}

@end
