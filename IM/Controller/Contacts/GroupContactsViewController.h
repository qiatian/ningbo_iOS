//
//  GroupContactsViewController.h
//  IM
//
//  Created by 陆浩 on 15/4/22.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupContactsViewController : GQBaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>

@property(strong, nonatomic) UITableView *groupTBView;
@property(nonatomic,strong) UINib *nibGroupContacts;

//群主通讯录
@property(nonatomic,strong) NSString *groupNameCreated;
@property(nonatomic,strong) CXAlertView *createGroupChatAlertView;
@property(nonatomic,strong) NSMutableArray *groupContacts;

@end
