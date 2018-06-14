//
//  ContactsViewController.m
//  IM
//
//  Created by zuo guoqing on 14-9-11.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "ContactsViewController.h"
#import "PinYin4Objc.h"
#import "NSString+PinYin4Cocoa.h"
#import "EnterpriseUserCardViewController.h"
#import "SelectEnterpriseUserViewController.h"
#import "FPPopoverController.h"
#import "FPToolController.h"
#import "ChatViewController.h"

@interface ContactsViewController ()


@end

@implementation ContactsViewController

@synthesize segmentedControlIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_ENTERPRISECONTACT_FINISHED_LOAD object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationEnterpriseContactFinishedLoad:) name:NOTIFICATION_ENTERPRISECONTACT_FINISHED_LOAD object:nil];
 
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_R_SQL_GROUPUSER object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRSQLGroupUser:) name:NOTIFICATION_R_SQL_GROUPUSER object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_D_SQL_GROUPUSER_RELOAD object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationDSQLGroupUser:) name:NOTIFICATION_D_SQL_GROUPUSER_RELOAD object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_R_SQL_USER object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRSQLUser) name:NOTIFICATION_R_SQL_USER object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_U_SQL_GROUP object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationUSQLGroup:) name:NOTIFICATION_U_SQL_GROUP object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_D_SQL_GROUP object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationDSQLGroup:) name:NOTIFICATION_D_SQL_GROUP object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.scrollView.pagingEnabled = YES;
    self.scrollView.frame = CGRectMake(0, 0, boundsWidth, self.view.frame.size.height);
    self.scrollView.contentSize =CGSizeMake(boundsWidth * 3, self.scrollView.bounds.size.height);

    NSLog(@"scrollview frame width is %f" , self.scrollView.frame.size.width);
    NSLog(@"scroll view content size width is %f", self.scrollView.contentSize.width);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
//    self.localTBView.frame = CGRectMake(boundsWidth * 0, 0, boundsWidth, self.scrollView.bounds.size.height);
//    self.enterpriseTBView.frame = CGRectMake(boundsWidth * 1, 0, boundsWidth, self.scrollView.bounds.size.height);
//    self.groupTBView.frame = CGRectMake(boundsWidth * 2, 0, boundsWidth, self.scrollView.bounds.size.height);
//    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
//    [appDelegate drawerController].navigationItem.title = self.tabBarItem.title;
}

-(void)notificationRSQLUser{
    [self loadEnterpriseContactsData:YES];
    [self loadGroupContactsData];
}

-(void)notificationEnterpriseContactFinishedLoad:(NSNotification*)notification{
    
//    [self loadEnterpriseContactsData:NO];
    //replace by 陆浩
    [self loadEnterpriseContactsData:YES];
    //end
}

-(void)notificationDSQLGroup:(NSNotification*)notification{
    [self loadGroupContactsData];
}

-(void)notificationUSQLGroup:(NSNotification*)notification{
    [self loadGroupContactsData];
}

-(void)notificationRSQLGroupUser:(NSNotification*)notification{
    [self loadGroupContactsData];
}

-(void)notificationDSQLGroupUser:(NSNotification*)notification{
    [self loadGroupContactsData];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -------------------------------------------------------------------------
#pragma mark 键盘隐藏事件
-(void) keyboardWillHide:(NSNotification *) notification{
    NSNumber *duration = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark 键盘弹出事件
-(void) keyboardWillShow:(NSNotification *) notification{
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSNumber *duration = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        
    } completion:^(BOOL finished){
        
    }];
}

#pragma mark 组装视图
-(void)setupViews{
    
//    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = NO;
    
    self.scrollView.frame = CGRectMake(0, 0, boundsWidth, self.view.frame.size.height);
    self.scrollView.contentSize =CGSizeMake(boundsWidth * 3, self.scrollView.frame.size.height);

    self.localTBView.frame = CGRectMake(boundsWidth * 0, 0, boundsWidth, self.scrollView.frame.size.height);
    self.enterpriseTBView.frame = CGRectMake(boundsWidth * 1, 0, boundsWidth, self.scrollView.frame.size.height);
    self.groupTBView.frame = CGRectMake(boundsWidth * 2, 0, boundsWidth, self.scrollView.frame.size.height);

    [self handleNormalNavigationBarItem];
    
    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 44)];
    self.segmentedControl.sectionTitles = @[@"本地", @"企业",@"群组"];
    
    self.segmentedControl.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    self.segmentedControl.textColor =[UIColor blackColor];
    self.segmentedControl.selectedTextColor = [UIColor blackColor];
    self.segmentedControl.selectionIndicatorColor = [UIColor colorWithRGBHex:0x2c5492];
    self.segmentedControl.selectionStyle =HMSegmentedControlSelectionStyleFullWidthStripe;// HMSegmentedControlSelectionStyleBox;
    self.segmentedControl.selectionIndicatorLocation =HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.selectionIndicatorHeight = 2.0f;
    self.segmentedControl.seperatorHeight =20;
//    self.segmentedControl.seperatorColor =[UIColor lightGrayColor];
    
    WEAKSELF
    [self.segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf handleSelectSegmentWithIndex:index];
    }];
    
    
    self.nibLocalContacts =[UINib nibWithNibName:@"GQLocalContactsCell" bundle:[NSBundle mainBundle]];
    self.nibEnterpriseContacts =[UINib nibWithNibName:@"GQEnterpriseContactsCell" bundle:[NSBundle mainBundle]];
    self.nibEnterpriseTool =[UINib nibWithNibName:@"GQEnterpriseToolCell" bundle:[NSBundle mainBundle]];
    self.nibGroupContacts =[UINib nibWithNibName:@"GQGroupContactsCell" bundle:[NSBundle mainBundle]];
    
    
    GQContactsCreateView *groupCreate=[[GQContactsCreateView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 50) avatar:@"group_create.png" title:@"新建群组"];
    groupCreate.tag =3;
    groupCreate.delegate =self;
    self.groupTBView.tableHeaderView =groupCreate;
    
    self.localTBView.tableFooterView =[[UIView alloc] init];
    self.enterpriseTBView.tableFooterView =[[UIView alloc] init];
    self.groupTBView.tableFooterView =[[UIView alloc] init];

    
    //add by 陆浩
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.segmentedControl setSelectedSegmentIndex:segmentedControlIndex animated:NO notify:YES];
        
    });
    [self.view addSubview:self.segmentedControl];
    self.segmentedControl.hidden = YES;
    //end
}

#pragma mark 导航条点击事件
-(void)clickLeftItem:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickRightItem:(id)sender{
    
    FPToolController *fpToolVC = [[FPToolController alloc] initWithNibName:@"FPToolController" bundle:[NSBundle mainBundle]];
    fpToolVC.delegate = self;
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:fpToolVC];
    popover.tint = FPPopoverWhiteTint;
    popover.border =NO;
    popover.contentSize = CGSizeMake(boundsWidth, 200);
    popover.arrowDirection = FPPopoverArrowDirectionAny;
    [popover presentPopoverFromView:sender];
    

}

-(void)clickCancelItem:(id)sender{
    [self handleUnselected];
    [self.segmentedControl setSelectedSegmentIndex:1 animated:NO notify:YES];
    self.m_selectedUsers =[NSMutableDictionary dictionary];
}

-(void)clickConfirmItem:(id)sender{
    [self handleUnselected];
    [self.segmentedControl setSelectedSegmentIndex:2 animated:NO notify:YES];
}

#pragma mark -------------------------------------------------------------------------
#pragma mark 加载数据
-(void)loadData{
    [self loadLocalContactsData];
    [self loadGroupContactsData];
    
    //add by 陆浩
    [self loadEnterpriseContactsData:NO];
    //end
}

#pragma mark 加载本地通讯录数据
-(void)loadLocalContactsData{
    
    clock_t start_time = 0;
    clock_t end_time = 0;
    start_time = clock();
    RHAddressBook *pab = [[RHAddressBook alloc] init];
    end_time = clock();
    
    start_time = clock();
    NSArray *allPeoples = [pab people];
    end_time = clock();
    
    if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusNotDetermined){
        [pab requestAuthorizationWithCompletion:^(bool granted, NSError *error) {
            
        }];
    }
    
    if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusDenied){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"RHAuthorizationStatusDenied" message:@"Access to the addressbook is currently denied." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusRestricted){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"RHAuthorizationStatusRestricted" message:@"Access to the addressbook is currently restricted." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    self.localContacts =[self getSortContactsByAlphabet:allPeoples];
    self.localContactKeys =[self.localContacts.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    self.localSelectedIndexPath =nil;
    [self.localTBView reloadData];
}




#pragma mark 加载企业通讯录数据
-(void)loadEnterpriseContactsData:(BOOL)isReload{
    self.enterpriseData =[[NSMutableDictionary alloc] init];
    self.enterpriseDeptData =[[NSMutableDictionary alloc] init];
    self.enterpriseUserData =[[NSMutableDictionary alloc] init];
    self.stepBarData =[[NSMutableArray alloc] init];
    self.m_selectedUsers =[[NSMutableDictionary alloc] init];
    WEAKSELF
    
    [weakSelf loadEnterpriseDataWithCompletionBlock:^{
        [weakSelf loadEnterpriseContactsRootData];
        
    } isReload:isReload];
}

#pragma mark 加载企业通讯录根目录
-(void)loadEnterpriseContactsRootData{
    WEAKSELF
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MEnterpriseDept *dept =[[MEnterpriseDept alloc] init];
        dept.cid =@"0";
        dept.cname =[[ConfigManager sharedInstance].userDictionary objectForKey:@"gname"];
        weakSelf.enterpriseCurrentDept =dept;
        weakSelf.enterpriseContacts =[weakSelf getEnterpriseTableDataByCId:dept.cid];
        
        
        MEnterpriseDept *stepDept =[[MEnterpriseDept alloc] init];
        stepDept.cid =@"0";
        stepDept.cname =[[ConfigManager sharedInstance].userDictionary objectForKey:@"gname"];
        
        weakSelf.stepBarData =[NSMutableArray arrayWithObject:stepDept];
        
//        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.enterpriseSelectedIndexPath =nil;
            [weakSelf.enterpriseTBView reloadData];
            
//        });
//    });
    
}

#pragma mark 加载群组通讯录
-(void)loadGroupContactsData{
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        weakSelf.groupContacts =[NSMutableArray arrayWithArray:[[[SQLiteManager sharedInstance] getAllGroups] allValues]];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.groupSelectedIndexPath=nil;
            [weakSelf.groupTBView reloadData];
            
        });
    });
    
}

#pragma mark 加载企业通讯录数据
-(void) loadEnterpriseDataWithCompletionBlock:(void (^)(void))completionBlock isReload:(BOOL)isReload{
    
    
    if (!isReload && [self.enterpriseDeptData count]>0&& [self.enterpriseUserData count]>0) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *myGId=[[ConfigManager sharedInstance].userDictionary objectForKey:@"gid"];
        NSArray *departArr=[[SQLiteManager sharedInstance] getAllDeptByGId:myGId];
        NSArray *userArr =[[[SQLiteManager sharedInstance] getAllUserByGid:myGId] allValues];
        
        for (MEnterpriseDept *md in departArr) {
            
            [self.enterpriseDeptData setObject:md forKey:[NSString stringWithFormat:@"%lld",[md.cid longLongValue]]];
            
            NSString *pkey=[NSString stringWithFormat:@"%@p",md.cid];
            NSString *skey=[NSString stringWithFormat:@"%@s",md.cid];
            NSString *pskey=[NSString stringWithFormat:@"%@s",md.pid];
            NSString *ppkey=[NSString stringWithFormat:@"%@p",md.pid];
            
            
            //当前部门的子部门
            if (![self.enterpriseData objectForKey:skey]) {
                [self.enterpriseData setObject:@"" forKey:skey];
            }
            
            if (![self.enterpriseData objectForKey:pkey]) {
                [self.enterpriseData setObject:@"" forKey:pkey];
            }
            
            //添加当前部门上一级部门的子部门
            NSString *psValue=[self.enterpriseData objectForKey:pskey];
            if(psValue && psValue.length>0){
                [self.enterpriseData setObject:[NSString stringWithFormat:@"%@,%@",psValue,md.cid] forKey:pskey];
            }else{
                [self.enterpriseData setObject:[NSString stringWithFormat:@"%lld",[md.cid longLongValue]]forKey:pskey];
            }
            
            
            //添加当前部门的父部门
            if([md.pid longLongValue]==0){
                [self.enterpriseData setObject:@"" forKey:pkey];
            }else{
                NSString *ppValue =[self.enterpriseData objectForKey:ppkey];
                if(ppValue && ppValue.length>0){
                    [self.enterpriseData setObject:[NSString stringWithFormat:@"%@,%@", ppValue,md.pid] forKey:pkey];
                    
                }else{
                    [self.enterpriseData setObject:[NSString stringWithFormat:@"%lld",[md.pid longLongValue]] forKey:pkey];
                }
            }
        }
        for (MEnterpriseUser *mu in userArr) {
            mu.gname =[[ConfigManager sharedInstance].userDictionary objectForKey:@"gname"];
            [self.enterpriseUserData setObject:mu forKey:mu.uid];
            NSString *key=[NSString stringWithFormat:@"%@u",mu.cid];
            
            if(![self.enterpriseData objectForKey:key]){
                [self.enterpriseData setObject:mu.uid forKey:key];
            }else{
                NSString *value=[NSString stringWithFormat:@"%@,%@",[self.enterpriseData objectForKey:key],mu.uid];
                [self.enterpriseData setObject:value forKey:key];
            }
            
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock){
                completionBlock();
            }
        });
        
    });
    
}

#pragma mark -------------------------------------------------------------------------
#pragma mark 处理正常情况下的导航条
-(void)handleNormalNavigationBarItem{
    self.navigationItem.title = @"通讯录";
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    //ILBarButtonItem *leftItem =[ILBarButtonItem barItemWithImage:[[UIImage imageWithFileName:@"search.png"] imageResizedToSize:CGSizeMake(20, 20)] highlightedImage:[[UIImage imageWithFileName:@"search.png"] imageResizedToSize:CGSizeMake(20, 20)] target:self action:@selector(clickLeftItem:)];
    //self.navigationItem.leftBarButtonItem=leftItem;
//    ILBarButtonItem *rightItem =[ILBarButtonItem barItemWithImage:[[UIImage imageWithFileName:@"add.png" ] imageResizedToSize:CGSizeMake(20, 20)] highlightedImage:[[UIImage imageWithFileName:@"add.png"] imageResizedToSize:CGSizeMake(20, 20)] target:self action:@selector(clickRightItem:)];
//    self.navigationItem.rightBarButtonItem=rightItem;
}

#pragma mark 处理选中情况下的导航条
-(void)handleSelectedNavigationBarItemWithNumber:(int)number{
    NSString *confirm =@"确定";
    if (number>0) {
        confirm =[ NSString stringWithFormat:@"确定(%d)",number];
    }
    
    ILBarButtonItem *rightItem =[ILBarButtonItem barItemWithTitle:confirm themeColor:[UIColor whiteColor] target:self action:@selector(clickConfirmItem:)];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    ILBarButtonItem *leftItem =[ILBarButtonItem barItemWithTitle:@"取消" themeColor:[UIColor whiteColor] target:self action:@selector(clickCancelItem:)];
    self.navigationItem.leftBarButtonItem=leftItem;
}

#pragma mark 处理创建群组名称
-(void)handleCreateGroupWithName:(NSString*)groupName{
    
    SelectEnterpriseUserViewController *selectUserVC =[[SelectEnterpriseUserViewController alloc] init];
    selectUserVC.groupName =groupName;
    
    GQNavigationController *selectUserVCNav =[[GQNavigationController alloc] initWithRootViewController:selectUserVC];
    [self presentViewController:selectUserVCNav animated:YES completion:^{}];
}




#pragma mark 处理创建群组
-(void)handleCreateGroup{
    
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *myToken =[[ConfigManager sharedInstance].userDictionary  objectForKey:@"token"];
        NSString *myUid=[NSString stringWithFormat:@"%lld",[[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"] longLongValue]];
        __block NSMutableArray *userIds =[[NSMutableArray alloc] init];
        if ([[weakSelf.m_selectedUsers allKeys] containsObject:myUid]) {
            [userIds addObjectsFromArray:[weakSelf.m_selectedUsers allKeys]];
        }else{
            [userIds addObject:myUid];
            [userIds addObjectsFromArray:[weakSelf.m_selectedUsers allKeys]];
        }
        
        NSMutableDictionary *params =[[NSMutableDictionary alloc] init];
        [params setObject:myToken forKey:@"token"];
        [params setObject:[NSNumber numberWithInt:0] forKey:@"isTemp"];
        [params setObject:weakSelf.groupNameCreated forKey:@"groupName"];
        [params setObject:userIds forKey:@"users"];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodCreateGroup] parameters:params successBlock:^(BOOL success, id data, NSString *msg) {
            
            NSDictionary *gitem =[data objectForKey:@"groupChat"];
            NSMutableArray *groups =[[NSMutableArray alloc] init];
            NSMutableArray *groupUsers =[[NSMutableArray alloc] init];
            
            MGroup *mg =[[MGroup alloc] init];
            mg.createTime =[gitem objectForKey:@"createTime"];
            mg.groupName =[gitem objectForKey:@"groupName"];
            mg.groupid =[gitem objectForKey:@"groupid"];
            mg.len =[gitem objectForKey:@"userCount"];
            mg.name =[gitem objectForKey:@"name"];
            mg.isTemp =[gitem objectForKey:@"isTemp"];
            mg.uid =[gitem objectForKey:@"uid"];
            mg.ver =[gitem objectForKey:@"ver"];
            mg.maxLen =[gitem objectForKey:@"maxLen"];
            
            HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
            [outputFormat setToneType:ToneTypeWithoutTone];
            [outputFormat setVCharType:VCharTypeWithV];
            [outputFormat setCaseType:CaseTypeLowercase];
            
            for (NSString *userId in userIds) {
                MEnterpriseUser *userTemp =[weakSelf.enterpriseUserData objectForKey:userId];
                MGroupUser *user =[[MGroupUser alloc] initWithUser:userTemp];
                user.pinyin=[PinyinHelper toHanyuPinyinStringWithNSString:user.uname withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
                user.groupid =[gitem objectForKey:@"groupid"];
                if([user.uid longLongValue]>0){
                    [groupUsers addObject:user];
                }
            }
            
            mg.users =[NSArray arrayWithArray:groupUsers];
            [groups addObject:mg];
            
            
            [[SQLiteManager sharedInstance] insertGroupsToSQLite:groups];
            [[SQLiteManager sharedInstance] insertGroupUsersToSQLite:groupUsers notificationName:NOTIFICATION_D_SQL_GROUPUSER_RELOAD];
            
            weakSelf.groupContacts =[NSMutableArray arrayWithArray:[[[SQLiteManager sharedInstance] getAllGroups] allValues]];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.m_selectedUsers =[NSMutableDictionary dictionary];
                weakSelf.groupSelectedIndexPath=nil;
                [weakSelf.groupTBView reloadData];
                
            });
            
        } failureBlock:^(NSString *description) {
            NSLog(@"url=%@,error=%@",[HTTPAddress MethodCreateGroup],description);
        }];
    });
    
    
}

#pragma mark 处理未选中
-(void)handleUnselected{
    self.canSelectedUsers =NO;
    
    for (NSString *cid in [self.enterpriseDeptData allKeys]) {
        MEnterpriseDept *dept =[self.enterpriseDeptData objectForKey:cid];
        dept.selectedNumber =[NSNumber numberWithInt:0];
    }
    for (NSString *uid in [self.enterpriseUserData allKeys]) {
        MEnterpriseUser *user  =[self.enterpriseUserData objectForKey:uid];
        user.selected =[NSNumber numberWithInt:0];
    }
    
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (id object in weakSelf.enterpriseContacts) {
            if ([object isKindOfClass:[MEnterpriseDept class]]) {
                MEnterpriseDept *dept =(MEnterpriseDept*)object;
                dept.selectedNumber =[NSNumber numberWithInt:-1];
            }
            if ([object isKindOfClass:[MEnterpriseUser class]]) {
                MEnterpriseUser *user =(MEnterpriseUser*)object;
                user.normal =YES;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.enterpriseSelectedIndexPath =nil;
            [weakSelf.enterpriseTBView reloadData];
            
        });
    });
    
    [self handleNormalNavigationBarItem];
}

#pragma mark 处理选中某个人员
-(void) handleSelectedUser:(MEnterpriseUser*)user isSelect:(BOOL)isSelect{
    if(isSelect){//增加选中的人
        [self.m_selectedUsers setObject:user.uname forKey:user.uid];
        NSString *depId=user.cid ;
        NSString *pIds=[self.enterpriseData objectForKey:[NSString stringWithFormat:@"%@p",depId]];
        NSArray *pdepIdArr=[pIds componentsSeparatedByString:@","];
        for (NSString *key in pdepIdArr) {
            MEnterpriseDept *mdd=(MEnterpriseDept*)[self.enterpriseDeptData objectForKey:key];
            mdd.selectedNumber=[NSNumber numberWithInt:[mdd.selectedNumber intValue]+1];
        }
        
        MEnterpriseDept *md=(MEnterpriseDept*)[self.enterpriseDeptData objectForKey:depId];
        md.selectedNumber=[NSNumber numberWithInt:[md.selectedNumber intValue]+1];
        user.selected =[NSNumber numberWithInt:1];
    }else{//删除选中的人
        [self.m_selectedUsers removeObjectForKey:user.uid];
        NSString *depId=user.cid ;
        NSString *pIds=[self.enterpriseData objectForKey:[NSString stringWithFormat:@"%@p",depId]];
        NSArray *pdepIdArr=[pIds componentsSeparatedByString:@","];
        for (NSString *key in pdepIdArr) {
            MEnterpriseDept *mdd=(MEnterpriseDept*)[self.enterpriseDeptData objectForKey:key];
            mdd.selectedNumber=[NSNumber numberWithInt:[mdd.selectedNumber intValue]-1];
        }
        MEnterpriseDept *md=(MEnterpriseDept*)[self.enterpriseDeptData objectForKey:depId];
        md.selectedNumber=[NSNumber numberWithInt:[md.selectedNumber intValue]-1];
        user.selected =[NSNumber numberWithInt:0];
    }
}

#pragma mark 处理选中某个部门

-(void)handleSelectedDepartment:(MEnterpriseDept*)dm isSelected:(BOOL)isSelected
{
    NSMutableSet *subDeprtIds=[[NSMutableSet alloc] init];
    [self getAllSubDepartments:dm output:&subDeprtIds];
    [subDeprtIds addObject:[NSString stringWithFormat:@"%lld",[dm.cid longLongValue]]];
    
    if(isSelected){
        //选中所有人
        dm.selectedNumber =[NSNumber numberWithInt:0];
        
        for (NSString*key in subDeprtIds) {
            MEnterpriseDept *md=[self.enterpriseDeptData objectForKey:key];
            md.selectedNumber =[NSNumber numberWithInt:0];
        }
        
        for (NSString*key in subDeprtIds) {
            MEnterpriseDept *md=[self.enterpriseDeptData objectForKey:key];
            NSString *userIds=[self.enterpriseData objectForKey:[NSString stringWithFormat:@"%@u",key]];
            if(userIds && userIds.length>0){
                NSArray *userIdsArr=[userIds componentsSeparatedByString:@","];
                for (NSString *userKey in userIdsArr) {
                    MEnterpriseUser *user=[self.enterpriseUserData objectForKey:userKey];
                    user.selected =[NSNumber numberWithInt:1];
                    [self.m_selectedUsers setObject:user.uname forKey:user.uid];
                    md.selectedNumber=[NSNumber numberWithInt:[md.selectedNumber intValue]+1];
                }
                if (![dm.cid isEqualToString:md.cid]) {
                    dm.selectedNumber =[NSNumber numberWithInt:[dm.selectedNumber intValue]+[md.selectedNumber intValue]];
                }
            }
        }
        
        NSString *pkeys=[self.enterpriseData objectForKey:[NSString stringWithFormat:@"%lldp",[dm.cid longLongValue]]];
        if(pkeys&&pkeys.length>0){
            NSArray *pIdsArr=[pkeys componentsSeparatedByString:@","];
            for(NSString *pId in pIdsArr){
                MEnterpriseDept *md=[self.enterpriseDeptData objectForKey:pId];
                if (![dm.cid isEqualToString:md.cid]) {
                    md.selectedNumber =[NSNumber numberWithInt:[md.selectedNumber intValue]+[dm.selectedNumber intValue]];
                }
            }
        }
    }else{
        //删除所有人
        NSString *pkeys=[self.enterpriseData objectForKey:[NSString stringWithFormat:@"%lldp",[dm.cid longLongValue]]];
        if(pkeys&&pkeys.length>0){
            NSArray *pIdsArr=[pkeys componentsSeparatedByString:@","];
            for(NSString *pId in pIdsArr){
                MEnterpriseDept *md=[self.enterpriseDeptData objectForKey:pId];
                if (![dm.cid isEqualToString:md.cid]) {
                    md.selectedNumber =[NSNumber numberWithInt:[md.selectedNumber intValue]-[dm.selectedNumber intValue]];
                }
            }
        }
        dm.selectedNumber=[NSNumber numberWithInt:0];
        
        for (NSString*key in subDeprtIds) {
            MEnterpriseDept *md=[self.enterpriseDeptData objectForKey:key];
            
            NSString *userIds=[self.enterpriseData objectForKey:[NSString stringWithFormat:@"%@u",key]];
            if(userIds&&userIds.length>0){
                NSArray *userIdsArr=[userIds componentsSeparatedByString:@","];
                for (NSString *userKey in userIdsArr) {
                    MEnterpriseUser *user=[self.enterpriseUserData objectForKey:userKey];
                    user.selected =[NSNumber numberWithInt:0];
                    [self.m_selectedUsers removeObjectForKey:user.uid];
                    md.selectedNumber=[NSNumber numberWithInt:0];
                }
            }
        }
    }
}


#pragma mark 处理选项卡点击事件
-(void)handleSelectSegmentWithIndex:(int)index{
    CGFloat h =self.scrollView.frame.size.height;
    CGFloat w =self.scrollView.frame.size.width;
    NSLog(@"w is %f",w);
    CGFloat x =self.scrollView.frame.origin.x;
    CGFloat y =self.scrollView.frame.origin.y;
    self.isDragging =NO;
    [self.scrollView scrollRectToVisible:CGRectMake(w * index, y, w, h) animated:NO];
    
    switch (index+1) {
        case ContactsTypeLocal:{
            
        }
            break;
        case ContactsTypeEnterprise:{
            
        }
            break;
        case ContactsTypeGroup:{
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -------------------------------------------------------------------------
#pragma mark 根据部门获取该部门所有子部门ID
-(void) getAllSubDepartments:(MEnterpriseDept*)departData output:(NSMutableSet**)output{
    
    NSString *subIds=[self.enterpriseData objectForKey:[NSString stringWithFormat:@"%@s",departData.cid]];
    if([subIds isEqualToString:@""]){
        return ;
    }else{
        
        NSArray *subDeptArr=[subIds componentsSeparatedByString:@","];
        for (NSString *subdeptId in subDeptArr) {
            [*output addObject:subdeptId];
            [self getAllSubDepartments:(MEnterpriseDept*)[self.enterpriseDeptData objectForKey:subdeptId] output:output];
        }
    }
}


#pragma mark  根据部门ID获取该部门人员及子部门
-(NSMutableArray *)getEnterpriseTableDataByCId:(NSString*)cid
{
    NSMutableArray *tableData =[[NSMutableArray alloc] init];
    //加载当前部门的人员
    NSString *userChildIds=[self.enterpriseData objectForKey:[NSString stringWithFormat:@"%@u",cid]];
    if(userChildIds &&userChildIds.length>0){
        
        NSArray *userIds=[userChildIds componentsSeparatedByString:@","];
        NSMutableArray *sortArr=[[NSMutableArray alloc] initWithCapacity:[userIds count]];
        for (NSString *key in userIds) {
            MEnterpriseUser *user =[self.enterpriseUserData objectForKey:key];
            if (self.canSelectedUsers) {
                user.normal=NO;
            }else{
                user.normal =YES;
            }
            [sortArr addObject:user];
        }
        [tableData addObjectsFromArray:sortArr];
        
    }
    
    //加载子部门
    NSString *childIds=[self.enterpriseData objectForKey:[NSString stringWithFormat:@"%@s",cid]];
    if(![childIds isEqualToString:@""]){
        NSArray *departIds=[childIds componentsSeparatedByString:@","];
        NSMutableArray *sortArr=[[NSMutableArray alloc] initWithCapacity:[departIds count]];
        for (NSString *key in departIds) {
            MEnterpriseDept *dept =[self.enterpriseDeptData objectForKey:key];
            if (self.canSelectedUsers) {
                if ([dept.selectedNumber intValue]<=0) {
                    dept.selectedNumber =[NSNumber numberWithInt:0];
                }
            }else{
                dept.selectedNumber =[NSNumber numberWithInt:-1];
            }
            [sortArr addObject:dept];
        }
        [tableData addObjectsFromArray:sortArr];
    }
    
    return tableData;
}

#pragma mark 根据字母排序本地通讯录
-(NSMutableDictionary *)getSortContactsByAlphabet:(NSArray *)contacts{
    NSMutableDictionary *resultDic =[[NSMutableDictionary alloc] init];
    for (NSString * alpha in ALPHA_ARRAY) {
        NSMutableArray * temp = [[NSMutableArray alloc]  init];
        BOOL realExist = NO;
        for (RHPerson * mc in contacts) {
            if ([mc.pinyin hasPrefix:[alpha lowercaseString]]) {
                [temp addObject:mc];
                realExist = YES;
            }
        }
        if (realExist) {
            [resultDic setObject:temp forKey:alpha];
        }
    }
    return resultDic;
}

#pragma mark ---------------------------------------------------------------------------
- (BOOL)isSelectedIndexPath:(NSIndexPath *)indexPath selectedIndexPath:(NSIndexPath *)selectedIndexPath{
    if (indexPath && selectedIndexPath){
        if (indexPath.row == selectedIndexPath.row && indexPath.section == selectedIndexPath.section){
            return YES;
        }
    }
    return NO;
}

- (BOOL)isExpandedCellIndexPath:(NSIndexPath *)indexPath selectIndexPath:(NSIndexPath*)selectIndexPath{
    if (indexPath && selectIndexPath){
        if (indexPath.row == selectIndexPath.row+1 && indexPath.section == selectIndexPath.section){
            return YES;
        }
    }
    return NO;
}


- (void)insertCellBelowIndexPath:(NSIndexPath *)indexPath tableView:(UITableView*)tableView
{
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:(indexPath.row+1) inSection:indexPath.section];
    NSArray *pathsArray = @[nextIndexPath];
    [tableView insertRowsAtIndexPaths:pathsArray withRowAnimation:UITableViewRowAnimationTop];
}

- (void)removeCellBelowIndexPath:(NSIndexPath *)indexPath tableView:(UITableView*)tableView
{
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:(indexPath.row+1) inSection:indexPath.section];
    NSArray *pathsArray = @[nextIndexPath];
    [tableView deleteRowsAtIndexPaths:pathsArray withRowAnimation:UITableViewRowAnimationTop];
}


-(void)contactsCellDidSelectAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView selectedIndexPath:(NSIndexPath*)selectedIndexPath{
    if (indexPath) {
        [tableView beginUpdates];
        
        if (selectedIndexPath)
        {
            if ([self isSelectedIndexPath:indexPath selectedIndexPath:selectedIndexPath]){
                
                switch (tableView.tag) {
                    case 1:{
                        self.localSelectedIndexPath = nil;
                    }
                        break;
                    case 2:{
                        self.enterpriseSelectedIndexPath = nil;
                    }
                        break;
                    case 3:{
                        self.groupSelectedIndexPath = nil;
                    }
                        break;
                        
                    default:
                        break;
                }
                
                [self removeCellBelowIndexPath:selectedIndexPath tableView:tableView];
            }else if ([self isExpandedCellIndexPath:indexPath selectIndexPath:selectedIndexPath]){
                
            }else{
                if (indexPath.row > selectedIndexPath.row && indexPath.section == selectedIndexPath.section) {
                    indexPath = [NSIndexPath indexPathForRow:(indexPath.row-1) inSection:indexPath.section];
                }
                switch (tableView.tag) {
                    case 1:{
                        self.localSelectedIndexPath = indexPath;
                    }
                        break;
                    case 2:{
                        self.enterpriseSelectedIndexPath = indexPath;
                    }
                        break;
                    case 3:{
                        self.groupSelectedIndexPath = indexPath;
                    }
                        break;
                        
                    default:
                        break;
                }
                
                [self removeCellBelowIndexPath:selectedIndexPath tableView:tableView];
                [self insertCellBelowIndexPath:indexPath tableView:tableView];
            }
        } else {
            switch (tableView.tag) {
                case 1:{
                    self.localSelectedIndexPath = indexPath;
                }
                    break;
                case 2:{
                    self.enterpriseSelectedIndexPath = indexPath;
                }
                    break;
                case 3:{
                    self.groupSelectedIndexPath = indexPath;
                }
                    break;
                    
                default:
                    break;
            }
            [self insertCellBelowIndexPath:indexPath tableView:tableView];
        }
        
        [tableView endUpdates];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}



#pragma mark ---------------------------------------------------------------------------


#pragma mark GQContactsCreateViewDelegate 新建群组／客户
-(void)clickedGQContactsCreateViewWithTag:(int)tag{
    NSLog(@"clickedGQContactsCreateViewWithTag:%d",tag);
    switch (tag) {
        case 3:{
            UITextField *textField =[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 250, 30)];
            textField.borderStyle=UITextBorderStyleRoundedRect;
            textField.delegate =self;
            textField.returnKeyType =UIReturnKeyDone;
            CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"请输入群组名称！"  contentView:textField cancelButtonTitle:nil];
            alertView.keyboardHeight=216;
            [textField becomeFirstResponder];
            alertView.showBlurBackground = NO;
            [alertView addButtonWithTitle:@"取消"
                                     type:CXAlertViewButtonTypeDefault
                                  handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                      [alertView dismiss];
                                      [textField resignFirstResponder];
                                      
                                  }];
            [alertView addButtonWithTitle:@"好"
                                     type:CXAlertViewButtonTypeCancel
                                  handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                      [alertView dismiss];
                                      [textField resignFirstResponder];
                                      if (textField.text && textField.text.length>0) {
                                          [self handleCreateGroupWithName:textField.text];
                                          
                                      }
                                      
                                  }];
            
            self.createGroupChatAlertView =alertView;
            [self.createGroupChatAlertView show];
        }
            break;
            
        default:
            break;
    }
}



#pragma mark GQEnterpriseContactsCellDelegate 选择框点击事件
-(void)clickedAccessoryBtnInEnterpriseContactsCell:(GQEnterpriseContactsCell*)cell isSelected:(BOOL)isSelected{
    id enterprise =cell.enterprise;
    if ([enterprise isKindOfClass:[MEnterpriseDept class]]) {
        [self handleSelectedDepartment:enterprise isSelected:isSelected];
        
    }else if ([enterprise isKindOfClass:[MEnterpriseUser class]]){
        [self handleSelectedUser:enterprise isSelect:isSelected];
    }
    
    [cell updateState];
    [self handleSelectedNavigationBarItemWithNumber:self.m_selectedUsers.count];
    
}



#pragma mark GQGroupContactsGroupViewDelegate 群组Cell点击事件
-(void)clickedFoldBtnInGroupContactsGroupView:(GQGroupContactsGroupView *)groupView{
    self.groupSelectedIndexPath =nil;
    [self.groupTBView reloadData];
}

-(void)clickedChatBtnInGroupContactsGroupView:(GQGroupContactsGroupView *)groupView{
    NSLog(@"进入群聊页面");
    ChatViewController *chatVC =[[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:[NSBundle mainBundle]];
//    chatVC.hidesBottomBarWhenPushed = YES;
    chatVC.chatGroup =groupView.group;;
    chatVC.isGroup =YES;
    [self.navigationController pushViewController:chatVC animated:YES];

}
-(void)clickedAvatarBtnInGroupContactsGroupView:(GQGroupContactsGroupView *)groupView{
    NSLog(@"进入群聊详情页面");
    GroupChatDetailViewController *detail =[[GroupChatDetailViewController alloc] initWithNibName:@"GroupChatDetailViewController" bundle:[NSBundle mainBundle]];
    detail.group =groupView.group;
//    detail.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark OCUCMailCellDelegate
-(void)sendEmailWithEmails:(NSArray*)emails
{
    if ([MFMailComposeViewController canSendMail]) {
        self.mailComposeViewController =[[MFMailComposeViewController alloc] init];
        self.mailComposeViewController.mailComposeDelegate=self;
        [self.mailComposeViewController setSubject:@""];                                               //邮件主题
        [self.mailComposeViewController setToRecipients:emails]; //收件人
        [self.mailComposeViewController setCcRecipients:[NSArray array]];                              //抄送
        [self.mailComposeViewController setBccRecipients:[NSArray array]];                             //密送
        [self.mailComposeViewController setMessageBody:@"" isHTML:NO];                                 //邮件内容
        //self.mailCompose =self.mailComposeViewController;
        [self presentViewController:self.mailComposeViewController animated:YES completion:nil];
    }
    else
    {
        CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"deviceNOMail", nil) cancelButtonTitle:NSLocalizedString(@"comfirm", nil)];
        alertView.showBlurBackground = YES;
        [alertView show];
        
    }
    
}

#pragma mark OCUCPhoneCellDelegate
-(void)sendSmsWithPhones:(NSArray*)phoneNumbers{
    
    if([MFMessageComposeViewController canSendText]){
        self.messageComposeViewController = [[MFMessageComposeViewController alloc] init];
        self.messageComposeViewController.messageComposeDelegate = self;
        [self.messageComposeViewController setRecipients:phoneNumbers];
        [self.messageComposeViewController setBody:@""];
        //self.messageCompose=self.messageComposeViewController;
        [self presentViewController:self.messageComposeViewController animated:YES completion:nil];
        
        
    }else{
        CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"deviceNOSMS", nil) cancelButtonTitle:NSLocalizedString(@"comfirm", nil)];
        alertView.showBlurBackground = YES;
        [alertView show];
    }
}


-(void)makeCallWithPhone:(NSString*)phoneNumber{
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneNumber]];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
        {
        }
            break;
        case MFMailComposeResultSaved:
        {
        }
            break;
        case MFMailComposeResultSent:
        {
        }
            break;
        case MFMailComposeResultFailed:
        {
            CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"sendMailFailed", nil) cancelButtonTitle:NSLocalizedString(@"comfirm", nil)];
            alertView.showBlurBackground = YES;
            [alertView show];
            
        }
            break;
            
        default:
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
        {
            
        }
            break;
        case MessageComposeResultFailed:
        {
            CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"sendSMSFailed", nil) cancelButtonTitle:NSLocalizedString(@"comfirm", nil)];
            alertView.showBlurBackground = YES;
            [alertView show];
        }
            break;
        case MessageComposeResultSent:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark GQEnterpriseToolCellDelegate  消息工具条点击事件
-(void)clickedEnterpriseToolItemWithUser:(id)auser tag:(EnterpriseToolType)tag{
    
    NSString *phoneNumber=@"";
    NSString *email =@"";
    if ([auser isKindOfClass:[RHPerson class]]) {
        RHMultiStringValue *phoneNumbers =((RHPerson*)auser).phoneNumbers;
        RHMultiStringValue *emails =((RHPerson*)auser).emails;
        if ([phoneNumbers count]>0) {
            phoneNumber =[phoneNumbers valueAtIndex:0];
        }
        if ([emails count]>0) {
            email =[emails valueAtIndex:0];
        }
    }
    else if ([auser isKindOfClass:[MEnterpriseUser class]]) {
        phoneNumber =((MEnterpriseUser*)auser).mobile;
        email =((MEnterpriseUser*)auser).email;
    }
    
    switch (tag) {
        case EnterpriseToolTypeCall:{
            if (phoneNumber&&phoneNumber.length>0) {
                [self makeCallWithPhone:phoneNumber];
            }else{
                CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"手机号码为空！" message:@"" cancelButtonTitle:@"确认"];
                alertView.showBlurBackground = YES;
                [alertView show];
            }
            
        }
            break;
        case EnterpriseToolTypeChat:{
            //聊天触发
            if ([auser isKindOfClass:[MEnterpriseUser class]]) {
                if ([((MEnterpriseUser*)auser).uid isEqualToString:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]]]) {
                    CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"自己不能和自己聊天！" message:@"" cancelButtonTitle:@"确认"];
                    alertView.showBlurBackground = YES;
                    [alertView show];
                    return;
                    
                }
                
                
                
                ChatViewController *chatVC =[[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:[NSBundle mainBundle]];
//                chatVC.hidesBottomBarWhenPushed = YES;
                chatVC.chatUser =auser;
                chatVC.isGroup =NO;
                [self.navigationController pushViewController:chatVC animated:YES];
            }
        }
            break;
        case EnterpriseToolTypeSms:{
            if (phoneNumber&&phoneNumber.length>0) {
                 [self sendSmsWithPhones:[NSArray arrayWithObject:phoneNumber]];
            }else{
                CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"手机号码为空！" message:@"" cancelButtonTitle:@"确认"];
                alertView.showBlurBackground = YES;
                [alertView show];
            }
           
        }
            break;
        case EnterpriseToolTypeMail:{
            if (email&&email.length>0) {
                [self sendEmailWithEmails:[NSArray arrayWithObject:email]];
            }else{
                CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"邮箱账号为空！" message:@"" cancelButtonTitle:@"确认"];
                alertView.showBlurBackground = YES;
                [alertView show];
            }
            
        }
            break;
        case EnterpriseToolTypeDetail:{
            if ([auser isKindOfClass:[MGroupUser class]]) {
                EnterpriseUserCardViewController *userCard =[[EnterpriseUserCardViewController alloc] initWithNibName:@"EnterpriseUserCardViewController" bundle:[NSBundle mainBundle]];
                userCard.user =(MGroupUser*)auser;
//                userCard.hidesBottomBarWhenPushed =YES;
                [self.navigationController pushViewController:userCard animated:YES];
            }else if ([auser isKindOfClass:[MEnterpriseUser class]]) {
                EnterpriseUserCardViewController *userCard =[[EnterpriseUserCardViewController alloc] initWithNibName:@"EnterpriseUserCardViewController" bundle:[NSBundle mainBundle]];
                userCard.user =(MEnterpriseUser*)auser;
//                userCard.hidesBottomBarWhenPushed =YES;
                [self.navigationController pushViewController:userCard animated:YES];
                
            }else if ([auser isKindOfClass:[RHPerson class]]){
                RHPerson *person =(RHPerson*)auser;
                ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
                [person.addressBook performAddressBookAction:^(ABAddressBookRef addressBookRef) {
                    personViewController.addressBook =addressBookRef;
                } waitUntilDone:YES];
                personViewController.displayedPerson = person.recordRef;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
                personViewController.allowsActions = YES;
#endif
                personViewController.allowsEditing = YES;
                //self.contactsUI =personViewController;
                [self.navigationController pushViewController:personViewController animated:YES];
                
                
            }
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark RMStepsBarDataSource
- (NSUInteger)numberOfStepsInStepsBar:(RMStepsBar *)bar{
    return [self.stepBarData count];
    
}
- (RMStep *)stepsBar:(RMStepsBar *)bar stepAtIndex:(NSUInteger)index{
    RMStep *step=[[RMStep alloc] init];
    [step setDisabledTextColor:[UIColor blackColor]];
    [step setSelectedTextColor:[UIColor blackColor]];
    [step setEnabledTextColor:[UIColor blackColor]];
    
    [step setSelectedBarColor:[UIColor colorWithRGBHex:0xcccccc]];
    [step setEnabledBarColor:[UIColor colorWithRGBHex:0xf4f4f4]];
    [step setDisabledBarColor:[UIColor colorWithRGBHex:RM_DISABLEDBARCOLOR]];
    MEnterpriseDept *dept=[self.stepBarData objectAtIndex:index];
    [step setTitle:dept.cname];
    return step;
}

#pragma mark RMStepsBarDelegate
- (void)stepsBarDidSelectCancelButton:(RMStepsBar *)bar{
    
}

- (void)stepsBar:(RMStepsBar *)bar shouldSelectStepAtIndex:(NSInteger)index{
    NSLog(@"shouldSelectStepAtIndex:%d",index);
    MEnterpriseDept *stepDept =[self.stepBarData objectAtIndex:index];
    MEnterpriseDept *enterpriseCurrentDept =self.enterpriseCurrentDept;
    enterpriseCurrentDept.cid =stepDept.cid;
    enterpriseCurrentDept.cname=stepDept.cname;
    enterpriseCurrentDept.pid=stepDept.pid;
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        weakSelf.enterpriseContacts =[weakSelf getEnterpriseTableDataByCId:[NSString stringWithFormat:@"%lld", [enterpriseCurrentDept.cid longLongValue]]];
        
        if (index <[self.stepBarData count]) {
            [self.stepBarData removeObjectsInRange:NSMakeRange(index+1, [self.stepBarData count]-index-1)];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.enterpriseTBView setContentOffset:CGPointMake(0, 0) animated:NO];
            self.enterpriseSelectedIndexPath =nil;
            [weakSelf.enterpriseTBView reloadData];
        });
    });
}


#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self.createGroupChatAlertView dismiss];
    
    if (textField.text && textField.text.length>0) {
        [self handleCreateGroupWithName:textField.text];
    }
    return YES;
}

#pragma mark UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.isDragging =YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)ascrollView
{
    if (ascrollView ==self.scrollView) {
        int page = (ascrollView.contentOffset.x+boundsWidth/2.0) / boundsWidth;
        if (self.mCurrentPage == page) {
            return;
        }
        self.mCurrentPage= (page>2)?2:((page<0)?0:page);
        
        if (self.isDragging) {
            [self.scrollView setContentOffset:CGPointMake(self.mCurrentPage*boundsWidth, 0) animated:YES];
            [self.segmentedControl setSelectedSegmentIndex:self.mCurrentPage animated:YES];
        }
        
    }
   
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    switch (tableView.tag) {
        case ContactsTypeLocal:{
            return 30;
        }
        case ContactsTypeEnterprise:{
            return 40;
        }
        case ContactsTypeGroup:{
            return 50;
        }
        default:{
            return 0;
        }
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    switch (tableView.tag) {
        case ContactsTypeLocal:{
            UIView *customHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 30.0f)];
            customHeaderView.backgroundColor = [UIColor colorWithRed:0.926 green:0.920 blue:0.956 alpha:1.000];
            
            UILabel *headerLabel = [[UILabel alloc]initWithFrame: CGRectMake(15.0f, 0, CGRectGetWidth(customHeaderView.bounds) - 15.0f, 30.0f)];
            headerLabel.text =[self.localContactKeys objectAtIndex:section];
            headerLabel.backgroundColor = [UIColor clearColor];
            headerLabel.font = [UIFont boldSystemFontOfSize:14.0f];
            headerLabel.textColor = [UIColor darkGrayColor];
            
            [customHeaderView addSubview:headerLabel];
            return customHeaderView;
        }
            break;
        case ContactsTypeEnterprise:{
            if (self.stepBarData && [self.stepBarData count]>0) {
                RMStepsBar *stepBar =[[RMStepsBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 40.0f)];
                [stepBar setDelegate:self];
                [stepBar setDataSource:self];
                [stepBar setSeperatorColor:[UIColor colorWithRGBHex:0x585858]];
                stepBar.translatesAutoresizingMaskIntoConstraints = YES;
                [stepBar reloadData];
                self.stepBar =stepBar;
                
                return stepBar;
            }else{
                return nil;

            }
            
        }
            break;
        case ContactsTypeGroup:{
            GQGroupContactsGroupView *headView =[[GQGroupContactsGroupView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 50.0f)];
            headView.delegate =self;
            headView.group =[self.groupContacts objectAtIndex:section];
            return headView;
        }
            break;
            
        default:{
            return nil;
        }
            break;
    }
   
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case ContactsTypeLocal:{
            [self contactsCellDidSelectAtIndexPath:indexPath tableView:self.localTBView selectedIndexPath:self.localSelectedIndexPath];
        }
            break;
        case ContactsTypeEnterprise:{
            if (indexPath.row<[self.enterpriseContacts count]) {
                id enterprise= [self.enterpriseContacts objectAtIndex:indexPath.row];
                if ([enterprise isKindOfClass:[MEnterpriseUser class ]]) {
                     [self contactsCellDidSelectAtIndexPath:indexPath tableView:self.enterpriseTBView selectedIndexPath:self.enterpriseSelectedIndexPath];
                    
                    
                }else if ([enterprise isKindOfClass:[MEnterpriseDept class]]){
                    MEnterpriseDept *dept =(MEnterpriseDept*)enterprise;
                    MEnterpriseDept *enterpriseCurrentDept =self.enterpriseCurrentDept;
                    enterpriseCurrentDept.cid =dept.cid;
                    enterpriseCurrentDept.cname=dept.cname;
                    enterpriseCurrentDept.pid=dept.pid;
                    WEAKSELF
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        weakSelf.enterpriseContacts =[weakSelf getEnterpriseTableDataByCId:[NSString stringWithFormat:@"%lld", [enterpriseCurrentDept.cid longLongValue]]];
                        
                        
                        MEnterpriseDept *stepDept =[[MEnterpriseDept alloc] init];
                        stepDept.cid =dept.cid;
                        stepDept.cname=dept.cname;
                        stepDept.pid=dept.pid;
                        [weakSelf.stepBarData addObject:stepDept];
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.enterpriseTBView setContentOffset:CGPointMake(0, 0) animated:NO];
                            self.enterpriseSelectedIndexPath =nil;
                            [weakSelf.enterpriseTBView reloadData];
                        });
                    });
                }
            }else if(indexPath.row == [self.enterpriseContacts count] && self.enterpriseSelectedIndexPath){
                id enterprise= [self.enterpriseContacts objectAtIndex:indexPath.row-1];
                if ([enterprise isKindOfClass:[MEnterpriseUser class ]]) {
                    [self contactsCellDidSelectAtIndexPath:indexPath tableView:self.enterpriseTBView selectedIndexPath:self.enterpriseSelectedIndexPath];
                    
                    
                }
                
            }
            
        }
            break;
        case ContactsTypeGroup:{
            [self contactsCellDidSelectAtIndexPath:indexPath tableView:self.groupTBView selectedIndexPath:self.groupSelectedIndexPath];
            
        }
            break;
            
        default:{
        }
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case ContactsTypeLocal:{
            return 50;
        }
        case ContactsTypeEnterprise:{
            return 50;
        }
        case ContactsTypeGroup:{
            return 50;
        }
        default:{
            return 50;
        }
    }

}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    switch (tableView.tag) {
        case ContactsTypeLocal:{
            return [self.localContacts count];
        }
        case ContactsTypeEnterprise:{
            return 1;
        }
        case ContactsTypeGroup:{
            return [self.groupContacts count];
        }
        default:{
            return 0;
        }
            break;
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag) {
        case ContactsTypeLocal:{
            NSString *sectionKey= [self.localContactKeys objectAtIndex:section];
            NSArray * sectionArray = [self.localContacts objectForKey:sectionKey];
            if (self.localSelectedIndexPath && self.localSelectedIndexPath.section ==section) {
                return [sectionArray count]+1;
            }else{
                return [sectionArray count];
            }
        }
        case ContactsTypeEnterprise:{
            if (self.enterpriseSelectedIndexPath && self.enterpriseSelectedIndexPath.section ==section) {
                return [self.enterpriseContacts count]+1;
            }else{
                return [self.enterpriseContacts count];
            }
        }
        case ContactsTypeGroup:{
            MGroup *group =[self.groupContacts objectAtIndex:section];
            if (group.isOpened) {
                if (self.groupSelectedIndexPath && self.groupSelectedIndexPath.section ==section) {
                    return group.users.count+1;
                }else{
                    return group.users.count;
                }
            }else{
                return 0;
            }
        }
            
        default:{
            return 0;
        }
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (tableView.tag) {
        case ContactsTypeLocal:{
            if ([self isExpandedCellIndexPath:indexPath selectIndexPath:self.localSelectedIndexPath]){
                GQEnterpriseToolCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GQEnterpriseToolCell"];
                if(!cell){
                    cell=(GQEnterpriseToolCell*)[[self.nibEnterpriseTool instantiateWithOwner:self options:nil] objectAtIndex:0];
                }
                
                NSString *sectionKey= [self.localContactKeys objectAtIndex:indexPath.section];
                NSArray * sectionArray = [self.localContacts objectForKey:sectionKey];
                cell.user= [sectionArray objectAtIndex:self.localSelectedIndexPath.row];
                cell.delegate =self;
                return cell;
            }else{

            
                GQLocalContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GQLocalContactsCell"];
                
                if(!cell){
                    cell=(GQLocalContactsCell*)[[self.nibLocalContacts instantiateWithOwner:self options:nil] objectAtIndex:0];
                }
                
                
                NSString *sectionKey= [self.localContactKeys objectAtIndex:indexPath.section];
                NSArray * sectionArray = [self.localContacts objectForKey:sectionKey];
                
                
                if (self.localSelectedIndexPath && self.localSelectedIndexPath.section ==indexPath.section) {
                    if (indexPath.row<=self.localSelectedIndexPath.row) {
                        cell.user =[sectionArray objectAtIndex:indexPath.row];
                    }else{
                        cell.user =[sectionArray objectAtIndex:indexPath.row-1];
                    }
                    
                }else{
                    cell.user= [sectionArray objectAtIndex:indexPath.row];
                }

                return cell;
            }
        }
            break;
        case ContactsTypeEnterprise:{
            
            if ([self isExpandedCellIndexPath:indexPath selectIndexPath:self.enterpriseSelectedIndexPath]){
                GQEnterpriseToolCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GQEnterpriseToolCell"];
                if(!cell){
                    cell=(GQEnterpriseToolCell*)[[self.nibEnterpriseTool instantiateWithOwner:self options:nil] objectAtIndex:0];
                }
                cell.user= [self.enterpriseContacts objectAtIndex:self.enterpriseSelectedIndexPath.row];
                cell.delegate =self;
                return cell;
            }else{
                GQEnterpriseContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GQEnterpriseContactsCell"];
                
                if(!cell){
                    cell=(GQEnterpriseContactsCell*)[[self.nibEnterpriseContacts instantiateWithOwner:self options:nil] objectAtIndex:0];
                }
                
                if (self.enterpriseSelectedIndexPath && self.enterpriseSelectedIndexPath.section ==indexPath.section) {
                    if (indexPath.row<=self.enterpriseSelectedIndexPath.row) {
                        cell.enterprise =[self.enterpriseContacts objectAtIndex:indexPath.row];
                    }else{
                        cell.enterprise =[self.enterpriseContacts objectAtIndex:indexPath.row-1];
                    }
                    
                }else{
                    cell.enterprise= [self.enterpriseContacts objectAtIndex:indexPath.row];
                }
                
                cell.delegate =self;
                return cell;
            }
        }
            break;
        case ContactsTypeGroup:{
            
            if ([self isExpandedCellIndexPath:indexPath selectIndexPath:self.groupSelectedIndexPath]){
                GQEnterpriseToolCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GQEnterpriseToolCell"];
                if(!cell){
                    cell=(GQEnterpriseToolCell*)[[self.nibEnterpriseTool instantiateWithOwner:self options:nil] objectAtIndex:0];
                }
                
                MGroup *group  =[self.groupContacts objectAtIndex:indexPath.section];
                cell.user= [group.users  objectAtIndex:self.groupSelectedIndexPath.row];
                cell.delegate =self;
                return cell;
            }else{
            
                GQGroupContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GQGroupContactsCell"];
                    
                if(!cell){
                    cell=(GQGroupContactsCell*)[[self.nibGroupContacts instantiateWithOwner:self options:nil] objectAtIndex:0];
                }
                
                MGroup *group  =[self.groupContacts objectAtIndex:indexPath.section];
                
                if (self.groupSelectedIndexPath && self.groupSelectedIndexPath.section ==indexPath.section) {
                    if (indexPath.row<=self.groupSelectedIndexPath.row) {
                        cell.groupUser =[group.users objectAtIndex:indexPath.row];
                    }else{
                        cell.groupUser =[group.users objectAtIndex:indexPath.row-1];
                    }
                    
                }else{
                    cell.groupUser= [group.users objectAtIndex:indexPath.row];
                }
                return cell;
            }
            
        }
            break;
            
        default:{
            return nil;
        }
            break;
    }
}

@end
