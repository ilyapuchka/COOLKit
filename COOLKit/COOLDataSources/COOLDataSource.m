//
//  COOLDataSource.m
//  CoolEvents
//
//  Created by Ilya Puchka on 08.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLDataSource.h"
#include "NSString+Extensions.h"
#import <objc/message.h>

#define COOL_ASSERT_MAIN_THREAD NSAssert([NSThread isMainThread], @"This method must be called on the main thread")


@interface COOLDataSource()

@property (nonatomic, strong) COOLLoadingStateMachine *stateMachine;
@property (nonatomic, strong) COOLLoadingProcess *loadingProcess;

@end

@implementation COOLDataSource

@synthesize delegate = _delegate;
@synthesize loadingError = _loadingError;

- (COOLLoadingStateMachine *)stateMachine
{
    if (_stateMachine)
        return _stateMachine;
    
    _stateMachine = [[COOLLoadingStateMachine alloc] init];
    _stateMachine.delegate = self;
    return _stateMachine;
}

- (NSString *)loadingState
{
    // Don't cause the creation of the state machine just by inspection of the loading state.
    if (!_stateMachine)
        return COOLLoadingStateInitial;
    return _stateMachine.currentState;
}

- (void)setLoadingState:(NSString *)loadingState
{
    COOLLoadingStateMachine *stateMachine = self.stateMachine;
    if (loadingState != stateMachine.currentState)
        stateMachine.currentState = loadingState;
}

- (void)beginLoading
{
    NSString *loadingState;
    if ([self.loadingState isEqualToString:COOLLoadingStateInitial] ||
        [self.loadingState isEqualToString:COOLLoadingStateLoadingContent]) {
        loadingState = COOLLoadingStateLoadingContent;
    }
    else if ([self.loadingState isEqualToString:COOLLoadingStateNoContent] ||
             [self.loadingState isEqualToString:COOLLoadingStateError]) {
        loadingState = COOLStateUndefined;
    }
    else {
        loadingState = COOLLoadingStateRefreshingContent;
    }
    self.loadingState = loadingState;
    
    [self notifyWillLoadContent];
}

- (void)endLoadingWithState:(NSString *)state error:(NSError *)error update:(dispatch_block_t)update
{
    self.loadingError = error;
    self.loadingState = state;
    
    if (update) update();
    
    [self notifyContentLoadedWithError:error];
}

- (void)notifyContentLoadedWithError:(NSError *)error
{
    COOL_ASSERT_MAIN_THREAD;
    [self.delegate dataSource:self didLoadContentWithError:error];
}

- (void)notifyWillLoadContent
{
    COOL_ASSERT_MAIN_THREAD;
    [self.delegate dataSourceWillLoadContent:self];
}

- (void)setNeedsLoadContent
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadContent) object:nil];
    [self performSelector:@selector(loadContent) withObject:nil afterDelay:0];
}

- (void)resetContent
{
    _stateMachine = nil;
    // Content has been reset, if we're loading something, chances are we don't need it.
    self.loadingProcess = nil;
}

- (void)loadContent
{
    
}

- (void)loadContentWithBlock:(COOLLoadingBlock)block
{
    [self beginLoading];
    
    __weak typeof(self) weakself = self;
    
    //create loading helper
    COOLLoadingProcess *loadingProcess = [COOLLoadingProcess loadingProcessWithCompletionHandler:^(NSString *newState, NSError *error, COOLLoadingProcessDoneBlock update){
        if (!newState)
            return;
        
        [self endLoadingWithState:newState error:error update:^{
            typeof(weakself) me = weakself;
            if (update && me)
                update(me);
        }];
    }];
    
    self.loadingProcess = loadingProcess;
    
    // Call the provided block to actually do the load
    block(loadingProcess);
}

- (BOOL)completed
{
    return ([self.loadingState isEqualToString:COOLLoadingStateContentLoaded] ||
            [self.loadingState isEqualToString:COOLLoadingStateNoContent] ||
            [self.loadingState isEqualToString:COOLLoadingStateError]);
}

- (BOOL)didCompleteLoadingWithSuccess
{
    return YES;
}

- (BOOL)didCompleteLoadingWithNoContent
{
    return NO;
}

#pragma mark - COOLStateMachineDelegate

- (void)stateWillChange
{
    // loadingState property isn't really Key Value Compliant, so let's begin a change notification
    [self willChangeValueForKey:@"loadingState"];
    
    typedef void (*ObjCMsgSendReturnVoid)(id, SEL, id);
    ObjCMsgSendReturnVoid sendMsgReturnVoid = (ObjCMsgSendReturnVoid)objc_msgSend;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SEL aSelector = @selector(dataSourceStateWillChange:);
    if ([self.delegate respondsToSelector:aSelector]) {
        sendMsgReturnVoid(self.delegate, aSelector, self);
    }
#pragma clang diagnostic pop
}

- (void)stateDidChange
{
    // loadingState property isn't really Key Value Compliant, so let's finish a change notification
    [self didChangeValueForKey:@"loadingState"];
    
    typedef void (*ObjCMsgSendReturnVoid)(id, SEL, id);
    ObjCMsgSendReturnVoid sendMsgReturnVoid = (ObjCMsgSendReturnVoid)objc_msgSend;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SEL aSelector = @selector(dataSourceStateDidChange:);
    if ([self.delegate respondsToSelector:aSelector]) {
        sendMsgReturnVoid(self.delegate, aSelector, self);
    }
#pragma clang diagnostic pop
}

#pragma mark - Invocations forwarding

- (BOOL)isKindOfClass:(Class)aClass
{
    BOOL isKindOfClass = [super isKindOfClass:aClass];
    if (!isKindOfClass) {
        isKindOfClass = [self.delegate isKindOfClass:aClass];
    }
    return isKindOfClass;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    BOOL respondsToSelector = [super respondsToSelector:aSelector];
    if (!respondsToSelector) {
        if ((aSelector = [self transformDelegateSelector:aSelector]))
            respondsToSelector = [self.delegate respondsToSelector:aSelector];
    }
    return respondsToSelector;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *methodSignatureForSelector = [super methodSignatureForSelector:aSelector];
    if (!methodSignatureForSelector) {
        if ((aSelector = [self transformDelegateSelector:aSelector]))
            methodSignatureForSelector = [(NSObject *)self.delegate methodSignatureForSelector:aSelector];
    }
    return methodSignatureForSelector;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL aSelector = [anInvocation selector];
    if ((aSelector = [self transformDelegateSelector:aSelector])) {
        typedef void (*ObjCMsgSendReturnVoid)(id, SEL, id);
        ObjCMsgSendReturnVoid sendMsgReturnVoid = (ObjCMsgSendReturnVoid)objc_msgSend;
        if ([self.delegate respondsToSelector:aSelector]) {
            sendMsgReturnVoid(self.delegate, aSelector, self);
        }
    }
}

- (SEL)transformDelegateSelector:(SEL)aSelector
{
    if ([NSStringFromSelector(aSelector) hasSuffix:@"State"]) {
        return NSSelectorFromString([NSString stringWithFormat:@"dataSource%@:", [NSStringFromSelector(aSelector) cool_firstLetterUppercasedString]]);
    }
    else {
        return nil;
    }
}

@end
