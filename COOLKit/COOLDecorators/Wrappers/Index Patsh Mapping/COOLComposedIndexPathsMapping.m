//
//  COOLIndexPathsMapping.m
//  COOLDecorators
//
//  Created by Ilya Puchka on 15.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLComposedIndexPathsMapping.h"
#import <UIKit/UIKit.h>

@interface COOLComposedIndexPathsMapping()

#warning TODO: remove beforeToAfterSections and afterToBeforeSections, make using just section index offset
@property (nonatomic, strong) NSMutableDictionary *beforeToAfterSections; //sections before wrapping mapped to sections after
@property (nonatomic, strong) NSMutableDictionary *afterToBeforeSections; //sections after wrapping mapped to sections before

@property (nonatomic) NSInteger sectionsCount;
@property (nonatomic, copy) NSArray *rowsCount;

@end

@implementation COOLComposedIndexPathsMapping

- (instancetype)initWithSectionsCount:(NSInteger)sectionsCount
{
    self = [self init];
    if (self) {
        self.sectionsCount = sectionsCount;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.beforeToAfterSections = [@{} mutableCopy];
        self.afterToBeforeSections = [@{} mutableCopy];
    }
    return self;
}

- (NSInteger)sectionAfterWrappingForSectionBeforeWrapping:(NSInteger)section
{
    if (self.beforeToAfterSections[@(section)] != nil) {
        NSInteger beforeSection = [self.beforeToAfterSections[@(section)] integerValue];
        return beforeSection;
    }
    return NSNotFound;
}

- (NSInteger)sectionBeforeWrappingForSectionAfterWrapping:(NSInteger)section
{
    if (self.afterToBeforeSections[@(section)] != nil) {
        NSInteger afterSection = [self.afterToBeforeSections[@(section)] integerValue];
        return afterSection;
    }
    return NSNotFound;
}

- (NSIndexSet *)sectionsAfterWrappingForSectionBeforeWrapping:(NSIndexSet *)sections
{
    NSMutableIndexSet *mSections = [NSMutableIndexSet new];
    [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
        NSInteger index = [self sectionAfterWrappingForSectionBeforeWrapping:section];
        if (index != NSNotFound) [mSections addIndex:index];
    }];
    return [mSections copy];
}

- (NSIndexSet *)sectionsBeforeWrappingForSectionAfterWrapping:(NSIndexSet *)sections
{
    NSMutableIndexSet *mSections = [NSMutableIndexSet new];
    [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
        NSInteger index = [self sectionBeforeWrappingForSectionAfterWrapping:section];
        if (index != NSNotFound) [mSections addIndex:index];
    }];
    return [mSections copy];
}

- (NSIndexPath *)indexPathAfterWrappingForIndexPathBeforeWrapping:(NSIndexPath *)indexPath
{
    NSInteger section = [self sectionAfterWrappingForSectionBeforeWrapping:indexPath.section];
    if (section != NSNotFound) {
        NSIndexPath *afterIndexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:section];
        return afterIndexPath;
    }
    return nil;
}

- (NSIndexPath *)indexPathBeforeWrappingForIndexPathAfterWrapping:(NSIndexPath *)indexPath
{
    NSInteger section = [self sectionBeforeWrappingForSectionAfterWrapping:indexPath.section];
    if (section != NSNotFound) {
        NSIndexPath *beforeIndexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:section];
        return beforeIndexPath;
    }
    return nil;
}

- (NSArray *)indexPathsAfterWrappingForIndexPathBeforeWrapping:(NSArray *)indexPaths
{
    NSMutableArray *mIndexPaths = [@[] mutableCopy];
    for (NSIndexPath *indexPath in indexPaths) {
        NSIndexPath *_indexPath = [self indexPathAfterWrappingForIndexPathBeforeWrapping:indexPath];
        if (_indexPath) [mIndexPaths addObject:_indexPath];
    }
    return [mIndexPaths copy];
}

- (NSArray *)indexPathsBeforeWrappingForIndexPathAfterWrapping:(NSArray *)indexPaths
{
    NSMutableArray *mIndexPaths = [@[] mutableCopy];
    for (NSIndexPath *indexPath in indexPaths) {
        NSIndexPath *_indexPath = [self indexPathBeforeWrappingForIndexPathAfterWrapping:indexPath];
        if (_indexPath) [mIndexPaths addObject:_indexPath];
    }
    return [mIndexPaths copy];
}

- (NSInteger)updateWithSectionsCount:(NSInteger)sectionsCount
          startingWithSectionAtIndex:(NSInteger)startSectionIndex
{
    [self.beforeToAfterSections removeAllObjects];
    [self.beforeToAfterSections removeAllObjects];
    self.sectionsCount = sectionsCount;
    
    NSMutableArray *rowsCount = [@[] mutableCopy];
    for (NSInteger i = 0; i < sectionsCount; i++) {
        [rowsCount addObject:[NSNull null]];
    }
    self.rowsCount = rowsCount;
    
    for (NSUInteger beforeSection = 0; beforeSection < self.sectionsCount; beforeSection++) {
        NSNumber *startNum = @(startSectionIndex);
        NSNumber *beforeNum = @(beforeSection);
        self.afterToBeforeSections[startNum] = beforeNum;
        self.beforeToAfterSections[beforeNum] = startNum;
        startSectionIndex++;
    }
    return startSectionIndex;
}

- (void)setNumberOfRows:(NSInteger)count inSection:(NSInteger)section
{
    NSMutableArray *rowsCount = [self.rowsCount mutableCopy];
    rowsCount[section] = @(count);
    self.rowsCount = rowsCount;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return [self.rowsCount[section] integerValue];
}

@end
