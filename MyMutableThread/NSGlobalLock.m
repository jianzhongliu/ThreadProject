//
//  NSGlobalLock.m
//  MyMutableThread
//
//  Created by jianzhongliu on 4/21/14.
//  Copyright (c) 2014 anjuke. All rights reserved.
//

#import "NSGlobalLock.h"

@implementation NSGlobalLock
+ (instancetype)shareInstance {
    static NSGlobalLock *global = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (global == nil) {
            global = [[NSGlobalLock alloc] init];
        }
    });
    return global;
}
@end
