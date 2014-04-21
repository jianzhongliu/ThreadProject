//
//  ThreadLockViewController.m
//  MyMutableThread
//
//  Created by yons on 14-4-20.
//  Copyright (c) 2014年 anjuke. All rights reserved.
//

#import "ThreadLockViewController.h"
#import "GCDThreadFirstViewController.h"
#import "LockObj.h"
#import "NSGlobalLock.h"

@interface ThreadLockViewController ()

@end

@implementation ThreadLockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"锁";
        // Custom initialization
    }
    return self;
}
- (void)background {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performSelector:@selector(background) withObject:nil afterDelay:1];
//    [self synchronizedLockMethod];//@synchronized创建互斥锁
//    [self lockForLockAndUnlockMethod];//用lock对象管理锁
//    [self GCDThreadMethodForSemaphoreLock];
    [self forthRecursiveLock];
    // 待续。。。。。。
    
    
    //http://blog.sina.com.cn/s/blog_7b9d64af0101c75e.html    GCD和block 线程文档没有
    //另外还有文档中得NSRecursiveLock对象    74页
    
}

- (void)synchronizedLockMethod{
    //@synchronized 指令是在 Objective-C 代码中创建一个互斥锁非常方便的方法,它防止不同的线程在同一时间获取 同一个锁,然而在这种情况下,你不需要直接创建一个互斥锁或锁对象。相反,你 只需要简单的使用 Objective-C 对象作为锁的令牌如下，如果你在多个不同的线程里面执行上述方法,每次在一个线程传递一个不同的对象给 obj1 参数,那么每次都将会拥有它的锁,并持续处理,中间不被其他线程阻塞；然而,如果你传递的是同一个对象,那么多个线程中的一个线程会首先获得该锁,而其￼他线程将会被阻塞直到第一个线程完成它的临界区。
    
    LockObj *obj1 = [[LockObj alloc] init];
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized(obj1){
            [[NSThread currentThread] setName:[NSString stringWithFormat:@"第一个线程"]];
            [obj1 firstMethodforPrintSomeThing];
            sleep(10);
        }
    });
    
    for (int i = 0; i<3; i++) {
        //线程2
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(1);
            @synchronized(obj1){
                [[NSThread currentThread] setName:[NSString stringWithFormat:@"%d",i]];
                [obj1 secondMethodforPrintSomeWordsElse];
            }
        });
    }
//作为一种预防措施,@synchronized 块隐式的添加一个异常处理例程来保护代码。该处理例程会在异常抛出的时候自动的释放互斥锁。这意味着为了使用 @synchronized 指令,你必须在你的代码中启用异常处理。如果你不想让隐式的异 常处理例程带来额外的开销,你应该考虑使用锁的类
}

- (void)lockForLockAndUnlockMethod {
//lock和unlock配套使用
//某个线程A调用lock方法。这样，NSLock将被上锁。可以执行“关键部分”，完成后，调用unlock方法。如果，在线程A 调用unlock方法之前，另一个线程B调用了同一锁对象的lock方法。那么，线程B只有等待。直到线程A调用了unlock----------其实在按照下面的方法来走，并且多次切换controller页面就会出问题，（答案看下面对锁的单例处理）
    LockObj *obj1 = [LockObj shareInstance];
    NSGlobalLock *lock = [NSGlobalLock shareInstance];//注意，多线程的时候一定要用同一个锁，才能保证method执行完再执行其他method，不然就会出现method1执行了一半就执行method2了。
    for (int i = 0; i < 3; i++) {
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSThread currentThread] setName:[NSString stringWithFormat:@"第一个线程%d", i]];
        [lock lock];
        [obj1 firstMethodforPrintSomeThing];
//        sleep(10);
        [lock unlock];
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSThread currentThread] setName:[NSString stringWithFormat:@"第er个线程%d", i]];
//        sleep(5);//以保证让线程2的代码后执行
        [lock lock];
        [obj1 secondMethodforPrintSomeWordsElse];
        [lock unlock];
    });
    }
}
- (void)GCDThreadMethodForSemaphoreLock {

    LockObj *obj1 = [LockObj shareInstance];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    for (int i = 0; i < 10; i++) {
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSThread currentThread] setName:[NSString stringWithFormat:@"第一个线程%d", i]];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [obj1 GCDfirstMethodforPrintSomeThing];
        sleep(5);
        dispatch_semaphore_signal(semaphore);
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSThread currentThread] setName:[NSString stringWithFormat:@"第er个线程%d", i]];
        sleep(1);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        [obj1 GCDsecondMethodforPrintSomeWordsElse];
        dispatch_semaphore_signal(semaphore);
    });
    }
}
- (void)forthRecursiveLock{//递归锁 可以被同一线程多次锁住的锁。
//NSRecursiveLock 类定义的锁可以在同一线程多次获得,而不会造成死锁。一个递归锁会跟踪它被多少次成功获得了。每次成功的获得该锁都必须平衡调用锁住和解 锁的操作。只有所有的锁住和解锁操作都平衡的时候,锁才真正被释放给其他线程获 得。
    NSRecursiveLock *theLock = [[NSRecursiveLock alloc] init];
    LockObj *obj1 = [LockObj shareInstance];
    for (int i = 0; i < 3; i++) {
        //线程1
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[NSThread currentThread] setName:[NSString stringWithFormat:@"第一个线程%d", i]];
            [theLock lock];
            [obj1 GCDfirstMethodforPrintSomeThing];
            [theLock unlock];
        });
        
        //线程2
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[NSThread currentThread] setName:[NSString stringWithFormat:@"第er个线程%d", i]];
            [theLock lock];
            [obj1 GCDsecondMethodforPrintSomeWordsElse];
            [theLock unlock];
        });
    }
}
@end
