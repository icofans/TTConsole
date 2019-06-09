//
//  TTCrashStackTableViewCell.m
//  AFNetworking
//
//  Created by 打不死的强丿 on 2019/6/9.
//

#import "TTCrashStackTableViewCell.h"

@interface TTCrashStackTableViewCell ()

@property (nonatomic,strong) UILabel *lineLabel;

@property (nonatomic,strong) UILabel *contentLabel;

@end

@implementation TTCrashStackTableViewCell

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

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.textColor = [UIColor grayColor];
        _contentLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    return _contentLabel;
}

- (UILabel *)lineLabel
{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
        _lineLabel.font = [UIFont systemFontOfSize:13];
        _lineLabel.textColor = [UIColor grayColor];
        _lineLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _lineLabel;
}

- (void)creatUI
{
    [self.contentView addSubview:self.lineLabel];
    [self.contentView addSubview:self.contentLabel];
    self.contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.lineLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.lineLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:40];
    [self.lineLabel addConstraint:widthConstraint];

    CGFloat margin = 8;
    [self.contentView addConstraints:@[
                                // lineLabel
                                [NSLayoutConstraint constraintWithItem:self.lineLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.lineLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.lineLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
                                // contentLabel
                                [NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.lineLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:margin],
                                [NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:margin],
                                [NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-margin],
                                [NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-margin]
                                ]];
}

- (void)setCellInfo:(NSString *)text
{
    text = [text componentsSeparatedByString:@"\t"].lastObject;
    
    NSArray *components = [text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:components];
    self.lineLabel.text = arr.firstObject;
    [arr removeObjectAtIndex:0];
    if (arr.count > 2) {
        NSString *line1 = arr.firstObject;
        NSString *line2 = arr[1];
        NSString *line3 = [[arr subarrayWithRange:NSMakeRange(2, arr.count-2)] componentsJoinedByString:@" "];
        self.contentLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@",line1,line2,line3];
    } else {
        self.contentLabel.text = [arr componentsJoinedByString:@" "];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
