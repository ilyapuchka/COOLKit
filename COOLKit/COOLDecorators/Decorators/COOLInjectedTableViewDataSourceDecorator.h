//
//  COOLInjectTableViewDataSourceDecorator.h
//  COOLKit
//
//  Created by Ilya Puchka on 01.01.15.
//  Copyright (c) 2015 Ilya Puchka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "COOLListViewDecorator.h"
#import "COOLTableViewDecorator.h"

@interface COOLInjectedTableViewDataSourceDecorator : COOLListViewDecorator <COOLTableViewDecorator>

@property (nonatomic, assign, readonly) NSInteger offset;
@property (nonatomic, assign, readonly) NSInteger step;

- (instancetype)initWithOffset:(NSInteger)offset step:(NSInteger)step;

- (NSInteger)injectItemIndexForIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)injectItemIndexPathForIndex:(NSInteger)index inSection:(NSInteger)section;

- (NSInteger)countOfInsertedItemsInSectionAtIndex:(NSInteger)section;

- (UITableViewCell *)tableView:(UITableView *)tableView injectCellForIndexPath:(NSIndexPath *)indexPath;
- (BOOL)isInjectItemAtIndexPath:(NSIndexPath *)indexPath;

@end
