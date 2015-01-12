//
//  COOLAPIResponseSerialization.h
//  COOLNetworkStack
//
//  Created by Ilya Puchka on 05.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLResponseSerialization.h"
#import "COOLAPIRequest.h"
#import "COOLAPIResponse.h"

@protocol COOLAPIResponseSerialization <AFURLResponseSerialization>

- (instancetype)initWithResponsesRegisteredForRequests:(NSDictionary *)responsesRegisteredForRequests;

- (NSDictionary *)responsesRegisteredForRequests;

- (void)registerAPIResponseClass:(Class)apiResponseClass
              forAPIRequestClass:(Class)apiRequestClass;

- (id<COOLAPIResponse>)responseForRequest:(COOLAPIRequest *)request
                                     task:(NSURLSessionDataTask *)task
                             httpResponse:(NSHTTPURLResponse *)httpResponse
                           responseObject:(id)responseObject
                                httpError:(NSError *)httpError;

@end
