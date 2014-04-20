ThreadProject
=============
启动 run loop 只对程序的辅助线程有意义。一个 run loop 通常必须包含一个输 入源或定时器来监听事件。如果一个都没有,run loop 启动后立即退出。
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
========================获得runloop==================================
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

==========================================================




==========================================================




==========================================================




==========================================================



==========================================================





==========================================================