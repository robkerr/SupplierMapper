//
//  MyAnnotation.m
//  PinPaths
//
//  Created by Rob Kerr on 3/25/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.
//

#import "ImagePinAnnotation.h"

NSString *const kReusablePinCar = @"Car";
NSString *const kReusablePinBuilding = @"Building";


@implementation ImagePinAnnotation

- (instancetype) initWithCoordinates: (CLLocationCoordinate2D)paramCoordinates withTitle:(NSString *)paramTitle withSubTitle:(NSString *)paramSubTitle
{
    self = [super init];
    
    if (self != nil)
    {
        _coordinate = paramCoordinates;
        _title = paramTitle;
        _subTitle = paramSubTitle;
        _pinType = kReusablePinBuilding;
    }
    
    return self;
}

+ (NSString *) reusableIdentifierForPinType: (NSString *)pinType
{
    if ([pinType isEqualToString:kReusablePinBuilding])
        return kReusablePinBuilding;
    else
        return kReusablePinCar;
}


@end
