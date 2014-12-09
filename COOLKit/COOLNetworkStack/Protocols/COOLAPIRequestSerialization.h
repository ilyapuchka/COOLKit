//
//  COOLAPIRequestSerialization.h
//  COOLNetworkStack
//
//  Created by Ilya Puchka on 05.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLRequestSerialization.h"
#import "COOLAPIRequest.h"

@protocol COOLAPIRequestSerialization <AFURLRequestSerialization>

- (NSURLRequest *)requestBySerializingAPIRequest:(COOLAPIRequest *)request
                                        basePath:(NSURL *)basePath
                                           error:(NSError *__autoreleasing *)error;

@end
