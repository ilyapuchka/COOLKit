//
//  COOLAPIClientImpl.m
//  COOLNetworkStack
//
//  Created by Ilya Puchka on 04.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLAPIClientImpl.h"

#import "COOLAPIRequest.h"
#import "COOLAPIResponse.h"

#import "AFHTTPRequestSerializer+COOLAPIRequestSerialization.h"
#import "AFHTTPResponseSerializer+COOLAPIResponseSerialization.h"

@interface COOLAPIClientImpl()

@end

@implementation COOLAPIClientImpl

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration requestSerializer:(id<COOLAPIRequestSerialization>)requestSerializer responseSerializer:(id<COOLAPIResponseSerialization>)responseSerializer
{
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self) {
        self.requestSerializer = requestSerializer;
        self.responseSerializer = responseSerializer;
    }
    return self;
}

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self) {
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

- (void)setNetworkActivityLogger:(id<COOLNetworkActivityLogger>)networkActivityLogger
{
    _networkActivityLogger = networkActivityLogger;
    [_networkActivityLogger startLogging];
}

- (NSURLSessionDataTask *)dataTaskWithAPIRequest:(COOLAPIRequest *)request success:(COOLAPIClientSuccessBlock)success failure:(COOLAPIClientFailureBlock)failure
{
    NSError *requestBuildError;
    NSURLRequest *httpRequest = [self.requestSerializer requestBySerializingAPIRequest:request basePath:self.baseURL error:&requestBuildError];
    
    __block NSURLSessionDataTask *task = [self dataTaskWithRequest:httpRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            id<COOLAPIResponse> apiResponse;
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            apiResponse = [self.responseSerializer responseForRequest:request task:task httpResponse:httpResponse responseObject:responseObject httpError:error];
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
