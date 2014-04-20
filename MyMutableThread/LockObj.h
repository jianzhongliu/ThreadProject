//
//  LockObj.h
//  MyMutableThread
//
//  Created by yons on 14-4-20.
//  Copyright (c) 2014年 anjuke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LockObj : NSObject
+ (instancetype)shareInstance;
- (void)firstMethodforPrintSomeThing;
- (void)secondMethodforPrintSomeWordsElse;
- (void)GCDfirstMethodforPrintSomeThing;
- (void)GCDsecondMethodforPrintSomeWordsElse;
@end
