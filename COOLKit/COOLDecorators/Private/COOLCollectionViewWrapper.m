//
//  COOLCollectionViewWrapper.m
//  COOLDecorators
//
//  Created by Ilya Puchka on 14.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLCollectionViewWrapper.h"
#import <objc/runtime.h>

@implementation COOLCollectionViewWrapper

+ (instancetype)wrapperFor:(UITableView *)view
{
    return [super wrapperFor:view];
}

+ (Class)wrappedClass
{
    return [UICollectionView class];
}

- (UICollectionView *)wrappedObject
{
    return (UICollectionView *)[super wrappedObject];
}

- (UICollectionView *)collectionView
{
    return [self wrappedObject];
}

- (NSIndexPath *)indexPathForCell:(id)cell
{
    //    NSIndexPath *globalIndexPath;
    //
    //    if ([_wrappedView isKindOfClass:[UITableView class]])
    //        globalIndexPath = [(UITableView *)_wrappedView indexPathForCell:cell];
    //    else
    //        globalIndexPath = [(UICollectionView *)_wrappedView indexPathForCell:cell];
    //
    //    return [_mapping localIndexPathForGlobalIndexPath:globalIndexPath];
    return [self.wrappedObject indexPathForCell:cell];
}

- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection
{
    //    NSUInteger globalSection = [_mapping globalSectionForLocalSection:section];
    //    NSUInteger globalNewSection = [_mapping globalSectionForLocalSection:newSection];
    //
    //    if ([_wrappedView isKindOfClass:[UITableView class]])
    //        [(UITableView *)_wrappedView moveSection:globalSection toSection:globalNewSection];
    //    else
    //        [(UICollectionView *)_wrappedView moveSection:globalSection toSection:globalNewSection];
}

//#pragma mark - UICollectionView methods that accept index paths
//
//- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath*)indexPath
//{
//    return [(UICollectionView *)_wrappedView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[_mapping globalIndexPathForLocalIndexPath:indexPath]];
//}
//
//- (id)dequeueReusableSupplementaryViewOfKind:(NSString*)elementKind withReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath*)indexPath
//{
//    return [(UICollectionView *)_wrappedView dequeueReusableSupplementaryViewOfKind:elementKind withReuseIdentifier:identifier forIndexPath:[_mapping globalIndexPathForLocalIndexPath:indexPath]];
//}
//
//// returns nil or an array of selected index paths
//- (NSArray *)indexPathsForSelectedItems
//{
//    NSArray *globalIndexPaths = [(UICollectionView *)_wrappedView indexPathsForSelectedItems];
//    if (!globalIndexPaths)
//        return nil;
//    return [_mapping localIndexPathsForGlobalIndexPaths:globalIndexPaths];
//}
//
//- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition
//{
//    [(UICollectionView *)_wrappedView selectItemAtIndexPath:[_mapping globalIndexPathForLocalIndexPath:indexPath] animated:animated scrollPosition:scrollPosition];
//}
//
//- (void)deselectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
//{
//    [(UICollectionView *)_wrappedView deselectItemAtIndexPath:[_mapping globalIndexPathForLocalIndexPath:indexPath] animated:animated];
//}
//
//- (NSInteger)numberOfItemsInSection:(NSInteger)section
//{
//    NSUInteger globalSection = [_mapping globalSectionForLocalSection:section];
//    return [(UICollectionView *)_wrappedView numberOfItemsInSection:globalSection];
//}
//
//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [(UICollectionView *)_wrappedView layoutAttributesForItemAtIndexPath:[_mapping globalIndexPathForLocalIndexPath:indexPath]];
//}
//
//- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    return [(UICollectionView *)_wrappedView layoutAttributesForSupplementaryElementOfKind:kind atIndexPath:[_mapping globalIndexPathForLocalIndexPath:indexPath]];
//}
//
//- (NSIndexPath *)indexPathForItemAtPoint:(CGPoint)point
//{
//    NSIndexPath *globalIndexPath = [(UICollectionView *)_wrappedView indexPathForItemAtPoint:point];
//    return [_mapping localIndexPathForGlobalIndexPath:globalIndexPath];
//}
//
//- (UICollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [(UICollectionView *)_wrappedView cellForItemAtIndexPath:[_mapping globalIndexPathForLocalIndexPath:indexPath]];
//}
//
//- (NSArray *)indexPathsForVisibleItems
//{
//    NSArray *globalIndexPaths = [(UICollectionView *)_wrappedView indexPathsForVisibleItems];
//    if (![globalIndexPaths count])
//        return nil;
//
//    return [_mapping localIndexPathsForGlobalIndexPaths:globalIndexPaths];
//}
//
//- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated
//{
//    [(UICollectionView *)_wrappedView scrollToItemAtIndexPath:[_mapping globalIndexPathForLocalIndexPath:indexPath] atScrollPosition:scrollPosition animated:animated];
//}
//
//- (void)insertSections:(NSIndexSet *)sections
//{
//    NSMutableIndexSet *globalSections = [[NSMutableIndexSet alloc] init];
//
//    [sections enumerateIndexesUsingBlock:^(NSUInteger localSection, BOOL *stop) {
//        NSUInteger globalSection = [_mapping globalSectionForLocalSection:localSection];
//        [globalSections addIndex:globalSection];
//    }];
//
//    [(UICollectionView *)_wrappedView insertSections:sections];
//}
//
//- (void)deleteSections:(NSIndexSet *)sections
//{
//    NSMutableIndexSet *globalSections = [[NSMutableIndexSet alloc] init];
//
//    [sections enumerateIndexesUsingBlock:^(NSUInteger localSection, BOOL *stop) {
//        NSUInteger globalSection = [_mapping globalSectionForLocalSection:localSection];
//        [globalSections addIndex:globalSection];
//    }];
//
//    [(UICollectionView *)_wrappedView deleteSections:sections];
//}
//
//- (void)reloadSections:(NSIndexSet *)sections
//{
//    NSMutableIndexSet *globalSections = [[NSMutableIndexSet alloc] init];
//
//    [sections enumerateIndexesUsingBlock:^(NSUInteger localSection, BOOL *stop) {
//        NSUInteger globalSection = [_mapping globalSectionForLocalSection:localSection];
//        [globalSections addIndex:globalSection];
//    }];
//
//    [(UICollectionView *)_wrappedView reloadSections:sections];
//}
//
//- (void)insertItemsAtIndexPaths:(NSArray *)indexPaths
//{
//    NSMutableArray *globalIndexPaths = [NSMutableArray arrayWithCapacity:[indexPaths count]];
//    for (NSIndexPath *localIndexPath in indexPaths) {
//        NSIndexPath *globalIndexPath = [_mapping globalIndexPathForLocalIndexPath:localIndexPath];
//        [globalIndexPaths addObject:globalIndexPath];
//    }
//
//    [(UICollectionView *)_wrappedView insertItemsAtIndexPaths:globalIndexPaths];
//}
//
//- (void)deleteItemsAtIndexPaths:(NSArray *)indexPaths
//{
//    NSMutableArray *globalIndexPaths = [NSMutableArray arrayWithCapacity:[indexPaths count]];
//    for (NSIndexPath *localIndexPath in indexPaths) {
//        NSIndexPath *globalIndexPath = [_mapping globalIndexPathForLocalIndexPath:localIndexPath];
//        [globalIndexPaths addObject:globalIndexPath];
//    }
//
//    [(UICollectionView *)_wrappedView deleteItemsAtIndexPaths:globalIndexPaths];
//}
//
//- (void)reloadItemsAtIndexPaths:(NSArray *)indexPaths
//{
//    NSMutableArray *globalIndexPaths = [NSMutableArray arrayWithCapacity:[indexPaths count]];
//    for (NSIndexPath *localIndexPath in indexPaths) {
//        NSIndexPath *globalIndexPath = [_mapping globalIndexPathForLocalIndexPath:localIndexPath];
//        [globalIndexPaths addObject:globalIndexPath];
//    }
//
//    [(UICollectionView *)_wrappedView reloadItemsAtIndexPaths:globalIndexPaths];
//}
//
//- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath
//{
//    [(UICollectionView *)_wrappedView moveItemAtIndexPath:[_mapping globalIndexPathForLocalIndexPath:indexPath] toIndexPath:[_mapping globalIndexPathForLocalIndexPath:newIndexPath]];
//}

@end
