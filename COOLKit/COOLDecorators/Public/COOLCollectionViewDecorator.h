//
//  COOLCollectionViewDecorator.h
//  COOLKit
//
//  Created by Ilya Puchka on 09.12.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol COOLCollectionViewDecorator <NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

- (void)decorateView:(UICollectionView *)view;

@property (nonatomic, strong, readonly) UICollectionView *decoratedView;
@property (nonatomic, weak, readonly) id<UICollectionViewDataSource> decoratedDataSource;
@property (nonatomic, weak, readonly) id<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> decoratedDelegate;

@end
