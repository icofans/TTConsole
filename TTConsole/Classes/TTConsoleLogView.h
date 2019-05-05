//
//  TTConsoleLogView.h
//  Pods-TTConsole_Example
//
//  Created by 王家强 on 2019/4/30.
//

#import <UIKit/UIKit.h>

@interface TTConsoleLogView : UIView


/**
 关闭点击
 */
@property (nonatomic, strong) void(^closeClick)(void);

/**
 清空点击
 */
@property (nonatomic, strong) void(^clearClick)(void);

/**
 更新所有日志
 
 @param str 日志
 */
- (void)updateAllLog:(NSAttributedString *)str;

/**
 更新新增日志
 
 @param str 新日志
 */
- (void)updateLog:(NSAttributedString *)str;

@end
