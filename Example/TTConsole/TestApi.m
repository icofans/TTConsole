//
//  TestApi.m
//  ZXRequestBlockDemo
//
//  Created by 打不死的强丿 on 2019/6/8.
//  Copyright © 2019 李兆祥. All rights reserved.
//

#import "TestApi.h"

@implementation TestApi

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}

- (YTKRequestSerializerType)requestSerializerType
{
    return YTKRequestSerializerTypeHTTP;
}

- (YTKResponseSerializerType)responseSerializerType
{
    return YTKResponseSerializerTypeJSON;
}

- (NSString *)baseUrl
{
    return @"http://api.nnzhp.cn/api/user/stu_info";
}

@end
