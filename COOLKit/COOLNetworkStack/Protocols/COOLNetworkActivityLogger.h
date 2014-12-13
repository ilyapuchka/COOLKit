//
//  COOLNetworkActivityLogger.h
//  COOLNetworkStack
//
//  Created by Ilya Puchka on 05.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, COOLLoggerLevel) {
    COOLLoggerLevelOff,
    COOLLoggerLevelDebug,
    COOLLoggerLevelInfo,
    COOLLoggerLevelWarn,
    COOLLoggerLevelError,
    COOLLoggerLevelFatal = COOLLoggerLevelOff,
};

@protocol COOLNetworkActivityLogger <NSObject>

@property (nonatomic, assign) COOLLoggerLevel level;
@property (nonatomic, strong) NSPredicate *filterPredicate;

- (void)startLogging;
- (void)stopLogging;

@end
