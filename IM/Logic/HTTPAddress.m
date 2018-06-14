//
//  HTTPAddress.m
//  IM
//
//  Created by zuo guoqing on 14-9-12.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "HTTPAddress.h"

@implementation HTTPAddress


+(NSString*)MethodLogin{
    return @"login2";
}
+(NSString*)MethodRegGetCode
{
    return @"regGetCode";
}
+(NSString*)MethodRegConfirmCode
{
    return @"regConfirmCode";
}
+(NSString*)MethodSearchTenant
{
    return @"searchTenant";
}
#pragma mark-------创建企业
+(NSString*)MethodAddTenant
{
    return @"addTenant";
}
#pragma mark-------申请加入企业
+(NSString*)MethodRegAddTenant
{
    return @"regAddTenant";
}
+(NSString*)MethodRegCancleTenant
{
    return @"regCancleTenant";
}
+(NSString*)MethodGetApplication
{
    return @"getApplication";
}
#pragma mark-----管理员审批用户加入企业
+(NSString*)MethodRegConfirmAddTenant
{
    return @"regConfirmAddTenant";
}
+(NSString*)MethodAddUser
{
    return @"addUser";
}
+(NSString*)MethodAddDept
{
    return @"addDept";
}
+(NSString*)MethodDeleteDept
{
    return @"deleteDept";
}
+(NSString*)MethodUpdateDept
{
    return @"updateDept";
}
+(NSString*)MethodDeleteUser
{
    return @"deleteUser";
}
+(NSString*)MethodModifyUserDept
{
    return @"modifyUserDept";
}
+(NSString*)MethodSetUserPwd
{
    return @"setUserPwd";
}


#pragma mark------task
+(NSString*)MethodTaskAdd
{
    return @"taskAdd";
}
+(NSString*)MethodTaskList
{
    return @"taskList";
}
+(NSString*)MethodTaskQuery
{
    return @"taskQuery";
}
+(NSString*)MethodTaskConfirm
{
    return @"taskConfirm";
}
+(NSString*)MethodTaskUpdateProgress
{
    return @"taskUpdateProgress";
}
+(NSString*)MethodTaskUpdateDelayPurpose
{
    return @"taskUpdateDelayPurpose";
}
+(NSString*)MethodTaskListReply
{
    return @"taskListReply";
}
+(NSString*)MethodTaskAddReply
{
    return @"taskAddReply";
}
+(NSString*)MethodTaskDelete
{
    return @"taskDelete";
}

+(NSString*)MethodEnterpriseContact{
    return @"enterpriseContact";
}
+(NSString*)MethodFindUserByGid{
    return @"findUserByGid";
}

+(NSString*)MethodFindGroup{
    return @"findGroup";
}
+(NSString*)MethodCreateGroup{
    return @"createGroup";
}
+(NSString*)MethodInviteGroup{
    return @"inviteGroup";
}
+(NSString*)MethodRemoveGroupMember{
    return @"removeGroupMember";
}
+(NSString*)MethodModifyGroup{
    return @"modifyGroup";
}
+(NSString*)MethodQuitGroup{
    return @"quitGroup";
}
+(NSString*)MethodRemoveGroup{
    return @"removeGroup";
}

+(NSString*)MethodListAppCate{
    return @"listAppCate";
}
+(NSString*)MethodListApp{
    return @"listApp";
}
+(NSString*)MethodSoftUpdate {
    return @"softwareUpdate";
}

+(NSString*)MethodChatContentQuery{
    return @"chatContentQuery";
}

+(NSString*)MethodChatContentPublish{
    return @"chatContentPublish";
}

#pragma mark ----- 系统设置 -----
+(NSString*)MethodUpdateUser{
    return @"updateUser";
}

+(NSString*)MethodGetInformNum{
    return @"getInformNum";
}

+(NSString*)MethodFriendCircle{
    //获取该用户下得所有的圈子
    return @"findGroupByUserId";
}

+(NSString*)MethodSaveFeedback{
    return @"saveFeedback";
}

+(NSString*)MethodChangePwd{
    return @"modifyPwd";
}

#pragma mark ----- 会议通知 -----
+(NSString*)MethodCreateInform{
    return @"createInform";
}

+(NSString*)MethodGetInform{
    return @"getInform";
}

+(NSString*)MethodAcceptInform{
    return @"acceptInform";
}

+(NSString*)MethodCancelInform{
    return @"cancelInform";
}

+(NSString*)MethodRefuseInform{
    return @"refuseInform";
}

+(NSString*)MethodRemindInform{
    //一键提醒
    return @"remindInform";
}

+(NSString*)MethodGetSalary{
    
    return @"getSalary";
}
//获取小黑板列表
+(NSString*)MethodGetBoard{
    return @"getBoard";
    
}
//获取公告类型
+(NSString*)MethodGetBoardType{
    
    return @"getBoardType";
    
}

+(NSString*)MethodCreateBoardType{
    
    return @"createBoardType";
    
}

+(NSString*)MethodDeleteBoardType{
    
    return @"deleteBoardType";
    
}
//创建小黑板
+(NSString*)MethodCreateBoard{
    
    return @"createBoard";
    
    
}

+(NSString*)MethodGetBoardByBoardId{
    
    return @"getBoardByBoardId";
    
}
+(NSString*)MethodModifyPassword{
    
    return @"modifyPwd";
}

@end
