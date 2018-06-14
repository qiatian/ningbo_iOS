//
//  MessageListViewController.h
//  IM
//
//  Created by zuo guoqing on 14-12-5.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GQBaseViewController.h"
#import "GQMessageCell.h"
#import "ChatViewController.h"

@interface MessageListViewController : GQBaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong) UITableView *tbView;
@property(nonatomic,strong) NSArray *messageList;
@property(nonatomic,strong) UINib *nibMessage;
@property(nonatomic,strong) CXAlertView *createGroupChatAlertView;

@end
