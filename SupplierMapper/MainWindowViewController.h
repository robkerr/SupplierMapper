//
//  MainWindowViewController.h
//  Created by Rob Kerr on 3/25/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.

#import <UIKit/UIKit.h>
#import "MyProtocols.h"

@class MapOverlayViewController;
@class CarouselViewController;

@interface MainWindowViewController : UIViewController <EmbeddedSceenDelegate>

@property (strong, nonatomic) MapOverlayViewController *posTrendsViewController;
@property (strong, nonatomic) CarouselViewController *carouselViewController;

@end
