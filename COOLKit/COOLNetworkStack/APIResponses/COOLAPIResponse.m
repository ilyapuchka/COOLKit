//
//  COOLAPIResponse.m
//  COOLNetworkStack
//
//  Created by Ilya Puchka on 04.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLAPIResponse.h"

@interface COOLAPIResponse ()

@property (nonatomic, copy, readwrite) NSURLSessionDataTask *task;
@property (nonatomic, copy, readwrite) NSHTTPURLResponse *response;
@property (nonatomic, copy, readwrite) NSError *error;
@property (nonatomic, strong, readwrite) id responseObject;

@end

@implementation COOLAPIResponse

+ (instancetype)responseWithTask:(NSURLSessionDataTask *)task response:(NSHTTPURLResponse *)response responseObject:(id)responseObject httpError:(NSError *)httpError
{
    COOLAPIResponse *apiResponse = [[[self class] alloc] initWithTask:task response:response responseObject:responseObject error:httpError];
    if (!httpError) {
        NSError *mappingError;
        if (![apiResponse mapResponseObject:&mappingError]) {
            apiResponse.error = mappingError;
        }
    }
    return apiResponse;
}

- (instancetype)initWithTask:(NSURLSessionDataTask *)task
                    response:(NSHTTPURLResponse *)response
              responseObject:(id)responseObject
                       error:(NSError *)error
{
    self = [super init];
    if (self) {
        self.task = task;
        self.responseObject = responseObject;
        self.response = response;
        self.error = error;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithTask:self.task
                                                  response:self.response
                                            responseObject:self.responseObject
                                                     error:self.error];
}

- (id)mappedResponseObject
{
    return self.responseObject;
}

- (BOOL)mapResponseObject:(NSError *__autoreleasing *)error
{
    return YES;
}

- (BOOL)succes
{
    return self.error == nil && self.responseObject != nil && self.mappedResponseObject != nil;
}

- (BOOL)noContent
{
    return [self succes];
}

- (BOOL)cancelled
{
    return ([self.error.domain isEqualToString:NSURLErrorDomain] &&
            self.error.code == NSURLErrorCancelled);
}

@end
