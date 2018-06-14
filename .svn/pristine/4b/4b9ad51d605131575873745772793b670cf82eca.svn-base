//
//  EnterpriseContactsViewController.m
//  IM
//
//  Created by 陆浩 on 15/4/22.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "EnterpriseContactsViewController.h"
#import "CreatNotiViewController.h"

@interface EnterpriseContactsViewController ()<UISearchDisplayDelegate,UISearchBarDelegate>
{
    EnterpriseUserCardViewController *userCardViewController;
    UIView *moreFounctionView;
    UISearchDisplayController *searchDisplayController;
    UISearchBar *tmpSearchBar;
    
    NSMutableArray *resultArray;//搜索结果使用
    NSMutableArray *allContactArray;//企业通讯录中所有的联系人
    NSInteger nowSelectIndex;
    NSInteger nowResultSelectIndex;
    
    ILBarButtonItem *rightItem;
}

@end

@implementation EnterpriseContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    nowSelectIndex = -1;
    nowResultSelectIndex = -1;
    self.view.backgroundColor = [UIColor whiteColor];
    resultArray = [[NSMutableArray alloc] init];
    allContactArray = [[NSMutableArray alloc] init];
    
    [self setupViews];
    [self loadData];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_ENTERPRISECONTACT_FINISHED_LOAD object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationEnterpriseContactFinishedLoad:) name:NOTIFICATION_ENTERPRISECONTACT_FINISHED_LOAD object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_R_SQL_USER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRSQLUser) name:NOTIFICATION_R_SQL_USER object:nil];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=YES;
}
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
//    appDelegate.centerButton.hidden=NO;
    [self hiddenMoreFounctionView];
    [searchDisplayController setActive:NO animated:NO];
    [self hiddenDetailInfoView];
}

-(void)notificationRSQLUser{
    [self loadEnterpriseContactsData:YES];
}

-(void)notificationEnterpriseContactFinishedLoad:(NSNotification*)notification{
    [self loadEnterpriseContactsData:YES];
}

-(void)reloadAndConfigureStepBar
{
    if (self.stepBarData && [self.stepBarData count]>0) {
        RMStepsBar *stepBar =[[RMStepsBar alloc] initWithFrame:CGRectMake(40, 7, 220, 30.0f)];
        stepBar.layer.masksToBounds = YES;
        stepBar.layer.cornerRadius = 8.0f;
        [stepBar setDelegate:self];
        [stepBar setDataSource:self];
        [stepBar setSeperatorColor:[UIColor blackColor]];
        stepBar.translatesAutoresizingMaskIntoConstraints = YES;
        self.stepBar =stepBar;
        [stepBar setBackgroundImage:[UIImage createImageWithColor:[UIColor hexChangeFloat:@"BCBCBC"] rect:CGRectMake(0, 0, boundsWidth, 30)] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           self.navigationItem.titleView = stepBar;
        });
        [stepBar reloadData];
    }
}

#pragma mark -
#pragma mark - 用户侧滑详情界面
-(void)showUserDetailWith:(id)enterprise
{
    ((KKNavigationController *)self.navigationController).canDragBack = NO;
    tmpSearchBar.userInteractionEnabled = NO;
    if(!userCardViewController)
    {
        userCardViewController =[[EnterpriseUserCardViewController alloc] initWithNibName:@"EnterpriseUserCardViewController" bundle:[NSBundle mainBundle]];
        userCardViewController.viewWidth = boundsWidth-60;
        [self.view addSubview:userCardViewController.view];
        [self addChildViewController:userCardViewController];
        
        UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
        rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenDetailInfoView)];
        rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:rightSwipeGestureRecognizer];
        userCardViewController.view.frame = CGRectMake(boundsWidth, 0, boundsWidth-70, self.view.frame.size.height);
        CGRect frame = userCardViewController.tbView.frame;
        frame.size.width = boundsWidth-70;
        frame.size.height=self.view.frame.size.height-110;
        userCardViewController.tbView.frame = frame;
        userCardViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
        userCardViewController.view.layer.shadowOffset = CGSizeMake(2, 2);
        userCardViewController.view.layer.shadowOpacity = 1.0;
        userCardViewController.view.layer.shadowRadius = 3;
    }
    if(userCardViewController.view.frame.origin.x == boundsWidth)
    {
        [UIView animateWithDuration:0.5 animations:^{
            ((KKNavigationController *)self.navigationController).canDragBack = NO;
            tmpSearchBar.userInteractionEnabled = NO;
            userCardViewController.view.frame = CGRectMake(70, 0, boundsWidth-70, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            ((KKNavigationController *)self.navigationController).canDragBack = NO;
            tmpSearchBar.userInteractionEnabled = NO;
        }];
    }
    [self.view bringSubviewToFront:userCardViewController.view];
    tmpSearchBar.userInteractionEnabled = NO;
    userCardViewController.user = enterprise;
    [userCardViewController reloadUserInfoView];
}

-(void)hiddenDetailInfoView
{
    tmpSearchBar.userInteractionEnabled = NO;
    ((KKNavigationController *)self.navigationController).canDragBack = NO;
    nowResultSelectIndex = -1;
    nowSelectIndex = -1;
    CGRect frame = userCardViewController.view.frame;
    frame.origin.x = boundsWidth;
    [UIView animateWithDuration:0.5 animations:^{
        userCardViewController.view.frame = frame;
        tmpSearchBar.userInteractionEnabled = NO;
        ((KKNavigationController *)self.navigationController).canDragBack = NO;
    } completion:^(BOOL finished) {
        if(finished)
        {
            tmpSearchBar.userInteractionEnabled = YES;
            ((KKNavigationController *)self.navigationController).canDragBack = YES;
        }
    }];
}

#pragma mark -
#pragma mark - 部门更多功能界面以及事件
-(void)showMoreFounctionView
{
    if(!moreFounctionView)
    {
        moreFounctionView = [[UIView alloc] initWithFrame:CGRectMake(0, boundsHeight-(viewWithNavNoTabbar), boundsWidth, viewWithNavNoTabbar)];
        moreFounctionView.backgroundColor = [UIColor hexChangeFloat:@"000000" alpha:0.5];
        moreFounctionView.alpha = 0;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 85)];
        view.backgroundColor = [UIColor whiteColor];
        [moreFounctionView addSubview:view];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(boundsWidth-31, -6, 12, 6)];
        imageView.image = [UIImage imageNamed:@"more_triangle.png"];
        [view addSubview:imageView];
        
        CGFloat buttonWidth = boundsWidth/4;
        for(int i = 0 ; i < 4 ; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0+buttonWidth*i, 8, buttonWidth, 50);
            [view addSubview:button];
        
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.origin.x, button.frame.size.height+button.frame.origin.y, button.frame.size.width, 14)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor hexChangeFloat:@"878787"];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:12.0f];
            [view addSubview:label];
            
            switch (i) {
                case 0:
                    [button addTarget:self action:@selector(createGroupIM:) forControlEvents:UIControlEventTouchUpInside];
                    [button setImage:[UIImage imageNamed:@"group_im.png"] forState:UIControlStateNormal];
                    label.text = LOCALIZATION(@"EnterpriseContactsViewController_GroupChat");
//                    label.text = LOCALIZATION(@"Message_GroupChat");
                    break;
                case 1:
                    [button addTarget:self action:@selector(createGroupNotification:) forControlEvents:UIControlEventTouchUpInside];
                    [button setImage:[UIImage imageNamed:@"group_noti.png"] forState:UIControlStateNormal];
                    label.text =LOCALIZATION(@"EnterpriseContactsViewController_CreateNoti");
//                    label.text = LOCALIZATION(@"Message_BulkNotification");
                    break;
                case 2:
                    [button addTarget:self action:@selector(createGroupMessage:) forControlEvents:UIControlEventTouchUpInside];
                    [button setImage:[UIImage imageNamed:@"group_msg.png"] forState:UIControlStateNormal];
                    label.text = LOCALIZATION(@"EnterpriseContactsViewController_GroupMessage");
//                    label.text = LOCALIZATION(@"Message_BulkMessage");
                    break;
                case 3:
                    [button addTarget:self action:@selector(createGroupEmail:) forControlEvents:UIControlEventTouchUpInside];
                    [button setImage:[UIImage imageNamed:@"group_email.png"] forState:UIControlStateNormal];
                    label.text = LOCALIZATION(@"EnterpriseContactsViewController_GroupMail");
//                    label.text = LOCALIZATION(@"Message_BulkMail");
                    break;
 
                default:
                    break;
            }
        }
    }
    [self.navigationController.view addSubview:moreFounctionView];
    ((GQNavigationController *)(self.navigationController)).canDragBack = NO;
    [UIView animateWithDuration:0.3 animations:^{
        moreFounctionView.alpha = 1;
    }];
}

-(void)hiddenMoreFounctionView
{
    ((GQNavigationController *)(self.navigationController)).canDragBack = YES;
    [UIView animateWithDuration:0.3 animations:^{
        moreFounctionView.alpha = 0;
    } completion:^(BOOL finished) {
        [moreFounctionView removeFromSuperview];
        [rightItem setIsSelected:NO];
    }];
}


-(void)createGroupIM:(UIButton *)sender
{
    NSLog(@"新建群组");
    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"EnterpriseContactsViewController_CreateGroup") isDismissLater:NO];
//    [MMProgressHUD showHUDWithTitle: LOCALIZATION(@"Message_Being_component_group") isDismissLater:NO];
    [self.m_selectedUsers removeAllObjects];
    for(id model in self.enterpriseContacts)
    {
        if([model isKindOfClass:[MEnterpriseDept class]])
        {
            NSMutableArray *array = [self getEnterpriseTableDataByCId:[NSString stringWithFormat:@"%lld", [((MEnterpriseDept *)model).cid longLongValue]]];
            for(id model in array)
            {
                MEnterpriseUser *user = model;
                [self.m_selectedUsers setObject:user.uname forKey:user.uid];
            }
        }
        else if([model isKindOfClass:[MEnterpriseUser class]])
        {
            MEnterpriseUser *user = model;
            [self.m_selectedUsers setObject:user.uname forKey:user.uid];
        }
    }
    NSLog(@"%@",self.m_selectedUsers);
    [self handleGroup];
}

-(void)createGroupNotification:(UIButton *)sender
{
    CreatNotiViewController *vc = [[CreatNotiViewController alloc] init];
    NSMutableArray *msgArray = [NSMutableArray array];
    for(id model in self.enterpriseContacts)
    {
        if([model isKindOfClass:[MEnterpriseDept class]])
        {
            NSMutableArray *array = [self getEnterpriseTableDataByCId:[NSString stringWithFormat:@"%lld", [((MEnterpriseDept *)model).cid longLongValue]]];
            
            [msgArray addObjectsFromArray:array];
        }
        else if([model isKindOfClass:[MEnterpriseUser class]])
        {
            [msgArray addObject:model];
        }
    }
    [vc.userArray addObjectsFromArray:msgArray];
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"新建通知");
}

-(void)createGroupMessage:(UIButton *)sender
{
    NSLog(@"群发短信");
    NSMutableArray *msgArray = [NSMutableArray array];
    for(id model in self.enterpriseContacts)
    {
        if([model isKindOfClass:[MEnterpriseDept class]])
        {
            NSMutableArray *array = [self getEnterpriseTableDataByCId:[NSString stringWithFormat:@"%lld", [((MEnterpriseDept *)model).cid longLongValue]]];
            for(id model in array)
            {
                MEnterpriseUser *user = model;
                [msgArray addObject:user.mobile];
            }
        }
        else if([model isKindOfClass:[MEnterpriseUser class]])
        {
            MEnterpriseUser *user = model;
            [msgArray addObject:user.mobile];
        }
    }
    [self sendSmsWithPhones:msgArray];
}

-(void)createGroupEmail:(UIButton *)sender
{
    NSLog(@"群发邮件");
    NSMutableArray *msgArray = [NSMutableArray array];
    for(id model in self.enterpriseContacts)
    {
        if([model isKindOfClass:[MEnterpriseDept class]])
        {
            NSMutableArray *array = [self getEnterpriseTableDataByCId:[NSString stringWithFormat:@"%lld", [((MEnterpriseDept *)model).cid longLongValue]]];
            for(id model in array)
            {
                MEnterpriseUser *user = model;
                [msgArray addObject:user.email];
            }
        }
        else if([model isKindOfClass:[MEnterpriseUser class]])
        {
            MEnterpriseUser *user = model;
            [msgArray addObject:user.email];
        }
    }
    [self sendEmailWithEmails:msgArray];
}

#pragma mark 组装视图
-(void)setupViews{
    self.enterpriseTBView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, boundsWidth, viewWithNavNoTabbar-44)];
    self.enterpriseTBView.backgroundColor=[UIColor hexChangeFloat:@"f2f2f2"];
    self.enterpriseTBView.delegate = self;
    self.enterpriseTBView.dataSource = self;
    self.enterpriseTBView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.enterpriseTBView];
    [self handleNormalNavigationBarItem];

    self.nibEnterpriseContacts =[UINib nibWithNibName:@"GQEnterpriseContactsCell" bundle:[NSBundle mainBundle]];
    self.enterpriseTBView.tableFooterView =[[UIView alloc] init];
 
    tmpSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 44)];
    tmpSearchBar.delegate = self;
    tmpSearchBar.placeholder = LOCALIZATION(@"ColleagueViewController_Search");
//    tmpSearchBar.placeholder =LOCALIZATION(@"ColleagueViewController_Search");
//    tmpSearchBar.placeholder = LOCALIZATION(@"Message_FindPeople");
    [self.view addSubview:tmpSearchBar];
    UIImage *img = [UIImage createImageWithColor:[UIColor hexChangeFloat:@"f2f2f2"] size:CGSizeMake(boundsWidth, 30)];
    [tmpSearchBar setBackgroundImage:img];
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:tmpSearchBar contentsController:self];
    searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;;
    searchDisplayController.delegate = self;
    // searchResultsDataSource 就是 UITableViewDataSource
    searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    searchDisplayController.searchResultsDelegate = self;
}

#pragma mark 导航条点击事件
-(void)clickLeftItem:(id)sender{
    if([self.enterpriseContacts count])
    {
        id enterprise = [self.enterpriseContacts objectAtIndex:0];
        if ([enterprise isKindOfClass:[MEnterpriseUser class ]]) {
            [self stepsBar:self.stepBar shouldSelectStepAtIndex:0];
        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)clickRightItem:(id)sender{
    [rightItem setIsSelected:!rightItem.isSelected];
    if(rightItem.isSelected)
    {
        [self showMoreFounctionView];
    }
    else
    {
        [self hiddenMoreFounctionView];
    }
}

#pragma mark -------------------------------------------------------------------------
#pragma mark 加载数据
-(void)loadData{
    //add by 陆浩
    [self loadEnterpriseContactsData:NO];
    //end
}

#pragma mark 加载企业通讯录数据
-(void)loadEnterpriseContactsData:(BOOL)isReload{
    self.enterpriseData =[[NSMutableDictionary alloc] init];
    self.enterpriseDeptData =[[NSMutableDictionary alloc] init];
    self.enterpriseUserData =[[NSMutableDictionary alloc] init];
    self.stepBarData =[[NSMutableArray alloc] init];
    self.m_selectedUsers =[[NSMutableDictionary alloc] init];
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf loadEnterpriseDataWithCompletionBlock:^{
            [weakSelf loadEnterpriseContactsRootData];
        } isReload:isReload];
    });
}

#pragma mark 加载企业通讯录根目录
-(void)loadEnterpriseContactsRootData{
    WEAKSELF
    if (self.isUserDept&&![[[ConfigManager sharedInstance].userDictionary objectForKey:@"userType"] isEqualToString:@"admin"])
    {
        MEnterpriseDept *dept =[[MEnterpriseDept alloc] init];
        dept.cid = [[ConfigManager sharedInstance].userDictionary  objectForKey:@"cid"];
        dept.cname =[[ConfigManager sharedInstance].userDictionary objectForKey:@"gname"];
        weakSelf.enterpriseCurrentDept =dept;
        weakSelf.enterpriseContacts =[weakSelf getEnterpriseTableDataByCId:dept.cid];
        weakSelf.enterpriseUsers=[weakSelf getEnterpriseTableUserDataByCId:dept.cid];
        
        MEnterpriseDept *stepDept =[[MEnterpriseDept alloc] init];
        stepDept.cid =[[ConfigManager sharedInstance].userDictionary  objectForKey:@"cid"];
        stepDept.cname = [[ConfigManager sharedInstance].userDictionary objectForKey:@"cname"];
        weakSelf.stepBarData =[NSMutableArray arrayWithObject:stepDept];
        [weakSelf.enterpriseTBView reloadData];
        
        [weakSelf reloadAndConfigureStepBar];
    }
    else
    {
        MEnterpriseDept *dept =[[MEnterpriseDept alloc] init];
        dept.cid = @"0";
        dept.cname =[[ConfigManager sharedInstance].userDictionary objectForKey:@"gname"];
        weakSelf.enterpriseCurrentDept =dept;
        weakSelf.enterpriseContacts =[weakSelf getEnterpriseTableDataByCId:dept.cid];
        weakSelf.enterpriseUsers=[weakSelf getEnterpriseTableUserDataByCId:dept.cid];
        
        MEnterpriseDept *stepDept =[[MEnterpriseDept alloc] init];
        stepDept.cid = @"0";
        stepDept.cname = [[ConfigManager sharedInstance].userDictionary objectForKey:@"gname"];
        weakSelf.stepBarData =[NSMutableArray arrayWithObject:stepDept];
        [weakSelf.enterpriseTBView reloadData];
        
        [weakSelf reloadAndConfigureStepBar];
    }
    
}

#pragma mark 加载企业通讯录数据
-(void) loadEnterpriseDataWithCompletionBlock:(void (^)(void))completionBlock isReload:(BOOL)isReload{
    if (!isReload && [self.enterpriseDeptData count]>0&& [self.enterpriseUserData count]>0) {
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

#pragma mark 处理正常情况下的导航条
-(void)handleNormalNavigationBarItem{
    self.navigationItem.title = @"";
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
//    rightItem=[ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_function.png"] selectedImage:[UIImage imageNamed:@"nav_function_select.png"] target:self action:@selector(clickRightItem:)];
//    [self.navigationItem setRightBarButtonItem:rightItem];
}

#pragma mark  根据部门ID获取该部门子部门
-(NSMutableArray *)getEnterpriseTableDataByCId:(NSString*)cid
{
    NSMutableArray *tableData =[[NSMutableArray alloc] init];
    
    //加载子部门
    NSString *childIds=[self.enterpriseData objectForKey:[NSString stringWithFormat:@"%@s",cid]];
    if(![childIds isEqualToString:@""]){
        NSArray *departIds=[childIds componentsSeparatedByString:@","];
        NSMutableArray *sortArr=[[NSMutableArray alloc] initWithCapacity:[departIds count]];
        for (NSString *key in departIds) {
            MEnterpriseDept *dept =[self.enterpriseDeptData objectForKey:key];
            dept.selectedNumber =[NSNumber numberWithInt:-1];
            [sortArr addObject:dept];
        }
        [tableData addObjectsFromArray:sortArr];
    }
    return tableData;
}
#pragma mark  根据部门ID获取该部门人员
-(NSMutableArray *)getEnterpriseTableUserDataByCId:(NSString*)cid
{
    NSMutableArray *tableData =[[NSMutableArray alloc] init];
    //加载当前部门的人员
    NSString *userChildIds=[self.enterpriseData objectForKey:[NSString stringWithFormat:@"%@u",cid]];
    if(userChildIds &&userChildIds.length>0){
        
        NSArray *userIds=[userChildIds componentsSeparatedByString:@","];
        NSMutableArray *sortArr=[[NSMutableArray alloc] initWithCapacity:[userIds count]];
        for (NSString *key in userIds) {
            MEnterpriseUser *user =[self.enterpriseUserData objectForKey:key];
            user.normal =YES;
            [sortArr addObject:user];
        }
        [tableData addObjectsFromArray:sortArr];
        
    }
    return tableData;
}

#pragma mark RMStepsBarDataSource
- (NSUInteger)numberOfStepsInStepsBar:(RMStepsBar *)bar{
    return [self.stepBarData count];
    
}
- (RMStep *)stepsBar:(RMStepsBar *)bar stepAtIndex:(NSUInteger)index{
    RMStep *step=[[RMStep alloc] init];

    [step setDisabledTextColor:MainColor];
    [step setSelectedTextColor:[UIColor hexChangeFloat:@"2D2D2D"]];
    [step setEnabledTextColor:MainColor];

    [step setSelectedBarColor:[UIColor hexChangeFloat:@"BCBCBC"]];
    [step setEnabledBarColor:[UIColor hexChangeFloat:@"D7D7D7"]];
    [step setDisabledBarColor:[UIColor hexChangeFloat:@"D7D7D7"]];
    
    MEnterpriseDept *dept=[self.stepBarData objectAtIndex:index];
    [step setTitle:dept.cname];
    return step;
}

#pragma mark RMStepsBarDelegate
- (void)stepsBarDidSelectCancelButton:(RMStepsBar *)bar{
    
}

- (void)stepsBar:(RMStepsBar *)bar shouldSelectStepAtIndex:(NSInteger)index{
    if(index < [self.stepBarData count]-1)
    {
        [self hiddenDetailInfoView];
    }
    MEnterpriseDept *stepDept =[self.stepBarData objectAtIndex:index];
    MEnterpriseDept *enterpriseCurrentDept =self.enterpriseCurrentDept;
    enterpriseCurrentDept.cid =stepDept.cid;
    enterpriseCurrentDept.cname=stepDept.cname;
    enterpriseCurrentDept.pid=stepDept.pid;
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        weakSelf.enterpriseContacts =[weakSelf getEnterpriseTableDataByCId:[NSString stringWithFormat:@"%lld", [enterpriseCurrentDept.cid longLongValue]]];
        weakSelf.enterpriseUsers = [weakSelf getEnterpriseTableUserDataByCId:[NSString stringWithFormat:@"%lld", [enterpriseCurrentDept.cid longLongValue]]];
        
        if (index <[self.stepBarData count]) {
            [self.stepBarData removeObjectsInRange:NSMakeRange(index+1, [self.stepBarData count]-index-1)];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.enterpriseTBView setContentOffset:CGPointMake(0, 0) animated:NO];
            [weakSelf.enterpriseTBView reloadData];
            [weakSelf reloadAndConfigureStepBar];
        });
    });
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor hexChangeFloat:@"d9e9f9"];
    
    if(tableView == self.enterpriseTBView)
    {
        if (indexPath.section==0)
        {
            MEnterpriseDept *dept =[self.enterpriseContacts objectAtIndex:indexPath.row];
            MEnterpriseDept *enterpriseCurrentDept =self.enterpriseCurrentDept;
            enterpriseCurrentDept.cid =dept.cid;
            enterpriseCurrentDept.cname=dept.cname;
            enterpriseCurrentDept.pid=dept.pid;
            WEAKSELF
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                weakSelf.enterpriseContacts =[weakSelf getEnterpriseTableDataByCId:[NSString stringWithFormat:@"%lld", [enterpriseCurrentDept.cid longLongValue]]];
                weakSelf.enterpriseUsers=[weakSelf getEnterpriseTableUserDataByCId:[NSString stringWithFormat:@"%lld", [enterpriseCurrentDept.cid longLongValue]]];
                MEnterpriseDept *stepDept =[[MEnterpriseDept alloc] init];
                stepDept.cid =dept.cid;
                stepDept.cname=dept.cname;
                stepDept.pid=dept.pid;
                [weakSelf.stepBarData addObject:stepDept];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.enterpriseTBView setContentOffset:CGPointMake(0, 0) animated:NO];
                    [weakSelf.enterpriseTBView reloadData];
                    [weakSelf reloadAndConfigureStepBar];
                });
            });
        }
        else if (indexPath.section==1)
        {
            MEnterpriseUser *enterprise =[self.enterpriseUsers objectAtIndex:indexPath.row];
            if(nowSelectIndex == indexPath.row)
            {
                [self hiddenDetailInfoView];
            }
            else
            {
                nowSelectIndex = indexPath.row;
                
                
                [self showUserDetailWith:enterprise];
            }
        }
    }
    else{
        if(nowResultSelectIndex == indexPath.row)
        {
            [self hiddenDetailInfoView];
        }
        else
        {
            nowResultSelectIndex = indexPath.row;
            id enterprise= [resultArray objectAtIndex:indexPath.row];
            [self showUserDetailWith:enterprise];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
}


#pragma mark UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView==self.enterpriseTBView) {
        return 2;
    }
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.enterpriseTBView)
    {
        if (section==0)
        {
            return [self.enterpriseContacts count];
        }
        else
        {
            return [self.enterpriseUsers count];
        }
    }
    else
    {
        return [resultArray count];;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GQEnterpriseContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GQEnterpriseContactsCell"];
    if(!cell){
        cell=(GQEnterpriseContactsCell*)[[self.nibEnterpriseContacts instantiateWithOwner:self options:nil] objectAtIndex:0];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 49.5)];
        view.layer.masksToBounds = YES;
        view.backgroundColor = [UIColor hexChangeFloat:@"d9e9f9"];
        cell.selectedBackgroundView = view;
    }
    if(tableView == self.enterpriseTBView){
        if (indexPath.section==0)
        {
            cell.enterprise= [self.enterpriseContacts objectAtIndex:indexPath.row];
        }
        else if (indexPath.section==1)
        {
            cell.enterprise= [self.enterpriseUsers objectAtIndex:indexPath.row];
        }
    }
    else{
        
        MEnterpriseUser *model = [resultArray objectAtIndex:indexPath.row];
        model.normal = YES;
        cell.enterprise = model;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return EdgeDis;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *myView=[[UIView alloc]init];
    myView.backgroundColor=[UIColor hexChangeFloat:@"f2f2f2"];
    return myView;
}
#pragma mark - UISearchDisplayController delegate
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
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


#pragma mark OCUCMailCellDelegate
-(void)sendEmailWithEmails:(NSArray*)emails
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposeViewController =[[MFMailComposeViewController alloc] init];
        mailComposeViewController.mailComposeDelegate=self;
        [mailComposeViewController setSubject:@""];                                               //邮件主题
        [mailComposeViewController setToRecipients:emails]; //收件人
//        [mailComposeViewController setCcRecipients:[NSArray array]];                              //抄送
//        [mailComposeViewController setBccRecipients:[NSArray array]];                             //密送
        [mailComposeViewController setMessageBody:@"" isHTML:NO];                                 //邮件内容
        //self.mailCompose =self.mailComposeViewController;
        [self presentViewController:mailComposeViewController animated:YES completion:nil];
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
        MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];
        messageComposeViewController.messageComposeDelegate = self;
        [messageComposeViewController setRecipients:phoneNumbers];
        [messageComposeViewController setBody:@""];
        //self.messageCompose =self.messageComposeViewController;
        [self presentViewController:messageComposeViewController animated:YES completion:nil];
        
        
    }else{
        CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"deviceNOSMS", nil) cancelButtonTitle:NSLocalizedString(@"comfirm", nil)];
        alertView.showBlurBackground = YES;
        [alertView show];
    }
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
        
        //创建群组并添加人员
        NSMutableDictionary *params =[[NSMutableDictionary alloc] init];
        [params setObject:myToken forKey:@"token"];
        [params setObject:[NSNumber numberWithInt:0] forKey:@"isTemp"];
        [params setObject:LOCALIZATION(@"EnterpriseContactsViewController_TempChat") forKey:@"groupName"];
        [params setObject:userIds forKey:@"users"];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodCreateGroup] parameters:params successBlock:^(BOOL success, id data, NSString *msg) {

            [MMProgressHUD dismiss];
            
            NSDictionary *gitem =[data objectForKey:@"groupChat"];
            MGroup *mg =[[MGroup alloc] init];
            mg.createTime =[gitem objectForKey:@"createTime"];
            mg.groupName =[gitem objectForKey:@"groupName"];
            mg.groupid =[NSString stringWithFormat:@"%@",[gitem objectForKey:@"groupid"]];
            mg.len =[gitem objectForKey:@"userCount"];
            mg.name =[gitem objectForKey:@"name"];
            mg.isTemp =[gitem objectForKey:@"isTemp"];
            mg.uid =[gitem objectForKey:@"uid"];
            mg.ver =[gitem objectForKey:@"ver"];
            mg.maxLen =[gitem objectForKey:@"maxLen"];
            NSMutableArray *groupUsers =[self handleSelectedGroupUsers:userIds groupId:[NSString stringWithFormat:@"%@",[gitem objectForKey:@"groupid"]]];
            mg.users =[NSArray arrayWithArray:groupUsers];
            [[SQLiteManager sharedInstance] insertGroupsToSQLite:[NSArray arrayWithObject:mg]];
            [[SQLiteManager sharedInstance] insertGroupUsersToSQLite:groupUsers notificationName:NOTIFICATION_R_SQL_GROUPUSER];
            
        //添加跳转
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                MGroup *group = mg;
                ChatViewController *chatVC =[[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:[NSBundle mainBundle]];
                chatVC.chatGroup = group;
                chatVC.isGroup =YES;
                [self.navigationController pushViewController:chatVC animated:YES];
            });
            
            
            
        } failureBlock:^(NSString *description) {
            NSLog(@"url=%@,error=%@",[HTTPAddress MethodCreateGroup],description);
            [MMProgressHUD dismiss];
        }];
    });
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


NSInteger nickNameSort(id user1, id user2, void *context)
{
    MEnterpriseUser *u1,*u2;
    //类型转换
    u1 = (MEnterpriseUser*)user1;
    u2 = (MEnterpriseUser*)user2;
    return  [u1.pinyin localizedCompare:u2.pinyin];
}


@end