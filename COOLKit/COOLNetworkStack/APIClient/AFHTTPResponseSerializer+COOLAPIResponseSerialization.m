//
//  AFHTTPResponseSerializer+COOLAPIResponseSerialization.m
//  COOLKit
//
//  Created by Ilya Puchka on 22.12.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "AFHTTPResponseSerializer+COOLAPIResponseSerialization.h"

@implementation AFHTTPResponseSerializer (COOLAPIResponseSerialization)

static NSDictionary *_responsesRegisteredForRequests;

- (instancetype)initWithResponsesRegisteredForRequests:(NSDictionary *)responsesRegisteredForRequests
{
    self = [self init];
    if (self) {
        _responsesRegisteredForRequests = responsesRegisteredForRequests;
    }
    return self;
}

- (void)registerAPIResponseClass:(Class)apiResponseClass forAPIRequestClass:(Class)apiRequestClass
{
    NSAssert([apiRequestClass isSubclassOfClass:[COOLAPIRequest class]], @"apiRequestClass should be subclass of COOLAPIRequest");
    NSAssert([[apiResponseClass alloc] conformsToProtocol:@protocol(COOLAPIResponse)], @"apiRequestClass should conform to COOLAPIResponse protocol");
    if ([apiRequestClass isSubclassOfClass:[COOLAPIRequest class]] &&
        [apiResponseClass isSubclassOfClass:[COOLAPIResponse class]]) {
        NSMutableDictionary *mDict = [_responsesRegisteredForRequests?:@{} mutableCopy];
        mDict[NSStringFromClass(apiRequestClass)] = NSStringFromClass(apiResponseClass);
        _responsesRegisteredForRequests = [mDict copy];
    }
}

- (NSDictionary *)responsesRegisteredForRequests
{
    return _responsesRegisteredForRequests;
}

- (Class)APIResponseClassForAPIRequestClass:(Class)apiRequestClass
{
    return NSClassFromString(_responsesRegisteredForRequests[NSStringFromClass(apiRequestClass)]);
}

- (id<COOLAPIResponse>)responseForRequest:(COOLAPIRequest *)request task:(NSURLSessionDataTask *)task httpResponse:(NSHTTPURLResponse *)httpResponse responseObject:(id)responseObject httpError:(NSError *)httpError
{
    Class responseClass = [self APIResponseClassForAPIRequestClass:[request class]];
    if (responseClass == Nil) responseClass = [COOLAPIResponse class];
    
    id<COOLAPIResponse> apiResponse = [responseClass responseWithTask:task response:httpResponse responseObject:responseObject httpError:httpError];
    return apiResponse;
}

@end
