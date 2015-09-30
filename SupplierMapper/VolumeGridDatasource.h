//
//  VolumeGridDelegate.h
//  Created by Rob Kerr on 3/25/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.

#import <Foundation/Foundation.h>
#import <ShinobiGrids/ShinobiDataGrid.h>

@interface VolumeGridDatasource : NSObject<SDataGridDataSource, SDataGridDelegate>
@property (nonatomic, strong) NSArray *DataRows;
@property (nonatomic, strong) NSArray *SortedDataRows;
@end
