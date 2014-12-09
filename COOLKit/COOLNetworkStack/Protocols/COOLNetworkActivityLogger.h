//
//  COOLNetworkActivityLogger.h
//  COOLNetworkStack
//
//  Created by Ilya Puchka on 05.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol COOLNetworkActivityLogger <NSObject>

@property (nonatomic, assign) NSInteger level;
@property (nonatomic, strong) NSPredicate *filterPredicate;

- (void)startLogging;
- (void)stopLogging;

@end
