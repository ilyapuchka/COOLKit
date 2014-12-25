//
//  COOLLoadableContentView.h
//  COOLKit
//
//  Created by Ilya Puchka on 25.12.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "COOLLoadingStateMachine.h"

@protocol COOLLoadingSupplementaryView <NSObject>

- (void)startAnimating;
- (void)stopAnimating;

@end

@protocol COOLLoadableContentViewDelegate <NSObject>

@optional
- (NSString *)nextStateForCurrentLoadingState:(NSString *)currentState;

@end

@interface COOLLoadableContentView : UIView <COOLStateMachineDelegate> {
    COOLLoadingStateMachine *_stateMachine;
}

@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIView *noContentSupplementaryView;
@property (nonatomic, weak) IBOutlet UIView *errorSupplementaryView;
@property (nonatomic, weak) IBOutlet UIView<COOLLoadingSupplementaryView> *loadingSupplementaryView;

@property (nonatomic, weak) IBOutlet id<COOLLoadableContentViewDelegate> delegate;

@property (nonatomic, copy, readonly) NSString *loadingState;

- (void)beginUpdateContent;
- (void)endUpdateContentWithNewState:(NSString *)state;

///Always returns COOLLoadingStateLoadingContent. During state transition to this state contentView will be hidden and loadingSupplementaryView will be shown with fade animation. To change this override this method and return different state (i.e. if there is already content displayed return COOLLoadingStateRefreshingContent, then no animation will be performed) or override COOLStateMachineDelegate methods for state transition.
- (NSString *)nextStateForCurrentLoadingState:(NSString *)currentState;

@end
