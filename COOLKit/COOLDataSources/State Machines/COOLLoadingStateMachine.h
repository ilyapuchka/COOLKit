//
//  COOLLoadingStateMachine.h
//  CoolEvents
//
//  Created by Ilya Puchka on 08.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLStateMachine.h"

/// The initial state.
extern NSString *const COOLLoadingStateInitial;

/// The first load of content.
extern NSString *const COOLLoadingStateLoadingContent;

/// Subsequent loads after the first.
extern NSString *const COOLLoadingStateRefreshingContent;

/// After content is loaded successfully.
extern NSString *const COOLLoadingStateContentLoaded;

/// No content is available.
extern NSString *const COOLLoadingStateNoContent;

/// An error occurred while loading content.
extern NSString *const COOLLoadingStateError;

@interface COOLLoadingStateMachine : COOLStateMachine

@property (weak, atomic) IBOutlet id<COOLStateMachineDelegate> delegate;

@end
