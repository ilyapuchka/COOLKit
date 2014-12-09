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

@property (nonatomic, copy, readwrite) NSString *method;
@property (nonatomic, copy, readwrite) NSString *path;
@property (nonatomic, copy, readwrite) NSDictionary *parameters;

@end

@implementation COOLAPIRequest

- (instancetype)initWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters
{
    self = [super init];
    if (self) {
        self.method = method;
        self.path = path;
        self.parameters = parameters;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithMethod:self.method
                                                        path:self.path
                                                  parameters:self.parameters];
}

@end
