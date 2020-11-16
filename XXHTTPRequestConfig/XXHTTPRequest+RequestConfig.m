//
//  XXHTTPRequest+RequestConfig.m
//  XXHTTPSerializer
//
//  Created by Shawn on 2019/3/12.
//  Copyright © 2019 Shawn. All rights reserved.
//

#import "XXHTTPRequest+RequestConfig.h"
#import <XXHTTPResponseJSONSerializer.h>
#import <XXAFNetworkRequestAdapter.h>
#import <XXHTTPRequestManager.h>

@implementation XXHTTPRequest (RequestConfig)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self defaultRequestConfig];
        [XXHTTPRequestManager defaultRequestManager].requestAdapter = [XXAFNetworkRequestAdapter new];
    });
}

+ (instancetype)defaultRequestConfig
{
    static dispatch_once_t onceToken;
    static XXHTTPRequest *request ;
    dispatch_once(&onceToken, ^{
        NSString *configPath = [[NSBundle mainBundle]pathForResource:@"network_config" ofType:@"plist"];
        NSDictionary *tempDic = [NSDictionary dictionaryWithContentsOfFile:configPath];
        NSString *baseURL = tempDic[@"XXNetworkBaseURL"];
        NSString *requestSerializerClass = tempDic[@"XXNetworkRequestSerializerClass"];
        if (requestSerializerClass == nil) {
            requestSerializerClass = @"XXHTTPRequestURLEncodingSerializer";
        }
        request = [[XXHTTPRequest alloc] initWithBaseURL:baseURL];
        request.requestSerializer = [NSClassFromString(requestSerializerClass) new];
        NSString *responseSerializerClass = tempDic[@"XXNetworkResponseSerializerClass"];
        if (responseSerializerClass) {
            request.responseSerializer = [NSClassFromString(responseSerializerClass) new];
        }else
        {
            NSString *responseConfigPath = [[NSBundle mainBundle] pathForResource:@"network_response_config" ofType:@"plist"];
            NSDictionary *tempResponseConfigDic = [NSDictionary dictionaryWithContentsOfFile:responseConfigPath];
            NSString *dataKey = tempResponseConfigDic[@"data"];
            if (dataKey == nil) {
                dataKey = @"info";
            }
            NSString *msgKey = tempResponseConfigDic[@"message"];
            if (msgKey == nil) {
                msgKey = @"msg";
            }
            NSString *statusKey = tempResponseConfigDic[@"status"];
            if (statusKey == nil) {
                statusKey = @"status";
            }
            NSString *success = tempResponseConfigDic[@"success"];
            if (success == nil) {
                success = @"1";
            }
            request.responseSerializer = [[XXHTTPResponseJSONSerializer alloc]initWithDataMappingKey:dataKey messageKey:msgKey statusKey:statusKey successStatus:success];
        }
    });
    return request;
}

+ (instancetype)defaultGETHTTPRequest
{
    XXHTTPRequest *request = [[self defaultRequestConfig] mutableCopy];
    request.HTTPMethod = @"GET";
    return request;
}

+ (instancetype)defaultPOSTHTTPRequest
{
    XXHTTPRequest *request = [[self defaultRequestConfig] mutableCopy];
    request.HTTPMethod = @"POST";
    return request;
}

@end
