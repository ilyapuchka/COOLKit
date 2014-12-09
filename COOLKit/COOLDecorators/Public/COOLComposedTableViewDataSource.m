//
//  COOLComposedTableViewDataSource.m
//  CoolEvents
//
//  Created by Ilya Puchka on 16.11.14.
//  Copyright (c) 2014 CoolConnections. All rights reserved.
//

#import "COOLComposedTableViewDataSource.h"
#import "COOLTableViewWrapper.h"

@interface COOLComposedTableViewDataSource()

@property (nonatomic, strong) NSMutableDictionary *sectionsToMappings;
@property (nonatomic, strong) NSMutableDictionary *sectionsToDataSources;
@property (nonatomic, strong) NSMutableArray *mappings;
@property (nonatomic) NSInteger sectionsCount;
@property (nonatomic, strong) COOLComposition *dataSources;

@end

@implementation COOLComposedTableViewDataSource

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
        _sectionsToDataSources = [@{} mutableCopy];
        _sectionsToMappings = [@{} mutableCopy];
    }
    return self;
}

- (COOLComposition *)dataSources
{
    if (!_dataSources) {
        _dataSources = [[COOLComposition alloc] init];
        for (id<UITableViewDataSourceDelegate> object in _objects) {
            [self addDataSource:object];
        }
    }
    return _dataSources;
}

- (void)addDataSource:(id)dataSource
{
    NSParameterAssert(dataSource);

    [self.dataSources addObject:dataSource];
    NSInteger numberOfSections = [dataSource numberOfSectionsInTableView:nil];
    numberOfSections = numberOfSections == 0? 1: numberOfSections;

    COOLIndexPathsMapping *mappingForDataSource = [[COOLIndexPathsMapping alloc] initWithSectionsCount:numberOfSections];
    [self.mappings addObject:mappingForDataSource];
    
    [self updateMappings];
}

- (void)removeDataSource:(id)dataSource
{
    [self.dataSources removeObject:dataSource];
}

- (COOLComposition *)composition
{
    return (COOLComposition *)self.dataSources;
}

#pragma mark - UITableViewDataSourceDelegate, COOLTableViewDisplayDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [self updateMappings];
    return self.sectionsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self updateMappings];

    id<UITableViewDataSource> dataSource = [self tableViewDataSourceForSection:section];
    COOLTableViewWrapper *wrapper = [self wrapperForTableView:tableView section:section];
    NSInteger localSection = [wrapper.indexPathsMapping sectionBeforeWrappingForSectionAfterWrapping:section];
    NSInteger numberOfSections = [dataSource numberOfSectionsInTableView:(UITableView *)wrapper];
    numberOfSections = numberOfSections == 0? 1: numberOfSections;
    NSAssert(localSection < numberOfSections, @"local section is out of bounds for composed data source");

    return [dataSource tableView:(UITableView *)wrapper numberOfRowsInSection:localSection];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<UITableViewDataSource> dataSource = [self tableViewDataSourceForIndexPath:indexPath];
    COOLTableViewWrapper *wrapper = [self wrapperForTableView:tableView indexPath:indexPath];
    NSIndexPath *localIndexPath = [self wrapper:wrapper indexPathForIndexPath:indexPath];
    return [dataSource tableView:(UITableView *)wrapper cellForRowAtIndexPath:localIndexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<UITableViewDelegate> dataSource = [self tableViewDataSourceForIndexPath:indexPath];
    if ([dataSource respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        COOLTableViewWrapper *wrapper = [self wrapperForTableView:tableView indexPath:indexPath];
        NSIndexPath *localIndexPath = [self wrapper:wrapper indexPathForIndexPath:indexPath];
        [dataSource tableView:(UITableView *)wrapper didSelectRowAtIndexPath:localIndexPath];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"header";
}

- (void)registerReusableViewsInTableView:(UITableView *)tableView
{
    for (id<COOLTableViewDisplayDataSource> object in self.dataSources) {
        [object registerReusableViewsInTableView:tableView];
    }
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    COOLIndexPathsMapping *mapping = [self mappingForSectionAtIndex:indexPath.section];
    id<COOLTableViewDisplayDataSource> dataSource = [self tableViewDisplayDataSourceForIndexPath:indexPath];
    NSIndexPath *mappedIndexPath = [mapping indexPathBeforeWrappingForIndexPathAfterWrapping:indexPath];;
    return [dataSource itemAtIndexPath:mappedIndexPath];
}

- (NSArray *)itemsInSectionAtIndex:(NSInteger)section
{
    COOLIndexPathsMapping *mapping = [self mappingForSectionAtIndex:section];
    id<COOLTableViewDisplayDataSource> dataSource = [self tableViewDisplayDataSourceForSection:section];
    NSInteger mappedSection = [mapping sectionBeforeWrappingForSectionAfterWrapping:section];
    return [dataSource itemsInSectionAtIndex:mappedSection];
}

#pragma mark - Private

- (id<UITableViewDataSourceDelegate>)tableViewDataSourceForSection:(NSInteger)section
{
    id<UITableViewDataSourceDelegate> dataSource = self.sectionsToDataSources[@(section)];
    return dataSource;
}

- (id<UITableViewDataSourceDelegate>)tableViewDataSourceForIndexPath:(NSIndexPath *)indexPath
{
    return [self tableViewDataSourceForSection:indexPath.section];
}

- (id<COOLTableViewDisplayDataSource>)tableViewDisplayDataSourceForSection:(NSInteger)section
{
    return (id<COOLTableViewDisplayDataSource>)[self tableViewDataSourceForSection:section];
}

- (id<COOLTableViewDisplayDataSource>)tableViewDisplayDataSourceForIndexPath:(NSIndexPath *)indexPath
{
    return [self tableViewDisplayDataSourceForSection:indexPath.section];
}


- (COOLTableViewWrapper *)wrapperForTableView:(UITableView *)tableView section:(NSInteger)section
{
    COOLIndexPathsMapping *mapping = [self mappingForSectionAtIndex:section];
    COOLTableViewWrapper *wrapper = [COOLTableViewWrapper wrapperFor:tableView];
    wrapper.indexPathsMapping = mapping;
    return wrapper;
}

- (COOLTableViewWrapper *)wrapperForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    COOLIndexPathsMapping *mapping = [self mappingForSectionAtIndex:indexPath.section];
    COOLTableViewWrapper *wrapper = [COOLTableViewWrapper wrapperFor:tableView];
    wrapper.indexPathsMapping = mapping;
    return wrapper;
}

- (NSIndexPath *)wrapper:(COOLTableViewWrapper *)wrapper indexPathForIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *localIndexPath = [wrapper.indexPathsMapping indexPathBeforeWrappingForIndexPathAfterWrapping:indexPath];
    return localIndexPath;
}

- (void)updateMappings
{
    self.sectionsCount = 0;
    [self.sectionsToDataSources removeAllObjects];
    [self.sectionsToMappings removeAllObjects];

    for (NSUInteger idx = 0; idx < self.mappings.count; idx++) {
        COOLIndexPathsMapping *mapping = self.mappings[idx];
        id dataSource = self.dataSources[idx];
        NSInteger newSectionCount = [mapping updateWithSectionsCount:mapping.sectionsCount startingWithSectionAtIndex:self.sectionsCount];
        while (self.sectionsCount < newSectionCount) {
            self.sectionsToMappings[@(self.sectionsCount)] = mapping;
            self.sectionsToDataSources[@(self.sectionsCount)] = dataSource;
            self.sectionsCount++;
        }
    }
}

- (COOLIndexPathsMapping *)mappingForSectionAtIndex:(NSInteger)sectionIndex
{
    COOLIndexPathsMapping *mapping = self.sectionsToMappings[@(sectionIndex)];
    return mapping;
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
