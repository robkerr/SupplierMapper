

#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import <Foundation/Foundation.h>


#pragma mark * Block Definitions


typedef void (^QSCompletionBlock) ();
typedef void (^QSCompletionWithIndexBlock) (NSUInteger index);
typedef void (^QSBusyUpdateBlock) (BOOL busy);


#pragma mark * TodoService public interface


@interface DataService : NSObject

//----------  Data lists fetched/maintained by this data service  --------
@property (nonatomic, strong)   NSMutableDictionary *plantMasterItems;
@property (nonatomic, strong)   NSMutableDictionary *selectedPlantMasterItems;

@property (nonatomic, strong)   NSArray *ProductCodeMasterItems;
@property (nonatomic, strong)   NSMutableDictionary *selectedProductCodeMasterItems;

@property (nonatomic, strong)   NSMutableDictionary *supplierItems;
@property (nonatomic, strong)   NSMutableDictionary *selectedSupplierItems;

@property (nonatomic, strong)   NSArray *supplierCountries;
@property (nonatomic, strong)   NSMutableDictionary *selectedSupplierCountries;

@property (nonatomic, strong)   NSArray *plantTurnoverItems;
@property (nonatomic, strong)   NSArray *plantSupplierItems;

//------- Dimension searching arrays  -------
@property (nonatomic, strong)   NSArray *plantSearchList;  // an Array that has 2 entries per plant - one code, other description.  Used to do prefix searching for code or description simultaneously
@property (nonatomic, strong)   NSArray *pccSearchList;  // an Array that has 2 entries per ProductCode - one code, other description.  Used to do prefix searching for code or description simultaneously
@property (nonatomic, strong)   NSArray *supplierSearchList;  // an Array that has 2 entries per Supplier - one code, other description.  Used to do prefix searching for code or description simultaneously

//---------- External methods to call --------
- (void)getPlants:(QSCompletionBlock)completion;
- (void)getProductCodeMaster:(QSCompletionBlock)completion;
- (void)getPlantTurnover:(QSCompletionBlock)completion;
- (void)getSuppliers:(QSCompletionBlock)completion;
- (void)getPlantSupplierVolumeForLocation:(NSString *)SupplierID OfType:(int)PlantOrSupplier :(QSCompletionBlock)completion;

//------------  Internal plumbing code -----------
@property (nonatomic, strong)   MSClient *client;
@property (nonatomic, copy)     QSBusyUpdateBlock busyUpdate;

+ (DataService *)defaultService;

- (void)handleRequest:(NSURLRequest *)request
                 next:(MSFilterNextBlock)next
             response:(MSFilterResponseBlock)response;

@end
