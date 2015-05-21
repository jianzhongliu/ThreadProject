//
//  OperationObjectManager.m
//  MyMutableThread
//
//  Created by jianzhongliu on 4/24/14.
//  Copyright (c) 2014 anjuke. All rights reserved.
//

#import "OperationObjectManager.h"

@implementation OperationObjectManager
+ (instancetype)shareInstance {
    static OperationObjectManager *operation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (operation == nil) {
            operation = [[OperationObjectManager alloc] init];
        }
    });
    return operation;
}
//reference
//https://developer.apple.com/library/ios/documentation/Cocoa/Reference/NSOperation_class/Reference/Reference.html
/**
 https://developer.apple.com/library/ios/documentation/Cocoa/Reference/NSOperation_class/Reference/Reference.html
NSOperation是个抽象的类，一般情况下不建议直接使用，而是使用 (NSInvocationOperation or NSBlockOperation),nsoperation的对象只会执行一次
一般情况下通过 NSOperationQueue来使用NSOperation，
自己操作NSOperation时可以使用start方法（在当前线程中执行的），执行operation通常是在代码里面添加一个负荷，start一个operaion并非把她置为ready状态，isReady方法可以查看operation是否在执行的队列里面
NSOperation本身有多核特性，在多线程下操作无需上锁。NSOperation在一个线程里面执行是并发的，当执行NSOperation的start时，会在它执行完之前返回，是因为调用start后NSOperation会找到一个线程去执行这个任务，此时无法确认该任务此时有没有执行，但是可以确认的是可以执行。
 */

- (void)firstOperationOfBlockOperation {
    __block dispatch_group_t dispatchGroup = dispatch_group_create();
    NSBlockOperation *batchedOperation = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{

            
        });
#if !OS_OBJECT_USE_OBJC
        dispatch_release(dispatchGroup);
#endif
    }];
    
    
}
- (NSOperation *)executeBlock:(void (^)(void))block completion:(void (^)(BOOL finished))completion {
    
    NSOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:block];
    
    NSOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:^{
        sleep(2);
        completion(blockOperation.isFinished);
    }];
    
    [completionOperation addDependency:blockOperation];
    [[NSOperationQueue mainQueue] addOperation:completionOperation];
    
    NSOperationQueue *backgroundOperationQueue = [[NSOperationQueue alloc] init];
    [backgroundOperationQueue addOperation:blockOperation];
    
    return blockOperation;
}

- (void)secondOperationForBlockOperation {
    
    NSMutableString *string = [NSMutableString stringWithString:@"tea"];
    NSString *otherString = @"for";
    
    NSOperation *operation = [self executeBlock:^{
        NSString *yetAnother = @"two";
        [string appendFormat:@" %@ %@", otherString, yetAnother];
    } completion:^(BOOL finished) {
        // this logs "tea for two"
        NSLog(@"===%@", string);
    }];
    
    NSLog(@"keep this operation so we can cancel it: %@", operation);
}
@end
