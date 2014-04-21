//
//  RootViewController.m
//  MyMutableThread
//
//  Created by jianzhongliu on 4/17/14.
//  Copyright (c) 2014 anjuke. All rights reserved.
//

#import "RootViewController.h"
#include <assert.h>
#include <pthread.h>
#import "AddObserverToCurrentRunloopViewController.h"
#import "ThreadLockViewController.h"
#import "GCDThreadFirstViewController.h"

@interface RootViewController ()


@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

void* PosixThreadMainRoutine(void* data)
{
    return NULL;
}

- (void) LaunchThread
{
    pthread_attr_t attr;
    pthread_t posixThreadID;
    int returnVal;
    returnVal = pthread_attr_init(&attr);
    assert(!returnVal);
    returnVal = pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
    assert(!returnVal);
    int threadError = pthread_create(&posixThreadID, &attr, &PosixThreadMainRoutine, NULL);
    returnVal = pthread_attr_destroy(&attr);
    assert(!returnVal);
    if (threadError != 0)
    {
    }
}

- (void)threadMainRoutine
{
    BOOL moreWorkToDo = YES;
    BOOL exitNow = NO;

    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    // Add the exitNow BOOL to the thread dictionary.
    NSMutableDictionary* threadDict = [[NSThread currentThread] threadDictionary];
    [threadDict setValue:[NSNumber numberWithBool:exitNow]  forKey:@"ThreadShouldExitNow"];
    // Install an input source.
//    [self myInstallCustomInputSource];
    while (moreWorkToDo && !exitNow)
    {
        // Do one chunk of a larger body of work here.
        // Change the value of the moreWorkToDo Boolean when done.
        // Run the run loop but timeout immediately if the input source isn't waiting to fire.
     [runLoop runUntilDate:[NSDate date]];
        // Check to see if an input source handler changed the exitNow value.
        exitNow = [[threadDict valueForKey:@"ThreadShouldExitNow"] boolValue];
    }
}
- (void)click {
    AddObserverToCurrentRunloopViewController *controller = [[AddObserverToCurrentRunloopViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navi animated:YES completion:Nil];
    
}
- (void)click1 {
    ThreadLockViewController *controller = [[ThreadLockViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navi animated:YES completion:Nil];
    
}
- (void)click2 {
    GCDThreadFirstViewController *controller = [[GCDThreadFirstViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navi animated:YES completion:Nil];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *but = [UIButton buttonWithType:UIButtonTypeInfoDark];
    but.frame = CGRectMake(10, 100, 40, 40);
    [but addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:but];
    
    UIButton *but1 = [UIButton buttonWithType:UIButtonTypeCustom];
    but1.frame = CGRectMake(10, 200, 40, 40);
    [but1 setTitle:@"lock" forState:UIControlStateNormal];
    [but1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [but1 addTarget:self action:@selector(click1) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:but1];
    
    UIButton *but2 = [UIButton buttonWithType:UIButtonTypeCustom];
    but2.frame = CGRectMake(10, 300, 40, 40);
    [but2 setTitle:@"GCD" forState:UIControlStateNormal];
    [but2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [but2 addTarget:self action:@selector(click2) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:but2];
//    [self threadMain];
    //因为 POSIX 创建的线程默认情况是可连接的(joinable),下面的例子改变线程的属性来创 建一个脱离的线程。把线程标记为脱离的,当它退出的时候让系统有机会立即回收该 线程的资源。
    //利用posix来创建线程，该技术可以被任何类型的应用程序使用
//    [self LaunchThread];
    
    //下面两种方式创建开销一样的
    //NSThread第一种方式
//    [NSThread detachNewThreadSelector:@selector(myThreadMainMethod) toTarget:self withObject:nil];
    //NSThread第二种方式
//    NSThread* myThread = [[NSThread alloc] initWithTarget:self
//                                                 selector:@selector(myThreadMainMethod)
//                                                   object:nil];
//    [myThread start]; // Actually create the thread
    // Do any additional setup after loading the view.
}

- (void)threadMain
{
    // The application uses garbage collection, so no autorelease pool is needed.
    NSRunLoop* myRunLoop = [NSRunLoop currentRunLoop];
    // Create a run loop observer and attach it to the run loop.
    CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,kCFRunLoopAllActivities, YES, 0,nil, &context);
    if (observer)
    {
        CFRunLoopRef cfLoop = [myRunLoop getCFRunLoop];
        CFRunLoopAddObserver(cfLoop, observer, kCFRunLoopDefaultMode);
    }
    // Create and schedule the timer.
    [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                   selector:@selector(doFireTimer) userInfo:nil repeats:YES];
    NSInteger loopCount = 10; do
    {
        // Run the run loop 10 times to let the timer fire.
        [myRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:10]];
        loopCount--;
    }
    while (loopCount > 0);
}

- (void)doFireTimer {

}

- (void)myThreadMainMethod {

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
