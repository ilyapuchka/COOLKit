//
//  UITableView+Decoration.m
//  COOLKit
//
//  Created by Ilya Puchka on 08.12.14.
//  Copyright (c) 2014 Rambler&Co. All rights reserved.
//

#import "UITableView+Decoration.h"
#import <objc/runtime.h>

typedef void (*ObjCMsgSendReturnNil)(id, SEL);

@implementation UITableView (Decoration)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //swizzle reloadData
        SEL reloadDataSelector = @selector(reloadData);
        Method reloadDataMethod = class_getInstanceMethod([self class], reloadDataSelector);
        ObjCMsgSendReturnNil originalReloadData = (ObjCMsgSendReturnNil)method_getImplementation(reloadDataMethod);

        IMP adjustedReloadDataIMP = imp_implementationWithBlock(^void(UITableView *instance){
            [[instance decorator] reloadData];
            originalReloadData(instance, reloadDataSelector);
        });
        method_setImplementation(reloadDataMethod, adjustedReloadDataIMP);

        //swizzle beginUpdates
        SEL beginUpdatesSelector = @selector(beginUpdates);
        Method beginUpdatesMethod = class_getInstanceMethod([self class], beginUpdatesSelector);
        ObjCMsgSendReturnNil originalBeginUpdates = (ObjCMsgSendReturnNil)method_getImplementation(beginUpdatesMethod);
        IMP adjustedBeginUpdatesIMP = imp_implementationWithBlock(^void(UITableView *instance){
            originalBeginUpdates(instance, beginUpdatesSelector);
            [[instance decorator] beginUpdates];
        });
        method_setImplementation(beginUpdatesMethod, adjustedBeginUpdatesIMP);

        //swizzle endUpdates
        SEL endUpdatesSelector = @selector(endUpdates);
        Method endUpdatesMethod = class_getInstanceMethod([self class], endUpdatesSelector);
        ObjCMsgSendReturnNil originalEndUpdates = (ObjCMsgSendReturnNil)method_getImplementation(endUpdatesMethod);
        IMP adjustedEndUpdatesIMP = imp_implementationWithBlock(^void(UITableView *instance){
            [[instance decorator] endUpdates];
            originalEndUpdates(instance, endUpdatesSelector);
        });
        method_setImplementation(endUpdatesMethod, adjustedEndUpdatesIMP);
    });
}

- (COOLListViewDecorator *)decorator
{
    return objc_getAssociatedObject(self, @selector(decorator));
}

- (void)setDecorator:(COOLListViewDecorator *)decorator
{
    objc_setAssociatedObject(self, @selector(decorator), decorator, OBJC_ASSOCIATION_ASSIGN);
}

- (NSIndexPath *)decoratedIndexPathForIndexPath:(NSIndexPath *)indexPath
{
    if (self.decorator) {
        return [self.decorator decoretedIndexPathForIndexPath:indexPath];
    }
    return indexPath;
}

- (NSIndexPath *)indexPathForDecoratedIndexPath:(NSIndexPath *)indexPath
{
    if (self.decorator) {
        return [self.decorator indexPathForDecoratedIndexPath:indexPath];
    }
    return indexPath;
}

@end
