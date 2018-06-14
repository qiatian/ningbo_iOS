//
//  CCPManager.m
//  Voip
//
//  Created by luhao on 15-5-07.
//  Copyright (c) 2015年 luhao.com. All rights reserved.
//

#import "CCPManager.h"
#import "AudioConferenceViewController.h"
#import "VoipViewController.h"

//http://docs.yuntongxun.com/index.php/IOS_SDK   ios云通讯文档地址

@implementation CCPManager
@synthesize voipCallService;

//实现单例
+ (CCPManager *)ShareInstance
{
    static CCPManager *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[super allocWithZone:NULL]init];
        //share = [[super alloc]init];
    });
    return share;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        voipCallService = [[CCPCallService alloc] init];
        [voipCallService setDelegate:self];
    }
    return self;
}

//有呼叫进入 voip
- (void)onIncomingCallReceived:(NSString*)callid withCallerAccount:(NSString *)caller withCallerPhone:(NSString *)callerphone withCallerName:(NSString *)callername withCallType:(NSInteger)calltype
{
    NSLog(@"onIncomingCallReceived callid=%@ caller=%@ callerphone=%@ callername=%@ calltype=%d", callid, caller, callerphone, callername, calltype);
    
    if (self.callStatusResult != ECallStatus_NO && self.callStatusResult != ECallStatus_Released)
    {
        [voipCallService rejectCall:callid andReason:EReasonBusy];//通话中来电直接拒绝掉，客户可以根据自己需要进行处理
        self.rejectCallId = callid;
        return;
    }
    
    self.callStatusResult = ECallStatus_Incoming;

    VoipViewController *audioConference = [[VoipViewController alloc] init];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    audioConference.hidesBottomBarWhenPushed = YES;
    audioConference.callType = 1;
    audioConference.callID = callid;
    audioConference.callerAccount = caller;
    audioConference.voipType = calltype;
    audioConference.view.alpha = 0.1;
    GQNavigationController *audioCallNav =[[GQNavigationController alloc] initWithRootViewController:audioConference];
    [delegate.mainNav presentViewController:audioCallNav animated:NO completion:^{
        [UIView animateWithDuration:0.6 animations:^{
            audioConference.view.alpha = 1;
        }];
    }];
}


- (NSInteger)connectCCPService
{
    return [voipCallService connectToCCP:KVoipHostAddress onPort:KVoipHostPort withAccount:[[ConfigManager sharedInstance].userDictionary objectForKey:@"viopId"] withPsw:[[ConfigManager sharedInstance].userDictionary objectForKey:@"viopPwd"] withAccountSid:[[ConfigManager sharedInstance].userDictionary objectForKey:@"viopSid"] withAuthToken:[[ConfigManager sharedInstance].userDictionary objectForKey:@"viopSidPwd"]];
}

- (void)disConnectCCPService;
{
    [voipCallService disConnectToCCP];
}

//呼叫 voip
- (NSString *)makeCall:(NSString *)called withPhone:(NSString*)phone withType:(NSInteger)callType withVoipType:(NSInteger)voiptype
{
    self.callStatusResult = ECallStatus_Calling;
    NSString* callid = nil;
    if (0 == voiptype)
    {
        //电话直拨，使用被叫人电话号
        callid = [voipCallService makeCallWithType:callType andCalled:[NSString stringWithFormat:@"0086%@", phone]];
    }
    else
    {
        //网络免费电话 使用被叫人voip账号
        callid = [voipCallService makeCallWithType:callType andCalled:called];
    }
    return callid;
}


-(void)acceptInComingCall:(NSString *)callid;
{
    self.callStatusResult = ECallStatus_MyAnswered;
    [voipCallService acceptCall:callid];
}

-(void)rejectInComingCall:(NSString *)callid
{
    //拒接进来的电话
    self.callStatusResult = ECallStatus_Released;
    [voipCallService rejectCall:callid andReason:EReasonDeclined];
}

-(void)releaseCalling:(NSString *)callid
{
    //挂断正在进行的通话
    self.callStatusResult = ECallStatus_Released;
    [voipCallService releaseCall:callid];
}

#pragma mark -
#pragma mark - 通过荣联sdk来监听被挤掉线

- (void)exitAndDelBtnClick
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"你的账号在其他地方登录，如果不是本人操作，请修改登录密码。" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
    [alert show];
    
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


#pragma mark -
#pragma mark - CcpServer Delegate

- (void)onConnected
{
    NSLog(@"与voip服务器平台连接成功");
    self.registerResult = ERegisterSuccess;
}

//与voip服务器平台连接失败或连接断开
- (void)onConnectError:(NSInteger)reason withReasonMessge:(NSString *)reasonMessage
{
    if (reason == EReasonKickedOff)
    {
        //账号在另外一个地方登陆，如果出现这个情况，则直接被挤掉。。。嘿嘿
        [self exitAndDelBtnClick];
    }
}

//呼叫处理中
- (void)onCallProceeding:(NSString *)callid
{
    NSLog(@"正在呼叫");
    self.callStatusResult = ECallStatus_Proceeding;
}

//呼叫振铃
- (void)onCallAlerting:(NSString *)callid
{
    NSLog(@"呼叫振铃");
    self.callStatusResult = ECallStatus_Alerting;
}

//外呼对方应答 开始通话
- (void)onCallAnswered:(NSString *)callid
{
    NSLog(@"外呼对方应答 开始通话");
    self.callStatusResult = ECallStatus_Answered;
    [[NSNotificationCenter defaultCenter] postNotificationName:VOIPCALLBEGIN object:nil];
}

//外呼失败
- (void)onMakeCallFailed:(NSString *)callid withReason:(int)reason
{
    NSLog(@"外呼失败 reason == %d",reason);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:callid,@"callId",[NSString stringWithFormat:@"%d",reason],@"reasonCode", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:VOIPCALLFAIL object:dic];
    self.callStatusResult = ECallStatus_Released;
}

//呼叫挂机
- (void)onCallReleased:(NSString *)callid
{
    NSLog(@"挂断了电话");
    if ([self.rejectCallId isEqualToString:callid])//通话中来电默认拒绝，因当前呼叫还在继续因此不上报消息
    {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:VOIPCALLDOWN object:nil];
    self.callStatusResult = ECallStatus_Released;
}

/**
 *  对方请求切换音视频，我方回调函数
 *
 *  @param callid  通话id
 *  @param request 0代表请求增加视频（需要调用responseSwitchCallMediaType接口进行响应）1代表请求删除视频（不需要响应）
 */
- (void)onSwitchCallMediaType:(NSString *)callid withRequest:(NSInteger)request
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:callid,@"callId",[NSString stringWithFormat:@"%d",request],@"requestCode", nil];
    //对方请求音视频通话转换。。。。只有再视频通话的时候才有这个功能
    NSLog(@"收到媒体类型切换请求");
    [[NSNotificationCenter defaultCenter] postNotificationName:VOIPCALLMediaType object:dic];
}


/**
 *  创建或者加入聊天室的回调
 *
 *  @param reason 错误码
 *  @param roomNo 房间号码
 */
- (void)onChatroomStateWithReason:(CloopenReason*) reason andRoomNo:(NSString*)roomNo
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:reason,@"reason",roomNo,@"roomNo", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:VOIPCALLMakeChatRoom object:dic];
}
/**
 *  通知客户端收到新的聊天室信息
 *
 *  @param msg ChatroomMsg数据
 */

- (void)onReceiveChatroomMsg:(ChatroomMsg*) msg
{
    if([msg isKindOfClass:[ChatroomJoinMsg class]])
    {
        //有用户加入
        [[NSNotificationCenter defaultCenter] postNotificationName:VOIPCALLJointChatRoom object:msg];
    }
    if([msg isKindOfClass:[ChatroomExitMsg class]])
    {
        //有用户退出（挂断）
        [[NSNotificationCenter defaultCenter] postNotificationName:VOIPCALLExitChatRoom object:msg];
    }
    if([msg isKindOfClass:NSClassFromString(@"ChatroomRefuseMsg")])
    {
        //有人挂断了
        [[NSNotificationCenter defaultCenter] postNotificationName:VOIPCALLRefuseChatRoom object:msg];
    }
//    NSLog(@"%@",msg);
}

/**
 *  邀请加入聊天室状态返回
 *
 *  @param reason 错误码
 *  @param roomNo 房间号
 */
- (void)onChatroomInviteMembersWithReason:(CloopenReason*) reason andRoomNo:(NSString*)roomNo
{
    NSLog(@"%@",roomNo);
}

/**
 *  解散聊天室回调
 *
 *  @param reason 错误码
 *  @param roomNo 房间号
 */
- (void)onChatroomDismissWithReason:(CloopenReason*) reason andRoomNo:(NSString*) roomNo
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:reason,@"reason",roomNo,@"roomNo", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:VOIPCALLDismissChatRoom object:dic];
}

/**
 *  踢出成员回调
 *
 *  @param reason 错误码
 *  @param member 成员号码或者voip
 */
- (void) onChatroomRemoveMemberWithReason:(CloopenReason*) reason andMember:(NSString*) member
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:reason,@"reason",member,@"member", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:VOIPCALLRemoveUserChatRoom object:dic];
}

@end
