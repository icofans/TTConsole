//
//  TTEnvHelper.m
//  AFNetworking
//
//  Created by 打不死的强丿 on 2019/6/9.
//

#import "TTEnvHelper.h"


NSString * const TTEnvironmentKey = @"AppEnvironment";

@implementation TTEnvHelper

+ (instancetype)helper
{
    static TTEnvHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TTEnvHelper alloc] init];
    });
    return instance;
}

- (NSUInteger)currentEnvironment
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:TTEnvironmentKey];
}

@end
