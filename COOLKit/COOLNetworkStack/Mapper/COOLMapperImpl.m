//
//  COOLMapperImpl.m
//  COOLNetworkStack
//
//  Created by Ilya Puchka on 04.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLMapperImpl.h"
#import "COOLMapping.h"

@implementation COOLMapperImpl

+ (id)objectFromExternalRepresentation:(NSDictionary *)externalRepresentation ofClass:(Class)mappedClass
{
    if ([mappedClass mapping]) {
        if (externalRepresentation != nil) {
            if ([externalRepresentation isKindOfClass:[NSArray class]]) {
                return [super arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation
                                                           withMapping:[mappedClass mapping]];
            }
            else if ([externalRepresentation isKindOfClass:[NSDictionary class]]) {
                return [super objectFromExternalRepresentation:externalRepresentation
                                                   withMapping:[mappedClass mapping]];
            }
        }
    }
    return nil;
}

+ (NSArray *)arrayOfObjectsFromExternalRepresentation:(NSArray *)externalRepresentation ofClass:(Class)mappedClass
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *representation in externalRepresentation) {
        id parsedObject = [self objectFromExternalRepresentation:representation withMapping:[mappedClass mapping]];
        if (parsedObject) [array addObject:parsedObject];
    }
    return [NSArray arrayWithArray:array];
}

@end
