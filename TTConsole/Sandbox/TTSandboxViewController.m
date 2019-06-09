//
//  TTSandboxViewController.m
//  TTConsole-Resource
//
//  Created by 打不死的强丿 on 2019/6/9.
//

#import "TTSandboxViewController.h"
#import "TTImgPreViewController.h"
#import "TTTextPreViewController.h"
#import <QuickLook/QuickLook.h>

@interface TTSandboxViewController ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSFileManager  *fileManager;
@property (nonatomic, strong) NSURL  *fileUrl;

@end

@implementation TTSandboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self setupNav];
    [self loadData];
}

- (void)setupUI
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SANDBOX_CELL"];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView reloadData];
}

- (void)setupNav
{
    self.navigationItem.title = self.filePath?[self.filePath lastPathComponent]:@"SandBox";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Resource.bundle/back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData {
    if (!self.filePath) {
        self.filePath = NSHomeDirectory();
    }
    self.fileManager = [NSFileManager defaultManager];
    NSArray *data = [NSMutableArray arrayWithArray:[self.fileManager contentsOfDirectoryAtPath:self.filePath error:nil]];
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSComparator finderSortBlock = ^(id string1,id string2) {
        NSRange string1Range = NSMakeRange(0, [string1 length]);
        return [string1 compare:string2 options:kNilOptions range:string1Range locale:currentLocale];
    };
    
    self.data = [NSMutableArray arrayWithArray:[data sortedArrayUsingComparator:finderSortBlock]];
    if ([self.data containsObject:@".DS_Store"]) {
        [self.data removeObject:@".DS_Store"];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SANDBOX_CELL" forIndexPath:indexPath];
    cell.textLabel.text = self.data[indexPath.row];
    NSString *subPath = [self.filePath stringByAppendingPathComponent:self.data[indexPath.row]];
    BOOL directiory = NO;
    [_fileManager fileExistsAtPath:subPath isDirectory:&directiory];
    cell.accessoryType = directiory ? UITableViewCellAccessoryDisclosureIndicator :UITableViewCellAccessoryNone ;
    cell.imageView.image = [UIImage imageNamed:directiory ? @"Resource.bundle/folder" : @"Resource.bundle/file"];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UITableViewCellEditingStyleDelete == editingStyle ) {
        NSString *subPath = [self.filePath stringByAppendingPathComponent:self.data[indexPath.row]];
        NSError *error = nil;
        [_fileManager removeItemAtPath:subPath error:&error];
        if (!error) {
            [self.data removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            NSLog(@"delete failed at path:%@", subPath);
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *current = self.data[indexPath.row];
    NSString *subPath = [self.filePath stringByAppendingPathComponent:current];
    BOOL directiory = NO;
    [_fileManager fileExistsAtPath:subPath isDirectory:&directiory];
    
    if (directiory) {
        TTSandboxViewController *controller = [[TTSandboxViewController alloc] init];
        controller.title = current;
        controller.filePath = subPath;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        if ([QLPreviewController canPreviewItem:(id)[NSURL fileURLWithPath:subPath]]) {
            self.fileUrl = [NSURL fileURLWithPath:subPath];
            QLPreviewController* previewer = [[QLPreviewController alloc] init];
            previewer.dataSource = self;
            previewer.delegate = self;
            previewer.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
            [self.view addSubview:previewer.view];
            NSString *version = [UIDevice currentDevice].systemVersion;
            /// 在iOS10以下 使用didMove方法 10开始没有效果
            if (version.floatValue >= 10.0) {
                [self addChildViewController:previewer];
            } else {
                [previewer didMoveToParentViewController:self];
            }
        } else {
            NSString *pathExtension = [subPath pathExtension];
            if ([@"plist" caseInsensitiveCompare:pathExtension] == NSOrderedSame) {
                TTTextPreViewController *pre = [[TTTextPreViewController alloc] init];
                pre.title = current;
                pre.sourcePath = subPath;
                [self.navigationController pushViewController:pre animated:YES];
            }
            if ([@"png" caseInsensitiveCompare:pathExtension] == NSOrderedSame || [@"jpg" caseInsensitiveCompare:pathExtension] == NSOrderedSame || [@"jpeg" caseInsensitiveCompare:pathExtension] == NSOrderedSame || [@"gif" caseInsensitiveCompare:pathExtension] == NSOrderedSame) {
                TTImgPreViewController *pre = [[TTImgPreViewController alloc] init];
                pre.title = current;
                pre.sourcePath = subPath;
                [self.navigationController pushViewController:pre animated:YES];
            }
        }
    }
}

#pragma mark - 返回加载文件个数
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}
#pragma mark - 返回加载路径
- (id )previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return self.fileUrl;
}

@end
