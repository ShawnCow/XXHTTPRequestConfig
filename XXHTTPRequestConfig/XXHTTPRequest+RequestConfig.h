//
//  XXHTTPRequest+RequestConfig.h
//  XXHTTPSerializer
//
//  Created by Shawn on 2019/3/12.
//  Copyright © 2019 Shawn. All rights reserved.
//

#import <XXHTTPRequest.h>

@interface XXHTTPRequest (RequestConfig)

+ (instancetype)defaultRequestConfig;

+ (instancetype)defaultGETHTTPRequest;

+ (instancetype)defaultPOSTHTTPRequest;

@end
