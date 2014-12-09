//
//  COOLNetworkActivityLoggerImpl.m
//  COOLNetworkStack
//
//  Created by Ilya Puchka on 04.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLNetworkActivityLoggerImpl.h"

@interface AFNetworkActivityLogger()

- (void)networkRequestDidFinish:(NSNotification *)notification;

@end

@implementation COOLNetworkActivityLoggerImpl

- (void)networkRequestDidFinish:(NSNotification *)notification
{
    NSError *error = [notification.object error];
    if ([error.domain isEqualToString:NSURLErrorDomain] &&
        error.code == NSURLErrorCancelled) {
        return;
    }
    
    [super networkRequestDidFinish:notification];
}

@end
