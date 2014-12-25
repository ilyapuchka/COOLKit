//
//  COOLLoadingProcess.h
//  CoolEvents
//
//  Created by Ilya Puchka on 08.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

/*
 Based on APPLLoading from AdvancedUserInterfacesUsingCollectionView sample code.
 */

#import <Foundation/Foundation.h>

@class COOLDataSource;
typedef void (^COOLLoadingProcessDoneBlock)(COOLDataSource *me);

/**
 *  COOLDataSource helper class for loading content. Implementations of COOLDataSource should call this class instance methods to signal loading completion.
    
    @see <a>COOLDataSource</a>
 */
@interface COOLLoadingProcess : NSObject

/**
 *  Creates a new loading helper. Usually you don't create helper, it will be created by COOLDataSource in -loadContentWithBlock: method. It will then retain created instance of helper.
 *
 *  @param handler Loading completion block that will be called on main queue as a result of invoking other instance methods.
 *
 *  @return
 */
+ (instancetype)loadingProcessWithCompletionHandler:(void(^)(NSString *state, NSError *error, COOLLoadingProcessDoneBlock update))handler initialState:(NSString *)initialState;

/**
 *  Signals that this result should be ignored. Sends a nil value for the state to the completion handler.
 */
- (void)ignore;

/**
 *  Signals that loading is complete with no errors. This triggers a transition to the Loaded state.
 */
- (void)done;

/**
 *  Signals that loading failed with an error. This triggers a transition to the Error state.
 *
 *  @param error
 */
- (void)doneWithError:(NSError *)error;

/**
 *  Signals that loading failed with an error. This triggers a transition to the Error state.
 *
 *  @param error
 *  @param block
 */
- (void)doneWithError:(NSError *)error update:(COOLLoadingProcessDoneBlock)block;

/**
 *  Signals that loading is complete, transitions into the Loaded state and then runs the block.
 *
 *  @param block Block can perform any additional tasks. Passed object is an instance of COOLDataSource that created helper.
 */
- (void)doneWithContent:(COOLLoadingProcessDoneBlock)block;

/**
 *  Signals that loading completed with no content, transitions to the No Content state and then runs the block.
 *
 *  @param block Block can perform any additional tasks. Passed object is an instance of COOLDataSource that created helper.
 */
- (void)doneWithNoContent:(COOLLoadingProcessDoneBlock)block;

/**
 *  Signals that loading was canceled, transitions to initial state.
 */
- (void)cancelLoading;

@property (nonatomic, getter=isCurrent) BOOL current;
@property (nonatomic, getter=isCancelled) BOOL cancelled;

@end
