//
//  COOLInjectIndexPathsMapping.h
//  COOLKit
//
//  Created by Ilya Puchka on 01.01.15.
//  Copyright (c) 2015 Ilya Puchka. All rights reserved.
//

#import "COOLComposedIndexPathsMapping.h"
#import "COOLIndexPathsMapping.h"

//Mapping for original items
@interface COOLInjecedtIndexPathsMapping : NSObject <COOLIndexPathsMapping>

- (instancetype)initWithSectionsCount:(NSInteger)sectionsCount
                               offset:(NSInteger)offset
                                 step:(NSInteger)step;

@property (nonatomic, assign, readonly) NSInteger offset;
@property (nonatomic, assign, readonly) NSInteger step;

- (BOOL)isInjectItemAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)countOfInsertedItemsInSection:(NSInteger)section;

- (void)updateWithSectionsCount:(NSInteger)sectionsCount
                         offset:(NSInteger)offset
                           step:(NSInteger)step;

- (NSArray *)injectedItemsIndexPaths;

- (NSIndexPath *)injectItemIndexPathForIndex:(NSInteger)index inSection:(NSInteger)section;

@end

//Mapping for injected items
@interface COOLInjecedtIndexPathsMappingForInjectedItems : COOLInjecedtIndexPathsMapping

@end
