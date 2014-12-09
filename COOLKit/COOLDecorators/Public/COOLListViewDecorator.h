//
//  COOLListViewDecorator.h
//  COOLDecorators
//
//  Created by Ilya Puchka on 13.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol COOLListView <NSObject>

@property (nonatomic, weak) id delegate;
@property (nonatomic, weak) id dataSource;

@end

@interface COOLListViewDecorator : NSObject

@end