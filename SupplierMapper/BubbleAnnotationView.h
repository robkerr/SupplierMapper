//
//  BubbleAnnotationView.h
//  SupplyChainPrototype
//
//  Created by Robert Kerr on 3/29/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>
#import "BubbleAnnotation.h"
#import "BubbleSubview.h"

@protocol MapAnnotationAction

@optional

-(void)bubbleTapped:(NSString *)keyValue OfType:(int)PinType OfRelativeSize:(NSNumber *)relativeSize;

@end

@interface BubbleAnnotationView : MKAnnotationView
{
    MKMapView * _mapView;
    BubbleSubview * _internalView;
}

//@property (nonatomic) CGPoint centerOffset;

@property(nonatomic,assign)id delegate;

- (id)initWithAnnotation:(BubbleAnnotation *)annotation mapView:(MKMapView *)mapView;

-(void)setDimmed: (BOOL) newDimValue;

@end
