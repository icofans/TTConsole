//
//  TTConsole.m
//  Pods
//
//  Created by 王家强 on 2019/4/30.
//

#import "TTConsole.h"
#import "TTConsoleFloatView.h"
#import "TTConsoleLogView.h"

@interface TTConsole ()
@property (nonatomic, strong) NSMutableAttributedString *attributedlogStr;
@property (strong, nonatomic) TTConsoleFloatView *floatView;
@property (strong, nonatomic) TTConsoleLogView *logView;

@end

@implementation TTConsole

+ (instancetype)console {
    static TTConsole *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
        instance.attributedlogStr = [[NSMutableAttributedString alloc] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [TTConsole console];
}

- (void)markLog:(NSString *)log {
    // 注册
    if ([[TTConsole console] registerConsole]) {
        NSString * addLog = [NSString stringWithFormat:@"%@\n", log];
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        style.lineSpacing = 3;
        style.headIndent = 4;
        NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:addLog attributes:@{NSParagraphStyleAttributeName:style}];
        [self.attributedlogStr appendAttributedString:attrText];
        
        if (!_logView.hidden) {
            [_logView updateLog:attrText];
        }
    }
}

- (BOOL)registerConsole {
    if (![[UIApplication sharedApplication] delegate].window) {
        NSLog(@"[Application]还未启动");
        return NO;
    } else {
        if (!self.floatView) {
            self.floatView = [[TTConsoleFloatView alloc] init];
            __weak __typeof(self)weakSelf = self;
            self.floatView.onClick = ^{
                weakSelf.floatView.hidden = YES;
                weakSelf.logView.hidden = NO;
                [weakSelf.logView updateAllLog:[weakSelf.attributedlogStr copy]];
            };
        }
        return YES;
    }
}

- (TTConsoleLogView *)logView
{
    if (!_logView) {
        _logView = [[TTConsoleLogView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-240, [UIScreen mainScreen].bounds.size.width, 240)];
        __weak __typeof(self)weakSelf = self;
        _logView.closeClick = ^{
            weakSelf.floatView.hidden = NO;
            weakSelf.logView.hidden = YES;
        };
        _logView.clearClick = ^{
            weakSelf.attributedlogStr = [[NSMutableAttributedString alloc] init];
        };
        [[[UIApplication sharedApplication] delegate].window addSubview:_logView];
    }
    return _logView;
}

@end
