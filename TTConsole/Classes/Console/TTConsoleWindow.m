//
//  TTConsoleWindow.m
//  Pods-TTConsole_Example
//
//  Created by 打不死的强丿 on 2019/6/7.
//

#import "TTConsoleWindow.h"

@interface TTConsoleWindow ()

@property(nonatomic,strong)UIButton *consoleButton;

@end

@implementation TTConsoleWindow

- (UIButton *)consoleButton
{
    if (!_consoleButton) {
        _consoleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_consoleButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:184/255.0 blue:108/255.0 alpha:0.2]];
        [_consoleButton setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
        [_consoleButton setTitle:@"" forState:UIControlStateNormal];
        [_consoleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _consoleButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _consoleButton.layer.cornerRadius = 3;
        _consoleButton.layer.masksToBounds = YES;
        _consoleButton.layer.shadowColor = [UIColor blackColor].CGColor;
        _consoleButton.layer.shadowOffset = CGSizeMake(0,4);
        _consoleButton.layer.shadowRadius = 3;
        _consoleButton.layer.shadowOpacity = 0.3;
        _consoleButton.layer.shouldRasterize = YES;
        _consoleButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
        [_consoleButton addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _consoleButton;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
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

//点击事件
- (void)tapAction:(UIButton *)sender
{
    if (self.onClick) {
        self.onClick();
    }
}

@end
