//
//  TTHttpHelper.m
//  AFNetworking
//
//  Created by 打不死的强丿 on 2019/6/9.
//

#import "TTHttpHelper.h"
#import "TTURLProtocol.h"
#import "TTURLRequestKey.h"

@interface TTHttpHelper ()

@property (nonatomic,strong) NSMutableArray *requestArr;
@property (nonatomic,strong) NSMutableArray *requestIds;

@end

@implementation TTHttpHelper

+ (instancetype)helper {
    static TTHttpHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
        instance.requestArr = [NSMutableArray array];
        instance.requestIds = [NSMutableArray array];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [TTHttpHelper helper];
}

- (void)start
{
    [NSURLProtocol registerClass:[TTURLProtocol class]];
}

- (void)addHttpRequset:(NSDictionary *)model {
    @synchronized(self.requestArr) {
        [self.requestArr insertObject:model atIndex:0];
    }
    @synchronized(self.requestIds) {
        if (model[TTURLRequestRequestIdKey] && [model[TTURLRequestRequestIdKey] length] > 0) {
            [self.requestIds addObject:model[TTURLRequestRequestIdKey]];
        }
    }
}

- (void)clear {
    @synchronized(self.requestArr) {
        [self.requestArr removeAllObjects];
    }
}

@end
