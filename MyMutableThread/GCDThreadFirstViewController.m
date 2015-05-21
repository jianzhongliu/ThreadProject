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
@property (readwrite, strong, nonatomic)  dispatch_queue_t myqueue;
@property BOOL isCancel;
@end

@implementation GCDThreadFirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _myqueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        // Custom initialization
        _isCancel = NO;
    }
    return self;
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *but1 = [UIButton buttonWithType:UIButtonTypeCustom];
    but1.frame = CGRectMake(10, 200, 40, 40);
    [but1 setTitle:@"start" forState:UIControlStateNormal];
    [but1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [but1 addTarget:self action:@selector(startThread) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:but1];
    
    UIButton *but2 = [UIButton buttonWithType:UIButtonTypeCustom];
    but2.frame = CGRectMake(10, 300, 40, 40);
    [but2 setTitle:@"back" forState:UIControlStateNormal];
    [but2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [but2 addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:but2];
    
    UIButton *but3 = [UIButton buttonWithType:UIButtonTypeCustom];
    but3.frame = CGRectMake(10, 400, 130, 40);
    [but3 setTitle:@"cancelThread" forState:UIControlStateNormal];
    [but3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [but3 addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:but3];
    

}

- (void)startThread {
//        [self firstGCDThreadRunINMainThread];//主线程队列中得线程
//        [self secondGCDThreadForLoadIMG];//同步线程和异步线程
//        [self thirdGCDThreadForDelayPerform];//延迟执行的线程
//        [self forthGCDThreadForGroupThread];//分组的队列,我们可以创建很多组，每个组是一个队列，队列中得任务是串行得，
//        [self fifthGCDThreadForMyNameQueue];//创建指定的自定义的串行队列
//        [self sixthGCDThreadForSignal];
//        [self seventhGCDThreadForCancelBlock];//通过bool值取消gcd线程，需要点击cancelThread按钮中断线程的继续。
        [self eighthGCDThreadForSemaphore];
}

- (void)dealloc {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
//    dispatch_release(_myqueue);
    _myqueue = nil;
}


- (void)cancel {
    self.isCancel = YES;
}
/**
 
 
 */
- (void)firstGCDThreadRunINMainThread  {
    
    // 主线程队列，由系统自动创建并且与应用撑血的主线程相关联。
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    LockObj *obj = [LockObj shareInstance];
    // 要在主线程队列中，执行的Block
    //mainQueue是下面线程所在的队列
    for (int i = 0; i < 10; i++) {
        dispatch_async(mainQueue, ^(void) {
            NSLog(@"===%d",i);
            [obj secondMethodforPrintSomeWordsElse];
            
        });
    }

//dispatch_get_main_queue()
// 用来得到主队列。主队列又系统自动创建并且与应用程序主线程相关联。
// 也就是我们常说的能调用主线程修改UI的队列，即：主线程队列。
    
//dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
//获得全局队列，根据优先级。
//第一个参数线程优先级，第二个参数设0（？）
    
}
/**
 
 
 */
- (void)secondGCDThreadForLoadIMG {
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{//整个流程是异步线程执行
        __block UIImage *image = nil;
        dispatch_sync(concurrentQueue, ^{// 同步下载图片
            NSLog(@"Image is downloading.");
            sleep(2);
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
                NSLog(@"Image is downloaded.");
                sleep(2);
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
/**
 
 // 创建延期的时间 2S，因为dispatch_time使用的时间是纳秒，尼玛，比毫秒还小，太夸张了！！！
 //dispatch_time第一个参数指定的开始点，可以用 DISPATCH_TIME_NOW 来指定一个当前的时间点,第二个参数是纳秒数
 
 */
- (void)thirdGCDThreadForDelayPerform {
    double delayInSeconds = 5.0;

    dispatch_time_t delayInNanoSeconds =dispatch_time(0, delayInSeconds * 1000000000);
    // 得到全局队列
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 延期执行
    dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
        NSLog(@"Output GCD !");
        
    });
    NSLog(@"---");
}
/**
 注意：当所有线程在同一个queue中执行，并且在同一个group中执行，才会得到理想的结果，当改变其中一个任务的queue就会分成多条线去执行了，不会是原来的在一个group中逐一执行
 
 group的好处，当很多的任务执行完，会有Dispatch_group_notify执行，而queue不会知道到底走完没有。
 
 */
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
//    dispatch_group_wait(taskGroup,dispatch_time(DISPATCH_TIME_NOW,
//));
    // 当指定调度组（taskGroup）中的所有Block都执行完成后，将执行给定的Block，用指定的队列（mainQueue）。
    dispatch_group_notify(taskGroup, mainQueue, ^{
        // 指定的Block
        [[[UIAlertView alloc] initWithTitle:@"Finished"
                                    message:@"All tasks are finished" delegate:nil
                          cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        
    });
    
    // 最后，必须release 掉调度组（taskGroup）
//    dispatch_release(taskGroup);

}
/**
 
 
 */
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
        NSUInteger counter = 0;
        for (counter = 0;counter < 5;counter++){
            NSLog(@"Second iteration, counter = %lu", (unsigned long)counter);
            NSLog(@"Current thread = %@", [NSThread currentThread]);
        }
    });
    dispatch_async(firstSerialQueue, ^{
        NSUInteger counter = 0;
        for (counter = 0;counter < 5;counter++){
            NSLog(@"Second iteration, counter = %lu", (unsigned long)counter);
            NSLog(@"Current thread = %@", [NSThread currentThread]);
        }
    });
    dispatch_async(firstSerialQueue, ^{
        NSUInteger counter = 0;
        for (counter = 0;counter < 5;counter++){
            NSLog(@"Third iteration, counter = %lu", (unsigned long)counter);
            NSLog(@"Current thread = %@", [NSThread currentThread]);
        }
    });
    
    // 销毁队列
//    dispatch_release(firstSerialQueue);
    
    // 输出主队列，比较会发现，我们自定义的队列，并不在主线程上，效率还是蛮高的。
    
    dispatch_queue_t mainQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(mainQueue, ^(void) {
        NSLog(@"DISPATCH_QUEUE_PRIORITY_DEFAULT Main thread = %@", [NSThread currentThread]);
    });
    
    dispatch_queue_t mainQueue1 = dispatch_get_main_queue();
    dispatch_async(mainQueue1, ^(void) {
        NSLog(@"Main thread = %@", [NSThread currentThread]);
        NSLog(@"Main thread = %@", [NSThread mainThread]);
    });
}
/**
 
 
 */
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

- (void)seventhGCDThreadForCancelBlock {
    __weak GCDThreadFirstViewController *obj = self;
    
    dispatch_queue_t myqueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(myqueue, ^{
        sleep(2);
        NSLog(@"---两秒后继续---");
        if (obj.isCancel) {
            return ;
        }
        sleep(2);
        NSLog(@"---两秒后继续---");
        if (obj.isCancel) {
            return ;
        }
        sleep(2);
        NSLog(@"---两秒后继续---");
        if (obj.isCancel) {
            return ;
        }
        
    });
}

/**
 当我们在处理一系列线程的时候，当数量达到一定量，在以前我们可能会选择使用NSOperationQueue来处理并发控制，但如何在GCD中快速的控制并发呢？答案就是dispatch_semaphore，对经常做unix开发的人来讲，我所介绍的内容可能就显得非常入门级了，信号量在他们的多线程开发中再平常不过了。
 　　信号量是一个整形值并且具有一个初始计数值，并且支持两个操作：信号通知和等待。当一个信号量被信号通知，其计数会被增加。当一个线程在一个信号量上等待时，线程会被阻塞（如果有必要的话），直至计数器大于零，然后线程会减少这个计数。
 　　在GCD中有三个函数是semaphore的操作，分别是：
 　　dispatch_semaphore_create　　　创建一个semaphore
 　　dispatch_semaphore_signal　　　发送一个信号
 　　dispatch_semaphore_wait　　　　等待信号/会阻塞当前线程
 　　简单的介绍一下这三个函数，第一个函数有一个整形的参数，我们可以理解为信号的总量，dispatch_semaphore_signal是发送一个信号，自然会让信号总量加1，dispatch_semaphore_wait等待信号，当信号总量少于0的时候就会一直等待，否则就可以正常的执行，并让信号总量-1，根据这样的原理，我们便可以快速的创建一个并发控制来同步任务和有限资源访问控制。
*/

- (void)eighthGCDThreadForSemaphore {
    dispatch_group_t group = dispatch_group_create();
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_queue_t queue = dispatch_queue_create("gange", NULL);
    for (int i = 0; i < 3; i++)
    {
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_group_async(group, queue, ^{
            NSLog(@"%i",i);
            NSLog(@"current thread%@", [NSThread currentThread]);
            sleep(2);
//            dispatch_semaphore_signal(semaphore);
        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"dispatch_group_wait");
}

@end
