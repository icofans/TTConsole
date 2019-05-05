//
//  TTConsoleLogView.m
//  Pods-TTConsole_Example
//
//  Created by 王家强 on 2019/4/30.
//

#import "TTConsoleLogView.h"

@interface TTConsoleLogView ()

@property (nonatomic, strong) UIView *topView;

@property (nonatomic,strong) UIButton *closeBtn;

@property (nonatomic,strong) UIButton *clearBtn;

@property (nonatomic, strong) UITextView *textView;

@end



@implementation TTConsoleLogView

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:247/255.0 alpha:0.6];
    }
    return _topView;
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.backgroundColor = [UIColor clearColor];
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _closeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)clearBtn
{
    if (!_clearBtn) {
        _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearBtn.backgroundColor = [UIColor clearColor];
        [_clearBtn setTitle:@"清空" forState:UIControlStateNormal];
        [_clearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _clearBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_clearBtn addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearBtn;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.editable = NO;
    }
    return _textView;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topView];
        [self.topView addSubview:self.closeBtn];
        [self.topView addSubview:self.clearBtn];
        [self addSubview:self.textView];
        
        self.topView.frame = CGRectMake(0, 0, self.frame.size.width, 40);
        self.clearBtn.frame = CGRectMake(8, 0, 40, 40);
        self.closeBtn.frame = CGRectMake(self.frame.size.width-8-40, 0, 40, 40);
        self.textView.frame = CGRectMake(8, CGRectGetMaxY(self.topView.frame)+4, self.frame.size.width-16, self.frame.size.height-CGRectGetMaxY(self.topView.frame)-8);
    }
    return self;
}

- (void)close
{
    if (self.closeClick) {
        self.closeClick();
    }
}

- (void)clear
{
    self.textView.attributedText = [[NSAttributedString alloc] initWithString:@""];
    if (self.clearClick) {
        self.clearClick();
    }
}

//MARK:更新所有日志
- (void)updateAllLog:(NSAttributedString *)str {
    self.textView.attributedText = str;
}

//MARK:更新日志
- (void)updateLog:(NSAttributedString *)str {
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    [att appendAttributedString:str];
    self.textView.attributedText = att;
}

@end
