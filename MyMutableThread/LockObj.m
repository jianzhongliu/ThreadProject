//
//  LockObj.m
//  MyMutableThread
//
//  Created by yons on 14-4-20.
//  Copyright (c) 2014年 anjuke. All rights reserved.
//

#import "LockObj.h"

@implementation LockObj
+ (instancetype)shareInstance {
    static LockObj *lockobj = nil;
    static dispatch_once_t onceToken;//dispatch_once_t是long型数据类型，默认为0
    dispatch_once(&onceToken, ^{
        if (lockobj == nil) {
            NSLog(@"========%@", [[NSThread currentThread] name]);
            lockobj = [[LockObj alloc] init];
        }
    });
    return lockobj;
}
/**
 互斥锁：
 @synchronized可以保证下面的代码块不被打断，当不要这个互斥锁，很多线程跑到这里就会乱掉（有时先打印前两句再打印2里面的前两句）--这只是现象，什么是互斥锁？
 
 */
- (void)firstMethodforPrintSomeThing{
    @synchronized(self){
    NSLog(@"------firstMethodforPrintSomeThing=====%@",[[NSThread currentThread] name]);
    NSLog(@"------firstMethodforPrintSomeThing--Selector%@",NSStringFromSelector(_cmd));
    sleep(1);
    NSLog(@"------firstMethodforPrintSomeThing----Current thread = %@", [NSThread currentThread]);
    NSLog(@"------firstMethodforPrintSomeThing-----Main thread = %@", [NSThread mainThread]);
    }
}

- (void)secondMethodforPrintSomeWordsElse{
    @synchronized(self){
    NSLog(@"--------secondMethodforPrintSomeWordsElse-----%@",[[NSThread currentThread] name]);
    NSLog(@"--------secondMethodforPrintSomeWordsElse-Selector----%@",NSStringFromSelector(_cmd));
    sleep(1);
    NSLog(@"--------secondMethodforPrintSomeWordsElse---Current thread = %@", [NSThread currentThread]);
    NSLog(@"--------secondMethodforPrintSomeWordsElse----Main thread = %@", [NSThread mainThread]);
    }
}

- (void)GCDfirstMethodforPrintSomeThing{
        NSLog(@"------firstMethodforPrintSomeThing=====%@",[[NSThread currentThread] name]);
        NSLog(@"------firstMethodforPrintSomeThing--Selector%@",NSStringFromSelector(_cmd));
        sleep(1);
        NSLog(@"------firstMethodforPrintSomeThing----Current thread = %@", [NSThread currentThread]);
        NSLog(@"------firstMethodforPrintSomeThing-----Main thread = %@", [NSThread mainThread]);
}

- (void)GCDsecondMethodforPrintSomeWordsElse{
        NSLog(@"--------secondMethodforPrintSomeWordsElse-----%@",[[NSThread currentThread] name]);
        NSLog(@"--------secondMethodforPrintSomeWordsElse-Selector----%@",NSStringFromSelector(_cmd));
        sleep(2);
        NSLog(@"--------secondMethodforPrintSomeWordsElse---Current thread = %@", [NSThread currentThread]);
        NSLog(@"--------secondMethodforPrintSomeWordsElse----Main thread = %@", [NSThread mainThread]);
}
@end
