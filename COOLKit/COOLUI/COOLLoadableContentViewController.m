//
//  COOLLoadableContentViewController.m
//  COOLKit
//
//  Created by Ilya Puchka on 25.12.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLLoadableContentViewController.h"

@interface COOLLoadableContentViewController ()

@end

@implementation COOLLoadableContentViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)loadView
{
    if ([self nibName]) {
        return [super loadView];
    }
    else {
        [self setView:self.loadableContentView];
    }
}

- (void)setLoadableContentView:(COOLLoadableContentView *)loadableContentView
{
    [self setView:loadableContentView];
}

- (void)setView:(COOLLoadableContentView *)view
{
    if (![view isKindOfClass:[COOLLoadableContentView class]]) {
        [NSException raise:NSInvalidArgumentException format:@"COOLLoadableContentViewController root view should be COOLLoadableContentView or it's subclass"];
    }
    
    [super setView:view];
    _loadableContentView = view;
}

@end
