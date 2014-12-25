//
//  COOLLoadingStateMachine.m
//  CoolEvents
//
//  Created by Ilya Puchka on 08.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLLoadingStateMachine.h"

@implementation COOLLoadingStateMachine

- (instancetype)init
{
    NSDictionary *validTransitions = @{
                                       COOLLoadingStateInitial : @[COOLLoadingStateLoadingContent],
                                       COOLLoadingStateLoadingContent : @[COOLLoadingStateContentLoaded, COOLLoadingStateNoContent, COOLLoadingStateError, /*COOLLoadingStateCancelled*/],
                                       COOLLoadingStateRefreshingContent : @[COOLLoadingStateContentLoaded, COOLLoadingStateNoContent, COOLLoadingStateError, /*COOLLoadingStateCancelled*/],
                                       COOLLoadingStateContentLoaded : @[COOLLoadingStateRefreshingContent],
                                       COOLLoadingStateNoContent : @[COOLLoadingStateLoadingContent, COOLLoadingStateRefreshingContent],
                                       COOLLoadingStateError : @[COOLLoadingStateLoadingContent, COOLLoadingStateRefreshingContent],
                                       /*COOLLoadingStateCancelled: @[COOLLoadingStateLoadingContent, COOLLoadingStateRefreshingContent]*/
                                       };
    
    self = [super initWithValidTransitions:validTransitions];
    if (self) {
        self.currentState = COOLLoadingStateInitial;
    }
    return self;
}


@end
