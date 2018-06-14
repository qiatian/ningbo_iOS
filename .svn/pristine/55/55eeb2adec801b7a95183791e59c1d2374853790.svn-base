//
//  HTTPClient.m
//  IM
//
//  Created by zuo guoqing on 14-9-12.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "HTTPClient.h"

@implementation HTTPClient


+ (HTTPClient *)sharedClient
{
    static HTTPClient *sSharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sSharedClient = [[HTTPClient alloc] init];
    });
    return sSharedClient;
}

-(id)init{
    self=[super init];
    if(self){
        sharedQueue =[[NSOperationQueue alloc] init];
    }
    return self;
}


-(NSOperationQueue*)sharedQueue{
    return sharedQueue;
}

-(NSArray*)getsharedQueueUrls{
    NSMutableArray *urls =[[NSMutableArray alloc] init];
    for (AFHTTPRequestOperation *op in [sharedQueue operations]) {
        [urls addObject:[op.request.URL absoluteString]];
    }
    return urls;
}

-(AFHTTPRequestOperation*)getOperationByUrl:(NSString*)url{
    for (AFHTTPRequestOperation *op in [sharedQueue operations]) {
        if ([url isEqualToString:[op.request.URL absoluteString]]) {
            return op;
        }
    }
    
    return nil;
}

+(void)asynchronousGetRequest:(NSString *)url successBlock:(void (^)(BOOL, id, NSString *))successBlock failureBlock:(void (^)(NSString *))failureBlock progressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progressBlock{
    NSURLRequest *request =[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *op =[[AFHTTPRequestOperation alloc] initWithRequest:request];
    NSString *fileName =[url lastPathComponent];
    if (fileName && fileName.length>0) {
        NSString *downloadPath =[NSString stringWithFormat:@"%@/tmp/download/%@",APPCachesDirectory,fileName];
        op.outputStream=[NSOutputStream outputStreamToFileAtPath:downloadPath append:YES];
        [op setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            if (progressBlock) {
                progressBlock(bytesRead,totalBytesRead,totalBytesExpectedToRead);
            }
        }];
        
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (successBlock) {
                successBlock(YES,responseObject,downloadPath);
            }
            [operation cancel];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failureBlock) {
                failureBlock(error.localizedDescription);
            }
            [operation cancel];
        }];
        
        if (![[[self sharedClient] getsharedQueueUrls] containsObject:url]) {
            [[[self sharedClient] sharedQueue] addOperation:op];
        }
    }
}

+(void)asynchronousGetRequest:(NSString*)url method:(NSString*)method parameters:(NSDictionary*)parameters successBlock:(void (^)(BOOL success,id data,NSString* msg))successBlock failureBlock:(void (^)(NSString* description))failureBlock{
    
    NSString *urlString = [NSString stringWithFormat:@"%@?method=%@&jsonRequest=%@",url,method,[parameters JSONString]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
    [request setHTTPMethod: @"GET"];
    [request setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        id responseData =[operation.responseString objectFromJSONString];
        if ([responseData isKindOfClass:[NSDictionary class]]) {
            NSDictionary *res =[responseData objectForKey:@"res"];
            if (res){
                if ([res objectForKey:@"reCode"] && [[res objectForKey:@"reCode"]intValue]==1 ) {
                    successBlock(YES,responseData,@"");
                }else if([res objectForKey:@"resCode"] && [[res objectForKey:@"resCode"]intValue]==1 ) {
                    //妈的，后来的朋友圈那边code是用resCode来标记的，草泥马，垃圾代码
                    successBlock(YES,responseData,@"");
                }
                else{
                    if ([res objectForKey:@"resMessage"]) {
                        successBlock(NO,nil,[res objectForKey:@"resMessage"]);
                    }else{
                        successBlock(NO,nil,@"no resMessage");
                    }
                    
                }
            }else{
                successBlock(NO,nil,@"no res");
            }
            
        }
        
        [operation cancel];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [operation cancel];
        failureBlock(error.localizedDescription);
        
    }];
    [operation start];
}

+(void)asynchronousPostRequest:(NSString*)url method:(NSString*)method parameters:(NSDictionary*)parameters successBlock:(void (^)(BOOL success,id data,NSString* msg))successBlock failureBlock:(void (^)(NSString* description))failureBlock{
    
    
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0f];
    [request setHTTPMethod: @"POST"];
    [request setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    request.timeoutInterval = 10.0;
    
    NSMutableData *postBody=[NSMutableData data];
    NSLog(@"%@",[NSString stringWithFormat:@"method=%@&jsonRequest=%@",method,[parameters JSONString]]);
    [postBody appendData:[[NSString stringWithFormat:@"method=%@&jsonRequest=%@",method,[[parameters JSONString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@",postBody);
    [request setHTTPBody:postBody];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        id responseData =[operation.responseString objectFromJSONString];
        if ([responseData isKindOfClass:[NSDictionary class]]) {
            NSDictionary *res =[responseData objectForKey:@"res"];
            if (res){
                if ([res objectForKey:@"reCode"] && [[res objectForKey:@"reCode"]intValue]==1 ) {
                    successBlock(YES,responseData,@"");
                }else if([res objectForKey:@"resCode"] && [[res objectForKey:@"resCode"]intValue]==1 ) {
                    //妈的，后来的朋友圈那边code是用resCode来标记的，草泥马，垃圾代码
                    successBlock(YES,responseData,@"");
                }
                else if ([res objectForKey:@"reCode"] && [[res objectForKey:@"reCode"]intValue]==-6)
                {
                    successBlock(NO,responseData,[res objectForKey:@"resMessage"]);
                }
                else{
                    if ([res objectForKey:@"resMessage"]) {
                        successBlock(NO,nil,[res objectForKey:@"resMessage"]);
                    }else{
                        successBlock(NO,nil,@"no resMessage");
                    }
                    
                }
            }else{
                successBlock(NO,nil,@"no res");
            }
            
        }
        
        [operation cancel];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [operation cancel];
        failureBlock(error.localizedDescription);
        
    }];
    [operation start];
}


+(void)asynchronousPostRequest:(NSString*)url method:(NSString*)method parameters:(NSArray *)parameters singleSuccessBlock:(void (^)(NSString* url,BOOL success,id data, NSString* msg))successBlock singleFailureBlock:(void (^)(NSString* description))failureBlock allCompletionBlock:(void (^)(NSArray *operations))allCompletionBlock{
    NSMutableArray *mutableOperations = [[NSMutableArray alloc] init];
    
    
    for (int i=0;i<parameters.count;i++) {
        NSDictionary *parameter=[parameters objectAtIndex:i];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
        [request setHTTPMethod: @"POST"];
        [request setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        NSMutableData *postBody=[NSMutableData data];
        [postBody appendData:[[NSString stringWithFormat:@"method=%@&jsonRequest=%@",method,[parameter JSONString]] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:postBody];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.userInfo =[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@?method=%@&jsonRequest=%@",ApiPrefix,method,[parameter JSONString]] forKey:@"url"];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            id responseData =[operation.responseString objectFromJSONString];
            if ([responseData isKindOfClass:[NSDictionary class]]) {
                NSDictionary *res =[responseData objectForKey:@"res"];
                if (res){
                    if ([res objectForKey:@"reCode"] && [[res objectForKey:@"reCode"]intValue]==1 ) {
                        successBlock([operation.userInfo objectForKey:@"url"],YES,responseData,@"");
                    }else{
                        if ([res objectForKey:@"resMessage"]) {
                            successBlock([operation.userInfo objectForKey:@"url"],NO,nil,[res objectForKey:@"resMessage"]);
                        }else{
                            successBlock([operation.userInfo objectForKey:@"url"],NO,nil,@"no resMessage");
                        }
                        
                    }
                }else{
                    successBlock([operation.userInfo objectForKey:@"url"],NO,nil,@"no res");
                }
                
            }
            
            [operation cancel];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [operation cancel];
            failureBlock([NSString stringWithFormat:@"error:%@,url:%@" ,error.localizedDescription,[operation.userInfo objectForKey:@"url"]]);
            
        }];
        [mutableOperations addObject:operation];
    }
    
    NSArray *operations = [AFURLConnectionOperation batchOfRequestOperations:mutableOperations progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        
    } completionBlock:^(NSArray *operations) {
        allCompletionBlock(operations);
    }];
    
    [[NSOperationQueue mainQueue] addOperations:operations waitUntilFinished:NO];
    

}

@end
