//
//  CCPManager.h
//  Voip
//
//  Created by luhao on 15-5-07.
//  Copyright (c) 2015年 luhao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCPCallService.h"

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
    ERegisterNot=0,         //没有登录
    ERegistering,           //登录中
    ERegisterSuccess,       //登录成功
    ERegisterFail,          //登录失败
    ERegisterLogout         //注销
}ERegisterResult;

typedef enum
{
    ECallStatus_NO=0,               //没有呼叫
    ECallStatus_Calling,            //呼叫中
    ECallStatus_Proceeding,         //服务器有回应
    ECallStatus_Alerting,           //对方振铃
    ECallStatus_Answered,           //对方应答
    ECallStatus_Pasused,            //保持成功
    ECallStatus_PasusedByRemote,    //被对方保持
    ECallStatus_Resumed,            //恢复通话
    ECallStatus_ResumedByRemote,    //对方恢复通话
    ECallStatus_Released,           //通话释放
    ECallStatus_Failed,             //呼叫失败
    ECallStatus_Incoming,           //来电
    ECallStatus_Transfered,         //呼叫转移
    ECallStatus_CallBack,           //回拨成功
    ECallStatus_CallBackFailed,     //回拨失败
    ECallStatus_MyAnswered          //对方来电，我方应答
}ECallStatusResult;

@protocol ModelEngineUIDelegate <NSObject>
@optional

-(void)showBtn:(NSString *)callid;
@end

@interface CCPManager : NSObject
{
    CCPCallService   *voipCallService;
}

@property(nonatomic, strong) CCPCallService         *voipCallService;
@property(assign, nonatomic) ERegisterResult        registerResult;
@property(assign, nonatomic) ECallStatusResult      callStatusResult;

@property(nonatomic, retain) NSString               *rejectCallId;
@property (nonatomic,assign) BOOL                   appIsActive;    //是否在前台
@property (nonatomic, assign)id<ModelEngineUIDelegate> UIDelegate;

//实现单例
+ (CCPManager *)ShareInstance;


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
- (void)disConnectCCPService;


//登录
- (NSInteger)connectCCPService;

//呼叫
/*
 called 被叫人的voip账号，网络免费电话使用
 phone 被叫人的电话号，网络直拨电话使用
 callType 电话类型，视频或语音
 voiptype 根据类型，网络免费电话(voip账号) 或 网络电话直拨(电话号)
 */
- (NSString *)makeCall:(NSString *)called withPhone:(NSString*)phone withType:(NSInteger)callType withVoipType:(NSInteger)voiptype;

@end
