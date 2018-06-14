//
//  MeetingModel.m
//  IM
//
//  Created by 陆浩 on 15/7/2.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "MeetingModel.h"

@implementation MeetingModel

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.meetingTitle = @"";
        self.meetingPwd = @"";
        self.meetingId = @"";
        self.meetingLastConnectTime = @"";
        self.commonMeeting = @"";
        self.meetingConnectType = @"";
        self.meetingUserArray = [[NSMutableArray alloc] init];
    }
    return self;
}

@end

@implementation MeetingUserModel

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.userId = @"";
        self.userAvatar = @"";
        self.userName = @"";
        self.telephone = @"";
    }
    return self;
}


@end
