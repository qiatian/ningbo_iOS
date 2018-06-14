//
//  MeetingDetailViewController.h
//  IM
//
//  Created by 陆浩 on 15/7/1.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingDetailViewController : UIViewController

@property(nonatomic,strong)NSString *meetingId;

@property(nonatomic,assign)BOOL fromHistory;

@property(nonatomic,assign)BOOL firstCreatMeeting;

@end
