//
//  ThreadLockViewController.h
//  MyMutableThread
//
//  Created by yons on 14-4-20.
//  Copyright (c) 2014年 anjuke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreadLockViewController : UIViewController

@end
/**
 一，互斥锁
 OC下互斥锁的实现是通过@synchronized实现的，代码中创建一个互斥锁非常方便的方法,它防止不同的线程在同一时间获取同一个锁，然而,如果你传递的是同一个对象,那么多个线程中的一个线程会首先获得该锁,而其￼他线程将会被阻塞直到第一个线程完成它的临界区（多个线程都会访问的公用的区域，比如多个线程都要访问磁盘，这个磁盘就是临界区）
 
 二，NSLock
 使用方法，当多个线程使用同一个锁，那么第一个锁住的对象有权访问资源，其他线程就会被阻塞成一个请求队列，直到第一个lock住资源的线程unlock资源，第二个线程去请求资源，同样会上锁，防止其他线程访问资源。
 NSLock的创建，自定义一个继承自NSLock的锁，
 [lock lock];
//do some thing complete your task.
 [lock unlock];
 
 三，信号量锁，见GCD部分
 
 四，递归锁
 类定义的锁可以在同一线程多次获得,而不会造成死锁。一个递归锁会跟踪它被多少次成功获得了。每次成功的获得该锁都必须平衡调用锁住和解 锁的操作。只有所有的锁住和解锁操作都平衡的时候,锁才真正被释放给其他线程获 得
 NSRecursiveLock *theLock = [[NSRecursiveLock alloc] init];
 [theLock lock];
// do some thing .
 [theLock unlock];
 
 
 
 
 */