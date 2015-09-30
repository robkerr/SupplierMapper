//
//  PolyLineAnnotationView.m
//  Created by Rob Kerr on 3/25/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.

#import "PolyLineAnnotationView.h"

const CGFloat POLYLINE_WIDTH = 2.0;

@interface InternalAnnotationView : UIView
{
    PolyLineAnnotationView* _polylineView;
    MKMapView *_mapView;
}

- (id) initWithPolylineView:(PolyLineAnnotationView *)polylineView
                    mapView:(MKMapView *)mapView;
@end

@implementation InternalAnnotationView



- (id) initWithPolylineView:(PolyLineAnnotationView *)polylineView
                    mapView:(MKMapView *)mapView
{
    if (self = [super init]){
        _polylineView = polylineView;
        _mapView = mapView;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
    }
    
    return self;
}
-(void) drawRect:(CGRect)rect
{
    
    PolyLineAnnotation* annotation = (PolyLineAnnotation*)_polylineView.annotation;
    if (annotation.points && annotation.points.count > 0)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        UIColor *blueColor = [UIColor colorWithRed:5.0/255 green:56.0/255 blue:118.0/255 alpha:0.5];
        
        CGContextSetStrokeColorWithColor(context, blueColor.CGColor);
        CGContextSetRGBFillColor(context, 5.0/255, 56.0/255, 118.0/255, 0.5);
        CGContextSetAlpha(context, 0.5);
        
        CGContextSetLineWidth(context, POLYLINE_WIDTH);
        
        for (int i = 0; i < annotation.points.count; i++) {
            CLLocation* location = [annotation.points objectAtIndex:i];
            CGPoint point = [_mapView convertCoordinate:location.coordinate toPointToView:self];
            
            if (i == 0)
                CGContextMoveToPoint(context, point.x, point.y);
            else
                CGContextAddLineToPoint(context, point.x, point.y);
        }
        
        CGContextStrokePath(context);
        /*
        CGRect rcText = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setAlignment:NSTextAlignmentCenter];
        NSDictionary *attr = [NSDictionary dictionaryWithObject:style forKey:NSParagraphStyleAttributeName];
        [annotation.distanceLabel drawInRect:rcText withAttributes:attr];
        */
        
    }
}
@end


@implementation PolyLineAnnotationView



- (id)initWithAnnotation:(PolyLineAnnotation *)annotation
                 mapView:(MKMapView *)mapView
{
    if (self = [super init]) {
        
        self.annotation = annotation;
        _mapView = mapView;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        self.frame = CGRectMake(0.0, 0.0, _mapView.frame.size.width, _mapView.frame.size.height);
        
        _internalView = [[InternalAnnotationView alloc] initWithPolylineView:self mapView:_mapView];
        [self addSubview:_internalView];
    }
    return self;
}
-(void) regionChanged
{
    PolyLineAnnotation* annotation = (PolyLineAnnotation *)self.annotation;
    CGPoint minpt, maxpt;
    for (int i = 0; i < annotation.points.count; i++)
    {
        CLLocation* location = [annotation.points objectAtIndex:i];
        CGPoint point = [_mapView convertCoordinate:location.coordinate toPointToView:_mapView];
        if (point.x < minpt.x || i == 0)
            minpt.x = point.x;
        if (point.y < minpt.y || i == 0)
            minpt.y = point.y;
        if (point.x > maxpt.x || i == 0)
            maxpt.x = point.x;
        if (point.y > maxpt.y || i == 0)
            maxpt.y = point.y;
    }
    
    CGFloat w = maxpt.x - minpt.x + (2*POLYLINE_WIDTH);
    CGFloat h = maxpt.y - minpt.y + (2*POLYLINE_WIDTH);
    
    _internalView.frame = CGRectMake(minpt.x - POLYLINE_WIDTH, minpt.y - POLYLINE_WIDTH,
                                     w, h);
    [_internalView setNeedsDisplay];
}
- (CGPoint) centerOffset
{
    [self regionChanged];
    return [super centerOffset];
}
- (void) setCenterOffset:(CGPoint) centerOffset {

    [super setCenterOffset:centerOffset];
}
@end
