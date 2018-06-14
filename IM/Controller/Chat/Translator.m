//
//  Translator.m
//  IM
//
//  Created by 周永 on 16/4/12.
//  Copyright © 2016年 zuo guoqing. All rights reserved.
//

#import "Translator.h"
#import "AppDelegate.h"

#define YouDaoAPI @"http://fanyi.youdao.com/openapi.do?keyfrom=ChinaData&key=1962800513&type=data&doctype=json&version=1.1"

@implementation Translator


+(void)translate:(NSString*)word{
    
    NSString *urlString = [NSString stringWithFormat:@"%@&q=%@",YouDaoAPI,word];
    NSString *url = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
                             
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    NSMutableString *resultString = [NSMutableString string];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id responseDict = operation.responseString.objectFromJSONString;
        if ([responseDict isKindOfClass:[NSDictionary class]]) {
            if ([responseDict[@"errorCode"] intValue] == 0) {
                NSArray *translateResult = responseDict[@"translation"];
                if (translateResult && translateResult.count > 0) {
                    for (NSString *translate in translateResult) {
                        [resultString appendString:translate];
                        [resultString appendString:@"\n"];
                    }
                }else{
                    [resultString appendString:LOCALIZATION(@"translate_noresult")];
                }
            }else{
                [resultString appendString:LOCALIZATION(@"translate_noresult")];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOCALIZATION(@"translate_result") message:resultString delegate:self cancelButtonTitle:LOCALIZATION(@"confirm") otherButtonTitles:nil];
            [alertView show];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate.window makeToast:LOCALIZATION(@"checkout_network") duration:0.5 position:@"center"];
    }];
    
    [op start];
}

@end
