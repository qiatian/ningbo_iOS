//
//  ConfigManager.m
//  ZGQChat
//
//  Created by zuo guoqing on 14-7-24.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "ConfigManager.h"

@implementation ConfigManager
@synthesize myUserId =_myUserId;
@synthesize userDictionary =_userDictionary;
@synthesize loginDictionary=_loginDictionary;
@synthesize isLogin=_isLogin;

+(ConfigManager *)sharedInstance{
    static dispatch_once_t onceToken;
    static ConfigManager *sSharedInstance;
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[ConfigManager alloc] init];
    });
    return sSharedInstance;
}
#pragma mark 初始化方法
-(id)init{
    self=[super init];
    if(self){
        [self setup];
        [self createTmpDirectory];
    }
    return self;
}


-(void)createTmpDirectory{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *avatarPath = [NSString stringWithFormat:@"%@/%@",APPCachesDirectory,@"tmp/avatar/"];
    if (![fileManager fileExistsAtPath:avatarPath])
    {
        [fileManager createDirectoryAtPath:avatarPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@",APPCachesDirectory,@"tmp/chatimage/"];
    if (![fileManager fileExistsAtPath:imagePath])
    {
        [fileManager createDirectoryAtPath:imagePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    NSString *moviePath =[NSString stringWithFormat:@"%@/%@",APPCachesDirectory,@"tmp/chatmovie/"];
    if (![fileManager fileExistsAtPath:moviePath])
    {
        [fileManager createDirectoryAtPath:moviePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    NSString *downloadPath =[NSString stringWithFormat:@"%@/%@",APPCachesDirectory,@"tmp/download/"];
    if (![fileManager fileExistsAtPath:downloadPath])
    {
        [fileManager createDirectoryAtPath:downloadPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }

}

#pragma mark 创建app配置文件
-(void) setup{
    userDefault=[NSUserDefaults standardUserDefaults];
}

-(void) clearALLConfig{
    [[userDefault dictionaryRepresentation] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if([key hasPrefix:@"IM."]){
            [userDefault removeObjectForKey:key];
            
        }
    }];
    [userDefault synchronize];
    [NSUserDefaults resetStandardUserDefaults];
    userDefault=[NSUserDefaults standardUserDefaults];
}

#pragma mark property overwrite
-(void) setMyUserId:(NSString *)myUserId{
    _myUserId=myUserId;
    [userDefault setObject:myUserId forKey:@"IM.myuserid"];
    [userDefault synchronize];
}

-(NSString*) myUserId{
    _myUserId=[userDefault stringForKey:@"IM.myuserid"];
    return _myUserId;
}

-(void) setLoginDictionary:(NSDictionary *)loginDictionary{
    _loginDictionary =[NSDictionary dictionaryWithDictionary:loginDictionary];
    [userDefault setObject:loginDictionary forKey:@"Login.loginDictionary"];
    [userDefault synchronize];
}

-(NSDictionary*)loginDictionary{
    _loginDictionary =[userDefault dictionaryForKey:@"Login.loginDictionary"];
    return _loginDictionary;
}


-(void)setIsLogin:(BOOL)isLogin{
    _isLogin =isLogin;
    [userDefault setBool:isLogin forKey:@"Login.isLogin"];
    [userDefault synchronize];
}

-(BOOL)isLogin{
    _isLogin=[userDefault boolForKey:@"Login.isLogin"];
    return _isLogin;
}


-(void) setUserDictionary:(NSDictionary *)userDictionary{
    _userDictionary =[NSDictionary dictionaryWithDictionary:userDictionary];
    [userDefault setObject:userDictionary forKey:@"IM.userDictionary"];
    [userDefault synchronize];
}

-(NSDictionary*)userDictionary{
    _userDictionary =[userDefault dictionaryForKey:@"IM.userDictionary"];
    return _userDictionary;
}




@end
