//
//  HTTPClient.h
//  IM
//
//  Created by zuo guoqing on 14-9-12.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HTTPClient : NSObject{
    NSOperationQueue  *sharedQueue;
}

+ (HTTPClient *)sharedClient;

-(AFHTTPRequestOperation*)getOperationByUrl:(NSString*)url;

+(void)asynchronousGetRequest:(NSString*)url method:(NSString*)method parameters:(NSDictionary*)parameters successBlock:(void (^)(BOOL success,id data,NSString* msg))successBlock failureBlock:(void (^)(NSString* description))failureBlock;

+(void)asynchronousGetRequest:(NSString *)url successBlock:(void (^)(BOOL, id, NSString *))successBlock failureBlock:(void (^)(NSString *))failureBlock progressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progressBlock;

+(void)asynchronousPostRequest:(NSString*)url method:(NSString*)method parameters:(NSDictionary*)parameters successBlock:(void (^)(BOOL success,id data,NSString* msg))successBlock failureBlock:(void (^)(NSString* description))failureBlock;

+(void)asynchronousPostRequest:(NSString*)url method:(NSString*)method parameters:(NSArray *)parameters singleSuccessBlock:(void (^)(NSString* url,BOOL success,id data, NSString* msg))successBlock singleFailureBlock:(void (^)(NSString* description))failureBlock allCompletionBlock:(void (^)(NSArray *operations))allCompletionBlock;

@end
