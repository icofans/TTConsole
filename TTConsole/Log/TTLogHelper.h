//
//  TTLogHelper.h
//  AFNetworking
//
//  Created by 打不死的强丿 on 2019/6/9.
//

#import <Foundation/Foundation.h>

@interface TTLogHelper : NSObject


+ (instancetype)helper;

/**
 启动日志收集
 */
- (void)start;

/**
 日志
 */
@property (nonatomic, strong, readonly) NSMutableAttributedString *logStr;

/**
 更新日志
 */
@property (nonatomic,copy) void(^updateLogStr)(NSMutableAttributedString *logStr);

@end
