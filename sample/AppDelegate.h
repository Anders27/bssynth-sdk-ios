//
//  AppDelegate.h
//  sample
//
//  Created by hideo on 10/8/13.
//  Copyright (c) 2013 bismark. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "bsmp.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property BSMP_FUNC *api;
@property BSMP_HANDLE handle;
@property NSInteger clocks;

@end
