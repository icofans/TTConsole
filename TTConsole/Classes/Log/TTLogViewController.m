//
//  TTLogViewController.m
//  Pods-TTConsole_Example
//
//  Created by 打不死的强丿 on 2019/6/7.
//

#import "TTLogViewController.h"
#import "TTLogHelper.h"

@interface TTLogViewController ()

@property (nonatomic,strong) UIButton *clearBtn;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) NSMutableAttributedString *attributedlogStr;

@end

@implementation TTLogViewController

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
        _textView.backgroundColor = [UIColor blackColor];
        _textView.frame = self.view.bounds;
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
    }
    return _textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    // layout setting
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self setupNav];
    [self setupUI];
    
    typeof(self) __weak weakSelf = self;
    [TTLogHelper helper].updateLogStr = ^(NSMutableAttributedString *logStr) {
        [weakSelf updateLog:logStr];
    };
}

- (void)setupUI
{
    [self.view addSubview:self.textView];
    [self updateAllLog:[TTLogHelper helper].logStr];
}

- (void)setupNav
{
    self.navigationItem.title = @"调试日志";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Resource.bundle/back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIBarButtonItem *clearItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Resource.bundle/delete"] style:UIBarButtonItemStylePlain target:self action:@selector(clear)];
    self.navigationItem.rightBarButtonItem = clearItem;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clear
{
    self.textView.attributedText = [[NSAttributedString alloc] initWithString:@""];
    [[TTLogHelper helper].logStr setAttributedString:[[NSAttributedString alloc] init]];
}

#pragma mark - private
- (void)updateAllLog:(NSAttributedString *)str {
    self.textView.attributedText = str;
}
- (void)updateLog:(NSAttributedString *)str {
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    [att appendAttributedString:str];
    self.textView.attributedText = att;
}

@end
