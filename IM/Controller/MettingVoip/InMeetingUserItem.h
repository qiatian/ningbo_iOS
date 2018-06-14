//
//  InMeetingUserItem.h
//  IM
//
//  Created by 陆浩 on 15/7/7.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    waiteconnect,//等待接入
    hasconnect,//已经连入，正在通话
    reconnect,//连接失败，点击可重新连接
    hangUp//对方已挂断
}MeetingType;

@interface InMeetingUserItem : UIControl

@property(nonatomic,strong)UILabel *labUserName;
@property(nonatomic,strong)UILabel *labAvatar;
@property(nonatomic,strong)GQLoadImageView *ivAvatar;
@property(nonatomic,strong)MeetingUserModel *user;
@property(nonatomic,assign)MeetingType type;
@end
