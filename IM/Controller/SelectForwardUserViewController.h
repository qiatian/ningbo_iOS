//
//  SelectForwardUserViewController.h
//  IM
//
//  Created by zuo guoqing on 15-1-5.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GQBaseViewController.h"
#import "PBFlatSegmentedControl.h"
#import "RMStep.h"
#import "RMStepsBar.h"
#import "GQEnterpriseContactsCell.h"
#import "GQSelectForwardGroupCell.h"

@protocol SelectForwardUserViewControllerDelegate <NSObject>
-(void)clickedSendBtnInSelectForwardUserViewControllerWithUser:(id)user;
@end

@interface SelectForwardUserViewController : GQBaseViewController<UITableViewDataSource,UITableViewDelegate,RMStepsBarDelegate,RMStepsBarDataSource>
@property(nonatomic,assign) BOOL isGroup;
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property(nonatomic,assign) id<SelectForwardUserViewControllerDelegate>delegate;
@property(nonatomic,strong) UINib *nibEnterpriseContacts;
@property(nonatomic,strong) UINib *nibSelectForwardGroup;

@property(nonatomic,strong) NSMutableDictionary *enterpriseData;
@property(nonatomic,strong) NSMutableDictionary *enterpriseDeptData;
@property(nonatomic,strong) NSMutableDictionary *enterpriseUserData;
@property(nonatomic,strong) MEnterpriseDept *enterpriseCurrentDept;
@property(nonatomic,strong) NSMutableArray *enterpriseContacts;
@property(nonatomic,strong) RMStepsBar *stepBar;
@property(nonatomic,strong) NSMutableArray *stepBarData;

@property(nonatomic) int mCurrentPage;
@property(nonatomic) BOOL isDragging;
@property(nonatomic,strong) NSMutableArray *groupContacts;
@end
