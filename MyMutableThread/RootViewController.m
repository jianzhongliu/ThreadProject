//
//  RootViewController.m
//  MyMutableThread
//
//  Created by jianzhongliu on 4/17/14.
//  Copyright (c) 2014 anjuke. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //下面两种方式创建开销一样的
    //NSThread第一种方式
    [NSThread detachNewThreadSelector:@selector(myThreadMainMethod) toTarget:self withObject:nil];
    //NSThread第二种方式
    NSThread* myThread = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(myThreadMainMethod)
                                                   object:nil];
    [myThread start]; // Actually create the thread
    // Do any additional setup after loading the view.
}

- (void)myThreadMainMethod {

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
