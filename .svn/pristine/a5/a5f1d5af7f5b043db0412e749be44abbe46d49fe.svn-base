//
//  EnterpriseContactsViewController.h
//  IM
//
//  Created by 陆浩 on 15/4/22.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterpriseContactsViewController : GQBaseViewController<UITableViewDataSource,UITableViewDelegate,RMStepsBarDataSource,RMStepsBarDelegate,UIScrollViewDelegate,UITextFieldDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>

@property(nonatomic,strong) UITableView *enterpriseTBView;
@property(nonatomic,strong) UINib *nibEnterpriseContacts;

//企业通讯录
@property(nonatomic,strong) NSMutableDictionary *m_selectedUsers;
@property(nonatomic,strong) NSMutableDictionary *enterpriseData;
@property(nonatomic,strong) NSMutableDictionary *enterpriseDeptData;
@property(nonatomic,strong) NSMutableDictionary *enterpriseUserData;
@property(nonatomic,strong) MEnterpriseDept *enterpriseCurrentDept;
@property(nonatomic,strong) NSMutableArray *enterpriseContacts;
@property(nonatomic,strong) NSMutableArray *enterpriseUsers;

@property(nonatomic,strong) RMStepsBar *stepBar;
@property(nonatomic,strong) NSMutableArray *stepBarData;

@property(nonatomic,assign)BOOL isUserDept;

NSInteger nickNameSort(id user1, id user2, void *context);

@end
