//
//  NSString+Extensions.m
//  CoolEvents
//
//  Created by Ilya Puchka on 08.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "NSString+Extensions.h"

@implementation NSString (Extensions)

- (NSString *)cool_firstLetterUppercasedString
{
    NSMutableString *mSelf = [self mutableCopy];
    NSRange range = NSMakeRange(0, 1);
    [mSelf replaceCharactersInRange:range withString:[[self substringWithRange:range] uppercaseString]];
    return [mSelf copy];
}

@end
