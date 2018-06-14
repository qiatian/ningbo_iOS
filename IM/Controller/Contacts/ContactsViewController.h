//
//  ContactsViewController.h
//  IM
//
//  Created by zuo guoqing on 14-9-11.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "GQBaseViewController.h"
#import "ILBarButtonItem.h"
#import "DSGraphicsKit.h"
#import "HMSegmentedControl.h"
#import "GQLocalContactsCell.h"
#import "AddressBook.h"
#import "ConfigManager.h"
#import "HTTPClient.h"
#import "HTTPAddress.h"
#import <AddressBookUI/AddressBookUI.h>
#import "MEnterpriseDept.h"
#import "MEnterpriseCompany.h"
#import "MEnterpriseUser.h"
#import "SQLiteManager.h"
#import "GQLocalContactsCell.h"
#import "GQEnterpriseContactsCell.h"
#import "RMStepsBar.h"
#import "RMStep.h"
#import "UITableView+Animation.h"
#import "GQEnterpriseToolCell.h"
#import "GQGroupContactsCell.h"
#import "GQGroupContactsGroupView.h"
#import "GQContactsCreateView.h"
#import "GroupChatDetailViewController.h"
#import  <MessageUI/MessageUI.h>
typedef NS_ENUM(NSInteger, ContactsType) {
    ContactsTypeLocal = 1,
    ContactsTypeEnterprise = 2,
    ContactsTypeGroup = 3,
};


@interface ContactsViewController : GQBaseViewController<UITableViewDataSource,UITableViewDelegate,RMStepsBarDataSource,RMStepsBarDelegate,GQEnterpriseToolCellDelegate,UIScrollViewDelegate,GQContactsCreateViewDelegate,GQGroupContactsGroupViewDelegate,UITextFieldDelegate,GQEnterpriseContactsCellDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *localTBView;
@property (weak, nonatomic) IBOutlet UITableView *enterpriseTBView;
@property (weak, nonatomic) IBOutlet UITableView *groupTBView;
@property(nonatomic) int mCurrentPage;
@property(nonatomic) BOOL isDragging;

@property(nonatomic,strong) UINib *nibLocalContacts;
@property(nonatomic,strong) UINib *nibEnterpriseContacts;
@property(nonatomic,strong) UINib *nibEnterpriseTool;
@property(nonatomic,strong) UINib *nibGroupContacts;

//本地通讯录
@property (strong, nonatomic) RHAddressBook *addressBook;
@property (strong, nonatomic) NSMutableDictionary *localContacts;
@property(nonatomic,strong)   NSArray *localContactKeys;
@property (strong, nonatomic) NSIndexPath *localSelectedIndexPath;

//企业通讯录
@property(nonatomic,assign) BOOL canSelectedUsers;

@property(nonatomic,strong) NSMutableDictionary* m_selectedUsers;
@property(nonatomic,strong) NSMutableDictionary *enterpriseData;
@property(nonatomic,strong) NSMutableDictionary *enterpriseDeptData;
@property(nonatomic,strong) NSMutableDictionary *enterpriseUserData;
@property(nonatomic,strong) MEnterpriseDept *enterpriseCurrentDept;
@property(nonatomic,strong) NSMutableArray *enterpriseContacts;
@property (strong, nonatomic) NSIndexPath *enterpriseSelectedIndexPath;
@property(nonatomic,strong) RMStepsBar *stepBar;
@property(nonatomic,strong) NSMutableArray *stepBarData;

//群主通讯录
@property(nonatomic,strong) NSString *groupNameCreated;
@property(nonatomic,strong)CXAlertView *createGroupChatAlertView;
@property(nonatomic,strong) NSMutableArray *groupContacts;
@property (strong, nonatomic) NSIndexPath *groupSelectedIndexPath;


@property(nonatomic,strong) MFMessageComposeViewController* messageComposeViewController;
@property(nonatomic,strong) MFMailComposeViewController *mailComposeViewController;


@property(nonatomic,assign) int segmentedControlIndex;

@end
