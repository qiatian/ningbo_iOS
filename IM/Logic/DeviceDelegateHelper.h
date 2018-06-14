//
//  DeviceDelegateHelper.h
//  IM
//
//  Created by ZteCloud on 16/1/26.
//  Copyright © 2016年 zuo guoqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECDeviceHeaders.h"
#import "ECVoIPCallManager.h"
#import "AppDelegate.h"
#define DefaultAppKey @"8a48b5514800eb2801480b41686505de"//8a48b55152624825015277cabe3e27a1     8a48b5514800eb2801480b41686505de
#define DefaultAppToke @"d783e0560dae11e5ac73ac853d9f54f2"//  2889568647e229f9d97ceb35ca2b9f0d  d783e0560dae11e5ac73ac853d9f54f2

#define VOIPCALLBEGIN       @"VOIPcallBegin"
#define VOIPCALLFAIL        @"VOIPcallFail"
#define VOIPCALLDOWN        @"VOIPcallDown"//挂断
#define VOIPCALLMediaType   @"VOIPcallMediaChange"//音视频切换

#define VOIPCALLMakeChatRoom        @"VOIPCALLMakeChatRoom"//创建聊天室
#define VOIPCALLDismissChatRoom     @"VOIPCALLDismissChatRoom"//解散聊天室
#define VOIPCALLJointChatRoom       @"VOIPCALLJointChatRoom"//有成员加入聊天室
#define VOIPCALLExitChatRoom        @"VOIPCALLExitChatRoom"//有成员退出聊天室（挂断电话）
#define VOIPCALLRefuseChatRoom      @"VOIPCALLRefuseChatRoom"//有成员未接聊天室
#define VOIPCALLRemoveUserChatRoom  @"VOIPCALLRemoveUserChatRoom"//踢出成员

typedef enum
{
    ECallStatus_NO1=0,               //没有呼叫
    ECallStatus_Calling1,            //呼叫中
    ECallStatus_Proceeding1,         //服务器有回应
    ECallStatus_Alerting1,           //对方振铃
    ECallStatus_Answered1,           //对方应答
    ECallStatus_Pasused1,            //保持成功
    ECallStatus_PasusedByRemote1,    //被对方保持
    ECallStatus_Resumed1,            //恢复通话
    ECallStatus_ResumedByRemote1,    //对方恢复通话
    ECallStatus_Released1,           //通话释放
    ECallStatus_Failed1,             //呼叫失败
    ECallStatus_Incoming1,           //来电
    ECallStatus_Transfered1,         //呼叫转移
    ECallStatus_CallBack1,           //回拨成功
    ECallStatus_CallBackFailed1,     //回拨失败
    ECallStatus_MyAnswered1          //对方来电，我方应答
}ECallStatusResult1;
@interface DeviceDelegateHelper : NSObject<ECDeviceDelegate>
@property(nonatomic,strong)ECDevice *voipCallService;
@property(assign, nonatomic) ECallStatusResult1      callStatusResult;
@property(nonatomic, retain) NSString               *rejectCallId;
//实现单例
+ (DeviceDelegateHelper *)ShareInstance;
/**
 *  拒接对方来电
 *
 *  @param callid voip电话id
 */
-(void)rejectInComingCall:(NSString *)callid;
/**
 *  挂断当前电话
 *
 *  @param callid voip电话id
 */
-(void)releaseCalling:(NSString *)callid;
/**
 *  接听对方来电
 *
 *  @param callid voip电话id
 */
-(void)acceptInComingCall:(NSString *)callid;
/**
 *  退出voip
 */
- (void)disConnectVoip;
//登录
-(void)connectVoip;
//呼叫
/*
 called 被叫人的voip账号，网络免费电话使用
 phone 被叫人的电话号，网络直拨电话使用
 callType 电话类型，视频或语音
 voiptype 根据类型，网络免费电话(voip账号) 或 网络电话直拨(电话号)
 */
- (NSString *)makeCall:(NSString *)called withPhone:(NSString*)phone withType:(CallType)callType withVoipType:(NSInteger)voiptype;
@end
