//
//  COOLCollectionViewWrapper.h
//  COOLDecorators
//
//  Created by Ilya Puchka on 14.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLWrapper.h"
#import "COOLIndexPathsMapping.h"

@interface COOLCollectionViewWrapper : COOLWrapper

+ (instancetype)wrapperFor:(UICollectionView *)view;

@property (nonatomic, strong) COOLIndexPathsMapping *indexPathsMapping;

- (UICollectionView *)wrappedObject;
- (UICollectionView *)collectionView;

@end
