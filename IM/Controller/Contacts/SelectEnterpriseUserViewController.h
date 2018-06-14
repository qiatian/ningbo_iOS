//
//  SelectEnterpriseUserViewController.h
//  IM
//
//  Created by zuo guoqing on 14-10-30.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "GQBaseViewController.h"
#import "RMStepsBar.h"
#import "RMStep.h"
#import "SQLiteManager.h"
#import "GQEnterpriseContactsCell.h"
#import "ConfigManager.h"
#import "HTTPClient.h"
#import "HTTPAddress.h"
#import "ILBarButtonItem.h"
#import "PinYin4Objc.h"
#import "GQUserItem.h"

typedef void(^SelectUserBlock)(NSArray *responseUsers);

typedef void(^CreatGroupSuccessBlock)(MGroup *group);

@interface SelectEnterpriseUserViewController : GQBaseViewController<UITableViewDataSource,UITableViewDelegate,GQEnterpriseContactsCellDelegate,RMStepsBarDelegate,RMStepsBarDataSource>

@property(nonatomic,strong) UITableView *tbView;
@property(nonatomic,strong) UINib *nibEnterpriseContacts;

//企业通讯录
@property(nonatomic,assign) BOOL canSelectedUsers;
@property(nonatomic,strong) NSString *groupName;
@property(nonatomic,strong) NSString *groupId;
@property(nonatomic,strong) NSMutableArray *disabledContactIds;
@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) NSMutableDictionary* m_selectedUsers;
@property(nonatomic,strong) NSMutableDictionary *enterpriseData;
@property(nonatomic,strong) NSMutableDictionary *enterpriseDeptData;
@property(nonatomic,strong) NSMutableDictionary *enterpriseUserData;
@property(nonatomic,strong) MEnterpriseDept *enterpriseCurrentDept;
@property(nonatomic,strong) NSMutableArray *enterpriseContacts;
@property(nonatomic,strong) RMStepsBar *stepBar;
@property(nonatomic,strong) NSMutableArray *stepBarData;


@property(nonatomic,copy)SelectUserBlock selectBlock;
@property(nonatomic,copy)CreatGroupSuccessBlock creatGroupBlock;


@property(nonatomic,assign) BOOL fromChatDetail;

@property(nonatomic,strong) NSString *currentChatUid;

@property(nonatomic,assign) BOOL fromMessageList;

//提供多选使用
@property(nonatomic,assign)BOOL selectGroupUsers;//可多个选择

@property (nonatomic, assign) BOOL isGroupEmail;
@property (nonatomic, assign) BOOL isGroupMessage;



@end
