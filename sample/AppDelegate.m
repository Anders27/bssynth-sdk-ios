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
        
        // This keycode will be expire on 2018/03/31
        const unsigned char key[64] = {
            0xA9, 0x89, 0x5F, 0x31, 0xDF, 0x5E, 0x40, 0xE5,
            0x15, 0xDC, 0x93, 0x02, 0xDC, 0x97, 0xFC, 0x85,
            0xB5, 0x9F, 0x5B, 0x43, 0x22, 0x73, 0xE3, 0x34,
            0x92, 0x70, 0x70, 0xFA, 0x6B, 0xFC, 0xC6, 0x97,
            0x40, 0x21, 0xD0, 0xF4, 0x30, 0x91, 0x10, 0x54,
            0x56, 0x2F, 0xEE, 0x9B, 0xEF, 0x42, 0x50, 0x1C,
            0x9A, 0xB7, 0xC9, 0x1A, 0xEF, 0x7F, 0x1B, 0x76,
            0x33, 0x8E, 0x2A, 0xB2, 0x7E, 0x78, 0x0F, 0x69,
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

