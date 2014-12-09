//
//  COOLSwitchComposition.m
//  CoolEvents
//
//  Created by Ilya Puchka on 08.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLSwitchComposition.h"
#import "NSArray+Extensions.h"

@interface COOLSwitchComposition()

@property (nonatomic, strong) NSObject *currentObject;
@property (nonatomic, assign) NSUInteger currentObjectIndex;

@end

@implementation COOLSwitchComposition

- (instancetype)init
{
    return [self initWithArray:nil];
}

- (instancetype)initWithArray:(NSArray *)objects
{
    self = [super init];
    if (self) {
        _objects = [objects copy];
        [self switchToObjectAtIndex:0];
    }
    return self;
}

- (BOOL)switchToObject:(id)object
{
    if ([self.objects containsObject:object]) {
        self.currentObject = object;
        self.currentObjectIndex = [self.objects indexOfObject:object];
        return YES;
    }
    return NO;
}

- (BOOL)switchToObjectAtIndex:(NSUInteger)index
{
    if (index < self.objects.count) {
        self.currentObjectIndex = index;
        self.currentObject = self.objects[index];
        return YES;
    }
    return NO;
}

- (void)addObject:(id)object
{
    self.objects = [self.objects?:@[] cool_addObject:object];
}

- (void)removeObject:(id)object
{
    if (object == self.currentObject) {
        [NSException raise:@"Invalid object" format:@"Can not remove currently active object"];
    }
    self.objects = [self.objects cool_removeObject:object];
}

- (void)removeObjectAtIndex:(NSUInteger)idx
{
    if (idx == self.currentObjectIndex) {
        [NSException raise:@"Invalid object" format:@"Can not remove currently active object"];
    }
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

#pragma mark - Invocations forwarding

- (BOOL)isKindOfClass:(Class)aClass
{
    BOOL isKindOfClass = [super isKindOfClass:aClass];
    if (!isKindOfClass) {
        isKindOfClass = [self.currentObject isKindOfClass:aClass];
    }
    return isKindOfClass;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    BOOL respondsToSelector = [super respondsToSelector:aSelector];
    if (!respondsToSelector) {
        respondsToSelector = [self.currentObject respondsToSelector:aSelector];
    }
    return respondsToSelector;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self.currentObject respondsToSelector:aSelector]) {
        return self.currentObject;
    }
    return nil;
}

@end
