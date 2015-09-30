//
//  PolyLineAnnotation.h
//  Created by Rob Kerr on 3/25/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PolyLineAnnotation : NSObject <MKAnnotation>
{
    NSArray* _points;
    MKMapView* _mapView;
}

-(id) initWithPoints:(NSArray*) points mapView:(MKMapView *)mapView distance:(NSString *)distanceLabel;
@property (nonatomic, retain) NSArray* points;
@property (nonatomic, copy, readonly) NSString *distanceLabel;

@end
