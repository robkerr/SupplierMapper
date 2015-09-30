//
//  BubbleAnnotation.h
//  SupplyChainPrototype
//
//  Created by Robert Kerr on 3/29/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BubbleAnnotation : NSObject<MKAnnotation>


@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *subTitle;
@property (nonatomic, copy, readonly) NSNumber *relativeSize;
@property (nonatomic, copy, readonly) UIColor *bubbleColor;
@property (nonatomic, copy, readonly) NSNumber *bubbleType; // 0=Plant, 1=Supplier
@property (nonatomic, assign) BOOL IsDimmed;


- (instancetype) initWithCoordinates:
        (CLLocationCoordinate2D)paramCoordinates
        withTitle:(NSString *)paramTitle
        withSubTitle:(NSString *)paramSubTitle
        withRelativeSize:(NSNumber *)paramRelativeSize
        withBubbleType:(NSNumber *)paramBubbleType
        withMapView:(MKMapView *)paramMapView
        withColor:(UIColor *)paramBubbleColor
        withDimState:(BOOL) paramDimState;

@end
