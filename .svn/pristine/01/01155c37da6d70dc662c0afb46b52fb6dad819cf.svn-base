//
//  SelectEnterpriseUserViewController.m
//  IM
//
//  Created by zuo guoqing on 14-10-30.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "SelectEnterpriseUserViewController.h"
#import "EnterpriseContactsViewController.h"


@interface SelectEnterpriseUserViewController ()<UISearchDisplayDelegate,UISearchBarDelegate>
{
    NSMutableArray *resultArray;//搜索结果使用
    NSMutableArray *allContactArray;//企业组织架构中所有的联系人
    
    UISearchDisplayController *searchDisplayController;
    UISearchBar *tmpSearchBar;
}

@end

@implementation SelectEnterpriseUserViewController

@synthesize selectBlock,creatGroupBlock;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    //当推出界面时隐藏底部的tabBar
    self.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    resultArray = [[NSMutableArray alloc] init];
    allContactArray = [[NSMutableArray alloc] init];
    [self setupViews];
    [self loadData];
}

#pragma mark 处理选中情况下的导航条
-(void)handleSelectedNavigationBarItemWithNumber:(int)number{
    NSString *confirm =LOCALIZATION(@"Message_CXAlertView_title3");
    if (number>0) {
        confirm =[LOCALIZATION(@"Message_CXAlertView_title3") stringByAppendingFormat:@"(%d)",number];
    }
    
    ILBarButtonItem *rightItem =[ILBarButtonItem barItemWithTitle:confirm themeColor:[UIColor blackColor] target:self action:@selector(clickConfirmItem:)];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    ILBarButtonItem *leftItem =[ILBarButtonItem barItemWithTitle:LOCALIZATION(@"Message_cancel") themeColor:[UIColor blackColor] target:self action:@selector(clickCancelItem:)];
    self.navigationItem.leftBarButtonItem=leftItem;
}

-(void)clickCancelItem:(id)sender{
    [self handleUnselected];
    self.m_selectedUsers =[NSMutableDictionary dictionary];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)clickConfirmItem:(id)sender{
    if([self.m_selectedUsers allKeys].count == 0)
    {
        [self.view makeToast:LOCALIZATION(@"Message_Select_member")];
        return;
    }
    [self handleUnselected];
    if (_fromMessageList) {
        if ([[self.m_selectedUsers allKeys] count]>1) {
            //多选
            [self handleGroup];
            if (_fromChatDetail) {
                return;
            }
        }

        NSMutableArray *returnArray = [[NSMutableArray alloc] init];
        for(NSString *uid in [self.m_selectedUsers allKeys])
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@", uid];
            [returnArray addObjectsFromArray:[allContactArray filteredArrayUsingPredicate:predicate]];
        }
        
        [self dismissViewControllerAnimated:YES completion:^{
            if(selectBlock)
            {
                selectBlock(returnArray);
            }
        }];
        return;
    }
    if(!_selectGroupUsers)
    {
        if(!selectBlock)
        {
            [self handleGroup];
            if (_fromChatDetail) {
                return;
            }
        }
        [self dismissViewControllerAnimated:YES completion:^{
            if(selectBlock)
            {
                selectBlock([self.m_selectedUsers allKeys]);
            }
        }];
    }
    else
    {
        NSMutableArray *returnArray = [[NSMutableArray alloc] init];
        for(NSString *uid in [self.m_selectedUsers allKeys])
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@", uid];
            [returnArray addObjectsFromArray:[allContactArray filteredArrayUsingPredicate:predicate]];
        }
        
        [self dismissViewControllerAnimated:YES completion:^{
            if(selectBlock)
            {
                selectBlock(returnArray);
            }
        }];
    }
}


-(NSMutableArray *)handleSelectedGroupUsers:(NSArray*)userIds groupId:(NSString*)groupId{
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    NSMutableArray *groupUsers =[[NSMutableArray alloc] init];
    for (NSString *userId in userIds) {
        MEnterpriseUser *userTemp =[self.enterpriseUserData objectForKey:userId];
        MGroupUser *user =[[MGroupUser alloc] initWithUser:userTemp];
        user.pinyin=[PinyinHelper toHanyuPinyinStringWithNSString:user.uname withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
        user.groupid =groupId;
        if([user.uid longLongValue]>0){
            [groupUsers addObject:user];
        }
    }
    return groupUsers;
}

-(void)reloadAndConfigureStepBar
{
    if (self.stepBarData && [self.stepBarData count]>0) {
        
        UIScrollView *stepBarButtomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 220, 30)];
        
        CGFloat scrollWidth = 0;
        
        if (self.stepBarData.count < 3) {
            scrollWidth =  220;
        }else{
            scrollWidth = (self.stepBarData.count - 2) * 80 + 200;
        }
        
        stepBarButtomScrollView.contentSize = CGSizeMake(scrollWidth, 30);
        stepBarButtomScrollView.layer.cornerRadius = 8.0;
        stepBarButtomScrollView.bounces = NO;
        stepBarButtomScrollView.showsHorizontalScrollIndicator = NO;
        stepBarButtomScrollView.layer.masksToBounds = YES;
        
        RMStepsBar *stepBar =[[RMStepsBar alloc] initWithFrame:CGRectMake(0, 0, scrollWidth, 30.0f)];
        stepBar.layer.masksToBounds = YES;
        stepBar.layer.cornerRadius = 8.0f;
        [stepBar setDelegate:self];
        [stepBar setDataSource:self];
        //        [stepBar setSeperatorColor:[UIColor colorWithRGBHex:0x585858]];
        [stepBar setSeperatorColor:[UIColor hexChangeFloat:@"ffffff"]];
        stepBar.translatesAutoresizingMaskIntoConstraints = YES;
        [stepBar reloadData];
        self.stepBar =stepBar;
        [stepBar setBackgroundImage:[UIImage createImageWithColor:[UIColor hexChangeFloat:@"202930"] rect:CGRectMake(0, 0, boundsWidth, 30)] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];

        [stepBarButtomScrollView addSubview:self.stepBar];
        
        self.navigationItem.titleView = stepBarButtomScrollView;

    }
}

#pragma mark 处理群组
-(void)handleGroup{
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
        
        if (_currentChatUid) {
            [userIds addObject:_currentChatUid];
        }
        
        for (int i = 0 ; i < userIds.count; i++) {
            NSLog(@"&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& %@",userIds[i]);
        }
        
        
        NSLog(@"################################# %d",userIds.count);
        if (weakSelf.groupId && weakSelf.groupId.length>0) {
            //添加群组人员
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_adding_members") isDismissLater:NO];

            NSMutableDictionary *params =[[NSMutableDictionary alloc] init];
            [params setObject:myToken forKey:@"token"];
            [params setObject:weakSelf.groupId forKey:@"groupid"];
            [params setObject:userIds forKey:@"users"];
            
            
            [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodInviteGroup] parameters:params successBlock:^(BOOL success, id data, NSString *msg) {
                
                NSArray *groupUsers =[weakSelf handleSelectedGroupUsers:userIds groupId:weakSelf.groupId];
                [[SQLiteManager sharedInstance] insertGroupUsersToSQLite:groupUsers notificationName:NOTIFICATION_R_SQL_GROUPUSER];
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_AddSuccess") isDismissLater:YES];
                
                
            } failureBlock:^(NSString *description) {
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_AddFailure") isDismissLater:YES];
            }];
            
        }else{
            if(userIds.count < 2)
            {
                //没有成员，毛线的群组
                [self.view makeToast:LOCALIZATION(@"Message_Select_group_members")];
                return;
            }

            NSMutableDictionary *params =[[NSMutableDictionary alloc] init];
            [params setObject:myToken forKey:@"token"];
            [params setObject:[NSNumber numberWithInt:0] forKey:@"isTemp"];
            if(weakSelf.groupName.length==0)
            {
                [params setObject:LOCALIZATION(@"Message_TempChat") forKey:@"groupName"];
            }
            else
            {
                [params setObject:weakSelf.groupName forKey:@"groupName"];
            }
            [params setObject:userIds forKey:@"users"];
            //创建群组并添加人员
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_Being_component_group") isDismissLater:NO];
            [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodCreateGroup] parameters:params successBlock:^(BOOL success, id data, NSString *msg) {
                NSDictionary *gitem =[data objectForKey:@"groupChat"];
                MGroup *mg =[[MGroup alloc] init];
                mg.createTime =[gitem objectForKey:@"createTime"];
                mg.groupName =[gitem objectForKey:@"groupName"];
                mg.groupid =[NSString stringWithFormat:@"%@",[gitem objectForKey:@"groupid"]];
                mg.len =[gitem objectForKey:@"len"];
                mg.name =[gitem objectForKey:@"name"];
                mg.isTemp =[gitem objectForKey:@"isTemp"];
                mg.uid =[gitem objectForKey:@"uid"];
                mg.ver =[gitem objectForKey:@"ver"];
                mg.maxLen =[gitem objectForKey:@"maxLen"];
                NSMutableArray *groupUsers =[self handleSelectedGroupUsers:userIds groupId:[gitem objectForKey:@"groupid"]];
                mg.users =[NSArray arrayWithArray:groupUsers];
                [[SQLiteManager sharedInstance] insertGroupsToSQLite:[NSArray arrayWithObject:mg]];
                [[SQLiteManager sharedInstance] insertGroupUsersToSQLite:groupUsers notificationName:NOTIFICATION_R_SQL_GROUPUSER];
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_Create_success") isDismissLater:YES];
                //添加跳转
                if(creatGroupBlock)
                {
                    creatGroupBlock (mg);
                }
//                else
//                {
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        MGroup *group = mg;
//                        ChatViewController *chatVC =[[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:[NSBundle mainBundle]];
//                        chatVC.chatGroup = group;
//                        chatVC.isGroup =YES;
//                        [self.navigationController pushViewController:chatVC animated:YES];
//                    });
//                }
            } failureBlock:^(NSString *description) {
                NSLog(@"url=%@,error=%@",[HTTPAddress MethodCreateGroup],description);
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_Create_Failure") isDismissLater:YES];
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }];
        }
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
        if ([user.selected intValue]!=2) {
            user.selected =[NSNumber numberWithInt:0];
        }
        
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
            [weakSelf.tbView reloadData];
            [weakSelf reloadAndConfigureStepBar];
        });
    });
    
    [self handleSelectedNavigationBarItemWithNumber:0];
}

#pragma mark 处理选中某个人员
-(void) handleSelectedUser:(MEnterpriseUser*)user isSelect:(BOOL)isSelect{
    if(isSelect){//增加选中的人
        if ([user.selected intValue]!=2) {
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
        }
        
    }else{//删除选中的人
        if ([user.selected intValue]!=2) {
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
                    if ([user.selected intValue]!=2) {
                        user.selected =[NSNumber numberWithInt:1];
                        [self.m_selectedUsers setObject:user.uname forKey:user.uid];
                        md.selectedNumber=[NSNumber numberWithInt:[md.selectedNumber intValue]+1];
                    }
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
                    if ([user.selected intValue]!=2) {
                        user.selected =[NSNumber numberWithInt:0];
                        [self.m_selectedUsers removeObjectForKey:user.uid];
                        md.selectedNumber=[NSNumber numberWithInt:0];
                    }
                }
            }
        }
    }
}

#pragma mark 组装视图
-(void)setupViews{
    [self handleSelectedNavigationBarItemWithNumber:0];
    
    //秦俊伟 修改
    //[self handleNormalNavigationBarItem];
    self.navigationItem.title =LOCALIZATION(@"Message_Contact_person");
    
    self.tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, boundsWidth, viewWithNavNoTabbar-44)];
    self.tbView.delegate = self;
    self.tbView.dataSource = self;
    self.tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.nibEnterpriseContacts =[UINib nibWithNibName:@"GQEnterpriseContactsCell" bundle:[NSBundle mainBundle]];
    tmpSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 44)];
    tmpSearchBar.delegate = self;
    tmpSearchBar.placeholder = LOCALIZATION(@"Message_tmpSearchBar_placeholder");
    UIImage *img = [UIImage createImageWithColor:[UIColor hexChangeFloat:@"f2f2f2"] size:CGSizeMake(boundsWidth, 30)];
    [tmpSearchBar setBackgroundImage:img];
    
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:tmpSearchBar contentsController:self];
    searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;;
    searchDisplayController.delegate = self;
    // searchResultsDataSource 就是 UITableViewDataSource
    searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    searchDisplayController.searchResultsDelegate = self;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, viewWithNavNoTabbar-64, boundsWidth, 64)];
    self.scrollView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.tbView];
    
    [self.view addSubview:tmpSearchBar];
}


//秦俊伟修改
//#pragma mark 处理正常情况下的导航条
//-(void)handleNormalNavigationBarItem{
//    self.navigationItem.title = @"";
//    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
//    [self.navigationItem setLeftBarButtonItem:leftItem];
//    
//    //    rightItem=[ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_function.png"] selectedImage:[UIImage imageNamed:@"nav_function_select.png"] target:self action:@selector(clickRightItem:)];
//    //    [self.navigationItem setRightBarButtonItem:rightItem];
//}
//#pragma mark 导航条点击事件
//-(void)clickLeftItem:(id)sender{
//    if([self.enterpriseContacts count] != 0)
//    {
//        id enterprise = [self.enterpriseContacts objectAtIndex:0];
//        if ([enterprise isKindOfClass:[MEnterpriseUser class ]]) {
//            [self stepsBar:self.stepBar shouldSelectStepAtIndex:0];
//        }
//        else{
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }
//    else
//    {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}






-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    UIView *topView = controller.searchBar.subviews[0];
    [controller.searchBar setShowsCancelButton:YES animated:NO];
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            UIButton *cancelButton = (UIButton*)subView;
            [cancelButton setTitle:LOCALIZATION(@"Message_CXAlertView_title3") forState:UIControlStateNormal];  //@"取消"
        }
    }
}

#pragma mark 加载企业通讯录数据
-(void)loadData{
    self.canSelectedUsers =YES;
    
    self.enterpriseData =[[NSMutableDictionary alloc] init];
    self.enterpriseDeptData =[[NSMutableDictionary alloc] init];
    self.enterpriseUserData =[[NSMutableDictionary alloc] init];
    self.stepBarData =[[NSMutableArray alloc] init];
    self.m_selectedUsers =[[NSMutableDictionary alloc] init];
    WEAKSELF
    
    [weakSelf loadEnterpriseDataWithCompletionBlock:^{
        [weakSelf loadEnterpriseContactsRootData];
    }];
}

#pragma mark 加载企业通讯录数据
-(void) loadEnterpriseDataWithCompletionBlock:(void (^)(void))completionBlock{
    
    if ([self.enterpriseDeptData count]>0&& [self.enterpriseUserData count]>0) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *myGId=[[ConfigManager sharedInstance].userDictionary objectForKey:@"gid"];
        NSArray *departArr=[[SQLiteManager sharedInstance] getAllDeptByGId:myGId];
        NSArray *allUserArr =[[[SQLiteManager sharedInstance] getAllUserByGid:myGId] allValues];
        [allContactArray setArray:allUserArr];
        NSArray *userArr = [allUserArr sortedArrayUsingFunction:nickNameSort context:NULL];
        
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


#pragma mark 加载企业通讯录根目录
-(void)loadEnterpriseContactsRootData{
    WEAKSELF
    MEnterpriseDept *dept =[[MEnterpriseDept alloc] init];
    dept.cid =@"0";
    dept.cname =[[ConfigManager sharedInstance].userDictionary objectForKey:@"gname"];
    weakSelf.enterpriseCurrentDept =dept;
    weakSelf.enterpriseContacts =[weakSelf getEnterpriseTableDataByCId:dept.cid];
    
    MEnterpriseDept *stepDept =[[MEnterpriseDept alloc] init];
    stepDept.cid =@"0";
    stepDept.cname =[[ConfigManager sharedInstance].userDictionary objectForKey:@"gname"];
    
    weakSelf.stepBarData =[NSMutableArray arrayWithObject:stepDept];
    [weakSelf.tbView reloadData];
    [weakSelf reloadAndConfigureStepBar];
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
            if ((self.canSelectedUsers&&!selectBlock)||_selectGroupUsers) {
//           if (self.canSelectedUsers) {
                user.normal=NO;
                if ([self.disabledContactIds containsObject:key]) {
                    user.selected =[NSNumber numberWithInt:2];
                }
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
            if ((self.canSelectedUsers&&!selectBlock)||_selectGroupUsers) {
//            if (self.canSelectedUsers) {
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
    [self addUserItemsToScrollView];
}

-(void)addUserItemsToScrollView{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    
    int count =[[self.m_selectedUsers allKeys] count];
    for (int i=0; i<count; i++) {
        
        GQUserItem *userItem =[[GQUserItem alloc] initWithFrame:CGRectMake(12+52*i, 0, 40, 64)];
        userItem.user =[self.enterpriseUserData objectForKey:[[self.m_selectedUsers allKeys] objectAtIndex:i]];
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userItemTaped:)];
        [userItem addGestureRecognizer:tap];
        userItem.tag =i+1;
        [self.scrollView addSubview:userItem];
    }
    self.scrollView.scrollEnabled =YES;
    self.scrollView.contentSize =CGSizeMake(12+52*count+40, 64) ;
    if(count == 0)
    {
        self.tbView.frame = CGRectMake(0, 44, boundsWidth, viewWithNavNoTabbar-44);
    }
    else
    {
        self.tbView.frame = CGRectMake(0, 44, boundsWidth, viewWithNavNoTabbar-64-44);
    }
}

-(void)userItemTaped:(UITapGestureRecognizer *)tap{
    GQUserItem *userItem =(GQUserItem *)tap.view;
    [self.m_selectedUsers removeObjectForKey:((MEnterpriseUser *)userItem.user).uid];
    
    NSString *depId=((MEnterpriseUser *)userItem.user).cid ;
    NSString *pIds=[self.enterpriseData objectForKey:[NSString stringWithFormat:@"%@p",depId]];
    NSArray *pdepIdArr=[pIds componentsSeparatedByString:@","];
    for (NSString *key in pdepIdArr) {
        MEnterpriseDept *mdd=(MEnterpriseDept*)[self.enterpriseDeptData objectForKey:key];
        mdd.selectedNumber=[NSNumber numberWithInt:[mdd.selectedNumber intValue]-1];
    }
    MEnterpriseDept *md=(MEnterpriseDept*)[self.enterpriseDeptData objectForKey:depId];
    md.selectedNumber=[NSNumber numberWithInt:[md.selectedNumber intValue]-1];
    
    MEnterpriseUser *user =[self.enterpriseUserData objectForKey:((MEnterpriseUser *)userItem.user).uid];
    user.selected =[NSNumber numberWithInt:0];
    [self.tbView reloadData];
    [self reloadAndConfigureStepBar];
    [self addUserItemsToScrollView];
    
    [self handleSelectedNavigationBarItemWithNumber:self.m_selectedUsers.count];
}

#pragma mark RMStepsBarDataSource
- (NSUInteger)numberOfStepsInStepsBar:(RMStepsBar *)bar{
    return [self.stepBarData count];
}

- (RMStep *)stepsBar:(RMStepsBar *)bar stepAtIndex:(NSUInteger)index{
    RMStep *step=[[RMStep alloc] init];
    [step setDisabledTextColor:[UIColor whiteColor]];
    [step setSelectedTextColor:[UIColor whiteColor]];
    [step setEnabledTextColor:[UIColor whiteColor]];
    [step setSelectedBarColor:[UIColor hexChangeFloat:@"1b2026"]];
    [step setEnabledBarColor:[UIColor hexChangeFloat:@"202930"]];
    [step setDisabledBarColor:[UIColor hexChangeFloat:@"202930"]];
    MEnterpriseDept *dept=[self.stepBarData objectAtIndex:index];
    [step setTitle:dept.cname];
    return step;
}

#pragma mark RMStepsBarDelegate
- (void)stepsBarDidSelectCancelButton:(RMStepsBar *)bar{
    
}

- (void)stepsBar:(RMStepsBar *)bar shouldSelectStepAtIndex:(NSInteger)index{
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
            [weakSelf.tbView setContentOffset:CGPointMake(0, 0) animated:NO];
            [weakSelf.tbView reloadData];
            [weakSelf reloadAndConfigureStepBar];
        });
    });
}


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == self.tbView){
        id enterprise= [self.enterpriseContacts objectAtIndex:indexPath.row];
        if ([enterprise isKindOfClass:[MEnterpriseUser class ]]) {
            
            if (_isGroupEmail) {
                
                MEnterpriseUser *user = enterprise;
                
                if (!user.email) {
                    
                    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"email_nil") isDismissLater:YES];
                    return;
                }
                
                if (!user.mobile) {
                    
                    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"mobile_nil") isDismissLater:YES];
                    return;
                }
                
            }
            
            if(selectBlock&&!_selectGroupUsers)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray *array = [NSArray arrayWithObject:enterprise];
                    [self dismissViewControllerAnimated:YES completion:^{
                        selectBlock(array);
                    }];
                });
            }
            else
            {
                GQEnterpriseContactsCell *cell = (GQEnterpriseContactsCell *)[tableView cellForRowAtIndexPath:indexPath];
                [cell btnAccessoryClicked:cell.btnAccessory];
            }
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
                    [weakSelf.tbView setContentOffset:CGPointMake(0, 0) animated:NO];
                    [weakSelf.tbView reloadData];
                    [weakSelf reloadAndConfigureStepBar];
                });
            });
        }
    }
    else{
        if(selectBlock&&!_selectGroupUsers)
        {
            id enterprise= [resultArray objectAtIndex:indexPath.row];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *array = [NSArray arrayWithObject:enterprise];
                [self dismissViewControllerAnimated:YES completion:^{
                    selectBlock(array);
                }];
            });
        }
        else
        {
            GQEnterpriseContactsCell *cell = (GQEnterpriseContactsCell *)[tableView cellForRowAtIndexPath:indexPath];
            [cell btnAccessoryClicked:cell.btnAccessory];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.tbView){
        return [self.enterpriseContacts count];
    }
    return [resultArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GQEnterpriseContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GQEnterpriseContactsCell"];
    if(!cell){
        cell=(GQEnterpriseContactsCell*)[[self.nibEnterpriseContacts instantiateWithOwner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    if(tableView == self.tbView){
        cell.enterprise= [self.enterpriseContacts objectAtIndex:indexPath.row];
    }
    else{
        
        MEnterpriseUser *user = [resultArray objectAtIndex:indexPath.row];
        if ([self.disabledContactIds containsObject:user.uid]) {
            user.selected =[NSNumber numberWithInt:2];
        }
        
        if ((self.canSelectedUsers&&!selectBlock)||_selectGroupUsers) {
            user.normal =NO;
        }else{
            user.normal =YES;
        }
        
        cell.enterprise= [resultArray objectAtIndex:indexPath.row];
        
        
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchDisplayController delegate
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller  shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterContentForSearchText:searchString];
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uname contains[cd] %@", searchText];
    [resultArray setArray:[allContactArray filteredArrayUsingPredicate:predicate]];
    if([resultArray count] == 0)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pinyin contains[cd] %@", searchText];
        [resultArray setArray:[allContactArray filteredArrayUsingPredicate:predicate]];
    }
    if([resultArray count] == 0)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mobile contains[cd] %@", searchText];
        [resultArray setArray:[allContactArray filteredArrayUsingPredicate:predicate]];
    }
    if([resultArray count] == 0)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"jid contains[cd] %@", searchText];
        [resultArray setArray:[allContactArray filteredArrayUsingPredicate:predicate]];
    }
}


@end
