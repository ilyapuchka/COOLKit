//
//  COOLComposition.h
//  CoolEvents
//
//  Created by Ilya Puchka on 08.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol COOLComposition <NSObject, NSFastEnumeration>

- (instancetype)initWithArray:(NSArray *)objects;

- (void)addObject:(id)object;

- (void)removeObject:(id)object;
- (void)removeObjectAtIndex:(NSUInteger)idx;

- (NSUInteger)indexOfObject:(id)object;

- (NSUInteger)count;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;

@end

//Methods that are not implemented in composition are passed to objects from composition. By default methods are called only on first object from composition that responds to this selector.
@interface COOLComposition : NSObject <COOLComposition> {
    NSArray *_objects;
}

@property (nonatomic, copy) NSArray *objects;

//all methods inside block will be performed on all object in composition that responds to this method.
//outside the block messages are passed only to the first responding object
//block should call only those methods that are executed on the same thread where this method was called
- (void)performOnAllObjects:(void(^)(COOLComposition *composition))performBlock;

//all methods inside block will be performed on object at particular index
//outside the block messages are passed to all objects one after another
//block should call only those methods that are executed on the same thread where this method was called
- (void)perform:(void(^)(COOLComposition *composition))performBlock onObjectAtIndex:(NSInteger)index;

@end
