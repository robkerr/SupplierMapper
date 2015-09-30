//
//  POSTrendsViewController.m
//  Created by Rob Kerr on 3/25/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.

#import "MapOverlayViewController.h"
#import <ShinobiEssentials/SEssentialsSlidingOverlay.h>

#import "UnderlayViewController.h"
#import "MyProtocols.h"
#import "ImagePinAnnotation.h"
#import "PolyLineAnnotation.h"
#import "PolyLineAnnotationView.h"
#import "BubbleAnnotation.h"
#import "BubbleAnnotationView.h"
#import "DataService.h"
#import "PlantMaster.h"
#import "PlantTurnover.h"
#import "PlantSupplierVolume.h"
#import "Supplier.h"
#import "VolumeGridDatasource.h"
#import "BarChartDelegate.h"
#import "GenericDataPoint.h"



@interface MapOverlayViewController ()
{
    // private properties
    UILabel * _selectedLocationLabel;

    
    UILabel * _maskLabel;
    UIButton *_maskButton;
    UIScrollView *_pageScrollView;
    UIPageControl *_pageControl;

    VolumeGridDatasource *_volumeGridDelegate;
    ShinobiDataGrid* _volumeGrid;
    
    BarChartDelegate * _barChartDelegate;
    ShinobiChart* _distanceChart;
    
    CLLocationCoordinate2D _selectedLocation;
    NSString * _selectedSupplierID;
    
}
- (IBAction)returnToMenu:(id)sender;
//- (IBAction)changePage:(id)sender;

@end

@implementation MapOverlayViewController
{
    MKMapView * overlayMapView;
    UILabel *myUnderlayLabel;
    DataService *dataService;
    SEssentialsSlidingOverlay *slidingView;
    UnderlayViewController *underlayController;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)filtersUpdated
{
    if (_maskLabel == nil)
    {
        _maskLabel = [[UILabel alloc]initWithFrame:self.view.frame];
        _maskLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        [overlayMapView addSubview:_maskLabel];
        
        _maskButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_maskButton addTarget:self
                   action:@selector(refreshFilterSelections:)
         forControlEvents:UIControlEventTouchUpInside];
        
        _maskButton.frame = CGRectMake(250.0, 100.0, 150.0, 60.0);
        _maskButton.layer.borderWidth = 1.0;
        _maskButton.layer.masksToBounds = YES;
        _maskButton.layer.cornerRadius = 5.0;
        UIColor *borderColor =[UIColor whiteColor];
        _maskButton.layer.borderColor = borderColor.CGColor;
        
        [_maskButton setTitle:@"Refresh" forState:UIControlStateNormal];
        [_maskButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_maskButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        
        [overlayMapView addSubview:_maskButton];
    }
    
    NSLog(@"Received filtersUpdatedMessage in MapOverlayViewController");
}

- (IBAction)refreshFilterSelections:(id)sender {

    // remove prompt from UI
    if (_maskButton != nil)
    {
        [_maskButton removeFromSuperview];
        _maskButton = nil;
    }
    if (_maskLabel != nil)
    {
        [_maskLabel removeFromSuperview];
        _maskLabel = nil;
    }
    
    // remove all annotations
    [overlayMapView removeAnnotations:[overlayMapView annotations]];
    
    // Collapse navigational items
    [slidingView hideUnderlayAnimated:YES];
    
    [underlayController resignAllFirstResponder];
    
    // requery
    [self queryPlantTurnover];
}

// When underlay appears, resize the chart and grid to be smaller
- (void)slidingOverlayUnderlayDidAppear:(SEssentialsSlidingOverlay *)slidingOverlay
{
//    NSLog(@"Overlay appeared");
 //   mainChart.frame = chartNarrowRect;
 //   [mainChart redrawChart];
  
 //   [gridController resizeGrid:gridNarrowRect];
//    gridController.view.frame = gridNarrowRect;

}

// When underlay disappears, resize chart and grid to be larger
- (void)slidingOverlayUnderlayDidDisappear:(SEssentialsSlidingOverlay *)slidingOverlay
{
//    NSLog(@"Overlay disappeared");
    /*
    mainChart.frame = chartWideRect;
    [mainChart redrawChart];
    
    [gridController resizeGrid:gridWideRect];
     */
//    gridController.view.frame = gridWideRect;
}

-(void)changeGroupFilter:(NSString *)newSelection
{
//    NSLog(@"Change group filter: %@", newSelection);
    /*
    datasource.groupFilter = newSelection;
    [datasource loadDataFromJSON:0];
    [datasource loadDataFromJSON:1];
    [mainChart reloadData];
    [mainChart redrawChart];
    
    gridController.groupFilter = newSelection;
    [gridController loadDataFromJSON];
    */
}
-(void)changeCategoryFilter:(NSString *)newSelection
{
//    NSLog(@"Change category filter: %@", newSelection);
    /*
    datasource.categoryFilter = newSelection;
    [datasource loadDataFromJSON:0];
    [datasource loadDataFromJSON:1];
    [mainChart reloadData];
    [mainChart redrawChart];
    
    gridController.categoryFilter = newSelection;
    [gridController loadDataFromJSON];
     */
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dataService = [DataService defaultService];
    
    /***********  Setup the sliding view  ********/
    slidingView = [[SEssentialsSlidingOverlay alloc] initWithFrame:self.view.frame andToolbar:YES];
    slidingView.delegate = self;
    slidingView.overlay.texture = [UIColor whiteColor];
    
    [slidingView setUnderlaySizeType:SEssentialsUnderlayPixelSize];
    [slidingView setUnderlayRevealAmount:400.0f];
    
    [self.view addSubview:slidingView];

    //******************  Create the underlay, and add it to the underlay region **********
    underlayController = [[UnderlayViewController alloc]init];
    underlayController.delegate = self;
    [slidingView.underlay addSubview:underlayController.view];

    //*****************  Create the map view, add to overlay *********
    CGRect mapRect = CGRectMake(slidingView.frame.origin.x, slidingView.frame.origin.y, slidingView.frame.size.width, slidingView.frame.size.height-300);
    
    overlayMapView = [[MKMapView alloc] initWithFrame:mapRect];
    [slidingView addSubview:overlayMapView];
    [overlayMapView setAutoresizingMask:
     (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    overlayMapView.delegate = self;
    
    CGRect labelRect = CGRectMake(0, 0, mapRect.size.width, 30);
    _selectedLocationLabel = [[UILabel alloc]initWithFrame:labelRect];
    _selectedLocationLabel.backgroundColor = [UIColor clearColor];
    _selectedLocationLabel.textAlignment = NSTextAlignmentCenter;
    _selectedLocationLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:18.f];
    
    [overlayMapView addSubview:_selectedLocationLabel];

    
    // set map center and zoom
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(34.210357, -37.029190);
    
    MKCoordinateSpan span = {.latitudeDelta = 180, .longitudeDelta = 360};
    MKCoordinateRegion viewRegion = MKCoordinateRegionMake(location, span);
    
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location, 10000000,10000000);
    MKCoordinateRegion adjustedRegion = [overlayMapView regionThatFits:viewRegion];
    [overlayMapView setRegion:adjustedRegion animated:YES];
    
    //****************  Create the close button, add to the overlay  *********
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(returnToMenu:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Close" forState:UIControlStateNormal];
    button.frame = CGRectMake(956.0, 20.0, 40.0, 30.0);
    [slidingView.overlay addSubview:button];
    
    
    //*****************  Create a scrollview add to the overlay  **********
    CGRect scrollerRect = CGRectMake(slidingView.frame.origin.x, slidingView.frame.size.height-300,
                                    slidingView.frame.size.width, 299);

    _pageScrollView = [[UIScrollView alloc]initWithFrame:scrollerRect];
    _pageScrollView.delegate = self;
    _pageScrollView.contentSize = CGSizeMake(_pageScrollView.frame.size.width * 3, _pageScrollView.frame.size.height);
    [slidingView.overlay addSubview:_pageScrollView];

    // *****************  Create a page control, add to the overlay  **********
    /*
    CGRect pageViewRect = CGRectMake(scrollerRect.origin.x, scrollerRect.origin.y+scrollerRect.size.height,
                                     scrollerRect.size.width, 15);
    
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:pageViewRect];
    pageControl.numberOfPages = 4;
    pageControl.currentPage = 0;
    pageControl.tintColor = [UIColor blueColor];
    pageControl.tintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor redColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    [slidingView.overlay addSubview:pageControl];
     */
    
    // ***************  Create the volume grid and its delegate *************
    CGRect gridFrame = CGRectMake(0,0, scrollerRect.size.width - 170, scrollerRect.size.height);
//    gridFrame.origin.x = scrollerRect.origin.y = 0;
//    gridFrame.size = scrollerRect.size;

    _volumeGridDelegate = [[VolumeGridDatasource alloc]init];
    _volumeGridDelegate.DataRows = dataService.plantSupplierItems;
    _volumeGrid = [self createVolumeGrid:gridFrame WithDatasource:_volumeGridDelegate];
    [_pageScrollView addSubview:_volumeGrid];

    //****************  Create the Export button, add to the scrollview  *********
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(exportFileTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Export" forState:UIControlStateNormal];
    button.frame = CGRectMake(scrollerRect.size.width - 120, 30, 100.0, 30.0);
    [_pageScrollView addSubview:button];
  
    [self queryPlantTurnover];


}

-(ShinobiDataGrid *) createVolumeGrid:(CGRect)frame WithDatasource:(VolumeGridDatasource *)dataSource
{
    ShinobiDataGrid * grid = [[ShinobiDataGrid alloc] initWithFrame:frame];
    grid.selectionMode = SDataGridSelectionModeNone;
    
    //-----   Add Columns to the project list grid  ----
    SDataGridColumn* column = [[SDataGridColumn alloc] initWithTitle:@"SupplierID"];
    column.width = @60;
    column.sortMode = SDataGridColumnSortModeBiState;
    [grid addColumn:column];

    column = [[SDataGridColumn alloc] initWithTitle:@"Name"];
    column.width = @230;
    column.sortMode = SDataGridColumnSortModeBiState;
    [grid addColumn:column];

    column = [[SDataGridColumn alloc] initWithTitle:@"Location"];
    column.width = @140;
    column.sortMode = SDataGridColumnSortModeBiState;
    [grid addColumn:column];

    column = [[SDataGridColumn alloc] initWithTitle:@"Distance"];
    column.width = @83;
    column.sortMode = SDataGridColumnSortModeBiState;
    [grid addColumn:column];
    
    column = [[SDataGridColumn alloc] initWithTitle:@"Turnover"];
    column.width = @83;
    column.sortMode = SDataGridColumnSortModeBiState;
    [grid addColumn:column];

    column = [[SDataGridColumn alloc] initWithTitle:@"Usage"];
    column.sortMode = SDataGridColumnSortModeBiState;
    column.width = @83;
    [grid addColumn:column];

    column = [[SDataGridColumn alloc] initWithTitle:@"Volume"];
    column.sortMode = SDataGridColumnSortModeBiState;
    column.width = @83;
    [grid addColumn:column];

    column = [[SDataGridColumn alloc] initWithTitle:@"Avg Price"];
    column.sortMode = SDataGridColumnSortModeBiState;
    column.width = @90;
    [grid addColumn:column];

    grid.dataSource = dataSource;
    grid.delegate = dataSource;
    
    grid.defaultHeaderRowHeight = @20;
    grid.defaultCellStyleForHeaderRow.contentInset = UIEdgeInsetsMake(0, 4, 0, 4);
    grid.defaultCellStyleForHeaderRow.font = [UIFont fontWithName:@"EuphemiaUCAS" size:12.f];
    
    grid.defaultRowHeight = @20;
    grid.defaultCellStyleForRows.contentInset = UIEdgeInsetsMake(0, 4, 0, 4);
    grid.defaultCellStyleForRows.font = [UIFont fontWithName:@"EuphemiaUCAS" size:12.f];
    
    grid.defaultCellStyleForAlternateRows.contentInset = UIEdgeInsetsMake(0, 4, 0, 4);
    grid.defaultCellStyleForAlternateRows.font = [UIFont fontWithName:@"EuphemiaUCAS" size:12.f];

    for (int i=3;i<8;i++)
    {
        SDataGridColumn *col = [[grid columns] objectAtIndex:i];
        col.cellStyle.textAlignment = NSTextAlignmentRight;
        col.headerCellStyle.textAlignment = NSTextAlignmentLeft;
    }
 
    
    
    return grid;
}


- (void) ReloadDistanceChart
{
    if (_distanceChart != nil)
    {
        [_distanceChart removeFromSuperview];
    }
    
    _barChartDelegate = [[BarChartDelegate alloc]init];
    NSMutableArray* chartPoints = [NSMutableArray new];
    
    //*******************  Create the trend chart  *************************
    CGRect frame;
    frame.origin.x = _pageScrollView.frame.size.width;
    frame.origin.y = 0;
    frame.size = _pageScrollView.frame.size;
    
    _distanceChart = [[ShinobiChart alloc] initWithFrame:frame];
    _distanceChart.delegate = _barChartDelegate;
    _distanceChart.datasource = _barChartDelegate;
    
    _distanceChart.gesturePanType = SChartGesturePanTypeNone;
    
    //********* add X-Axis  *************
    SChartCategoryAxis *xAxis = [[SChartCategoryAxis alloc] init];
    xAxis.enableGesturePanning = NO;
    xAxis.enableGestureZooming = NO;
    _distanceChart.xAxis = xAxis;
    
    //***********  Add Y-Axis  ***************
    SChartNumberAxis *yAxis = [[SChartNumberAxis alloc] init];
    yAxis.axisPosition = SChartAxisPositionReverse;
    //    yAxis.title = @"Billable Hours";
    yAxis.rangePaddingHigh = @(1.0);
    [_distanceChart addYAxis:yAxis];
    
    // Style changes
    SChartTheme *chartTheme = [SChartiOS7Theme new];
    chartTheme.chartStyle.backgroundColor = [UIColor whiteColor];
    chartTheme.chartStyle.backgroundColorGradient = [UIColor whiteColor];
    chartTheme.xAxisStyle.majorTickStyle.labelFont = [UIFont fontWithName:@"Avenir-Light" size:10.0f];
    chartTheme.legendStyle.font = [UIFont fontWithName:@"Avenir-Light" size:10.0f];
    chartTheme.yAxisStyle.majorTickStyle.labelFont = [UIFont fontWithName:@"Avenir-Light" size:10.0f];
    [_distanceChart applyTheme: chartTheme];
    
    float over2000Miles, num2000Miles, num1000Miles, num750Miles, num500Miles, num250Miles;
    
    for (PlantSupplierVolume *item in dataService.plantSupplierItems)
    {
        if (item.DistanceFromPartnerMiles != nil && item.DistanceFromPartnerMiles.floatValue > .01)
        {
            if (item.DistanceFromPartnerMiles.floatValue >= 2000.0f)
                over2000Miles++;
            
            if (item.DistanceFromPartnerMiles.floatValue < 2000.0f)
                num2000Miles++;
            
            if (item.DistanceFromPartnerMiles.floatValue < 1000.0f)
                num1000Miles++;
            
            if (item.DistanceFromPartnerMiles.floatValue < 750.0f)
                num750Miles++;
            
            if (item.DistanceFromPartnerMiles.floatValue < 500.0f)
                num500Miles++;
            
            if (item.DistanceFromPartnerMiles.floatValue < 250.0f)
                num250Miles++;
        }
    }

    GenericDataPoint *pt = nil;
    
    if (over2000Miles > 0)
    {
        pt = [GenericDataPoint new];
        pt.Label = @">2000";
        pt.Value1 = [NSNumber numberWithFloat:over2000Miles];
        [chartPoints addObject:pt];
    }
    
    if (num2000Miles > 0)
    {
        pt = [GenericDataPoint new];
        pt.Label = @"<2000";
        pt.Value1 = [NSNumber numberWithFloat:num2000Miles];
        [chartPoints addObject:pt];
    }

    if (num1000Miles > 0)
    {
        pt = [GenericDataPoint new];
        pt.Label = @"<1000";
        pt.Value1 = [NSNumber numberWithFloat:num1000Miles];
        [chartPoints addObject:pt];
    }
    
    if (num750Miles > 0)
    {
        pt = [GenericDataPoint new];
        pt.Label = @"<750";
        pt.Value1 = [NSNumber numberWithFloat:num750Miles];
        [chartPoints addObject:pt];
    }
    
    if (num500Miles > 0)
    {
        pt = [GenericDataPoint new];
        pt.Label = @"<500";
        pt.Value1 = [NSNumber numberWithFloat:num500Miles];
        [chartPoints addObject:pt];
    }
    
    if (num250Miles > 0)
    {
        pt = [GenericDataPoint new];
        pt.Label = @"<250";
        pt.Value1 = [NSNumber numberWithFloat:num250Miles];
        [chartPoints addObject:pt];
    }
    
    _barChartDelegate.DataPoints = chartPoints;
    
    //********** Show legend  ************
    _distanceChart.legend.hidden = NO;
    _distanceChart.legend.placement = SChartLegendPlacementOutsidePlotArea;
    _distanceChart.legend.position = SChartLegendPositionBottomMiddle;
    
    //*****  Finally, add the chart to the view controller  ********
    [_pageScrollView addSubview:_distanceChart];
}


- (void)queryPlantTurnover
{
    [dataService getPlantTurnover:^
     {
         NSLog(@"Plants Retrieved: %lu", (unsigned long)dataService.plantTurnoverItems.count);
    
         [self dropPlantPins:nil];
         _volumeGridDelegate.DataRows = _volumeGridDelegate.SortedDataRows = dataService.plantSupplierItems;
         [_volumeGrid reload];
         
     }];
}


- (void)queryPlantSuppliers:(NSString *)PlantSupplierID
{
    // remove all annoations
    [overlayMapView removeAnnotations:[overlayMapView annotations]];
    [self dropPlantPins:PlantSupplierID];
    
    [dataService getPlantSupplierVolumeForLocation:PlantSupplierID OfType:0 :^
     {
         NSLog(@"Suppliers Retrieved: %lu", (unsigned long)dataService.plantSupplierItems.count);
         [self dropPlantSupplierVolumePinsForPinType:[NSNumber numberWithInteger:1]];
         
         [self ReloadDistanceChart];
         _volumeGridDelegate.DataRows = _volumeGridDelegate.SortedDataRows = dataService.plantSupplierItems;
         [_volumeGrid reload];
     }];
}

- (void)querySupplierPlants:(NSString *)SupplierSupplierID HadRelativeSize:(NSNumber *)hadRelativeSize
{
    // remove all annoations
    [overlayMapView removeAnnotations:[overlayMapView annotations]];
    [self dropSingleSupplierPinForSupplierID:SupplierSupplierID HadRelativeSize:hadRelativeSize];

    [dataService getPlantSupplierVolumeForLocation:SupplierSupplierID OfType:1 :^
     {
         NSLog(@"Plants Retrieved: %lu", (unsigned long)dataService.plantSupplierItems.count);
         [self dropPlantSupplierVolumePinsForPinType:[NSNumber numberWithInteger:0]];
         
         [self ReloadDistanceChart];
         _volumeGridDelegate.DataRows = _volumeGridDelegate.SortedDataRows = dataService.plantSupplierItems;
         [_volumeGrid reload];
         
     }];
}

- (void)dropPlantSupplierVolumePinsForPinType:(NSNumber *)pinType
{
    if (dataService.plantSupplierItems != nil && dataService.plantSupplierItems.count >0)
    {
        NSLog(@"Dropping %ld pins", (unsigned long) dataService.plantSupplierItems.count);
        [self removeAllPinsFrom:overlayMapView ForBubbleType:pinType];
//        [self removeAllLinesFrom:overlayMapView];
        
        // First add lines so they are not on top
        for (PlantSupplierVolume *item in dataService.plantSupplierItems)
        {
            if (item.Latitude != 0 && item.Longitude != 0)
            {
                CLLocationCoordinate2D location = CLLocationCoordinate2DMake(item.Latitude.doubleValue, item.Longitude.doubleValue);

                NSArray *polyLinePoints = [NSArray arrayWithObjects:
                                           [[CLLocation alloc]initWithLatitude:location.latitude longitude:location.longitude],
                                           [[CLLocation alloc]initWithLatitude:_selectedLocation.latitude longitude:_selectedLocation.longitude],nil];
                
//                if (dataService.selectedProductCodeMasterItems.count>0)
//                {
                    PolyLineAnnotation *polyLineAnnotation =
                        [[PolyLineAnnotation alloc]initWithPoints:polyLinePoints mapView:overlayMapView distance:item.DistanceFromPartnerLabel];
                    [overlayMapView addAnnotation:polyLineAnnotation];
//                }
            }
        }
        
        // Now add bubbles
        for (PlantSupplierVolume *item in dataService.plantSupplierItems)
        {
            if (item.Latitude != 0 && item.Longitude != 0)
            {
                BOOL bubbleDim = NO;
                UIColor *pinColor = nil;
                
                if (pinType.intValue==0)
                    pinColor = [UIColor colorWithRed:5.0/255 green:56.0/255 blue:118.0/255 alpha:0.5];
                else
                    pinColor = [UIColor colorWithRed:1 green:160.0/255 blue:0 alpha:1.0];
                
                CLLocationCoordinate2D location = CLLocationCoordinate2DMake(item.Latitude.doubleValue, item.Longitude.doubleValue);
                
                BubbleAnnotation *bubble = [[BubbleAnnotation alloc] initWithCoordinates:location withTitle:item.Name withSubTitle:item.SupplierID withRelativeSize:item.RelativeSize withBubbleType:[NSNumber numberWithInt:pinType.intValue] withMapView:overlayMapView withColor:pinColor withDimState:bubbleDim];
                [overlayMapView addAnnotation:bubble];
            }
        }
    }
}
- (void)dropPlantPins:(NSString *)nonDimmedSupplierID
{
    if (dataService.plantTurnoverItems != nil && dataService.plantTurnoverItems.count >0)
    {
        NSLog(@"Dropping %ld plant pins", (unsigned long) dataService.plantTurnoverItems.count);
        [self removeAllPinsButUserLocationFrom:overlayMapView];
        
        
        for (PlantTurnover *plantData in dataService.plantTurnoverItems)
        {
            PlantMaster *plant = [dataService.plantMasterItems objectForKey:plantData.SupplierID];
            
            if (plant != nil && plant.Latitude.doubleValue != 0 && plant.Longitude.doubleValue != 0)
            {
                BOOL bubbleDim = YES;
                
                if (nonDimmedSupplierID==nil || [nonDimmedSupplierID isEqualToString:plant.SupplierID] )
                {
                    _selectedLocation = CLLocationCoordinate2DMake(plant.Latitude.doubleValue, plant.Longitude.doubleValue);  // will be the center of flight lines, if added
                    bubbleDim = NO;
                }
                
                CLLocationCoordinate2D location = CLLocationCoordinate2DMake(plant.Latitude.doubleValue, plant.Longitude.doubleValue);
                BubbleAnnotation *bubble = [[BubbleAnnotation alloc] initWithCoordinates:location withTitle:plant.Name withSubTitle:plant.SupplierID withRelativeSize:plantData.RelativeSize withBubbleType:[NSNumber numberWithInt:0] withMapView:overlayMapView withColor:[UIColor colorWithRed:5.0/255 green:56.0/255 blue:118.0/255 alpha:0.5] withDimState:bubbleDim];
                [overlayMapView addAnnotation:bubble];
            }
        }
    }
}


- (void)dropSingleSupplierPinForSupplierID:(NSString *)SupplierID HadRelativeSize:(NSNumber *)relativeSize
{
    if (SupplierID == nil) return;
    
    Supplier *item = [dataService.supplierItems objectForKey:SupplierID];
    
    if (item != nil)
    {
        [self removeAllPinsFrom:overlayMapView ForBubbleType:[NSNumber numberWithInt:1]];
        
        if (item.Latitude.doubleValue != 0 && item.Longitude.doubleValue != 0)
        {
            BOOL bubbleDim = NO;
            _selectedLocation = CLLocationCoordinate2DMake(item.Latitude.doubleValue, item.Longitude.doubleValue);  // will be the center of flight lines, if added

            
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake(item.Latitude.doubleValue, item.Longitude.doubleValue);
            UIColor *pinColor = [UIColor colorWithRed:1 green:160.0/255 blue:0 alpha:1.0];
            
            BubbleAnnotation *bubble = [[BubbleAnnotation alloc] initWithCoordinates:location withTitle:item.Name withSubTitle:item.SupplierID withRelativeSize:relativeSize withBubbleType:[NSNumber numberWithInt:1] withMapView:overlayMapView withColor:pinColor withDimState:bubbleDim];
            
            [overlayMapView addAnnotation:bubble];
        }
    }
}

- (void)removeAllPinsFrom:(MKMapView *)mapView ForBubbleType:(NSNumber *)bubbleType
{
    // get array of pins, and create array of pins to remove from map
    NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[mapView annotations]];
    NSMutableArray *removePins = [NSMutableArray new];
    
    // if pin is the type we're targeting, and matches metadata, add to remove list
    for (NSObject *annotation in pins)
    {
        if ([annotation isKindOfClass:[BubbleAnnotation class]])
        {
            BubbleAnnotation *bubble = (BubbleAnnotation *)annotation;
            if (bubble.bubbleType.intValue == bubbleType.intValue)
                [removePins addObject:annotation];
        }
    }
    
    // remove target list
    [mapView removeAnnotations:removePins];
}

/*
- (void)removeAllPinsFrom:(MKMapView *)mapView ForBubbleType:(NSNumber *)bubbleType
{
    // get array of pins, and create array of pins to remove from map
    NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[mapView annotations]];
    NSMutableArray *removePins = [NSMutableArray new];
    
    // if pin is the type we're targeting, and matches metadata, add to remove list
    for (NSObject *annotation in pins)
    {
        if ([annotation isKindOfClass:[BubbleAnnotation class]])
        {
            BubbleAnnotation *bubble = (BubbleAnnotation *)annotation;
            if (bubble.bubbleType.intValue == bubbleType.intValue)
                [removePins addObject:annotation];
        }
    }
    
    // remove target list
    [mapView removeAnnotations:removePins];
}
*/
- (void)removeAllLinesFrom:(MKMapView *)mapView
{
    // get array of pins, and create array of pins to remove from map
    NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[mapView annotations]];
    NSMutableArray *removePins = [NSMutableArray new];
    
    // if pin is the type we're targeting, and matches metadata, add to remove list
    for (NSObject *annotation in pins)
    {
        if (![annotation isKindOfClass:[PolyLineAnnotation class]])
        {
            [removePins addObject:annotation];
        }
    }
    
    // remove target list
    [mapView removeAnnotations:removePins];
}


- (void)removeAllPinsButUserLocationFrom:(MKMapView *)mapView
{
    id userLocation = [mapView userLocation];
    NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[mapView annotations]];
    if ( userLocation != nil ) {
        [pins removeObject:userLocation]; // avoid removing user location off the map
    }
    
    [mapView removeAnnotations:pins];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *result = nil;
    
    // only can process for the _mapView map
    if ([mapView isEqual:mapView]==NO)
    {
        return result;
    }
    
    // only can process for MyAnnotation
    if ([annotation isKindOfClass:[ImagePinAnnotation class]])
    {
        // cast the annotation to be shown
        ImagePinAnnotation *ann = (ImagePinAnnotation *)annotation;
        
        // What's the reusable identifier for pins with this base name?
        NSString *pinReusableIdentifier = [ImagePinAnnotation reusableIdentifierForPinType:ann.pinType];
        
        // Do we already have an annotation view that looks like this one?
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:pinReusableIdentifier];
        
        if (annotationView==nil)
        {
            // No, we need to create one
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:ann reuseIdentifier:pinReusableIdentifier];
            annotationView.canShowCallout = YES;
            
            UIImage *pinImage = [UIImage imageNamed:ann.pinType];
            
            if (pinImage != nil)
            {
                annotationView.image = pinImage;
            }
        }
        result = annotationView;
    }
    else if ([annotation isKindOfClass:[PolyLineAnnotation class]])
    {
        result = [[PolyLineAnnotationView alloc]initWithAnnotation:annotation mapView:mapView];
    }
    else if ([annotation isKindOfClass:[BubbleAnnotation class]])
    {
        BubbleAnnotationView *bubbleView = [[BubbleAnnotationView alloc] initWithAnnotation:annotation mapView:mapView];
        bubbleView.delegate = self;  // send me notifications if someone interacts with you, OK?
        result = bubbleView;
    }
    
    return result;
    
    // if you add QuartzCore to your project, you can set shadows for your image, too
    //
    // [annotationView.layer setShadowColor:[UIColor blackColor].CGColor];
    // [annotationView.layer setShadowOpacity:1.0f];
    // [annotationView.layer setShadowRadius:5.0f];
    // [annotationView.layer setShadowOffset:CGSizeMake(0, 0)];
    // [annotationView setBackgroundColor:[UIColor whiteColor]];
}

-(void)bubbleTapped:(NSString *)keyValue OfType:(int)PinType OfRelativeSize:(NSNumber *)relativeSize
{
    NSLog(@"Bubble was tapped: %@, pin type %d", keyValue, PinType);
    
    if (keyValue == nil)
        return;
    
    // if same bubble tapped, reset to show all plants.  If a new bubble tapped, then process filter query
    if ([keyValue isEqualToString:_selectedSupplierID])
    {
        _selectedSupplierID = keyValue;
        [self queryPlantTurnover];
    }
    else
    {
        _selectedSupplierID = keyValue;
        
        if (PinType==0)
        {
            PlantMaster *plant = [dataService.plantMasterItems objectForKey:keyValue];
            if (plant==nil)
                _selectedLocationLabel.text = keyValue;
            else
                _selectedLocationLabel.text = plant.Name;
        }
        else if (PinType==1)
        {
            Supplier *supplier = [dataService.supplierItems objectForKey:keyValue];
            if (supplier==nil)
                _selectedLocationLabel.text = keyValue;
            else
                _selectedLocationLabel.text = supplier.Name;
        }
        
            if (PinType==0)
                [self queryPlantSuppliers:keyValue];
            else
                [self querySupplierPlants:keyValue HadRelativeSize:relativeSize];
    }
    
    
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Update the page when more than 50% of the previous/next page is visible
    /*
    CGFloat pageWidth = _pageScrollView.frame.size.width;
    int page = floor((_pageScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
     */
}
/*
- (IBAction)changePage:(id)sender {
    int page = [_pageControl currentPage];
    
    [self setPage:page];
    
}

- (void) setPage:(int)page
{
    if (page==0)
    {
    }
    else if (page==1)
    {
    }
    else
    {
    }
    
}
*/
- (IBAction)exportFileTapped:(id)sender
{
    NSString *csvPath = [[self applicationDocumentsDirectory].path
                      stringByAppendingPathComponent:@"export.csv"];
    
    [self exportCsv:csvPath];
    // mail is graphical and must be run on UI thread
    [self performSelectorOnMainThread: @selector(mailFile:) withObject: csvPath waitUntilDone: NO];
}

- (void) mailFile: (NSString*) filePath
{
    // here I stop animating the UIActivityIndicator
    
    BOOL success = NO;
    if ([MFMailComposeViewController canSendMail])
    {
        // TODO: autorelease pool needed ?
        NSData* database = [NSData dataWithContentsOfFile: filePath];
        
        if (database != nil) {
            MFMailComposeViewController* picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            [picker setToRecipients:[NSArray arrayWithObject:@"robkerr@outlook.com"]];
            [picker setSubject:[NSString stringWithFormat: @"%@ %@", [[UIDevice currentDevice] model], [filePath lastPathComponent]]];
            
            NSString* filename = [filePath lastPathComponent];
            [picker addAttachmentData: database mimeType:@"application/octet-stream" fileName: filename];
            NSString* emailBody = @"Attached is the data exported from the map view.";
            [picker setMessageBody:emailBody isHTML:YES];
            
            [self presentViewController:picker animated:YES completion:nil];
            success = YES;
        }
    }
    else
    {
        NSLog(@"Device is unable to send email in its current state.");
    }
    
    if (!success) {
        UIAlertView* warning = [[UIAlertView alloc] initWithTitle: @"Error"
                                                          message: @"Unable to send attachment!"
                                                         delegate: self
                                                cancelButtonTitle: @"Ok"
                                                otherButtonTitles: nil];
        [warning show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    NSString* message = nil;
    switch(result)
    {
        case MFMailComposeResultCancelled:
            message = @"Not sent at user request.";
            break;
        case MFMailComposeResultSaved:
            message = @"Saved";
            break;
        case MFMailComposeResultSent:
            message = @"Sent";
            break;
        case MFMailComposeResultFailed:
            message = @"Error";
    }
    NSLog(@"%s %@", __PRETTY_FUNCTION__, message);
}

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

-(void) exportCsv: (NSString*) filePath
{
    NSMutableString *fileContent = [NSMutableString new];

    [fileContent appendString:[PlantSupplierVolume CsvFileHeader]];
    
    for (PlantSupplierVolume *item in dataService.plantSupplierItems)
    {
        NSString *line = [item CsvDataRow];
        [fileContent appendString:line];
    }

    [fileContent writeToFile:filePath atomically:YES
                   encoding:NSUTF8StringEncoding error:nil];

}
/*
-(void) createTempFile: (NSString*) filePath {
    NSFileManager* fileSystem = [NSFileManager defaultManager];
    [fileSystem removeItemAtPath: filePath error: nil];
    
    NSMutableDictionary* attributes = [[NSMutableDictionary alloc] init];
    NSNumber* permission = [NSNumber numberWithLong: 0640];
    [attributes setObject: permission forKey: NSFilePosixPermissions];
    if (![fileSystem createFileAtPath: filePath contents: nil attributes: attributes]) {
        NSLog(@"Unable to create temp file for exporting CSV.");
        // TODO: UIAlertView?
    }
}
*/


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)returnToMenu:(id)sender {
    
    if([_delegate respondsToSelector:@selector(childClosingItself:)])
    {
        //send the delegate function with the amount entered by the user
        [_delegate childClosingItself:1];
    }
}
@end

