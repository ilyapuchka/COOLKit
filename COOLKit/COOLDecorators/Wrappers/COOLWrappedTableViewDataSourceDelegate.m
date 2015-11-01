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
    [NSException raise:NSInternalInconsistencyException format:@"%@ method should be overriden by subclass", NSStringFromSelector(_cmd)];
    return nil;
}

- (id<COOLTableViewDataSourceDelegate>)tableViewDataSourceForIndexPath:(NSIndexPath *)indexPath
{
    [NSException raise:NSInternalInconsistencyException format:@"%@ method should be overriden by subclass", NSStringFromSelector(_cmd)];
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

#pragma mark - UITableViewDataSource required methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSNumber *numberOfRows;
    [self performOnTableView:tableView inSection:section block:^(id<COOLTableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSInteger _section, __autoreleasing id *result) {
        *result = @([_dataSource tableView:_tableView numberOfRowsInSection:_section]);
    } result:&numberOfRows];
    return numberOfRows.integerValue;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    [self performOnTableView:tableView atIndexPath:indexPath block:^void(id<COOLTableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSIndexPath *_indexPath, __autoreleasing id *result) {
        *result = [_dataSource tableView:_tableView cellForRowAtIndexPath:_indexPath];
    } result:&cell];
    return cell;
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

#pragma mark - UITableViewDataSource optional methods

@interface COOLWrappedTableViewDataSourceDelegate (UITableViewProtocolMethods) <UITableViewDataSource, UITableViewDelegate>

@end

@implementation COOLWrappedTableViewDataSourceDelegate(UITableViewProtocolOptionalMethods)

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    [self performOnTableView:tableView inSection:section block:^(id<COOLTableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSInteger _section, __autoreleasing id *result) {
        if ([_dataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
            *result = [_dataSource tableView:_tableView titleForHeaderInSection:_section];
        }
    } result:&title];
    return title;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *title;
    [self performOnTableView:tableView inSection:section block:^(id<COOLTableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSInteger _section, __autoreleasing id *result) {
        if ([_dataSource respondsToSelector:@selector(tableView:titleForFooterInSection:)]) {
            *result = [_dataSource tableView:_tableView titleForFooterInSection:_section];
        }
    } result:&title];
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height;
    [self performOnTableView:tableView atIndexPath:indexPath block:^(id<COOLTableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSIndexPath *_indexPath, __autoreleasing id *result) {
        if ([_dataSource respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
            *result = @([_dataSource tableView:_tableView heightForRowAtIndexPath:_indexPath]);
        }
        else {
            *result = @(UITableViewAutomaticDimension);
        }
    } result:&height];
    return height.floatValue;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSNumber *height;
    [self performOnTableView:tableView inSection:section block:^(id<COOLTableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSInteger _section, __autoreleasing id *result) {
        if ([_dataSource respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
            *result = @([_dataSource tableView:_tableView heightForHeaderInSection:_section]);
        }
        else {
            *result = @(UITableViewAutomaticDimension);
        }
    } result:&height];
    return height.floatValue;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSNumber *height;
    [self performOnTableView:tableView inSection:section block:^(id<COOLTableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSInteger _section, __autoreleasing id *result) {
        if ([_dataSource respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
            *result = @([_dataSource tableView:_tableView heightForFooterInSection:_section]);
        }
        else {
            *result = @(UITableViewAutomaticDimension);
        }
    } result:&height];
    return height.floatValue;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height;
    [self performOnTableView:tableView atIndexPath:indexPath block:^(id<COOLTableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSIndexPath *_indexPath, __autoreleasing id *result) {
        if ([_dataSource respondsToSelector:@selector(tableView:estimatedHeightForRowAtIndexPath:)]) {
            *result = @([_dataSource tableView:_tableView estimatedHeightForRowAtIndexPath:_indexPath]);
        }
        else {
            *result = @(UITableViewAutomaticDimension);
        }
    } result:&height];
    return height.floatValue;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    NSNumber *height;
    [self performOnTableView:tableView inSection:section block:^(id<COOLTableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSInteger _section, __autoreleasing id *result) {
        if ([_dataSource respondsToSelector:@selector(tableView:estimatedHeightForHeaderInSection:)]) {
            *result = @([_dataSource tableView:_tableView estimatedHeightForHeaderInSection:_section]);
        }
        else {
            *result = @(UITableViewAutomaticDimension);
        }
    } result:&height];
    return height.floatValue;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
{
    NSNumber *height;
    [self performOnTableView:tableView inSection:section block:^(id<COOLTableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSInteger _section, __autoreleasing id *result) {
        if ([_dataSource respondsToSelector:@selector(tableView:estimatedHeightForFooterInSection:)]) {
            *result = @([_dataSource tableView:_tableView estimatedHeightForFooterInSection:_section]);
        }
        else {
            *result = @(UITableViewAutomaticDimension);
        }
    } result:&height];
    return height.floatValue;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    [self performOnTableView:tableView inSection:section block:^(id<COOLTableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSInteger _section, __autoreleasing id *result) {
        if ([_dataSource respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
            *result = [_dataSource tableView:_tableView viewForHeaderInSection:_section];
        }
    } result:&view];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view;
    [self performOnTableView:tableView inSection:section block:^(id<COOLTableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSInteger _section, __autoreleasing id *result) {
        if ([_dataSource respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
            *result = [_dataSource tableView:_tableView viewForFooterInSection:_section];
        }
    } result:&view];
    return view;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performOnTableView:tableView atIndexPath:indexPath block:^(id<COOLTableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSIndexPath *_indexPath, __autoreleasing id *result) {
        if ([_dataSource respondsToSelector:@selector(tableView:accessoryTypeForRowWithIndexPath:)]) {
            [_dataSource tableView:_tableView accessoryButtonTappedForRowWithIndexPath:_indexPath];
        }
    } result:NULL];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray *titles;
    return titles;
}

- (NSUInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSNumber *section;
    [self performOnTableView:tableView inSection:index block:^(id<COOLTableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSInteger _section, __autoreleasing id *result) {
        if ([_dataSource respondsToSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:)]) {
            *result = @([_dataSource tableView:_tableView sectionForSectionIndexTitle:title atIndex:_section]);
        }
    } result:&section];
    return section.unsignedIntegerValue;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *indentation;
    [self performOnTableView:tableView atIndexPath:indexPath block:^(id<COOLTableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSIndexPath *_indexPath, __autoreleasing id *result) {
        if ([_dataSource respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)]) {
            *result = @([_dataSource tableView:tableView indentationLevelForRowAtIndexPath:_indexPath]);
        }
    } result:&indentation];
    return indentation.integerValue;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *seletedIndexPath;
    [self performOnTableView:tableView atIndexPath:indexPath block:^(id<COOLTableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSIndexPath *_indexPath, __autoreleasing id *result) {
        if ([_dataSource respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
            *result = [_dataSource tableView:_tableView willSelectRowAtIndexPath:_indexPath];
        }
    } result:&seletedIndexPath];
    return seletedIndexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performOnTableView:tableView atIndexPath:indexPath block:^(id<COOLTableViewDataSourceDelegate> _delegate, UITableView *_tableView, NSIndexPath *_indexPath, __autoreleasing id *result) {
        if ([_delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
            [_delegate tableView:_tableView didSelectRowAtIndexPath:_indexPath];
        }
    } result:NULL];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *selectedIndexPath;
    [self performOnTableView:tableView atIndexPath:indexPath block:^(id<COOLTableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSIndexPath *_indexPath, __autoreleasing id *result) {
        if ([_dataSource respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)]) {
            *result = [_dataSource tableView:_tableView willDeselectRowAtIndexPath:_indexPath];
        }
    } result:&selectedIndexPath];
    return selectedIndexPath;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performOnTableView:tableView atIndexPath:indexPath block:^(id<COOLTableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSIndexPath *_indexPath, __autoreleasing id *result) {
        if ([_dataSource respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
            [_dataSource tableView:_tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
        }
    } result:NULL];
}

@end
