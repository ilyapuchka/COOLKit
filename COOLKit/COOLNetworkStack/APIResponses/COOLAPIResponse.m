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
@property (nonatomic, strong, readwrite) id mappedResponseObject;

@end

@implementation COOLAPIResponse

+ (instancetype)responseWithTask:(NSURLSessionDataTask *)task response:(NSHTTPURLResponse *)response responseObject:(id)responseObject httpError:(NSError *)httpError
{
    return [[[self class] alloc] initWithTask:task response:response responseObject:responseObject error:httpError];
}

- (instancetype)initWithTask:(NSURLSessionDataTask *)task
                    response:(NSHTTPURLResponse *)response
              responseObject:(id)responseObject
                       error:(NSError *)error
{
    self = [super init];
    if (self) {
        _task = [task copy];
        _response = [response copy];
        _error = [error copy];
        _responseObject = responseObject;
        
        if (!_error) {
            NSError *mappingError;
            if (![self mapResponseObject:&mappingError]) {
                _error = mappingError;
            }
        }
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

- (BOOL)mapResponseObject:(NSError *__autoreleasing *)error
{
    _mappedResponseObject = self.responseObject;
    return YES;
}

- (BOOL)succes
{
    return self.error == nil && self.responseObject != nil && self.mappedResponseObject != nil;
}

- (BOOL)noContent
{
    return NO;
}

- (BOOL)cancelled
{
    return ([self.error.domain isEqualToString:NSURLErrorDomain] &&
            self.error.code == NSURLErrorCancelled);
}

@end
