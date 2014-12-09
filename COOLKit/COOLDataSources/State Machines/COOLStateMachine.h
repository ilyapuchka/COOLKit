//
//  COOLStateMachine.h
//  CoolEvents
//
//  Created by Ilya Puchka on 08.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

/*
 Based on AAPLStateMachine from AdvancedUserInterfacesUsingCollectionView sample code.
 
 */

#import <Foundation/Foundation.h>

@protocol COOLStateMachineDelegate;

/**
 *  Special state to forse calling missingTransitionFromState:toState on delegate
 */
extern NSString *const COOLStateUndefined;

/**
 *   A general purpose state machine implementation. The state machine will call methods on the delegate based on the name of the state. For example, when transitioning from StateA to StateB, the state machine will first call -shouldEnterStateA. If that method isn't implemented or returns YES, the state machine calls -willExitStateA followed by -willEnterStateB, then if implemented, it will call -stateWillChangeFromStateAToStateB or otherwise -stateWillChange, and updates the current state. It then calls -didExitStateA followed by -didEnterStateB. Finally, if implemented, it will call -stateDidChangeFromStateAToStateB or otherwise -stateDidChange. Target of all this calls will be delegate or state machine itself if delegate is nil.
 
     Assumptions:
 
     • The number of states and transitions are relatively few
 
     • State transitions are relatively infrequent
 
     • Multithreadsafety/atomicity is handled at a higher level

 */
@interface COOLStateMachine : NSObject

@property (copy, atomic) NSString *currentState;
@property (retain, atomic, readonly) NSDictionary *validTransitions;

- (instancetype)initWithValidTransitions:(NSDictionary *)validTransitions NS_DESIGNATED_INITIALIZER;

/**
 *  Returns all possible states based on validTransitions
 *
 *  @return
 */
- (NSArray *)possibleStates;

/**
 *  If set, COOLStateMachine invokes transition methods on this delegate instead of self. This allows COOLStateMachine to be used where subclassing doesn't make sense. The delegate is invoked on the same thread as -setCurrentState:
 */
@property (weak, atomic) id<COOLStateMachineDelegate> delegate;

/**
 *  Use NSLog to output state transitions.
 */
@property (assign, nonatomic) BOOL shouldLogStateTransitions;

/**
 *  Set current state and return YES if the state changed successfully to the supplied state, NO otherwise. Note that this does _not_ bypass missingTransitionFromState, so, if you invoke this, you must also supply an missingTransitionFromState implementation that avoids raising exceptions.
 *
 *  @param state
 *
 *  @return
 */
- (BOOL)applyState:(NSString *)state;

/**
 *  For subclasses and delegates. Base implementation raises IllegalStateTransition exception. Need not invoke super unless desired. Should return the desired state if it doesn't raise, or nil for no change. If delegate is set method is invoked on this delegate instead of self.
 *
 *  @param fromState
 *  @param toState
 *
 *  @return
 */
- (NSString *)missingTransitionFromState:(NSString *)fromState toState:(NSString *)toState;

@end


@protocol COOLStateMachineDelegate <NSObject>

@optional

// Completely generic state change hook
- (void)stateWillChange;
- (void)stateDidChange;

/**
 *  Return the new state or nil for no change for an missing transition from a state to another state. If implemented, overrides the base implementation completely.
 *
 *  @param fromState
 *  @param toState
 *
 *  @return
 */
- (NSString *)missingTransitionFromState:(NSString *)fromState toState:(NSString *)toState;

@end

