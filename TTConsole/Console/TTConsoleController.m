//
//  TTConsoleController.m
//  Pods-TTConsole_Example
//
//  Created by 打不死的强丿 on 2019/6/7.
//

#import "TTConsoleController.h"
#import "TTLogViewController.h"
#import "TTEnvViewController.h"
#import "TTHttpViewController.h"
#import "TTCrashViewController.h"
#import "TTSandboxViewController.h"

typedef NS_OPTIONS(NSUInteger, TTConsoleItemType) {
    CONSOLE_ENV          = 0, // 环境切换
    CONSOLE_HTTP         = 1, // 网络请求
    CONSOLE_LOG          = 2, // 调试日志
    CONSOLE_CRASH        = 3, // 崩溃日志
    CONSOLE_SANDBOX      = 4, // 沙盒文件
};

static NSString * TTConsoleItemTypeKey = @"type";
static NSString * TTConsoleItemNameKey = @"name";

@interface TTConsoleController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView  *tableView;
@property(nonatomic,strong) NSArray      *dataSource;
@end

@implementation TTConsoleController


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
    [self loadData];
}

#pragma mark - nav
- (void)setupNav
{
    self.navigationItem.title = @"调试工具";
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Resource.bundle/close"] style:UIBarButtonItemStylePlain target:self action:@selector(closeController)];
    self.navigationItem.leftBarButtonItem = closeItem;
}

- (void)closeController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UI
- (void)setupUI
{
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 55;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _tableView;
}

#pragma mark - Data
- (void)loadData
{
    self.dataSource = @[
                        @{TTConsoleItemTypeKey:@(CONSOLE_ENV),TTConsoleItemNameKey:@"环境切换"},
                        @{TTConsoleItemTypeKey:@(CONSOLE_HTTP),TTConsoleItemNameKey:@"网络请求"},
                        @{TTConsoleItemTypeKey:@(CONSOLE_LOG),TTConsoleItemNameKey:@"调试日志"},
                        @{TTConsoleItemTypeKey:@(CONSOLE_CRASH),TTConsoleItemNameKey:@"崩溃收集"},
                        @{TTConsoleItemTypeKey:@(CONSOLE_SANDBOX),TTConsoleItemNameKey:@"沙盒浏览"}
                        ];
    [self.tableView reloadData];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = self.dataSource[indexPath.row][TTConsoleItemNameKey];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch ([self.dataSource[indexPath.row][TTConsoleItemTypeKey] integerValue]) {
        case CONSOLE_ENV:
        {
            [self.navigationController pushViewController:[TTEnvViewController new] animated:YES];
        }
            break;
        case CONSOLE_HTTP:
        {
            [self.navigationController pushViewController:[TTHttpViewController new] animated:YES];
        }
            break;
        case CONSOLE_LOG:
        {
            [self.navigationController pushViewController:[TTLogViewController new] animated:YES];
        }
            break;
        case CONSOLE_CRASH:
        {
            [self.navigationController pushViewController:[TTCrashViewController new] animated:YES];
        }
            break;
        case CONSOLE_SANDBOX:
        {
            [self.navigationController pushViewController:[TTSandboxViewController new] animated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
