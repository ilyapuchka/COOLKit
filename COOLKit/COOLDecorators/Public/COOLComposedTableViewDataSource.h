//
//  COOLComposedTableViewDataSource.h
//  CoolEvents
//
//  Created by Ilya Puchka on 16.11.14.
//  Copyright (c) 2014 CoolConnections. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "COOLComposition.h"
#import "COOLTableViewDisplayDataSource.h"
#import "COOLTableViewDelegatingWrapper.h"

@interface COOLComposedTableViewDataSource : NSObject <UITableViewDataSourceDelegate, COOLTableViewDisplayDataSource> {
    id<COOLComposition> _dataSources;
    NSArray *_objects;
}

//dataSources should be either COOLTableViewDelegatingWrapper or UITableViewDataSourceDelegate
- (instancetype)initWithDataSources:(NSArray *)dataSources NS_DESIGNATED_INITIALIZER;

- (void)addDataSource:(id)dataSource;
- (void)removeDataSource:(id)dataSource;

@end
