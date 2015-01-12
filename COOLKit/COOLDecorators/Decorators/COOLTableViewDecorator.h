//
//  COOLTableViewDecorator.h
//  COOLKit
//
//  Created by Ilya Puchka on 09.12.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "COOLTableViewDataSourceDelegate.h"
#import "UITableView+Decoration.h"

@protocol COOLTableViewDecorator <COOLTableViewDataSourceDelegate>

- (void)decorateView:(UITableView *)view;

@property (nonatomic, strong, readonly) UITableView *decoratedView;
@property (nonatomic, weak, readonly) id<UITableViewDataSource> decoratedDataSource;
@property (nonatomic, weak, readonly) id<UITableViewDelegate> decoratedDelegate;

- (void)beginUpdates;
- (void)endUpdates;

@end
