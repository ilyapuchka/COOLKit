//
//  COOLDataSource.h
//  CoolEvents
//
//  Created by Ilya Puchka on 08.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "COOLLoadingStateMachine.h"
#import "COOLLoadingProcess.h"
#import "COOLDataSourceDelegate.h"

typedef void (^COOLLoadingBlock)(COOLLoadingProcess *loadingProcess);

/**
 *  
    Base data source implementation.
 
    <b>Subclassing notes.</b>
 
    If your subclass overrides <a>COOLStateMachineDelegate</a> state changing methods (e.g. didEnter..., willEnter... etc.) call super in you implementation. It will call <a>COOLDataSourceDelegate</a> corresponding methods (e.g. dataSourceDidEnter...:, dataSourceWillEnter...:).
 
    If you don't call super then call COOLDataSourceDelegate corresponding methods by yourself.
 
    @see <a>COOLDataSourceDelegate</a>, <a>COOLStateMachineDelegate</a>
 */

@interface COOLDataSource : NSObject <COOLStateMachineDelegate>
{
    COOLLoadingStateMachine *_stateMachine;
    COOLLoadingProcess *_loadingProcess;
}

/**
 *
 Delegate can implement any state changing methods (e.g dataSourceWillEnter...:, dataSourceStateWillChangeFrom...To...:).
 
 See <a>COOLLoadingStateMachine</a> for list of possible states and <a>COOLStateMachine</a> for methods naming conventions.
 
 @see <a>COOLLoadingStateMachine</a>, <a>COOLStateMachine</a>
 
 */
@property (nonatomic, weak) id<COOLDataSourceDelegate> delegate;

/**
 *  Optional block called if loading completed with success.
 */
@property (nonatomic, copy) COOLLoadingProcessDoneBlock onContentBlock;

/**
 *  Optional block called if loading completed with no content.
 */
@property (nonatomic, copy) COOLLoadingProcessDoneBlock onNoContentBlock;

/**
 *  Optional block called if loading completed with error.
 */
@property (nonatomic, copy) COOLLoadingProcessDoneBlock onErrorBlock;

/**
 *  Any error that occurred during content loading. Valid only when loadingState is COOLLoadingStateError.
 */
@property (nonatomic, strong) NSError *loadingError;

/**
 *  Returns current state of current loading operation
 *
 *  @return current state of current loading operation
 *  @see
 */
- (NSString *)loadingState;

/**
 *  Returns current loading helper object
 *
 *  @return helper object used for current loading operation
 */
- (COOLLoadingProcess *)loadingProcess;

/**
 *  Returns YES whether loading is completed
 *
 *  @return YES if loading is completed
 */
- (BOOL)completed;

/**
 *  Base implementation always returns YES. Should be overriden by subclasses.
 *
 *  @return YES if last loading process was completed with success
 */
- (BOOL)didCompleteLoadingWithSuccess;

/**
 *  Base implementation always returns NO. Should be overriden by subclasses.
 *
 *  @return YES if last loading process was completed with success but no content was loaded
 */
- (BOOL)didCompleteLoadingWithNoContent;

/**
 *  Will schedule loadContent for later execution
 */
- (void)setNeedsLoadContent;

/**
 *  Loads content Base implementation do nothing.
 */
- (void)loadContent;

/**
 *  Prepares data source for loading.
 *
 *  @param block Block that actually do loading.
 *  @see <a>COOLLoadingProcess</a>
 */
- (void)loadContentWithBlock:(COOLLoadingBlock)block;

/**
 *  Reset loading state. Subclasses should call super and should reset any content information they currently hold.
 */
- (void)resetContent NS_REQUIRES_SUPER;

@end


