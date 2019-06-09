//
//  TTEnvTableViewCell.h
//  fishhook
//
//  Created by 打不死的强丿 on 2019/6/8.
//

#import <UIKit/UIKit.h>

extern NSString * const TTEnvironmentTypeKey;
extern NSString * const TTEnvironmentNameKey;
extern NSString * const TTEnvironmentSelectKey;

@interface TTEnvTableViewCell : UITableViewCell

- (void)setCellInfo:(NSDictionary *)model;

@end
