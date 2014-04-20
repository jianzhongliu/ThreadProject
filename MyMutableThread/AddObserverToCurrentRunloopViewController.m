//
//  AddObserverToCurrentRunloopViewController.m
//  MyMutableThread
//
//  Created by yons on 14-4-20.
//  Copyright (c) 2014年 anjuke. All rights reserved.
//

#import "AddObserverToCurrentRunloopViewController.h"

@interface AddObserverToCurrentRunloopViewController ()

@end

@implementation AddObserverToCurrentRunloopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)click{
    NSRunLoop *myRunLoop = [NSRunLoop currentRunLoop];
    CFRunLoopObserverContext  context = {0,(__bridge void *)(self), NULL,NULL, NULL};
    
    CFRunLoopObserverRef    observer =CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                              
                                                              kCFRunLoopBeforeTimers,YES, 0, &myRunLoopObserver, &context);
     CFRunLoopRef    cfLoop = [myRunLoop getCFRunLoop];
    CFRunLoopRemoveObserver(cfLoop, observer, kCFRunLoopDefaultMode);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeInfoDark];
    but.frame = CGRectMake(10, 100, 40, 40);
    but.backgroundColor = [UIColor greenColor];
    [but addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:but];
    
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:10.0];
    NSTimer *cameraTimer = [[NSTimer alloc] initWithFireDate:fireDate interval:10.0 target:self selector:@selector(timedPhotoFire) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:cameraTimer forMode:NSDefaultRunLoopMode];
    
    [self addObserverToCurrentRunloop];
	// Do any additional setup after loading the view.
}

- (void)timedPhotoFire {
    NSLog(@"===为什么不加到runloop就不跑了====");
}

- (void)addObserverToCurrentRunloop
{
    // The application uses garbage collection, so noautorelease pool is needed.
    NSRunLoop*myRunLoop = [NSRunLoop currentRunLoop];
    // Create a run loop observer and attach it to the runloop.
    CFRunLoopObserverContext  context = {0,(__bridge void *)(self), NULL,NULL, NULL};
    CFRunLoopObserverRef    observer =CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopBeforeTimers, YES, 0, &myRunLoopObserver, &context);
    if (observer)
    {
        CFRunLoopRef    cfLoop = [myRunLoop getCFRunLoop];
        CFRunLoopAddObserver(cfLoop, observer, kCFRunLoopDefaultMode);
    }
}

void myRunLoopObserver(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
            //The entrance of the run loop, before entering the event processing loop.
            //This activity occurs once for each call to CFRunLoopRun and CFRunLoopRunInMode
        case kCFRunLoopEntry:
            NSLog(@"run loop entry");
            break;
            //Inside the event processing loop before any timers are processed
        case kCFRunLoopBeforeTimers:
            NSLog(@"run loop before timers");
            break;
            //Inside the event processing loop before any sources are processed
        case kCFRunLoopBeforeSources:
            NSLog(@"run loop before sources");
            break;
            //Inside the event processing loop before the run loop sleeps, waiting for a source or timer to fire.
            //This activity does not occur if CFRunLoopRunInMode is called with a timeout of 0 seconds.
            //It also does not occur in a particular iteration of the event processing loop if a version 0 source fires
        case kCFRunLoopBeforeWaiting:
            NSLog(@"run loop before waiting");
            break;
            //Inside the event processing loop after the run loop wakes up, but before processing the event that woke it up.
            //This activity occurs only if the run loop did in fact go to sleep during the current loop
        case kCFRunLoopAfterWaiting:
            NSLog(@"run loop after waiting");
            break;
            //The exit of the run loop, after exiting the event processing loop.
            //This activity occurs once for each call to CFRunLoopRun and CFRunLoopRunInMode
        case kCFRunLoopExit:
            NSLog(@"run loop exit");
            break;
            /*
             A combination of all the preceding stages
             case kCFRunLoopAllActivities:
             break;
             */
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
