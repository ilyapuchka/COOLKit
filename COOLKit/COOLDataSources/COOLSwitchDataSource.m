//
//  COOLSwitchDataSource.m
//  COOLDataSource
//
//  Created by Ilya Puchka on 09.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLSwitchDataSource.h"

@interface COOLComposedDataSource()

@property (nonatomic, strong) id<COOLSwitchComposition> dataSources;

@end

@interface COOLSwitchDataSource()

@end

@implementation COOLSwitchDataSource

- (id<COOLSwitchComposition>)dataSources
{
    if (!_dataSources) {
        _dataSources = [[COOLSwitchComposition alloc] initWithArray:_objects];
    }
    return (COOLSwitchComposition *)_dataSources;
}

- (COOLSwitchComposition *)composition
{
    return (COOLSwitchComposition *)self.dataSources;
}

#pragma mark - Composition methods

- (COOLDataSource *)currentObject
{
    return [self.dataSources currentObject];
}

- (NSUInteger)currentObjectIndex
{
    return [self.dataSources currentObjectIndex];
}

- (BOOL)switchToObject:(COOLDataSource *)object
{
    return [self.dataSources switchToObject:object];
}

- (BOOL)switchToObjectAtIndex:(NSUInteger)index
{
    return [self.dataSources switchToObjectAtIndex:index];
}

- (BOOL)didCompleteLoadingWithSuccess
{
    COOLDataSource *currentDataSource = (COOLDataSource *)[self currentObject];
    return [currentDataSource didCompleteLoadingWithSuccess];
}

- (BOOL)didCompleteLoadingWithNoContent
{
    COOLDataSource *currentDataSource = (COOLDataSource *)[self currentObject];
    return [currentDataSource didCompleteLoadingWithNoContent];
}

@end
