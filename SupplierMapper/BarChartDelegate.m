//
//  BarChartDelegate.m
//  SupplyChainPrototype
//
//  Created by Robert Kerr on 3/29/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.
//

#import "BarChartDelegate.h"
#import "GenericDataPoint.h"

@implementation BarChartDelegate




-(NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 1;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index
{
    SChartColumnSeries *s = [SChartColumnSeries new];
    s.style.areaColor = [UIColor blueColor];
    s.title = @"Distance (miles)";
    return s;
}

- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex
{
    if (_DataPoints != nil)
        return _DataPoints.count;
    else
        return 0;
}

-(void)sChart:(ShinobiChart *)chart alterTickMark:(SChartTickMark *)tickMark beforeAddingToAxis:(SChartAxis *)axis
{
}
/*
-(SChartAxis *)sChart:(ShinobiChart *)chart yAxisForSeriesAtIndex:(NSInteger)index {
     if (index==1)
     return _trendChart.allYAxes[0];
     else
     return _trendChart.allYAxes[1];

    return _trendChart.allYAxes[index];
}
*/
- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {

    SChartDataPoint *datapoint = [SChartDataPoint new];

    if (_DataPoints != nil && _DataPoints.count > dataIndex)
    {
        GenericDataPoint *pt = [self.DataPoints objectAtIndex:dataIndex];
        datapoint.xValue = pt.Label;
        datapoint.yValue = pt.Value1;
    }
    
    return datapoint;
}


@end
