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
    return [self.indexPathsMapping indexPathBeforeWrappingForIndexPathAfterWrapping:indexPath];
}

- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection
{
    section = [self.indexPathsMapping sectionAfterWrappingForSectionBeforeWrapping:section];
    newSection = [self.indexPathsMapping sectionAfterWrappingForSectionBeforeWrapping:newSection];

    [self.wrappedObject moveSection:section toSection:newSection];
}

#pragma mark - UITableView methods that accept index paths

- (NSInteger)numberOfSections
{
    return self.indexPathsMapping.sectionsCount;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    section = [self.indexPathsMapping sectionAfterWrappingForSectionBeforeWrapping:section];
    return [self.wrappedObject numberOfRowsInSection:section];
}

- (CGRect)rectForSection:(NSInteger)section
{
    section = [self.indexPathsMapping sectionAfterWrappingForSectionBeforeWrapping:section];
    return [self.wrappedObject rectForSection:section];
}

- (CGRect)rectForHeaderInSection:(NSInteger)section
{
    section = [self.indexPathsMapping sectionAfterWrappingForSectionBeforeWrapping:section];
    return [self.wrappedObject rectForHeaderInSection:section];
}

- (CGRect)rectForFooterInSection:(NSInteger)section
{
    section = [self.indexPathsMapping sectionAfterWrappingForSectionBeforeWrapping:section];
    return [self.wrappedObject rectForFooterInSection:section];
}

- (CGRect)rectForRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexPath = [self.indexPathsMapping indexPathAfterWrappingForIndexPathBeforeWrapping:indexPath];
    return [self.wrappedObject rectForRowAtIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForRowAtPoint:(CGPoint)point
{
    NSIndexPath *indexPath = [self.wrappedObject indexPathForRowAtPoint:point];
    return [self.indexPathsMapping indexPathBeforeWrappingForIndexPathAfterWrapping:indexPath];
}

- (NSArray *)indexPathsForRowsInRect:(CGRect)rect
{
    NSArray *indexPaths = [self.wrappedObject indexPathsForRowsInRect:rect];
    return [self.indexPathsMapping indexPathsBeforeWrappingForIndexPathAfterWrapping:indexPaths];
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexPath = [self.indexPathsMapping indexPathAfterWrappingForIndexPathBeforeWrapping:indexPath];
    return [self.wrappedObject cellForRowAtIndexPath:indexPath];
}

- (NSArray *)indexPathsForVisibleRows
{
    NSArray *indexPaths = [self.wrappedObject indexPathsForVisibleRows];
    return [self.indexPathsMapping indexPathsBeforeWrappingForIndexPathAfterWrapping:indexPaths];
}

- (UITableViewHeaderFooterView *)headerViewForSection:(NSInteger)section
{
    section = [self.indexPathsMapping sectionAfterWrappingForSectionBeforeWrapping:section];
    return [self.wrappedObject headerViewForSection:section];
}

- (UITableViewHeaderFooterView *)footerViewForSection:(NSInteger)section
{
    section = [self.indexPathsMapping sectionAfterWrappingForSectionBeforeWrapping:section];
    return [self.wrappedObject footerViewForSection:section];
}

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    indexPath = [self.indexPathsMapping indexPathAfterWrappingForIndexPathBeforeWrapping:indexPath];
    [self.wrappedObject scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    sections = [self.indexPathsMapping sectionsAfterWrappingForSectionBeforeWrapping:sections];
    [self.wrappedObject insertSections:sections withRowAnimation:animation];
}

- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    sections = [self.indexPathsMapping sectionsAfterWrappingForSectionBeforeWrapping:sections];
    [self.wrappedObject deleteSections:sections withRowAnimation:animation];
}

- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    sections = [self.indexPathsMapping sectionsAfterWrappingForSectionBeforeWrapping:sections];
    [self.wrappedObject reloadSections:sections withRowAnimation:animation];
}

- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    indexPaths = [self.indexPathsMapping indexPathsAfterWrappingForIndexPathBeforeWrapping:indexPaths];
    [self.wrappedObject insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    indexPaths = [self.indexPathsMapping indexPathsAfterWrappingForIndexPathBeforeWrapping:indexPaths];
    [self.wrappedObject deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    indexPaths = [self.indexPathsMapping indexPathsAfterWrappingForIndexPathBeforeWrapping:indexPaths];
    [self.wrappedObject reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath
{
    indexPath = [self.indexPathsMapping indexPathAfterWrappingForIndexPathBeforeWrapping:indexPath];
    newIndexPath = [self.indexPathsMapping indexPathAfterWrappingForIndexPathBeforeWrapping:newIndexPath];
    [self.wrappedObject moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
}

- (NSIndexPath *)indexPathForSelectedRow
{
    NSIndexPath *indexPath = [self.wrappedObject indexPathForSelectedRow];
    return [self.indexPathsMapping indexPathBeforeWrappingForIndexPathAfterWrapping:indexPath];
}

- (NSArray *)indexPathsForSelectedRows
{
    NSArray *indexPaths = [self.wrappedObject indexPathsForSelectedRows];
    if (!indexPaths) {
        return nil;
    }
    return [self.indexPathsMapping indexPathsBeforeWrappingForIndexPathAfterWrapping:indexPaths];
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition
{
    indexPath = [self.indexPathsMapping indexPathAfterWrappingForIndexPathBeforeWrapping:indexPath];
    [self.wrappedObject selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
}

- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    indexPath = [self.indexPathsMapping indexPathAfterWrappingForIndexPathBeforeWrapping:indexPath];
    [self.wrappedObject deselectRowAtIndexPath:indexPath animated:animated];
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    indexPath = [self.indexPathsMapping indexPathAfterWrappingForIndexPathBeforeWrapping:indexPath];
    return [self.wrappedObject dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

@end
