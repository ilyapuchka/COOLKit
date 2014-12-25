//
//  COOLLoadableContentView.m
//  COOLKit
//
//  Created by Ilya Puchka on 25.12.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLLoadableContentView.h"

@interface COOLLoadableContentView()

@property (nonatomic, strong) COOLLoadingStateMachine *stateMachine;

@end

@implementation COOLLoadableContentView

- (COOLStateMachine *)stateMachine
{
    if (!_stateMachine) {
        _stateMachine = [COOLLoadingStateMachine new];
        _stateMachine.delegate = self;
        _contentView.alpha = 0.0f;
    }
    return _stateMachine;
}

- (UIView<COOLLoadingSupplementaryView> *)loadingSupplementaryView
{
    if (!_loadingSupplementaryView) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.color = [UIColor lightGrayColor];
        _loadingSupplementaryView = (UIView<COOLLoadingSupplementaryView> *)activityView;
        [_loadingSupplementaryView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_loadingSupplementaryView];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_loadingSupplementaryView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_loadingSupplementaryView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    }
    return _loadingSupplementaryView;
}

#pragma mark - Animations

- (void)animateViewAppear:(UIView *)view
{
    [self animateViewAppear:view completion:nil];
}

- (void)animateViewAppear:(UIView *)view completion:(void (^)(BOOL finished))completion
{
    [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        view.alpha = 1.0f;
    } completion:completion];
}

- (void)animateViewDissapear:(UIView *)view
{
    [self animateViewDissapear:view completion:nil];
}

- (void)animateViewDissapear:(UIView *)view completion:(void (^)(BOOL finished))completion
{
    [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        view.alpha = 0.0f;
    } completion:completion];
}

#pragma mark - COOLStateMachineDelegate

- (void)willEnterLoadingState
{
    [self.loadingSupplementaryView startAnimating];
    [self animateViewAppear:self.loadingSupplementaryView];
}

- (void)willExitLoadingState
{
    [self animateViewDissapear:self.loadingSupplementaryView completion:^(BOOL finished) {
        [self.loadingSupplementaryView stopAnimating];
    }];
}

- (void)willEnterLoadedState
{
    [self animateViewAppear:self.contentView];
}

- (void)willExitLoadedState
{
}

- (void)stateWillChangeFromLoadedStateToLoadingState
{
    [self animateViewDissapear:self.contentView];
}

- (void)willEnterNoContentState
{
    [self animateViewAppear:self.noContentSupplementaryView];
}

- (void)willExitNoContentState
{
    [self animateViewDissapear:self.noContentSupplementaryView];
}

- (void)willEnterErrorState
{
    [self animateViewAppear:self.errorSupplementaryView];
}

- (void)willExitErrorState
{
    [self animateViewDissapear:self.errorSupplementaryView];
}

- (void)beginUpdateContent
{
    NSString *loadingState;
    if ([self.loadingState isEqualToString:COOLLoadingStateInitial] ||
        [self.loadingState isEqualToString:COOLLoadingStateLoadingContent]) {
        loadingState = COOLLoadingStateLoadingContent;
    }
    else if ([self.loadingState isEqualToString:COOLLoadingStateRefreshingContent]) {
        loadingState = COOLLoadingStateRefreshingContent;
    }
    else {
        loadingState = COOLStateUndefined;
    }
    self.loadingState = loadingState;
}

- (void)endUpdateContentWithNewState:(NSString *)state
{
    self.loadingState = state;
}

- (NSString *)nextStateForCurrentLoadingState:(NSString *)currentState
{
    return COOLLoadingStateLoadingContent;
}

- (NSString *)loadingState
{
    if (!_stateMachine)
        return COOLLoadingStateInitial;
    return _stateMachine.currentState;
}

- (void)setLoadingState:(NSString *)loadingState
{
    COOLStateMachine *stateMachine = self.stateMachine;
    if (loadingState != stateMachine.currentState) {
        [self willChangeValueForKey:@"loadingState"];
        stateMachine.currentState = loadingState;
        [self didChangeValueForKey:@"loadingState"];
    }
}

- (NSString *)missingTransitionFromState:(NSString *)fromState toState:(NSString *)toState
{
    if ([toState isEqualToString:COOLStateUndefined]) {
        if ([self.delegate respondsToSelector:@selector(nextStateForCurrentLoadingState:)]) {
            return [self.delegate nextStateForCurrentLoadingState:fromState];
        }
        else {
            return [self nextStateForCurrentLoadingState:fromState];
        }
    }
    return toState;
}

@end
