//
//  ConfigManager.h
//  ZGQChat
//
//  Created by zuo guoqing on 14-7-24.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigManager : NSObject
{
    NSUserDefaults *userDefault;
}

@property(nonatomic,strong) NSString *myUserId;
@property(nonatomic,strong) NSDictionary* userDictionary;
@property(nonatomic,strong) NSDictionary* loginDictionary;
@property(nonatomic) BOOL isLogin;

+(ConfigManager *)sharedInstance;
-(void) clearALLConfig;

@property (nonatomic, copy) NSString *createGroupId;


@end
