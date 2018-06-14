//
//  ChatDetailViewController.h
//  IM
//
//  Created by syj on 15/4/25.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGroup.h"
#import "MGroupUser.h"
#import "GQGroupChatDetailUsersCell.h"
#import "CXAlertView.h"
#import "EnterpriseUserCardViewController.h"
#import "Common.h"
#import "ZJSwitch.h"
#import "SelectEnterpriseUserViewController.h"
#import "MGroupDetailCell.h"
#import "ChatUserContainer.h"

#define DELETECHATINFO @"DELETECHATINFO"

@protocol ChatDetailViewDelegate <NSObject>

-(void)deleteChatSuccess;

@end

@interface ChatDetailViewController : GQBaseViewController<UITableViewDataSource,UITableViewDelegate,ChatUserContainerDelegate,UITextFieldDelegate>
@property (strong, nonatomic) UITableView *tbView;
@property(nonatomic,strong) MGroup *group;
@property(nonatomic,strong) MEnterpriseUser *chatUser;
@property(nonatomic,strong) MMessage *chatMessage;
@property(nonatomic,strong) UINib *nibGroupChatDetailUsersCell;
@property(nonatomic,strong)CXAlertView *createGroupChatAlertView;
@property(nonatomic,strong) NSMutableDictionary *groupDetails;
@property(nonatomic,assign) id<ChatDetailViewDelegate> delegate;
@end
