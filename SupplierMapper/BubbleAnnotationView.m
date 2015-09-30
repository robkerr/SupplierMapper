//
//  BubbleAnnotationView.m
//  SupplyChainPrototype
//
//  Created by Robert Kerr on 3/29/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.
//

#import "BubbleAnnotationView.h"
#import "BubbleSubview.h"



@implementation BubbleAnnotationView
{
    BOOL isTouchDown;
}

//@synthesize centerOffset = _centerOffset;

- (id)initWithAnnotation:(BubbleAnnotation *)annotation mapView:(MKMapView *)mapView
{
    if (self = [super init]) {
        
        self.annotation = annotation;
        _mapView = mapView;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        //self.frame = CGRectMake(0.0, 0.0, _mapView.frame.size.width, _mapView.frame.size.height);
        
        
        float bubbleSize = 20.0 + (annotation.relativeSize.floatValue * 50.0);
        
        self.frame = CGRectMake(0, 0, bubbleSize, bubbleSize);
        
        _internalView = [[BubbleSubview alloc] initWithBubbleView:self mapView:_mapView relativeSize:[NSNumber numberWithFloat:0.5] bubbleType:annotation.bubbleType bubbleColor:annotation.bubbleColor isDimmed:annotation.IsDimmed];
        _internalView.frame = self.frame;
        [self addSubview:_internalView];
    }
    return self;
    
}

-(void)setDimmed: (BOOL) newDimValue
{
    _internalView.IsDimmed = newDimValue;  // set new value
    [_internalView setNeedsDisplay];        // tell it that it needs to be redisplayed
}
/*
-(void) regionChanged
{
    BubbleAnnotation* annotation = (BubbleAnnotation *)self.annotation;
    CGPoint point = [_mapView convertCoordinate:annotation.coordinate toPointToView:_mapView];
    _internalView.frame = CGRectMake(point.x - 100, point.y - 100, 200, 200);
    [_internalView setNeedsDisplay];
}
*/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    isTouchDown = YES;
    _internalView.BubbleColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.5];
    [_internalView setNeedsDisplay];
//    self.backgroundColor = [UIColor redColor];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Triggered when touch is released
    if (isTouchDown)
    {
        //_internalView.BubbleColor = [UIColor colorWithRed:5.0/255 green:56.0/255 blue:118.0/255 alpha:0.5];
        _internalView.BubbleColor = _internalView.BubbleColor;
        _internalView.IsDimmed = NO;
        [_internalView setNeedsDisplay];
        isTouchDown = NO;
        
        if (self.annotation != nil && [self.annotation isKindOfClass:[BubbleAnnotation class]])
        {
            BubbleAnnotation *annotation = (BubbleAnnotation *) self.annotation;
            [self.delegate bubbleTapped:annotation.subTitle OfType:annotation.bubbleType.intValue OfRelativeSize:annotation.relativeSize];
            
        }
        /*
        [_internalView resignFirstResponder];
        [self resignFirstResponder];
         */
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Triggered if touch leaves view
    if (isTouchDown)
    {
        //_internalView.BubbleColor = [UIColor colorWithRed:5.0/255 green:56.0/255 blue:118.0/255 alpha:0.5];
        _internalView.BubbleColor = _internalView.BubbleColor;
        _internalView.IsDimmed = YES;

        [_internalView setNeedsDisplay];
        isTouchDown = NO;
    }
}

/*
- (CGPoint) centerOffset
{
    [self regionChanged];
    return [super centerOffset];
}
- (void) setCenterOffset:(CGPoint) centerOffset {
        _centerOffset = centerOffset;
    //[super setCenterOffset:centerOffset];
}
*/



@end
