//
//  TTHttpHelper.h
//  AFNetworking
//
//  Created by 打不死的强丿 on 2019/6/9.
//

#import <Foundation/Foundation.h>

extern NSString * const TTURLRequestRequestIdKey;
extern NSString * const TTURLRequestUrlKey;
extern NSString * const TTURLRequestMethodKey;
extern NSString * const TTURLRequestMineTypeKey;
extern NSString * const TTURLRequestHeaderKey;
extern NSString * const TTURLRequestStatusCodeKey;
extern NSString * const TTURLRequestRequestBodyKey;
extern NSString * const TTURLRequestResponseDataKey;
extern NSString * const TTURLRequestIsImageKey;
extern NSString * const TTURLRequestImageDataKey;

@interface TTHttpHelper : NSObject


+ (instancetype)helper;

/**
 启动请求收集
 */
- (void)start;

/**
 拦截的请求
 */
@property (nonatomic,strong,readonly) NSMutableArray *requestArr;
@property (nonatomic,strong,readonly) NSMutableArray *requestIds;

/**
 *  记录http请求
 *
 *  @param model http
 */
- (void)addHttpRequset:(NSDictionary *)model;

/**
 拦截请求回调
 */
@property (nonatomic,copy) void(^requestHookHandler)(void);

/**
 *  清空
 */
- (void)clear;

- (NSString *)jsonStrFromData:(NSData *)data;

@end
