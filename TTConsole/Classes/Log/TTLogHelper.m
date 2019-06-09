//
//  TTLogHelper.m
//  AFNetworking
//
//  Created by 打不死的强丿 on 2019/6/9.
//

#import "TTLogHelper.h"

#import "fishhook.h"

@interface TTLogHelper ()

@property (nonatomic, strong) NSMutableAttributedString *logStr;

@end

@implementation TTLogHelper

static ssize_t (*orig_writev)(int a, const struct iovec * v, int v_len);
ssize_t new_writev(int a, const struct iovec *v, int v_len) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSMutableArray *marr = [NSMutableArray array];
    for (int i = 0; i < v_len; i++) {
        char *c = (char *)v[i].iov_base;
        [marr addObject:[NSString stringWithCString:c encoding:NSUTF8StringEncoding]];
    }
    [marr replaceObjectAtIndex:0 withObject:dateStr];
    ssize_t result = orig_writev(a, v, v_len);
    dispatch_async(dispatch_get_main_queue(), ^{
        // 获取到log信息
        [[TTLogHelper helper] markLog:[marr copy]];
    });
    return result;
}

+ (instancetype)helper {
    static TTLogHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
        instance.logStr = [[NSMutableAttributedString alloc] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [TTLogHelper helper];
}

- (void)start
{
    // hook NSLOG
    rebind_symbols((struct rebinding[1]){{"writev", new_writev, (void *)&orig_writev}}, 1);
}

- (void)markLog:(NSArray *)logArr {
    
    if (logArr.count < 3) {
        return;
    }
    NSString *log_date = logArr[0];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = 5;
    style.headIndent = 4;
    NSAttributedString *dateAttr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",log_date] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:255/255.0 green:184/255.0 blue:108/255.0 alpha:1]}];
    NSAttributedString *logAttr = [[NSAttributedString alloc] initWithString:logArr[1] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc] initWithAttributedString:dateAttr];
    [mAttr appendAttributedString:logAttr];
    [mAttr appendAttributedString:[[NSAttributedString alloc] initWithString:logArr[2]]];
    [mAttr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, mAttr.length)];
    [self.logStr appendAttributedString:[mAttr copy]];
    
    if (self.updateLogStr) {
        self.updateLogStr([mAttr copy]);
    }
}

@end

