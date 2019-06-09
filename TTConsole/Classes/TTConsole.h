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

// env key
extern NSString * const TTEnvironmentKey;

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

/**
 环境切换回调 [如果切换需要重启请直接在启动时读取currentEnvironment，此属性只用于立即切换不重启的情况]
 */
@property (nonatomic,copy) void(^environmentChanged)(TTEnvironmentType env);


@end

