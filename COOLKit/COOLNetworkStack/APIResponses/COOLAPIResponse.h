//
//  COOLAPIResponse.h
//  COOLNetworkStack
//
//  Created by Ilya Puchka on 04.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol COOLAPIResponse <NSObject>

+ (instancetype)responseWithTask:(NSURLSessionDataTask *)task
                        response:(NSHTTPURLResponse *)response
                  responseObject:(id)responseObject
                       httpError:(NSError *)httpError;

//returns YES in no error and mappedResponseObject is not nil. Subclasses should override.
- (BOOL)succes;

//returns YES if no error and mappedResponseObject is nil. Subclasses should override.
- (BOOL)noContent;

//returns YES if request was canceled (by default checks error code to be NSURLErrorCancelled)
- (BOOL)cancelled;

- (NSURLSessionDataTask *)task;
- (NSError *)error;
- (NSHTTPURLResponse *)response;
- (id)responseObject;

@end

@interface COOLAPIResponse : NSObject <COOLAPIResponse, NSCopying> {
    id _responseObject;
    NSURLSessionDataTask *_task;
    NSHTTPURLResponse *_response;
    NSError *_error;
}

@property (nonatomic, copy, readonly) NSURLSessionDataTask *task;
@property (nonatomic, copy, readonly) NSHTTPURLResponse *response;
@property (nonatomic, copy, readonly) NSError *error;
@property (nonatomic, strong, readonly) id responseObject;

/**
 *  Returns mapped response object. Base implementation returns responseObject.
 *
 *  @return returns mapped response object.
 */
-(id)mappedResponseObject;

/**
 *  Performs response object mapping
 *
 *  @param error Error occured during mapping. Should be nil if method returns YES.
 *
 *  @return YES if mapping completed with no errors.
 */
-(BOOL)mapResponseObject:(NSError *__autoreleasing *)error;

@end
