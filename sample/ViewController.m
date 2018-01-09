//
//  ViewController.m
//  sample
//
//  Created by hideo on 10/8/13.
//  Copyright (c) 2013 bismark. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface ViewController ()
{
    NSTimer *timer;
    unsigned short division;
}

@property (weak, nonatomic) IBOutlet UISlider *seekSlider;
@property (weak, nonatomic) IBOutlet UISwitch *reverbSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *chorusSwitch;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    BSMP_ERR err = BSMP_OK;
    
    if (err == BSMP_OK) {
        // revweb on
        int value = (int) self.reverbSwitch.isOn;
        err = appDelegate.api->ctrl (appDelegate.handle, BSMP_CTRL_SET_REVERB, &value, sizeof (value));
    }
    
    if (err == BSMP_OK) {
        // chorus on
        int value = (int) self.chorusSwitch.isOn;
        err = appDelegate.api->ctrl (appDelegate.handle, BSMP_CTRL_SET_CHORUS, &value, sizeof (value));
    }
    
    if (err == BSMP_OK) {
        // set midi contents
        NSString *path = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"mid"];
        const char *lib = [path cStringUsingEncoding:NSShiftJISStringEncoding];
        err = appDelegate.api->setFile (appDelegate.handle, lib);
    }
    
    if (err == BSMP_OK) {
        unsigned long totaltick;
        appDelegate.api->getFileInfo (appDelegate.handle, NULL, &division, &totaltick, NULL);
        NSInteger clocks = totaltick * 24 / division;
        NSLog (@"total %lu tick = %ld MIDI clocks", totaltick, (long)clocks);
        [self.seekSlider setMaximumValue:clocks];
    }
    
    if (err == BSMP_OK) {
        // open wave output device
        err = appDelegate.api->open (appDelegate.handle, NULL, NULL);
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    BSMP_ERR err = BSMP_OK;
    
    if (err == BSMP_OK) {
        // close wave output device
        err = appDelegate.api->close (appDelegate.handle);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)start:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    if (appDelegate.api->isPlaying (appDelegate.handle) == 0) {
        appDelegate.api->start (appDelegate.handle);
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateSlider:) userInfo:nil repeats:YES];
    }
}

- (IBAction)stop:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    if (appDelegate.api->isPlaying (appDelegate.handle) == 1) {
        appDelegate.api->stop (appDelegate.handle);
        [timer invalidate];
    }
}

- (IBAction)seek:(UISlider *)sender
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    appDelegate.clocks = 0;
    unsigned long tick = sender.value * division / 24;
    NSLog (@"seek %lu tick = %.0f MIDI clocks", tick, sender.value);
    appDelegate.api->seek (appDelegate.handle, tick);
}

- (IBAction)keyControl:(UIStepper *)sender
{
    int value = sender.value;
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    appDelegate.api->ctrl (appDelegate.handle, BSMP_CTRL_SET_MASTER_KEY, &value, sizeof (value));
}

- (IBAction)speedControl:(UIStepper *)sender {
    int value = sender.value;
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    appDelegate.api->ctrl (appDelegate.handle, BSMP_CTRL_SET_SPEED, &value, sizeof (value));
}

- (IBAction)reverb:(UISwitch *)sender
{
    int value = sender.isOn;
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    appDelegate.api->ctrl (appDelegate.handle, BSMP_CTRL_SET_REVERB, &value, sizeof (value));
}

- (IBAction)chorus:(UISwitch *)sender
{
    int value = sender.isOn;
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    appDelegate.api->ctrl (appDelegate.handle, BSMP_CTRL_SET_CHORUS, &value, sizeof (value));
}

- (void)updateSlider:(NSTimer *)timer
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    if (self.seekSlider.touchInside == NO) {
        [self.seekSlider setValue:appDelegate.clocks];
    }
}

@end

