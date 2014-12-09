//
//  COOLTableViewDecorator.h
//  COOLKit
//
//  Created by Ilya Puchka on 09.12.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol COOLTableViewDecorator <NSObject, UITableViewDelegate, UITableViewDataSource>

- (void)decorateView:(UITableView *)view;

@property (nonatomic, strong, readonly) UITableView *decoratedView;
@property (nonatomic, weak, readonly) id<UITableViewDataSource> decoratedDataSource;
@property (nonatomic, weak, readonly) id<UITableViewDelegate> decoratedDelegate;

@end
