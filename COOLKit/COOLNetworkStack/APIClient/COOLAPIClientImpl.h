//
//  COOLAPIClientImpl.h
//  COOLNetworkStack
//
//  Created by Ilya Puchka on 04.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "COOLAPIClient.h"
#import "COOLNetworkActivityLogger.h"

@interface COOLAPIClientImpl : AFHTTPSessionManager <COOLAPIClient>

@property (nonatomic, strong) id<COOLNetworkActivityLogger> networkActivityLogger;

@end
