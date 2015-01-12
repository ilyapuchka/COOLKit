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
 -tableView:numberOfRowsInSection: //returns 0
 -tableView:cellForRowAtIndexPath:
 -tableView:didSelectRowAtIndexPath:
 
 If you need to implement other UITableViewDelegate/UITableViewDataSource methods you should sublcass this class and implement these methods using -perform... or -performAndReturn...
 
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

//subclasses should override next two methods, base implementation returns nil
- (id<COOLTableViewDataSourceDelegate>)tableViewDataSourceForSection:(NSInteger)section;
- (id<COOLTableViewDataSourceDelegate>)tableViewDataSourceForIndexPath:(NSIndexPath *)indexPath;

//calls -tableViewDataSourceForSection
- (id<COOLTableViewDisplayDataSource>)tableViewDisplayDataSourceForSection:(NSInteger)section;
//calls -tableViewDataSourceForIndexPath
- (id<COOLTableViewDisplayDataSource>)tableViewDisplayDataSourceForIndexPath:(NSIndexPath *)indexPath;

@end

/*
 Contains helper methods for subclasses. Provide blocks with dataSource for passed section or indexPath, table view wrapper and recalculated section or indexPath.
 Usage:
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 return [self performAndReturnOnTableView:tableView atIndexPath:indexPath block:^id(id<COOLTableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSIndexPath *_indexPath) {
 return [_dataSource tableView:_tableView cellForRowAtIndexPath:_indexPath];
 }];
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
