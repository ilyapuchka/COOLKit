//
//  COOLTableViewDelegationDecorator.h
//  COOLDecorators
//
//  Created by Ilya Puchka on 15.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "COOLTableViewDisplayDataSource.h"
#import "COOLTableViewEventsResponder.h"
#import "COOLTableViewEditingDelegate.h"
#import "COOLTableViewDataSourceDelegate.h"

@interface COOLTableViewDelegationDecorator : NSObject <COOLTableViewDataSourceDelegate, COOLTableViewDisplayDataSource>

@property (nonatomic, strong) IBOutlet id<COOLTableViewDisplayDataSource> displayDataSource;
@property (nonatomic, strong) IBOutlet id<COOLTableViewEventsResponder> eventsResponder;
@property (nonatomic, strong) IBOutlet id<UIScrollViewDelegate> scrollDelegate;
@property (nonatomic, strong) IBOutlet id<COOLTableViewEditingDelegate> editingDelegate;

@end