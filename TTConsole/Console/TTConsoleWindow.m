//
//  TTConsoleWindow.m
//  Pods-TTConsole_Example
//
//  Created by 打不死的强丿 on 2019/6/7.
//

#import "TTConsoleWindow.h"

#define showDuration 0.1          //展开动画时间
#define statusChangeDuration  3.0    //状态改变时间
#define normalAlpha  0.8           //正常状态时背景alpha值
#define sleepAlpha  0.3           //隐藏到边缘时的背景alpha值
#define myBorderWidth 1.0         //外框宽度
#define marginWith  5             //间隔

@interface TTConsoleWindow ()

@property(nonatomic,strong)UIButton *consoleButton;

@property(nonatomic,strong)UIPanGestureRecognizer *pan;//移动手势
@property(nonatomic,strong)UITapGestureRecognizer *tap;//点击主按钮

@end

@implementation TTConsoleWindow

- (UIButton *)consoleButton
{
    if (!_consoleButton) {
        _consoleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_consoleButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:184/255.0 blue:108/255.0 alpha:0.6]];
        [_consoleButton setFrame:CGRectMake(0, 0, 44, 44)];
        [_consoleButton setTitle:@"调试" forState:UIControlStateNormal];
        [_consoleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _consoleButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _consoleButton.layer.cornerRadius = 22;
        _consoleButton.layer.masksToBounds = YES;
        _consoleButton.layer.shouldRasterize = YES;
        _consoleButton.layer.borderWidth = 1;
        _consoleButton.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
        _consoleButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
        [_consoleButton addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //手势
        _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(locationChange:)];
        _pan.delaysTouchesBegan = NO;
        [_consoleButton addGestureRecognizer:_pan];
    }
    return _consoleButton;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height-44)/2, 44, 44)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 这里有个坑，调用makeKeyAndVisible会替换keywindow，导致其他使用keywindow的控件可能出现的问题
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelStatusBar + 1;  //如果想在 alert 之上，则改成 + 2
        self.rootViewController = [UIViewController new];
        [self makeKeyAndVisible];
        [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
        [self addSubview:self.consoleButton];
        
    }
    return self;
}

//拖拽悬浮窗（pan移动手势响应）
- (void)locationChange:(UIPanGestureRecognizer*)p
{
    CGFloat w = 44;
    CGFloat h = 44;
    CGFloat kw = [UIScreen mainScreen].bounds.size.width;
    CGFloat kh = [UIScreen mainScreen].bounds.size.height;
    CGFloat animateDuration = 0.3;
    
    CGPoint panPoint = [p locationInView:[[UIApplication sharedApplication] keyWindow]];
    if(p.state == UIGestureRecognizerStateChanged)
    {
        self.center = CGPointMake(panPoint.x, panPoint.y);
    }
    else if(p.state == UIGestureRecognizerStateEnded)
    {
        if(panPoint.x <= kw/2)
        {
            CGFloat pointy = panPoint.y;
            if (pointy < 64 + h/2) {
                pointy = 64 + h/2;
            }
            if (pointy > kh - 44 - h/2) {
                pointy = kh - 44 - h/2;
            }
            [UIView animateWithDuration:animateDuration animations:^{
                self.center = CGPointMake(w/2, pointy);
            }];
        }
        else if(panPoint.x > kw/2)
        {
            CGFloat pointy = panPoint.y;
            if (pointy < 64 + h/2) {
                pointy = 64 + h/2;
            }
            if (pointy > kh - 44 - h/2) {
                pointy = kh - 44 - h/2;
            }
            [UIView animateWithDuration:animateDuration animations:^{
                self.center = CGPointMake(kw-w/2, pointy);
            }];
        }
    }
}

//点击事件
- (void)tapAction:(UIButton *)sender
{
    if (self.onClick) {
        self.onClick();
    }
}

@end
