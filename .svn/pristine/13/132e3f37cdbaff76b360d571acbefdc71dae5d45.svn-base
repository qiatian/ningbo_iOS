//
//  MeetingModel.h
//  IM
//
//  Created by 陆浩 on 15/7/2.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeetingModel : NSObject

@property(nonatomic,copy)NSString *meetingTitle;//会议主题

@property(nonatomic,copy)NSString *meetingPwd;//会议密码

@property(nonatomic,copy)NSString *meetingId;//会议id,暂时以时间戳来作为meetingId，本地存储

@property(nonatomic,copy)NSString *meetingLastConnectTime;//最后近一次通话的时间，如果还没有通话，就是创建时间

@property(nonatomic,copy)NSString *commonMeeting;//是常用会议 ? 1 : 0

@property(nonatomic,copy)NSString *showInRecordMeeting;//在会议记录中显示常用会议 ? 1 : 0 (如果是常用会议，则该数据可能是不显示再记录列表中的，但是，数据库中是有该条数据的)

@property(nonatomic,copy)NSString *meetingConnectType;//最近一次会议电话连接状态（未接，拨出等。。。）

@property(nonatomic,strong)NSMutableArray *meetingUserArray;//参会人员，放的是人员模型

@property(nonatomic,strong) NSString *confname; //会议名称

@property(nonatomic,assign) BOOL top1;        //时候置顶
@property(nonatomic,strong) NSString *topTime1;    //置顶时间
@property(nonatomic,strong) NSString *sessionState1;
@property(nonatomic,strong) NSString*sendTime;


@end

@interface MeetingUserModel : NSObject

@property(nonatomic,copy)NSString *userId;//如果有userid则说明是从企业通讯录选取出来的

@property(nonatomic,copy)NSString *userName;//如果是直接输入的号码，用户名直接用参会人员

@property(nonatomic,copy)NSString *telephone;//手机号码

@property(nonatomic,copy)NSString *userAvatar;//头像，企业架构里面的才能有头像

@end
