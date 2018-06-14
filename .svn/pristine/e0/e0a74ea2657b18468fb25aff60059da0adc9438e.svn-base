//
//  VoipViewController.h
//  IM
//
//  Created by 陆浩 on 15/6/28.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MEnterpriseUser.h"
//语音电话挂断类型

/*
 1、A 呼 B，A 取消呼出
 2、A 呼 B，B 挂断
 3、A 呼 B，B 未接听 超时断开
 4、A 呼 B，B 接听，A 挂断
 5、A 呼 B，B 接听，B 挂断
 */


typedef NS_ENUM(NSInteger, CallHangUpType) {
    
    //挂断电话的类型
    CallHangUpTypeSelfNotConnect = 1,
    CallHangUpTypeOtherNotConnect,
    CallHangUpTypeTimeOut,
    CallHangUpTypeDownConnected,
    CallHangUpTypeNotAnswer
    
};

static const NSString *CallHangUpNotification = @"CallHangUp";


@interface VoipViewController : GQBaseViewController

@property(nonatomic, assign)int callType;//是接听还是拨打电话 0:打电话  1:接电话

@property(nonatomic, strong)NSString *callID;//接听的时候需要传入

@property(nonatomic,strong)MEnterpriseUser *callUser;//对方的数据模型，拨打的时候需要传入，接听电话的时候需要根据voipid从本地数据库获取对应信息

@property(nonatomic,strong)NSString *callerAccount;

@property(nonatomic,assign)int voipType;//0:语音  1:视频

@end
