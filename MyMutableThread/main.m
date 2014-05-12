//
//  main.m
//  MyMutableThread
//
//  Created by jianzhongliu on 4/17/14.
//  Copyright (c) 2014 anjuke. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "MyClass.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
/**
 在 iOS中可以直接调用某个对象的消息方式有两种：
 
 一种是performSelector:withObject；
 
 再一种就是NSInvocation。
 
 第一种方式比较简单，能完成简单的调用。但是对于>2个的参数或者有返回值的处理，那就需要做些额外工作才能搞定。那么在这种情况下，我们就可以使用NSInvocation来进行这些相对复杂的操作。
 */
//int main (int argc, const char * argv[])
//{
//
//    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
//    
//    MyClass *myClass = [[MyClass alloc] init];
//    NSString *myString = @"My string";
//    
//    //普通调用
//    NSString *normalInvokeString = [myClass appendMyString:myString];
//    NSLog(@"The normal invoke string is: %@", normalInvokeString);
//    
//    //NSInvocation调用
//    SEL mySelector = @selector(appendMyString:);
//    NSMethodSignature * sig = [[myClass class]
//                               instanceMethodSignatureForSelector: mySelector];
//    
//    NSInvocation * myInvocation = [NSInvocation invocationWithMethodSignature: sig];
//    [myInvocation setTarget: myClass];
//    [myInvocation setSelector: mySelector];
//    
//    [myInvocation setArgument: &myString atIndex: 2];
//    NSString * result = nil;
//    [myInvocation retainArguments];
//    [myInvocation invoke];
//    [myInvocation getReturnValue: &result];
//    NSLog(@"The NSInvocation invoke string is: %@", result);
//    
//    [myClass release];
//    
//    [pool drain];
//    return 0;
//}

