//
//  COOLTableViewWrapper.h
//  COOLDecorators
//
//  Created by Ilya Puchka on 14.11.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import "COOLWrapper.h"
#import "COOLIndexPathsMapping.h"

@interface COOLTableViewWrapper : COOLWrapper

+ (instancetype)wrapperFor:(UITableView *)view;

@property (nonatomic, strong) id<COOLIndexPathsMapping> indexPathsMapping;

- (UITableView *)wrappedObject;
- (UITableView *)tableView;

@end
