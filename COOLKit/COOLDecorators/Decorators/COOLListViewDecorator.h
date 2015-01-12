//
//  COOLListViewDecorator.h
//  COOLDecorators
//
//  Created by Ilya Puchka on 13.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import <UIKit/UIKit.h>

@class COOLListViewDecorator;

@protocol COOLListView <NSObject>

@property (nonatomic, weak) id delegate;
@property (nonatomic, weak) id dataSource;

- (void)reloadData;

@property (nonatomic, assign) COOLListViewDecorator *decorator;

@end

@interface COOLListViewDecorator : NSObject

- (void)decorateView:(UIView<COOLListView> *)view;

@property (nonatomic, weak, readonly) UIView<COOLListView> *decoratedView;
@property (nonatomic, weak, readonly) id decoratedDataSource;
@property (nonatomic, weak, readonly) id decoratedDelegate;

- (void)reloadData;
- (void)setNeedsUpdate;
- (void)beginUpdates;
- (void)endUpdates;

- (NSIndexPath *)indexPathForDecoratedIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)decoretedIndexPathForIndexPath:(NSIndexPath *)indexPath;

@end
