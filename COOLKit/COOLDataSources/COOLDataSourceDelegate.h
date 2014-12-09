//
//  COOLDataSourceDelegate.h
//  COOLDataSource
//
//  Created by Ilya Puchka on 09.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol COOLDataSourceDelegate <NSObject>

@required

/**
 *  If the content was loaded successfully, the error will be nil.
 *
 *  @param dataSource
 *  @param error
 */
- (void)dataSource:(id)dataSource didLoadContentWithError:(NSError *)error;

/**
 *  Called just before a datasource begins loading its content.
 *
 *  @param dataSource
 */
- (void)dataSourceWillLoadContent:(id)dataSource;

@end