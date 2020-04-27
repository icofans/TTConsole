//
//  TTCrashDetailViewController.m
//  AFNetworking
//
//  Created by 打不死的强丿 on 2019/6/9.
//

#import "TTCrashDetailViewController.h"
#import "TTCrashHelper.h"
#import "TTCrashStackTableViewCell.h"

@interface TTCrashDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView  *tableView;
@property(nonatomic,strong) NSArray      *dataSource;

@end

@implementation TTCrashDetailViewController

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
    self.navigationItem.title = @"Crash Info";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Console.bundle/back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
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
        [_tableView registerClass:[TTCrashStackTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TTCrashStackTableViewCell class])];
    }
    return _tableView;
}

#pragma mark - Data
- (void)loadData
{
    NSArray *arr = [self.model[TTCrashCallStackKey] componentsSeparatedByString:@"\n"];
    
    if (arr.count > 3) {
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:arr];
        [tempArr removeObject:tempArr.firstObject];
        [tempArr removeObject:tempArr.lastObject];
        self.dataSource = [tempArr copy];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell;
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        cell.textLabel.textColor = [UIColor colorWithRed:255/255.0 green:184/255.0 blue:108/255.0 alpha:1];
        cell.textLabel.text = self.model[TTCrashNameKey];
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.text = self.model[TTCrashReasonKey];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return cell;
    } else {
        TTCrashStackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTCrashStackTableViewCell class]) forIndexPath:indexPath];
        [cell setCellInfo:self.dataSource[indexPath.row-1]];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return cell;
    }
}

@end
