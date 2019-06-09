//
//  NSURLRequest+DataExt.h
//  TTConsole-Resource
//
//  Created by 打不死的强丿 on 2019/6/8.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (DataExt)

- (NSString *)requestId;
- (void)setRequestId:(NSString *)requestId;

@end


@interface NSURLResponse (DataExt)

- (NSData *)responseData;
- (void)setResponseData:(NSData *)responseData;

@end


@interface NSURLSessionTask (DataExt)


- (NSString*)taskDataIdentify;
- (void)setTaskDataIdentify:(NSString*)name;

- (NSMutableData*)responseDatas;
- (void)setResponseDatas:(NSMutableData*)data;

@end
