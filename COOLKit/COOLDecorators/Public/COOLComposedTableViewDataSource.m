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
    NSInteger numberOfSections = [[self performAndReturnOnTableView:tableView inSection:section block:^id(id<UITableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSInteger _section) {
        NSInteger _numberOfSections = [_dataSource tableView:_tableView numberOfRowsInSection:_section];
        _numberOfSections = _numberOfSections == 0? 1: _numberOfSections;
        NSAssert(_section < _numberOfSections, @"local section is out of bounds for composed data source");
        return @(_numberOfSections);
    }] integerValue];
    return numberOfSections;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self performAndReturnOnTableView:tableView atIndexPath:indexPath block:^id(id<UITableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSIndexPath *_indexPath) {
        return [_dataSource tableView:_tableView cellForRowAtIndexPath:_indexPath];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performOnTableView:tableView atIndexPath:indexPath block:^(id<UITableViewDataSourceDelegate> _delegate, UITableView *_tableView, NSIndexPath *_indexPath) {
        if ([_delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
            [_delegate tableView:_tableView didSelectRowAtIndexPath:_indexPath];
        }
    }];
}

- (void)performOnTableView:(UITableView *)tableView inSection:(NSInteger)section block:(COOLBlockOnTableViewInSection)block
{
    [self performAndReturnOnTableView:tableView inSection:section block:^id(id<UITableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSInteger _section) {
        block(_dataSource, _tableView, _section);
        return nil;
    }];
}

- (id)performAndReturnOnTableView:(UITableView *)tableView inSection:(NSInteger)section block:(COOLReturnBlockOnTableViewInSection)block
{
    id<UITableViewDataSourceDelegate> dataSource = [self tableViewDataSourceForSection:section];
    COOLTableViewWrapper *wrapper = [self wrapperForTableView:tableView section:section];
    NSInteger localSection = [wrapper.indexPathsMapping sectionBeforeWrappingForSectionAfterWrapping:section];
    return block(dataSource, (UITableView *)wrapper, localSection);
}

- (void)performOnTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath block:(COOLBlockOnTableViewAtIndexPath)block
{
    [self performAndReturnOnTableView:tableView atIndexPath:indexPath block:^id(id<UITableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSIndexPath *_indexPath) {
        block(_dataSource, _tableView, _indexPath);
        return nil;
    }];
}

- (id)performAndReturnOnTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath block:(COOLReturnBlockOnTableViewAtIndexPath)block
{
    id<UITableViewDataSourceDelegate> dataSource = [self tableViewDataSourceForIndexPath:indexPath];
    COOLTableViewWrapper *wrapper = [self wrapperForTableView:tableView indexPath:indexPath];
    NSIndexPath *localIndexPath = [self wrapper:wrapper indexPathForIndexPath:indexPath];
    return block(dataSource, (UITableView *)wrapper, localIndexPath);
}

- (void)performOnTableView:(UITableView *)tableView
             fromIndexPath:(NSIndexPath *)fromIndexPath
               toIndexPath:(NSIndexPath *)toIndexPath
                     block:(COOLBlockOnTableViewFromIndexPathToIndexPath)block
{
    [self performAndReturnOnTableView:tableView fromIndexPath:fromIndexPath toIndexPath:toIndexPath block:^id(id<UITableViewDataSourceDelegate> _dataSource, UITableView *_tableView, NSIndexPath *_fromIndexPath, NSIndexPath *_toIndexPath) {
        block(_dataSource, _tableView, _fromIndexPath, _toIndexPath);
        return nil;
    }];
}

- (id)performAndReturnOnTableView:(UITableView *)tableView
                    fromIndexPath:(NSIndexPath *)fromIndexPath
                      toIndexPath:(NSIndexPath *)toIndexPath
                            block:(COOLReturnBlockOnTableViewFromIndexPathToIndexPath)block
{
    id<UITableViewDataSourceDelegate> dataSource = [self tableViewDataSourceForIndexPath:fromIndexPath];
    COOLTableViewWrapper *wrapper = [self wrapperForTableView:tableView indexPath:fromIndexPath];
    NSIndexPath *localFromIndexPath = [self wrapper:wrapper indexPathForIndexPath:fromIndexPath];
    NSIndexPath *localToIndexPath = [self wrapper:wrapper indexPathForIndexPath:toIndexPath];
    return block(dataSource, (UITableView *)wrapper, localFromIndexPath, localToIndexPath);
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

- (NSArray *)itemsInSection:(NSInteger)section
{
    COOLIndexPathsMapping *mapping = [self mappingForSectionAtIndex:section];
    id<COOLTableViewDisplayDataSource> dataSource = [self tableViewDisplayDataSourceForSection:section];
    NSInteger mappedSection = [mapping sectionBeforeWrappingForSectionAfterWrapping:section];
    return [dataSource itemsInSection:mappedSection];
}

- (id<UITableViewDataSourceDelegate>)tableViewDataSourceForSection:(NSInteger)section
{
    id<UITableViewDataSourceDelegate> dataSource = self.sectionsToDataSources[@(section)];
    return dataSource;
}

- (id<UITableViewDataSourceDelegate>)tableViewDataSourceForIndexPath:(NSIndexPath *)indexPath
{
    return [self tableViewDataSourceForSection:indexPath.section];
}

#pragma mark - Private

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
