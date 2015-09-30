//
//  POSTrendsUnderlayViewController.m
//  Created by Rob Kerr on 3/25/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.

#import "UnderlayViewController.h"
#import "DataService.h"
#import "PlantMaster.h"
#import "ProductCodeMaster.h"
#import "Supplier.h"



@interface UnderlayViewController ()

    // private properties
    @property (strong, nonatomic) DataService *dataService;

@end

@implementation UnderlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set a default data source for all instances.  Otherwise, you can specify the data source on individual text fields via the autocompleteDataSource property
    [HTAutocompleteTextField setDefaultAutocompleteDataSource:[HTAutocompleteManager sharedManager]];
    
    self.DimensionSearchField1.autocompleteType = HTAutoCompleteTypePlant;
    self.DimensionSearchField1.ignoreCase = YES;
    self.selectedMembersLabel1.text = @"";
    self.DimensionItems1SelectedLabel.text = @"";

    self.DimensionSearchField2.autocompleteType = HTAutocompleteTypeProductCode;
    self.DimensionSearchField2.ignoreCase = YES;
    self.selectedMembersLabel2.text = @"";
    self.DimensionItems2SelectedLabel.text = @"";

    self.DimensionSearchField3.autocompleteType = HTautocompleteTypeSupplier;
    self.DimensionSearchField3.ignoreCase = YES;
    self.SelectedMembersLabel3.text = @"";
    self.DimensionItems3SelectedLabel.text = @"";

    // Dismiss the keyboard when the user taps outside of a text field
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    
    _dataService = [DataService defaultService];
    [self loadPlantMasterList];
    [self loadProductCodeMasterList];
    [self loadSupplierList];
}

- (void)loadPlantMasterList
{
    [_dataService getPlants:^
     {
         NSLog(@"Plant Row Count: %lu", (unsigned long)_dataService.plantMasterItems.count);
     }];
}
- (void)loadSupplierList
{
    [_dataService getSuppliers:^
     {
         NSLog(@"Supplier Row Count: %lu", (unsigned long)_dataService.supplierItems.count);
     }];
}
- (void)loadProductCodeMasterList
{
    [_dataService getProductCodeMaster:^
     {
         NSLog(@"ProductCode Row Count: %lu", (unsigned long)_dataService.ProductCodeMasterItems.count);
     }];
}

- (void)resignAllFirstResponder
{
    if ([self.DimensionSearchField1 isFirstResponder])
    {
        self.DimensionSearchField1.text = @"";
        [self.DimensionSearchField1 resignFirstResponder];
    }
    
    if ([self.DimensionSearchField2 isFirstResponder])
    {
        self.DimensionSearchField2.text = @"";
        [self.DimensionSearchField2 resignFirstResponder];
    }
    
    if ([self.DimensionSearchField3 isFirstResponder])
    {
        self.DimensionSearchField3.text = @"";
        [self.DimensionSearchField3 resignFirstResponder];
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self resignAllFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SearchAddButton1Tapped:(id)sender {
    [self AddSearchItemFromTextbox1];
}

-(void)AddSearchItemFromTextbox1
{
    [self.DimensionSearchField1 resignFirstResponder];
    
    NSString *newSelection = self.DimensionSearchField1.text;
    
    if ([newSelection length]>0 && _dataService.plantMasterItems.count > 0)
    {
        NSString *textEntered = [newSelection lowercaseString];
        
        for (PlantMaster *plant in [_dataService.plantMasterItems allValues])
        {
            NSString *plantSupplierID = [plant.SupplierID lowercaseString];
            NSString *DescriptionAndCode = [plant.DescriptionAndCode lowercaseString];
            
            if ([DescriptionAndCode isEqualToString:textEntered] || [plantSupplierID isEqualToString:textEntered])
            {
                [self addSearchPlantItem:plant];
                break;
            } // if
        } // for each
        
    } // if selection length and plantitem list both are >0
    
    [self.DimensionSearchField1 becomeFirstResponder];
}

-(void)AddSearchItemFromTextbox2
{
    [self.DimensionSearchField2 resignFirstResponder];
    
    NSString *newSelection = self.DimensionSearchField2.text;
    
    if ([newSelection length]>0 && _dataService.ProductCodeMasterItems.count > 0)
    {
        NSString *textEntered = [newSelection lowercaseString];
        
        for (ProductCodeMaster *item in [_dataService ProductCodeMasterItems])
        {
            NSString *itemName = [item.ProductCode lowercaseString];
            NSString *itemCode = [item.Description lowercaseString];
            
            if ([itemName isEqualToString:textEntered] || [itemCode isEqualToString:textEntered])
            {
                [self addSearchProductCodeItem:item];
                break;
            } // if
        } // for each
        
    } // if selection length and plantitem list both are >0
    
    [self.DimensionSearchField2 becomeFirstResponder];
}

-(void)AddSearchItemFromTextbox3
{
    [self.DimensionSearchField3 resignFirstResponder];
    
    NSString *newSelection = self.DimensionSearchField3.text;
    
    if ([newSelection length]>0 && _dataService.supplierItems.count > 0)
    {
        NSString *textEntered = [newSelection lowercaseString];
        
        for (Supplier *item in [_dataService.supplierItems allValues])
        {
            NSString *itemCode = [item.SupplierID lowercaseString];
            NSString *DescriptionAndCode = [item.DescriptionAndCode lowercaseString];
            
            if ([DescriptionAndCode isEqualToString:textEntered] || [itemCode isEqualToString:textEntered])
            {
                [self addSearchSupplierItem:item];
                break;
            } // if
        } // for each
        
    } // if selection length and plantitem list both are >0
    
    [self.DimensionSearchField3 becomeFirstResponder];
}


-(void)addSearchPlantItem:(PlantMaster *)plant
{
    NSMutableString *existingSelections = [[NSMutableString alloc]initWithString:self.selectedMembersLabel1.text];
    
    if ([existingSelections length]>0)
        [existingSelections appendString:@", "];
    
    [existingSelections appendString:plant.DescriptionAndCode];
    [_dataService.selectedPlantMasterItems setObject:plant forKey:plant.SupplierID];
    
    self.DimensionSearchField1.text = @"";
    self.selectedMembersLabel1.text = existingSelections;
    
    self.selectedMembersLabel1.frame = CGRectMake(
      self.selectedMembersLabel1.frame.origin.x,
      self.selectedMembersLabel1.frame.origin.y,
      320, 20);
    
    // Size to fit the contents
    [self.selectedMembersLabel1 sizeToFit];
    
    // Reset the width to standard with
    self.selectedMembersLabel1.frame = CGRectMake(
      self.selectedMembersLabel1.frame.origin.x,
      self.selectedMembersLabel1.frame.origin.y,
      320, self.selectedMembersLabel1.frame.size.height);
    
    // set label that indicates how many are selected
    self.DimensionItems1SelectedLabel.text = [NSString stringWithFormat:@"(%ld selected)", (unsigned long) _dataService.selectedPlantMasterItems.count];
    
  //  if([self.delegate respondsToSelector:@selector(filtersUpdated:)])
        [self.delegate filtersUpdated]; // message to delegate that user has changed something

}

-(void)addSearchProductCodeItem:(ProductCodeMaster *)newItem
{
    NSMutableString *existingSelections = [[NSMutableString alloc]initWithString:self.selectedMembersLabel2.text];
    
    if ([existingSelections length]>0)
        [existingSelections appendString:@", "];
    
    [existingSelections appendString:newItem.DescriptionAndCode];
    [_dataService.selectedProductCodeMasterItems setObject:newItem forKey:newItem.ProductCode];
    
    self.DimensionSearchField2.text = @"";
    self.selectedMembersLabel2.text = existingSelections;
    
    self.selectedMembersLabel2.frame = CGRectMake(
          self.selectedMembersLabel2.frame.origin.x,
          self.selectedMembersLabel2.frame.origin.y,
          320, 20);
    
    // Size to fit the contents
    [self.selectedMembersLabel2 sizeToFit];
    
    // Reset the width to standard with
    self.selectedMembersLabel2.frame = CGRectMake(
          self.selectedMembersLabel2.frame.origin.x,
          self.selectedMembersLabel2.frame.origin.y,
          320, self.selectedMembersLabel2.frame.size.height);
    
    // set label that indicates how many are selected
    self.DimensionItems2SelectedLabel.text = [NSString stringWithFormat:@"(%ld selected)", (unsigned long) _dataService.selectedProductCodeMasterItems.count];
    
 //   if([self.delegate respondsToSelector:@selector(filtersUpdated:)])
        [self.delegate filtersUpdated]; // message to delegate that user has changed something
}

-(void)addSearchSupplierItem:(Supplier *)supplier
{
    NSMutableString *existingSelections = [[NSMutableString alloc]initWithString:self.SelectedMembersLabel3.text];
    
    if ([existingSelections length]>0)
        [existingSelections appendString:@", "];
    
    [existingSelections appendString:supplier.DescriptionAndCode];
    [_dataService.selectedSupplierItems setObject:supplier forKey:supplier.SupplierID];
    
    self.DimensionSearchField3.text = @"";
    self.SelectedMembersLabel3.text = existingSelections;
    
    self.SelectedMembersLabel3.frame = CGRectMake(
                                                  self.SelectedMembersLabel3.frame.origin.x,
                                                  self.SelectedMembersLabel3.frame.origin.y,
                                                  320, 20);
    
    // Size to fit the contents
    [self.SelectedMembersLabel3 sizeToFit];
    
    // Reset the width to standard with
    self.SelectedMembersLabel3.frame = CGRectMake(
                                                  self.SelectedMembersLabel3.frame.origin.x,
                                                  self.SelectedMembersLabel3.frame.origin.y,
                                                  320, self.SelectedMembersLabel3.frame.size.height);
    
    // set label that indicates how many are selected
    self.DimensionItems3SelectedLabel.text = [NSString stringWithFormat:@"(%ld selected)", (unsigned long) _dataService.selectedSupplierItems.count];
    
    //  if([self.delegate respondsToSelector:@selector(filtersUpdated:)])
    [self.delegate filtersUpdated]; // message to delegate that user has changed something
}


- (IBAction)SearchAddButton2Tapped:(id)sender {
    [self AddSearchItemFromTextbox2];
}

- (IBAction)SearchAddButton3Tapped:(id)sender {
    [self AddSearchItemFromTextbox3];
}

- (IBAction)RemoveMembersButton1Tapped:(id)sender {
    self.selectedMembersLabel1.text = @"";
    self.DimensionItems1SelectedLabel.text = @"";
    [_dataService.selectedPlantMasterItems removeAllObjects];
    [self.selectedMembersLabel1 sizeToFit];
    [self.delegate filtersUpdated]; // message to delegate that user has changed something
}

- (IBAction)RemoveMembersButton2Tapped:(id)sender {
    self.selectedMembersLabel2.text = @"";
    self.DimensionItems2SelectedLabel.text = @"";
    [_dataService.selectedProductCodeMasterItems removeAllObjects];
    [self.selectedMembersLabel2 sizeToFit];
    [self.delegate filtersUpdated]; // message to delegate that user has changed something
}

- (IBAction)RemoveMembersButton3Tapped:(id)sender {
    self.SelectedMembersLabel3.text = @"";
    self.DimensionItems3SelectedLabel.text = @"";
    [_dataService.selectedSupplierItems removeAllObjects];
    [self.SelectedMembersLabel3 sizeToFit];
    [self.delegate filtersUpdated]; // message to delegate that user has changed something
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.DimensionSearchField1 isFirstResponder])
    {
        [self AddSearchItemFromTextbox1];
    }
    else if ([self.DimensionSearchField2 isFirstResponder])
    {
        [self AddSearchItemFromTextbox2];
    }
    else if ([self.DimensionSearchField3 isFirstResponder])
    {
        [self AddSearchItemFromTextbox3];
    }
    return YES;
}

-(void)addAllPlantsFromRegion:(NSString *)region
{
    for (PlantMaster *plant in [_dataService.plantMasterItems allValues])
    {
        if ([plant.Region isEqualToString:region])
            [self addSearchPlantItem:plant];
    } // for each
}

- (IBAction)RegionButton1Tapped:(id)sender {
    [self addAllPlantsFromRegion:self.RegionButton1.titleLabel.text];
}
- (IBAction)RegionButton2Tapped:(id)sender {
    [self addAllPlantsFromRegion:self.RegionButton2.titleLabel.text];
}
- (IBAction)RegionButton3Tapped:(id)sender {
    [self addAllPlantsFromRegion:self.RegionButton3.titleLabel.text];
}
- (IBAction)RegionButton4Tapped:(id)sender {
    [self addAllPlantsFromRegion:self.RegionButton4.titleLabel.text];
}
@end
