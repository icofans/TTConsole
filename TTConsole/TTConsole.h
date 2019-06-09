//
//  TTConsole.h
//  Pods
//
//  Created by 王家强 on 2019/4/30.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, TTEnvironmentType) {
    ENV_INTRANET_TEST           = 0, // 内网测试
    ENV_OUTERNET_TEST           = 1, // 外网测试
    ENV_PRODUCTION_TEST         = 2, // 生产测试
};

@interface TTConsole : NSObject

/**
 instance

 @return instance
 */
+ (instancetype)console;

/**
 是否开启Debug模式
 */
- (void)enableDebugMode;

/**
 当前环境，默认重启后生效
 */
@property (nonatomic, assign, readonly) TTEnvironmentType currentEnvironment;


@end

