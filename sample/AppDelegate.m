//
//  AppDelegate.m
//  sample
//
//  Created by hideo on 10/8/13.
//  Copyright (c) 2013 bismark. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
- (void)callback:(BSMP_CALLBACK_TYPE) type data:(void *)data;
@end

static void myCallback (BSMP_HANDLE handle, BSMP_CALLBACK_TYPE type, void *data, void *user)
{
	AppDelegate *appDelegate = (__bridge AppDelegate *) user;
	[appDelegate callback:type data:data];
}

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // Override point for customization after application launch.

  self.api = bsmpLoad ();
  
  BSMP_ERR err = BSMP_OK;
	
  if (err == BSMP_OK) {
    // initialize
    NSString *path = [[NSBundle mainBundle] pathForResource:@"GeneralUser GS SoftSynth v1.44" ofType:@"sf2"];
    const char *lib = [path cStringUsingEncoding:NSASCIIStringEncoding];
		
    // This keycode will be expire on 2017/03/31
    const unsigned char key[64] = {
        0xA9, 0x89, 0x5F, 0x31, 0xDF, 0x5E, 0x40, 0xE5,
        0x44, 0x57, 0x4F, 0x44, 0x65, 0xB2, 0x72, 0xF5,
        0xE6, 0xF1, 0xE9, 0xA7, 0xB7, 0x81, 0x4C, 0xC3,
        0x8D, 0x3B, 0xB1, 0xA7, 0xE7, 0xCF, 0x34, 0xB3,
        0x63, 0x46, 0xB4, 0x88, 0x2E, 0x72, 0xB8, 0x5B,
        0xEF, 0x24, 0xFF, 0xE1, 0x41, 0x67, 0x82, 0x82,
        0x49, 0xE8, 0x49, 0x28, 0x6C, 0xD0, 0xA0, 0x99,
        0x15, 0x43, 0x90, 0xFB, 0x6B, 0x77, 0xCE, 0x88,
    };

    err = self.api->initializeWithSoundLib (&_handle, myCallback, (__bridge void *) self, (const char *) lib, NULL, key);
	}

  if (err == BSMP_OK) {
    int value = 512;
    self.api->ctrl (self.handle, BSMP_CTRL_SET_NUMBER_OF_REGIONS, &value, sizeof (value));
  }
  
  if (err != BSMP_OK) {
    NSLog (@"ERROR - initialize synthesizer");
  }
  
  return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)callback:(BSMP_CALLBACK_TYPE) type data:(void *)data
{
	switch (type) {
    case BSMP_CALLBACK_TYPE_OPEN:
      NSLog (@"opened");
      break;
    case BSMP_CALLBACK_TYPE_CLOSE:
      NSLog (@"closeed");
      break;
    case BSMP_CALLBACK_TYPE_START:
      NSLog (@"started");
      break;
    case BSMP_CALLBACK_TYPE_STOP:
      NSLog (@"stopped");
      break;
    case BSMP_CALLBACK_TYPE_SEEK:
      NSLog (@"seeked");
      break;
    case BSMP_CALLBACK_TYPE_CLOCK:
      self.clocks++;
      break;
    case BSMP_CALLBACK_TYPE_TEMPO:
#if __LP64__
      NSLog (@"tempo = %u[usec/beat]", *(unsigned int *) data);
#else
      NSLog (@"tempo = %lu[usec/beat]", *(unsigned long *) data);
#endif
      break;
    case BSMP_CALLBACK_TYPE_TIME_SIGNATURE:
#if __LP64__
      NSLog (@"set time signature = %u", *(unsigned int *) data);
#else
      NSLog (@"set time signature = %lu", *(unsigned long *) data);
#endif
      break;
    case BSMP_CALLBACK_TYPE_CHANNEL_MESSAGE:
/*
      {
        unsigned char status = (*(unsigned long *) data >> 16) & 0x000000FF;
        unsigned char data1 = (*(unsigned long *) data >> 8) & 0x000000FF;
        unsigned char data2 = (*(unsigned long *) data >> 0) & 0x000000FF;
        NSLog (@"channel message %02X %02X %02X", status, data1, data2);
      }
*/
      break;
    default:
      break;
	}
}

@end
