//
//  COOLWrapper.h
//  COOLDecorators
//
//  Created by Ilya Puchka on 14.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import <UIKit/UIKit.h>

//Wrapper will be retained by wrapped object
@interface COOLWrapper : NSObject {
    __weak NSObject *_wrappedObject;
}

+ (instancetype)wrapperFor:(NSObject *)object;
+ (Class)wrappedClass;
- (NSObject *)wrappedObject;

@end
