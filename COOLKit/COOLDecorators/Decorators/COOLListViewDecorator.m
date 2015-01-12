//
//  COOLListViewDecorator.m
//  COOLDecorators
//
//  Created by Ilya Puchka on 13.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLListViewDecorator.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#import "COOLTableViewDecorator.h"

static void *COOLDelegateObservationContext = &COOLDelegateObservationContext;
static void *COOLDatasourceObservationContext = &COOLDatasourceObservationContext;
static NSString *const COOLDelegateKeyPath = @"delegate";
static NSString *const COOLDataSourceKeyPath = @"dataSource";


@implementation UITableView(COOLListView)

- (COOLListViewDecorator *)decorator
{
    return objc_getAssociatedObject(self, @selector(decorator));
}

- (void)setDecorator:(COOLListViewDecorator *)decorator
{
    if (decorator == nil) {
        @try {
            [[decorator decoratedView] removeObserver:self forKeyPath:COOLDelegateKeyPath context:COOLDelegateObservationContext];
            [[decorator decoratedView] removeObserver:self forKeyPath:COOLDataSourceKeyPath context:COOLDatasourceObservationContext];
        }
        @catch (NSException *exception) {
        }
    }
    objc_setAssociatedObject(self, @selector(decorator), decorator, OBJC_ASSOCIATION_ASSIGN);
}

@end

@implementation UICollectionView(COOLListView)

- (COOLListViewDecorator *)decorator
{
    return objc_getAssociatedObject(self, @selector(decorator));
}

- (void)setDecorator:(COOLListViewDecorator *)decorator
{
    if (decorator == nil) {
        @try {
            [[decorator decoratedView] removeObserver:self forKeyPath:COOLDelegateKeyPath context:COOLDelegateObservationContext];
            [[decorator decoratedView] removeObserver:self forKeyPath:COOLDataSourceKeyPath context:COOLDatasourceObservationContext];
        }
        @catch (NSException *exception) {
        }
    }
    objc_setAssociatedObject(self, @selector(decorator), decorator, OBJC_ASSOCIATION_ASSIGN);
}

@end

@interface COOLListViewDecorator()

@property (nonatomic, weak, readwrite) UIView<COOLListView> *decoratedView;
@property (nonatomic, weak, readwrite) id decoratedDataSource;
@property (nonatomic, weak, readwrite) id decoratedDelegate;

@end

@implementation COOLListViewDecorator

- (void)decorateView:(UIView<COOLListView> *)view
{
    NSCParameterAssert(view);
    
    BOOL shouldAddObservers = self.decoratedView != view;
    
    if (shouldAddObservers) {
        NSKeyValueObservingOptions options = NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew;
        [view addObserver:self forKeyPath:COOLDataSourceKeyPath options:options context:COOLDatasourceObservationContext];
        [view addObserver:self forKeyPath:COOLDelegateKeyPath options:options context:COOLDelegateObservationContext];
    }
    
    self.decoratedView = view;
    
    if (self.decoratedView.dataSource) {
        id decoratedDataSource = self.decoratedView.dataSource;
        self.decoratedDataSource = nil;
        self.decoratedView.dataSource = self;
        self.decoratedDataSource = decoratedDataSource;
    }
    if (self.decoratedView.delegate) {
        id decoratedDelegate = self.decoratedView.delegate;
        self.decoratedDelegate = nil;
        self.decoratedView.delegate = self;
        self.decoratedDelegate = decoratedDelegate;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == COOLDelegateObservationContext || context == COOLDatasourceObservationContext) {
        if ((change[NSKeyValueChangeOldKey] == self || change[NSKeyValueChangeOldKey] == [NSNull null]) && change[NSKeyValueChangeNewKey] != self) {
            if (context == COOLDelegateObservationContext) {
                [self decorateDelegate:change[NSKeyValueChangeNewKey]];
            }
            else if (context == COOLDatasourceObservationContext) {
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
    
    [self setNeedsUpdate];
}

- (void)decorateDataSource:(id)newDataSource
{
    self.decoratedDataSource = nil;
    self.decoratedDataSource = newDataSource;
    self.decoratedView.dataSource = self;
    
    [self setNeedsUpdate];
}

- (void)dealloc
{
    @try {
        [_decoratedView removeObserver:self forKeyPath:COOLDelegateKeyPath context:COOLDelegateObservationContext];
        [_decoratedView removeObserver:self forKeyPath:COOLDataSourceKeyPath context:COOLDatasourceObservationContext];
    }
    @catch (NSException *exception) {
    }
    
    _decoratedView.delegate = _decoratedDelegate;
    _decoratedView.dataSource = _decoratedDataSource;
    _decoratedView.decorator = nil;
    _decoratedDataSource = nil;
    _decoratedDelegate = nil;
    _decoratedView = nil;
}

- (void)setNeedsUpdate
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadData) object:nil];
    [self performSelector:@selector(reloadData) withObject:nil afterDelay:0];
}

- (void)reloadData
{
}

- (void)beginUpdates
{
}

- (void)endUpdates
{
}

- (NSIndexPath *)indexPathForDecoratedIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

- (NSIndexPath *)decoretedIndexPathForIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
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
