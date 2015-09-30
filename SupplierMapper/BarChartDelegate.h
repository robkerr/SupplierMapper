//
//  BarChartDelegate.h
//  SupplyChainPrototype
//
//  Created by Robert Kerr on 3/29/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShinobiCharts/ShinobiChart.h>

@interface BarChartDelegate : NSObject<SChartDelegate, SChartDatasource>
@property (nonatomic, strong) NSArray *DataPoints;
@end
