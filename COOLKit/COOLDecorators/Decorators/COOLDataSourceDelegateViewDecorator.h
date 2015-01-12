//
//  COOLDataSourceDelegateDecorator.h
//  COOLKit
//
//  Created by Ilya Puchka on 02.01.15.
//  Copyright (c) 2015 Ilya Puchka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "COOLWrapper.h"
#import "COOLIndexPathsMapping.h"

@protocol COOLDataSourceDelegateView <NSObject>

@property (nonatomic, weak) id delegate;
@property (nonatomic, weak) id dataSource;

@end

@interface COOLDataSourceDelegateViewDecorator : COOLWrapper

+ (instancetype)wrapperFor:(UIView<COOLDataSourceDelegateView> *)view;

- (COOLWrapper *)dataSourceWrapper;
- (COOLWrapper *)delegateWrapper;

- (UIView<COOLDataSourceDelegateView> *)wrappedObject;

@property (nonatomic, strong) id<COOLIndexPathsMapping> indexPathsMapping;

@end

@interface COOLTableViewDecorator: COOLDataSourceDelegateViewDecorator

+ (instancetype)wrapperFor:(UITableView *)view;

- (COOLWrapper<UITableViewDataSource> *)dataSourceWrapper;
- (COOLWrapper<UITableViewDelegate> *)delegateWrapper;

- (UITableView *)wrappedObject;

@end