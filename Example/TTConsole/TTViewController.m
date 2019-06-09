//
//  TTViewController.m
//  TTConsole
//
//  Created by icofans on 04/30/2019.
//  Copyright (c) 2019 icofans. All rights reserved.
//

#import "TTViewController.h"
#import <TTConsole/TTConsole.h>
#import "TestApi.h"
#import <AFNetworking.h>

@interface TTViewController ()

@end

@implementation TTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    NSLog(@"测试一下日志");
    
    NSLog(@"application 完成");
    
    NSLog(@"测试一下日志");
    
    NSLog(@"viewDidLoad 完成");
    NSLog(@"viewDidLoad 完成");
    NSLog(@"viewDidLoad 完成");
    NSLog(@"viewDidLoad 完成");
    NSLog(@"viewDidLoad 完成");
    NSLog(@"viewDidLoad 完成");
    NSLog(@"viewDidLoad 完成");
    NSLog(@"viewDidLoad 完成");
    NSLog(@"viewDidLoad 完成");
    
    NSLog(@"[%@]",[UIApplication sharedApplication].keyWindow);
    NSLog(@"[%@]",[UIApplication sharedApplication].delegate.window);
    
    NSLog(@"viewDidLoad 完成");
    NSLog(@"viewDidLoad 完成");
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    button.center = self.view.center;
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:button];
    
    
    NSLog(@"%@",button);
    
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger GET:@"http://api.nnzhp.cn/api/user/stu_info" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    TestApi *api = [[TestApi alloc] init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"---");
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"xxx");
    }];
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
    }];
    
    
    NSData* data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.quwenlieqi.com/upload/allimg/140924/1606235532-14.jpg"]];   
}

- (void)click
{
    NSArray *arr = @[];
    
    arr[2];
    
    UIViewController *vc = [UIViewController new];
    [vc setValue:@"1" forKey:@"1"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
