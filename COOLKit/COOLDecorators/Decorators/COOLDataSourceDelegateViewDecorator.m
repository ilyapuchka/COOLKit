//
//  COOLDataSourceDelegateDecorator.m
//  COOLKit
//
//  Created by Ilya Puchka on 02.01.15.
//  Copyright (c) 2015 Ilya Puchka. All rights reserved.
//

#import "COOLDataSourceDelegateViewDecorator.h"

@interface COOLDataSourceDelegateViewDecorator()

@property (nonatomic, weak) COOLWrapper *dataSourceWrapper;
@property (nonatomic, weak) COOLWrapper *delegateWrapper;

@end

@implementation COOLDataSourceDelegateViewDecorator

+ (instancetype)wrapperFor:(UIView<COOLDataSourceDelegateView> *)view
{
    COOLDataSourceDelegateViewDecorator *decorator = [super wrapperFor:view];
    
    view.delegate = decorator.delegateWrapper;
    view.dataSource = decorator.dataSourceWrapper;
    
    return decorator;
}

- (COOLWrapper *)dataSourceWrapper
{
    return nil;
}

- (COOLWrapper *)delegateWrapper
{
    return nil;
}

- (void)unwrap
{
    self.wrappedObject.dataSource = self.dataSourceWrapper.wrappedObject;
    [self.dataSourceWrapper unwrap];
    self.dataSourceWrapper = nil;

    self.wrappedObject.delegate = self.delegateWrapper.wrappedObject;
    [self.delegateWrapper unwrap];
    self.delegateWrapper = nil;
    
    [super unwrap];
}

+ (Class)wrappedClass
{
    return [UIView class];
}

- (UIView<COOLDataSourceDelegateView> *)wrappedObject
{
    return (UIView<COOLDataSourceDelegateView> *)[super wrappedObject];
}

@end

@implementation COOLTableViewDecorator

+ (instancetype)wrapperFor:(UITableView *)view
{
    return [super wrapperFor:(UIView<COOLDataSourceDelegateView> *)view];
}

+ (Class)wrappedClass
{
    return [UITableView class];
}

- (UITableView *)wrappedObject
{
    return (UITableView *)[super wrappedObject];
}

- (COOLWrapper<UITableViewDelegate> *)delegateWrapper
{
    return (COOLWrapper<UITableViewDelegate> *)[super delegateWrapper];
}

- (COOLWrapper<UITableViewDataSource> *)dataSourceWrapper
{
    return (COOLWrapper<UITableViewDataSource> *)[super dataSourceWrapper];
}

@end
