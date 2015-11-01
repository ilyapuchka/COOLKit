//
//  COOLWrappedTableViewDataSourceDelegate.h
//  COOLKit
//
//  Created by Ilya Puchka on 01.01.15.
//  Copyright (c) 2015 Ilya Puchka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "COOLTableViewDisplayDataSource.h"
#import "COOLTableViewWrapper.h"
#import "COOLTableViewDataSourceDelegate.h"

typedef void(^COOLBlockOnTableViewInSection)(id<COOLTableViewDataSourceDelegate> _dataSource,
                                             UITableView *_tableView,
                                             NSInteger _section,
                                             id *result);

typedef void(^COOLBlockOnTableViewAtIndexPath)(id<COOLTableViewDataSourceDelegate> _dataSource,
                                               UITableView *_tableView,
                                               NSIndexPath *_indexPath,
                                               id *result);

typedef void(^COOLBlockOnTableViewFromIndexPathToIndexPath)(id<COOLTableViewDataSourceDelegate> _dataSource,
                                                            UITableView *_tableView,
                                                            NSIndexPath *_fromIndexPath,
                                                            NSIndexPath *_toIndexPath,
                                                            id *result);

/*
 Class for wrapping number of table view data sources and delegates.
 
 Implements following methods:
 -tableView:numberOfRowsInSection: //calls -tableView:numberOfRowsInSection: on particular data source
 -tableView:cellForRowAtIndexPath: //calls -tableView:cellForRowAtIndexPath: on particular data source
 -tableView:didSelectRowAtIndexPath: //calls -tableView:didSelectRowAtIndexPath: on particular delegate
 
 If you need to implement other UITableViewDelegate/UITableViewDataSource methods you should sublcass this class and implement methods you need.
 @see COOLWrappedTableViewDataSourceDelegate(PerformOnTableView)
 
 */
@interface COOLWrappedTableViewDataSourceDelegate : NSObject <COOLTableViewDataSourceDelegate>

- (void)updateMappingsWithTableView:(UITableView *)tableView;

//Methods for subclasses

//Return table view wrapper for section. Wrapper contains indexPath's mapping.
- (COOLTableViewWrapper *)wrapperForTableView:(UITableView *)tableView section:(NSInteger)section;

//Return table view wrapper for indexPath. Wrapper contains indexPath's mapping.
- (COOLTableViewWrapper *)wrapperForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (id<COOLIndexPathsMapping>)mappingForSection:(NSInteger)section;
- (id<COOLIndexPathsMapping>)mappingForIndexPath:(NSIndexPath *)indexPath;

//subclasses should override next two methods, base implementation raises exception
- (id<COOLTableViewDataSourceDelegate>)tableViewDataSourceForSection:(NSInteger)section;
- (id<COOLTableViewDataSourceDelegate>)tableViewDataSourceForIndexPath:(NSIndexPath *)indexPath;

//calls -tableViewDataSourceForSection
- (id<COOLTableViewDisplayDataSource>)tableViewDisplayDataSourceForSection:(NSInteger)section;
//calls -tableViewDataSourceForIndexPath
- (id<COOLTableViewDisplayDataSource>)tableViewDisplayDataSourceForIndexPath:(NSIndexPath *)indexPath;

@end

/*
 Contains helper methods for subclasses. Provide blocks with dataSource for passed section or indexPath, table view wrapper and recalculated section or indexPath.
 
 You use -perfromOnTableView:... to create a context to use table view data source or delegate objects, contained by composed data source. UITableView object passed to the block is a wrapper for actual table view. id<COOLTableViewDataSourceDelegate> passed to the block is a particular data source/delegate object from composition that corresponds to current section or index path. Index path or section passed to the block is calculated based on current indexPath/section but in context of particular data source/delegate.
 
 @see COOLTableViewWrapper
 
 Usage:
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     UITableViewCell *cell;
     [self performOnTableView:tableView atIndexPath:indexPath block:^void(id<COOLTableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSIndexPath *_indexPath, __autoreleasing id *result) {
     *result = [_dataSource tableView:_tableView cellForRowAtIndexPath:_indexPath];
     } result:&cell];
     return cell;
 }
 */
@interface COOLWrappedTableViewDataSourceDelegate(PerformOnTableView)

- (void)performOnTableView:(UITableView *)tableView
                 inSection:(NSInteger)section
                     block:(COOLBlockOnTableViewInSection)block
                    result:(id *)result;

- (void)performOnTableView:(UITableView *)tableView
               atIndexPath:(NSIndexPath *)indexPath
                     block:(COOLBlockOnTableViewAtIndexPath)block
                    result:(id *)result;

- (void)performOnTableView:(UITableView *)tableView
             fromIndexPath:(NSIndexPath *)fromIndexPath
               toIndexPath:(NSIndexPath *)toIndexPath
                     block:(COOLBlockOnTableViewFromIndexPathToIndexPath)block
                    result:(id *)result;

@end
