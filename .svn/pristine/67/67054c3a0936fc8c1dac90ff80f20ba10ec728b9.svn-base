//
//  SQLStatement.m
//  ZGQChat
//
//  Created by zuo guoqing on 14-7-22.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//
#import "SQLStatement.h"

@implementation SQLStatement
//创建联系人表
NSString* const CT_SQL_User=@"CREATE TABLE `tbl_user` (`uid` BIGINT NOT NULL ,`uname` VARCHAR(255) NULL  ,`cid` BIGINT NULL ,`cname` VARCHAR(255) NULL ,`autograph` VARCHAR(255) NULL ,`email` VARCHAR(255) NULL ,`fax` VARCHAR(255) NULL ,`gid` BIGINT NULL ,`groupVer` VARCHAR(255) NULL ,`groupids` VARCHAR(1024) NULL ,`hp` VARCHAR(255) NULL ,`jid` VARCHAR(255) NULL ,`mobile` VARCHAR(255) NULL ,`post` VARCHAR(255) NULL ,`pwd` VARCHAR(255) NULL ,`remark` VARCHAR(255) NULL ,`telephone` VARCHAR(255) NULL, `viopId` VARCHAR(255) NULL,`viopPwd` VARCHAR(255) NULL, `viopSid` VARCHAR(255) NULL,`viopSidPwd` VARCHAR(255) NULL,'pinyin' VARCHAR(255) NULL, `minipicurl` VARCHAR(255) NULL, `bigpicurl` VARCHAR(255) NULL, `extNumber` VARCHAR(255) NULL,`groupManager` VARCHAR(255) NULL, PRIMARY KEY (`uid`) )";
//删除联系人表
NSString* const DT_SQL_User =@"DELETE FROM tbl_user";
//删除联系人记录
NSString* const D_SQL_User =@"DELETE FROM tbl_user WHERE `uid`=?";
//插入或更新联系人记录
NSString* const R_SQL_User =@"REPLACE INTO `tbl_user` (`uid`,`uname`,`cid`,`cname`,`autograph` ,`email`,`fax` ,`gid`,`groupVer`,`groupids` ,`hp`,`jid` ,`mobile` ,`post` ,`pwd` ,`remark` ,`telephone`, `viopId`,`viopPwd` , `viopSid`,`viopSidPwd`,'pinyin',`minipicurl`,`bigpicurl`,`extNumber`,`groupManager`) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
//查询所有联系人记录
NSString* const S_SQL_UserByGId =@"SELECT tbl_user.uid,tbl_user.uname,tbl_user.cid,tbl_user.autograph,tbl_user.email,tbl_user.fax,tbl_user.gid,tbl_user.groupVer,tbl_user.groupids,tbl_user.hp,tbl_user.jid,tbl_user.mobile,tbl_user.post,tbl_user.pwd,tbl_user.remark,tbl_user.telephone,tbl_user.viopId,tbl_user.viopPwd,tbl_user.viopSid,tbl_user.viopSidPwd,tbl_user.pinyin,tbl_user.minipicurl,tbl_user.bigpicurl,tbl_user.extNumber,tbl_user.groupManager,tbl_dept.cname,tbl_company.gname FROM tbl_user LEFT JOIN tbl_dept ON tbl_user.cid = tbl_dept.cid LEFT JOIN tbl_company ON tbl_dept.gid=tbl_company.gid WHERE tbl_user.gid=?";

NSString* const U_SQL_UserAvatar =@"UPDATE tbl_user SET minipicurl=?, bigpicurl=? WHERE uid=?";

NSString* const S_SQL_UserByVoipId=@"SELECT tbl_user.uid,tbl_user.uname,tbl_user.cid,tbl_user.autograph,tbl_user.email,tbl_user.fax,tbl_user.gid,tbl_user.groupVer,tbl_user.groupids,tbl_user.hp,tbl_user.jid,tbl_user.mobile,tbl_user.post,tbl_user.pwd,tbl_user.remark,tbl_user.telephone,tbl_user.viopId,tbl_user.viopPwd,tbl_user.viopSid,tbl_user.viopSidPwd,tbl_user.pinyin,tbl_user.minipicurl,tbl_user.bigpicurl,tbl_user.extNumber,tbl_user.groupManager,tbl_dept.cname,tbl_company.gname FROM tbl_user LEFT JOIN tbl_dept ON tbl_user.cid = tbl_dept.cid LEFT JOIN tbl_company ON tbl_dept.gid=tbl_company.gid WHERE tbl_user.viopId=?";


NSString* const CT_SQL_Company=@"CREATE TABLE `tbl_company`(`gid` BIGINT NOT NULL,`gname` VARCHAR(255) NOT NULL,`rootCIds` VARCHAR(1024) NULL , PRIMARY KEY (`gid`))";
NSString* const DT_SQL_Company=@"DELETE FROM tbl_company";
NSString* const D_SQL_Company =@"DELETE FROM tbl_company WHERE `gid`=?" ;
NSString* const R_SQL_Company =@"REPLACE INTO `tbl_company` (`gid`,`gname`,`rootCIds`) VALUES (?,?,?)";
NSString* const S_SQL_Company=@"SELECT * FROM tbl_company";
NSString* const S_SQL_CompanyId=@"SELECT * FROM tbl_company WHERE gid=?";



NSString* const CT_SQL_Dept =@"CREATE TABLE `tbl_dept`(`cid` BIGINT NOT NULL,`cname` VARCHAR(255) NOT NULL,`gid` BIGINT NOT NULL, isroot BIGINT NULL,pid BIGINT NULL, PRIMARY KEY (`cid`))";
NSString* const DT_SQL_Dept=@"DELETE FROM tbl_dept";
NSString* const D_SQL_Dept=@"DELETE FROM tbl_dept WHERE `cid`=?" ;
NSString* const R_SQL_Dept=@"REPLACE INTO `tbl_dept` (`cid`,`cname`,`gid`,`isroot`,`pid`) VALUES (?,?,?,?,?)";
NSString* const S_SQL_DeptByGId =@"SELECT * FROM tbl_dept WHERE gid=?";



NSString*const CT_SQL_Group=@"CREATE TABLE `tbl_group`(`groupid` BIGINT NOT NULL,`groupName` VARCHAR(255) NULL,`createTime` VARCHAR(255) NULL,`len` VARCHAR(255) NULL ,`maxLen` VARCHAR(255) NULL, `name` VARCHAR(255) NULL, `uid` VARCHAR(255) NULL, `isTemp` VARCHAR(255) NULL,`ver` VARCHAR(255) NULL, PRIMARY KEY (`groupid`))";
NSString* const DT_SQL_Group =@"DELETE FROM tbl_group";
NSString* const D_SQL_Group =@"DELETE FROM tbl_group WHERE `groupid`=?" ;;
NSString* const R_SQL_Group=@"REPLACE INTO `tbl_group` (`groupid`,`groupName`,`createTime`,`len`,`maxLen`,`name`,`uid`,`isTemp`,`ver`) VALUES (?,?,?,?,?,?,?,?,?)";
NSString* const S_SQL_Group=@"SELECT * FROM tbl_group";
NSString* const U_SQL_Group= @"UPDATE tbl_group SET groupName=? WHERE `groupid`=?";

NSString*const CT_SQL_GroupUser =@"CREATE TABLE `tbl_groupuser` (`uid` BIGINT NOT NULL ,`uname` VARCHAR(255) NULL  ,`cid` BIGINT NULL ,`cname` VARCHAR(255) NULL ,`autograph` VARCHAR(255) NULL ,`email` VARCHAR(255) NULL ,`fax` VARCHAR(255) NULL ,`gid` BIGINT NULL ,`groupVer` VARCHAR(255) NULL ,`groupids` VARCHAR(1024) NULL ,`hp` VARCHAR(255) NULL ,`jid` VARCHAR(255) NULL ,`mobile` VARCHAR(255) NULL ,`post` VARCHAR(255) NULL ,`pwd` VARCHAR(255) NULL ,`remark` VARCHAR(255) NULL ,`telephone` VARCHAR(255) NULL, `viopId` VARCHAR(255) NULL,`viopPwd` VARCHAR(255) NULL, `viopSid` VARCHAR(255) NULL,`viopSidPwd` VARCHAR(255) NULL,'pinyin' VARCHAR(255) NULL, `minipicurl` VARCHAR(255) NULL, `bigpicurl` VARCHAR(255) NULL, `gname` VARCHAR(255) NULL, `extNumber` VARCHAR(255) NULL, `groupid` BIGINT NOT NULL, CONSTRAINT `groupuser_unique` UNIQUE (uid, groupid))";
NSString* const DT_SQL_GroupUser=@"DELETE FROM tbl_groupuser";
NSString* const D_SQL_GroupUser =@"DELETE FROM tbl_groupuser WHERE `uid`=? AND groupid=?" ;
NSString* const R_SQL_GroupUser =@"REPLACE INTO `tbl_groupuser` (`uid`,`uname`,`cid`,`cname`,`autograph` ,`email`,`fax` ,`gid`,`groupVer`,`groupids` ,`hp`,`jid` ,`mobile` ,`post` ,`pwd` ,`remark` ,`telephone`, `viopId`,`viopPwd` , `viopSid`,`viopSidPwd`,'pinyin', `minipicurl`, `bigpicurl`, `gname`, `extNumber`, `groupid`) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
NSString* const S_SQL_GroupUser=@"SELECT * FROM tbl_groupuser";
NSString* const S_SQL_OnlyGroupUser=@"SELECT * FROM tbl_groupuser WHERE `groupid`=?";


NSString*const CT_SQL_Message=@"CREATE TABLE `tbl_message`(`identity` VARCHAR(255) NULL, `msgId` VARCHAR(255) NULL,`headpicurl` VARCHAR(255) NULL, `sessionid` VARCHAR(255) NULL, `sessionname` VARCHAR(255) NULL, `type` VARCHAR(255) NULL, `msg` VARCHAR(255) NULL, `username` VARCHAR(255) NULL, `keyid` VARCHAR(255) NULL , `contenttype` VARCHAR(255) NULL, `bigpicurl` VARCHAR(255) NULL, `minipicurl` VARCHAR(255) NULL, `filelength` VARCHAR(255) NULL, `voicelength` VARCHAR(255) NULL, `operatorid` VARCHAR(255) NULL, `adminid` VARCHAR(255) NULL, `adminname` VARCHAR(255) NULL, `modeltype` VARCHAR(255) NULL, `msgOtherId` VARCHAR(255) NULL,`msgOtherName` VARCHAR(255) NULL, `msgOtherAvatar` VARCHAR(255) NULL, `sendTime` VARCHAR(255) NULL, `srState` VARCHAR(255) NULL,`sessionState` VARCHAR(255) NULL,`wavPath`  VARCHAR(255) NULL,`amrPath`  VARCHAR(255) NULL, `videoPath`  VARCHAR(255) NULL,`filePath`  VARCHAR(255) NULL, PRIMARY KEY (`msgId`))";
NSString*const DT_SQL_Message=@"DELETE FROM tbl_message";
NSString*const D_SQL_Message=@"DELETE FROM tbl_message WHERE `msgId`=?" ;
//修改了一下 之前是replace into -- zy
NSString*const R_SQL_Message=@"INSERT INTO `tbl_message`(`identity`,`msgId`, `headpicurl`, `sessionid`, `sessionname`, `type` , `msg` , `username` , `keyid` , `contenttype` , `bigpicurl` , `minipicurl`, `filelength`, `voicelength`, `operatorid` , `adminid` , `adminname` , `modeltype` ,`msgOtherId`,`msgOtherName`,`msgOtherAvatar`,`sendTime`,`srState`,`sessionState`, `wavPath`, `amrPath`,`videoPath`,`filePath`) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
//查找消息在数据库中的位置
NSString *const RID_SQL_Message = @"SELECT COUNT(*) FROM (SELECT ROWID,* FROM tbl_message WHERE `sessionid`=? AND identity=? ORDER BY `sendTime` ASC) WHERE ROWID < (SELECT ROWID FROM (SELECT ROWID,* FROM tbl_message WHERE `sessionid`=? AND identity=? ORDER BY `sendTime` ASC) WHERE msgId=?) ";


//查询所有消息
NSString*const S_SQL_Message=@"SELECT * FROM (SELECT * FROM tbl_message t2 WHERE t2.identity=? ORDER BY t2.sendTime ASC) t1 GROUP BY t1.msgOtherId";

//查询所有未读消息
NSString*const S_SQL_Message_UnreadNumber=@"SELECT t1.msgOtherId,COUNT(t1.msgOtherId) AS unreadNumber FROM (SELECT * FROM tbl_message t2 WHERE t2.srState='4' AND t2.identity=? ORDER BY t2.sendTime DESC) t1 GROUP BY t1.msgOtherId";

//更新消息状态为已读
NSString*const U_SQL_Message_ReadState=@"UPDATE tbl_message SET srState='3' WHERE srState='4' AND`msgOtherId`=? AND identity=?";

//更新消息列表状态为不显示
NSString*const U_SQL_Message_SessionState=@"UPDATE tbl_message SET sessionState='0' WHERE sessionState='1' AND`msgOtherId`=? AND identity=?";

//获取所有发送失败的消息
NSString*const S_SQL_Message_Sending=@"SELECT * From tbl_message WHERE srState='0' AND identity=?";

NSString*const U_SQL_Message_SendState=@"UPDATE tbl_message SET srState=? WHERE msgId=?";

NSString*const U_SQL_Message_MsgOtherName=@"UPDATE tbl_message SET msgOtherName=? WHERE msgOtherId=?";

NSString*const U_SQL_Message_MsgOtherId1=@"UPDATE tbl_message SET msgOtherId=sessionid,msgOtherName=sessionname WHERE keyid=identity";
NSString*const U_SQL_Message_MsgOtherId2=@"UPDATE tbl_message SET msgOtherId=keyid,msgOtherName=username WHERE sessionid=identity";
NSString*const U_SQL_MessageVideoPath =@"UPDATE tbl_message SET videoPath=? WHERE bigpicurl=?";
NSString*const U_SQL_MessageFilePath =@"UPDATE tbl_message SET filePath=? WHERE bigpicurl=?";

//查询个人消息记录
// LIMIT 10 OFFSET 5 限制条数
NSString*const S_SQL_Message_Private=@"SELECT * FROM tbl_message WHERE (`keyid`=? AND `sessionid`=? AND identity=?) OR (`keyid`=? AND `sessionid`=? AND identity=? ) ORDER BY `sendTime` ASC LIMIT ? OFFSET ?";
NSString *const S_SQL_Message_Count = @"SELECT COUNT(*) FROM tbl_message WHERE (`keyid`=? AND `sessionid`=? AND identity=?) OR (`keyid`=? AND `sessionid`=? AND identity=? )";
//NSUInteger count = [db intForQuery:@"select count(*) from LoginUser"];

//删除个人消息记录
NSString*const S_SQL_Message_Private_delete=@"DELETE FROM tbl_message WHERE (`keyid`=? AND `sessionid`=? AND identity=?) OR (`keyid`=? AND `sessionid`=? AND identity=? )";

//查询群组消息记录
NSString*const S_SQL_Message_Group=@"SELECT * FROM tbl_message WHERE `sessionid`=? AND identity=? ORDER BY `sendTime` ASC LIMIT ? OFFSET ?";
NSString*const S_SQL_Message_Group_Count = @"SELECT COUNT(*) FROM tbl_message WHERE `sessionid`=? AND identity=?";

//删除群组消息记录
NSString*const S_SQL_Message_Group_delete=@"DELETE FROM tbl_message WHERE `sessionid`=? AND identity=?";

NSString*const CT_SQL_File=@"CREATE TABLE `tbl_file`(`fileId` VARCHAR(255) NULL,`fileName` VARCHAR(255) NULL, `fileSize` VARCHAR(255) NULL, `filePath` VARCHAR(255) NULL, `fileUrl` VARCHAR(255) NULL, `createdTime` VARCHAR(255) NULL,`fileType` VARCHAR(255) NULL,`fileExt` VARCHAR(255) NULL,`fileFromId` VARCHAR(255) NULL,`fileFromName` VARCHAR(255) NULL, PRIMARY KEY (`fileId`))";
NSString*const DT_SQL_File=@"DELETE FROM tbl_file";
NSString*const D_SQL_File=@"DELETE FROM tbl_file WHERE fileId=?";
NSString*const R_SQL_File=@"REPLACE INTO `tbl_file`(`fileId`, `fileName`, `fileSize`, `filePath`, `fileUrl` , `createdTime` , `fileType`,`fileExt`,`fileFromId`,`fileFromName`) VALUES (?,?,?,?,?,?,?,?,?,?)";
NSString*const S_SQL_File=@"SELECT * FROM tbl_file";

//小黑板通知记录
NSString *const CT_SQL_Board = @"CREATE TABLE `tbl_board`(`boardId` VARCHAR(255) NULL,`content` VARCHAR(255) NULL, `createTime` VARCHAR(255) NULL, `creatorUid` VARCHAR(255) NULL, `creatorUserId` VARCHAR(255) NULL, `deptCid` VARCHAR(255) NULL,`deptGroupId` VARCHAR(255) NULL,`deptName` VARCHAR(255) NULL,`gid` VARCHAR(255) NULL,`tenantId` VARCHAR(255) NULL,`title` VARCHAR(255) NULL,`typeId` VARCHAR(255) NULL,`typeName` VARCHAR(255) NULL, `mobile` VARCHAR(255) NULL, `name` VARCHAR(255) NULL,`contentType` VARCHAR(255) NULL,`creatorAppocUserId` VARCHAR(255) NULL,`creatorName` VARCHAR(255) NULL,`isDelayingMessageSent` VARCHAR(255) NULL,`isDeleted` VARCHAR(255) NULL,`isNeedNotify` VARCHAR(255) NULL,`plannedFinishTime` VARCHAR(255) NULL,`progress` VARCHAR(255) NULL,`status` VARCHAR(255) NULL,`taskId` VARCHAR(255) NULL,`userCount` VARCHAR(255) NULL,`uid` VARCHAR(255) NULL,PRIMARY KEY (`boardId`))";
NSString*const DT_SQL_Board = @"DELETE FROM tbl_board";
NSString*const D_SQL_Board = @"DELETE FROM tbl_board WHERE boardId=?";
NSString*const R_SQL_Board = @"REPLACE INTO `tbl_board`(`boardId`, `content`, `createTime`, `creatorUid`, `creatorUserId` , `deptCid` , `deptGroupId`,`deptName`,`gid`,`tenantId`,`title`,`typeId`,`typeName`,`mobile`,`name`,`contentType`,`creatorAppocUserId`,`creatorName`,`isDelayingMessageSent`,`isDeleted`,`isNeedNotify`,`plannedFinishTime`,`progress`,`status`,`taskId`,`userCount`,`uid`) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
NSString*const S_SQL_Board = @"SELECT * FROM tbl_board";
NSString*const S_SQL_USE_Board = @"SELECT * FROM tbl_board WHERE uid=?";
NSString*const S_SQL_Task = @"SELECT * FROM tbl_board WHERE taskId=?";
NSString*const U_SQL_Board =@"UPDATE tbl_board SET status=? WHERE taskId=? AND uid=?";

//申请加入企业通知记录
NSString *const CT_SQL_Approve = @"CREATE TABLE `tbl_approve`(`createTime` VARCHAR(255) NULL, `mobile` VARCHAR(255) NULL, `name` VARCHAR(255) NULL,`contentType` VARCHAR(255) NULL)";
NSString*const DT_SQL_Approve = @"DELETE FROM tbl_approve";
NSString*const D_SQL_Approve = @"DELETE FROM tbl_approve WHERE boardId=?";
NSString*const R_SQL_Approve = @"REPLACE INTO `tbl_approve`( `createTime`, `mobile`, `name`, `contentType`) VALUES (?,?,?,?)";
NSString*const S_SQL_Approve = @"SELECT * FROM tbl_approve";

//电话会议数据库
NSString*const CT_SQL_MEETING=@"CREATE TABLE `tbl_meeting`(`meetingId` VARCHAR(255) NULL,`creatUserId` VARCHAR(255) NULL,`meetingTitle` VARCHAR(255) NULL, `meetingPwd` VARCHAR(255) NULL, `meetingIsCommon` VARCHAR(255) NULL, `meetingLastTime` VARCHAR(255) NULL, `meetingConnectType` VARCHAR(255) NULL,`meetingUserJson` TEXT NULL, PRIMARY KEY (`meetingId`))";
NSString*const DT_SQL_MEETING=@"DELETE FROM tbl_meeting";
//根据会议id删除会议
NSString*const DM_SQL_MEETING=@"DELETE FROM tbl_meeting WHERE meetingId=?";
//根据用户id删除该用户下所有的会议
NSString*const DU_SQL_MEETING=@"DELETE FROM tbl_meeting WHERE creatUserId=?";

NSString*const R_SQL_MEETING=@"REPLACE INTO `tbl_meeting`(`meetingId`, `creatUserId`, `meetingTitle`, `meetingPwd`, `meetingIsCommon` , `meetingLastTime` , `meetingConnectType` , `meetingUserJson`) VALUES (?,?,?,?,?,?,?,?)";
//根据用户id获取该用户在设备上的所有会议记录
NSString*const S_SQL_MEETING=@"SELECT * FROM tbl_meeting WHERE creatUserId=?";

//根据会议id获取该会议记录
NSString*const SI_SQL_MEETING=@"SELECT * FROM tbl_meeting WHERE meetingId=?";



//电话会议记录数据库
NSString*const CT_SQL_HISTORY_MEETING=@"CREATE TABLE `tbl_history_meeting`(`meetingId` VARCHAR(255) NULL,`creatUserId` VARCHAR(255) NULL,`meetingTitle` VARCHAR(255) NULL, `meetingPwd` VARCHAR(255) NULL, `meetingIsCommon` VARCHAR(255) NULL, `meetingLastTime` VARCHAR(255) NULL, `meetingConnectType` VARCHAR(255) NULL,`meetingUserJson` TEXT NULL, PRIMARY KEY (`meetingId`))";
NSString*const DT_SQL_HISTORY_MEETING=@"DELETE FROM tbl_history_meeting";
//根据会议id删除会议
NSString*const DM_SQL_HISTORY_MEETING=@"DELETE FROM tbl_history_meeting WHERE meetingId=?";
//根据用户id删除该用户下所有的会议
NSString*const DU_SQL_HISTORY_MEETING=@"DELETE FROM tbl_history_meeting WHERE creatUserId=?";

NSString*const R_SQL_HISTORY_MEETING=@"REPLACE INTO `tbl_history_meeting`(`meetingId`, `creatUserId`, `meetingTitle`, `meetingPwd`, `meetingIsCommon` , `meetingLastTime` , `meetingConnectType` , `meetingUserJson`) VALUES (?,?,?,?,?,?,?,?)";
//根据用户id获取该用户在设备上的所有会议记录
NSString*const S_SQL_HISTORY_MEETING=@"SELECT * FROM tbl_history_meeting WHERE creatUserId=?";

//根据会议id获取该会议记录
NSString*const SI_SQL_HISTORY_MEETING=@"SELECT * FROM tbl_history_meeting WHERE meetingId=?";




NSString* const NOTIFICATION_RELOADVOIPLIST=@"NOTIFICATION_RELOADVOIPLIST";

NSString* const NOTIFICATION_ENTERPRISECONTACT_FINISHED_LOAD=@"NOTIFICATION_ENTERPRISECONTACT_FINISHED_LOAD";
NSString* const NOTIFICATION_R_SQL_MESSAGE=@"NOTIFICATION_R_SQL_MESSAGE";
NSString* const NOTIFICATION_D_SQL_MESSAGE=@"NOTIFICATION_D_SQL_MESSAGE";
NSString* const NOTIFICATION_R_SQL_GROUPUSER=@"NOTIFICATION_R_SQL_GROUPUSER";

NSString* const NOTIFICATION_D_SQL_GROUPUSER_RELOAD=@"NOTIFICATION_D_SQL_GROUPUSER_RELOAD";
NSString* const NOTIFICATION_D_SQL_GROUPUSER_NOT_RELOAD =@"NOTIFICATION_D_SQL_GROUPUSER_NOT_RELOAD";

NSString* const NOTIFICATION_U_SQL_GROUP =@"NOTIFICATION_U_SQL_GROUP";
NSString* const NOTIFICATION_D_SQL_GROUP=@"NOTIFICATION_D_SQL_GROUP";
NSString* const NOTIFICATION_R_SQL_USER=@"NOTIFICATION_R_SQL_USER";
NSString* const NOTIFICATION_D_SQL_USER=@"NOTIFICATION_D_SQL_USER";

NSString* const NOTIFICATION_D_SQL_DEPT=@"NOTIFICATION_D_SQL_DEPT";
NSString* const NOTIFICATION_R_SQL_DEPT=@"NOTIFICATION_R_SQL_DEPT";

NSString *const NOTIFICATION_VIEWCONTROLLER_CHANGE=@"NOTIFICATION_VIEWCONTROLLER_CHANGE";
NSString* const NOTIFICATION_R_SQL_FILE=@"NOTIFICATION_R_SQL_FILE";


NSString* const NOTIFICATION_U_SQL_MESSAGE_READSTATE=@"NOTIFICATION_U_SQL_MESSAGE_READSTATE";
NSString* const NOTIFICATION_U_SQL_MESSAGE_SENDSTATE=@"NOTIFICATION_U_SQL_MESSAGE_SENDSTATE";

@end
