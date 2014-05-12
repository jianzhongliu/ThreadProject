class Refrence
RootViewController---------------------a importor of even kind of thread

AddObserverToCurrentRunloopViewController----runloop & observer
ThreadLockViewController---------------lock used in thread
GCDThreadFirstViewController-----------GCD Thread methods


OperationObjectManager ----------------some kind of operation
LockObj--------------------------------a obj for test lock

MyClass--------------------------------NSInvocation


ThreadProject
=============
启动 run loop 只对程序的辅助线程有意义。一个 run loop 通常必须包含一个输 入源或定时器来监听事件。如果一个都没有,run loop 启动后立即退出。每个线程都有一个或多个 run loop
ThreadProject
====================下面方法定义在nsobject中，是可以在其他线程中执行的seelctor，并非是创建新线程=================================
￼performSelectorOnMainThread:withObject:waitUntilDone:
￼￼performSelectorOnMainThread:withObject:waitUntilDone:mod￼￼es:          //modes是指runloop的模型

￼performSelector:onThread:withObject:waitUntilDone:
￼￼performSelector:onThread:withObject:waitUntilDone:modes:

￼performSelector:withObject:afterDelay:
￼￼performSelector:withObject:afterDelay:inModes:

￼cancelPreviousPerformRequestsWithTarget://取消掉《performSelector:withObject:afterDelay:》
￼￼cancelPreviousPerformRequestsWithTarget:selector:object:
======================runloop的生命周期==================================
 Run loop 入口
 Run loop 何时处理一个定时器
 Run loop 何时处理一个输入源
 Run loop 何时进入睡眠状态
 Run loop 何时被唤醒,但在唤醒之前要处理的事件
￼ Run loop 终止
==========================================================
为了创建一 个 run loop 观察者,你可以创建一个 CFRunLoopObserverRef 类型的实例



=====================runloop的使用场景=====================================
Run loop 在你要和线程有更多的交互时才需要,比如以下情况:
 使用端口或自定义输入源来和其他线程通信
 使用线程的定时器
 Cocoa 中使用任何 performSelector...的方法
 使线程周期性工作


Run loop 对象提供了添加输入源,定时器和 run loop 的观察者以及启动 run loop 的接口
每个线程都有唯一的与之关联的 run loop 对象。在 Cocoa 中,该对象是 NSRunLoop 类的一个实例
========================获得runloop===================没走通===============
//把当前监听netserviece的输入源加入到runloop，然后移除
    NSNetService *service = [[NSNetService alloc] initWithDomain:@"local" type:@"_crypttest._tcp" name:[[UIDevice currentDevice] name] port:55663];
    [service publish];//通知接收者
    CFReadStreamRef readStream = NULL;
    CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
    [readStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [readStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
//runloop中添加timer
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:5.0];
    NSTimer *cameraTimer = [[NSTimer alloc] initWithFireDate:fireDate interval:1.0 target:self selector:@selector(timedPhotoFire) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:cameraTimer forMode:NSDefaultRunLoopMode];
    self.cameraTimer = cameraTimer;
        //注意timer要释放
    if ([self.cameraTimer isValid])
    {
        [self.cameraTimer invalidate];
    }
//

===========================GCD和block===============================
http://blog.sina.com.cn/s/blog_7b9d64af0101c75e.html



==========================术语================================

Run loop(运行循环) 一个事件处理循环,在此期间事件被接收并分配给合适的处理例程。
 Run loop 模式(run loop mode)
与某一特定名称相关的输入源、定时源和 run loop 观察者的集合。当运行在 某一特定“模式”下,一个 run loop 监视和该模式相关的源和观察者。
 Run loop 对象(run loop object)
NSRunLoop 类或 CFRunLoopRef 不透明类型的实例。这些对象供线程里面实现事件处理循环的接口。
 Run loop 观察者(run loop observer)在 run loop 运行的不同阶段时接收通知的对象。


==========================================================




==========================================================



=========================ios常用的宏=================================

http://965678322.blog.51cto.com/4935622/1281406
//ios国外常用网站
http://blog.sina.com.cn/s/blog_4b55f6860101hi53.html

==========================================================