//
//  CircleViewController.m
//  IM
//
//  Created by 陆浩 on 15/4/14.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "CircleViewController.h"

@interface CircleViewController ()

@end

@implementation CircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"工作圈";
    [self getCircleData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark - Request And Parese Data

-(void)getCircleData
{
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
    [parameters setObject:[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"] forKey:@"userId"];
    [parameters setObject:[NSNumber numberWithInt:1] forKey:@"pageNum"];
    [parameters setObject:[NSNumber numberWithInt:10] forKey:@"pageSize"];
    [parameters setObject:[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"] forKey:@"token"];
    
    
    [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodFriendCircle] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
        if(success && [data isKindOfClass:[NSDictionary class]]){

        }else{

        }
    } failureBlock:^(NSString *description) {

    }];
}

@end
