//
//  COOLInjectTableViewDataSourceDecorator.m
//  COOLKit
//
//  Created by Ilya Puchka on 01.01.15.
//  Copyright (c) 2015 Ilya Puchka. All rights reserved.
//

#import "COOLInjectedTableViewDataSourceDecorator.h"
#import <objc/message.h>

@interface COOLInjectedTableViewDataSourceDecorator()

//s[i] = s[i-1] + rowsCount[i]; s[0] = rowsCount[0]; s[1] = s[0] + rowsCount[1]; ...
@property (nonatomic, copy) NSArray *sectionsRowsArray;
@property (nonatomic, copy) NSArray *injectedItemsIndexPaths;

@property (nonatomic, assign, readwrite) NSInteger offset;
@property (nonatomic, assign, readwrite) NSInteger step;

@end

@implementation COOLInjectedTableViewDataSourceDecorator

- (instancetype)initWithOffset:(NSInteger)offset step:(NSInteger)step
{
    self = [super init];
    if (self) {
        _offset = offset;
        _step = step;
    }
    return self;
}

- (NSInteger)decoratedViewSectionsCount
{
    typedef NSUInteger (*ObjCMsgSendReturnNSUInteger)(id, SEL, id);
    ObjCMsgSendReturnNSUInteger sendMsgReturnNSUInteger = (ObjCMsgSendReturnNSUInteger)objc_msgSend;
    
    NSInteger sectionsCount = 0;
    if ([self.decoratedDataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sectionsCount = sendMsgReturnNSUInteger(self.decoratedDataSource, @selector(numberOfSectionsInTableView:), self.decoratedView);
    }
    else if ([self.decoratedDataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        sectionsCount = sendMsgReturnNSUInteger(self.decoratedDataSource, @selector(numberOfSectionsInCollectionView:), self.decoratedView);
    }
    return sectionsCount;
}

- (NSInteger)decoratedViewRowsCountInSection:(NSInteger)section
{
    typedef NSUInteger (*ObjCMsgSendReturnNSUInteger)(id, SEL, id, NSInteger);
    ObjCMsgSendReturnNSUInteger sendMsgReturnNSUInteger = (ObjCMsgSendReturnNSUInteger)objc_msgSend;

    NSInteger rowsCount = 0;
    if ([self.decoratedDataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        rowsCount = sendMsgReturnNSUInteger(self.decoratedDataSource, @selector(tableView:numberOfRowsInSection:), self.decoratedView, section);
    }
    else if ([self.decoratedDataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
        rowsCount = sendMsgReturnNSUInteger(self.decoratedDataSource, @selector(collectionView:numberOfItemsInSection:), self.decoratedView, section);
    }
    return rowsCount;
}

- (void)beginUpdates
{
    [self removeItems];
}

- (void)removeItems
{
    [(UITableView *)self.decoratedView deleteRowsAtIndexPaths:self.injectedItemsIndexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void)endUpdates
{
    [self reloadData];
    [(UITableView *)self.decoratedView insertRowsAtIndexPaths:self.injectedItemsIndexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadData
{
    NSInteger sectionsCount = [self decoratedViewSectionsCount];
    if (sectionsCount <= 0) {
        self.sectionsRowsArray = nil;
        self.injectedItemsIndexPaths = nil;
        return;
    }
    
    [self insertItemsWithSectionsCount:sectionsCount];
    [super reloadData];
}

- (void)insertItemsWithSectionsCount:(NSInteger)sectionsCount
{
    NSMutableArray *sectionsRawsArray = [NSMutableArray new];
    NSMutableArray *injectedItemsIndexPaths = [NSMutableArray new];
    
    for (NSInteger i = 0; i < sectionsCount; i++) {
        NSInteger rowsCount = [self decoratedViewRowsCountInSection:i];
        if (i == 0) {
            sectionsRawsArray[i] = @(rowsCount);
        }
        else {
            sectionsRawsArray[i] = @([sectionsRawsArray[i-1] integerValue] + rowsCount);
        }
        NSInteger adsCount = [self countOfInsertedItemsInSectionAtIndex:i];
        for (NSInteger j = 0; j < adsCount; j++) {
            NSIndexPath *indexPath = [self injectItemIndexPathForIndex:j inSection:i];
            if (indexPath) {
                [injectedItemsIndexPaths addObject:indexPath];
            }
        }
        self.sectionsRowsArray = sectionsRawsArray;
        self.injectedItemsIndexPaths = injectedItemsIndexPaths;
    }
}

- (NSIndexPath *)indexPathForDecoratedIndexPath:(NSIndexPath *)indexPath
{
    NSInteger i = indexPath.section;
    NSInteger jj = indexPath.row;
    
    NSInteger ki = [self startOffsetForSectionAtIndex:i];
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

- (NSIndexPath *)indexPathAfterDecorationForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger i = indexPath.section;
    NSInteger j = indexPath.row;
    
    NSInteger ki = [self startOffsetForSectionAtIndex:i];
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

- (BOOL)isInjectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger i = indexPath.section;
    NSInteger ki = [self startOffsetForSectionAtIndex:i];
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

- (NSInteger)startOffsetForSectionAtIndex:(NSInteger)section
{
    NSInteger rowsCount = [self decoratedViewRowsCountInSection:section];
    
    NSInteger i = section;
    NSInteger k = self.offset;
    
    NSInteger si = rowsCount + ((i > 0)? [self.sectionsRowsArray[i-1] integerValue]: 0);
    if (si <= k) {
        return NSNotFound;
    }
    
    NSInteger v = self.step;
    
    NSInteger ki;
    NSInteger c = (i > 0)? [self.sectionsRowsArray[i-1] integerValue]: 0;
    if (c <= k) {
        ki = k - c;
    }
    else if ((c - k) % v == 0) {
        return 0;
    }
    else {
        ki = v - (c - k) % v;
    }
    return MAX(ki, 0);
}

- (NSInteger)countOfInsertedItemsInSectionAtIndex:(NSInteger)section
{
    NSInteger i = section;
    NSInteger ki = [self startOffsetForSectionAtIndex:i];
    if (ki == NSNotFound) {
        return 0;
    }
    
    NSInteger v = self.step;
    NSInteger si = [self decoratedViewRowsCountInSection:i];
    if (si > ki) {
        NSInteger count = (si - ki) / v + 1;
        if ((si - ki) % v == 0) {
            count--;
        }
        return MAX(count, 0);
    }
    return 0;
}

- (NSInteger)injectItemIndexForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger j = indexPath.row;
    NSInteger i = indexPath.section;
    NSInteger v = self.step;
    NSInteger ki = [self startOffsetForSectionAtIndex:i];
    if (ki == NSNotFound) {
        return NSNotFound;
    }
    NSInteger index = (j - ki) / v;
    return index;
}

- (NSIndexPath *)injectItemIndexPathForIndex:(NSInteger)index inSection:(NSInteger)section
{
    NSInteger i = section;
    NSInteger ki = [self startOffsetForSectionAtIndex:i];
    if (ki == NSNotFound) {
        return nil;
    }
    
    NSInteger v = self.step;
    NSInteger row = index * (v + 1) + ki;
    return [NSIndexPath indexPathForRow:row inSection:section];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowsCount = [self decoratedViewRowsCountInSection:section];
    return rowsCount + [self countOfInsertedItemsInSectionAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isInjectItemAtIndexPath:indexPath]) {
        return [self tableView:tableView injectCellForIndexPath:indexPath];
    }
    else {
        return [self.decoratedDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView injectCellForIndexPath:(NSIndexPath *)indexPath
{
    [NSException raise:NSInternalInconsistencyException format:@"Subclasses should override this method"];
    return nil;
}

- (void)registerReusableViewsInTableView:(UITableView *)tableView
{
    [NSException raise:NSInternalInconsistencyException format:@"Subclasses should override this method"];
}

- (NSArray *)cellObjectsInSection:(NSInteger)section
{
    [NSException raise:NSInternalInconsistencyException format:@"Subclasses should override this method"];
    return nil;
}

- (id)cellObjectAtIndexPath:(NSIndexPath *)indexPath
{
    [NSException raise:NSInternalInconsistencyException format:@"Subclasses should override this method"];
    return nil;
}

@end
