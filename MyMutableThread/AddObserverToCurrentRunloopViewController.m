//
//  AddObserverToCurrentRunloopViewController.m
//  MyMutableThread
//
//  Created by yons on 14-4-20.
//  Copyright (c) 2014年 anjuke. All rights reserved.
//

#import "AddObserverToCurrentRunloopViewController.h"

@interface AddObserverToCurrentRunloopViewController ()

@property (nonatomic, strong) NSTimer *timer;

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
    
    CFRunLoopObserverRef    observer =CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopBeforeTimers,YES, 0, &myRunLoopObserver, &context);
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
    
    //schedule这种方式创建timer，当执行到timerSchedule方法时，mode还是kCFRunLoopDefaultMode，并且在主线程
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timerSchedul) userInfo:nil repeats:YES];
    [self.timer fire];
    
    //解释下timer这个东西
    //1,这里解释下为什么timer一般无法释放，原因是timer会给方法的接受者retain一份对象内存
    //2，timer的这个方法scheduledTimerWithTimeInterval实质上是做了两件事，第一件事是创建timer，第二件事是把他添加到defaultmode中
    //3，NSTimer其实只能跟runloop合并使用
    //4，按照上面的理解，NSTimer计时肯定不准，因为当前线程当前这个mode很可能资源不够被卡主，这个时候timer就不准了
//    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:2.0];
//    NSTimer *cameraTimer = [[NSTimer alloc] initWithFireDate:fireDate interval:2.0 target:self selector:@selector(timedPhotoFire) userInfo:nil repeats:YES];
    
//runloop1
//能让timer跑起来，但是主界面卡死了，不能有用户操作
//    NSRunLoop *timerRunLoop = [NSRunLoop currentRunLoop];
//    [timerRunLoop addTimer:cameraTimer forMode:kCFRunLoopDefaultMode];
//    [timerRunLoop run];
    
    //runloop2
    //效果和1一样，原因未知，runloop2的runloop不需要调用run方法，因为mainrunloop默认会run
//    [[NSRunLoop mainRunLoop] addTimer:cameraTimer forMode:NSDefaultRunLoopMode];
    
    [self addObserverToCurrentRunloop];
}

- (void)timerSchedul {
    NSString* runLoopMode = [[NSRunLoop currentRunLoop] currentMode];
    NSThread *thread = [NSThread currentThread];
    NSLog(@"%@===%d", runLoopMode, thread.isMainThread);
}

- (void)timedPhotoFire {
    NSString* runLoopMode = [[NSRunLoop currentRunLoop] currentMode];
    NSLog(@"===为什么不加到runloop就不跑了====%@", runLoopMode);
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

@end
