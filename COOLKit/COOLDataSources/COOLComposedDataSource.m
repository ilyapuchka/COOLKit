//
//  COOLComposedDataSource.m
//  CoolEvents
//
//  Created by Ilya Puchka on 08.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLComposedDataSource.h"
#include "NSArray+Extensions.h"
#import "COOLLoadingStateMachine.h"

@interface COOLComposedDataSource()

@property (nonatomic, strong) id<COOLComposition> dataSources;
@property (nonatomic, strong) NSDictionary *dataSourcesByStates;

@end

@implementation COOLComposedDataSource

- (instancetype)init
{
    return [self initWithDataSources:nil];
}

- (instancetype)initWithDataSources:(NSArray *)dataSources
{
    self = [super init];
    if (self) {
        _objects = [dataSources copy];
        
        for (COOLDataSource *object in self.dataSources) {
            [object setDelegate:self];
            [self addDataSourceByState:object];
        }
        _dataSourcesByStates = @{};
    }
    return self;
}

- (id<COOLComposition>)dataSources
{
    if (!_dataSources) {
        _dataSources = [[COOLComposition alloc] initWithArray:_objects];
    }
    return _dataSources;
}

- (COOLComposition *)composition
{
    return (COOLComposition *)self.dataSources;
}

- (void)resetContent
{
    [super resetContent];
    
    _dataSourcesByStates = @{};
    for (COOLDataSource *object in self.dataSources) {
        [object resetContent];
        [self addDataSourceByState:object];
    }
}

#pragma mark - Composition methods

- (void)addObject:(COOLDataSource *)object
{
    [self.dataSources addObject:object];
    [object setDelegate:self];
    [self addDataSourceByState:object];
}

- (void)removeObject:(COOLDataSource *)object
{
    [self.dataSources removeObject:object];
}

- (void)removeObjectAtIndex:(NSUInteger)idx
{
    [self.dataSources removeObjectAtIndex:idx];
}

- (NSUInteger)count
{
    return [self.dataSources count];
}

- (NSUInteger)indexOfObject:(COOLDataSource *)object
{
    return [self.dataSources indexOfObject:object];
}

- (COOLDataSource *)objectAtIndexedSubscript:(NSUInteger)idx
{
    return [self.dataSources objectAtIndexedSubscript:idx];
}

- (void)setObject:(COOLDataSource *)obj atIndexedSubscript:(NSUInteger)idx
{
    [self.dataSources setObject:obj atIndexedSubscript:idx];
}

#pragma mark - COOLDataSourceDelegate

- (void)dataSourceStateWillChange:(COOLDataSource *)dataSource
{
    [self removeDataSourceByState:dataSource];
}

- (void)dataSourceStateDidChange:(COOLDataSource *)dataSource
{
    [self addDataSourceByState:dataSource];
}

- (void)dataSourceWillLoadContent:(COOLDataSource *)dataSource
{
    self.loadingError = nil;
}

- (void)dataSource:(COOLDataSource *)dataSource didLoadContentWithError:(NSError *)error
{
    if (error) self.loadingError = error;

    [self completeLoadingIfNeeded:self.loadingProcess];
}

- (NSString *)missingTransitionFromState:(NSString *)fromState toState:(NSString *)toState
{
    if ([toState isEqualToString:COOLStateUndefined]) {
        //if previous loading was completed with success then go to refresh state, else to loading state
        if ([self didCompleteLoadingWithSuccess]) {
            return COOLLoadingStateRefreshingContent;
        }
        return COOLLoadingStateLoadingContent;
    }
    return nil;
}

- (BOOL)didCompleteLoadingWithSuccess
{
    //if at least one data source completed loading then assume that loading completed with success
    return [self.dataSourcesByStates[COOLLoadingStateContentLoaded] count] > 0;
}

- (BOOL)didCompleteLoadingWithNoContent
{
    //if all data sources completed loading with no content then assume that loading completed with no content
    return [self.dataSourcesByStates[COOLLoadingStateNoContent] count] == [self.dataSources count];
}

#pragma mark - Private

- (void)addDataSourceByState:(COOLDataSource *)dataSource
{
    NSMutableDictionary *mDataSourcesByStates = [_dataSourcesByStates mutableCopy];
    mDataSourcesByStates[[dataSource loadingState]] = [_dataSourcesByStates[[dataSource loadingState]]?:@[] cool_addObject:dataSource];
    _dataSourcesByStates = [mDataSourcesByStates copy];
}

- (void)removeDataSourceByState:(COOLDataSource *)dataSource
{
    NSMutableDictionary *mDataSourcesByStates = [_dataSourcesByStates mutableCopy];
    mDataSourcesByStates[[dataSource loadingState]] = [_dataSourcesByStates[[dataSource loadingState]]?:@[] cool_removeObject:dataSource];
    _dataSourcesByStates = [mDataSourcesByStates copy];
}

- (BOOL)completed
{
    return ([self.dataSourcesByStates[COOLLoadingStateLoadingContent] count] == 0 &&
            [self.dataSourcesByStates[COOLLoadingStateRefreshingContent] count] == 0);
}

- (void)completeLoadingIfNeeded:(COOLLoadingProcess *)loadingProcess
{
    if ([self completed]) {
        if ([self didCompleteLoadingWithSuccess]) {
            [loadingProcess doneWithContent:self.onContentBlock];
        }
        else if ([self didCompleteLoadingWithNoContent]) {
            [loadingProcess doneWithNoContent:self.onNoContentBlock];
        }
        else {
            [loadingProcess doneWithError:self.loadingError update:self.onErrorBlock];
        }
    }
}

#pragma mark - Invocations forwarding

- (BOOL)isKindOfClass:(Class)aClass
{
    BOOL isKindOfClass = [super isKindOfClass:aClass];
    if (!isKindOfClass) {
        return [self.dataSources isKindOfClass:aClass];
    }
    return isKindOfClass;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    BOOL respondsToSelector = [super respondsToSelector:aSelector];
    if (!respondsToSelector) {
        return [self.dataSources respondsToSelector:aSelector];
    }
    return respondsToSelector;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self.dataSources respondsToSelector:aSelector]) {
        return self.dataSources;
    }
    return nil;
}

@end
