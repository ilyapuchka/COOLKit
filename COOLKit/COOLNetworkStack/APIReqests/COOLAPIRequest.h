//
//  COOLAPIRequest.h
//  COOLNetworkStack
//
//  Created by Ilya Puchka on 04.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const COOLAPIGETRequest = @"GET";
static NSString * const COOLAPIPOSTRequest = @"POST";

@protocol COOLAPIResponse;

@interface COOLAPIRequest : NSObject <NSCopying>

@property (nonatomic, copy, readonly) NSString *method;
@property (nonatomic, copy, readonly) NSString *path;
@property (nonatomic, copy, readonly) NSDictionary *parameters;

- (instancetype)initWithMethod:(NSString *)method
                          path:(NSString *)path
                    parameters:(NSDictionary *)parameters;

@end
