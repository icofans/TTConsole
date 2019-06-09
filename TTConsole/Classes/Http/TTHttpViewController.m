//
//  TTHttpViewController.m
//  TTConsole-Resource
//
//  Created by 打不死的强丿 on 2019/6/7.
//

#import "TTHttpViewController.h"
#import "TTHttpHelper.h"
#import "TTURLRequestKey.h"
#import "TTHttpDetailViewController.h"

@interface TTHttpViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView  *tableView;
@property(nonatomic,strong) NSArray      *dataSource;

@end

@implementation TTHttpViewController

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
    
    typeof(self) __weak weakSelf = self;
    [TTHttpHelper helper].requestHookHandler = ^{
        [weakSelf loadData];
    };
}

- (void)setupNav
{
    self.navigationItem.title = @"网络请求";
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
    [[TTHttpHelper helper] clear];
    [self loadData];
    
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 55;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _tableView;
}

#pragma mark - Data
- (void)loadData
{
    self.dataSource = [[TTHttpHelper helper].requestArr copy];
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
    cell.textLabel.text = [self.dataSource[indexPath.row][TTURLRequestUrlKey] host];
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    NSString *path = [self.dataSource[indexPath.row][TTURLRequestUrlKey] path];
    cell.detailTextLabel.text = path.length?path:@"/";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    TTHttpDetailViewController *detail = [[TTHttpDetailViewController alloc] init];
    detail.model = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
   
}

@end
