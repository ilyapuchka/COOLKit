//
//  NSArray+Extensions.m
//  CoolEvents
//
//  Created by Ilya Puchka on 08.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "NSArray+Extensions.h"

@implementation NSArray (Extensions)

- (instancetype)cool_addObject:(id)object
{
    NSCParameterAssert(object);
    if (object) {
        return [self arrayByAddingObject:object];
    }
    return self;
}

- (instancetype)cool_removeObject:(id)object
{
    NSMutableArray *mSelf = [self mutableCopy];
    [mSelf removeObject:object];
    return [mSelf copy];
}

@end
