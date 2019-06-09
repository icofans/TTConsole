//
//  TTCrashHelper.m
//  AFNetworking
//
//  Created by 打不死的强丿 on 2019/6/9.
//

#import "TTCrashHelper.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

const int maxCrashLogNum  = 20;
volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;

NSString * const TTCrashInfoKey = @"info";
NSString * const TTCrashDateKey = @"date";
NSString * const TTCrashNameKey = @"name";
NSString * const TTCrashReasonKey = @"reason";
NSString * const TTCrashUserInfoKey = @"userInfo";
NSString * const TTCrashCallStackKey = @"stack";

@interface TTCrashHelper() {
    NSString*       _crashLogPath;
    NSMutableArray* _plist;
}

@end

@implementation TTCrashHelper

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString* sandBoxPath  = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        _crashLogPath = [sandBoxPath stringByAppendingPathComponent:@"CrashLog"];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:_crashLogPath] == NO)
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:_crashLogPath withIntermediateDirectories:YES attributes:nil error:NULL];
        }
        
        //creat plist
        if (YES == [[NSFileManager defaultManager] fileExistsAtPath:[_crashLogPath stringByAppendingPathComponent:@"crashLog.plist"]])
        {
            _plist = [[NSMutableArray arrayWithContentsOfFile:[_crashLogPath stringByAppendingPathComponent:@"crashLog.plist"]] mutableCopy];
        } else {
            _plist = [NSMutableArray new];
        }
    }
    return self;
}

+ (instancetype)helper
{
    static TTCrashHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TTCrashHelper alloc] init];
    });
    return instance;
}

/**
 开始收集
 */
- (void)start
{
    //注册回调函数
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    signal(SIGABRT, UncaughtSignalHandler);
    signal(SIGILL, UncaughtSignalHandler);
    signal(SIGSEGV, UncaughtSignalHandler);
    signal(SIGFPE, UncaughtSignalHandler);
    signal(SIGBUS, UncaughtSignalHandler);
    signal(SIGPIPE, UncaughtSignalHandler);
}


/**
 获取堆栈信息
 
 @return stack
 */
+ (NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    
    for (i = 0;i < frames;i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    return backtrace;
}


- (NSArray* )crashLogs
{
    NSMutableArray* ret = [NSMutableArray new];
    for (NSString* key in _plist) {
        NSString* filePath = [_crashLogPath stringByAppendingPathComponent:key];
        NSDictionary* log = [NSDictionary dictionaryWithContentsOfFile:filePath];
        if (log) { [ret addObject:log];}
    }
    return [ret copy];
}

- (void)saveException:(NSException*)exception
{
    //add date
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:exception.name forKey:TTCrashNameKey];
    [dict setValue:exception.reason forKey:TTCrashReasonKey];
    [dict setValue:[NSString stringWithFormat:@"%@",exception.userInfo] forKey:TTCrashUserInfoKey];
    [dict setValue:[NSString stringWithFormat:@"%@",exception.callStackSymbols] forKey:TTCrashCallStackKey];
    [self saveToFile:dict];
    
}

- (void)saveSignal:(int)signal
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:_sigName(signal) forKey:TTCrashNameKey];
    [dict setValue:_sigReason(signal) forKey:TTCrashReasonKey];
    NSArray *callStack = [TTCrashHelper backtrace];
    [dict setValue:[NSString stringWithFormat:@"%@",@{@"signal":[NSNumber numberWithInt:signal]}] forKey:TTCrashUserInfoKey];
    [dict setValue:[NSString stringWithFormat:@"%@",callStack] forKey:TTCrashCallStackKey];
    [self saveToFile:dict];
}

- (void)saveToFile:(NSMutableDictionary*)dict
{
    //add date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateString = [formatter stringFromDate:[NSDate date]];
    [dict setObject:dateString forKey:TTCrashDateKey];
    
    // fileName
    NSDate *date = [formatter dateFromString:dateString];
    [formatter setDateFormat:@"yyyyMMddHHmmssS"];
    NSString *fileName = [NSString stringWithFormat:@"%@.plist",[formatter stringFromDate:date]];
    
    //save path
    NSString* savePath = [_crashLogPath stringByAppendingPathComponent:fileName];
    
    //save to disk
    BOOL succeed = [dict writeToFile:savePath atomically:YES];
    if (succeed) {
        NSLog(@"save crash report succeed!");
    } else {
        NSLog(@"crash report failed!");
    }
    
    [_plist insertObject:fileName atIndex:0];
    [_plist writeToFile:[_crashLogPath stringByAppendingPathComponent:@"crashLog.plist"] atomically:YES];
    
    if (_plist.count > maxCrashLogNum)
    {
        [[NSFileManager defaultManager] removeItemAtPath:[_crashLogPath stringByAppendingPathComponent:_plist[0]] error:nil];
        [_plist writeToFile:[_crashLogPath stringByAppendingPathComponent:@"crashLog.plist"] atomically:YES];
    }
}

#pragma mark - register
void UncaughtExceptionHandler(NSException *exception)
{
    [[TTCrashHelper helper] saveException:exception];
    [exception raise];
}

void UncaughtSignalHandler(int sig)
{
    [[TTCrashHelper helper] saveSignal:sig];
    signal(sig, SIG_DFL);
    raise(sig);
}

#pragma mark - sig
NSString *_sigReason(int sig)
{
    switch (sig) {
        case 6:
            return @"abort()";
            break;
        case 4:
            return @"illegal instruction (not reset when caught)";
            break;
        case 11:
            return @"segmentation violation";
            break;
        case 8:
            return @"floating point exception";
            break;
        case 10:
            return @"bus error";
            break;
        case 13:
            return @"write on a pipe with no one to read it";
            break;
            
        default:
            return [NSString stringWithFormat:@"Signal %d was raised.",sig];
            break;
    }
}

NSString *_sigName(int sig)
{
    switch (sig) {
        case 6:
            return @"SIGABRT";
            break;
        case 4:
            return @"SIGILL";
            break;
        case 11:
            return @"SIGSEGV";
            break;
        case 8:
            return @"SIGFPE";
            break;
        case 10:
            return @"SIGBUS";
            break;
        case 13:
            return @"SIGPIPE";
            break;
            
        default:
            return [NSString stringWithFormat:@"SIGNAL %d",sig];
            break;
    }
}

- (void)dealloc
{
    signal( SIGABRT,    SIG_DFL );
    signal( SIGBUS,     SIG_DFL );
    signal( SIGFPE,     SIG_DFL );
    signal( SIGILL,     SIG_DFL );
    signal( SIGPIPE,    SIG_DFL );
    signal( SIGSEGV,    SIG_DFL );
}


@end
