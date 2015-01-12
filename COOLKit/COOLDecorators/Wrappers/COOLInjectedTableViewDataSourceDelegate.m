//
//  COOLInjectTableViewDataSourceDelegate.m
//  COOLKit
//
//  Created by Ilya Puchka on 02.01.15.
//  Copyright (c) 2015 Ilya Puchka. All rights reserved.
//

#import "COOLInjectedTableViewDataSourceDelegate.h"
#import "COOLInjecedtIndexPathsMapping.h"

@interface COOLInjectedTableViewDataSourceDelegate()

@property (nonatomic, strong) COOLInjecedtIndexPathsMapping *originalItemsMapping;
@property (nonatomic, strong) COOLInjecedtIndexPathsMappingForInjectedItems *injectedItemsMapping;

@end

@implementation COOLInjectedTableViewDataSourceDelegate

- (instancetype)initWithDataSource:(id<COOLTableViewDataSourceDelegate>)dataSource injectedDataSource:(id<COOLTableViewInjectDataSource>)injectedDataSource
{
    self = [super init];
    if (self) {
        self.dataSource = dataSource;
        self.injectedDataSource = injectedDataSource;
    }
    return self;
}

- (void)setInjectedDataSource:(id<COOLTableViewInjectDataSource>)injectedDataSource
{
    _injectedDataSource = injectedDataSource;
    if (injectedDataSource) {
        COOLInjecedtIndexPathsMappingForInjectedItems *mapping = [[COOLInjecedtIndexPathsMappingForInjectedItems alloc] init];
        self.injectedItemsMapping = mapping;
    }
    else {
        self.injectedItemsMapping = nil;
    }
}

- (void)setDataSource:(id<COOLTableViewDataSourceDelegate>)dataSource
{
    _dataSource = dataSource;
    if (dataSource) {
        COOLInjecedtIndexPathsMapping *mapping = [[COOLInjecedtIndexPathsMapping alloc] init];
        self.originalItemsMapping = mapping;
    }
    else {
        self.originalItemsMapping = nil;
    }
}

- (void)updateMappingsWithTableView:(UITableView *)tableView
{
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        self.sectionsCount = [self.dataSource numberOfSectionsInTableView:tableView];
    }
    else {
        self.sectionsCount = 1;
    }
    NSInteger offset = [self.injectedDataSource tableViewInjectOffset:tableView];
    NSInteger step = [self.injectedDataSource tableViewInjectStep:tableView];
    
    [self updateOrigialItemsMappingWithTableView:tableView offset:offset step:step];
    [self updateInjectedItemsMappingWithTableView:tableView offset:offset step:step];
}

- (void)updateOrigialItemsMappingWithTableView:(UITableView *)tableView offset:(NSInteger)offset step:(NSInteger)step
{
    [self.originalItemsMapping updateWithSectionsCount:self.sectionsCount offset:offset step:step];
    for (NSInteger section = 0; section < self.sectionsCount; section++) {
        NSInteger rowsCount = [self.dataSource tableView:tableView numberOfRowsInSection:section];
        [self.originalItemsMapping setNumberOfRows:rowsCount inSection:section];
    }
}

- (void)updateInjectedItemsMappingWithTableView:(UITableView *)tableView offset:(NSInteger)offset step:(NSInteger)step
{
    [self.injectedItemsMapping updateWithSectionsCount:self.sectionsCount offset:offset step:step];
    for (NSInteger section = 0; section < self.sectionsCount; section++) {
        NSInteger rowsCount = [self.dataSource tableView:tableView numberOfRowsInSection:section];
        [self.injectedItemsMapping setNumberOfRows:rowsCount inSection:section];
    }
}

- (id<COOLTableViewDataSourceDelegate>)tableViewDataSourceForSection:(NSInteger)section
{
    return self.dataSource;
}

- (id<COOLTableViewDataSourceDelegate>)tableViewDataSourceForIndexPath:(NSIndexPath *)indexPath
{
    COOLInjecedtIndexPathsMapping *mapping = [self mappingForIndexPath:indexPath];
    if ([mapping isInjectItemAtIndexPath:indexPath]) {
        return self.injectedDataSource;
    }
    else {
        return self.dataSource;
    }
}

- (id<COOLIndexPathsMapping>)mappingForSection:(NSInteger)section
{
    //set nil mapping 'cause sections contains both original and inserted cells
    //so no need to map index paths, operations should be performed on section at all
    //or either on original or inserted cells in this section
    return nil;
}

- (id<COOLIndexPathsMapping>)mappingForIndexPath:(NSIndexPath *)indexPath
{
    if ([self.originalItemsMapping isInjectItemAtIndexPath:indexPath]) {
        return self.injectedItemsMapping;
    }
    else {
        return self.originalItemsMapping;
    }
}

#pragma mark - UITableViewDisplayDataSource

- (void)registerReusableViewsInTableView:(UITableView *)tableView
{
    if ([self.dataSource respondsToSelector:@selector(registerReusableViewsInTableView:)]) {
        [self.dataSource registerReusableViewsInTableView:tableView];
    }
    if ([self.injectedDataSource respondsToSelector:@selector(registerReusableViewsInTableView:)]) {
        [self.injectedDataSource registerReusableViewsInTableView:tableView];
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
    NSNumber *numberOfRows;
    [self performOnTableView:tableView inSection:section block:^(id<COOLTableViewDataSourceDelegate> aDataSource, UITableView *_tableView, NSInteger _section, __autoreleasing id *result) {
        NSInteger _numberOfRows = [aDataSource tableView:_tableView numberOfRowsInSection:_section];
        COOLInjecedtIndexPathsMapping *mapping = [(COOLTableViewWrapper *)_tableView indexPathsMapping];
        NSInteger insertedItemsCount = [mapping countOfInsertedItemsInSection:_section];
        _numberOfRows += insertedItemsCount;
        *result = @(_numberOfRows);
    } result:&numberOfRows];
    return [numberOfRows integerValue];
}

@end
