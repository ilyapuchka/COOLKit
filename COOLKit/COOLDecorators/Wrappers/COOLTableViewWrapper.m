//
//  COOLTableViewWrapper.m
//  COOLDecorators
//
//  Created by Ilya Puchka on 14.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLTableViewWrapper.h"
#import <objc/runtime.h>

@implementation COOLTableViewWrapper

+ (instancetype)wrapperFor:(UITableView *)view
{
    return [super wrapperFor:view];
}

+ (Class)wrappedClass
{
    return [UITableView class];
}

- (UITableView *)wrappedObject
{
    return (UITableView *)[super wrappedObject];
}

- (UITableView *)tableView
{
    return [self wrappedObject];
}

- (NSIndexPath *)indexPathForCell:(id)cell
{
    NSIndexPath *indexPath = [self.wrappedObject indexPathForCell:cell];
    if (!self.indexPathsMapping) {
        return indexPath;
    }
    return [self.indexPathsMapping indexPathBeforeWrappingForIndexPathAfterWrapping:indexPath];
}

- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection
{
    if (self.indexPathsMapping) {
        section = [self.indexPathsMapping sectionAfterWrappingForSectionBeforeWrapping:section];
        newSection = [self.indexPathsMapping sectionAfterWrappingForSectionBeforeWrapping:newSection];
    }

    [self.wrappedObject moveSection:section toSection:newSection];
}

#pragma mark - UITableView methods that accept index paths

- (NSInteger)numberOfSections
{
    if (self.indexPathsMapping) {
        return self.indexPathsMapping.sectionsCount;
    }
    else {
        return [self.wrappedObject numberOfSections];
    }
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    if (self.indexPathsMapping) {
        section = [self.indexPathsMapping sectionAfterWrappingForSectionBeforeWrapping:section];
    }
    return [self.indexPathsMapping numberOfRowsInSection:section];
}

- (CGRect)rectForSection:(NSInteger)section
{
    if (self.indexPathsMapping) {
        section = [self.indexPathsMapping sectionAfterWrappingForSectionBeforeWrapping:section];
    }
    return [self.wrappedObject rectForSection:section];
}

- (CGRect)rectForHeaderInSection:(NSInteger)section
{
    if (self.indexPathsMapping) {
        section = [self.indexPathsMapping sectionAfterWrappingForSectionBeforeWrapping:section];
    }
    return [self.wrappedObject rectForHeaderInSection:section];
}

- (CGRect)rectForFooterInSection:(NSInteger)section
{
    if (self.indexPathsMapping) {
        section = [self.indexPathsMapping sectionAfterWrappingForSectionBeforeWrapping:section];
    }
    return [self.wrappedObject rectForFooterInSection:section];
}

- (CGRect)rectForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.indexPathsMapping) {
        indexPath = [self.indexPathsMapping indexPathAfterWrappingForIndexPathBeforeWrapping:indexPath];
    }
    return [self.wrappedObject rectForRowAtIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForRowAtPoint:(CGPoint)point
{
    NSIndexPath *indexPath = [self.wrappedObject indexPathForRowAtPoint:point];
    if (!self.indexPathsMapping) {
        return indexPath;
    }
    return [self.indexPathsMapping indexPathBeforeWrappingForIndexPathAfterWrapping:indexPath];
}

- (NSArray *)indexPathsForRowsInRect:(CGRect)rect
{
    NSArray *indexPaths = [self.wrappedObject indexPathsForRowsInRect:rect];
    if (!self.indexPathsMapping) {
        return indexPaths;
    }
    return [self.indexPathsMapping indexPathsBeforeWrappingForIndexPathAfterWrapping:indexPaths];
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.indexPathsMapping) {
        indexPath = [self.indexPathsMapping indexPathAfterWrappingForIndexPathBeforeWrapping:indexPath];
    }
    return [self.wrappedObject cellForRowAtIndexPath:indexPath];
}

- (NSArray *)indexPathsForVisibleRows
{
    NSArray *indexPaths = [self.wrappedObject indexPathsForVisibleRows];
    if (!self.indexPathsMapping) {
        return indexPaths;
    }
    return [self.indexPathsMapping indexPathsBeforeWrappingForIndexPathAfterWrapping:indexPaths];
}

- (UITableViewHeaderFooterView *)headerViewForSection:(NSInteger)section
{
    if (self.indexPathsMapping) {
        section = [self.indexPathsMapping sectionAfterWrappingForSectionBeforeWrapping:section];
    }
    return [self.wrappedObject headerViewForSection:section];
}

- (UITableViewHeaderFooterView *)footerViewForSection:(NSInteger)section
{
    if (self.indexPathsMapping) {
        section = [self.indexPathsMapping sectionAfterWrappingForSectionBeforeWrapping:section];
    }
    return [self.wrappedObject footerViewForSection:section];
}

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    if (self.indexPathsMapping) {
        indexPath = [self.indexPathsMapping indexPathAfterWrappingForIndexPathBeforeWrapping:indexPath];
    }
    [self.wrappedObject scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    if (self.indexPathsMapping) {
        sections = [self.indexPathsMapping sectionsAfterWrappingForSectionBeforeWrapping:sections];
    }
    [self.wrappedObject insertSections:sections withRowAnimation:animation];
}

- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    if (self.indexPathsMapping) {
        sections = [self.indexPathsMapping sectionsAfterWrappingForSectionBeforeWrapping:sections];
    }
    [self.wrappedObject deleteSections:sections withRowAnimation:animation];
}

- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    if (self.indexPathsMapping) {
        sections = [self.indexPathsMapping sectionsAfterWrappingForSectionBeforeWrapping:sections];
    }
    [self.wrappedObject reloadSections:sections withRowAnimation:animation];
}

- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    if (self.indexPathsMapping) {
        indexPaths = [self.indexPathsMapping indexPathsAfterWrappingForIndexPathBeforeWrapping:indexPaths];
    }
    [self.wrappedObject insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    if (self.indexPathsMapping) {
        indexPaths = [self.indexPathsMapping indexPathsAfterWrappingForIndexPathBeforeWrapping:indexPaths];
    }
    [self.wrappedObject deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    if (self.indexPathsMapping) {
        indexPaths = [self.indexPathsMapping indexPathsAfterWrappingForIndexPathBeforeWrapping:indexPaths];
    }
    [self.wrappedObject reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath
{
    if (self.indexPathsMapping) {
        indexPath = [self.indexPathsMapping indexPathAfterWrappingForIndexPathBeforeWrapping:indexPath];
        newIndexPath = [self.indexPathsMapping indexPathAfterWrappingForIndexPathBeforeWrapping:newIndexPath];
    }
    [self.wrappedObject moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
}

- (NSIndexPath *)indexPathForSelectedRow
{
    NSIndexPath *indexPath = [self.wrappedObject indexPathForSelectedRow];
    if (!self.indexPathsMapping) {
        return indexPath;
    }
    return [self.indexPathsMapping indexPathBeforeWrappingForIndexPathAfterWrapping:indexPath];
}

- (NSArray *)indexPathsForSelectedRows
{
    NSArray *indexPaths = [self.wrappedObject indexPathsForSelectedRows];
    if (!self.indexPathsMapping) {
        return indexPaths;
    }
    return [self.indexPathsMapping indexPathsBeforeWrappingForIndexPathAfterWrapping:indexPaths];
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition
{
    if (self.indexPathsMapping) {
        indexPath = [self.indexPathsMapping indexPathAfterWrappingForIndexPathBeforeWrapping:indexPath];
    }
    [self.wrappedObject selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
}

- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    if (self.indexPathsMapping) {
        indexPath = [self.indexPathsMapping indexPathAfterWrappingForIndexPathBeforeWrapping:indexPath];
    }
    [self.wrappedObject deselectRowAtIndexPath:indexPath animated:animated];
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    if (self.indexPathsMapping) {
        indexPath = [self.indexPathsMapping indexPathAfterWrappingForIndexPathBeforeWrapping:indexPath];
    }
    return [self.wrappedObject dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

@end
