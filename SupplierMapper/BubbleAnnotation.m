//
//  BubbleAnnotation.m
//  SupplyChainPrototype
//
//  Created by Robert Kerr on 3/29/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.
//

#import "BubbleAnnotation.h"

@implementation BubbleAnnotation

- (instancetype) initWithCoordinates:
(CLLocationCoordinate2D)paramCoordinates
                           withTitle:(NSString *)paramTitle
                        withSubTitle:(NSString *)paramSubTitle
                    withRelativeSize:(NSNumber *)paramRelativeSize
                    withBubbleType:(NSNumber *)paramBubbleType
                        withMapView:(MKMapView *)paramMapView
                        withColor:(UIColor *)paramBubbleColor
                        withDimState:(BOOL) paramDimState
{
    self = [super init];
    
    if (self != nil)
    {
        _coordinate = paramCoordinates;
        _title = paramTitle;
        _subTitle = paramSubTitle;
        _relativeSize = paramRelativeSize;
        _bubbleType = paramBubbleType;
        _bubbleColor = paramBubbleColor;
        _IsDimmed = paramDimState;
    }
    
    return self;
}

@end
