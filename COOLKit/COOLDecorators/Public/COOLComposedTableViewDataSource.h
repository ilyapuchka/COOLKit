//
//  COOLComposedTableViewDataSource.h
//  CoolEvents
//
//  Created by Ilya Puchka on 16.11.14.
//  Copyright (c) 2014 CoolConnections. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "COOLComposition.h"
#import "COOLTableViewDisplayDataSource.h"
#import "COOLTableViewDelegatingWrapper.h"

typedef void(^COOLBlockOnTableViewInSection)(id<UITableViewDataSourceDelegate> dataSource, UITableView *tableView, NSInteger _section);

typedef id(^COOLReturnBlockOnTableViewInSection)(id<UITableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSInteger _section);

typedef void(^COOLBlockOnTableViewAtIndexPath)(id<UITableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSIndexPath *_indexPath);

typedef id(^COOLReturnBlockOnTableViewAtIndexPath)(id<UITableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSIndexPath *_indexPath);

typedef void(^COOLBlockOnTableViewFromIndexPathToIndexPath)(id<UITableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSIndexPath *_fromIndexPath, NSIndexPath *_toIndexPath);

typedef id(^COOLReturnBlockOnTableViewFromIndexPathToIndexPath)(id<UITableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSIndexPath *_fromIndexPath, NSIndexPath *_toIndexPath);

/*
 Implements following methods:
    -numberOfSectionsInTableView:
    -tableView:numberOfRowsInSection:
    -tableView:cellForRowAtIndexPath:
    -tableView:didSelectRowAtIndexPath:
 
 Subclasses should implement other methods using -perform... or -performAndReturn... for other UITableViewDelegate/UITableViewDataSource methods if needed.
 */
@interface COOLComposedTableViewDataSource : NSObject <UITableViewDataSourceDelegate, COOLTableViewDisplayDataSource> {
    id<COOLComposition> _dataSources;
    NSArray *_objects;
}

//dataSources should be either COOLTableViewDelegatingWrapper or UITableViewDataSourceDelegate
- (instancetype)initWithDataSources:(NSArray *)dataSources NS_DESIGNATED_INITIALIZER;

- (void)addDataSource:(id)dataSource;
- (void)removeDataSource:(id)dataSource;

- (id<UITableViewDataSourceDelegate>)tableViewDataSourceForSection:(NSInteger)section;
- (id<UITableViewDataSourceDelegate>)tableViewDataSourceForIndexPath:(NSIndexPath *)indexPath;

/*
 Helper methods for subclasses. Provides block with dataSource for passed section.
 Usage:
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     return [self performAndReturnOnTableView:tableView atIndexPath:indexPath block:^id(id<UITableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSIndexPath *_indexPath) {
         return [_dataSource tableView:_tableView cellForRowAtIndexPath:_indexPath];
     }];
 }
*/
- (void)performOnTableView:(UITableView *)tableView
                 inSection:(NSInteger)section
                     block:(COOLBlockOnTableViewInSection)block;

- (id)performAndReturnOnTableView:(UITableView *)tableView
                        inSection:(NSInteger)section
                            block:(COOLReturnBlockOnTableViewInSection)block;

- (void)performOnTableView:(UITableView *)tableView
               atIndexPath:(NSIndexPath *)indexPath
                     block:(COOLBlockOnTableViewAtIndexPath)block;

- (id)performAndReturnOnTableView:(UITableView *)tableView
                      atIndexPath:(NSIndexPath *)indexPath
                            block:(COOLReturnBlockOnTableViewAtIndexPath)block;

- (void)performOnTableView:(UITableView *)tableView
             fromIndexPath:(NSIndexPath *)fromIndexPath
               toIndexPath:(NSIndexPath *)toIndexPath
                     block:(COOLBlockOnTableViewFromIndexPathToIndexPath)block;

- (id)performAndReturnOnTableView:(UITableView *)tableView
                    fromIndexPath:(NSIndexPath *)fromIndexPath
                      toIndexPath:(NSIndexPath *)toIndexPath
                            block:(COOLReturnBlockOnTableViewFromIndexPathToIndexPath)block;

@end
