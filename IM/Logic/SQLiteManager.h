//
//  SQLiteManager.h
//  ZGQChat
//
//  Created by zuo guoqing on 14-7-22.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"
#import "FMDatabaseAdditions.h"
#import "SQLStatement.h"
#import "JSONKit.h"
#import "MEnterpriseCompany.h"
#import "MEnterpriseDept.h"
#import "MEnterpriseUser.h"
#import "MGroup.h"
#import "MGroupUser.h"
#import "MMessage.h"
#import "MeetingModel.h"
@class ZTENotificationModal;
@interface SQLiteManager : NSObject{
    FMDatabaseQueue *_dbQueue;
}

+(SQLiteManager *)sharedInstance;
-(void)reset;
//创建表
-(void)createTable;
-(void)clearTable;
-(void)clearTableWithNames:(NSArray *)tableNames;

-(NSArray*) getAllDeptByGId:(NSString*)gid;
-(MEnterpriseUser*) getUserByVoipId:(NSString*)voipId;
-(NSMutableDictionary*) getAllUserByGid:(NSString*)gid;

- (int)getPrivateMessagesConuntWithKeyId:(NSString*)keyId sessionId:(NSString*)sessionId;
- (int)getGroupMessagesCountWithSessionid:(NSString*)sessionid;
//小黑板
- (void) insertBoardsToSQLite:(NSArray*)boards;
-(NSMutableArray*) getAllBoardsFromSQLiteWithTarget:(NSString *)target;
-(ZTENotificationModal*)getTaskModelWithTaskId:(NSString*)taskId;
-(void)updateBoardsStatus:(NSString*)status withTaskId:(NSString*)taskId withUid:(NSString*)uid notificationName:(NSString*)notificationName;
//注册审批表
-(void)insertApproveToSQLite:(NSArray *)approves;
-(NSMutableArray*) getAllApproveFromSQLite;


-(void) insertCompanysToSQLite:(NSArray*)companys;
-(void) insertDeptsToSQLite:(NSArray*)depts;
-(void) insertUsersToSQLite:(NSArray*)users notificationName:(NSString*)notificationName;

-(void)deleteDeptWithId:(NSString*)cid;
-(void)updateDeptCName:(NSString*)cName Gid:(NSString*)gid isRoot:(NSString*)isRoot Pid:(NSString*)pid withCid:(NSString*)cid notificationName:(NSString*)notificationName;

-(void)deleteUserId:(NSString*)uid;
-(void)updateUserAvatar:(MEnterpriseUser*)user;


-(NSMutableDictionary *) getAllGroups;
-(void)deleteGroup;//删除掉所有group信息
-(void)insertGroupsToSQLite:(NSArray*)depts;
-(void)updateGroupName:(NSString *)groupName groupId:(NSString*)groupId notificationName:(NSString*)notificationName;
-(void)deleteGroupId:(NSString*)groupId notificationName:(NSString*)notificationName;

-(void)deleteGroupUsers;
-(void)insertGroupUsersToSQLite:(NSArray*)users notificationName:(NSString*)notificationName;
-(void)deleteGroupUserId:(NSString*)groupUserId groupId:(NSString*)groupId notificationName:(NSString*)notificationName;

-(void)deleteMessageByIds:(NSArray*)msgIds notificationName:(NSString*)notificationName;
-(void)insertMessagesToSQLite:(NSArray*)messages notificationName:(NSString*)notificationName;
-(NSMutableDictionary*)getAllMessages;
-(void)updateMessageMsgOtherIdByMyUid:(NSString*)myUid;
-(void)updateMessageSendStateByMsgId:(NSString*)msgId isSendSuccess:(BOOL)isSendSuccess notificationName:(NSString*)notificationName;
-(void)updateMessageReadStateByMsgOtherId:(NSString*)msgOtherId notificationName:(NSString*)notificationName;
-(void)updateSessionShowStateByMsgOtherId:(NSString*)msgOtherId notificationName:(NSString*)notificationName;

-(void)updateMessageMsgOtherNameWithGroupName:(NSString *)groupName GroupId:(NSString*)groupId;
//获取聊天记录
-(NSMutableArray*)getPrivateMessagesWithKeyId:(NSString*)keyId sessionId:(NSString*)sessionId faceMap:(NSDictionary*)faceMap cssSheet:(DTCSSStylesheet *)cssSheet offset:(int)offset limit:(int)limit;

-(void)deleteChatUserMessageWithKeyId:(NSString*)keyId sessionId:(NSString*)sessionId  notificationName:(NSString*)notificationName;
-(NSMutableArray*)getGroupMessagesWithSessionId:(NSString*)sessionId faceMap:(NSDictionary*)faceMap cssSheet:(DTCSSStylesheet *)cssSheet offset:(int)offset limit:(int)limit;
-(void)deleteGroupMessagesWithSessionId:(NSString*)sessionId  notificationName:(NSString*)notificationName;
-(NSMutableArray*)getSendingMessages;




-(void)updateMessageVideoPath:(NSString*)videoPath  ByBigpicurl:(NSString *)bigpicurl ;
-(void)updateMessageFilePath:(NSString*)filePath  ByBigpicurl:(NSString *)bigpicurl;

-(void) insertFilesToSQLite:(NSArray*)files  notificationName:(NSString*)notificationName;
-(NSMutableArray*)getAllFiles;


//add by Luhao
-(NSMutableDictionary *) getAllOnlyGroups;
-(void)setUserArrayByGroupModel:(MGroup *)mu;

/**
 *  获取该用户下所有的常用的本地会议记录
 *
 *  @return 会议模型数组
 */
-(NSMutableArray *)getAllCommonMeeting;

/**
 *  根据会议id获取会议模型
 *
 *  @param meetingId 会议id（由于本地，会议id以创建时间的时间戳作为唯一标识）
 */
-(MeetingModel *)getMeetingWithId:(NSString *)meetingId;

/**
 *  根据id删除会议
 *
 *  @param meetingId        会议id
 *  @param notificationName 刷新界面通知名称
 */
-(void)deleteMeetingWithId:(NSString *)meetingId notification:(NSString *)notificationName;

/**
 *  删除该用户下的所有会议记录
 *
 *  @param notificationName 刷新界面通知名称
 */
-(void)deleteAllMeeting:(NSString *)notificationName;

/**
 *  刷新界面
 *
 *  @param meetingArray     插入数据
 *  @param notificationName 刷新界面通知名称
 */
-(void)insertMeetingWithArray:(NSArray *)meetingArray notification:(NSString *)notificationName;


-(NSMutableArray *)getAllHistoryMeeting;

-(MeetingModel *)getHistoryMeetingWithId:(NSString *)meetingId;

-(void)deleteHistoryMeetingWithId:(NSString *)meetingId notification:(NSString *)notificationName;

-(void)deleteAllHistoryMeeting:(NSString *)notificationName;

-(void)insertHistoryMeetingWithArray:(NSArray *)meetingArray notification:(NSString *)notificationName;

//
@property (nonatomic, assign) NSTimeInterval refreshTime;

- (int)getRowIdOfMessage:(NSString*)msgId sessionid:(NSString*)sessionId;

-(void)updateMessageSendStateByMsgId:(NSString*)msgId sendState:(MMessageSRState)sendSate notificationName:(NSString*)notificationName;

@end
