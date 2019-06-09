//
//  TTCrashHelper.h
//  AFNetworking
//
//  Created by 打不死的强丿 on 2019/6/9.
//

#import <Foundation/Foundation.h>

extern NSString * const TTCrashInfoKey;
extern NSString * const TTCrashNameKey;
extern NSString * const TTCrashDateKey;
extern NSString * const TTCrashReasonKey;
extern NSString * const TTCrashUserInfoKey;
extern NSString * const TTCrashCallStackKey;

@interface TTCrashHelper : NSObject

+ (instancetype)helper;

- (void)start;

- (NSArray *)crashLogs;

@end
