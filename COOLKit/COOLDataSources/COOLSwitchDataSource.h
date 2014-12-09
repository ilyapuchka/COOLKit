//
//  COOLSwitchDataSource.h
//  COOLDataSource
//
//  Created by Ilya Puchka on 09.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLComposedDataSource.h"
#import "COOLSwitchComposition.h"

/**
 *  Switch data source composition using COOLSwitchComposition
 */
@interface COOLSwitchDataSource : COOLComposedDataSource

- (COOLSwitchComposition *)composition;

//Composition methods
- (COOLDataSource *)currentObject;
- (NSUInteger)currentObjectIndex;

- (BOOL)switchToObject:(COOLDataSource *)object;
- (BOOL)switchToObjectAtIndex:(NSUInteger)index;

@end
