//
//  COOLComposedTableViewDataSource.m
//  CoolEvents
//
//  Created by Ilya Puchka on 16.11.14.
//  Copyright (c) 2014 CoolConnections. All rights reserved.
//

#import "COOLComposedTableViewDataSourceDelegate.h"
#import "COOLTableViewWrapper.h"
#import "COOLComposedIndexPathsMapping.h"

@interface COOLComposedTableViewDataSourceDelegate()

@property (nonatomic, strong) NSMutableDictionary *sectionsToDataSources;
@property (nonatomic, strong) COOLComposition *dataSources;

@end

@implementation COOLComposedTableViewDataSourceDelegate

- (instancetype)init
{
    return [self initWithDataSources:nil];
}

- (instancetype)initWithDataSources:(NSArray *)dataSources
{
    self = [super init];
    if (self) {
        _objects = [dataSources copy];
        _mappings = [@[] mutableCopy];
        _sectionsToMappings = [@{} mutableCopy];
    }
    return self;
}

- (COOLComposition *)dataSources
{
    if (!_dataSources) {
        _dataSources = [[COOLComposition alloc] init];
        for (id object in _objects) {
            [self addDataSource:object];
        }
    }
    return _dataSources;
}

- (void)addDataSource:(id<COOLTableViewDisplayDataSource>)dataSource
{
    NSParameterAssert(dataSource);

    [self.dataSources addObject:dataSource];
    COOLComposedIndexPathsMapping *mappingForDataSource = [[COOLComposedIndexPathsMapping alloc] init];
    [self.mappings addObject:mappingForDataSource];
}

- (void)removeDataSource:(id)dataSource
{
    [self.dataSources removeObject:dataSource];
}

- (COOLComposition *)composition
{
    return (COOLComposition *)self.dataSources;
}

- (id<COOLTableViewDisplayDataSource>)tableViewDataSourceForSection:(NSInteger)section
{
    id<COOLTableViewDisplayDataSource> dataSource = self.sectionsToDataSources[@(section)];
    return dataSource;
}

- (id<COOLTableViewDisplayDataSource>)tableViewDataSourceForIndexPath:(NSIndexPath *)indexPath
{
    return [self tableViewDataSourceForSection:indexPath.section];
}

- (id<COOLIndexPathsMapping>)mappingForSection:(NSInteger)section
{
    id<COOLIndexPathsMapping> mapping = self.sectionsToMappings[@(section)];
    return mapping;
}

- (id<COOLIndexPathsMapping>)mappingForIndexPath:(NSIndexPath *)indexPath
{
    return [self mappingForSection:indexPath.section];
}

- (void)updateMappingsWithTableView:(UITableView *)tableView
{
    self.sectionsCount = 0;
    [self.sectionsToDataSources removeAllObjects];
    [self.sectionsToMappings removeAllObjects];
    
    for (NSUInteger idx = 0; idx < self.mappings.count; idx++) {
        COOLComposedIndexPathsMapping *mapping = self.mappings[idx];
        NSInteger startingSection = self.sectionsCount;
        id<COOLTableViewDisplayDataSource> dataSource = self.dataSources[idx];
        NSInteger sectionsCount = 1;
        if ([dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
            sectionsCount = [dataSource numberOfSectionsInTableView:tableView];
        }
        NSInteger newSectionCount = [mapping updateWithSectionsCount:sectionsCount
                                          startingWithSectionAtIndex:startingSection];
        
        for (NSInteger i = 0; i < mapping.sectionsCount; i++) {
            NSInteger section = startingSection + i;
            NSInteger numberOfRows = [dataSource tableView:tableView numberOfRowsInSection:section];
            [mapping setNumberOfRows:numberOfRows inSection:section];
        }
        
        while (self.sectionsCount < newSectionCount) {
            self.sectionsToMappings[@(self.sectionsCount)] = mapping;
            self.sectionsToDataSources[@(self.sectionsCount)] = dataSource;
            self.sectionsCount++;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [self updateMappingsWithTableView:tableView];
    return self.sectionsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self updateMappingsWithTableView:tableView];
    return [super tableView:tableView numberOfRowsInSection:section];
}

#pragma mark - COOLTableViewDisplayDataSource

- (void)registerReusableViewsInTableView:(UITableView *)tableView
{
    for (id<COOLTableViewDisplayDataSource> object in self.dataSources) {
        if ([object respondsToSelector:@selector(registerReusableViewsInTableView:)]) {
            [object registerReusableViewsInTableView:tableView];
        }
    }
}

@end
