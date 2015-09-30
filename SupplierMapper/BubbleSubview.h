//
//  BubbleSubview.h
//  SupplyChainPrototype
//
//  Created by Robert Kerr on 3/29/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class BubbleAnnotationView;

@interface BubbleSubview : UIView

@property (nonatomic, strong) UIColor *BubbleColor;
@property (nonatomic, strong) NSNumber *BubbleType;
@property (nonatomic, assign) BOOL IsDimmed;

- (id) initWithBubbleView:(BubbleAnnotationView *)bubbleView
                  mapView:(MKMapView *)mapView relativeSize:(NSNumber *)relativeSize bubbleType:(NSNumber *)bubbleType bubbleColor:(UIColor *)bubbleColor isDimmed:(BOOL)isDimmed;

@end
