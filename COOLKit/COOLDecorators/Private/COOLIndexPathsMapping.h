//
//  COOLIndexPathsMapping.h
//  COOLDecorators
//
//  Created by Ilya Puchka on 15.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface COOLIndexPathsMapping : NSObject

- (instancetype)initWithSectionsCount:(NSInteger)sectionsCount;

- (NSInteger)sectionAfterWrappingForSectionBeforeWrapping:(NSInteger)section;
- (NSInteger)sectionBeforeWrappingForSectionAfterWrapping:(NSInteger)section;

- (NSIndexSet *)sectionsAfterWrappingForSectionBeforeWrapping:(NSIndexSet *)sections;
- (NSIndexSet *)sectionsBeforeWrappingForSectionAfterWrapping:(NSIndexSet *)sections;

- (NSIndexPath *)indexPathAfterWrappingForIndexPathBeforeWrapping:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathBeforeWrappingForIndexPathAfterWrapping:(NSIndexPath *)indexPath;

- (NSArray *)indexPathsAfterWrappingForIndexPathBeforeWrapping:(NSArray *)indexPaths;
- (NSArray *)indexPathsBeforeWrappingForIndexPathAfterWrapping:(NSArray *)indexPaths;

- (NSInteger)sectionsCount;

//returns new global sections count
- (NSInteger)updateWithSectionsCount:(NSInteger)sectionsCount startingWithSectionAtIndex:(NSInteger)sectionIndex;

@end
