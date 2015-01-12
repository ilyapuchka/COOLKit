//
//  COOLWrappedTableViewDataSourceDelegate.m
//  COOLKit
//
//  Created by Ilya Puchka on 01.01.15.
//  Copyright (c) 2015 Ilya Puchka. All rights reserved.
//

#import "COOLWrappedTableViewDataSourceDelegate.h"
#import "COOLTableViewWrapper.h"

@interface COOLWrappedTableViewDataSourceDelegate()

@end

@implementation COOLWrappedTableViewDataSourceDelegate

- (id<COOLTableViewDataSourceDelegate>)tableViewDataSourceForSection:(NSInteger)section
{
    return nil;
}

- (id<COOLTableViewDataSourceDelegate>)tableViewDataSourceForIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (id<COOLTableViewDisplayDataSource>)tableViewDisplayDataSourceForSection:(NSInteger)section
{
    return [self tableViewDataSourceForSection:section];
}

- (id<COOLTableViewDisplayDataSource>)tableViewDisplayDataSourceForIndexPath:(NSIndexPath *)indexPath
{
    return [self tableViewDisplayDataSourceForSection:indexPath.section];
}

- (COOLTableViewWrapper *)wrapperForTableView:(UITableView *)tableView section:(NSInteger)section
{
    id<COOLIndexPathsMapping> mapping = [self mappingForSection:section];
    COOLTableViewWrapper *wrapper = [COOLTableViewWrapper wrapperFor:tableView];
    wrapper.indexPathsMapping = mapping;
    return wrapper;
}

- (COOLTableViewWrapper *)wrapperForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    id<COOLIndexPathsMapping> mapping = [self mappingForIndexPath:indexPath];
    COOLTableViewWrapper *wrapper = [COOLTableViewWrapper wrapperFor:tableView];
    wrapper.indexPathsMapping = mapping;
    return wrapper;
}

- (void)updateMappingsWithTableView:(UITableView *)tableView
{
}

- (id<COOLIndexPathsMapping>)mappingForSection:(NSInteger)section
{
    return nil;
}

- (id<COOLIndexPathsMapping>)mappingForIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    [self performOnTableView:tableView atIndexPath:indexPath block:^void(id<COOLTableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSIndexPath *_indexPath, __autoreleasing id *result) {
        *result = [_dataSource tableView:_tableView cellForRowAtIndexPath:_indexPath];
    } result:&cell];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performOnTableView:tableView atIndexPath:indexPath block:^(id<COOLTableViewDataSourceDelegate> _delegate, UITableView *_tableView, NSIndexPath *_indexPath, __autoreleasing id *result) {
        if ([_delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
            [_delegate tableView:_tableView didSelectRowAtIndexPath:_indexPath];
        }
    } result:NULL];
}

#pragma mark - COOLTableViewDisplayDataSource

- (void)registerReusableViewsInTableView:(UITableView *)tableView
{
}

- (id)cellObjectAtIndexPath:(NSIndexPath *)indexPath
{
    id<COOLIndexPathsMapping> mapping = [self mappingForSection:indexPath.section];
    id<COOLTableViewDisplayDataSource> dataSource = [self tableViewDisplayDataSourceForIndexPath:indexPath];
    NSIndexPath *mappedIndexPath = [mapping indexPathBeforeWrappingForIndexPathAfterWrapping:indexPath];
    return [dataSource cellObjectAtIndexPath:mappedIndexPath];
}

- (NSArray *)cellObjectsInSection:(NSInteger)section
{
    id<COOLIndexPathsMapping> mapping = [self mappingForSection:section];
    id<COOLTableViewDisplayDataSource> dataSource = [self tableViewDisplayDataSourceForSection:section];
    NSInteger mappedSection = [mapping sectionBeforeWrappingForSectionAfterWrapping:section];
    return [dataSource cellObjectsInSection:mappedSection];
}

@end

#pragma mark - PerformOnTableView

@implementation COOLWrappedTableViewDataSourceDelegate(PerformOnTableView)

- (void)performOnTableView:(UITableView *)tableView inSection:(NSInteger)section block:(COOLBlockOnTableViewInSection)block result:(__autoreleasing id *)result
{
    id<COOLTableViewDataSourceDelegate> dataSource = [self tableViewDataSourceForSection:section];
    COOLTableViewWrapper *wrapper = [self wrapperForTableView:tableView section:section];
    NSInteger localSection = [wrapper.indexPathsMapping sectionBeforeWrappingForSectionAfterWrapping:section];
    id internalResult;
    block(dataSource, (UITableView *)wrapper, localSection, &internalResult);
    if (result) *result = internalResult;
}

- (void)performOnTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath block:(COOLBlockOnTableViewAtIndexPath)block result:(__autoreleasing id *)result
{
    id<COOLTableViewDataSourceDelegate> dataSource = [self tableViewDataSourceForIndexPath:indexPath];
    COOLTableViewWrapper *wrapper = [self wrapperForTableView:tableView indexPath:indexPath];
    NSIndexPath *localIndexPath = [wrapper.indexPathsMapping indexPathBeforeWrappingForIndexPathAfterWrapping:indexPath];
    id internalResult;
    block(dataSource, (UITableView *)wrapper, localIndexPath, &internalResult);
    if (result) *result = internalResult;
}

- (void)performOnTableView:(UITableView *)tableView
             fromIndexPath:(NSIndexPath *)fromIndexPath
               toIndexPath:(NSIndexPath *)toIndexPath
                     block:(COOLBlockOnTableViewFromIndexPathToIndexPath)block
                    result:(__autoreleasing id *)result
{
    id<COOLTableViewDataSourceDelegate> dataSource = [self tableViewDataSourceForIndexPath:fromIndexPath];
    COOLTableViewWrapper *wrapper = [self wrapperForTableView:tableView indexPath:fromIndexPath];
    NSIndexPath *localFromIndexPath = [wrapper.indexPathsMapping indexPathBeforeWrappingForIndexPathAfterWrapping:fromIndexPath];
    NSIndexPath *localToIndexPath = [wrapper.indexPathsMapping indexPathBeforeWrappingForIndexPathAfterWrapping:toIndexPath];
    id internalResult;
    block(dataSource, (UITableView *)wrapper, localFromIndexPath, localToIndexPath, &internalResult);
    if (result) *result = internalResult;
}

@end
