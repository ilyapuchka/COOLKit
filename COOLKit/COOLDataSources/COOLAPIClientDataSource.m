//
//  COOLAPIClientDataSource.m
//  CoolEvents
//
//  Created by Ilya Puchka on 08.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLAPIClientDataSource.h"
#import "COOLAPIResponse.h"
#import "COOLLoadingProcess.h"
#import "COOLAPIClient.h"

@interface COOLAPIClientDataSource()

@end

@implementation COOLAPIClientDataSource

- (instancetype)initWithAPIClient:(COOLAPIClient *)apiClient
{
    self = [super init];
    if (self) {
        self.apiClient = apiClient;
    }
    return self;
}

- (BOOL)didCompleteLoadingWithSuccess
{
    return (self.response.error == nil && self.response.responseObject != nil && self.response.mappedResponseObject != nil);
}

- (BOOL)didCompleteLoadingWithNoContent
{
    return NO;
}

- (void)completeLoadingWithTask:(NSURLSessionDataTask *)task response:(id<COOLAPIResponse>)response loadingProcess:(COOLLoadingProcess *)loadingProcess
{
    if (![response.task.originalRequest isEqual:task.originalRequest] ||
        ([response.error.domain isEqualToString:NSURLErrorDomain] && response.error.code == NSURLErrorCancelled) ||
        !loadingProcess.isCurrent) {
        if (!loadingProcess.isCancelled) {
            [loadingProcess ignore];
        }
        return;
    }

    self.response = response;
    if ([self didCompleteLoadingWithSuccess]) {
        [loadingProcess doneWithContent:self.onContentBlock];
    }
    else if ([self didCompleteLoadingWithNoContent]) {
        [loadingProcess doneWithNoContent:self.onNoContentBlock];
    }
    else {
        [loadingProcess doneWithError:response.error update:self.onErrorBlock];
    }
}

@end
