//
//  MyClass.m
//  MyMutableThread
//
//  Created by jianzhongliu on 5/12/14.
//  Copyright (c) 2014 anjuke. All rights reserved.
//

#import "MyClass.h"

@implementation MyClass
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSString *)appendMyString:(NSString *)string
{
    NSString *mString = [NSString stringWithFormat:@"%@ after append method", string];
    return mString;
}

@end
