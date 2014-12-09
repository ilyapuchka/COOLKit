//
//  COOLLoadingStateMachine.m
//  CoolEvents
//
//  Created by Ilya Puchka on 08.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLLoadingStateMachine.h"

NSString * const COOLLoadingStateInitial = @"Initial";
NSString * const COOLLoadingStateLoadingContent = @"LoadingState";
NSString * const COOLLoadingStateRefreshingContent = @"RefreshingState";
NSString * const COOLLoadingStateContentLoaded = @"LoadedState";
NSString * const COOLLoadingStateNoContent = @"NoContentState";
NSString * const COOLLoadingStateError = @"ErrorState";

@implementation COOLLoadingStateMachine

- (instancetype)init
{
    NSDictionary *validTransitions = @{
                                       COOLLoadingStateInitial : @[COOLLoadingStateLoadingContent],
                                       COOLLoadingStateLoadingContent : @[COOLLoadingStateContentLoaded, COOLLoadingStateNoContent, COOLLoadingStateError],
                                       COOLLoadingStateRefreshingContent : @[COOLLoadingStateContentLoaded, COOLLoadingStateNoContent, COOLLoadingStateError],
                                       COOLLoadingStateContentLoaded : @[COOLLoadingStateRefreshingContent],
                                       COOLLoadingStateNoContent : @[COOLLoadingStateLoadingContent, COOLLoadingStateRefreshingContent],
                                       COOLLoadingStateError : @[COOLLoadingStateLoadingContent, COOLLoadingStateRefreshingContent]
                                       };
    
    self = [super initWithValidTransitions:validTransitions];
    if (self) {
        self.currentState = COOLLoadingStateInitial;
    }
    return self;
}


@end
