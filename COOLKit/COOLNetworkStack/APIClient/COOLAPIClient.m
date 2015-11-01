//
//  COOLAPIClientImpl.m
//  COOLNetworkStack
//
//  Created by Ilya Puchka on 04.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLAPIClient.h"
#import "AFHTTPSessionManager.h"

#import "COOLAPIRequest.h"
#import "COOLAPIResponse.h"

@interface COOLAPIClient()

@property (nonatomic, copy) NSDictionary *responsesRegisteredForRequests;

@end

@implementation COOLAPIClient

- (dispatch_queue_t)privateQueue
{
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    });
    return queue;
}

- (instancetype)initWithResponsesRegisteredForRequests:(NSDictionary *)responsesRegisteredForRequests
{
    self = [self init];
    if (self) {
        _responsesRegisteredForRequests = [responsesRegisteredForRequests copy];
    }
    return self;
}

- (void)registerAPIResponseClass:(Class)apiResponseClass forAPIRequestClass:(Class)apiRequestClass
{
    NSAssert([apiRequestClass isSubclassOfClass:[COOLAPIRequest class]], @"%@ is not a subclass of COOLAPIRequest.", NSStringFromClass(apiRequestClass));
    NSAssert([[apiResponseClass alloc] conformsToProtocol:@protocol(COOLAPIResponse)], @"%@ does not conform to COOLAPIResponse protocol.", NSStringFromClass(apiResponseClass));
    
    if ([apiRequestClass isSubclassOfClass:[COOLAPIRequest class]] &&
        [apiResponseClass conformsToProtocol:@protocol(COOLAPIResponse)]) {
        NSMutableDictionary *mDict = [self.responsesRegisteredForRequests?:@{} mutableCopy];
        mDict[NSStringFromClass(apiRequestClass)] = NSStringFromClass(apiResponseClass);
        self.responsesRegisteredForRequests = [mDict copy];
    }
    else {
        [NSException raise:NSInternalInconsistencyException format:@"%@ is not a subclass of COOLAPIRequest, or %@ does not conform to COOLAPIResponse protocol.", NSStringFromClass(apiRequestClass), NSStringFromClass(apiResponseClass)];
    }
}

- (NSURLSessionDataTask *)dataTaskWithAPIRequest:(COOLAPIRequest *)request success:(COOLAPIClientSuccessBlock)success failure:(COOLAPIClientFailureBlock)failure
{
    NSURLSessionDataTask *task = [self.sessionManager dataTaskWithHTTPMethod:request.method URLString:request.path parameters:request.parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(self.privateQueue, ^{
            id<COOLAPIResponse> apiResponse = [self responseForRequest:request task:task httpResponse:(NSHTTPURLResponse *)task.response responseObject:responseObject httpError:nil];
            dispatch_async(self.resultsQueue?:dispatch_get_main_queue(), ^{
                if (apiResponse.error) {
                    if (failure) failure(apiResponse);
                }
                else if (success) success(apiResponse);
            });
        });

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        id<COOLAPIResponse> apiResponse = [self responseForRequest:request task:task httpResponse:(NSHTTPURLResponse *)task.response responseObject:nil httpError:error];
        dispatch_async(self.resultsQueue?:dispatch_get_main_queue(), ^{
            if (failure) failure(apiResponse);
        });
    }];
    [task resume];
    return task;
}

- (NSURLSessionDataTask *)dataTaskWithAPIRequest:(COOLAPIRequest *)request completionHandler:(COOLAPIClientCompletionBlock)completionHandler
{
    return [self dataTaskWithAPIRequest:request success:^(COOLAPIResponse *response) {
        if (completionHandler) completionHandler(YES, response);
    } failure:^(COOLAPIResponse *response) {
        if (completionHandler) completionHandler(NO, response);
    }];
}

#pragma mark - Private

- (Class)responseClassForRequestClass:(Class)requestClass
{
    return NSClassFromString(self.responsesRegisteredForRequests[NSStringFromClass(requestClass)]);
}

- (id<COOLAPIResponse>)responseForRequest:(COOLAPIRequest *)request task:(NSURLSessionDataTask *)task httpResponse:(NSHTTPURLResponse *)httpResponse responseObject:(id)responseObject httpError:(NSError *)httpError
{
    Class responseClass = [self responseClassForRequestClass:[request class]];
    if (responseClass == Nil) responseClass = [COOLAPIResponse class];
    if ([responseClass conformsToProtocol:@protocol(COOLAPIResponse)]) {
        id<COOLAPIResponse> apiResponse = [responseClass responseWithTask:task response:httpResponse responseObject:responseObject httpError:httpError];
        return apiResponse;
    }
    else {
        [NSException raise:NSInternalInconsistencyException format:@"%@ does not conform to COOLAPIResponse protocol.", NSStringFromClass(responseClass)];
        return nil;
    }
}

@end
