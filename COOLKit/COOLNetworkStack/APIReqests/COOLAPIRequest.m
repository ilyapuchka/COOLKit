//
//  COOLAPIRequest.m
//  COOLNetworkStack
//
//  Created by Ilya Puchka on 04.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLAPIRequest.h"
#import "COOLAPIResponse.h"

@interface COOLAPIRequest()

@end

@implementation COOLAPIRequest

- (instancetype)initWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters
{
    return [self initWithMethod:method path:path parameters:parameters request:nil];
}

- (instancetype)initWithRequest:(NSURLRequest *)request
{
    return [self initWithMethod:nil path:nil parameters:nil request:request];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithMethod:self.method
                                                        path:self.path
                                                  parameters:self.parameters
                                                     request:self.request];
}

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    return [self isEqualToRequest:object];
}

- (BOOL)isEqualToRequest:(COOLAPIRequest *)object
{
    BOOL methodIsEqual = ([self.method isEqualToString:object.method] ||
                          (self.method == nil && object.method == nil));
    
    BOOL pathIsEqual = ([self.path isEqualToString:object.path] ||
                        (self.path == nil && object.path == nil));
    
    BOOL paramsAreEqual = ([self.parameters isEqualToDictionary:object.parameters] ||
                           (self.parameters == nil && object.parameters == nil));
    
    BOOL requestIsEqual = ([self.request isEqual:object.request] ||
                           (self.request == nil && object.request == nil));
    
    return (methodIsEqual && pathIsEqual && paramsAreEqual && requestIsEqual);
}

- (NSUInteger)hash
{
    return self.method.hash ^ self.path.hash ^ self.parameters.hash ^ self.request.hash;
}

#pragma mark - Private

- (instancetype)initWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters request:(NSURLRequest *)request
{
    self = [super init];
    if (self) {
        _method = [method copy];
        _path = [path copy];
        _parameters = [parameters copy];
        _request = [_request copy];
    }
    return self;
}


@end
