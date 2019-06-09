//
//  TTHttpDetailViewController.m
//  fishhook
//
//  Created by 打不死的强丿 on 2019/6/8.
//

#import "TTHttpDetailViewController.h"
#import "TTURLRequestKey.h"

static NSString * TTRequestNameKey = @"name";
static NSString * TTRequestValueKey = @"value";

@interface TTHttpDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView  *tableView;
@property(nonatomic,strong) NSArray      *dataSource;

@end

@implementation TTHttpDetailViewController

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
    self.navigationItem.title = @"请求详情";
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
        _tableView.estimatedRowHeight = 55;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _tableView;
}

- (void)loadData
{
    self.dataSource = @[
                        @{TTRequestNameKey:@"Request Url",TTRequestValueKey:[self.model[TTURLRequestUrlKey] absoluteString]},
                        @{TTRequestNameKey:@"Status Code",TTRequestValueKey:self.model[TTURLRequestStatusCodeKey]},
                        @{TTRequestNameKey:@"Mime Type",TTRequestValueKey:self.model[TTURLRequestMineTypeKey]},
                        @{TTRequestNameKey:@"Request Header",TTRequestValueKey:self.model[TTURLRequestHeaderKey]?:@""},
                        @{TTRequestNameKey:@"Request Body",TTRequestValueKey:self.model[TTURLRequestRequestBodyKey]?:@""},
                        @{TTRequestNameKey:@"Response Body",TTRequestValueKey:self.model[TTURLRequestResponseDataKey]?:@""}
                        ];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    cell.textLabel.textColor = [UIColor colorWithRed:255/255.0 green:184/255.0 blue:108/255.0 alpha:1];
    cell.textLabel.text = self.dataSource[indexPath.row][TTRequestNameKey];
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.numberOfLines = 0;
    if (indexPath.row == self.dataSource.count-1) {
        if ([self.model[TTURLRequestIsImageKey] boolValue] && self.model[TTURLRequestImageDataKey]) {
            NSTextAttachment *attchment = [[NSTextAttachment alloc] init];
            attchment.image = [UIImage imageWithData:self.model[TTURLRequestImageDataKey]];//设置图片
            NSAttributedString *attrStr = [NSAttributedString attributedStringWithAttachment:attchment];
            cell.detailTextLabel.text = nil;
            cell.detailTextLabel.attributedText = attrStr;
        } else{
            cell.detailTextLabel.attributedText = nil;
            cell.detailTextLabel.text = [self.dataSource[indexPath.row][TTRequestValueKey] length]?self.dataSource[indexPath.row][TTRequestValueKey]:@"{\n\n}";
        }
    } else {
        cell.detailTextLabel.attributedText = nil;
        cell.detailTextLabel.text = [self.dataSource[indexPath.row][TTRequestValueKey] length]?self.dataSource[indexPath.row][TTRequestValueKey]:@"{\n\n}";
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
    
}
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    return YES;
    
}
- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [UIPasteboard generalPasteboard].string = cell.detailTextLabel.text;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
