//
//  COOLLoadingStateMachine.h
//  CoolEvents
//
//  Created by Ilya Puchka on 08.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLStateMachine.h"

/// The initial state.
static NSString *const COOLLoadingStateInitial = @"Initial";

/// The first load of content.
static NSString *const COOLLoadingStateLoadingContent = @"LoadingState";

/// Subsequent loads after the first.
static NSString *const COOLLoadingStateRefreshingContent = @"RefreshingState";

/// After content is loaded successfully.
static NSString *const COOLLoadingStateContentLoaded = @"LoadedState";

/// No content is available.
static NSString *const COOLLoadingStateNoContent = @"NoContentState";

/// An error occurred while loading content.
static NSString *const COOLLoadingStateError = @"ErrorState";

//static NSString * const COOLLoadingStateCancelled= @"CancelledState";

@interface COOLLoadingStateMachine : COOLStateMachine

@property (weak, atomic) IBOutlet id<COOLStateMachineDelegate> delegate;

@end
