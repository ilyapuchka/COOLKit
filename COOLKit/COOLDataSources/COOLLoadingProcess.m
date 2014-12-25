//
//  COOLLoadingProcess.m
//  CoolEvents
//
//  Created by Ilya Puchka on 08.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLLoadingProcess.h"
#import <libkern/OSAtomic.h>
#import "COOLLoadingStateMachine.h"

#define DEBUG_LOADING 0

@interface COOLLoadingProcess()

@property (nonatomic, copy) void (^completionBlock)(NSString *, NSError *, COOLLoadingProcessDoneBlock);
@property (nonatomic, copy) NSString *initialState;

@end

@implementation COOLLoadingProcess
#if DEBUG
{
    int32_t _complete;
}
#endif

+ (instancetype)loadingProcessWithCompletionHandler:(void (^)(NSString *, NSError *, COOLLoadingProcessDoneBlock))handler initialState:(NSString *)initialState
{
    NSParameterAssert(handler != nil);
    COOLLoadingProcess *loading = [[self alloc] init];
    loading.completionBlock = handler;
    loading.current = YES;
    loading.initialState = initialState;
    return loading;
}

#if DEBUG
- (void)loadingDebugDealloc
{
    if (OSAtomicCompareAndSwap32(0, 1, &_complete))
#if DEBUG_LOADING
        NSAssert(false, @"No completion methods called on COOLLoadingProcess instance before dealloc called.");
#else
    NSLog(@"No completion methods called on COOLLoadingProcess instance before dealloc called. Break in -[COOLLoadingProcess loadingDebugDealloc] to debug this.");
#endif
}

- (void)dealloc
{
    // make this easier to debug by having a separate method for a breakpoint.
    [self loadingDebugDealloc];
}
#endif

- (void)_doneWithNewState:(NSString *)newState error:(NSError *)error update:(COOLLoadingProcessDoneBlock)update
{
#if DEBUG
    if (!OSAtomicCompareAndSwap32(0, 1, &_complete))
        NSAssert(false, @"completion method called more than once");
#endif
    
    typeof(_completionBlock) block = _completionBlock;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        block(newState, error, update);
    });
    
    _completionBlock = nil;
}

- (void)ignore
{
    [self _doneWithNewState:nil error:nil update:nil];
}

- (void)done
{
    [self _doneWithNewState:COOLLoadingStateContentLoaded error:nil update:nil];
}

- (void)doneWithContent:(COOLLoadingProcessDoneBlock)update
{
    [self _doneWithNewState:COOLLoadingStateContentLoaded error:nil update:update];
}

- (void)doneWithError:(NSError *)error
{
    [self doneWithError:error update:nil];
}

- (void)doneWithError:(NSError *)error update:(COOLLoadingProcessDoneBlock)update
{
    NSString *newState = error ? COOLLoadingStateError : COOLLoadingStateContentLoaded;
    [self _doneWithNewState:newState error:error update:update];
}

- (void)doneWithNoContent:(COOLLoadingProcessDoneBlock)update
{
    [self _doneWithNewState:COOLLoadingStateNoContent error:nil update:update];
}

- (void)cancelLoading
{
    self.cancelled = YES;
    [self _doneWithNewState:self.initialState error:nil update:nil];
}

@end
