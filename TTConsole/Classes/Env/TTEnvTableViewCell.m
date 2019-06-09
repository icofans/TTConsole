//
//  TTEnvTableViewCell.m
//  fishhook
//
//  Created by 打不死的强丿 on 2019/6/8.
//

#import "TTEnvTableViewCell.h"

NSString * const TTEnvironmentTypeKey = @"type";
NSString * const TTEnvironmentNameKey = @"name";
NSString * const TTEnvironmentSelectKey = @"select";

@interface TTEnvTableViewCell ()

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UIImageView *indicator;

@end

@implementation TTEnvTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatUI];
    }
    return self;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _bgView.layer.cornerRadius = 8;
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.borderWidth = 1;
    }
    return _bgView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
    }
    return _nameLabel;
}

- (UIImageView *)indicator
{
    if (!_indicator) {
        _indicator = [[UIImageView alloc] init];
        _indicator.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _indicator;
}

- (void)creatUI
{
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.nameLabel];
    [self.bgView addSubview:self.indicator];
    
}

- (void)setCellInfo:(NSDictionary *)model
{
    self.nameLabel.text = model[TTEnvironmentNameKey];
    self.nameLabel.textColor = [model[TTEnvironmentSelectKey] boolValue]?[UIColor colorWithRed:26/255.0 green:173/255.0 blue:22/255.0 alpha:1]:[UIColor colorWithRed:255/255.0 green:184/255.0 blue:108/255.0 alpha:1];
    self.indicator.image = [model[TTEnvironmentSelectKey] boolValue]?[UIImage imageNamed:@"Resource.bundle/on"]:[UIImage imageNamed:@"Resource.bundle/off"];
    self.bgView.layer.borderColor = ([model[TTEnvironmentSelectKey] boolValue]?[UIColor colorWithRed:26/255.0 green:173/255.0 blue:22/255.0 alpha:1]:[UIColor clearColor]).CGColor;
}

- (void)layoutSubviews
{
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat iconW = 30;
    self.bgView.frame = CGRectMake(8, 8, w-16, self.frame.size.height-16);
    self.nameLabel.frame = CGRectMake(16, 0, self.bgView.frame.size.width/2, self.bgView.frame.size.height);
    self.indicator.frame = CGRectMake(CGRectGetWidth(self.bgView.frame)-iconW-16, (CGRectGetHeight(self.bgView.frame)-iconW)/2, iconW, iconW);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
