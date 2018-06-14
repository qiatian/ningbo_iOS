//
//  MQTTManager.m
//  IM
//
//  Created by syj on 14-9-25.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "MQTTManager.h"
#import "OpenCoreAmrManager.h"
#import "SQLiteManager.h"
#import "JSMessageSoundEffect.h"
#import "ZTENotificationModal.h"
#import "ZTEBoardNotificationDataSource.h"
#import "NSString+Helpers.h"
#import "SettingModel.h"
static MQTTManager *sSharedInstance;
static dispatch_once_t onceToken;

@implementation MQTTManager

+(MQTTManager *)sharedInstance{
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[MQTTManager alloc] init];
    });
    
    return sSharedInstance;
}


#pragma mark 初始化方法
-(id)init{
    self=[super init];
    if(self){

    }
    return self;
}

//-(void)destroyConnect{
//    [self.mqttClient destroyConnect];
//}

-(void)disconnect{
    [self.mqttClient disconnect];
}

//topic填写接收方id
- (void)connect
{
    NSString *clientID =[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary  objectForKey:@"uid"]];
    if (clientID && clientID.length>0) {
//        if(!self.mqttClient)
//        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
            [dic setObject:kMQTTServerHost forKey:kMQTTBrokerHostKey];
            [dic setObject:kMQTTPort forKey:kMQTTBrokerPortKey];
            self.mqttClient = [[MosquittoClient alloc] initWithIdentifier:clientID brokerInfo:dic delegate:self];
            [self.mqttClient setUsername:[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"] password:[[ConfigManager sharedInstance].userDictionary objectForKey:@"mqttpwd"]];
//        }
        [self.mqttClient connect];
    }
}


-(void)reconnect
{
    [self.mqttClient reConnect];
}


+(long long)byteArrayToLongLong:(unsigned char[])b{
    long long value= 0;
    for (int i = 0; i < 4; i++) {
        int shift= (4 - 1 - i) * 8;
        value +=(b[i] & 0x000000FF) << shift;
    }
    return value;
}

/*     各字段的含义
 
 JSON里各Key值的代表含义：
 "type" ：//0普通点对点，1普通群聊，2 修改群群名，3添加成员消息，4退群消息，5删除成员消息，6删除群  7系统创建群消息，10点赞，11评论，12转发，13邀请加入圈子，14关注好友，15@提到我，16系统消息 17
 会议通知
 “headpicurl” ：发送者的头像url
 "msg" ： 发送信息的内容，表情和文字 都包含
 “face” : 发送信息里是否包含头像。true ：包含。false：不包含。
 “username” ： 发送者的名字
 “keyid” ：发送者的UID
 “bigpicurl” ： 传输过程中的大图片url
 “minipicurl” ：传输过程中的小图片url
 ”voicelength“  传输语音的长度
 “operatorid” ：被操作者的uid。在群组操作里 被添加的人 被删除的人等需要此字段。
 ”adminid“   ： 该群组的创建者（群主） 在退出该群组的时候 会指定列表的下一个人为群主，拥有删除该群组内其他人的权限。
 ”adminname“ ：相对应 adminid这个人的 姓名
 ”contenttype“ ：接收到的信息内容类型。0：文字内容；1：文件；2：图片；3：语音；5：视频  7：用户更改头像，通知其他用户更新。
 ”sessionid“ 会话ID
 ”sessionname“ 会话名称。
 "filelength"
 "operatorid"
 "modeltype":0 企信，1微博
 */
- (void)sendMMessage:(MMessage *)msg voiceData:(NSData *)voiceData notificationName:(NSString *)notificationName{
    
//    [SettingModel getMessageSoundShock];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //发送
        [[SQLiteManager sharedInstance] insertMessagesToSQLite:[NSArray arrayWithObject:msg] notificationName:notificationName];
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        if(msg.msgId && msg.msgId.length>0){
            [parameters setObject:msg.msgId forKey:@"msgchatid"];
        }

        if (msg.headpicurl &&msg.headpicurl.length>0) {
            [parameters setObject:msg.headpicurl forKey:@"headpicurl"];
            [parameters setObject:[NSNumber numberWithBool:YES] forKey:@"face"];
        }
        else
        {
            [parameters setObject:[NSNumber numberWithBool:YES] forKey:@"face"];
        }
        if (msg.sessionid&&msg.sessionid.length>0) {
            [parameters setObject:[msg.sessionid hasPrefix:@"g"]?[msg.sessionid substringFromIndex:1]:msg.sessionid forKey:@"sessionid"];
        }
        if (msg.sessionname &&msg.sessionname.length) {
            [parameters setObject:msg.sessionname forKey:@"sessionname"];
        }
        
        if (msg.type&&msg.type.length) {
            [parameters setObject:[NSNumber numberWithInt:[msg.type intValue]] forKey:@"type"];
        }

        [parameters setObject:[[ConfigManager sharedInstance].userDictionary  objectForKey:@"name"] forKey:@"username"];
        [parameters setObject:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary  objectForKey:@"uid"]] forKey:@"keyid"];
        
        if (msg.contenttype&&msg.contenttype.length>0) {
            [parameters setObject:[NSNumber numberWithInt:[msg.contenttype intValue]] forKey:@"contenttype"];
        }
        
        if (msg.bigpicurl&& msg.bigpicurl.length>0) {
            [parameters setObject:msg.bigpicurl forKey:@"bigpicurl"];
        }
        
        if (msg.minipicurl&&msg.minipicurl.length>0) {
            [parameters setObject:msg.minipicurl forKey:@"minipicurl"];
        }
        
        if (msg.filelength && msg.filelength.length>0) {
            [parameters setObject:[NSNumber numberWithLongLong:[msg.filelength doubleValue]] forKey:@"filesize"];
        }
        
        if (msg.operatorid&&msg.operatorid.length>0) {
            [parameters setObject:msg.operatorid forKey:@"operatorid"];
        }
        if (msg.adminid&&msg.adminid.length>0) {
            [parameters setObject:msg.adminid forKey:@"adminid"];
        }
        if (msg.adminname&&msg.adminname.length>0) {
            [parameters setObject:msg.adminname forKey:@"adminname"];
        }
        
//        if (msg.modeltype&&msg.modeltype.length>0) {
//            [parameters setObject:msg.modeltype forKey:@"modeltype"];
//        }
        
        if (msg.voicelength&&msg.voicelength.length>0) {
            [parameters setObject:[NSNumber numberWithLongLong:[msg.voicelength doubleValue]] forKey:@"voicelength"];
        }

        if ([msg.contenttype intValue]==MMessageContentTypeVoice) {
            [parameters setObject:@"[语音]" forKey:@"msg"];
        }else if([msg.contenttype intValue]==MMessageContentTypeVideo){
            [parameters setObject:@"[视频]" forKey:@"msg"];
        }else if ([msg.contenttype intValue]==MMessageContentTypeFile){
            [parameters setObject:@"[文件]" forKey:@"msg"];
        }else if ([msg.contenttype intValue]==MMessageContentTypePhoto){
            [parameters setObject:@"[图片]" forKey:@"msg"];
        }else if ([msg.contenttype intValue]==MMessageContentTypeUpdateAvatar){
            [parameters setObject:@"[更换头像]" forKey:@"msg"];
        }else{
            [parameters setObject:msg.msg forKey:@"msg"];
        }
        //]stringByReplacingOccurrencesOfString:@" " withString:@""
        NSString *parameterStr2 = [[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error: nil] encoding:NSUTF8StringEncoding]stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        NSString *parametersWithLength  = [NSString stringWithFormat:@"%d#%@",[parameterStr2 dataUsingEncoding:NSUTF8StringEncoding].length,parameterStr2];
        NSMutableData *parametersWithLengthData = [NSMutableData dataWithData:[parametersWithLength dataUsingEncoding:NSUTF8StringEncoding]];
        if (voiceData) {
            [parametersWithLengthData appendData:voiceData];
        }
        
//        NSString *topicString =[msg.sessionid hasPrefix:@"g"]?[msg.sessionid substringFromIndex:1]:msg.sessionid;
        NSString *topicString = msg.sessionid;
        
        __block MosquittoMessage *mqttMsg = [[MosquittoMessage alloc] initWithMessageTopic:topicString payload:parametersWithLength payloadData:parametersWithLengthData  qualityOfServiceLevel:1];

        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error;
            BOOL publishSuccess= [self.mqttClient publish:mqttMsg error:&error];

            if (!publishSuccess || error) {

                msg.srState = [NSString stringWithFormat:@"%d",MMessageSRStateSendFailed];
                [[SQLiteManager sharedInstance] updateMessageSendStateByMsgId:msg.msgId isSendSuccess:NO notificationName:NOTIFICATION_U_SQL_MESSAGE_SENDSTATE];
            }
        });
        
    });
}

#pragma mark mqtt委托
- (void)mosquittoClient:(MosquittoClient *)client didReceiveConnectionResponse:(MosquittoConnectionResponse)responseStatus
{
    _responseStatus = responseStatus;
    if (responseStatus!= MosquittoConnectionResponseSuccessful) {
        
        if([ConfigManager sharedInstance].isLogin)
        {
            [self connect];
        }
    }else{
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray *sendingMsgs =[[SQLiteManager sharedInstance] getSendingMessages];
            
            for (MMessage *mm in sendingMsgs) {
                NSData *amrData =nil;
                if ([mm.contenttype intValue]==MMessageContentTypeVoice) {
                    amrData= [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:mm.amrPath]];
                }
                [[MQTTManager sharedInstance] sendMMessage:mm voiceData:amrData notificationName:NOTIFICATION_R_SQL_MESSAGE];
            }
        });
    }
}

- (void)mosquittoClientDidDisconnect:(MosquittoClient *)client errorCode:(int)rc
{
    
    if([ConfigManager sharedInstance].isLogin)
    {
//        if(rc == 7)
//        {
//            //被抢登了哟
//            [self exitAndDelBtnClick];
//        }
//        else
//        {
            //只有登录上之后掉线才需要重练，如果是手动退出登录，
            if ([AFNetworkReachabilityManager sharedManager].reachable) {
                if (self.responseStatus == MosquittoConnectionResponseSuccessful) {
//                    [self reconnect];
                    [self connect];
                }
            }
//        }
    }
}

- (void)mosquittoClient:(MosquittoClient *)client didPublishMessage:(MosquittoMessage *)message
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (message.payload_data.length < 6) {
            return;
        }
        
        NSString *headStr = [[NSString alloc] initWithData:[message.payload_data subdataWithRange:NSMakeRange(0, 6)]  encoding:NSUTF8StringEncoding];
        NSString *jsonStr=nil;
        NSUInteger seperatorLocation =[headStr rangeOfString:@"#"].location ;
        if(seperatorLocation !=NSNotFound) {
            NSString *dataLength = [[headStr componentsSeparatedByString:@"#"] objectAtIndex:0];
            NSData *jsonData = [message.payload_data subdataWithRange:NSMakeRange(seperatorLocation+1, [dataLength integerValue])];
            jsonStr = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
        }
        
        
        if (!jsonStr) {
            return;
        }
        
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        if (jsonDict) {
            NSString *msgId=[jsonDict objectForKey:@"msgchatid"];
            if (msgId && msgId.length>0) {
                [[SQLiteManager sharedInstance] updateMessageSendStateByMsgId:msgId isSendSuccess:YES notificationName:NOTIFICATION_U_SQL_MESSAGE_SENDSTATE];
            }
        }
    });
}

#pragma mark  接收到聊天消息
- (void)mosquittoClient:(MosquittoClient *)client didReceiveMessage:(MosquittoMessage *)message
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (message.payload_data.length < 6) {
            return;
        }
        
        NSString *headStr = [[NSString alloc] initWithData:[message.payload_data subdataWithRange:NSMakeRange(0, 6)]  encoding:NSUTF8StringEncoding];
        NSString *jsonStr=nil;
        NSData *voiceData=nil;
        NSUInteger seperatorLocation =[headStr rangeOfString:@"#"].location ;
        long long msgtime =(long long)[[NSDate date] timeIntervalSince1970]*1000;
        
        if(seperatorLocation !=NSNotFound) {
            NSString *dataLength = [[headStr componentsSeparatedByString:@"#"] objectAtIndex:0];
            NSData *jsonData = [message.payload_data subdataWithRange:NSMakeRange(seperatorLocation+1, [dataLength integerValue])];
            jsonStr = [[NSString alloc] initWithData:jsonData  encoding:NSUTF8StringEncoding];
            int timeLen=5;
            NSUInteger leftLen=message.payload_data.length-1-seperatorLocation-[dataLength integerValue];
            if (leftLen<timeLen) {
                //没有语音，没有时间
            }else if(leftLen>=timeLen){
                //有时间
                NSData *timeData =[message.payload_data subdataWithRange:NSMakeRange(message.payload_data.length - timeLen, timeLen)];
                Byte time5Byte[5];
                Byte time4Byte[4];
                [timeData getBytes:time5Byte range:NSMakeRange(0, 5)];
                [timeData getBytes:time4Byte range:NSMakeRange(1, 4)];
                int signer =time5Byte[0];
                if (signer==1) {//0在线，1离线
                    msgtime =[MQTTManager byteArrayToLongLong:time4Byte]*1000;
                }
                
                if (leftLen>timeLen) {
                    //有语音
                    voiceData = [message.payload_data subdataWithRange:NSMakeRange(seperatorLocation+1+[dataLength integerValue], message.payload_data.length-1-seperatorLocation-[dataLength integerValue]-timeLen)];
                }
            }
        }

        if (!jsonStr) {
            return;
        }
        //系统自带JSON解析
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        if (jsonDict) {
            
            MMessage *mm = [[MMessage alloc]init];
            mm.identity =[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
            mm.msgId =[NSString stringWithUUID];
            mm.modeltype =[jsonDict objectForKey:@"modeltype"];
            mm.contenttype=[jsonDict objectForKey:@"contenttype"];
            mm.msg =[jsonDict objectForKey:@"msg"];
            mm.bigpicurl =[jsonDict objectForKey:@"bigpicurl"];
            mm.minipicurl =[jsonDict objectForKey:@"minipicurl"];
            mm.filelength =[jsonDict objectForKey:@"filesize"];
            mm.operatorid =[jsonDict objectForKey:@"operatorid"];
            mm.keyid=[jsonDict objectForKey:@"keyid"];
            mm.username =[jsonDict objectForKey:@"username"];
            mm.type =[jsonDict objectForKey:@"type"];
            mm.sessionname=[jsonDict objectForKey:@"sessionname"];
            mm.headpicurl=[jsonDict objectForKey:@"headpicurl"];
            NSString *sessionid =[jsonDict objectForKey:@"sessionid"];
            NSString *msgVoiceId = sessionid;//免打扰中，单人免打扰与群组免打扰用的字段不一样，单人用的keyid来匹配，群组用的sessionid
            if (sessionid && sessionid.length>0) {
                if ([mm.type intValue]==MMessageTypeChat) {
                    mm.sessionid =sessionid;
                    mm.msgOtherId =mm.keyid;
                    mm.msgOtherName =mm.username;
                    mm.msgOtherAvatar=mm.headpicurl;
                    msgVoiceId = mm.keyid;
                }else{
                    mm.sessionid = [NSString stringWithFormat:@"g%@",sessionid];
                    mm.msgOtherId = mm.sessionid;
                    mm.msgOtherName = mm.sessionname;
                }
            }
            if([mm.contenttype intValue] == MMessageContentTypeNotice && [mm.type intValue]==MMessageTypeGroupChat){
//                //如果是公告，则修改数据获取方式，看不懂后台怎么输出的，妈的。。。。
//                mm.sessionid = [NSString stringWithFormat:@"g%@",[jsonDict objectForKey:@"groupid"]];
//                mm.msgOtherId = mm.sessionid;
//                mm.msgOtherName = @"群组公告";
//                mm.msg = [jsonDict objectForKey:@"title"];
                return;//如果是公告，暂时什么都不处理，直接返回把，不知道如何破这个公告的显示，妈的
            }
            
            mm.sendTime =[NSString stringWithFormat:@"%lld",msgtime];
            
            NSString *time = [NSString timeStringForTimeGettedFromServer:@(mm.sendTime.longLongValue) timeFormatter:@"MM-dd HH:mm:ss"];
            
            NSLog(@"%@",time);
            
//            mm.sendTime=[jsonDict objectForKey:@"mqttSendTime"];
            mm.adminid =[jsonDict objectForKey:@"adminid"];
            mm.adminname =[jsonDict objectForKey:@"adminname"];
            mm.srState =[NSString stringWithFormat:@"%d",MMessageSRStateReceiveUnread];
            
            if ([mm.type intValue]== MMessageTypeCreateGroup||[mm.type intValue]== MMessageTypeModifyGroup||[mm.type intValue]== MMessageTypeInviteGroup||[mm.type intValue]== MMessageTypeQuitGroup||[mm.type intValue]== MMessageTypeRemoveGroupMember||[mm.type intValue]== MMessageTypeRemoveGroup) {
                //妈的，所有涉及到修改群组的消息的，全他妈重新拉取群组消息，不然数据库没法处理了，草草草
                if([mm.type intValue]== MMessageTypeRemoveGroupMember)
                {
                    //被移除的是自己
                    
                    NSString *operatorids = [jsonDict objectForKey:@"operatorid"];
                    NSArray *operatoridArr = [operatorids componentsSeparatedByString:@","];
                    
                    BOOL isRemoveSelf = NO;
                    
                    for (NSString *operator in operatoridArr) {
                        
                        if ([operator isEqualToString:mm.identity]) {
                            isRemoveSelf = YES;
                            break;
                        }
                    }
                    
                    if (isRemoveSelf) {
                        //删除 群组成员表 中的userid
                        [[SQLiteManager sharedInstance] deleteGroupUserId:mm.identity groupId:sessionid notificationName:NOTIFICATION_D_SQL_GROUPUSER_NOT_RELOAD];
                        //删除 群组表 中的gropuid
                        [[SQLiteManager sharedInstance] deleteGroupId:sessionid notificationName:NOTIFICATION_D_SQL_GROUP];
                        //删除 消息表 中的message
//                        [[SQLiteManager sharedInstance] deleteGroupMessagesWithSessionId:mm.sessionid notificationName:NOTIFICATION_R_SQL_MESSAGE];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"userRemovedFromGroup" object:nil userInfo:@{@"groupid":sessionid}];
                    }
                    else
                    {
                        [[SQLiteManager sharedInstance] deleteGroupUserId:mm.identity groupId:sessionid notificationName:NOTIFICATION_D_SQL_GROUPUSER_NOT_RELOAD];
                    }

                }else if ([mm.type intValue]== MMessageTypeModifyGroup)
                {
                    //更新群name
                    [[SQLiteManager sharedInstance] updateGroupName:mm.sessionname groupId:sessionid notificationName:NOTIFICATION_U_SQL_GROUP];
                }
                else if ([mm.type intValue]== MMessageTypeInviteGroup)
                {
                    //非自己邀请的，需要更新到数据库
                    if(![mm.keyid isEqualToString:mm.identity])
                    {
                        NSArray *array = [[jsonDict objectForKey:@"operatorid"] componentsSeparatedByString:@","];
                        
                        if ([array count]>0) {
//                            [self loadGroupContacts];
                            for (NSString *operatorid in array) {
                                
                                if ([operatorid isEqualToString:mm.identity]) {
                                    
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"invitedToJoin" object:nil userInfo:@{@"groupid":sessionid}];
                                    
                                }
                                
                            }
                            
                        }
                    }
                }
                else if ([mm.type intValue]== MMessageTypeQuitGroup)
                {
                    //退出的是自己
                    if ([mm.keyid isEqualToString:mm.identity]) {
                        [[SQLiteManager sharedInstance] deleteGroupId:sessionid notificationName:NOTIFICATION_D_SQL_GROUP];
                        [[SQLiteManager sharedInstance] deleteGroupMessagesWithSessionId:mm.sessionid notificationName:NOTIFICATION_R_SQL_MESSAGE];
                    }
                    else
                    {
                        [[SQLiteManager sharedInstance] deleteGroupUserId:mm.identity groupId:sessionid notificationName:NOTIFICATION_D_SQL_GROUPUSER_NOT_RELOAD];
                    }
                }
                //创建群组
                else if ([mm.type integerValue] == MMessageTypeCreateGroup){
                    
                    if ([mm.keyid isEqualToString:mm.identity]) {
                        //把刚创建的群组放入到con里面保存一下
                        [ConfigManager sharedInstance].createGroupId = sessionid;
                        
                    }
                    
                }
                [self loadGroupContacts];
            }
            
            //聊天消息推送
            if ([mm.modeltype intValue] == 0) {
                UIApplicationState state= [UIApplication sharedApplication].applicationState;

                if ( state==UIApplicationStateInactive||state==UIApplicationStateBackground) {
                    [self sendLocalNotificationWithStr:mm.msg];
                }
                int contenttype =[mm.contenttype intValue];
                if (contenttype==MMessageContentTypeUpdateAvatar) {
                    MEnterpriseUser *auser =[[MEnterpriseUser alloc] init];
                    auser.uid =[jsonDict objectForKey:@"uid"];
                    auser.bigpicurl =[jsonDict objectForKey:@"bigpicurl"];
                    auser.minipicurl =[jsonDict objectForKey:@"minipicurl"];
                    [[SQLiteManager sharedInstance] updateUserAvatar:auser];
                    
                }
                else{
                    if (contenttype==MMessageContentTypeVoice) {
                        long long fileName =(long long)[[NSDate date] timeIntervalSince1970]*1000+arc4random();
                        NSString *amrFile = [NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"%lld.%@", fileName, @"amr"]];
                        [voiceData writeToFile:amrFile atomically:YES];
                        if(![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",APPCachesDirectory,@"tmp/chatVoice"]])
                        {
                            [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",APPCachesDirectory,@"tmp/chatVoice"] withIntermediateDirectories:YES attributes:nil error:nil];
                        }
                        NSString *wavFile =[[NSString stringWithFormat:@"%@/%@",APPCachesDirectory,@"tmp/chatVoice/"] stringByAppendingPathComponent:[NSString stringWithFormat: @"%lld.%@", fileName, @"wav"]];
                        [OpenCoreAmrManager amrToWav:amrFile wavSavePath:wavFile];
                        
                        [[NSFileManager defaultManager] removeItemAtPath:amrFile error:nil];
                        mm.wavPath =wavFile;
                        mm.amrPath=amrFile;
                        mm.voicelength =[jsonDict objectForKey:@"voicelength"];
                    }else if (contenttype==MMessageContentTypeVideo || contenttype==MMessageContentTypeFile || contenttype==MMessageContentTypePhoto){
                        /*
                        NSString *fileExt =[[mm.bigpicurl lastPathComponent] pathExtension];
                        MFile *mf=[[MFile alloc] init];
                        mf.fileId =[[mm.bigpicurl lastPathComponent] stringByDeletingPathExtension];
                        mf.fileExt =fileExt;
                        mf.fileName=mm.msg;
                        mf.fileSize=mm.filelength;
                        mf.fileFromId=mm.keyid;
                        mf.fileFromName= mm.username;
                        if ([fileExt isEqualToString:@"doc"]|| [fileExt isEqualToString:@"docx"]
                            ||[fileExt isEqualToString:@"xls"] || [fileExt isEqualToString:@"xlsx"]
                            ||[fileExt isEqualToString:@"ppt"]||[fileExt isEqualToString:@"pptx"]
                            ||[fileExt isEqualToString:@"txt"]
                            ||[fileExt isEqualToString:@"pdf"]) {
                            mf.fileType =[NSString stringWithFormat:@"%d",MMFileTypeDocument];
                        }else if ([fileExt isEqualToString:@"jpg"]||[fileExt isEqualToString:@"png"]){
                            mf.fileType=[NSString stringWithFormat:@"%d",MMFileTypePhoto];
                        }else if ([fileExt isEqualToString:@"MOV"]||[fileExt isEqualToString:@"3gp"]){
                            mf.fileType =[NSString stringWithFormat:@"%d",MMFileTypeVideo];
                        }else{
                            mf.fileType=[NSString stringWithFormat:@"%d",MMFileTypeUnknown];
                        }
                        
                        mf.fileUrl =mm.bigpicurl;
                        mf.createdTime=mm.sendTime;
                         
                        
                        [[SQLiteManager sharedInstance] insertFilesToSQLite:[NSArray arrayWithObject:mf] notificationName:NOTIFICATION_R_SQL_FILE];
                         */
                        
                    }
                    //忽略部分消息
//                    if ([mm.type intValue]== MMessageTypeQuitGroup||[mm.type intValue]== MMessageTypeRemoveGroupMember||[mm.type intValue]== MMessageTypeRemoveGroup)
//                    {
//                        MGroupUser *groupUser =[[[SQLiteManager sharedInstance] getAllOnlyGroups] objectForKey:sessionid];
//                        if (groupUser) {
//                            if(![[[[NSUserDefaults standardUserDefaults] objectForKey:SettingDisturbKey] objectForKey:msgVoiceId] boolValue])
//                            {
//                                //接收到信息声音
//                                [JSMessageSoundEffect playMessageReceivedAlert];
//                            }
//
//                            [[SQLiteManager sharedInstance] insertMessagesToSQLite:[NSArray arrayWithObject:mm] notificationName:NOTIFICATION_R_SQL_MESSAGE];
//                        }
//                    }
//                    else
//                    {
                        if(![[[[NSUserDefaults standardUserDefaults] objectForKey:SettingDisturbKey] objectForKey:msgVoiceId] boolValue])
                        {
                            //接收到信息声音
                            [SettingModel getMessageSoundShock];
                        }
                        [[SQLiteManager sharedInstance] insertMessagesToSQLite:[NSArray arrayWithObject:mm] notificationName:NOTIFICATION_R_SQL_MESSAGE];
//                    }
                }
            }
            else if ([mm.modeltype intValue] == 3 && [mm.contenttype intValue] != 3) {//会议通知推送
                
                //所有的通知用一个标记来表示，防止与其他信息冲突
           
                //通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotiStatusChangeNotification" object:nil];
                mm.msgOtherName = LOCALIZATION(@"Message_myNotification");
                mm.msgOtherId = NotiOhterId;
                [[SQLiteManager sharedInstance] insertMessagesToSQLite:[NSArray arrayWithObject:mm] notificationName:NOTIFICATION_R_SQL_MESSAGE];
                
            }
            else if([mm.modeltype intValue] != 5&&[mm.contenttype intValue] == 3){
                    NSLog(@"************&&&&&&&&&^^^^^^^^^^^^%%%%%%%%%%% %");
               [[NSNotificationCenter defaultCenter] postNotificationName:@"NotiStatusChangeNotification" object:mm];
                
                //1 更新本地数据,更新通知列表
                //2 发布广播    通知界面需要接收，通知详情界面需要接收
                 mm.msgOtherName = LOCALIZATION(@"Message_myNotification");
                 mm.msgOtherId = NotiOhterId;
                [[SQLiteManager sharedInstance] insertMessagesToSQLite:[NSArray arrayWithObject:mm] notificationName:NOTIFICATION_R_SQL_MESSAGE];
                    
                }
            else if ([mm.modeltype intValue] == 5){//宁波推送
               
                NSString *msg;
                if ([mm.contenttype intValue] == 4) {//小黑板
                    msg = jsonDict[@"msg"];
                }
                if ([mm.contenttype integerValue]==0) {//审批
                    msg=jsonDict[@"content"];
                }
                if ([mm.contenttype integerValue]==1) {//任务派发
                    NSLog(@"新建任务");
                    msg=jsonDict[@"msg"];
                }
                if ([mm.contenttype integerValue]==2) {//已延期的任务
                    NSLog(@"已延期的任务");
                    msg=jsonDict[@"msg"];
                    NSDictionary *modal = [NSJSONSerialization JSONObjectWithData:[msg dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                    [[SQLiteManager sharedInstance] updateBoardsStatus:@"DELAYED" withTaskId:modal[@"taskId"] withUid:[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"] notificationName:nil];
                    [NotiCenter postNotificationName:@"TaskDelay" object:nil userInfo:modal];
                }
                if ([mm.contenttype integerValue]==3) {//快到期的任务推送
                    NSLog(@"快到期的任务推送");
                    msg=jsonDict[@"msg"];
                    NSDictionary *modal = [NSJSONSerialization JSONObjectWithData:[msg dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                    [NotiCenter postNotificationName:@"TaskPrompt" object:nil userInfo:modal];
                }
                if ([mm.contenttype intValue] == 4) {
                    
                    [self dealWithNotification:msg contentType:mm.contenttype];
                    
                }
                
                if ([mm.contenttype intValue] == 1) {
                    
                    [self dealWithNotification:msg contentType:mm.contenttype];
                }
                
            }
        }
    });
}

- (void)dealWithNotification:(NSString*)msg contentType:(NSString*)contentType{
    
    NSDictionary *modal = [NSJSONSerialization JSONObjectWithData:[msg dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    ZTENotificationModal *notifiModal = [[ZTENotificationModal alloc] initWithNotificationModal:modal contentType:contentType];
    
    ZTEBoardNotificationDataSource *dataSource = [ZTEBoardNotificationDataSource sharedInstance];
    NSMutableArray *array = [NSMutableArray arrayWithArray:dataSource.boardDataArray];
    [array addObject:notifiModal];
    //KVO
//    [dataSource setValue:array forKeyPath:@"boardDataArray"];
    
    dataSource.boardDataArray = array;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dealNoti" object:nil];
    
}

- (void)mosquittoClient:(MosquittoClient *)client didSubscribe:(MosquittoMessage *)message
{
    NSLog(@"didSubscribe==%@",message.payload);
}
- (void)mosquittoClient:(MosquittoClient *)client didUnsubscribe:(MosquittoMessage *)message
{
    NSLog(@"didUnsubscribe==%@",message.payload);
}


-(void)loadGroupContacts{
    NSString *myToken =[[ConfigManager sharedInstance].userDictionary  objectForKey:@"token"];
    [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodFindGroup] parameters:[NSDictionary dictionaryWithObject:myToken forKey:@"token"] successBlock:^(BOOL success, id data, NSString *msg) {
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

- (void)exitAndDelBtnClick
{
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SQLiteManager sharedInstance] clearTableWithNames:[NSArray arrayWithObjects:@"tbl_company",@"tbl_dept",@"tbl_user",@"tbl_group", @"tbl_groupuser",nil]];
        NSMutableDictionary *loginDictionary =[NSMutableDictionary dictionaryWithDictionary:[ConfigManager sharedInstance].loginDictionary];
        if (loginDictionary && loginDictionary.count>0) {
            [loginDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"isAutoLogin"];
            [ConfigManager sharedInstance].loginDictionary =loginDictionary;
        }else{
            [ConfigManager sharedInstance].loginDictionary =[NSDictionary dictionary];
        }
        
        [[ConfigManager sharedInstance] clearALLConfig];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[MQTTManager sharedInstance].mqttClient stopNetworkEventLoop];
            [[MQTTManager sharedInstance].mqttClient disconnect];
            [MQTTManager sharedInstance].mqttClient = nil;
            [((AppDelegate *)[UIApplication sharedApplication].delegate) gotoLoginController];
        });
    });
}

-(void)sendLocalNotificationWithStr:(NSString*)str{
    
    UILocalNotification *localNotification = [[UILocalNotification alloc]init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    localNotification.alertBody = str;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber +1;
    [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
    
}



@end