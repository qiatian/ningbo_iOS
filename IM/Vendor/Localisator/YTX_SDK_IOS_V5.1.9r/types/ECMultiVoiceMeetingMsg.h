//
//  ECInterphoneMeetingMsg.h
//  CCPiPhoneSDK
//
//  Created by adminlrn on 15/4/13.
//  Copyright (c) 2015年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECMeetingMember.h"

#pragma mark - ECMeetingType_MultiVoice 相关通知类消息

typedef NS_ENUM(NSUInteger, ECMultiVoiceMeetingMsgType) {
    
    /** 加入聊天室 */
    MultiVoice_JOIN = 301,
    
    /** 退出聊天室 */
    MultiVoice_EXIT = 302,
    
    /** 删除聊天室 */
    MultiVoice_DELETE = 303,
    
    /** 删除聊天室成员 */
    MultiVoice_REMOVEMEMBER = 304,
    
    /** 拒绝 */
    MultiVoice_REFUSE = 306
};

@interface ECMultiVoiceMeetingMsg : NSObject

/**
 @brief 聊天室的消息类型
 */
@property (nonatomic, assign) ECMultiVoiceMeetingMsgType type;

/**
 @brief 聊天室房间id
 */
@property (nonatomic, copy) NSString *roomNo;

/**
 @brief 有人加入聊天室的VoIP账号集合
 */
@property (nonatomic, copy) NSArray *joinArr;

/**
 @brief 有人退出聊天室的VoIP账号集合
 */
@property (nonatomic, copy) NSArray *exitArr;

/**
 @brief 踢人的VoIP号/禁言的VoIP号/转换状态的VoIP号
 */
@property (nonatomic, strong) ECVoIPAccount *who;

/**
 @brief 用户拒绝加入会议的VoIP账号集合
 */
@property (nonatomic, copy) NSArray *refuseArr;

@end