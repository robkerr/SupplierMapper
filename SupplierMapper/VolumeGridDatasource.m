//
//  VolumeGridDelegate.m
//  Created by Rob Kerr on 3/25/14.
//  Copyright (c) 2014 Robert Kerr. All rights reserved.

#import "VolumeGridDatasource.h"
#import "PlantSupplierVolume.h"

@implementation VolumeGridDatasource


/**************************************************************************************************
 *
 *  Callback to return the number of rows to draw in the UI
 *
 **************************************************************************************************/
-(NSUInteger)shinobiDataGrid:(ShinobiDataGrid *)grid numberOfRowsInSection:(NSInteger) sectionIndex
{
    return  [_SortedDataRows count];
}

/**************************************************************************************************
 *
 *  Callback to draw individual cell in the UI
 *
 **************************************************************************************************/
- (void)shinobiDataGrid:(ShinobiDataGrid *)grid prepareCellForDisplay:(SDataGridCell *)cell
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"#,##0"];

    NSNumberFormatter *priceNumberFormatter = [[NSNumberFormatter alloc] init];
    [priceNumberFormatter setPositiveFormat:@"$#,##0.00"];

    // both columns use a SDataGridTextCell, so we are safe to perform this cast
    SDataGridTextCell* textCell = (SDataGridTextCell*)cell;
    PlantSupplierVolume *row = [_SortedDataRows objectAtIndex:cell.coordinate.row.rowIndex];
    
    if (row != nil)
    {
        switch (cell.coordinate.column.displayIndex)
        {
            case 0: textCell.text = row.SupplierID; break;
            case 1: textCell.text = row.Name; break;
            case 2: textCell.text = row.LocationText; break;
            case 3: textCell.text = [numberFormatter stringFromNumber:row.DistanceFromPartnerMiles]; break;
            case 4: textCell.text = [numberFormatter stringFromNumber:row.Turnover]; break;
            case 5: textCell.text = [numberFormatter stringFromNumber:row.VehCumUsage]; break;
            case 6: textCell.text = [numberFormatter stringFromNumber:row.AnnualizedVolume]; break;
            case 7: textCell.text = [priceNumberFormatter stringFromNumber:row.AvgPiecePrice]; break;
        }
    }
}

/**************************************************************************************************
 *
 *  User changing sort order
 *
 **************************************************************************************************/
- (void)shinobiDataGrid:(ShinobiDataGrid *)grid didChangeSortOrderForColumn:(SDataGridColumn *)column
                   from:(SDataGridColumnSortOrder)oldSortOrder
{
    if ([column.title isEqualToString:@"SupplierID"])
    {
        _SortedDataRows = [_DataRows sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
        {
            id valueOne = [obj1 SupplierID];
            id valueTwo = [obj2 SupplierID];
            NSComparisonResult result = [valueOne compare:valueTwo];
            return column.sortOrder == SDataGridColumnSortOrderAscending ? result : -result;
        }];
    }
    else if ([column.title isEqualToString:@"Name"])
    {
        _SortedDataRows = [_DataRows sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            id valueOne = [obj1 Name];
            id valueTwo = [obj2 Name];
            NSComparisonResult result = [valueOne compare:valueTwo];
            return column.sortOrder == SDataGridColumnSortOrderAscending ? result : -result;
        }];
    }
    else if ([column.title isEqualToString:@"Location"])
    {
        _SortedDataRows = [_DataRows sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            id valueOne = [obj1 LocationText];
            id valueTwo = [obj2 LocationText];
            NSComparisonResult result = [valueOne compare:valueTwo];
            return column.sortOrder == SDataGridColumnSortOrderAscending ? result : -result;
        }];
    }
    else if ([column.title isEqualToString:@"Distance"])
    {
        _SortedDataRows = [_DataRows sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSNumber *valueOne = [obj1 DistanceFromPartnerMiles];
            NSNumber *valueTwo = [obj2 DistanceFromPartnerMiles];
            NSComparisonResult result = [valueOne compare:valueTwo];
            return column.sortOrder == SDataGridColumnSortOrderAscending ? result : -result;
        }];
    }
    else if ([column.title isEqualToString:@"Turnover"])
    {
        _SortedDataRows = [_DataRows sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSNumber *valueOne = [obj1 Turnover];
            NSNumber *valueTwo = [obj2 Turnover];
            NSComparisonResult result = [valueOne compare:valueTwo];
            return column.sortOrder == SDataGridColumnSortOrderAscending ? result : -result;
        }];
    }
    else if ([column.title isEqualToString:@"Usage"])
    {
        _SortedDataRows = [_DataRows sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSNumber *valueOne = [obj1 VehCumUsage];
            NSNumber *valueTwo = [obj2 VehCumUsage];
            NSComparisonResult result = [valueOne compare:valueTwo];
            return column.sortOrder == SDataGridColumnSortOrderAscending ? result : -result;
        }];
    }
    else if ([column.title isEqualToString:@"Volume"])
    {
        _SortedDataRows = [_DataRows sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSNumber *valueOne = [obj1 AnnualizedVolume];
            NSNumber *valueTwo = [obj2 AnnualizedVolume];
            NSComparisonResult result = [valueOne compare:valueTwo];
            return column.sortOrder == SDataGridColumnSortOrderAscending ? result : -result;
        }];
    }
    else if ([column.title isEqualToString:@"Avg Price"])
    {
        _SortedDataRows = [_DataRows sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSNumber *valueOne = [obj1 AvgPiecePrice];
            NSNumber *valueTwo = [obj2 AvgPiecePrice];
            NSComparisonResult result = [valueOne compare:valueTwo];
            return column.sortOrder == SDataGridColumnSortOrderAscending ? result : -result;
        }];
    }
    
    
    
    
    
    // inform the grid that it should re-load the data
    [grid reload];
}


@end
