//
//  AppDelegate.m
//  sample2
//
//  Created by hideo on 10/8/13.
//  Copyright (c) 2013 bismark. All rights reserved.
//

#import <AVFoundation/AVAudioSession.h>
#import <AudioToolBox/AudioServices.h>

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // Override point for customization after application launch.

  AVAudioSession *audioSession = [AVAudioSession sharedInstance];
  [audioSession setCategory:AVAudioSessionCategoryAmbient error:nil];
  [audioSession setActive:YES error:nil];
  [audioSession setPreferredIOBufferDuration:0.005 error:nil];

  self.api = bsmdLoad ();
  BSMD_ERR err = BSMD_OK;
	
  if (err == BSMD_OK) {
    // initialize
    NSString *path = [[NSBundle mainBundle] pathForResource:@"GeneralUser GS SoftSynth v1.44" ofType:@"sf2"];
    const char *lib = [path cStringUsingEncoding:NSASCIIStringEncoding];

    // This keycode will be expire on 2016/07/31
    const unsigned char key[64] = {
        0xA9, 0x89, 0x5F, 0x31, 0xDF, 0x5E, 0x40, 0xE5,
        0x9B, 0xA2, 0x5D, 0x2E, 0xE3, 0x7F, 0x1A, 0xB9,
        0x3D, 0xEF, 0x40, 0x5B, 0x7A, 0xF4, 0x52, 0x5A,
        0x87, 0x10, 0xAC, 0x29, 0xF6, 0x64, 0x31, 0x4B,
        0x63, 0x3A, 0xC2, 0xED, 0x95, 0x6F, 0xC4, 0x29,
        0x85, 0xA6, 0x83, 0xB0, 0x1F, 0x00, 0x9B, 0x07,
        0x23, 0xDB, 0x33, 0xC0, 0x3C, 0xDE, 0xB1, 0x6F,
        0xA2, 0x9A, 0x80, 0x91, 0x56, 0x71, 0x9C, 0x57,
    };

    err = self.api->initializeWithSoundLib (&_handle, NULL, NULL, lib, NULL, key);
  }
  
  if (err == BSMD_OK) {
    // reverb on
    int value = 1;
    err = self.api->ctrl (self.handle, BSMD_CTRL_SET_REVERB, &value, sizeof (value));
  }
    
  if (err == BSMD_OK) {
    // open wave output device
    err = self.api->open (self.handle, NULL, NULL);
  }
  
  if (err == BSMD_OK) {
    // start realtime MIDI
    err = self.api->start (self.handle);
  }

	if (err == BSMD_OK) {
    int value = 512;
    self.api->ctrl (self.handle, BSMD_CTRL_SET_NUMBER_OF_REGIONS, &value, sizeof (value));
  }
  
  if (err != BSMD_OK) {
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

@end
