//
//  COOLComposedTableViewDataSource.h
//  CoolEvents
//
//  Created by Ilya Puchka on 16.11.14.
//  Copyright (c) 2014 CoolConnections. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "COOLComposition.h"
#import "COOLWrappedTableViewDataSourceDelegate.h"

//Class for composing number of table view data sources and delegates. Data sources are organized in array. Table view data is displayed according to data sources order.
@interface COOLComposedTableViewDataSourceDelegate : COOLWrappedTableViewDataSourceDelegate {
    id<COOLComposition> _dataSources;
    NSArray *_objects;
}

//dataSources should implement COOLTableViewDisplayDataSource
- (instancetype)initWithDataSources:(NSArray *)dataSources NS_DESIGNATED_INITIALIZER;

- (void)addDataSource:(id<COOLTableViewDisplayDataSource>)dataSource;
- (void)removeDataSource:(id)dataSource;

@property (nonatomic, strong) NSMutableArray *mappings;
@property (nonatomic, strong) NSMutableDictionary *sectionsToMappings;
@property (nonatomic) NSInteger sectionsCount;

@end
