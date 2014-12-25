//
//  COOLStateMachine.m
//  CoolEvents
//
//  Created by Ilya Puchka on 08.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLStateMachine.h"

#import <objc/message.h>
#import <libkern/OSAtomic.h>

#import "NSString+Extensions.h"

@interface COOLStateMachine()

@property (retain, atomic) NSDictionary *validTransitions;

@end

@implementation COOLStateMachine {
    OSSpinLock _lock;
}

@synthesize currentState = _currentState;

- (instancetype)init
{
    return [self initWithValidTransitions:nil];
}

- (instancetype)initWithValidTransitions:(NSDictionary *)validTransitions
{
    self = [super init];
    if (!self)
        return nil;
    
    self.validTransitions = validTransitions;
    
    _lock = OS_SPINLOCK_INIT;
    
    return self;
}

- (id)target
{
    id<COOLStateMachineDelegate> delegate = self.delegate;
    if (delegate)
        return delegate;
    return self;
}

- (NSString *)currentState
{
    __block NSString *currentState;
    
    // for atomic-safety, _currentState must not be released between the load of _currentState and the retain invocation
    OSSpinLockLock(&_lock);
    currentState = _currentState;
    OSSpinLockUnlock(&_lock);
    
    return currentState;
}

- (NSArray *)possibleStates
{
    return [self.validTransitions allKeys];
}

- (BOOL)applyState:(NSString *)toState
{
    return [self _setCurrentState:toState];
}

- (void)setCurrentState:(NSString *)toState
{
    [self _setCurrentState:toState];
}

- (BOOL)_setCurrentState:(NSString *)toState
{
    NSString *fromState = self.currentState;
       
    if (self.shouldLogStateTransitions)
        NSLog(@" ••• request state change from %@ to %@", fromState, toState);

    NSString *appliedToState = [self _validateTransitionFromState:fromState toState:toState];
    if (!appliedToState)
        return NO;

    // ... send messages
    [self _performBeforeTransitionFromState:fromState toState:appliedToState];

    OSSpinLockLock(&_lock);
    _currentState = [appliedToState copy];
    OSSpinLockUnlock(&_lock);
    
    // ... send messages
    [self _performAfterTransitionFromState:fromState toState:appliedToState];

    return [toState isEqual:appliedToState];
}

- (NSString *)_missingTransitionFromState:(NSString *)fromState toState:(NSString *)toState
{
    if ([_delegate respondsToSelector:@selector(missingTransitionFromState:toState:)])
        return [_delegate missingTransitionFromState:fromState toState:toState];
    return [self missingTransitionFromState:fromState toState:toState];
}

- (NSString *)missingTransitionFromState:(NSString *)fromState toState:(NSString *)toState
{
    [NSException raise:@"IllegalStateTransition" format:@"cannot transition from %@ to %@", fromState, toState];
    return nil;
}

- (NSString *)_validateTransitionFromState:(NSString *)fromState toState:(NSString *)toState
{
    // Transitioning to the same state (fromState == toState) is always allowed. If it's explicitly included in its own validTransitions, the standard method calls below will be invoked. This allows us to avoid creating states that exist only to reexecute transition code for the current state.

    // Raise exception if attempting to transition to nil -- you can only transition *from* nil
    if (!toState) {
        NSLog(@"  ••• %@ cannot transition to <nil> state", self);
        toState = [self _missingTransitionFromState:fromState toState:toState];
        if (!toState) {
            return nil;
        }
    }

    // Raise exception if this is an illegal transition (toState must be a validTransition on fromState)
    if (fromState) {
        id validTransitions = self.validTransitions[fromState];
        BOOL transitionSpecified = YES;
        
        // Multiple valid transitions
        if ([validTransitions isKindOfClass:[NSArray class]]) {
            if (![validTransitions containsObject:toState]) {
                transitionSpecified = NO;
            }
        }
        // Otherwise, single valid transition object
        else if (![validTransitions isEqual:toState]) {
            transitionSpecified = NO;
        }
        
        if (!transitionSpecified) {
            // Silently fail if implict transition to the same state
            if ([fromState isEqualToString:toState]) {
                if (self.shouldLogStateTransitions)
                    NSLog(@"  ••• %@ ignoring reentry to %@", self, toState);
                return nil;
            }
            
            if (self.shouldLogStateTransitions)
                NSLog(@"  ••• %@ cannot transition to %@ from %@", self, toState, fromState);
            toState = [self _missingTransitionFromState:fromState toState:toState];
            if (!toState || [toState isEqualToString:COOLStateUndefined])
                return nil;
        }
    }
    
    // Allow target to opt out of this transition (preconditions)
    id target = [self target];
    typedef BOOL (*ObjCMsgSendReturnBool)(id, SEL);
    ObjCMsgSendReturnBool sendMsgReturnBool = (ObjCMsgSendReturnBool)objc_msgSend;
    
    SEL enterStateAction = NSSelectorFromString([@"shouldEnter" stringByAppendingString:toState]);
    if ([target respondsToSelector:enterStateAction] && !sendMsgReturnBool(target, enterStateAction)) {
        NSLog(@"  ••• %@ transition disallowed to %@ from %@ (via %@)", self, toState, fromState, NSStringFromSelector(enterStateAction));
        toState = [self _missingTransitionFromState:fromState toState:toState];
    }

    return toState;
}

- (void)_performBeforeTransitionFromState:(NSString *)fromState toState:(NSString *)toState
{
    if (self.shouldLogStateTransitions)
        NSLog(@"  ••• %@ state will change from %@ to %@", self, fromState, toState);

    [self _performTransitionFromState:fromState toState:toState methodModifier:@"will"];
}

- (void)_performAfterTransitionFromState:(NSString *)fromState toState:(NSString *)toState
{
    if (self.shouldLogStateTransitions)
        NSLog(@"  ••• %@ state did changed from %@ to %@", self, fromState, toState);
    
    [self _performTransitionFromState:fromState toState:toState methodModifier:@"did"];
}

- (void)_performTransitionFromState:(NSString *)fromState toState:(NSString *)toState methodModifier:(NSString *)methodModifier
{
    // Subclasses may implement several different selectors to handle state transitions:
    //
    //  will/did enter state (willEnterPaused/didEnterPaused)
    //  will/did exit state (willExitPaused/didExitPaused)
    //  transition between states (stateWillChangeFromPausedToPlaying/stateDidChangeFromPausedToPlaying)
    //  or generic transition handler (stateWillChange/stateDidChange), for common tasks
    //
    // Any and all of these that are implemented will be invoked.

    id target = [self target];
    
    typedef void (*ObjCMsgSendReturnVoid)(id, SEL);
    ObjCMsgSendReturnVoid sendMsgReturnVoid = (ObjCMsgSendReturnVoid)objc_msgSend;
    
    if (fromState) {
        SEL exitStateAction = NSSelectorFromString([[NSString stringWithFormat:@"%@Exit", methodModifier] stringByAppendingString:fromState]);
        if ([target respondsToSelector:exitStateAction]) {
            sendMsgReturnVoid(target, exitStateAction);
        }
    }
    
    SEL enterStateAction = NSSelectorFromString([[NSString stringWithFormat:@"%@Enter", methodModifier] stringByAppendingString:toState]);
    if ([target respondsToSelector:enterStateAction]) {
        sendMsgReturnVoid(target, enterStateAction);
    }
    
    NSString *fromStateNotNil = fromState ? fromState : COOLStateNil;
    
    SEL transitionAction = NSSelectorFromString([NSString stringWithFormat:@"state%@ChangeFrom%@To%@", [methodModifier cool_firstLetterUppercasedString], fromStateNotNil, toState]);
    if ([target respondsToSelector:transitionAction]) {
        sendMsgReturnVoid(target, transitionAction);
    }
    else {
        SEL genericDidChangeAction = NSSelectorFromString([NSString stringWithFormat:@"state%@Change", [methodModifier cool_firstLetterUppercasedString]]);
        if ([target respondsToSelector:genericDidChangeAction]) {
            sendMsgReturnVoid(target, genericDidChangeAction);
        }
    }
}

@end
