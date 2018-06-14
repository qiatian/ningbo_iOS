//
//  EnterpriseManager.m
//  IM
//
//  Created by 周永 on 16/1/23.
//  Copyright © 2016年 zuo guoqing. All rights reserved.
//

#import "EnterpriseManager.h"

@implementation EnterpriseManager
static dispatch_once_t onceToken;
static EnterpriseManager *sSharedInstance;

+(EnterpriseManager *)sharedInstance{
    
    dispatch_once(&onceToken, ^{
        
        sSharedInstance = [[EnterpriseManager alloc] init];
        
    });
    
    return sSharedInstance;
    
}

#pragma mark------加载组通讯录
-(void)loadGroupContacts{
    
    NSString *myToken =[[ConfigManager sharedInstance].userDictionary  objectForKey:@"token"];
    if (!myToken) {
        return;
    }
    [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodFindGroup] parameters:[NSDictionary dictionaryWithObject:myToken forKey:@"token"] successBlock:^(BOOL success, id data, NSString *msg) {
        if ([data[@"res"][@"reCode"] intValue] == -5) {//Token过期返回登陆界面
            AppDelegate *delegate =  (AppDelegate*)[UIApplication sharedApplication].delegate;
            [delegate gotoLoginController];
            return ;
        }
        NSArray *gitems =[data objectForKey:@"item"];
        NSMutableArray *groups =[[NSMutableArray alloc] init];
        NSMutableArray *groupUsers =[[NSMutableArray alloc] init];
        
        HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
        [outputFormat setToneType:ToneTypeWithoutTone];
        [outputFormat setVCharType:VCharTypeWithV];
        [outputFormat setCaseType:CaseTypeLowercase];
        
        for (NSDictionary *gitem in gitems) {
            MGroup *mg =[[MGroup alloc] init];
            mg.createTime =[gitem objectForKey:@"createTime"];
            mg.groupName =[gitem objectForKey:@"groupName"];
            mg.groupid =[gitem objectForKey:@"groupid"];
            mg.len =[gitem objectForKey:@"len"];
            mg.name =[gitem objectForKey:@"name"];
            mg.uid =[gitem objectForKey:@"uid"];
            mg.ver =[gitem objectForKey:@"ver"];
            mg.maxLen =[gitem objectForKey:@"maxLen"];
            mg.isTemp =[gitem objectForKey:@"isTemp"];
            
            NSMutableArray *users =[[NSMutableArray alloc] init];
            NSArray *userlist =[gitem objectForKey:@"userlist"];
            for (NSDictionary *guitem in userlist) {
                MGroupUser *user =[[MGroupUser alloc] init];
                user.autograph =[guitem objectForKey:@"autograph"];
                user.cid =[guitem objectForKey:@"cid"];
                user.cname =[guitem objectForKey:@"cname"];
                user.email =[guitem objectForKey:@"email"];
                user.fax =[guitem objectForKey:@"fax"];
                user.gid =[guitem objectForKey:@"gid"];
                user.groupVer =[guitem objectForKey:@"groupVer"];
                user.groupids =[guitem objectForKey:@"groupids"];
                user.jid =[guitem objectForKey:@"jid"];
                user.mobile =[guitem objectForKey:@"mob"];
                
                user.minipicurl =[guitem objectForKey:@"minipicurl"];
                user.bigpicurl =[guitem objectForKey:@"bigpicurl"];
                user.extNumber =[guitem objectForKey:@"extNumber"];
                
                user.uname =[guitem objectForKey:@"name"];
                user.post =[guitem objectForKey:@"post"];
                user.pwd =[guitem objectForKey:@"pwd"];
                user.remark =[guitem objectForKey:@"remark"];
                user.telephone =[guitem objectForKey:@"telephone"];
                user.uid =[guitem objectForKey:@"uid"];
                user.viopId =[guitem objectForKey:@"viopId"];
                user.viopPwd =[guitem objectForKey:@"viopPwd"];
                user.viopSid =[guitem objectForKey:@"viopSid"];
                user.viopSidPwd =[guitem objectForKey:@"viopSidPwd"];
                user.pinyin=[PinyinHelper toHanyuPinyinStringWithNSString:user.uname withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
                user.groupid =[gitem objectForKey:@"groupid"];
                [users addObject:user];
                if ([user.uid longLongValue]>0) {
                    [groupUsers addObject:user];
                }
                
            }
            mg.users =[NSArray arrayWithArray:users];
            [groups addObject:mg];
            
        }
        [[SQLiteManager sharedInstance] deleteGroup];
        [[SQLiteManager sharedInstance] deleteGroupUsers];

        [[SQLiteManager sharedInstance] insertGroupsToSQLite:groups];
        [[SQLiteManager sharedInstance] insertGroupUsersToSQLite:groupUsers notificationName:NOTIFICATION_R_SQL_GROUPUSER];
        
    } failureBlock:^(NSString *description) {
        NSLog(@"url=%@,error=%@",[HTTPAddress MethodFindGroup],description);
    }];
}
#pragma mark------加载企业通讯录
-(void)loadEnterpriseContacts:(void (^)(void))allCompletionBlock{
    
    NSString *myToken =[[ConfigManager sharedInstance].userDictionary  objectForKey:@"token"];
    NSString *myGid =[[ConfigManager sharedInstance].userDictionary  objectForKey:@"gid"];
    
    if (!myToken || !myGid) {
        return;
    }
    
    [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodEnterpriseContact] parameters:[NSDictionary dictionaryWithObject:myToken forKey:@"token"] successBlock:^(BOOL success, id data, NSString *msg) {
        if (success && data) {
            MEnterpriseCompany *company =[[MEnterpriseCompany alloc] init];
            NSDictionary *firm =[data objectForKey:@"firm"];
            company.gid =[firm objectForKey:@"gid"];
            company.gname =[firm objectForKey:@"name"];
            
            NSArray *composition =[firm objectForKey:@"composition"];
            NSMutableArray *nodeDepts =[[NSMutableArray alloc] init];
            NSMutableArray *rootCIds =[[NSMutableArray alloc] init];
            for (NSDictionary *node in composition) {
                MEnterpriseDept *nodeDept=[[MEnterpriseDept alloc] init];
                nodeDept.cid =[NSString stringWithFormat:@"%d",[[node objectForKey:@"cid"] intValue]];
                nodeDept.gid =[NSString stringWithFormat:@"%d",[[node objectForKey:@"gid"] intValue]];
                nodeDept.isroot =[NSString stringWithFormat:@"%d",[[node objectForKey:@"isroot"] intValue]];;
                nodeDept.cname =[node objectForKey:@"name"];
                nodeDept.pid =[NSString stringWithFormat:@"%d",[[node objectForKey:@"pid"] intValue]];
                [nodeDepts addObject:nodeDept];
                if ([nodeDept.pid intValue]==0) {
                    [rootCIds addObject:nodeDept.cid];
                }
            }
            company.rootCIds =[NSMutableArray arrayWithArray:rootCIds];
            [[SQLiteManager sharedInstance] insertDeptsToSQLite:nodeDepts];
            [[SQLiteManager sharedInstance] insertCompanysToSQLite:[NSArray arrayWithObject:company]];
        }
    } failureBlock:^(NSString *description) {
        NSLog(@"url=%@,error=%@",[HTTPAddress MethodEnterpriseContact],description);
    }];

    NSMutableDictionary *firstParameter =[[NSMutableDictionary alloc] init];
    [firstParameter setObject:myToken forKey:@"token"];
    [firstParameter setObject:myGid forKey:@"gid"];
    [firstParameter setObject:[NSNumber numberWithInt:1] forKey:@"page"];
    [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodFindUserByGid] parameters:firstParameter successBlock:^(BOOL success, id data, NSString *msg) {
        int maxcount = [[data objectForKey:@"maxcount"] intValue];
        [self handleEnterpriseContactWithData:data];
        
        NSMutableArray *parameters =[[NSMutableArray alloc] init];
        NSMutableArray *urls =[[NSMutableArray alloc] init];
        for (int i=0; i<maxcount/20; i++) {
            NSMutableDictionary *parameter =[[NSMutableDictionary alloc] init];
            [parameter setObject:myToken forKey:@"token"];
            [parameter setObject:myGid forKey:@"gid"];
            [parameter setObject:[NSNumber numberWithInt:i+2] forKey:@"page"];
            
            [urls addObject:[HTTPAddress MethodFindUserByGid]];
            [parameters addObject:parameter];
        }
        
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodFindUserByGid] parameters:parameters singleSuccessBlock:^(NSString *url, BOOL success, id data, NSString *msg) {
            [self handleEnterpriseContactWithData:data];
        } singleFailureBlock:^(NSString *description) {
            NSLog(@"error=%@",description);
        } allCompletionBlock:^(NSArray *operations) {
            if (allCompletionBlock) {
                allCompletionBlock();
            }
        }];
        
    } failureBlock:^(NSString *description) {
        NSLog(@"url=%@,error=%@",[HTTPAddress MethodFindUserByGid],description);
    }];
}
-(void)handleEnterpriseContactWithData:(NSDictionary *)data{
    
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    
    NSArray *items=[data objectForKey:@"item"];
    NSMutableArray *enterpriseUsers =[[NSMutableArray alloc] init];
    for (NSDictionary *item in items) {
        MEnterpriseUser *user=[[MEnterpriseUser alloc] init];
        user.autograph =[item objectForKey:@"autograph"];
        user.cid =[item objectForKey:@"cid"];
        user.cname =[item objectForKey:@"cname"];
        user.email =[item objectForKey:@"email"];
        user.fax =[item objectForKey:@"fax"];
        user.gid =[item objectForKey:@"gid"];
        user.groupVer =[item objectForKey:@"groupVer"];
        user.groupids =[item objectForKey:@"groupids"];
        user.jid =[item objectForKey:@"jid"];
        user.mobile =[item objectForKey:@"mob"];
        
        user.minipicurl =[item objectForKey:@"minipicurl"];
        user.bigpicurl =[item objectForKey:@"bigpicurl"];
        user.extNumber =[item objectForKey:@"extNumber"];
        
        user.groupManager=[item objectForKey:@"groupManager"];
        
        user.uname =[item objectForKey:@"name"];
        user.post =[item objectForKey:@"post"];
        user.pwd =[item objectForKey:@"pwd"];
        user.remark =[item objectForKey:@"remark"];
        user.telephone =[item objectForKey:@"telephone"];
        user.uid =[item objectForKey:@"uid"];
        user.viopId =[item objectForKey:@"viopId"];
        user.viopPwd =[item objectForKey:@"viopPwd"];
        user.viopSid =[item objectForKey:@"viopSid"];
        user.viopSidPwd =[item objectForKey:@"viopSidPwd"];
        user.pinyin=[PinyinHelper toHanyuPinyinStringWithNSString:user.uname withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
        if([user.uid longLongValue] == [[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"] longLongValue])
        {
            //NSLog(@"不能把自己加入到通讯录里面，，换过账号需要把自己从原来的数据库里面删掉");
            [[SQLiteManager sharedInstance] deleteUserId:[NSString stringWithFormat:@"%@",user.uid]];
        }
        else
        {
            [enterpriseUsers addObject:user];
        }
    }
    [[SQLiteManager sharedInstance] insertUsersToSQLite:enterpriseUsers notificationName:nil];
}

@end
