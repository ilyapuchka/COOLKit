//
//  COOLAPIClientImpl.h
//  COOLNetworkStack
//
//  Created by Ilya Puchka on 04.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "COOLNetworkActivityLogger.h"
#import "COOLAPIClientBlocks.h"
#import "COOLSessionManager.h"

@class COOLAPIRequest;
@class COOLAPIResponse;

@interface COOLAPIClient : NSObject

@property (nonatomic, strong) id<COOLNetworkActivityLogger> networkActivityLogger;
@property (nonatomic, strong) id<COOLSessionManager> sessionManager;
@property (nonatomic, strong) dispatch_queue_t resultsQueue;

- (instancetype)initWithResponsesRegisteredForRequests:(NSDictionary *)responsesRegisteredForRequests;

- (NSDictionary *)responsesRegisteredForRequests;

- (void)registerAPIResponseClass:(Class)apiResponseClass
              forAPIRequestClass:(Class)apiRequestClass;

- (NSURLSessionDataTask *)dataTaskWithAPIRequest:(COOLAPIRequest *)request
                                         success:(COOLAPIClientSuccessBlock)success
                                         failure:(COOLAPIClientFailureBlock)failure;

- (NSURLSessionDataTask *)dataTaskWithAPIRequest:(COOLAPIRequest *)request
                               completionHandler:(COOLAPIClientCompletionBlock)completionHandler;

@end
