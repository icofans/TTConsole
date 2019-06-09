//
//  NSURLRequest+DataExt.m
//  TTConsole-Resource
//
//  Created by 打不死的强丿 on 2019/6/8.
//

#import "NSURLRequest+DataExt.h"
#import <objc/runtime.h>

@implementation NSURLRequest (DataExt)

- (NSString *)requestId {
    return objc_getAssociatedObject(self, @"requestId");
}

- (void)setRequestId:(NSString *)requestId {
    objc_setAssociatedObject(self, @"requestId", requestId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end


@implementation NSURLResponse (DataExt)
- (NSData *)responseData {
    return objc_getAssociatedObject(self, @"responseData");
}

- (void)setResponseData:(NSData *)responseData {
    objc_setAssociatedObject(self, @"responseData", responseData, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end


@implementation NSURLSessionTask (DataExt)

- (NSString*)taskDataIdentify {
    return objc_getAssociatedObject(self, @"taskDataIdentify");
}
- (void)setTaskDataIdentify:(NSString*)name {
    objc_setAssociatedObject(self, @"taskDataIdentify", name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSMutableData*)responseDatas {
    return objc_getAssociatedObject(self, @"responseDatas");
}

- (void)setResponseDatas:(NSMutableData*)data {
    objc_setAssociatedObject(self, @"responseDatas", data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

