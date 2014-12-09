//
//  COOLWrapper.m
//  COOLDecorators
//
//  Created by Ilya Puchka on 14.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLWrapper.h"
#import <objc/runtime.h>

@interface COOLWrapper()

@property (nonatomic, weak) NSObject *wrappedObject;

@end

@implementation COOLWrapper

+ (instancetype)wrapperFor:(NSObject *)object
{
    NSCParameterAssert(object);
    NSAssert([object isKindOfClass:[self wrappedClass]], @"View should be of class %@", [self wrappedClass]);
    if (![object isKindOfClass:[self wrappedClass]]) {
        return nil;
    }
    
    COOLWrapper *wrapper = [[[self class] alloc] init];
    
    wrapper.wrappedObject = object;
    return wrapper;
}

- (void)setWrappedObject:(NSObject *)wrappedObject
{
    if (_wrappedObject != wrappedObject) {
        [self releaseLifetimeFromObject:_wrappedObject];
        _wrappedObject = wrappedObject;
        [self bindLifetimeToObject:_wrappedObject];
    }
}

+ (Class)wrappedClass
{
    return [NSObject class];
}

#pragma mark - Private

- (void)bindLifetimeToObject:(id)object
{
    objc_setAssociatedObject(object, (__bridge void *)self, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)releaseLifetimeFromObject:(id)object
{
    objc_setAssociatedObject(object, (__bridge void *)self, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Invocations forwarding

- (BOOL)isKindOfClass:(Class)aClass
{
    BOOL isKindOfClass;
    if (!(isKindOfClass = [super isKindOfClass:aClass])) {
        isKindOfClass = [self.wrappedObject isKindOfClass:aClass];
    }
    return isKindOfClass;
}

- (BOOL)isMemberOfClass:(Class)aClass
{
    BOOL isMemberOfClass;
    if (!(isMemberOfClass = [super isMemberOfClass:aClass])) {
        isMemberOfClass = [self.wrappedObject isMemberOfClass:aClass];
    }
    return isMemberOfClass;
}

- (BOOL)isEqual:(id)object
{
    BOOL isEqual;
    if (!(isEqual = [super isEqual:object])) {
        isEqual = [self.wrappedObject isEqual:object];
    }
    return isEqual;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return _wrappedObject;
}

+ (NSMethodSignature *)instanceMethodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *signature = [super instanceMethodSignatureForSelector:selector];
    if (signature)
        return signature;
    
    return [[self wrappedClass] instanceMethodSignatureForSelector:selector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if (signature)
        return signature;
    else
        return [[self forwardingTargetForSelector:selector] methodSignatureForSelector:selector];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    BOOL responds = [super respondsToSelector:aSelector];
    if (!responds)
        responds = [[self forwardingTargetForSelector:aSelector] respondsToSelector:aSelector];
    return responds;
}

+ (BOOL)instancesRespondToSelector:(SEL)selector
{
    if (!selector)
        return NO;
    
    if (class_respondsToSelector(self, selector))
        return YES;
    
    if ([[self wrappedClass] instancesRespondToSelector:selector])
        return YES;
    
    return NO;
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return [_wrappedObject valueForKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    [_wrappedObject setValue:value forKey:key];
}

@end
