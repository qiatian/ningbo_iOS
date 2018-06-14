//
//  SQLiteManager.m
//  ZGQChat
//
//  Created by zuo guoqing on 14-7-22.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "SQLiteManager.h"
#import "ZTENotificationModal.h"

@implementation SQLiteManager
static dispatch_once_t onceToken;
static SQLiteManager *sSharedInstance;
#pragma mark  singleton方法
+(SQLiteManager *)sharedInstance{
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[SQLiteManager alloc] init];
        
    });
    return sSharedInstance;
}
#pragma mark 初始化方法
-(id)init{
    self=[super init];
    if(self){
        _dbQueue=[FMDatabaseQueue databaseQueueWithPath:[APPDocumentsDirectory  stringByAppendingPathComponent:@"zgq_chat.sqlite"]];
        [_dbQueue inDatabase:^(FMDatabase *db) {
            
        }];
        [self createTable];
        
    }
    return self;
}

-(void)reset
{
    onceToken = 0;
    sSharedInstance = nil;
}

#pragma mark 初始化创建表
-(void)createTable{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            if(![db tableExists:@"tbl_company"]){
                [db executeUpdate:CT_SQL_Company];
            }
            if(![db tableExists:@"tbl_dept"]){
                [db executeUpdate:CT_SQL_Dept];
            }
            if(![db tableExists:@"tbl_user"]){
                [db executeUpdate:CT_SQL_User];
            }
            if(![db tableExists:@"tbl_group"]){
                [db executeUpdate:CT_SQL_Group];
            }
            if(![db tableExists:@"tbl_groupuser"]){
                [db executeUpdate:CT_SQL_GroupUser];
            }
            if (![db tableExists:@"tbl_message"]) {
                [db executeUpdate:CT_SQL_Message];
            }
            if (![db tableExists:@"tbl_file"]) {
                [db executeUpdate:CT_SQL_File];
            }
            if (![db tableExists:@"tbl_meeting"]) {
                [db executeUpdate:CT_SQL_MEETING];
            }
            if (![db tableExists:@"tbl_history_meeting"]) {
                [db executeUpdate:CT_SQL_HISTORY_MEETING];
            }
            //小黑板
            if (![db tableExists:@"tbl_board"]) {
                [db executeUpdate:CT_SQL_Board];
            }
            if (![db tableExists:@"tbl_approve"]) {//注册审批
                [db executeUpdate:CT_SQL_Approve];
            }
            if([db hadError]){
                *rollback=YES;
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
        }
    }];
}

-(void)clearTableWithNames:(NSArray *)tableNames{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            for (NSString *tableName in tableNames) {
                [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM `%@`",tableName]];
            }
            
            if([db hadError]){
                *rollback=YES;
            }
            
        }
        @catch (NSException *exception) {
            *rollback=YES;
        }
    }];

}

#pragma mark 退出清空表
-(void) clearTable
{
    
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            FMResultSet *rs = [db getSchema];
            while ([rs next]) {
                NSString *sql=[NSString stringWithFormat:@"DELETE FROM `%@`",[rs stringForColumn:@"name"]];
                [db executeUpdate:sql];
            }
            if([db hadError]){
                *rollback=YES;
            }
            
        }
        @catch (NSException *exception) {
            *rollback=YES;
        }
    }];
}


#pragma mark 根据公司id获取部门列表
-(NSArray*) getAllDeptByGId:(NSString*)gid{
    
    __block NSMutableArray* departmentArr=[[NSMutableArray alloc] init];
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs=[db executeQuery:S_SQL_DeptByGId,gid];
        while ([rs next]) {
            MEnterpriseDept *md=[[MEnterpriseDept alloc] init];
            md.cid=[rs stringForColumn:@"cid"];
            md.cname=[rs stringForColumn:@"cname"];
            md.gid=[rs stringForColumn:@"gid"];
            md.isroot=[rs stringForColumn:@"isroot"];
            md.pid=[rs stringForColumn:@"pid"];
            [departmentArr addObject:md];
        }
        [rs close];
    }];
    return [NSArray arrayWithArray:departmentArr];
}

#pragma mark 获取公司下所有人员
-(NSMutableDictionary*) getAllUserByGid:(NSString*)gid{
    __block NSMutableDictionary* userDict=[[NSMutableDictionary alloc] init];
    
    [_dbQueue inDatabase:^(FMDatabase *db){
        //查询所有用户
        FMResultSet *rs=[db executeQuery:S_SQL_UserByGId,gid];
        while([rs next]) {
            MEnterpriseUser *mu=[[MEnterpriseUser alloc] init];
            mu.uid=[rs stringForColumn:@"uid"];
            mu.uname=[rs stringForColumn:@"uname"];
            mu.cid=[rs stringForColumn:@"cid"];
            mu.telephone=[rs  stringForColumn:@"telephone"];
            mu.cname=[rs stringForColumn:@"cname"];
            mu.autograph=[rs stringForColumn:@"autograph"];
            mu.email=[rs stringForColumn:@"email"];
            mu.fax=[rs stringForColumn:@"fax"];
            mu.gid =[rs stringForColumn:@"gid"];
            mu.gname =[rs stringForColumn:@"gname"];
            mu.groupVer=[rs stringForColumn:@"groupVer"];
            mu.groupids=[[rs stringForColumn:@"groupids"] objectFromJSONString];
            
            mu.minipicurl =[rs stringForColumn:@"minipicurl"];
            mu.bigpicurl =[rs stringForColumn:@"bigpicurl"];
            mu.extNumber =[rs stringForColumn:@"extNumber"];
            mu.groupManager=[rs stringForColumn:@"groupManager"];
            
            mu.jid=[rs stringForColumn:@"jid"];
            mu.mobile =[rs stringForColumn:@"mobile"];
            mu.post =[rs stringForColumn:@"post"];
            mu.pwd =[rs stringForColumn:@"pwd"];
            mu.remark =[rs stringForColumn:@"remark"];
            mu.viopId =[rs stringForColumn:@"viopId"];
            mu.viopPwd =[rs stringForColumn:@"viopPwd"];
            mu.viopSid =[rs stringForColumn:@"viopSid"];
            mu.viopSidPwd =[rs stringForColumn:@"viopSidPwd"];
            mu.viopSidPwd =[rs stringForColumn:@"viopSidPwd"];
            mu.pinyin =[rs stringForColumn:@"pinyin"];
            [userDict setObject:mu forKey:mu.uid];
        }
        [rs close];
    }];
    return userDict;
    
}

#pragma mark 获取所有小黑板列表
-(NSMutableArray*) getAllBoardsFromSQLiteWithTarget:(NSString *)target{
    __block NSMutableArray* boardsArray = [[NSMutableArray alloc] init];
    
    //                (`boardId`, `content`, `createTime`, `creatorUid`, `creatorUserId` , `deptCid` , `deptGroupId`,`deptName`,`gid`,`tenantId`,`title`,`typeId`,`typeName`)
    
    [_dbQueue inDatabase:^(FMDatabase *db){
        //查询所有用户
//        FMResultSet *rs=[db executeQuery:S_SQL_Board,target];
        FMResultSet *rs=[db executeQuery:S_SQL_USE_Board,target];
        
        while([rs next]) {
            ZTENotificationModal *model=[[ZTENotificationModal alloc] init];
            
            model.boardId = [rs stringForColumn:@"boardId"];
            model.content = [rs stringForColumn:@"content"];
            model.createTime = [rs stringForColumn:@"createTime"];
            model.creatorUid = [rs stringForColumn:@"creatorUid"];
            model.creatorUserId = [rs stringForColumn:@"creatorUserId"];
            model.deptCid = [rs stringForColumn:@"deptCid"];
            model.deptGroupId = [rs stringForColumn:@"deptGroupId"];
            model.deptName = [rs stringForColumn:@"deptName"];
            model.gid = [rs stringForColumn:@"deptCid"];
            model.tenantId = [rs stringForColumn:@"tenantId"];
            model.title = [rs stringForColumn:@"title"];
            model.typeId = [rs stringForColumn:@"typeId"];
            model.typeName = [rs stringForColumn:@"typeName"];
            
            //注册审批
            model.name=[rs stringForColumn:@"name"];
            model.mobile=[rs stringForColumn:@"mobile"];
//            model.sessionid=[rs stringForColumn:@"sessionId"];
            //新建任务
            model.creatorAppocUserId=[rs stringForColumn:@"creatorAppocUserId"];
            model.creatorName=[rs stringForColumn:@"creatorName"];
            model.isDelayingMessageSent=[rs stringForColumn:@"isDelayingMessageSent"];
            model.isDeleted=[rs stringForColumn:@"isDeleted"];
            model.isNeedNotify=[rs stringForColumn:@"isNeedNotify"];
            model.plannedFinishTime=[rs stringForColumn:@"plannedFinishTime"];
            model.progress=[rs stringForColumn:@"progress"];
            model.status=[rs stringForColumn:@"status"];
            model.taskId=[rs stringForColumn:@"taskId"];
            model.userCount=[rs stringForColumn:@"userCount"];
  
            //通知类型
            model.contentType = [rs stringForColumn:@"contentType"];
            
            [boardsArray addObject:model];
            
        }
        [rs close];
    }];
    return boardsArray;
    
}
-(ZTENotificationModal*)getTaskModelWithTaskId:(NSString *)taskId
{
    __block ZTENotificationModal *model=[[ZTENotificationModal alloc] init];
    [_dbQueue inDatabase:^(FMDatabase *db){
        //查询所有用户
        //        FMResultSet *rs=[db executeQuery:S_SQL_Board,target];
        FMResultSet *rs=[db executeQuery:S_SQL_Task,taskId];
        
        while([rs next]) {
            
            
            model.boardId = [rs stringForColumn:@"boardId"];
            model.content = [rs stringForColumn:@"content"];
            model.createTime = [rs stringForColumn:@"createTime"];
            model.creatorUid = [rs stringForColumn:@"creatorUid"];
            model.creatorUserId = [rs stringForColumn:@"creatorUserId"];
            model.deptCid = [rs stringForColumn:@"deptCid"];
            model.deptGroupId = [rs stringForColumn:@"deptGroupId"];
            model.deptName = [rs stringForColumn:@"deptName"];
            model.gid = [rs stringForColumn:@"deptCid"];
            model.tenantId = [rs stringForColumn:@"tenantId"];
            model.title = [rs stringForColumn:@"title"];
            model.typeId = [rs stringForColumn:@"typeId"];
            model.typeName = [rs stringForColumn:@"typeName"];
            
            //注册审批
            model.name=[rs stringForColumn:@"name"];
            model.mobile=[rs stringForColumn:@"mobile"];
            //            model.sessionid=[rs stringForColumn:@"sessionId"];
            //新建任务
            model.creatorAppocUserId=[rs stringForColumn:@"creatorAppocUserId"];
            model.creatorName=[rs stringForColumn:@"creatorName"];
            model.isDelayingMessageSent=[rs stringForColumn:@"isDelayingMessageSent"];
            model.isDeleted=[rs stringForColumn:@"isDeleted"];
            model.isNeedNotify=[rs stringForColumn:@"isNeedNotify"];
            model.plannedFinishTime=[rs stringForColumn:@"plannedFinishTime"];
            model.progress=[rs stringForColumn:@"progress"];
            model.status=[rs stringForColumn:@"status"];
            model.taskId=[rs stringForColumn:@"taskId"];
            model.userCount=[rs stringForColumn:@"userCount"];
            
            //通知类型
            model.contentType = [rs stringForColumn:@"contentType"];
            
            
        }
        [rs close];
    }];
    return model;
}
#pragma mark 获取所有申请列表
-(NSMutableArray*) getAllApproveFromSQLite{
    __block NSMutableArray* approveArray = [[NSMutableArray alloc] init];
    
    [_dbQueue inDatabase:^(FMDatabase *db){
        //查询所有用户
        FMResultSet *rs=[db executeQuery:S_SQL_Approve];
        while([rs next]) {
            ZTENotificationModal *model=[[ZTENotificationModal alloc] init];
            
            
            //注册审批
            model.mobile=[rs stringForColumn:@"mobile"];
            model.createTime=[rs stringForColumn:@"createTime"];
            model.name=[rs stringForColumn:@"name"];
            //通知类型
            model.contentType = [rs stringForColumn:@"contentType"];
            
            [approveArray addObject:model];
            
        }
        [rs close];
    }];
    return approveArray;
    
}
#pragma mark 根据voipid获取对应的用户模型
-(MEnterpriseUser*) getUserByVoipId:(NSString*)voipId{
    __block MEnterpriseUser *mu = nil;
    [_dbQueue inDatabase:^(FMDatabase *db){
        FMResultSet *rs=[db executeQuery:S_SQL_UserByVoipId,voipId];
        while([rs next]) {
            mu=[[MEnterpriseUser alloc] init];
            mu.uid=[rs stringForColumn:@"uid"];
            mu.uname=[rs stringForColumn:@"uname"];
            mu.cid=[rs stringForColumn:@"cid"];
            mu.telephone=[rs  stringForColumn:@"telephone"];
            mu.cname=[rs stringForColumn:@"cname"];
            mu.autograph=[rs stringForColumn:@"autograph"];
            mu.email=[rs stringForColumn:@"email"];
            mu.fax=[rs stringForColumn:@"fax"];
            mu.gid =[rs stringForColumn:@"gid"];
            mu.gname =[rs stringForColumn:@"gname"];
            mu.groupVer=[rs stringForColumn:@"groupVer"];
            mu.groupids=[[rs stringForColumn:@"groupids"] objectFromJSONString];
            
            mu.minipicurl =[rs stringForColumn:@"minipicurl"];
            mu.bigpicurl =[rs stringForColumn:@"bigpicurl"];
            mu.extNumber =[rs stringForColumn:@"extNumber"];
            mu.groupManager=[rs stringForColumn:@"groupManager"];
            
            mu.jid=[rs stringForColumn:@"jid"];
            mu.mobile =[rs stringForColumn:@"mobile"];
            mu.post =[rs stringForColumn:@"post"];
            mu.pwd =[rs stringForColumn:@"pwd"];
            mu.remark =[rs stringForColumn:@"remark"];
            mu.viopId =[rs stringForColumn:@"viopId"];
            mu.viopPwd =[rs stringForColumn:@"viopPwd"];
            mu.viopSid =[rs stringForColumn:@"viopSid"];
            mu.viopSidPwd =[rs stringForColumn:@"viopSidPwd"];
            mu.viopSidPwd =[rs stringForColumn:@"viopSidPwd"];
            mu.pinyin =[rs stringForColumn:@"pinyin"];
        }
        [rs close];
    }];
    return mu;
}



#pragma mark 获取公司下所有人员
-(NSMutableDictionary *) getAllGroups{
    __block NSMutableDictionary* groupDict=[[NSMutableDictionary alloc] init];
    
    [_dbQueue inDatabase:^(FMDatabase *db){
        //查询所有用户
        FMResultSet *rs=[db executeQuery:S_SQL_Group];
        while([rs next]) {
            MGroup *mu=[[MGroup alloc] init];
            mu.groupid=[rs stringForColumn:@"groupid"];
            mu.groupName=[rs stringForColumn:@"groupName"];
            mu.createTime=[rs stringForColumn:@"createTime"];
            mu.len=[rs  stringForColumn:@"len"];
            mu.maxLen=[rs stringForColumn:@"maxLen"];
            mu.name=[rs stringForColumn:@"name"];
            mu.uid=[rs stringForColumn:@"uid"];
            mu.isTemp=[rs stringForColumn:@"isTemp"];
            mu.ver =[rs stringForColumn:@"ver"];
            mu.users =[[NSArray alloc] init];
            [groupDict setObject:mu forKey:mu.groupid];
        }
        [rs close];
        
        rs=[db executeQuery:S_SQL_GroupUser];
        while ([rs next]) {
            MGroup *mu=[groupDict objectForKey:[rs stringForColumn:@"groupid"]];
            MGroupUser *user =[[MGroupUser alloc] init];
            user.uid=[rs stringForColumn:@"uid"];
            user.groupid =[rs stringForColumn:@"groupid"];
            user.uname=[rs stringForColumn:@"uname"];
            user.cid=[rs stringForColumn:@"cid"];
            user.telephone=[rs  stringForColumn:@"telephone"];
            user.cname=[rs stringForColumn:@"cname"];
            user.autograph=[rs stringForColumn:@"autograph"];
            user.email=[rs stringForColumn:@"email"];
            user.fax=[rs stringForColumn:@"fax"];
            user.gid =[rs stringForColumn:@"gid"];
            user.gname =[rs stringForColumn:@"gname"];
            user.groupVer=[rs stringForColumn:@"groupVer"];
            user.groupids=[[rs stringForColumn:@"groupids"] objectFromJSONString];
            
            user.minipicurl =[rs stringForColumn:@"minipicurl"];
            user.bigpicurl =[rs stringForColumn:@"bigpicurl"];
            user.extNumber =[rs stringForColumn:@"extNumber"];
            
            user.jid=[rs stringForColumn:@"jid"];
            user.mobile =[rs stringForColumn:@"mobile"];
            user.post =[rs stringForColumn:@"post"];
            user.pwd =[rs stringForColumn:@"pwd"];
            user.remark =[rs stringForColumn:@"remark"];
            user.viopId =[rs stringForColumn:@"viopId"];
            user.viopPwd =[rs stringForColumn:@"viopPwd"];
            user.viopSid =[rs stringForColumn:@"viopSid"];
            user.viopSidPwd =[rs stringForColumn:@"viopSidPwd"];
            user.viopSidPwd =[rs stringForColumn:@"viopSidPwd"];
            user.pinyin =[rs stringForColumn:@"pinyin"];
            
            mu.users=[mu.users arrayByAddingObject:user];
            if ([mu.users count]>0) {
                if ([user.uid isEqualToString:mu.uid]) {
                    NSMutableArray *users =[NSMutableArray arrayWithArray:mu.users];
                    [users exchangeObjectAtIndex:0 withObjectAtIndex:[mu.users indexOfObject:user]];
                    mu.users =[NSMutableArray arrayWithArray:users];
                }
            }
            mu.len =[NSString stringWithFormat:@"%d",mu.users.count];
        }
        [rs close];
        
    }];
    return groupDict;
    
}

//只获取群列表，不需要群成员
-(NSMutableDictionary *) getAllOnlyGroups{
    __block NSMutableDictionary* groupDict=[[NSMutableDictionary alloc] init];

    [_dbQueue inDatabase:^(FMDatabase *db){
        //查询所有用户
        FMResultSet *rs=[db executeQuery:S_SQL_Group];
        while([rs next]) {
            MGroup *mu=[[MGroup alloc] init];
            mu.groupid=[rs stringForColumn:@"groupid"];
            mu.groupName=[rs stringForColumn:@"groupName"];
            mu.createTime=[rs stringForColumn:@"createTime"];
            mu.len=[rs  stringForColumn:@"len"];
            mu.maxLen=[rs stringForColumn:@"maxLen"];
            mu.name=[rs stringForColumn:@"name"];
            mu.uid=[rs stringForColumn:@"uid"];
            mu.isTemp=[rs stringForColumn:@"isTemp"];
            mu.ver =[rs stringForColumn:@"ver"];
            mu.users =[[NSArray alloc] init];
            [groupDict setObject:mu forKey:mu.groupid];
        }
        [rs close];
    }];
    return groupDict;
}


-(void)setUserArrayByGroupModel:(MGroup *)mu
{
    [_dbQueue inDatabase:^(FMDatabase *db){
        FMResultSet *rs=[db executeQuery:S_SQL_OnlyGroupUser,mu.groupid];
        while ([rs next]) {
            MGroupUser *user =[[MGroupUser alloc] init];
            user.uid=[rs stringForColumn:@"uid"];
            user.groupid =[rs stringForColumn:@"groupid"];
            user.uname=[rs stringForColumn:@"uname"];
            user.cid=[rs stringForColumn:@"cid"];
            user.telephone=[rs  stringForColumn:@"telephone"];
            user.cname=[rs stringForColumn:@"cname"];
            user.autograph=[rs stringForColumn:@"autograph"];
            user.email=[rs stringForColumn:@"email"];
            user.fax=[rs stringForColumn:@"fax"];
            user.gid =[rs stringForColumn:@"gid"];
            user.gname =[rs stringForColumn:@"gname"];
            user.groupVer=[rs stringForColumn:@"groupVer"];
            user.groupids=[[rs stringForColumn:@"groupids"] objectFromJSONString];
            
            user.minipicurl =[rs stringForColumn:@"minipicurl"];
            user.bigpicurl =[rs stringForColumn:@"bigpicurl"];
            user.extNumber =[rs stringForColumn:@"extNumber"];
            
            user.jid=[rs stringForColumn:@"jid"];
            user.mobile =[rs stringForColumn:@"mobile"];
            user.post =[rs stringForColumn:@"post"];
            user.pwd =[rs stringForColumn:@"pwd"];
            user.remark =[rs stringForColumn:@"remark"];
            user.viopId =[rs stringForColumn:@"viopId"];
            user.viopPwd =[rs stringForColumn:@"viopPwd"];
            user.viopSid =[rs stringForColumn:@"viopSid"];
            user.viopSidPwd =[rs stringForColumn:@"viopSidPwd"];
            user.viopSidPwd =[rs stringForColumn:@"viopSidPwd"];
            user.pinyin =[rs stringForColumn:@"pinyin"];
            
            mu.users=[mu.users arrayByAddingObject:user];
            if ([mu.users count]>0) {
                if ([user.uid isEqualToString:mu.uid]) {
                    NSMutableArray *users =[NSMutableArray arrayWithArray:mu.users];
                    [users exchangeObjectAtIndex:0 withObjectAtIndex:[mu.users indexOfObject:user]];
                    mu.users =[NSMutableArray arrayWithArray:users];
                }
            }
            mu.len =[NSString stringWithFormat:@"%d",mu.users.count];
        }
        [rs close];
    }];
}

-(void) insertCompanysToSQLite:(NSArray*)companys{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            for (MEnterpriseCompany* mc in companys) {
                [db executeUpdate:R_SQL_Company,mc.gid,mc.gname,[mc.rootCIds JSONString]];
                if([db hadError]){
                    *rollback=YES;
                    @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
                    NSLog(@"error:%@",[db lastErrorMessage]);
                }
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
            NSLog(@"error:%@",[db lastErrorMessage]);
            //@throw exception;
        }
    }];
}

//插入小黑板记录
- (void) insertBoardsToSQLite:(NSArray*)boards{
    
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            for (ZTENotificationModal* modal in boards) {
                [db executeUpdate:R_SQL_Board,modal.boardId,modal.content,modal.createTime,modal.creatorUid,modal.creatorUserId,modal.deptCid,modal.deptGroupId,modal.deptName,modal.gid,modal.tenantId,modal.title,modal.typeId,modal.typeName,modal.mobile,modal.name,modal.contentType,modal.creatorAppocUserId,modal.creatorName,modal.isDelayingMessageSent,modal.isDeleted,modal.isNeedNotify,modal.plannedFinishTime,modal.progress,modal.status,modal.taskId,modal.userCount,modal.userId];
                if([db hadError]){
                    *rollback=YES;
                    @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
                    NSLog(@"error:%@",[db lastErrorMessage]);
                }
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
            NSLog(@"error:%@",[db lastErrorMessage]);
            //@throw exception;
        }
    }];
    
    
}
//更改任务状态
-(void)updateBoardsStatus:(NSString *)status withTaskId:(NSString *)taskId withUid:(NSString*)uid notificationName:(NSString *)notificationName
{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            [db executeUpdate:U_SQL_Board,status,taskId,uid];
            if([db hadError]){
                *rollback=YES;
                @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
                NSLog(@"error:%@",[db lastErrorMessage]);
            }
            
        }
        @catch (NSException *exception) {
            *rollback=YES;
            NSLog(@"error:%@",[db lastErrorMessage]);
            //@throw exception;
        }
        @finally{
            if (notificationName && notificationName.length>0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:status];
                });
            }
        }
    }];
}
//插入申请记录
-(void)insertApproveToSQLite:(NSArray *)approves
{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            for (ZTENotificationModal* modal in approves) {
                [db executeUpdate:R_SQL_Approve,modal.contentType,modal.name,modal.mobile,modal.createTime];
                if([db hadError]){
                    *rollback=YES;
                    @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
                    NSLog(@"error:%@",[db lastErrorMessage]);
                }
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
            NSLog(@"error:%@",[db lastErrorMessage]);
            //@throw exception;
        }
    }];
}
-(void) insertDeptsToSQLite:(NSArray*)depts{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            for (MEnterpriseDept* mc in depts) {
                [db executeUpdate:R_SQL_Dept,mc.cid,mc.cname,mc.gid,mc.isroot,mc.pid];
                if([db hadError]){
                    *rollback=YES;
                    @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
                    NSLog(@"error:%@",[db lastErrorMessage]);
                }
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
            NSLog(@"error:%@",[db lastErrorMessage]);
            //@throw exception;
        }
    }];
}

-(void) insertUsersToSQLite:(NSArray*)users notificationName:(NSString*)notificationName{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            for (MEnterpriseUser*mc in users) {
                [db executeUpdate:R_SQL_User,mc.uid,mc.uname,mc.cid,mc.cname,mc.autograph,mc.email,mc.fax,mc.gid,mc.groupVer,[mc.groupids JSONString],mc.hp,mc.jid,mc.mobile,mc.post,mc.pwd,mc.remark,mc.telephone,mc.viopId,mc.viopPwd,mc.viopSid,mc.viopSidPwd,mc.pinyin,mc.minipicurl,mc.bigpicurl,mc.extNumber,mc.groupManager];
                if([db hadError]){
                    *rollback=YES;
                    @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
                    NSLog(@"error:%@",[db lastErrorMessage]);
                }
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
            NSLog(@"error:%@",[db lastErrorMessage]);
            //@throw exception;
        }
        @finally{
            if (notificationName && notificationName.length>0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
                });
            }
        }

    }];
}

-(void) insertGroupsToSQLite:(NSArray*)depts{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            for (MGroup* mc in depts) {
                [db executeUpdate:R_SQL_Group,mc.groupid,mc.groupName,mc.createTime,mc.len,mc.maxLen,mc.name,mc.uid,mc.isTemp,mc.ver];
                if([db hadError]){
                    *rollback=YES;
                    @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
                    NSLog(@"error:%@",[db lastErrorMessage]);
                }
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
            NSLog(@"error:%@",[db lastErrorMessage]);
            //@throw exception;
        }
    }];
}
-(void)updateGroupName:(NSString *)groupName groupId:(NSString*)groupId notificationName:(NSString*)notificationName{
    [self updateMessageMsgOtherNameWithGroupName:groupName GroupId:groupId];
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            [db executeUpdate:U_SQL_Group,groupName,groupId];
            if([db hadError]){
                *rollback=YES;
                @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
                NSLog(@"error:%@",[db lastErrorMessage]);
            }
            
        }
        @catch (NSException *exception) {
            *rollback=YES;
            NSLog(@"error:%@",[db lastErrorMessage]);
            //@throw exception;
        }
        @finally{
            if (notificationName && notificationName.length>0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:groupName];
                });
            }
        }
    }];

}

-(void)updateUserAvatar:(MEnterpriseUser*)user{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            [db executeUpdate:U_SQL_UserAvatar,user.minipicurl,user.bigpicurl,user.uid];
            if([db hadError]){
                *rollback=YES;
                @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
                NSLog(@"error:%@",[db lastErrorMessage]);
            }
            
        }
        @catch (NSException *exception) {
            *rollback=YES;
            NSLog(@"error:%@",[db lastErrorMessage]);
            //@throw exception;
        }
    }];
}

-(void)updateMessageFilePath:(NSString*)filePath  ByBigpicurl:(NSString *)bigpicurl {
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            [db executeUpdate:U_SQL_MessageFilePath,filePath,bigpicurl];
            if([db hadError]){
                *rollback=YES;
                @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
                NSLog(@"error:%@",[db lastErrorMessage]);
            }
            
        }
        @catch (NSException *exception) {
            *rollback=YES;
            NSLog(@"error:%@",[db lastErrorMessage]);
            //@throw exception;
        }
    }];
}

-(void)updateMessageVideoPath:(NSString*)videoPath  ByBigpicurl:(NSString *)bigpicurl {
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            [db executeUpdate:U_SQL_MessageVideoPath,videoPath,bigpicurl];
            if([db hadError]){
                *rollback=YES;
                @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
                NSLog(@"error:%@",[db lastErrorMessage]);
            }
            
        }
        @catch (NSException *exception) {
            *rollback=YES;
            NSLog(@"error:%@",[db lastErrorMessage]);
            //@throw exception;
        }
    }];
}

-(void) insertGroupUsersToSQLite:(NSArray*)users notificationName:(NSString*)notificationName{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            for (MGroupUser *mc in users) {
                
                //群组没有返回用户的公司，垃圾接口，暂时这样处理，妈了个巴子
                mc.gname = @"中兴云服务";
                //end
                
                [db executeUpdate:R_SQL_GroupUser,mc.uid,mc.uname,mc.cid,mc.cname,mc.autograph,mc.email,mc.fax,mc.gid,mc.groupVer,[mc.groupids JSONString],mc.hp,mc.jid,mc.mobile,mc.post,mc.pwd,mc.remark,mc.telephone,mc.viopId,mc.viopPwd,mc.viopSid,mc.viopSidPwd,mc.pinyin,mc.minipicurl,mc.bigpicurl,mc.gname,mc.extNumber,mc.groupid];
                if([db hadError]){
                    *rollback=YES;
                    @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
                    NSLog(@"error:%@",[db lastErrorMessage]);
                }
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
            NSLog(@"error:%@",[db lastErrorMessage]);
            //@throw exception;
        }
        @finally{
            if (notificationName && notificationName.length>0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
                });
            }
        }
    }];
}

-(void)deleteGroup{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            [db executeUpdate:DT_SQL_Group];
            if([db hadError]){
                *rollback=YES;
                @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
            //@throw exception;
        }
        @finally{
            
        }
    }];
}

-(void)deleteGroupUsers{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            [db executeUpdate:DT_SQL_GroupUser];
            if([db hadError]){
                *rollback=YES;
                @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
            //@throw exception;
        }
        @finally{
            
        }
    }];
}

-(void)deleteGroupId:(NSString*)groupId notificationName:(NSString*)notificationName{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            
            
            [db executeUpdate:D_SQL_Group,groupId];
            if([db hadError]){
                *rollback=YES;
                @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
            //@throw exception;
        }
        @finally{
            if (notificationName && notificationName.length>0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
                });
            }
        }
    }];

}

-(void)deleteGroupUserId:(NSString*)groupUserId groupId:(NSString*)groupId notificationName:(NSString*)notificationName{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            [db executeUpdate:D_SQL_GroupUser,groupUserId,groupId];
            if([db hadError]){
                *rollback=YES;
                @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
            //@throw exception;
        }
        @finally{
            if (notificationName && notificationName.length>0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
                });
            }
        }
    }];
}
-(void)deleteDeptWithId:(NSString *)cid
{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            [db executeUpdate:D_SQL_Dept,cid];
            if([db hadError]){
                *rollback=YES;
                @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
            //@throw exception;
        }
    }];
}
-(void)updateDeptCName:(NSString *)cName Gid:(NSString*)gid isRoot:(NSString*)isRoot Pid:(NSString *)pid withCid:(NSString *)cid notificationName:(NSString *)notificationName
{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            [db executeUpdate:R_SQL_Dept,cid,cName,gid,isRoot,pid];
            if([db hadError]){
                *rollback=YES;
                @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
            }
            
        }@catch (NSException *exception) {
            *rollback=YES;
            //@throw exception;
        }@finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (notificationName &&  notificationName.length>0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
                }
                
            });
        }
        
    }];
}

-(void)deleteUserId:(NSString*)uid{
    
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            [db executeUpdate:D_SQL_User,uid];
            if([db hadError]){
                *rollback=YES;
                @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
            //@throw exception;
        }
    }];
}


-(void)deleteMessageByIds:(NSArray*)msgIds notificationName:(NSString*)notificationName{
    
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            for (NSString *msgId in msgIds) {
                [db executeUpdate:D_SQL_Message,msgId];
                if([db hadError]){
                    *rollback=YES;
                    @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
                }
            }
            
        }@catch (NSException *exception) {
            *rollback=YES;
            //@throw exception;
        }@finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (notificationName &&  notificationName.length>0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
                }
                
            });
        }

    }];
}

-(void)insertMessagesToSQLite:(NSArray*)messages notificationName:(NSString*)notificationName{
    
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        @try {
            /*`msgId`, `headpicurl`, `sessionid`, `sessionname`, `type` , `msg` , `username` , `keyid` , `contenttype` , `bigpicurl` , `minipicurl`, `filelength`, `voicelength`, `operatorid` , `adminid` , `adminname` , `modeltype` ,`msgOtherId`,`sendTime`,`readState`,`state`,`wavPath`*/
            for (MMessage *mc in messages) {
                [db executeUpdate:R_SQL_Message,mc.identity,mc.msgId,mc.headpicurl,mc.sessionid,mc.sessionname,mc.type,mc.msg,mc.username,mc.keyid,mc.contenttype,mc.bigpicurl,mc.minipicurl,mc.filelength,mc.voicelength,mc.operatorid,mc.adminid,mc.adminname,mc.modeltype,mc.msgOtherId,mc.msgOtherName,mc.msgOtherAvatar,mc.sendTime,mc.srState,@"1",mc.wavPath,mc.amrPath,mc.videoPath,mc.filePath];
                if([db hadError]){
                    *rollback=YES;
                    @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
                    NSLog(@"error:%@",[db lastErrorMessage]);
                }
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
            NSLog(@"error:%@",[db lastErrorMessage]);
            //@throw exception;
        }
        @finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (notificationName &&  notificationName.length>0) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];

                }
            });
           
            
        }

    }];
}


-(NSMutableArray*)getAllFiles{
    
    __block NSMutableArray* files=[[NSMutableArray alloc] init];
    /*
    [_dbQueue inDatabase:^(FMDatabase *db){
        FMResultSet *rs=[db executeQuery:S_SQL_File];
        while([rs next]) {
            MFile *mu=[[MFile alloc] init];
            mu.fileId=[rs stringForColumn:@"fileId"];
            mu.fileName=[rs stringForColumn:@"fileName"];
            mu.fileSize=[rs stringForColumn:@"fileSize"];
            mu.filePath=[rs  stringForColumn:@"filePath"];
            mu.fileUrl=[rs stringForColumn:@"fileUrl"];
            mu.createdTime=[rs stringForColumn:@"createdTime"];
            mu.fileType=[rs stringForColumn:@"fileType"];
            mu.fileExt=[rs stringForColumn:@"fileExt"];
            mu.fileFromName=[rs stringForColumn:@"fileFromName"];
            mu.fileFromId=[rs stringForColumn:@"fileFromId"];
            [files addObject:mu];
        }
        [rs close];
    }];
     */
    return files;
}

-(void) insertFilesToSQLite:(NSArray*)files  notificationName:(NSString*)notificationName{
    /*
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            for (MFile* mc in files) {
                [db executeUpdate:R_SQL_File,mc.fileId,mc.fileName,mc.fileSize,mc.filePath,mc.fileUrl,mc.createdTime,mc.fileType,mc.fileExt,mc.fileFromId,mc.fileFromName];
                if([db hadError]){
                    *rollback=YES;
                    @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
                    NSLog(@"error:%@",[db lastErrorMessage]);
                }
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
            NSLog(@"error:%@",[db lastErrorMessage]);
            //@throw exception;
        }
        @finally {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (notificationName &&  notificationName.length>0) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
                    }
                });
        }

    }];
     */
}

-(void)deleteChatUserMessageWithKeyId:(NSString*)keyId sessionId:(NSString*)sessionId  notificationName:(NSString*)notificationName
{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
                NSString *identity=[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
                [db executeUpdate:S_SQL_Message_Private_delete,keyId,sessionId,identity,sessionId,keyId,identity];
                if([db hadError]){
                    *rollback=YES;
                    @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
            }
            
        }@catch (NSException *exception) {
            *rollback=YES;
            //@throw exception;
        }@finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (notificationName &&  notificationName.length>0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
                }
                
            });
        }
        
    }];
}
//查询表中所有记录总条数
- (int)getPrivateMessagesConuntWithKeyId:(NSString*)keyId sessionId:(NSString*)sessionId{
    
    __block int count = 0;
    
    NSString *identity=[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
       
        count = [db intForQuery:S_SQL_Message_Count,keyId,sessionId,identity,sessionId,keyId,identity];
        
    }];

    return count;
}

- (int)getGroupMessagesCountWithSessionid:(NSString*)sessionid{
    
    
    __block int count = 0;
    
    NSString *identity=[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        count = [db intForQuery:S_SQL_Message_Group_Count,sessionid,identity];
        
    }];
    
    return count;
    
    
}

-(NSMutableArray*)getPrivateMessagesWithKeyId:(NSString*)keyId sessionId:(NSString*)sessionId faceMap:(NSDictionary*)faceMap cssSheet:(DTCSSStylesheet *)cssSheet offset:(int)offset limit:(int)limit{//offset -- 查询偏移 limit -- 限制查询条数
    
    if (offset < 0) {
        offset = 0;
    }
    
    __block NSMutableArray* privateMsgs=[[NSMutableArray alloc] init];
    [_dbQueue inDatabase:^(FMDatabase *db){
        //查询所有用户
        NSString *identity=[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
        FMResultSet *rs=[db executeQuery:S_SQL_Message_Private,keyId,sessionId,identity,sessionId,keyId,identity,@(limit),@(offset)];
        while([rs next]) {
            /*`msgId`, `headpicurl`, `sessionid`, `sessionname`, `type` , `msg` , `username` , `keyid` , `contenttype` , `bigpicurl` , `minipicurl`, `filelength`, `voicelength`, `operatorid` , `adminid` , `adminname` , `modeltype` ,`msgOtherId`,`sendTime`,`readState`,`state`,`wavPath`*/
            MMessage *mu=[[MMessage alloc] init];
            mu.identity =[rs stringForColumn:@"identity"];
            mu.msgId=[rs stringForColumn:@"msgId"];
            mu.headpicurl=[rs stringForColumn:@"headpicurl"];
            mu.sessionid=[rs stringForColumn:@"sessionid"];
            mu.sessionname=[rs  stringForColumn:@"sessionname"];
            mu.type=[rs stringForColumn:@"type"];
            mu.msg=[rs stringForColumn:@"msg"];
            mu.username=[rs stringForColumn:@"username"];
            mu.keyid=[rs stringForColumn:@"keyid"];
            mu.contenttype =[rs stringForColumn:@"contenttype"];
            mu.bigpicurl =[rs stringForColumn:@"bigpicurl"];
            mu.minipicurl =[rs stringForColumn:@"minipicurl"];
            mu.filelength =[rs stringForColumn:@"filelength"];
            mu.voicelength =[rs stringForColumn:@"voicelength"];
            mu.operatorid =[rs stringForColumn:@"operatorid"];
            mu.adminid =[rs stringForColumn:@"adminid"];
            mu.adminname =[rs stringForColumn:@"adminname"];
            mu.modeltype =[rs stringForColumn:@"modeltype"];
            mu.msgOtherId =[rs stringForColumn:@"msgOtherId"];
            mu.msgOtherName=[rs stringForColumn:@"msgOtherName"];
            mu.msgOtherAvatar =[rs stringForColumn:@"msgOtherAvatar"];
            mu.sendTime =[rs stringForColumn:@"sendTime"];
            mu.srState =[rs stringForColumn:@"srState"];
            mu.wavPath=[rs stringForColumn:@"wavPath"];
            mu.amrPath=[rs stringForColumn:@"amrPath"];
            mu.videoPath=[rs stringForColumn:@"videoPath"];
            mu.filePath=[rs stringForColumn:@"filePath"];
            [mu handleFaceMap:faceMap cssSheet:cssSheet];
            [privateMsgs addObject:mu];
        }
        [rs close];
        
    }];
    return privateMsgs;

}

-(NSMutableArray*)getGroupMessagesWithSessionId:(NSString*)sessionId faceMap:(NSDictionary*)faceMap cssSheet:(DTCSSStylesheet *)cssSheet offset:(int)offset limit:(int)limit{
    
    if (offset < 0) {
        offset = 0;
    }
    
    __block NSMutableArray* groupMsgs=[[NSMutableArray alloc] init];
    [_dbQueue inDatabase:^(FMDatabase *db){
        //查询所有用户
        NSString *identity =[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
        FMResultSet *rs=[db executeQuery:S_SQL_Message_Group,sessionId,identity,@(limit),@(offset)];
        while([rs next]) {
            /*`msgId`, `headpicurl`, `sessionid`, `sessionname`, `type` , `msg` , `username` , `keyid` , `contenttype` , `bigpicurl` , `minipicurl`, `filelength`, `voicelength`, `operatorid` , `adminid` , `adminname` , `modeltype` ,`msgOtherId`,`sendTime`,`readState`,`state`,`wavPath`*/
            MMessage *mu=[[MMessage alloc] init];
            mu.identity =[rs stringForColumn:@"identity"];
            mu.msgId=[rs stringForColumn:@"msgId"];
            mu.headpicurl=[rs stringForColumn:@"headpicurl"];
            mu.sessionid=[rs stringForColumn:@"sessionid"];
            mu.sessionname=[rs  stringForColumn:@"sessionname"];
            mu.type=[rs stringForColumn:@"type"];
            mu.msg=[rs stringForColumn:@"msg"];
            mu.username=[rs stringForColumn:@"username"];
            mu.keyid=[rs stringForColumn:@"keyid"];
            mu.contenttype =[rs stringForColumn:@"contenttype"];
            mu.bigpicurl =[rs stringForColumn:@"bigpicurl"];
            mu.minipicurl =[rs stringForColumn:@"minipicurl"];
            mu.filelength =[rs stringForColumn:@"filelength"];
            mu.voicelength =[rs stringForColumn:@"voicelength"];
            mu.operatorid =[rs stringForColumn:@"operatorid"];
            mu.adminid =[rs stringForColumn:@"adminid"];
            mu.adminname =[rs stringForColumn:@"adminname"];
            mu.modeltype =[rs stringForColumn:@"modeltype"];
            mu.msgOtherId =[rs stringForColumn:@"msgOtherId"];
            mu.msgOtherName =[rs stringForColumn:@"msgOtherName"];
            mu.msgOtherAvatar =[rs stringForColumn:@"msgOtherAvatar"];
            mu.sendTime =[rs stringForColumn:@"sendTime"];
            mu.srState =[rs stringForColumn:@"srState"];
            mu.wavPath=[rs stringForColumn:@"wavPath"];
            mu.amrPath=[rs stringForColumn:@"amrPath"];
            mu.videoPath=[rs stringForColumn:@"videoPath"];
            mu.filePath=[rs stringForColumn:@"filePath"];
            [mu handleFaceMap:faceMap cssSheet:cssSheet];
            [groupMsgs addObject:mu];
        }
        [rs close];
        
    }];
    return groupMsgs;
}

-(void)deleteGroupMessagesWithSessionId:(NSString*)sessionId  notificationName:(NSString*)notificationName
{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            NSString *identity=[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
            [db executeUpdate:S_SQL_Message_Group_delete,sessionId,identity];
            if([db hadError]){
                *rollback=YES;
                @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
            }
            
        }@catch (NSException *exception) {
            *rollback=YES;
            //@throw exception;
        }@finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (notificationName &&  notificationName.length>0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
                }
                
            });
        }
        
    }];
}

- (int)getRowIdOfMessage:(NSString*)msgId sessionid:(NSString*)sessionId{
    
    __block int rowid = 0;
    
    NSString *identity =[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        rowid = [db intForQuery:RID_SQL_Message,sessionId,identity,sessionId,identity,msgId];
        
    }];
    
    return rowid;
    
}


-(NSMutableArray*)getSendingMessages{
    __block NSMutableArray* sendingMsgs=[[NSMutableArray alloc] init];
    [_dbQueue inDatabase:^(FMDatabase *db){
        //查询所有用户
        NSString *identity =[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
        FMResultSet *rs=[db executeQuery:S_SQL_Message_Sending,identity];
        while([rs next]) {
            /*`msgId`, `headpicurl`, `sessionid`, `sessionname`, `type` , `msg` , `username` , `keyid` , `contenttype` , `bigpicurl` , `minipicurl`, `filelength`, `voicelength`, `operatorid` , `adminid` , `adminname` , `modeltype` ,`msgOtherId`,`sendTime`,`readState`,`state`,`wavPath`*/
            MMessage *mu=[[MMessage alloc] init];
            mu.identity =[rs stringForColumn:@"identity"];
            mu.msgId=[rs stringForColumn:@"msgId"];
            mu.headpicurl=[rs stringForColumn:@"headpicurl"];
            mu.sessionid=[rs stringForColumn:@"sessionid"];
            mu.sessionname=[rs  stringForColumn:@"sessionname"];
            mu.type=[rs stringForColumn:@"type"];
            mu.msg=[rs stringForColumn:@"msg"];
            mu.username=[rs stringForColumn:@"username"];
            mu.keyid=[rs stringForColumn:@"keyid"];
            mu.contenttype =[rs stringForColumn:@"contenttype"];
            mu.bigpicurl =[rs stringForColumn:@"bigpicurl"];
            mu.minipicurl =[rs stringForColumn:@"minipicurl"];
            mu.filelength =[rs stringForColumn:@"filelength"];
            mu.voicelength =[rs stringForColumn:@"voicelength"];
            mu.operatorid =[rs stringForColumn:@"operatorid"];
            mu.adminid =[rs stringForColumn:@"adminid"];
            mu.adminname =[rs stringForColumn:@"adminname"];
            mu.modeltype =[rs stringForColumn:@"modeltype"];
            mu.msgOtherId =[rs stringForColumn:@"msgOtherId"];
            mu.msgOtherName =[rs stringForColumn:@"msgOtherName"];
            mu.msgOtherAvatar =[rs stringForColumn:@"msgOtherAvatar"];
            mu.sendTime =[rs stringForColumn:@"sendTime"];
            mu.srState =[rs stringForColumn:@"srState"];
            mu.wavPath=[rs stringForColumn:@"wavPath"];
            mu.amrPath=[rs stringForColumn:@"amrPath"];
            mu.videoPath=[rs stringForColumn:@"videoPath"];
            mu.filePath=[rs stringForColumn:@"filePath"];
            [sendingMsgs addObject:mu];
        }
        [rs close];
        
    }];
    return sendingMsgs;
}


-(void)updateMessageMsgOtherNameWithGroupName:(NSString *)groupName GroupId:(NSString*)groupId{
    
    
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            [db executeUpdate:U_SQL_Message_MsgOtherName,groupName,[NSString stringWithFormat:@"g%@",groupId]];
            if([db hadError]){
                *rollback=YES;
                @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
            //@throw exception;
        }
        @finally{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_R_SQL_MESSAGE object:nil];
            });
        }
    }];
}



-(void)updateMessageMsgOtherIdByMyUid:(NSString*)myUid{
    

    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            [db executeUpdate:U_SQL_Message_MsgOtherId1];
            [db executeUpdate:U_SQL_Message_MsgOtherId2];
            if([db hadError]){
                *rollback=YES;
                @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
            //@throw exception;
        }
        @finally{
        }
    }];
}

-(void)updateMessageSendStateByMsgId:(NSString*)msgId isSendSuccess:(BOOL)isSendSuccess notificationName:(NSString*)notificationName{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            [db executeUpdate:U_SQL_Message_SendState,(isSendSuccess?@"2":@"1"), msgId];
            if([db hadError]){
                *rollback=YES;
                @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
        }
        @finally{
            if (notificationName && notificationName.length>0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:msgId,@"msgId",(isSendSuccess?@"2":@"1"),@"srState", nil]];
                });
            }
        }
    }];
}
-(void)updateMessageSendStateByMsgId:(NSString*)msgId sendState:(MMessageSRState)sendSate notificationName:(NSString*)notificationName{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            [db executeUpdate:U_SQL_Message_SendState,[NSString stringWithFormat:@"%d",sendSate], msgId];
            if([db hadError]){
                *rollback=YES;
                @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
            //@throw exception;
        }
        @finally{
            if (notificationName && notificationName.length>0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:msgId,@"msgId",[NSString stringWithFormat:@"%d",sendSate],@"srState", nil]];
                });

            }

        }
    }];
}

-(void)updateMessageReadStateByMsgOtherId:(NSString*)msgOtherId notificationName:(NSString*)notificationName {
    
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            NSString *identity=[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
            [db executeUpdate:U_SQL_Message_ReadState,msgOtherId,identity];
            if([db hadError]){
                *rollback=YES;
                @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
            //@throw exception;
        }
        @finally{
            if (notificationName && notificationName.length>0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
                });

                
            }

        }
    }];

}



-(void)updateSessionShowStateByMsgOtherId:(NSString*)msgOtherId notificationName:(NSString*)notificationName {
    
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            NSString *identity=[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
            [db executeUpdate:U_SQL_Message_SessionState,msgOtherId,identity];
            if([db hadError]){
                *rollback=YES;
                @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
            //@throw exception;
        }
        @finally{
            if (notificationName && notificationName.length>0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
                });
                
                
            }
            
        }
    }];
    
}

-(NSMutableDictionary*)getAllMessages{
    __block NSMutableDictionary* groupDict=[[NSMutableDictionary alloc] init];
    
    [_dbQueue inDatabase:^(FMDatabase *db){
        //查询所有用户
        NSString *identity=[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
        FMResultSet *rs=[db executeQuery:S_SQL_Message,identity];
        while([rs next]) {
            /*`msgId`, `headpicurl`, `sessionid`, `sessionname`, `type` , `msg` , `username` , `keyid` , `contenttype` , `bigpicurl` , `minipicurl`, `filelength`, `voicelength`, `operatorid` , `adminid` , `adminname` , `modeltype` ,`msgOtherId`,`sendTime`,`readState`,`state`,`wavPath`*/
            MMessage *mu=[[MMessage alloc] init];
            mu.identity =[rs stringForColumn:@"identity"];
            mu.msgId=[rs stringForColumn:@"msgId"];
            mu.headpicurl=[rs stringForColumn:@"headpicurl"];
            mu.sessionid=[rs stringForColumn:@"sessionid"];
            mu.sessionname=[rs  stringForColumn:@"sessionname"];
            mu.type=[rs stringForColumn:@"type"];
            mu.msg=[rs stringForColumn:@"msg"];
            mu.username=[rs stringForColumn:@"username"];
            mu.keyid=[rs stringForColumn:@"keyid"];
            mu.contenttype =[rs stringForColumn:@"contenttype"];
            mu.bigpicurl =[rs stringForColumn:@"bigpicurl"];
            mu.minipicurl =[rs stringForColumn:@"minipicurl"];
            mu.filelength =[rs stringForColumn:@"filelength"];
            mu.voicelength =[rs stringForColumn:@"voicelength"];
            mu.operatorid =[rs stringForColumn:@"operatorid"];
            mu.adminid =[rs stringForColumn:@"adminid"];
            mu.adminname =[rs stringForColumn:@"adminname"];
            mu.modeltype =[rs stringForColumn:@"modeltype"];
            mu.msgOtherId =[rs stringForColumn:@"msgOtherId"];
            mu.msgOtherName=[rs stringForColumn:@"msgOtherName"];
            mu.msgOtherAvatar =[rs stringForColumn:@"msgOtherAvatar"];
            mu.sendTime =[rs stringForColumn:@"sendTime"];
            mu.srState =[rs stringForColumn:@"srState"];
            mu.sessionState =[rs stringForColumn:@"sessionState"];
            mu.wavPath=[rs stringForColumn:@"wavPath"];
            mu.amrPath=[rs stringForColumn:@"amrPath"];
            mu.videoPath= [rs stringForColumn:@"videoPath"];
            mu.filePath=[rs stringForColumn:@"filePath"];
            if(mu.msgOtherId && mu.msgOtherId.length>0){
                [groupDict setObject:mu forKey:mu.msgOtherId];
            }
        }
        [rs close];
        
        rs=[db executeQuery:S_SQL_Message_UnreadNumber,identity];
        while ([rs next]) {
            MMessage *mu=[groupDict objectForKey:[rs stringForColumn:@"msgOtherId"]];
            mu.unreadNumber =[NSNumber numberWithInt:[rs intForColumn:@"unreadNumber"]];
        }
        [rs close];
        
    }];
    return groupDict;
}

-(NSMutableArray *)getAllCommonMeeting
{
    __block NSMutableArray* meetingArrray=[[NSMutableArray alloc] init];
    [_dbQueue inDatabase:^(FMDatabase *db){
        //查询所有会议
        NSString *identity=[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
        FMResultSet *rs=[db executeQuery:S_SQL_MEETING,identity];
        while([rs next]) {
//            if([[rs stringForColumn:@"meetingIsCommon"] intValue] == 1)
//            {
                MeetingModel *model = [[MeetingModel alloc] init];
                model.meetingId =[rs stringForColumn:@"meetingId"];
                model.meetingTitle =[rs stringForColumn:@"meetingTitle"];
                model.meetingPwd =[rs stringForColumn:@"meetingPwd"];
                model.commonMeeting =[rs stringForColumn:@"meetingIsCommon"];
                model.meetingLastConnectTime =[rs stringForColumn:@"meetingLastTime"];
                model.meetingConnectType =[rs stringForColumn:@"meetingConnectType"];
                NSString *jsonString = [rs stringForColumn:@"meetingUserJson"];
                NSData *data = [jsonString dataUsingEncoding: NSUTF8StringEncoding];
                if(data)
                {
                    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    if([object isKindOfClass:[NSArray class]])
                    {
                        for(NSDictionary *dic in object)
                        {
                            MeetingUserModel *tmpModel = [[MeetingUserModel alloc] init];
                            tmpModel.userId = dic[@"userId"];
                            tmpModel.userName = dic[@"userName"];
                            tmpModel.userAvatar = dic[@"userAvatar"];
                            tmpModel.telephone = dic[@"telephone"];
                            [model.meetingUserArray addObject:tmpModel];
                        }
                    }
                }
                [meetingArrray insertObject:model atIndex:0];
            }
//        }
        [rs close];
    }];
    return [NSMutableArray arrayWithArray:meetingArrray];
}

-(MeetingModel *)getMeetingWithId:(NSString *)meetingId
{
    __block MeetingModel *model = nil;
    [_dbQueue inDatabase:^(FMDatabase *db){
        //查询所有会议
        FMResultSet *rs=[db executeQuery:SI_SQL_MEETING,meetingId];
        while([rs next]) {
            model = [[MeetingModel alloc] init];
            model.meetingId =[rs stringForColumn:@"meetingId"];
            model.meetingTitle =[rs stringForColumn:@"meetingTitle"];
            model.meetingPwd =[rs stringForColumn:@"meetingPwd"];
            model.commonMeeting =[rs stringForColumn:@"meetingIsCommon"];
            model.meetingLastConnectTime =[rs stringForColumn:@"meetingLastTime"];
            model.meetingConnectType =[rs stringForColumn:@"meetingConnectType"];
            NSString *jsonString = [rs stringForColumn:@"meetingUserJson"];
            NSData *data = [jsonString dataUsingEncoding: NSUTF8StringEncoding];
            if(data)
            {
                id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if([object isKindOfClass:[NSArray class]])
                {
                    for(NSDictionary *dic in object)
                    {
                        MeetingUserModel *tmpModel = [[MeetingUserModel alloc] init];
                        tmpModel.userId = dic[@"userId"];
                        tmpModel.userName = dic[@"userName"];
                        tmpModel.userAvatar = dic[@"userAvatar"];
                        tmpModel.telephone = dic[@"telephone"];
                        [model.meetingUserArray addObject:tmpModel];
                    }
                }
            }
        }
        [rs close];
    }];
    return model;

}

-(void)deleteMeetingWithId:(NSString *)meetingId notification:(NSString *)notificationName
{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            [db executeUpdate:DM_SQL_MEETING,meetingId];
            if([db hadError]){
                *rollback=YES;
                @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
            //@throw exception;
        }
        @finally{
            if (notificationName && notificationName.length>0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
                });
            }
        }
    }];
}

-(void)deleteAllMeeting:(NSString *)notificationName
{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            NSString *identity=[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
            [db executeUpdate:DU_SQL_MEETING,identity];
            if([db hadError]){
                *rollback=YES;
                @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
            //@throw exception;
        }
        @finally{
            if (notificationName && notificationName.length>0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
                });
            }
        }
    }];
}

-(void)insertMeetingWithArray:(NSArray *)meetingArray notification:(NSString *)notificationName
{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            for (MeetingModel*mc in meetingArray) {
                NSString *identity=[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
                NSMutableArray *array = [NSMutableArray array];
                for(int i = 0 ; i < mc.meetingUserArray.count ; i ++)
                {
                    MeetingUserModel *model = mc.meetingUserArray[i];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setObject:model.userId?model.userId:@"" forKey:@"userId"];
                    [dic setObject:model.userName?model.userName:@"" forKey:@"userName"];
                    [dic setObject:model.telephone?model.telephone:@"" forKey:@"telephone"];
                    [dic setObject:model.userAvatar?model.userAvatar:@"" forKey:@"userAvatar"];
                    [array addObject:dic];
                }
                NSData *newData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonStr = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
                [db executeUpdate:R_SQL_MEETING,mc.meetingId,identity,mc.meetingTitle,mc.meetingPwd,mc.commonMeeting,mc.meetingLastConnectTime,mc.meetingConnectType,jsonStr];
                if([db hadError]){
                    *rollback=YES;
                    @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
                    NSLog(@"error:%@",[db lastErrorMessage]);
                }
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
            NSLog(@"error:%@",[db lastErrorMessage]);
            //@throw exception;
        }
        @finally{
            if (notificationName && notificationName.length>0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
                });
            }
        }
    }];
}



-(NSMutableArray *)getAllHistoryMeeting
{
    __block NSMutableArray* meetingArrray=[[NSMutableArray alloc] init];
    [_dbQueue inDatabase:^(FMDatabase *db){
        //查询所有会议
        NSString *identity=[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
        FMResultSet *rs=[db executeQuery:S_SQL_HISTORY_MEETING,identity];
        while([rs next]) {
//            if([[rs stringForColumn:@"meetingIsCommon"] intValue] == 1)
//            {
                MeetingModel *model = [[MeetingModel alloc] init];
                model.meetingId =[rs stringForColumn:@"meetingId"];
                model.meetingTitle =[rs stringForColumn:@"meetingTitle"];
                model.meetingPwd =[rs stringForColumn:@"meetingPwd"];
                model.commonMeeting =[rs stringForColumn:@"meetingIsCommon"];
                model.meetingLastConnectTime =[rs stringForColumn:@"meetingLastTime"];
                model.meetingConnectType =[rs stringForColumn:@"meetingConnectType"];
                NSString *jsonString = [rs stringForColumn:@"meetingUserJson"];
                NSData *data = [jsonString dataUsingEncoding: NSUTF8StringEncoding];
                if(data)
                {
                    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    if([object isKindOfClass:[NSArray class]])
                    {
                        for(NSDictionary *dic in object)
                        {
                            MeetingUserModel *tmpModel = [[MeetingUserModel alloc] init];
                            tmpModel.userId = dic[@"userId"];
                            tmpModel.userName = dic[@"userName"];
                            tmpModel.userAvatar = dic[@"userAvatar"];
                            tmpModel.telephone = dic[@"telephone"];
                            [model.meetingUserArray addObject:tmpModel];
                        }
                    }
                }
                [meetingArrray insertObject:model atIndex:0];
//            }
        }
        [rs close];
    }];
    return [NSMutableArray arrayWithArray:meetingArrray];
}

-(MeetingModel *)getHistoryMeetingWithId:(NSString *)meetingId
{
    __block MeetingModel *model = nil;
    [_dbQueue inDatabase:^(FMDatabase *db){
        //查询所有会议
        FMResultSet *rs=[db executeQuery:SI_SQL_HISTORY_MEETING,meetingId];
        while([rs next]) {
            model = [[MeetingModel alloc] init];
            model.meetingId =[rs stringForColumn:@"meetingId"];
            model.meetingTitle =[rs stringForColumn:@"meetingTitle"];
            model.meetingPwd =[rs stringForColumn:@"meetingPwd"];
            model.commonMeeting =[rs stringForColumn:@"meetingIsCommon"];
            model.meetingLastConnectTime =[rs stringForColumn:@"meetingLastTime"];
            model.meetingConnectType =[rs stringForColumn:@"meetingConnectType"];
            NSString *jsonString = [rs stringForColumn:@"meetingUserJson"];
            NSData *data = [jsonString dataUsingEncoding: NSUTF8StringEncoding];
            if(data)
            {
                id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if([object isKindOfClass:[NSArray class]])
                {
                    for(NSDictionary *dic in object)
                    {
                        MeetingUserModel *tmpModel = [[MeetingUserModel alloc] init];
                        tmpModel.userId = dic[@"userId"];
                        tmpModel.userName = dic[@"userName"];
                        tmpModel.userAvatar = dic[@"userAvatar"];
                        tmpModel.telephone = dic[@"telephone"];
                        [model.meetingUserArray addObject:tmpModel];
                    }
                }
            }
        }
        [rs close];
    }];
    return model;
    
}

-(void)deleteHistoryMeetingWithId:(NSString *)meetingId notification:(NSString *)notificationName
{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            [db executeUpdate:DM_SQL_HISTORY_MEETING,meetingId];
            if([db hadError]){
                *rollback=YES;
                @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
            //@throw exception;
        }
        @finally{
            if (notificationName && notificationName.length>0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
                });
            }
        }
    }];
}

-(void)deleteAllHistoryMeeting:(NSString *)notificationName
{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            NSString *identity=[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
            [db executeUpdate:DU_SQL_HISTORY_MEETING,identity];
            if([db hadError]){
                *rollback=YES;
                @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
            //@throw exception;
        }
        @finally{
            if (notificationName && notificationName.length>0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
                });
            }
        }
    }];
}

-(void)insertHistoryMeetingWithArray:(NSArray *)meetingArray notification:(NSString *)notificationName
{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            for (MeetingModel*mc in meetingArray) {
                NSString *identity=[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
                NSMutableArray *array = [NSMutableArray array];
                for(int i = 0 ; i < mc.meetingUserArray.count ; i ++)
                {
                    MeetingUserModel *model = mc.meetingUserArray[i];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setObject:model.userId?model.userId:@"" forKey:@"userId"];
                    [dic setObject:model.userName?model.userName:@"" forKey:@"userName"];
                    [dic setObject:model.telephone?model.telephone:@"" forKey:@"telephone"];
                    [dic setObject:model.userAvatar?model.userAvatar:@"" forKey:@"userAvatar"];
                    [array addObject:dic];
                }
                NSData *newData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonStr = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
                [db executeUpdate:R_SQL_HISTORY_MEETING,mc.meetingId,identity,mc.meetingTitle,mc.meetingPwd,mc.commonMeeting,mc.meetingLastConnectTime,mc.meetingConnectType,jsonStr];
                if([db hadError]){
                    *rollback=YES;
                    @throw [[NSException alloc] initWithName:@"dbError" reason:[db lastErrorMessage] userInfo:nil];
                    NSLog(@"error:%@",[db lastErrorMessage]);
                }
            }
        }
        @catch (NSException *exception) {
            *rollback=YES;
            NSLog(@"error:%@",[db lastErrorMessage]);
            //@throw exception;
        }
        @finally{
            if (notificationName && notificationName.length>0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
                });
            }
        }
    }];
}

@end
