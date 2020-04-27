//
//  TTTextPreViewController.m
//  AFNetworking
//
//  Created by 打不死的强丿 on 2019/6/9.
//

#import "TTTextPreViewController.h"

@interface TTTextPreViewController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation TTTextPreViewController

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.editable = NO;
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
}

- (void)setupUI
{
    [self.view addSubview:self.textView];
    
    NSString *pathExtension = [self.sourcePath pathExtension];
    if ([@"plist" caseInsensitiveCompare:pathExtension] == NSOrderedSame) {
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:self.sourcePath];
        if (dictionary) {
            NSString *text = [NSString stringWithFormat:@"%@",dictionary];
            text = [text stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
            text = [text stringByReplacingOccurrencesOfString:@"\\t" withString:@"\t"];
            self.textView.text = text;
        }
        NSArray *arr = [NSArray arrayWithContentsOfFile:self.sourcePath];
        if (arr) {
            NSString *text = [NSString stringWithFormat:@"%@",arr];
            text = [text stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
            text = [text stringByReplacingOccurrencesOfString:@"\\t" withString:@"\t"];
            self.textView.text = text;
        }
    } else {
        NSString *text = [NSString stringWithContentsOfFile:self.sourcePath encoding:NSUTF8StringEncoding error:nil];
        self.textView.text = text;
    }
}

- (void)setupNav
{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Console.bundle/back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
