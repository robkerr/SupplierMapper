//
//  PolyLineAnnotationView.h
//  Created by Rob Kerr on 3/25/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.

#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>
#import "PolyLineAnnotation.h"

@interface PolyLineAnnotationView : MKAnnotationView
{
    MKMapView * _mapView;
    UIView * _internalView;
}

@property (nonatomic) CGPoint centerOffset;

- (id)initWithAnnotation:(PolyLineAnnotation *)annotation mapView:(MKMapView *)mapView;

@end
