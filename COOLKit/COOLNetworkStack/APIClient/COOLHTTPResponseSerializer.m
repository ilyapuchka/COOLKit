//
//  COOLHTTPResponseSerializer.m
//  COOLNetworkStack
//
//  Created by Ilya Puchka on 05.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLHTTPResponseSerializer.h"
#import "COOLAPIRequest.h"
#import "COOLAPIResponse.h"

@interface COOLHTTPResponseSerializer()

@property (nonatomic, copy) NSDictionary *responsesRegisteredForRequests;

@end

@implementation COOLHTTPResponseSerializer

- (instancetype)init
{
    return [self initWithResponsesRegisteredForRequests:@{}];
}

- (instancetype)initWithResponsesRegisteredForRequests:(NSDictionary *)responsesRegisteredForRequests
{
    self = [super init];
    if (self) {
        self.responsesRegisteredForRequests = responsesRegisteredForRequests;
    }
    return self;
}

- (void)registerAPIResponseClass:(Class)apiResponseClass forAPIRequestClass:(Class)apiRequestClass
{
    NSAssert([apiRequestClass isSubclassOfClass:[COOLAPIRequest class]], @"apiRequestClass should be subclass of COOLAPIRequest");
    NSAssert([[apiResponseClass alloc] conformsToProtocol:@protocol(COOLAPIResponse)], @"apiRequestClass should conform to COOLAPIResponse protocol");
    if ([apiRequestClass isSubclassOfClass:[COOLAPIRequest class]] &&
        [apiResponseClass isSubclassOfClass:[COOLAPIResponse class]]) {
        NSMutableDictionary *mDict = [self.responsesRegisteredForRequests mutableCopy];
        mDict[NSStringFromClass(apiRequestClass)] = NSStringFromClass(apiResponseClass);
        self.responsesRegisteredForRequests = mDict;
    }
}

- (Class)APIResponseClassForAPIRequestClass:(Class)apiRequestClass
{
    return NSClassFromString(self.responsesRegisteredForRequests[NSStringFromClass(apiRequestClass)]);
}

- (id<COOLAPIResponse>)responseForRequest:(COOLAPIRequest *)request task:(NSURLSessionDataTask *)task httpResponse:(NSHTTPURLResponse *)httpResponse responseObject:(id)responseObject httpError:(NSError *)httpError
{
    Class responseClass = [self APIResponseClassForAPIRequestClass:[request class]];
    if (responseClass == Nil) responseClass = [COOLAPIResponse class];
    
    id<COOLAPIResponse> apiResponse = [responseClass responseWithTask:task response:httpResponse responseObject:responseObject httpError:httpError];
    return apiResponse;
}

@end
