//
//  GCDThreadFirstViewController.m
//  MyMutableThread
//
//  Created by jianzhongliu on 4/21/14.
//  Copyright (c) 2014 anjuke. All rights reserved.
//

#import "GCDThreadFirstViewController.h"
#import "LockObj.h"

@interface GCDThreadFirstViewController ()

@end

@implementation GCDThreadFirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self firstGCDThreadRunINMainThread];//主线程队列中得线程
//    [self secondGCDThreadForLoadIMG];//同步线程和异步线程
//    [self thirdGCDThreadForDelayPerform];//延迟执行的线程
//    [self forthGCDThreadForGroupThread];//分组的队列,我们可以创建很多组，每个组是一个队列，队列中得任务是串行得，
//    [self fifthGCDThreadForMyNameQueue];//创建指定的自定义的串行队列
    [self sixthGCDThreadForSignal];
}


- (void)firstGCDThreadRunINMainThread  {
    // 主线程队列，由系统自动创建并且与应用撑血的主线程相关联。
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    // 要在主线程队列中，执行的Block
    //mainQueue是下面线程所在的队列
    dispatch_async(mainQueue, ^(void) {
        [[[UIAlertView alloc] initWithTitle:@"GCD"
                                    message:@"GCD is amazing!"
                                   delegate:nil cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
    });
//dispatch_get_main_queue()
// 用来得到主队列。主队列又系统自动创建并且与应用程序主线程相关联。
// 也就是我们常说的能调用主线程修改UI的队列，即：主线程队列。
    
//dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
//获得全局队列，根据优先级。
//第一个参数线程优先级，第二个参数设0（？）
    
}

- (void)secondGCDThreadForLoadIMG {
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{//整个流程是异步线程执行
        __block UIImage *image = nil;
        dispatch_sync(concurrentQueue, ^{// 同步下载图片
            NSString *urlAsString = @"http://img0.bdstatic.com/img/image/shouye/dengni14.jpg";
            NSURL *url = [NSURL URLWithString:urlAsString];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
            NSError *downloadError = nil;
            NSData *imageData = [NSURLConnection sendSynchronousRequest:urlRequest
                                                      returningResponse:nil
                                                                  error:&downloadError];
            if (downloadError == nil && imageData != nil){
                image = [UIImage imageWithData:imageData];
            }else if (downloadError != nil){
                NSLog(@"Error happened = %@", downloadError);
            } else {
                NSLog(@"No data could get downloaded from the URL."); }
        });
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            // 直到下载图片完成，再调用主线程，更新UI
            if (image != nil){
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
                [imageView setImage:image];
                [imageView setContentMode:UIViewContentModeScaleAspectFit];
                [self.view addSubview:imageView];
            } else {
                NSLog(@"Image isn't downloaded. Nothing to display.");
            }
        });
    });
}

- (void)thirdGCDThreadForDelayPerform {
    double delayInSeconds = 2.0;
    
    // 创建延期的时间 2S，因为dispatch_time使用的时间是纳秒，尼玛，比毫秒还小，太夸张了！！！
    //dispatch_time第一个参数指定的开始点，可以用 DISPATCH_TIME_NOW 来指定一个当前的时间点,第二个参数是纳秒数
    dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    // 得到全局队列
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 延期执行
    dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
        NSLog(@"Output GCD !");
        
    });
}

- (void)forthGCDThreadForGroupThread {
    dispatch_group_t taskGroup = dispatch_group_create();// 创建一个调度组
    dispatch_queue_t mainQueue = dispatch_get_main_queue();// 创建队列
    
    // 任务1
    // 将Block添加到指定的调度组(taskGroup)中，并且该Block用指定的队列(mainQueue)执行。
    dispatch_group_async(taskGroup, mainQueue, ^{
        NSLog(@"===========第一个任务1");
        sleep(2);
        NSLog(@"===========第一个任务2");
        
//        [self reloadTableView];
    });
    
    // 任务2
    // 将Block添加到指定的调度组(taskGroup)中，并且该Block用指定的队列(mainQueue)执行。
    dispatch_group_async(taskGroup, mainQueue, ^{
        NSLog(@"===========第二个任务1");
        sleep(2);
        NSLog(@"===========第二个任务2");
//        [self reloadScrollView];
    });
    
    // 任务3
    // 将Block添加到指定的调度组(taskGroup)中，并且该Block用指定的队列(mainQueue)执行。
    dispatch_group_async(taskGroup, mainQueue, ^{
        NSLog(@"===========第三个任务1");
        sleep(2);
        NSLog(@"===========第三个任务2");
//        [self reloadImageView];
    });
    
    // 当指定调度组（taskGroup）中的所有Block都执行完成后，将执行给定的Block，用指定的队列（mainQueue）。
    dispatch_group_notify(taskGroup, mainQueue, ^{
        // 指定的Block
        [[[UIAlertView alloc] initWithTitle:@"Finished"
                                    message:@"All tasks are finished" delegate:nil
                          cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        
    });
    
    // 最后，必须release 掉调度组（taskGroup）
    dispatch_release(taskGroup);

}

- (void)fifthGCDThreadForMyNameQueue {
    // 创建指定的自定义的串行队列
    dispatch_queue_t firstSerialQueue = dispatch_queue_create("jianzhongliu--swweaper5", NULL);
    
    // 让队列异步执行Block
    dispatch_async(firstSerialQueue, ^{
        NSUInteger counter = 0;
        for (counter = 0; counter < 5; counter++){
            NSLog(@"First iteration, counter = %lu", (unsigned long)counter); }
        NSLog(@"Current thread = %@", [NSThread currentThread]);
    });
    
    dispatch_async(firstSerialQueue, ^{
        NSUInteger counter = 0; for (counter = 0;counter < 5;counter++){
            NSLog(@"Second iteration, counter = %lu", (unsigned long)counter);
            NSLog(@"Current thread = %@", [NSThread currentThread]);
        }
    });
    
    dispatch_async(firstSerialQueue, ^{ NSUInteger counter = 0;
        for (counter = 0;counter < 5;counter++){
            NSLog(@"Third iteration, counter = %lu", (unsigned long)counter);
            NSLog(@"Current thread = %@", [NSThread currentThread]);
        }
    });
    
    // 销毁队列
    dispatch_release(firstSerialQueue);
    
    // 输出主队列，比较会发现，我们自定义的队列，并不在主线程上，效率还是蛮高的。
    dispatch_queue_t mainQueue1 = dispatch_get_main_queue();
    dispatch_async(mainQueue1, ^(void) {
        NSLog(@"Main thread = %@", [NSThread mainThread]);
    });
}

- (void)sixthGCDThreadForSignal {
    //主线程中
    LockObj *obj = [LockObj shareInstance];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    for (int i = 0; i<10; i++) {
    
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        long thecount= dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"--1--%ld",thecount);
        [obj GCDfirstMethodforPrintSomeThing];
        dispatch_semaphore_signal(semaphore);
    });

    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        long thecount= dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"--2--%ld",thecount);
        
        [obj GCDsecondMethodforPrintSomeWordsElse];
        dispatch_semaphore_signal(semaphore);
    });
    }
}
@end
