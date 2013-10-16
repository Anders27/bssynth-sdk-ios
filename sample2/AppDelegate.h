//
//  AppDelegate.h
//  sample2
//
//  Created by hideo on 10/8/13.
//  Copyright (c) 2013 bismark. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "bsmd.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property BSMD_FUNC *api;
@property BSMD_HANDLE handle;

@end
