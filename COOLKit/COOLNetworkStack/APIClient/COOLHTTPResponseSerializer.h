//
//  COOLHTTPResponseSerializer.h
//  COOLNetworkStack
//
//  Created by Ilya Puchka on 05.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "COOLAPIResponseSerialization.h"
#import "COOLMapper.h"

@interface COOLHTTPResponseSerializer : AFJSONResponseSerializer <COOLAPIResponseSerialization>

@property (nonatomic, copy, readonly) NSDictionary *responsesRegisteredForRequests;

- (instancetype)initWithResponsesRegisteredForRequests:(NSDictionary *)responsesRegisteredForRequests NS_DESIGNATED_INITIALIZER;

- (void)registerAPIResponseClass:(Class)apiResponseClass
              forAPIRequestClass:(Class)apiRequestClass;

@end