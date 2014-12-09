//
//  COOLSwitchComposition.h
//  CoolEvents
//
//  Created by Ilya Puchka on 08.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLComposition.h"

@protocol COOLSwitchComposition <COOLComposition>

- (id)currentObject;
- (NSUInteger)currentObjectIndex;

- (BOOL)switchToObject:(id)object;
- (BOOL)switchToObjectAtIndex:(NSUInteger)index;

@end

//Methods that are not implemented are passed to current object. If current object does not implement passed method, COOLComposition behaviour is applied.
@interface COOLSwitchComposition : NSObject <COOLSwitchComposition, NSFastEnumeration> {
    NSArray *_objects;
    NSObject *_currentObject;
    NSUInteger _currentObjectIndex;
}

@property (nonatomic, copy) NSArray *objects;

@end
