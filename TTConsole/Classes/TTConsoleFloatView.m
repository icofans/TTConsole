//
//  TTConsoleFloatView.m
//  Pods-TTConsole_Example
//
//  Created by 王家强 on 2019/4/30.
//

#import "TTConsoleFloatView.h"

@interface TTConsoleFloatView ()

@property(nonatomic,strong)UIButton *floatButton;

@end

@implementation TTConsoleFloatView

- (UIButton *)floatButton
{
    if (!_floatButton) {
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _floatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_floatButton setBackgroundColor:[UIColor colorWithRed:26/255.0 green:173/255.0 blue:22/255.0 alpha:1]];
        [_floatButton setFrame:frame];
        [_floatButton setTitle:@"Console" forState:UIControlStateNormal];
        [_floatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _floatButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _floatButton.layer.cornerRadius = 3;
        _floatButton.layer.masksToBounds = YES;
        _floatButton.layer.shadowColor = [UIColor blackColor].CGColor;
        _floatButton.layer.shadowOffset = CGSizeMake(0,4);
        _floatButton.layer.shadowRadius = 3;
        _floatButton.layer.shadowOpacity = 0.3;
        _floatButton.layer.shouldRasterize = YES;
        _floatButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:3];
        _floatButton.layer.shadowPath = path.CGPath;
        _floatButton.alpha = 0.6;
        [_floatButton addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _floatButton;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2, 80, 26)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame image:nil];
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelAlert + 1;  //如果想在 alert 之上，则改成 + 2
        self.rootViewController = [UIViewController new];
        [self makeKeyAndVisible];
        
        [self addSubview:self.floatButton];
        
        // 添加手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        pan.delaysTouchesBegan = NO;
        [self addGestureRecognizer:pan];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)dissmissWindow{
    self.hidden = YES;
}
- (void)showWindow{
    self.hidden = NO;
}

//改变位置
- (void)panAction:(UIPanGestureRecognizer*)p
{
    CGPoint panPoint = [p locationInView:[[UIApplication sharedApplication] keyWindow]];
    if(p.state == UIGestureRecognizerStateBegan)
    {
    }
    if(p.state == UIGestureRecognizerStateChanged)
    {
        CGFloat centerX = panPoint.x;
        CGFloat centerY = panPoint.y;
        
        CGFloat kSWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat kSHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat kWidth = self.frame.size.width;
        CGFloat kHeight = self.frame.size.height;
        
        // 预留2的间隙
        CGFloat kMagin = 2;
        if (panPoint.x >= kSWidth - kWidth) {
            centerX = kSWidth - kWidth/2 - kMagin;
        }
        if (panPoint.x <= kWidth/2) {
            centerX = kWidth/2 + kMagin;
        }
        if (panPoint.y >= kSHeight - kHeight) {
            centerY = kSHeight - kHeight/2 - kMagin;
        }
        if (panPoint.y <= 44) {
            centerY = 44;
        }
        self.center = CGPointMake(centerX, centerY);
    }
    else if(p.state == UIGestureRecognizerStateEnded)
    {
        
    }
}
//点击事件
- (void)tapAction:(UITapGestureRecognizer*)p
{
    if (self.onClick) {
        self.onClick();
    }
}

@end
