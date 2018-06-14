//
//  EnterpriseMangerViewController.m
//  IM
//
//  Created by ZteCloud on 15/10/23.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "EnterpriseMangerViewController.h"
#import "NewDepartmentViewController.h"
#import "NewColleagueViewController.h"
#import "TableViewCell_deptManager.h"
#import "AmendColleagueViewController.h"
#import "AmendDepartmentViewController.h"

@interface EnterpriseMangerViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,RMStepsBarDataSource,RMStepsBarDelegate,UISearchDisplayDelegate>
{
    
    NSArray *belowTitles,*detpTitles;
    NSMutableArray *deptArrs;
    NSMutableArray *collectContactArray;
    NSMutableArray *allContactArray;//企业通讯录中所有的联系人
    UINib *nibUserManagerCell;
    
    UISearchDisplayController *searchDisplayController;
    UISearchBar *tmpSearchBar;
    NSMutableArray *resultArray;//搜索结果使用
}

@end

@implementation EnterpriseMangerViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    collectContactArray = [[NSMutableArray alloc]initWithCapacity:0];
    allContactArray =[[NSMutableArray alloc]initWithCapacity:0];
    resultArray = [[NSMutableArray alloc]initWithCapacity:0];
    [self refreshCollectContacts];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshCollectContacts" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCollectContacts) name:@"refreshCollectContacts" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_ENTERPRISECONTACT_FINISHED_LOAD object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationEnterpriseContactFinishedLoad:) name:NOTIFICATION_ENTERPRISECONTACT_FINISHED_LOAD object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_D_SQL_USER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRSQLUser) name:NOTIFICATION_D_SQL_USER object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_D_SQL_DEPT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRSQLUser) name:NOTIFICATION_D_SQL_DEPT object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_R_SQL_DEPT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRSQLUser) name:NOTIFICATION_R_SQL_DEPT object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_R_SQL_USER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRSQLUser) name:NOTIFICATION_R_SQL_USER object:nil];
    
    [self handleNavigationBarItem];
//    detpTitles=[NSArray arrayWithObjects:@"企业互联",@"会议云",@"人事云",@"呼叫云",@"财务云",@"技术云", nil];
    [self setBelowBtn];
    [self setTable];
    [self loadData];

}
-(void)loadDept
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *myGId=[[ConfigManager sharedInstance].userDictionary objectForKey:@"gid"];
        NSArray *departArr=[[SQLiteManager sharedInstance] getAllDeptByGId:myGId];
        deptArrs=[[NSMutableArray alloc]initWithArray:departArr];
        [_mainTable reloadData];
    });
    
}
-(void)notificationRSQLUser{
    [self loadData];
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
#pragma mark------setTable
-(void)setTable
{
    _mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, boundsWidth, viewWithNavAndTabbar-44) style:UITableViewStylePlain];
    _mainTable.backgroundColor=BGColor;
    _mainTable.delegate=self;
    _mainTable.dataSource=self;
    _mainTable.showsVerticalScrollIndicator=NO;
    self.mainTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_mainTable];
    [Common setExtraCellLineHidden:_mainTable];
    [_mainTable registerNib:[UINib nibWithNibName:@"TableViewCell_deptManager" bundle:nil] forCellReuseIdentifier:@"Cell2"];
    nibUserManagerCell =[UINib nibWithNibName:@"GQEnterpriseContactsCell" bundle:[NSBundle mainBundle]];
    
    
    tmpSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 44)];
    tmpSearchBar.delegate = self;
    tmpSearchBar.placeholder = @"找人";
    tmpSearchBar.placeholder =LOCALIZATION(@"ColleagueViewController_Search");
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
#pragma mark-----setBelowBtn
-(void)setBelowBtn
{
    belowTitles=[[NSArray alloc]initWithObjects:LOCALIZATION(@"EnterpriseMangerViewController_NewDept"),LOCALIZATION(@"EnterpriseMangerViewController_NewColleague"), nil];
    NSArray *imgs=[NSArray arrayWithObjects:@"new_department",@"new_colleague", nil];
    for (int i=0; i<2; i++)
    {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(boundsWidth/2*i, viewWithNavAndTabbar, boundsWidth/2, 48);
        [btn setTitle:belowTitles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imgs[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(belowBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i+1;
        [self.view addSubview:btn];
    }
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(boundsWidth/2, viewWithNavAndTabbar, 0.5, 48)];
    lineView.backgroundColor=BGColor;
    [self.view addSubview:lineView];
}
#pragma mark------tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.mainTable)
    {
        if (section==0) {
            return self.enterpriseDepts.count;
        }
        if (section==1) {
            return self.enterpriseUsers.count;
        }
    }
    return resultArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==self.mainTable)
    {
        return 2;
    }
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.mainTable)
    {
        TableViewCell_deptManager *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell2"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //    if(!cell){
        //        cell=(TableViewCell_deptManager*)[[deptManagerCell instantiateWithOwner:self options:nil] objectAtIndex:0];
        //    }
        
        switch (indexPath.section) {
            case 0:
            {
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                MEnterpriseDept *md=self.enterpriseDepts[indexPath.row];
                cell.deptLabel.text=[NSString stringWithFormat:@"%@",md.cname];
                [cell.selectBtn setImage:[UIImage imageNamed:@"enter_manager"] forState:UIControlStateNormal];
                [cell.selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.selectBtn.tag=indexPath.row;
                
                
                
            }
                break;
            case 1:
            {
                //            cell.accessoryType=UITableViewCellAccessoryNone;
                //            MEnterpriseUser *mUser=[self.enterpriseUsers objectAtIndex:indexPath.row];
                //            cell.deptLabel.text=[NSString stringWithFormat:@"%@",mUser.uname];
                ////            cell.imageView.image= [UIImage imageNamed:@"default_head"];
                //            [cell.selectBtn setImageWithURL:nil forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_head"]];
                //            [cell.selectBtn setBackgroundImageWithURL:[NSURL URLWithString:mUser.bigpicurl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_head"]];
                //            cell.selectBtn.layer.cornerRadius=22;
                //            cell.selectBtn.layer.masksToBounds=YES;
                GQEnterpriseContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GQEnterpriseContactsCell"];
                if(!cell){
                    cell=(GQEnterpriseContactsCell*)[[nibUserManagerCell instantiateWithOwner:self options:nil] objectAtIndex:0];
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 49.5)];
                    view.backgroundColor = [UIColor hexChangeFloat:@"d9e9f9"];
                    cell.selectedBackgroundView = view;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.enterprise= [self.enterpriseUsers objectAtIndex:indexPath.row];
                return cell;
            }
                break;
            default:
                break;
        }
        return cell;
    }
    else
    {
        GQEnterpriseContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GQEnterpriseContactsCell"];
        if(!cell){
            cell=(GQEnterpriseContactsCell*)[[nibUserManagerCell instantiateWithOwner:self options:nil] objectAtIndex:0];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 49.5)];
            view.backgroundColor = [UIColor hexChangeFloat:@"d9e9f9"];
            cell.selectedBackgroundView = view;
        }
        MEnterpriseUser *model = [resultArray objectAtIndex:indexPath.row];
        model.normal = YES;
        cell.enterprise = model;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.mainTable)
    {
        if (indexPath.section==0)
        {
            MEnterpriseDept *dept =[self.enterpriseDepts objectAtIndex:indexPath.row];
            MEnterpriseDept *enterpriseCurrentDept =self.enterpriseCurrentDept;
            enterpriseCurrentDept.cid =dept.cid;
            enterpriseCurrentDept.cname=dept.cname;
            enterpriseCurrentDept.pid=dept.pid;
            WEAKSELF
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                weakSelf.enterpriseDepts =[weakSelf getEnterpriseTableDataByCId:[NSString stringWithFormat:@"%lld", [enterpriseCurrentDept.cid longLongValue]]];
                weakSelf.enterpriseUsers=[weakSelf getEnterpriseTableUserDataByCId:[NSString stringWithFormat:@"%lld", [enterpriseCurrentDept.cid longLongValue]]];
                MEnterpriseDept *stepDept =[[MEnterpriseDept alloc] init];
                stepDept.cid =dept.cid;
                stepDept.cname=dept.cname;
                stepDept.pid=dept.pid;
                [weakSelf.stepBarData addObject:stepDept];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.mainTable setContentOffset:CGPointMake(0, 0) animated:NO];
                    [weakSelf.mainTable reloadData];
                    [weakSelf reloadAndConfigureStepBar];
                });
            });
        }
        if (indexPath.section==1)
        {
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.backgroundColor = [UIColor hexChangeFloat:@"d9e9f9"];
            
            AmendColleagueViewController *avc=[[AmendColleagueViewController alloc]init];
            avc.amendUser=[self.enterpriseUsers objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:avc animated:YES];
        }
    }
    else
    {
        AmendColleagueViewController *avc=[[AmendColleagueViewController alloc]init];
        avc.amendUser=[resultArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:avc animated:YES];
        
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.mainTable)
    {
        if (indexPath.section==1)
        {
            return 50;
        }
        return 44;
    }
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == self.mainTable)
    {
        if(section == 0)
        {
            return 0;
        }
        else
        {
            return 20;
        }
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == self.mainTable)
    {
        if(section == 0)
        {
            return [[UIView alloc] initWithFrame:CGRectZero];
        }
    }
    return [[UIView alloc] initWithFrame:CGRectZero];
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section==0) {
//        return 41;
//    }
//    return EdgeDis;
//}
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *myView=[[UIView alloc]init];
//    myView.backgroundColor=BGColor;
//    if (section==0) {
//        UISearchBar *sb=[[UISearchBar alloc]initWithFrame:CGRectMake(EdgeDis, EdgeDis, boundsWidth-EdgeDis*2, 25)];
//        sb.placeholder=@"找人";
//        UIImage *img = [UIImage createImageWithColor:BGColor size:CGSizeMake(boundsWidth, 25)];
//        [sb setBackgroundImage:img];
//        sb.delegate=self;
//        [myView addSubview:sb];
//        
//    }
//    return myView;
//    
//}
#pragma mark--------belowBtnClick
-(void)belowBtnClick:(UIButton*)btn
{
    if (btn.tag==1)
    {
        NewDepartmentViewController *nvc=[[NewDepartmentViewController alloc]init];
        nvc.leaderDept=self.enterpriseCurrentDept;
        [self.navigationController pushViewController:nvc animated:YES];
    }
    else if (btn.tag==2)
    {
        NewColleagueViewController *nvc=[[NewColleagueViewController alloc]init];
        [self.navigationController pushViewController:nvc animated:YES];
    }
    
}
#pragma mark--------selectBtnClick
-(void)selectBtnClick:(UIButton*)btn
{
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:btn.tag inSection:0];
//    TableViewCell_deptManager *cell=[self.mainTable cellForRowAtIndexPath:indexPath];
    AmendDepartmentViewController *avc=[[AmendDepartmentViewController alloc]init];
    avc.dept=[self.enterpriseDepts objectAtIndex:btn.tag];
    avc.leaderDept=self.enterpriseCurrentDept.cname;
    [self.navigationController pushViewController:avc animated:YES];
}
-(void)notificationEnterpriseContactFinishedLoad:(NSNotification*)notification{
    NSString *myGId = [[ConfigManager sharedInstance].userDictionary objectForKey:@"gid"];
    NSArray *allUserArr =[[[SQLiteManager sharedInstance] getAllUserByGid:myGId] allValues];
    
    [allContactArray setArray:allUserArr];
    [self refreshCollectContacts];
}
-(void)refreshCollectContacts
{
    NSString *myGId = [[ConfigManager sharedInstance].userDictionary objectForKey:@"gid"];
    NSArray *allUserArr =[[[SQLiteManager sharedInstance] getAllUserByGid:myGId] allValues];
    
    [allContactArray setArray:allUserArr];
    [collectContactArray removeAllObjects];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([userDefault objectForKey:@"contact_collect_user_id"])
    {
        if([[userDefault objectForKey:@"contact_collect_user_id"] objectForKey:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]]])
        {
            NSArray *array = [[userDefault objectForKey:@"contact_collect_user_id"] objectForKey:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]]];
            for(NSString *uid in array)
            {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@", uid];
                [collectContactArray addObjectsFromArray:[allContactArray filteredArrayUsingPredicate:predicate]];
            }
        }
    }
}
#pragma mark 加载企业通讯录数据
-(void)loadData{
    
    _enterpriseDeptData =[[NSMutableDictionary alloc] init];
    _enterpriseUserData=[[NSMutableDictionary alloc] init];
    _enterpriseData =[[NSMutableDictionary alloc] init];
    WEAKSELF
    
    [weakSelf loadEnterpriseDataWithCompletionBlock:^{
        [weakSelf loadEnterpriseContactsRootData];
    }];
}
#pragma mark 加载企业通讯录部门数据
-(void) loadEnterpriseDataWithCompletionBlock:(void (^)(void))completionBlock{
    
    if ([_enterpriseDeptData count]>0) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *myGId=[[ConfigManager sharedInstance].userDictionary objectForKey:@"gid"];
        NSArray *departArr=[[SQLiteManager sharedInstance] getAllDeptByGId:myGId];
        NSArray *allUserArr =[[[SQLiteManager sharedInstance] getAllUserByGid:myGId] allValues];
//        NSArray *userArr = [allUserArr sortedArrayUsingFunction:nickNameSort context:NULL];
        [allContactArray setArray:allUserArr];
        for (MEnterpriseDept *md in departArr) {
            [_enterpriseDeptData setObject:md forKey:[NSString stringWithFormat:@"%lld",[md.cid longLongValue]]];
            
            NSString *pkey=[NSString stringWithFormat:@"%@p",md.cid];
            NSString *skey=[NSString stringWithFormat:@"%@s",md.cid];
            
            NSString *pskey=[NSString stringWithFormat:@"%@s",md.pid];
            NSString *ppkey=[NSString stringWithFormat:@"%@p",md.pid];
            
            //当前部门的子部门
            if (![_enterpriseData objectForKey:skey]) {
                [_enterpriseData setObject:@"" forKey:skey];
            }
            
            if (![_enterpriseData objectForKey:pkey]) {
                [_enterpriseData setObject:@"" forKey:pkey];
            }
            
            //添加当前部门上一级部门的子部门
            NSString *psValue=[_enterpriseData objectForKey:pskey];
            if(psValue && psValue.length>0){
                [_enterpriseData setObject:[NSString stringWithFormat:@"%@,%@",psValue,md.cid] forKey:pskey];
            }else{
                [_enterpriseData setObject:[NSString stringWithFormat:@"%lld",[md.cid longLongValue]]forKey:pskey];
            }
            
            //添加当前部门的父部门
            if([md.pid longLongValue]==0){
                [_enterpriseData setObject:@"" forKey:pkey];
            }else{
                NSString *ppValue =[_enterpriseData objectForKey:ppkey];
                if(ppValue && ppValue.length>0){
                    [_enterpriseData setObject:[NSString stringWithFormat:@"%@,%@", ppValue,md.pid] forKey:pkey];
                    
                }else{
                    [_enterpriseData setObject:[NSString stringWithFormat:@"%lld",[md.pid longLongValue]] forKey:pkey];
                }
            }
        }
        for (MEnterpriseUser *mu in allUserArr) {
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
    weakSelf.enterpriseCurrentDept=dept;
    weakSelf.enterpriseDepts=[weakSelf getEnterpriseTableDataByCId:dept.cid];
    weakSelf.enterpriseUsers=[weakSelf getEnterpriseTableUserDataByCId:dept.cid];
    
    [_mainTable reloadData];
    
    MEnterpriseDept *stepDept =[[MEnterpriseDept alloc] init];
    stepDept.cid = @"0";
    stepDept.cname = [[ConfigManager sharedInstance].userDictionary objectForKey:@"gname"];
    weakSelf.stepBarData =[NSMutableArray arrayWithObject:stepDept];
    
    [weakSelf reloadAndConfigureStepBar];
    

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
    
    
    MEnterpriseDept *stepDept =[self.stepBarData objectAtIndex:index];
    MEnterpriseDept *enterpriseCurrentDept =self.enterpriseCurrentDept;
    enterpriseCurrentDept.cid =stepDept.cid;
    enterpriseCurrentDept.cname=stepDept.cname;
    enterpriseCurrentDept.pid=stepDept.pid;
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        weakSelf.enterpriseDepts =[weakSelf getEnterpriseTableDataByCId:[NSString stringWithFormat:@"%lld", [enterpriseCurrentDept.cid longLongValue]]];
        weakSelf.enterpriseUsers = [weakSelf getEnterpriseTableUserDataByCId:[NSString stringWithFormat:@"%lld", [enterpriseCurrentDept.cid longLongValue]]];
        
        if (index <[self.stepBarData count]) {
            [self.stepBarData removeObjectsInRange:NSMakeRange(index+1, [self.stepBarData count]-index-1)];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.mainTable setContentOffset:CGPointMake(0, 0) animated:NO];
            [weakSelf.mainTable reloadData];
            [weakSelf reloadAndConfigureStepBar];
        });
    });
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
#pragma mark 处理导航条
-(void)handleNavigationBarItem{
//    self.navigationItem.title = @"企业管理";
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
}
-(void)clickLeftItem:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
