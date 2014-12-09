//
//  COOLMapper.h
//  COOLNetworkStack
//
//  Created by Ilya Puchka on 04.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol COOLMapper <NSObject>

+ (id)objectFromExternalRepresentation:(id)externalRepresentation ofClass:(Class)mappedClass;
+ (NSArray *)arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation ofClass:(Class)mappedClass;

@end
