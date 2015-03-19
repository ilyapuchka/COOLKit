//
//  COOLAPIClientImpl.m
//  COOLNetworkStack
//
//  Created by Ilya Puchka on 04.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLAPIClientImpl.h"
#import "AFHTTPSessionManager.h"

#import "COOLAPIRequest.h"
#import "COOLAPIResponse.h"

@implementation COOLAPIClientImpl

@synthesize sessionManager = _sessionManager;
@synthesize networkActivityLogger = _networkActivityLogger;
@synthesize requestSerializer = _requestSerializer;
@synthesize responseSerializer = _responseSerializer;

- (NSURLSessionDataTask *)dataTaskWithAPIRequest:(COOLAPIRequest *)request success:(COOLAPIClientSuccessBlock)success failure:(COOLAPIClientFailureBlock)failure
{
    NSError *requestBuildError;
    NSURLRequest *httpRequest = [self.requestSerializer requestBySerializingAPIRequest:request basePath:self.sessionManager.baseURL error:&requestBuildError];
    
    __block NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:httpRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            id<COOLAPIResponse> apiResponse = [self.responseSerializer responseForRequest:request task:task httpResponse:(NSHTTPURLResponse *)response responseObject:responseObject httpError:error];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (apiResponse.error) {
                    if (failure) failure(apiResponse);
                }
                else if (success) success(apiResponse);
            });
        });
    }];
    [task resume];
    return task;
}

- (NSURLSessionDataTask *)dataTaskWithAPIRequest:(COOLAPIRequest *)request completionHandler:(COOLAPIClientCompletionBlock)completionHandler
{
    return [self dataTaskWithAPIRequest:request success:^(id<COOLAPIResponse> response) {
        if (completionHandler) completionHandler(YES, response);
    } failure:^(id<COOLAPIResponse> response) {
        if (completionHandler) completionHandler(NO, response);
    }];
}

@end
