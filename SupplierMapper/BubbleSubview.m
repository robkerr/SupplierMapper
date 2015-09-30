//
//  BubbleSubview.m
//  SupplyChainPrototype
//
//  Created by Robert Kerr on 3/29/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.
//
#import "BubbleAnnotationView.h"
#import "BubbleSubview.h"

@interface BubbleSubview()
{
    BubbleAnnotationView* _bubbleView;
    MKMapView *_mapView;
    NSNumber *_relativeSize;
}

@end

@implementation BubbleSubview
- (id) initWithBubbleView:(BubbleAnnotationView *)bubbleView
                  mapView:(MKMapView *)mapView relativeSize:(NSNumber *)relativeSize bubbleType:(NSNumber *)bubbleType bubbleColor:(UIColor *)bubbleColor isDimmed:(BOOL)isDimmed
{
    if (self = [super init]){
        _bubbleView = bubbleView;
        _mapView = mapView;
        _relativeSize = relativeSize;
        _IsDimmed = isDimmed;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        _BubbleType = bubbleType;
        
        _BubbleColor = bubbleColor;
    }
    
    return self;
}
-(void) drawRect:(CGRect)rect
{
    BubbleAnnotation* annotation = (BubbleAnnotation*)_bubbleView.annotation;
    if (annotation.relativeSize > 0)
    {
        CGFloat lineWidth = 2;
        CGRect borderRect = CGRectInset(rect, lineWidth * 0.5, lineWidth * 0.5);
        CGPoint point;
        point.x = self.bounds.origin.x + self.bounds.size.width/2;
        point.y = self.bounds.origin.y + self.bounds.size.height/2;
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        const CGFloat* components = CGColorGetComponents(_BubbleColor.CGColor);
        
        float alphaBorder, alphaFill;
        if (self.IsDimmed)
        {
            alphaBorder = 0.4;
            alphaFill = 0.1;
        }
        else
        {
            alphaBorder = 1.0;
            alphaFill = 0.5;
        }
        
        UIColor *clrBorder = [UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:alphaBorder];
        UIColor *clrFill = [UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:alphaFill];
        
        CGContextSetStrokeColorWithColor(context, clrBorder.CGColor);
        CGContextSetFillColorWithColor(context, clrFill.CGColor);
        CGContextSetLineWidth(context, 2.0);
        
        //        CGRect circle = CGRectMake(point.x/2,point.y-point.x/2,point.x,point.x);
        //        CGContextAddEllipseInRect(context, circle);
        
        CGContextFillEllipseInRect (context, borderRect);
        CGContextStrokeEllipseInRect(context, borderRect);
        
        CGContextStrokePath(context);
    }
}

@end
