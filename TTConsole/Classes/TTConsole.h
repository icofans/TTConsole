//
//  TTConsole.h
//  Pods
//
//  Created by 王家强 on 2019/4/30.
//

#import <Foundation/Foundation.h>

#define NSLog(xxx, ...); \
{NSLog((@"%s [%d行] " xxx), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}\
{[[TTConsole console] markLog:[NSString stringWithFormat:(@"%s [%d行] " xxx), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]];}

@interface TTConsole : NSObject

+ (instancetype)console;

/**
 记录log
 
 @param log 日志
 */
- (void)markLog:(NSString *)log;

@end

