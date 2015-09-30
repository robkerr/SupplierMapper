//
//  POSTrendsUnderlayViewController.h
//  Created by Rob Kerr on 3/25/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.

#import <UIKit/UIKit.h>
#import "HTAutocompleteTextField.h"
#import "HTAutocompleteManager.h"

@protocol UnderlayMenuDelegate

@optional

-(void)filtersUpdated;

-(void)changeGroupFilter:(NSString *)newSelection;
-(void)changeCategoryFilter:(NSString *)newSelection;

@end


@interface UnderlayViewController : UIViewController <UITextFieldDelegate>

- (void)resignAllFirstResponder;

@property(nonatomic,assign)id delegate;
@property (weak, nonatomic) IBOutlet HTAutocompleteTextField *DimensionSearchField1;
@property (weak, nonatomic) IBOutlet HTAutocompleteTextField *DimensionSearchField2;
@property (weak, nonatomic) IBOutlet HTAutocompleteTextField *DimensionSearchField3;

@property (weak, nonatomic) IBOutlet UIButton *SearchAddButton1;
@property (weak, nonatomic) IBOutlet UIButton *SearchAddButton2;
@property (weak, nonatomic) IBOutlet UIButton *SearchAddButton3;

- (IBAction)SearchAddButton1Tapped:(id)sender;
- (IBAction)SearchAddButton2Tapped:(id)sender;
- (IBAction)SearchAddButton3Tapped:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *selectedMembersLabel1;
@property (weak, nonatomic) IBOutlet UILabel *selectedMembersLabel2;
@property (weak, nonatomic) IBOutlet UILabel *SelectedMembersLabel3;


@property (weak, nonatomic) IBOutlet UIButton *RemoveMembersButton1;
@property (weak, nonatomic) IBOutlet UIButton *RemoveMembersButton2;
@property (weak, nonatomic) IBOutlet UIButton *RemoveMembersButton3;


- (IBAction)RemoveMembersButton1Tapped:(id)sender;
- (IBAction)RemoveMembersButton2Tapped:(id)sender;
- (IBAction)RemoveMembersButton3Tapped:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *RegionButton1;
- (IBAction)RegionButton1Tapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *RegionButton2;
- (IBAction)RegionButton2Tapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *RegionButton3;
- (IBAction)RegionButton3Tapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *RegionButton4;
- (IBAction)RegionButton4Tapped:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *DimensionItems1SelectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *DimensionItems2SelectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *DimensionItems3SelectedLabel;


@end
