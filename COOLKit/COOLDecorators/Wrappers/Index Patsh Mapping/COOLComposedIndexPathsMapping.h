//
//  COOLIndexPathsMapping.h
//  COOLDecorators
//
//  Created by Ilya Puchka on 15.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "COOLIndexPathsMapping.h"

@interface COOLComposedIndexPathsMapping : NSObject <COOLIndexPathsMapping>

//- (instancetype)initWithSectionsCount:(NSInteger)sectionsCount;

//returns new global sections count
- (NSInteger)updateWithSectionsCount:(NSInteger)sectionsCount
          startingWithSectionAtIndex:(NSInteger)startSectionIndex;

@end
