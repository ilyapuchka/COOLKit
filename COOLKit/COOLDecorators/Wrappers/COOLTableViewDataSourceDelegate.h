//
//  COOLTableViewDataSourceDelegate.h
//  COOLKit
//
//  Created by Ilya Puchka on 01.01.15.
//  Copyright (c) 2015 Ilya Puchka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "COOLTableViewDisplayDataSource.h"

@protocol COOLTableViewDataSourceDelegate <UITableViewDataSource, UITableViewDelegate, COOLTableViewDisplayDataSource>

@end