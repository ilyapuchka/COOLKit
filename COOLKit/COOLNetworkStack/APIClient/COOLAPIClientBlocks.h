//
//  COOLAPIClientBlocks.h
//  COOLNetworkStack
//
//  Created by Ilya Puchka on 07.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#ifndef COOLNetworkStack_COOLAPIClientBlocks_h
#define COOLNetworkStack_COOLAPIClientBlocks_h

@protocol COOLAPIResponse;

typedef void(^COOLAPIClientSuccessBlock)(id<COOLAPIResponse> response);
typedef void(^COOLAPIClientFailureBlock)(id<COOLAPIResponse> response);

#endif
