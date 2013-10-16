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
		
    // This keycode will be expire on 2013/12/31
    const unsigned char key[64] = {
      0xE1, 0xF1, 0x4B, 0xF9, 0x39, 0xA7, 0x6C, 0x32,
      0xC9, 0xB5, 0xC5, 0xA6, 0xD7, 0x3A, 0x22, 0x91,
      0x4B, 0x2F, 0xEC, 0xB4, 0xE1, 0xD5, 0x9B, 0x29,
      0x15, 0xFF, 0x4D, 0x18, 0x72, 0xC8, 0xCF, 0x86,
      0x33, 0xC6, 0xC1, 0x6D, 0xA0, 0x89, 0x4B, 0xD4,
      0xDB, 0x0B, 0x82, 0xC0, 0x26, 0x9B, 0x05, 0x4E,
      0x93, 0x60, 0x6E, 0xFB, 0xAA, 0x73, 0x92, 0x1D,
      0x34, 0x7A, 0x4C, 0x23, 0x73, 0x2A, 0xDC, 0x87,
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
      NSLog (@"tempo = %lu[usec/beat]", *(unsigned long *) data);
      break;
    case BSMP_CALLBACK_TYPE_TIME_SIGNATURE:
      NSLog (@"set time signature = %lu", *(unsigned long *) data);
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
