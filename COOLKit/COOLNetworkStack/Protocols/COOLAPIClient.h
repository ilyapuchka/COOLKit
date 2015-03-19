//
//  COOLAPIClient.h
//  COOLNetworkStack
//
//  Created by Ilya Puchka on 04.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "COOLAPIClientBlocks.h"
#import "COOLAPIRequestSerialization.h"
#import "COOLAPIResponseSerialization.h"
#import "COOLNetworkActivityLogger.h"

@protocol COOLSessionManager <NSObject>

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;

- (NSURL *)baseURL;

@end

@protocol COOLAPIClient <NSObject>

@property (nonatomic, strong) id<COOLNetworkActivityLogger> networkActivityLogger;
@property (nonatomic, strong) id<COOLSessionManager> sessionManager;
@property (nonatomic, strong) id<COOLAPIRequestSerialization> requestSerializer;
@property (nonatomic, strong) id<COOLAPIResponseSerialization> responseSerializer;

- (NSURLSessionDataTask *)dataTaskWithAPIRequest:(COOLAPIRequest *)request
                                         success:(COOLAPIClientSuccessBlock)success
                                         failure:(COOLAPIClientFailureBlock)failure;

- (NSURLSessionDataTask *)dataTaskWithAPIRequest:(COOLAPIRequest *)request
                               completionHandler:(COOLAPIClientCompletionBlock)completionHandler;

@end
