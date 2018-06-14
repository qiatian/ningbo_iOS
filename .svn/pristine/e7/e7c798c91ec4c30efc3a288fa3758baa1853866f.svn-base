//
//  DeviceDelegateHelper.m
//  IM
//
//  Created by ZteCloud on 16/1/26.
//  Copyright © 2016年 zuo guoqing. All rights reserved.
//

#import "DeviceDelegateHelper.h"
#import "ECVoIPCallManager.h"
#import "VoipViewController.h"
@implementation DeviceDelegateHelper
+(DeviceDelegateHelper*)ShareInstance
{
    
    static DeviceDelegateHelper *devicedelegatehelper;
    
    static dispatch_once_t devicedelegatehelperonce;
    
    dispatch_once(&devicedelegatehelperonce, ^{
        
        devicedelegatehelper = [[DeviceDelegateHelper alloc] init];
        
    });
    
    return devicedelegatehelper;
    
}
#pragma mark--------连接云通讯的服务平台，实现ECDelegateBase代理的方法
//与voip服务器平台连接失败或连接断开
-(void)onConnectState:(ECConnectState)state failed:(ECError*)error {
    
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"推送消息" message:@"测试推送" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:@"去看看", nil];
//    [alert show];
    
    
    switch (state) {
            
        case State_ConnectSuccess://连接成功
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KNOTIFICATION_onConnected" object:[ECError errorWithCode:ECErrorType_NoError]];
            [UserDefault setObject:@"false" forKey:@"voipconect"];
            break;
            
        case State_Connecting://正在连接
            
            [UserDefault setObject:@"true" forKey:@"voipconect"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KNOTIFICATION_onConnected" object:[ECError errorWithCode:ECErrorType_Connecting]];
            
            [self performSelector:@selector(setVoipConnect) withObject:nil afterDelay:5];
            
            break;
            
        case State_ConnectFailed://失败  这边失败可能是网络断开了，所以延迟几秒钟后判断网络是否可用 如果可用才是被抢登 。。先这样吧
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KNOTIFICATION_onConnected" object:error];
            NSString *voipConnect = [UserDefault valueForKey:@"voipconect"];
            if (![voipConnect isEqualToString:@"true"]) {
                [self exitAndDelBtnClick];
            }
            [UserDefault setObject:@"false" forKey:@"voipconect"];
        }
        default:
            break;
    }
}

- (void)setVoipConnect{
    [UserDefault setObject:@"false" forKey:@"voipconect"];
}

-(void)rejectInComingCall:(NSString *)callid
{
    //拒接进来的电话
    self.callStatusResult = ECallStatus_Released1;
    [[ECDevice sharedInstance].VoIPManager rejectCall:callid andReason:ECErrorType_Gone];
}
-(void)releaseCalling:(NSString *)callid
{
    //挂断正在进行的通话
    self.callStatusResult = ECallStatus_Released1;
    [[ECDevice sharedInstance].VoIPManager rejectCall:callid andReason:ECErrorType_Gone];
}
-(void)acceptInComingCall:(NSString *)callid
{
    self.callStatusResult = ECallStatus_MyAnswered1;
    [[ECDevice sharedInstance].VoIPManager acceptCall:callid withType:LandingCall];
}
-(void)disConnectVoip
{
  //voip离线推送注释
    [[ECDevice sharedInstance] logout:^(ECError *error) {
       // 登出结果
    }];
}
-(void)connectVoip
{
    
//    ECLoginInfo * loginInfo = [[ECLoginInfo alloc] init];
//    loginInfo.username=[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
//    loginInfo.appKey=DefaultAppKey;
//    loginInfo.appToken=DefaultAppToke;
//    loginInfo.authType=LoginAuthType_NormalAuth;//默认方式登录
//    loginInfo.mode = LoginMode_InputPassword;
//    [[ECDevice sharedInstance] login:loginInfo completion:^(ECError *error){
//        if (error.errorCode == ECErrorType_NoError) {
//            //登录成功
//            NSLog(@"voip login success");
//        }else{
//            //登录失败
//        }
//    }];
    
    //密码模式：对AppKey、userName和userPassword鉴权
    ECLoginInfo * loginInfo = [[ECLoginInfo alloc] init];
    loginInfo.username =[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"viopId"]];
    loginInfo.appKey = DefaultAppKey;
//    loginInfo. userPassword= [NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"viopPwd"]];
//    loginInfo.authType = LoginAuthType_PasswordAuth;//密码方式登录
    loginInfo.appToken = DefaultAppToke;
    loginInfo.authType = LoginAuthType_NormalAuth;
    loginInfo.mode = LoginMode_InputPassword;
    
    
    [[ECDevice sharedInstance] login:loginInfo completion:^(ECError *error){
        if (error.errorCode == ECErrorType_NoError) {
            //登录成功
             NSLog(@"voip login success");
        }else{
            //登录失败
        }
    }];
    
}
-(NSString*)makeCall:(NSString *)called withPhone:(NSString *)phone withType:(CallType)callType withVoipType:(NSInteger)voiptype
{
    self.callStatusResult = ECallStatus_Calling1;
    NSString* callid = nil;
    if (0 == voiptype)
    {
        //电话直拨，使用被叫人电话号 0086
        callid = [[ECDevice sharedInstance].VoIPManager makeCallWithType:callType andCalled:[NSString stringWithFormat:@"%@", phone]];
    }
    else
    {
        //网络免费电话 使用被叫人voip账号
        callid = [[ECDevice sharedInstance].VoIPManager makeCallWithType:callType andCalled:called];
    }
    return callid;
}
#pragma mark-----------如需使用实时音视频功能，需实现ECVoIPCallDelegate类的回调函数。
/**
 @brief 有呼叫进入
 @param callid      会话id
 @param caller      主叫人账号
 @param callerphone 主叫人设置的手机号
 @param callername  主叫人设置的昵称
 @param calltype    呼叫类型
 */
- (NSString*)onIncomingCallReceived:(NSString*)callid withCallerAccount:(NSString *)caller withCallerPhone:(NSString *)callerphone withCallerName:(NSString *)callername withCallType:(CallType)calltype
{
    
    if (self.callStatusResult != ECallStatus_NO1 && self.callStatusResult != ECallStatus_Released1) {
        [[ECDevice sharedInstance].VoIPManager rejectCall:callid andReason:ECErrorType_CallBusy];
        self.rejectCallId = callid;
        return @"";
    }
    self.callStatusResult = ECallStatus_Incoming1;
    
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
    return nil;
}

/**
 @brief 呼叫事件
 @param voipCall VoIP电话实体类的对象
 */
- (void)onCallEvents:(VoIPCall*)voipCall
{
    NSLog(@"%@",voipCall);
//    if(voipCall.reason==ECErrorType_OtherSideOffline||voipCall.reason==ECErrorType_Timeout||voipCall.reason==ECErrorType_TemporarilyNotAvailable||voipCall.reason==171506)
//    {
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:voipCall.callID,@"callId",[NSString stringWithFormat:@"%d",voipCall.reason],@"reasonCode", nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:VOIPCALLFAIL object:dic];
//        
//    }
    switch (voipCall.callStatus) {
        case ECallProceeding:
        {
            self.callStatusResult = ECallStatus_Proceeding1;
        }
            break;
        case ECallFailed:
        {
            self.callStatusResult = ECallStatus_Released1;
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:voipCall.callID,@"callId",[NSString stringWithFormat:@"%d",voipCall.reason],@"reasonCode", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:VOIPCALLFAIL object:dic];
        }
            break;
        case ECallAlerting:
        {
            self.callStatusResult = ECallStatus_Alerting1;
            
        }
            break;
        case ECallStreaming:
        {
            self.callStatusResult = ECallStatus_Answered1;
            [[NSNotificationCenter defaultCenter] postNotificationName:VOIPCALLBEGIN object:nil];
        }
            break;
        case ECallEnd:
        {
            if ([self.rejectCallId isEqualToString:voipCall.callID])//通话中来电默认拒绝，因当前呼叫还在继续因此不上报消息
            {
                return;
            }
            self.callStatusResult = ECallStatus_Released1;
            [[NSNotificationCenter defaultCenter] postNotificationName:VOIPCALLDOWN object:nil];
            
        }
            break;
        default:
            break;
    }
    
    
}

/**
 @brief 收到dtmf
 @param callid 会话id
 @param dtmf   键值
 */
- (void)onReceiveFrom:(NSString*)callid DTMF:(NSString*)dtmf
{}

/**
 @brief 视频分辨率发生改变
 @param callid       会话id
 @param voip         VoIP号
 @param isConference NO 不是, YES 是
 @param width        宽度
 @param height       高度
 */
- (void)onCallVideoRatioChanged:(NSString *)callid andVoIP:(NSString *)voip andIsConfrence:(BOOL)isConference andWidth:(NSInteger)width andHeight:(NSInteger)height
{}

/**
 @brief 收到对方切换音视频的请求
 @param callid  会话id
 @param requestType 请求音视频类型 视频:需要响应 音频:请求删除视频（不需要响应，双方自动去除视频）
 */
- (void)onSwitchCallMediaTypeRequest:(NSString *)callid withMediaType:(CallType)requestType
{

}

/**
 @brief 收到对方应答切换音视频请求
 @param callid   会话id
 @param responseType 回复音视频类型
 */
- (void)onSwitchCallMediaTypeResponse:(NSString *)callid withMediaType:(CallType)responseType
{}

/**
 @brief 需要获取的离线呼叫CallId (用于苹果推送下来的离线呼叫callid)
 @return apns推送的过来的callid
 */
//- (NSString*)onGetOfflineCallId
//{}

/**
 @brief 获取本地回铃音路径
 @param voipCall  呼叫相关信息
 */
//- (NSString*)onGetRingBackWavPath:(VoIPCall*)voipCall
//{}

/**
 @brief 获取本地忙音路径
 @param voipCall  呼叫相关信息
 */
//- (NSString*)onGetBusyWavPath:(VoIPCall*)voipCall
//{}

#pragma mark-----------如需使用音视频会议功能，需实现ECMeetingDelegate类的回调函数。
/**
 @brief 有会议呼叫邀请
 @param callid      会话id
 @param calltype    呼叫类型
 @param meetingData 会议的数据
 */
//- (NSString*)onMeetingCallReceived:(NSString*)callid withCallType:(CallType)calltype withMeetingData:(NSDictionary*)meetingData
//{}

/**
 @brief 实时对讲通知消息
 @param msg 实时对讲消息
 */
-(void)onReceiveInterphoneMeetingMsg:(ECInterphoneMeetingMsg *)msg
{}

/**
 @brief 语音群聊通知消息
 @param msg 语音群聊消息
 */
-(void)onReceiveMultiVoiceMeetingMsg:(ECMultiVoiceMeetingMsg *)msg
{
    if(msg.type==MultiVoice_JOIN)
    {
        //有用户加入
        [[NSNotificationCenter defaultCenter] postNotificationName:VOIPCALLJointChatRoom object:msg];
    }
    if (msg.type==MultiVoice_EXIT) {
        //有用户退出（挂断）
        [[NSNotificationCenter defaultCenter] postNotificationName:VOIPCALLExitChatRoom object:msg];
    }
    if(msg.type==MultiVoice_REFUSE)
    {
        //有人挂断了
        [[NSNotificationCenter defaultCenter] postNotificationName:VOIPCALLRefuseChatRoom object:msg];
    }
    if(msg.type==MultiVoice_DELETE)
    {
//        删除聊天室
        [[NSNotificationCenter defaultCenter] postNotificationName:VOIPCALLDismissChatRoom object:msg];
    }
}

/**
 @brief 多路视频通知消息
 @param msg 多路视频消息
 */
-(void)onReceiveMultiVideoMeetingMsg:(ECMultiVideoMeetingMsg *)msg
{}


#pragma mark - 通过荣联sdk来监听被挤掉线
- (void)exitAndDelBtnClick
{
    
    [UserDefault removeObjectForKey:@"LPsw"];
    [UserDefault removeObjectForKey:@"TOKEN"];
  //voip离线推送注释
    [[ECDevice sharedInstance] logout:^(ECError *error) {
        //登出结果
    }];

    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"你的账号在其他地方登录，如果不是本人操作，请修改登录密码。" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alert show];
    });
    
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
@end
