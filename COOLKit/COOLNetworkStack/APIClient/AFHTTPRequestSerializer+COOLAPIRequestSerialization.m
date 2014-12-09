//
//  AFHTTPRequestSerializer+COOLAPIRequestSerialization.m
//  COOLNetworkStack
//
//  Created by Ilya Puchka on 09.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "AFHTTPRequestSerializer+COOLAPIRequestSerialization.h"
#import "COOLAPIRequest.h"

@implementation AFHTTPRequestSerializer (COOLAPIRequestSerialization)

- (NSURLRequest *)requestBySerializingAPIRequest:(COOLAPIRequest *)request basePath:(NSURL *)basePath error:(NSError *__autoreleasing *)error
{
    NSError *buildError;
    NSURL *url = [NSURL URLWithString:request.path relativeToURL:basePath];
    NSURLRequest *urlRequest = [self requestWithMethod:request.method URLString:[url absoluteString] parameters:request.parameters error:&buildError];
    if (buildError) {
        if (error) *error = buildError;
        return nil;
    }
    
    return urlRequest;
}

@end
