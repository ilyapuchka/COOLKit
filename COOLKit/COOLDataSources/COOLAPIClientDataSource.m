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

- (BOOL)didCompleteLoadingWithSuccess
{
    return [self.response succes];
}

- (BOOL)didCompleteLoadingWithNoContent
{
    return [self.response noContent];
}

- (void)completeLoadingWithTask:(NSURLSessionDataTask *)task response:(id<COOLAPIResponse>)response
{
    if (![response.task.originalRequest isEqual:task.originalRequest] ||
        [response cancelled]) {
        [self.loadingProcess ignore];
        return;
    }

    self.response = response;
    if ([self didCompleteLoadingWithSuccess]) {
        [self.loadingProcess doneWithContent:self.onContentBlock];
    }
    else if ([self didCompleteLoadingWithNoContent]) {
        [self.loadingProcess doneWithNoContent:self.onNoContentBlock];
    }
    else {
        [self.loadingProcess doneWithError:response.error update:self.onErrorBlock];
    }
}

@end
