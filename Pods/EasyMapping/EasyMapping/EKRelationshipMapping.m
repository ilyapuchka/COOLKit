//
//  EKRelationshipMapping.m
//  EasyMappingExample
//
//  Created by Denys Telezhkin on 14.06.14.
//  Copyright (c) 2014 EasyKit. All rights reserved.
//

#import "EKRelationshipMapping.h"

@implementation EKRelationshipMapping

-(EKObjectMapping*)objectMapping
{
    return (_objectMapping == nil) ? [_objectClass objectMapping] : _objectMapping;
}

@end
