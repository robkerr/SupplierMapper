//
//  POSTrendsViewController.h
//  Created by Rob Kerr on 3/25/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>

#import <ShinobiCharts/ShinobiChart.h>
#import <ShinobiEssentials/SEssentialsSlidingOverlayDelegate.h>
#import <ShinobiGrids/ShinobiDataGrid.h>
#import <ShinobiCharts/ShinobiChart.h>

#import "UnderlayViewController.h"
#import "BubbleAnnotationView.h"


@interface MapOverlayViewController : UIViewController <UnderlayMenuDelegate, MapAnnotationAction, SEssentialsSlidingOverlayDelegate, MKMapViewDelegate, UIScrollViewDelegate, MFMailComposeViewControllerDelegate> {

}

@property(nonatomic,assign)id delegate;


@end
