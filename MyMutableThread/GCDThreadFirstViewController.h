//
//  GCDThreadFirstViewController.h
//  MyMutableThread
//
//  Created by jianzhongliu on 4/21/14.
//  Copyright (c) 2014 anjuke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCDThreadFirstViewController : UIViewController

@end

/**
 GCD线程总结
 GCD的核心是dispatch_queue队列，也就是dispatch任务，dispatch任务概念上和operaion相同，但是功能比operation强大的多的多。让任务在block中执行，而block在多核下有先天优势，所多线程使用GCD是对线程的极度利用。
 dispatch_async并非是创建了一个GCD线程，当dispatch_async的queue是mainqueue，那么就是在主线程中执行这个block块，相当于是主线程的一个任务，当dispatch_async的queue时globalqueue或自定义的queue时就会创建一个线程去执行block块。
 dispatch_async(dispatch_queue_t queue, dispatch_block_t block);
 参数queue：dispatch_get_main_queue(),dispatch_get_global_queue()
 参数block:线程执行的主block ^(){}
 
 //dispatch_get_main_queue()
 // 用来得到主队列。主队列又系统自动创建并且与应用程序主线程相关联。
 // 也就是我们常说的能调用主线程修改UI的队列，即：主线程队列。
 
 //dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
 //获得全局队列，根据优先级。
 //第一个参数线程优先级，第二个参数设0（？）
 
 GCD同步异步调用实例
 dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
 dispatch_async(concurrentQueue, ^{//整个流程是异步线程执行
        dispatch_sync(concurrentQueue, ^{
            // 同步下载图片
        });
 
        dispatch_sync(dispatch_get_main_queue(), ^{
        // 直到下载图片完成，再调用主线程，更新UI
        });
 });
 
 GCD延迟执行
 dispatch_after(dispatch_time_t when, dispatch_queue_t queue, dispatch_block_t block);
 参数when：延迟时间 dispatch_time_t delayInNanoSeconds =dispatch_time(0\*表示当前时间*\, delayInSeconds * 1000000000);
 参数queue：线程所在队列，dispatch_get_main_queue和dispatch_get_global_queue都可以的
 参数block：^(){}
 
 多任务归一的方式
 用下面两个方法，多个dispatch_group_async全部执行结束后才会调用dispatch_group_notify，前提是group何queue要相同
    dispatch_group_async(dispatch_group_t group, dispatch_queue_t queue, dispatch_block_t block);
    dispatch_group_notify(dispatch_group_t group, dispatch_queue_t queue, dispatch_block_t block);
    参数group：dispatch_group_create
    参数queue：dispatch_get_main_queue
    参数block：^(void){}
 
 queue的创建：
 自定义queue：   dispatch_queue_create("jianzhongliu--swweaper5", NULL)//非主线程执行,但是同一个queue的任务在一个线程里面
 mainQueue:     dispatch_get_main_queue();//在主线程中执行
 globalQueue:   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)//独立线程执行，每个任务都在独立的线程执行
 
 GCD线程信号量
 dispatch_semaphore_t
 在OC中，如要实现线程任务的并发，一般会使用operation，dispatch_semaphore_t是GCD中通过线程信号量来实现类似并发operaion的功能，一个线程允许多个任务并发执行，如何控制并发数就是通过信号量来控制，当我们创建信号量时设置当前队列只有一个信号量，那么只有当之前占用信号的任务发出信号量，其他任务接受到信号量，其他任务才能执行。
 信号量有三个方法：
 这三个方法的使用规则是：首先创建一个信号量，那么后面发送，等待的信号都是他了，等待信号量的方法只有在当前队列中有空余信号量时才会执行，发送信号量的方法是当前任务结束时要把执行任务前接受的信号重新发送出去，让队列继续执行其他任务，或者让其他任务接受信号来启动任务。
 1，dispatch_semaphore_create(long value);//创建信号量
 value是信号量的数目，允许有多少任务同时执行。
 
 2，dispatch_semaphore_wait(dispatch_semaphore_t dsema, dispatch_time_t timeout);//等待信号量,当一个线程在一个信号量上等待时，线程会被阻塞
 参数dsema：信号量对象
 参数timeout：等待信号量的结束时间
 
 3，dispatch_semaphore_signal(dispatch_semaphore_t dsema);//发送信号量
 参数dsema:要发送的信号量
 
 等待group任务结束
 group的多个对象可能是多个线程（globalqueue）也可能是多个任务在一个线程（queue_create），当他们没有结束时，可以用dispatch_group_wait阻塞住当前线程，直到所有任务结束。
 dispatch_group_wait(dispatch_group_t group, dispatch_time_t timeout);
 参数group:要等待的group，
 参数timeout：等待的最终时间
 
 
 
 */