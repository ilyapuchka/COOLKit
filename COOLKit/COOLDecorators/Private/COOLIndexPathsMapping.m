//
//  COOLIndexPathsMapping.m
//  COOLDecorators
//
//  Created by Ilya Puchka on 15.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLIndexPathsMapping.h"
#import <UIKit/UIKit.h>

@interface COOLIndexPathsMapping()

@property (nonatomic, strong) NSMutableDictionary *beforeToAfterSections; //sections before wrapping mapped to sections after
@property (nonatomic, strong) NSMutableDictionary *afterToBeforeSections; //sections after wrapping mapped to sections before

@property (nonatomic) NSInteger sectionsCount;

@end

@implementation COOLIndexPathsMapping

- (instancetype)initWithSectionsCount:(NSInteger)sectionsCount
{
    self = [super init];
    if (self) {
        self.sectionsCount = sectionsCount;
        self.beforeToAfterSections = [@{} mutableCopy];
        self.afterToBeforeSections = [@{} mutableCopy];
    }
    return self;
}

- (NSInteger)sectionAfterWrappingForSectionBeforeWrapping:(NSInteger)section
{
//    NSIndexPath *indexPath = [self indexPathAfterWrappingForIndexPathBeforeWrapping:[NSIndexPath indexPathForItem:0 inSection:section]];
//    return indexPath.section;
    NSInteger beforeSection = [self.beforeToAfterSections[@(section)] integerValue];
    return beforeSection;

}

- (NSInteger)sectionBeforeWrappingForSectionAfterWrapping:(NSInteger)section
{
//    NSIndexPath *indexPath = [self indexPathBeforeWrappingForIndexPathAfterWrapping:[NSIndexPath indexPathForItem:0 inSection:section]];
//    return indexPath.section;
    NSInteger afterSection = [self.afterToBeforeSections[@(section)] integerValue];
    return afterSection;
}

- (NSIndexSet *)sectionsAfterWrappingForSectionBeforeWrapping:(NSIndexSet *)sections
{
    NSMutableIndexSet *mSections = [NSMutableIndexSet new];
    [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
        [mSections addIndex:[self sectionAfterWrappingForSectionBeforeWrapping:section]];
    }];
    return [mSections copy];
}

- (NSIndexSet *)sectionsBeforeWrappingForSectionAfterWrapping:(NSIndexSet *)sections
{
    NSMutableIndexSet *mSections = [NSMutableIndexSet new];
    [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
        [mSections addIndex:[self sectionBeforeWrappingForSectionAfterWrapping:section]];
    }];
    return [mSections copy];
}

- (NSIndexPath *)indexPathAfterWrappingForIndexPathBeforeWrapping:(NSIndexPath *)indexPath
{
    NSInteger section = [self.beforeToAfterSections[@(indexPath.section)] integerValue];
    NSIndexPath *afterIndexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:section];
    afterIndexPath = afterIndexPath?:indexPath;
    return afterIndexPath;
}

- (NSIndexPath *)indexPathBeforeWrappingForIndexPathAfterWrapping:(NSIndexPath *)indexPath
{
    NSInteger section = [self.afterToBeforeSections[@(indexPath.section)] integerValue];
    NSIndexPath *beforeIndexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:section];
    beforeIndexPath = beforeIndexPath?:indexPath;
    return beforeIndexPath;
}

- (NSArray *)indexPathsAfterWrappingForIndexPathBeforeWrapping:(NSArray *)indexPaths
{
    NSMutableArray *mIndexPaths = [@[] mutableCopy];
    for (NSIndexPath *indexPath in indexPaths) {
        [mIndexPaths addObject:[self indexPathAfterWrappingForIndexPathBeforeWrapping:indexPath]];
    }
    return [mIndexPaths copy];
}

- (NSArray *)indexPathsBeforeWrappingForIndexPathAfterWrapping:(NSArray *)indexPaths
{
    NSMutableArray *mIndexPaths = [@[] mutableCopy];
    for (NSIndexPath *indexPath in indexPaths) {
        [mIndexPaths addObject:[self indexPathBeforeWrappingForIndexPathAfterWrapping:indexPath]];
    }
    return [mIndexPaths copy];
}

- (NSInteger)updateWithSectionsCount:(NSInteger)sectionsCount
     startingWithSectionAtIndex:(NSInteger)startSectionIndex
{
    [self.beforeToAfterSections removeAllObjects];
    [self.beforeToAfterSections removeAllObjects];
    self.sectionsCount = sectionsCount;
    
    for (NSUInteger beforeSection = 0; beforeSection < self.sectionsCount; beforeSection++) {
        NSNumber *startNum = @(startSectionIndex);
        NSNumber *beforeNum = @(beforeSection);
        NSAssert(self.beforeToAfterSections[beforeNum] == nil, @"collision while trying to add to a mapping");
        self.afterToBeforeSections[startNum] = beforeNum;
        self.beforeToAfterSections[beforeNum] = startNum;
        startSectionIndex++;
    }
    return startSectionIndex;
}

@end
