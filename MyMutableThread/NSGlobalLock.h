//
//  NSGlobalLock.h
//  MyMutableThread
//
//  Created by jianzhongliu on 4/21/14.
//  Copyright (c) 2014 anjuke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSGlobalLock : NSLock
+ (instancetype)shareInstance;
@end
