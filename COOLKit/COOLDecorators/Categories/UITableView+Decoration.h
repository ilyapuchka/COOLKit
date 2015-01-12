//
//  UITableView+Decoration.h
//  COOLKit
//
//  Created by Ilya Puchka on 08.12.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "COOLListViewDecorator.h"

@interface UITableView(Decoration)<COOLListView>

- (NSIndexPath *)decoratedIndexPathForIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForDecoratedIndexPath:(NSIndexPath *)indexPath;

@end