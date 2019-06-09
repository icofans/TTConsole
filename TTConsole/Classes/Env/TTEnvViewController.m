//
//  TTEnvViewController.m
//  TTConsole-Resource
//
//  Created by 打不死的强丿 on 2019/6/7.
//

#import "TTEnvViewController.h"
#import "TTEnvTableViewCell.h"
#import "TTConsole.h"

@interface TTEnvViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView  *tableView;
@property(nonatomic,strong) NSArray      *dataSource;

@end

@implementation TTEnvViewController

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

- (void)setupNav
{
    self.navigationItem.title = @"环境切换";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Resource.bundle/back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
        _tableView.rowHeight = 80;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_tableView registerClass:[TTEnvTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TTEnvTableViewCell class])];
    }
    return _tableView;
}

#pragma mark - Data
- (void)loadData
{
    self.dataSource = @[
                        @{
                            TTEnvironmentTypeKey:@(ENV_INTRANET_TEST),
                            TTEnvironmentNameKey:@"内网测试环境",
                            TTEnvironmentSelectKey: @([TTConsole console].currentEnvironment == ENV_INTRANET_TEST)
                            },
                        @{
                            TTEnvironmentTypeKey:@(ENV_OUTERNET_TEST),
                            TTEnvironmentNameKey:@"外网测试环境",
                            TTEnvironmentSelectKey: @([TTConsole console].currentEnvironment == ENV_OUTERNET_TEST)
                            },
                        @{
                            TTEnvironmentTypeKey:@(ENV_PRODUCTION_TEST),
                            TTEnvironmentNameKey:@"外网正式环境",
                            TTEnvironmentSelectKey: @([TTConsole console].currentEnvironment == ENV_PRODUCTION_TEST)
                            }
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
    TTEnvTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTEnvTableViewCell class]) forIndexPath:indexPath];
    [cell setCellInfo:self.dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == [[NSUserDefaults standardUserDefaults] integerForKey:TTEnvironmentKey]) {
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"是否切换至”%@“,切换后需重启生效",self.dataSource[indexPath.row][TTEnvironmentNameKey]] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    typeof(self) __weak weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 处理数据源
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:weakSelf.dataSource];
        [tempArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:obj];
            dict[TTEnvironmentSelectKey] = (idx == indexPath.row)?@YES:@NO;
            [tempArr replaceObjectAtIndex:idx withObject:[dict copy]];
        }];
        weakSelf.dataSource = [tempArr copy];
        
        // 存储
        [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:TTEnvironmentKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if ([TTConsole console].environmentChanged) {
            [TTConsole console].environmentChanged(indexPath.row);
        }
        [weakSelf.tableView reloadData];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
