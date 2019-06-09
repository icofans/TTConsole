//
//  TTURLProtocol.m
//  TTConsole-Resource
//
//  Created by 打不死的强丿 on 2019/6/8.
//

#import "TTURLProtocol.h"
#import "TTURLRequestKey.h"
#import "TTHttpHelper.h"

NSString * const TTURLRequestRequestIdKey       = @"requestId";
NSString * const TTURLRequestUrlKey             = @"url";
NSString * const TTURLRequestMethodKey          = @"method";
NSString * const TTURLRequestMineTypeKey        = @"mineType";
NSString * const TTURLRequestStatusCodeKey      = @"statusCode";
NSString * const TTURLRequestHeaderKey          = @"header";
NSString * const TTURLRequestRequestBodyKey     = @"requestBody";
NSString * const TTURLRequestResponseDataKey    = @"responseData";
NSString * const TTURLRequestIsImageKey         = @"isImage";
NSString * const TTURLRequestImageDataKey       = @"imageData";


#define TTURLProtocolKey   @"TTURLProtocol"

@interface TTURLProtocol ()<NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, assign) NSTimeInterval  startTime;
@end

@implementation TTURLProtocol

#pragma mark - protocol
+ (void)load {
    
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if (![request.URL.scheme isEqualToString:@"http"] &&
        ![request.URL.scheme isEqualToString:@"https"]) {
        return NO;
    }
    
    if ([NSURLProtocol propertyForKey:TTURLProtocolKey inRequest:request] ) {
        return NO;
    }
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:TTURLProtocolKey inRequest:mutableReqeust];
    return [mutableReqeust copy];
}

- (void)startLoading {
    self.data = [NSMutableData data];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.connection = [[NSURLConnection alloc] initWithRequest:[[self class] canonicalRequestForRequest:self.request] delegate:self startImmediately:YES];
#pragma clang diagnostic pop
    self.startTime = [[NSDate date] timeIntervalSince1970];
}

- (void)stopLoading {
    [self.connection cancel];
    
    NSMutableDictionary *model = [NSMutableDictionary dictionary];
    model[TTURLRequestUrlKey] = self.request.URL;
    model[TTURLRequestMethodKey] = self.request.HTTPMethod;
    model[TTURLRequestMineTypeKey] = self.response.MIMEType;
    if (self.request.HTTPBody) {
        NSData *data = self.request.HTTPBody;
        model[TTURLRequestRequestBodyKey] = [[TTHttpHelper helper] jsonStrFromData:data];
    }
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)self.response;
    if ([self.response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:httpResponse.allHeaderFields options:NSJSONWritingPrettyPrinted error:nil];
        NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        model[TTURLRequestHeaderKey] = str;
    }
    BOOL isImage = [self.response.MIMEType rangeOfString:@"image"].location != NSNotFound;
    model[TTURLRequestStatusCodeKey] = [@(httpResponse.statusCode) stringValue];
    model[TTURLRequestResponseDataKey] = isImage?nil:[[TTHttpHelper helper] jsonStrFromData:self.data];
    model[TTURLRequestImageDataKey] = isImage?self.data:nil;
    model[TTURLRequestIsImageKey] = @(isImage);
    [[TTHttpHelper helper] addHttpRequset:model];
    if ([TTHttpHelper helper].requestHookHandler) {
        [TTHttpHelper helper].requestHookHandler();
    }
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[self client] URLProtocol:self didFailWithError:error];
    self.error = error;
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
    return YES;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [[self client] URLProtocol:self didReceiveAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [[self client] URLProtocol:self didCancelAuthenticationChallenge:challenge];
}
#pragma clang diagnostic pop

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    self.response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [[self client] URLProtocol:self didLoadData:data];
    [self.data appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return cachedResponse;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[self client] URLProtocolDidFinishLoading:self];
}

@end
