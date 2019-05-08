//
//  ViewController.m
//  RunLoopDemo
//
//  Created by 草帽~小子 on 2019/5/8.
//  Copyright © 2019 OnePiece. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIImageView *showImgae;
@property (nonatomic, strong) NSThread *thread;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self runloop1];
    
//    [self runloop2];
    
    //[self runloop3];
    
    [self runloop4];
    
    // Do any additional setup after loading the view.
}

- (void)runloop1 {
    [self setSubViews];
    self.timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(run) userInfo:nil repeats:YES];
    // 将定时器添加到当前RunLoop的NSDefaultRunLoopMode下
    // 此时滑动textView定时器停止打印
    //[[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    // 将定时器添加到当前RunLoop的UITrackingRunLoopMode下，只在拖动情况下工作
    //[[NSRunLoop currentRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
    
//    // 将定时器添加到当前RunLoop的NSRunLoopCommonModes下，定时器就会跑在被标记为Common Modes的模式下
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
//
    //调用了scheduledTimer返回的定时器，已经自动被加入到了RunLoop的NSDefaultRunLoopMode模式下。
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(run) userInfo:nil repeats:YES];
    
}

- (void)setSubViews {
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width - 100, 80)];
    self.textView.backgroundColor = [UIColor cyanColor];
    self.textView.text = @"The 1896 Cedar Keys hurricane was a powerful tropical cyclone that devastated much of the East Coast of the United States, starting with Florida's Cedar Keys, near the end of September. The storm's rapid movement allowed it to maintain much of its intensity after landfall, becoming one of the costliest United States hurricanes at the time. The fourth tropical cyclone of the 1896 Atlantic hurricane season, it washed out the railroad connecting the Cedar Keys to the mainland with a 10.5 ft (3.2 m) storm surge, and submerged much of the island group (Cedar Key flooding pictured). ";
    [self.view addSubview:self.textView];
}

- (void)run {
    NSLog(@"time====");
}

- (void)runloop2 {
    CFRunLoopObserverRef observe = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        NSLog(@"监听到RunLoop发生改变---%zd",activity);
    });
    
    // 添加观察者到当前RunLoop中
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observe, kCFRunLoopDefaultMode);
    // 释放observer，最后添加完需要释放掉
    CFRelease(observe);
    
}
/**
 * 第三个例子：用来展示UIImageView的延迟显示
 */
- (void)runloop3 {
    [self setSubViews];
    self.showImgae = [[UIImageView alloc] initWithFrame:CGRectMake(0, 400, 300, 300)];
    [self.view addSubview:self.showImgae];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 用来展示UIImageView的延迟显示
    //[self.showImgae performSelector:@selector(setImage:) withObject:[UIImage imageNamed:@"image.jpg"] afterDelay:4.0 inModes:@[NSDefaultRunLoopMode]];
    
    // 利用performSelector，在self.thread的线程中调用run2方法执行任务
    [self performSelector:@selector(run2) onThread:self.thread withObject:nil waitUntilDone:NO];
 
}

- (void)runloop4 {
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(run1) object:nil];
    [self.thread start];
}

- (void)run1 {
    // 这里写任务
    NSLog(@"----run1-----");
    
    // 添加下边两句代码，就可以开启RunLoop，之后self.thread就变成了常驻线程，可随时添加任务，并交于RunLoop处理
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
    
    // 测试是否开启了RunLoop，如果开启RunLoop，则来不了这里，因为RunLoop开启了循环。
    NSLog(@"未开启RunLoop");
    
}

- (void)run2 {
    NSLog(@"----run2------");
}


@end
