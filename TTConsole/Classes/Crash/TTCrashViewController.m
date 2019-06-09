//
//  TTCrashViewController.m
//  TTConsole-Resource
//
//  Created by 打不死的强丿 on 2019/6/8.
//

#import "TTCrashViewController.h"
#import "TTCrashHelper.h"
#import "TTCrashDetailViewController.h"

@interface TTCrashViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView  *tableView;
@property(nonatomic,strong) NSArray      *dataSource;

@end

@implementation TTCrashViewController

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
    self.navigationItem.title = @"崩溃收集";
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
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 55;
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
    self.dataSource = [[TTCrashHelper helper] crashLogs];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    cell.textLabel.textColor = [UIColor colorWithRed:255/255.0 green:184/255.0 blue:108/255.0 alpha:1];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = self.dataSource[indexPath.row][TTCrashNameKey];
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@",self.dataSource[indexPath.row][TTCrashDateKey],self.dataSource[indexPath.row][TTCrashReasonKey]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TTCrashDetailViewController *detail = [[TTCrashDetailViewController alloc] init];
    detail.model = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}

@end
