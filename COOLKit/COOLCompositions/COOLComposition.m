//
//  COOLComposition.m
//  CoolEvents
//
//  Created by Ilya Puchka on 08.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLComposition.h"
#import "NSArray+Extensions.h"

enum NSUInteger {
    COOLCompositionMakeAll = -2,
    COOLCompositionMakeFirst = -1,
};

@interface COOLComposition()

@property (nonatomic) NSInteger forwardTargetIndex;

@end

@implementation COOLComposition

- (instancetype)init
{
    return [self initWithArray:nil];
}

- (instancetype)initWithArray:(NSArray *)objects
{
    self = [super init];
    if (self) {
        _objects = [objects copy];
        _forwardTargetIndex = COOLCompositionMakeFirst;
    }
    return self;
}

- (void)addObject:(id)object
{
    self.objects = [self.objects?:@[] cool_addObject:object];
}

- (void)removeObject:(id)object
{
    self.objects = [self.objects cool_removeObject:object];
}

- (void)removeObjectAtIndex:(NSUInteger)idx
{
    self.objects = [self.objects cool_removeObject:self.objects[idx]];
}

- (NSUInteger)count
{
    return [self.objects count];
}

- (NSUInteger)indexOfObject:(id)object
{
    return [self.objects indexOfObject:object];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    return [self.objects objectAtIndexedSubscript:idx];
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx
{
    NSMutableArray *mObjects = [self.objects mutableCopy];
    [mObjects setObject:obj atIndexedSubscript:idx];
    self.objects = mObjects;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len
{
    return [self.objects countByEnumeratingWithState:state objects:buffer count:len];
}

- (instancetype)makeAll
{
    self.forwardTargetIndex = COOLCompositionMakeAll;
    return self;
}

- (instancetype)makeFirst
{
    self.forwardTargetIndex = COOLCompositionMakeFirst;
    return self;
}

- (instancetype)makeAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        self.forwardTargetIndex = index;
    }
    return self;
}

- (void)performOnFirstResponder:(void (^)(COOLComposition *))performBlock
{
    [self makeFirst];
    performBlock(self);
    [self makeAll];
}

- (void)perform:(void (^)(COOLComposition *))performBlock onObjectWithIndex:(NSInteger)index
{
    [self makeAtIndex:index];
    performBlock(self);
    [self makeAll];
}

#pragma mark - Invocations forwarding

- (BOOL)isKindOfClass:(Class)aClass
{
    BOOL isKindOfClass = [super isKindOfClass:aClass];
    if (!isKindOfClass) {
        if (self.forwardTargetIndex >= 0) {
            isKindOfClass = [self.objects[self.forwardTargetIndex] isKindOfClass:aClass];
        }
        else {
            for (id obj in self.objects) {
                isKindOfClass = [obj isKindOfClass:aClass];
                if (isKindOfClass) {
                    break;
                }
            }
        }
    }
    return isKindOfClass;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    BOOL respondsToSelector = [super respondsToSelector:aSelector];
    if (!respondsToSelector) {
        if (self.forwardTargetIndex >= 0) {
            respondsToSelector = [self.objects[self.forwardTargetIndex] respondsToSelector:aSelector];
        }
        else {
            for (id obj in self.objects) {
                respondsToSelector = [obj respondsToSelector:aSelector];
                if (respondsToSelector) {
                    break;
                }
            }
        }
    }
    return respondsToSelector;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *methodSignatureForSelector = [super methodSignatureForSelector:aSelector];
    if (!methodSignatureForSelector) {
        if (self.forwardTargetIndex >= 0) {
            methodSignatureForSelector = [self.objects[self.forwardTargetIndex] methodSignatureForSelector:aSelector];
        }
        else {
            for (id obj in self.objects) {
                methodSignatureForSelector = [obj methodSignatureForSelector:aSelector];
                if (methodSignatureForSelector) {
                    break;
                }
            }
        }
    }
    return methodSignatureForSelector;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL aSelector = [anInvocation selector];
    if (self.forwardTargetIndex >= 0) {
        id obj = self.objects[self.forwardTargetIndex];
        [anInvocation invokeWithTarget:obj];
    }
    else {
        for (id obj in self.objects) {
            if ([obj respondsToSelector:aSelector]) {
                [anInvocation invokeWithTarget:obj];
                if (self.forwardTargetIndex == COOLCompositionMakeFirst) {
                    break;
                }
            }
        }
    }
}

@end
