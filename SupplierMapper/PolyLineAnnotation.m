//
//  PolyLineAnnotation.m
//  Created by Rob Kerr on 3/25/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.

#import "PolyLineAnnotation.h"

@implementation PolyLineAnnotation

-(id) initWithPoints:(NSArray*) points mapView:(MKMapView *)mapView distance:(NSString *)distanceLabel
{
    self = [super init];
    _points = [[NSArray alloc] initWithArray:points];
    _mapView = mapView;
    _distanceLabel = distanceLabel;
    return self;
}
- (CLLocationCoordinate2D) coordinate
{
    return [_mapView centerCoordinate];
}

@end
