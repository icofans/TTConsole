//
//  TTViewController.m
//  TTConsole
//
//  Created by icofans on 04/30/2019.
//  Copyright (c) 2019 icofans. All rights reserved.
//

#import "TTViewController.h"
#import <TTConsole/TTConsole.h>

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
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    button.center = self.view.center;
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:button];
    
}

- (void)click
{
    UIViewController *vc = [UIViewController new];
    vc.view.backgroundColor = [UIColor redColor];
    [UIApplication sharedApplication].keyWindow.rootViewController = vc;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
