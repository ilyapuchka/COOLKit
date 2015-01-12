//
//  COOLIndexPathsMapping.h
//  COOLKit
//
//  Created by Ilya Puchka on 02.01.15.
//  Copyright (c) 2015 Ilya Puchka. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol COOLIndexPathsMapping <NSObject>

- (NSInteger)sectionAfterWrappingForSectionBeforeWrapping:(NSInteger)section;
- (NSInteger)sectionBeforeWrappingForSectionAfterWrapping:(NSInteger)section;

- (NSIndexSet *)sectionsAfterWrappingForSectionBeforeWrapping:(NSIndexSet *)sections;
- (NSIndexSet *)sectionsBeforeWrappingForSectionAfterWrapping:(NSIndexSet *)sections;

- (NSIndexPath *)indexPathAfterWrappingForIndexPathBeforeWrapping:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathBeforeWrappingForIndexPathAfterWrapping:(NSIndexPath *)indexPath;

- (NSArray *)indexPathsAfterWrappingForIndexPathBeforeWrapping:(NSArray *)indexPaths;
- (NSArray *)indexPathsBeforeWrappingForIndexPathAfterWrapping:(NSArray *)indexPaths;

- (NSInteger)sectionsCount;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (void)setNumberOfRows:(NSInteger)rowsCount inSection:(NSInteger)section;

@end
