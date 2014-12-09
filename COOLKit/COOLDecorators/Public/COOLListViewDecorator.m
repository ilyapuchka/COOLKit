//
//  COOLListViewDecorator.m
//  COOLDecorators
//
//  Created by Ilya Puchka on 13.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLListViewDecorator.h"
#import <UIKit/UIKit.h>
#import "COOLTableViewDecorator.h"
#import "COOLCollectionViewDecorator.h"

@interface UITableView(COOLListView)<COOLListView>
@end
@implementation UITableView(COOLListView)
@end

@interface UICollectionView(COOLListView)<COOLListView>
@end
@implementation UICollectionView(COOLListView)
@end

@interface COOLListViewDecorator()

@property (nonatomic, strong, readwrite) UIView<COOLListView> *decoratedView;
@property (nonatomic, weak, readwrite) id<UITableViewDataSource> decoratedDataSource;
@property (nonatomic, weak, readwrite) id<UITableViewDelegate> decoratedDelegate;

@end

static void *RMCDelegateObservationContext = &RMCDelegateObservationContext;
static void *RMCDatasourceObservationContext = &RMCDatasourceObservationContext;
static NSString *const RMCDelegateKeyPath = @"delegate";
static NSString *const RMCDataSourceKeyPath = @"dataSource";

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wprotocol"
@implementation COOLListViewDecorator
#pragma clang diagnostic pop

- (void)decorateView:(UIView<COOLListView> *)view
{
    NSCParameterAssert(view);
    
    BOOL shouldAddObservers = self.decoratedView != view;
    
    self.decoratedView = view;
    if (shouldAddObservers) {
        NSKeyValueObservingOptions options = NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew;
        [view addObserver:self forKeyPath:RMCDataSourceKeyPath options:options context:RMCDatasourceObservationContext];
        [view addObserver:self forKeyPath:RMCDelegateKeyPath options:options context:RMCDelegateObservationContext];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == RMCDelegateObservationContext || context == RMCDatasourceObservationContext) {
        if (change[NSKeyValueChangeOldKey] == self && change[NSKeyValueChangeNewKey] != self) {
            if (context == RMCDelegateObservationContext) {
                [self decorateDelegate:change[NSKeyValueChangeNewKey]];
            }
            else if (context == RMCDatasourceObservationContext) {
                [self decorateDataSource:change[NSKeyValueChangeNewKey]];
            }
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)decorateDelegate:(id)newDelegate
{
    self.decoratedDelegate = nil;
    self.decoratedDelegate = newDelegate;
    self.decoratedView.delegate = self;
}

- (void)decorateDataSource:(id)newDataSource
{
    self.decoratedDataSource = nil;
    self.decoratedDataSource = newDataSource;
    self.decoratedView.dataSource = self;
}

- (void)dealloc
{
    [_decoratedView removeObserver:self forKeyPath:RMCDelegateKeyPath context:RMCDelegateObservationContext];
    [_decoratedView removeObserver:self forKeyPath:RMCDataSourceKeyPath context:RMCDatasourceObservationContext];
    _decoratedView.delegate = _decoratedDelegate;
    _decoratedView.dataSource = _decoratedDataSource;
}

#pragma mark - Invocations forwarding

- (BOOL)isKindOfClass:(Class)aClass
{
    BOOL isKindOfClass;
    if (!(isKindOfClass = [super isKindOfClass:aClass])) {
        if (!(isKindOfClass = [self.decoratedDataSource isKindOfClass:aClass])) {
            isKindOfClass = [self.decoratedDelegate isKindOfClass:aClass];
        }
    }
    return isKindOfClass;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    BOOL respondsToSelector;
    if (!(respondsToSelector = [super respondsToSelector:aSelector])) {
        if (!(respondsToSelector = [self.decoratedDataSource respondsToSelector:aSelector])) {
            respondsToSelector = [self.decoratedDelegate respondsToSelector:aSelector];
        }
    }
    return respondsToSelector;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    id forwardingTargetForSelector = nil;
    if ([self.decoratedDataSource respondsToSelector:aSelector]) {
        forwardingTargetForSelector = self.decoratedDataSource;
    }
    else if ([self.decoratedDelegate respondsToSelector:aSelector]) {
        forwardingTargetForSelector = self.decoratedDelegate;
    }
    return forwardingTargetForSelector;
}

@end
