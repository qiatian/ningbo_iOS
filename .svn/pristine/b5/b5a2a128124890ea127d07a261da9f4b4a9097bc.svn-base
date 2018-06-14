//
//  GroupChatDetailViewController.h
//  IM
//
//  Created by zuo guoqing on 14-10-9.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "GQBaseViewController.h"
#import "MGroup.h"
#import "MGroupUser.h"
#import "GQGroupChatDetailUsersCell.h"
#import "CXAlertView.h"
#import "EnterpriseUserCardViewController.h"
#import "Common.h"
#import "ZJSwitch.h"
#import "SelectEnterpriseUserViewController.h"
#import "MGroupDetailCell.h"

@protocol GroupChatDetailViewDelegate <NSObject>

-(void)deleteChatSuccess;

@end

@interface GroupChatDetailViewController : GQBaseViewController<UITableViewDataSource,UITableViewDelegate,GQGroupUserContainerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property(nonatomic,strong) MGroup *group;
@property(nonatomic,strong) MMessage *chatMessage;
@property(nonatomic,strong) UINib *nibGroupChatDetailUsersCell;
@property(nonatomic,strong)CXAlertView *createGroupChatAlertView;
@property(nonatomic,strong) NSMutableDictionary *groupDetails;
@property(nonatomic,assign) id<GroupChatDetailViewDelegate> delegate;
@property(nonatomic,assign) BOOL deletedBtnIsNotClicked;


@end
