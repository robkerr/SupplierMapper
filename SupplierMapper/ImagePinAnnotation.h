//
//  MyAnnotation.h
//  PinPaths
//
//  Created by Rob Kerr on 3/25/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

extern NSString *const kReusablePinCar;
extern NSString *const kReusablePinBuilding;

@interface ImagePinAnnotation:  NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *subTitle;


@property (nonatomic, unsafe_unretained) NSString *pinType;

- (instancetype) initWithCoordinates: (CLLocationCoordinate2D)paramCoordinates withTitle:(NSString *)paramTitle withSubTitle:(NSString *)paramSubTitle;

+ (NSString *) reusableIdentifierForPinType: (NSString *)pinType;

@end
