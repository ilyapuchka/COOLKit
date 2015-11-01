//
//  COOLSessionManager.h
//  COOLKit
//
//  Created by Ilya Puchka on 24.05.15.
//  Copyright (c) 2015 Ilya Puchka. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol COOLSessionManager <NSObject>

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
