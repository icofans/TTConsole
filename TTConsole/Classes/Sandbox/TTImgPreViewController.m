//
//  TTImgPreViewController.m
//  AFNetworking
//
//  Created by 打不死的强丿 on 2019/6/9.
//

#import "TTImgPreViewController.h"

@interface TTImgPreViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation TTImgPreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.imageView.image = [UIImage imageWithContentsOfFile:self.sourcePath];
    [self.view addSubview:self.imageView];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.center = self.view.center;
}
- (UIImageView *) imageView {
    if (!_imageView) {
        CGRect rect = self.view.bounds;
        _imageView = [[UIImageView alloc] initWithFrame:rect];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}



@end
