//
//  COOLLoadableContentViewController.h
//  COOLKit
//
//  Created by Ilya Puchka on 25.12.14.
//  Copyright (c) 2014 Ilya Puchka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "COOLLoadableContentView.h"

@interface COOLLoadableContentViewController : UIViewController <COOLLoadableContentViewDelegate>

@property (nonatomic, retain) COOLLoadableContentView *loadableContentView;

@end
