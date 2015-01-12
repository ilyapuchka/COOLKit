//
//  COOLInjectTableViewDataSourceDelegate.h
//  COOLKit
//
//  Created by Ilya Puchka on 02.01.15.
//  Copyright (c) 2015 Ilya Puchka. All rights reserved.
//

#import "COOLWrappedTableViewDataSourceDelegate.h"

extern NSInteger const COOLAutomaticOffset;

//- tableView:numberOfRowsInSection: is ignored and never called on this data source
//indexPaths passed to this data source will always have section equal to 1
//so you beter organize data in this data source in one dimentional array
@protocol COOLTableViewInjectDataSource <COOLTableViewDataSourceDelegate>

///Return number of rows from top of table view to inject first cell.
- (NSInteger)tableViewInjectOffset:(UITableView *)tableView;

///Return number of rows between injected cells. This value is preserved on sections change.
- (NSInteger)tableViewInjectStep:(UITableView *)tableView;

@end

/**
 Class for injecting data from one data source (injectDataSource) into another data source with offset from top of table view and step.
 */
@interface COOLInjectedTableViewDataSourceDelegate : COOLWrappedTableViewDataSourceDelegate

- (instancetype)initWithDataSource:(id<COOLTableViewDataSourceDelegate>)dataSource
                injectedDataSource:(id<COOLTableViewInjectDataSource>)injectedDataSource;

@property (nonatomic, strong) id<COOLTableViewDataSourceDelegate> dataSource;
@property (nonatomic, strong) id<COOLTableViewInjectDataSource> injectedDataSource;

@property (nonatomic) NSInteger sectionsCount;

@end
