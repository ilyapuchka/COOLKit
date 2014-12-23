//
//  AFHTTPResponseSerializer+COOLAPIResponseSerialization.h
//  COOLKit
//
//  Created by Ilya Puchka on 22.12.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "AFURLResponseSerialization.h"
#import "COOLAPIResponseSerialization.h"

@interface AFHTTPResponseSerializer (COOLAPIResponseSerialization) <COOLAPIResponseSerialization>

- (NSDictionary *)responsesRegisteredForRequests;

- (instancetype)initWithResponsesRegisteredForRequests:(NSDictionary *)responsesRegisteredForRequests;

- (void)registerAPIResponseClass:(Class)apiResponseClass
              forAPIRequestClass:(Class)apiRequestClass;

@end
