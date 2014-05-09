//
//  OperationObjectManager.h
//  MyMutableThread
//
//  Created by jianzhongliu on 4/24/14.
//  Copyright (c) 2014 anjuke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OperationObjectManager : NSObject
+ (instancetype)shareInstance;

- (void)secondOperationForBlockOperation;


@end
