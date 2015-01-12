//
//  COOLInjectIndexPathsMapping.m
//  COOLKit
//
//  Created by Ilya Puchka on 01.01.15.
//  Copyright (c) 2015 Ilya Puchka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "COOLInjecedtIndexPathsMapping.h"

NSInteger const COOLAutomaticOffset = -1;

@interface COOLInjecedtIndexPathsMapping()

@property (nonatomic, assign, readwrite) NSInteger offset;
@property (nonatomic, assign, readwrite) NSInteger step;
@property (nonatomic, assign, readwrite) NSInteger sectionsCount;
@property (nonatomic, assign, readwrite) NSArray *rowsCount;
@property (nonatomic, strong, readwrite) NSArray *injectedItemsIndexPaths;
@property (nonatomic, copy) NSArray *sectionsRowsArray;

@end

@implementation COOLInjecedtIndexPathsMapping

- (NSInteger)sectionAfterWrappingForSectionBeforeWrapping:(NSInteger)section
{
    return section;
}

- (NSInteger)sectionBeforeWrappingForSectionAfterWrapping:(NSInteger)section
{
    return section;
}

- (NSIndexSet *)sectionsAfterWrappingForSectionBeforeWrapping:(NSIndexSet *)sections
{
    return sections;
}

- (NSIndexSet *)sectionsBeforeWrappingForSectionAfterWrapping:(NSIndexSet *)sections
{
    return sections;
}

- (instancetype)initWithSectionsCount:(NSInteger)sectionsCount offset:(NSInteger)offset step:(NSInteger)step
{
    self = [super init];
    if (self) {
        _sectionsCount = sectionsCount;
        _offset = offset;
        _step = step;
    }
    return self;
}

- (NSIndexPath *)indexPathAfterWrappingForIndexPathBeforeWrapping:(NSIndexPath *)indexPath
{
    NSInteger i = indexPath.section;
    NSInteger j = indexPath.row;
    
    NSInteger ki = self.offset;
    if (ki == NSNotFound) {
        return [NSIndexPath indexPathForRow:j inSection:i];
    }
    
    NSInteger v = self.step;
    
    NSInteger dj = 0;
    if (j >= ki) {
        dj = (j - ki) / v + 1;
    }
    NSInteger jj = j + dj;
    if (jj < 0) {
        [NSException raise:NSInternalInconsistencyException format:@"Index should be greater or equal to zero"];
    }
    return [NSIndexPath indexPathForRow:jj inSection:indexPath.section];
}

- (NSIndexPath *)indexPathBeforeWrappingForIndexPathAfterWrapping:(NSIndexPath *)indexPath
{
    NSInteger i = indexPath.section;
    NSInteger jj = indexPath.row;
    
    NSInteger ki = self.offset;
    NSInteger v = self.step;
    
    NSInteger dj = 0;
    
    if (jj >= ki) {
        dj = (jj - ki)/(v + 1) + 1;
    }
    NSInteger j = jj - dj;
    if (j < 0) {
        [NSException raise:NSInternalInconsistencyException format:@"Index should be greater or equal to zero"];
    }
    return [NSIndexPath indexPathForRow:j inSection:i];
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

- (BOOL)isInjectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger ki = self.offset;
    if (ki == NSNotFound) {
        return NO;
    }
    NSInteger j = indexPath.row;
    if (j < ki) {
        return NO;
    }
    NSInteger v = self.step;
    NSInteger rem = (j - ki) % (v + 1);
    return rem == 0;
}

- (NSInteger)countOfInsertedItemsInSection:(NSInteger)section
{
    NSInteger ki = self.offset;
    if (ki == NSNotFound) {
        return 0;
    }
    
    NSInteger v = self.step;
    NSInteger si = [self numberOfRowsInSection:section];
    if (si > ki) {
        NSInteger count = (si - ki) / v + 1;
        if ((si - ki) % v == 0) {
            count--;
        }
        return MAX(count, 0);
    }
    return 0;
}

- (NSIndexPath *)injectItemIndexPathForIndex:(NSInteger)index inSection:(NSInteger)section
{
    NSInteger ki = self.offset;
    if (ki == NSNotFound) {
        return nil;
    }
    
    NSInteger v = self.step;
    NSInteger row = index * (v + 1) + ki;
    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (NSIndexPath *)injectItemIndexForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [self.injectedItemsIndexPaths indexOfObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    if (index != NSNotFound) {
        return [NSIndexPath indexPathForRow:index inSection:indexPath.section];
    }
    return nil;
}

- (void)updateWithSectionsCount:(NSInteger)sectionsCount offset:(NSInteger)offset step:(NSInteger)step
{
    self.offset = offset;
    self.step = step;
    
    NSMutableArray *sectionsRawsArray = [NSMutableArray new];
    NSMutableArray *injectedItemsIndexPaths = [NSMutableArray new];
    
    for (NSInteger i = 0; i < sectionsCount; i++) {
        NSInteger rowsCount = [self numberOfRowsInSection:i];
        if (i == 0) {
            sectionsRawsArray[i] = @(rowsCount);
        }
        else {
            sectionsRawsArray[i] = @([sectionsRawsArray[i-1] integerValue] + rowsCount);
        }
        NSInteger itemsCount = [self countOfInsertedItemsInSection:i];
        for (NSInteger j = 0; j < itemsCount; j++) {
            NSIndexPath *indexPath = [self injectItemIndexPathForIndex:j inSection:i];
            if (indexPath) {
                [injectedItemsIndexPaths addObject:indexPath];
            }
        }
        self.sectionsRowsArray = sectionsRawsArray;
        self.injectedItemsIndexPaths = injectedItemsIndexPaths;
    }
}

- (void)setNumberOfRows:(NSInteger)count inSection:(NSInteger)section
{
    NSMutableArray *rowsCount = [self.rowsCount mutableCopy];
    rowsCount[section] = @(count);
    self.rowsCount = rowsCount;
    
    [self updateWithSectionsCount:self.sectionsCount offset:self.offset step:self.step];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return [self.rowsCount[section] integerValue];
}

@end

@implementation COOLInjecedtIndexPathsMappingForInjectedItems

- (NSIndexPath *)indexPathAfterWrappingForIndexPathBeforeWrapping:(NSIndexPath *)indexPath
{
    NSInteger j = indexPath.row;
    
    NSInteger ki = self.offset;
    if (ki == NSNotFound) {
        return [NSIndexPath indexPathForRow:j inSection:1];
    }
    
    NSInteger v = self.step;
    
    NSInteger dj = 0;
    if (j >= ki) {
        dj = (j - ki) / v + 1;
    }
    NSInteger jj = j + dj;
    if (jj < 0) {
        [NSException raise:NSInternalInconsistencyException format:@"Index should be greater or equal to zero"];
    }
    return [NSIndexPath indexPathForRow:jj inSection:1];
}

- (NSIndexPath *)indexPathBeforeWrappingForIndexPathAfterWrapping:(NSIndexPath *)indexPath
{
    NSInteger jj = indexPath.row;
    
    NSInteger ki = self.offset;
    NSInteger v = self.step;
    
    NSInteger dj = 0;
    
    if (jj >= ki) {
        dj = (jj - ki)/(v + 1) + 1;
    }
    NSInteger j = jj - dj;
    if (j < 0) {
        [NSException raise:NSInternalInconsistencyException format:@"Index should be greater or equal to zero"];
    }
    return [NSIndexPath indexPathForRow:j inSection:1];
}

@end
