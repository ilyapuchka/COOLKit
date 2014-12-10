//
//  COOLAPIClientDataSource.h
//  CoolEvents
//
//  Created by Ilya Puchka on 08.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLDataSource.h"
#import "COOLAPIClientImpl.h"
#import "COOLAPIResponse.h"
#import "COOLLoadingProcess.h"

/**
 *  COOLDataSource implementation that uses id<COOLAPIClient> for loading content. Returns YES from -didCompleteLoadingWithSuccess if recieved response returns YES from it's -success method. Returns YES from -didCompleteLoadingWithNoContent if recieved response returns YES from it's -noContent method. Subclasses should override these two methods (optionally calling super) if they want to provide additional conditions on response object.
 
    @see COOLAPIResponse
 */
@interface COOLAPIClientDataSource : COOLDataSource

- (instancetype)initWithAPIClient:(id<COOLAPIClient>)apiClient;

/**
 *  Instance of COOLAPIClientImpl used for loading content.
 */
@property (nonatomic, strong) id<COOLAPIClient> apiClient;

/**
 *  Response from api client
 */
@property (nonatomic, strong) id<COOLAPIResponse> response;

/**
 *  Performs basic completion of loading by checking recieved response object. Will call -didCompleteLoadingWithSuccess and didCompleteLoadingWithNoContent (if -didCompleteLoadingWithSuccess returns NO). Then calls it's current helper loadingProcess instance methods to transit to corresponding state. Also sets response property.
 
 Subclasses must call this methed when they actually complete loading content.
 *
 *  @param task The task that was created to load content
 *  @param response Response recieved by api client
 */
- (void)completeLoadingWithTask:(NSURLSessionDataTask *)task
                       response:(id<COOLAPIResponse>)response
                 loadingProcess:(COOLLoadingProcess *)loadingProcess;

@end
