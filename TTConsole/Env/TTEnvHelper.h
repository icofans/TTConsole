//
//  TTEnvHelper.h
//  AFNetworking
//
//  Created by 打不死的强丿 on 2019/6/9.
//

#import <Foundation/Foundation.h>

// env key
extern NSString * const TTEnvironmentKey;

@interface TTEnvHelper : NSObject

+ (instancetype)helper;

/**
 当前环境，默认重启后生效
 */
@property (nonatomic, assign, readonly) NSUInteger currentEnvironment;


/**
 环境切换回调 [如果切换需要重启请直接在启动时读取currentEnvironment，此属性只用于立即切换不重启的情况]
 */
@property (nonatomic,copy) void(^environmentChanged)(NSUInteger env);

@end
