//
//  COOLComposedDataSource.h
//  CoolEvents
//
//  Created by Ilya Puchka on 08.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLDataSource.h"
#import "COOLComposition.h"

/**
 *  Data sources composition that uses COOLComposition of COOLDataSource instances.
 
    Base implementation of -missingTransitionFromState:toState: method returns COOLLoadingStateRefreshingContent if previous loading completed with success or COOLLoadingStateLoadingContent otherwise.
 
    Base implementation of -didCompleteLoadingWithSuccess returns YES if at least one data source completed loading with success.
    
    Base implementation of -didCompleteLoadingWithNoContent returns YES if all data sources completed loading with no content.
 
    @see COOLComposition
 */
@interface COOLComposedDataSource : COOLDataSource <COOLDataSourceDelegate> {
    id<COOLComposition> _dataSources;
    NSArray *_objects;
    NSDictionary *_dataSourcesByStates;
}

/**
 *  Initialize composed data source with passed data sources. Data sources should be instances of COOLDataSource or it's subclass.
 *
 *  @param dataSources Array of data sources to use in composition
 *
 *  @return initialized composed data source
 */
- (instancetype)initWithDataSources:(NSArray *)dataSources NS_DESIGNATED_INITIALIZER;

/**
 *  Returns COOLComposition instance that holds data sources passed in initialization method.
 *
 *  @return instance of COOLComposition class that holds data sources passed in initialization method.
 */
- (COOLComposition *)composition;

/**
 *  COOLDataSourceDelegate method default implementation. Subclasses should call super.
 *
 *  @param dataSource Data source object that will load content.
 */
- (void)dataSourceWillLoadContent:(COOLDataSource *)dataSource NS_REQUIRES_SUPER;

/**
 *  COOLDataSourceDelegate method default implementation. Subclasses should call super.
 *
 *  @param dataSource Data source object that finished loading content
 *  @param error      Error occured during loading. Will be nil if loading completed with no errors.
 */
- (void)dataSource:(COOLDataSource *)dataSource didLoadContentWithError:(NSError *)error NS_REQUIRES_SUPER;

/**
 *  Implements basic completion of loading by checking state of each of data sources in composition. If no data sources are currently loading or refreshing their content than -didCompleteLoadingWithSuccess and -didCompleteLoadingWithNoContent are called to determine the next state to transition to. Ususally you should not call this method directly, but it can be usefull for subclasses.
 *
 *  @param loadingProcess current loading operation helper object
 */
- (void)completeLoadingIfNeeded:(COOLLoadingProcess *)loadingProcess;

@end
