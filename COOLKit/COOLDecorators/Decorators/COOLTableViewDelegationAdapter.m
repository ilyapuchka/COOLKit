//
//  COOLTableViewDelegationDecorator.m
//  COOLDecorators
//
//  Created by Ilya Puchka on 15.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLTableViewDelegationAdapter.h"
#import "COOLComposition.h"

@interface COOLTableViewDelegationAdapter()

@property (nonatomic, strong) COOLComposition *composition;

@end

@implementation COOLTableViewDelegationAdapter

@synthesize displayDataSource = _displayDataSource;
@synthesize eventsResponder = _eventsResponder;
@synthesize scrollDelegate = _scrollDelegate;
@synthesize editingDelegate = _editingDelegate;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.composition = [COOLComposition new];
    }
    return self;
}

- (void)setDisplayDataSource:(id<COOLTableViewDisplayDataSource>)displayDataSource
{
    [self.composition removeObject:_displayDataSource];
    _displayDataSource = displayDataSource;
    if (_displayDataSource) [self.composition addObject:_displayDataSource];
}

- (void)setEventsResponder:(id<COOLTableViewEventsResponder>)eventsResponder
{
    [self.composition removeObject:_eventsResponder];
    _eventsResponder = eventsResponder;
    if (_eventsResponder) [self.composition addObject:_eventsResponder];
}

- (void)setScrollDelegate:(id<UIScrollViewDelegate>)scrollDelegate
{
    [self.composition removeObject:_scrollDelegate];
    _scrollDelegate = scrollDelegate;
    if (_scrollDelegate) [self.composition addObject:_scrollDelegate];
}

- (void)setEditingDelegate:(id<COOLTableViewEditingDelegate>)editingDelegate
{
    [self.composition removeObject:_editingDelegate];
    _editingDelegate = editingDelegate;
    if (_editingDelegate) [self.composition addObject:_editingDelegate];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.displayDataSource tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.displayDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - Invocation forwarding

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return _composition;
}

- (BOOL)isKindOfClass:(Class)aClass
{
    BOOL isKindOfClass = [super isKindOfClass:aClass];
    if (!isKindOfClass) {
        return [_composition isKindOfClass:aClass];
    }
    return isKindOfClass;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    BOOL respondsToSelector = [super respondsToSelector:aSelector];
    if (!respondsToSelector) {
        return [[self forwardingTargetForSelector:aSelector] respondsToSelector:aSelector];
    }
    return respondsToSelector;
}

@end