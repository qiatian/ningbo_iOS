//
//  SelectEnterpriseDeptViewController.m
//  IM
//
//  Created by ZteCloud on 15/10/22.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "SelectEnterpriseDeptViewController.h"
#import "TableViewCell_dept.h"
@interface SelectEnterpriseDeptViewController ()<UITableViewDataSource,UITableViewDelegate,RMStepsBarDelegate,RMStepsBarDataSource,GQEnterpriseContactsCellDelegate>
{
    UITableView *mainTable;
    GQEnterpriseContactsCell *nibEnterpriseContacts;
    NSMutableDictionary *enterpriseDeptData,*enterpriseData,*enterpriseUserData;
    NSMutableArray *stepBarData;
    BOOL selected;
}

@property (nonatomic, strong) NSMutableDictionary *allSelectDepts; //所有部门 每个已选部门 存放cname和cid 是否被选中
@property (nonatomic, strong) NSMutableDictionary *selectBtnClickedDict;


@end

@implementation SelectEnterpriseDeptViewController
@synthesize selectBlock;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _allSelectDepts = [NSMutableDictionary dictionary];
    _selectBtnClickedDict = [NSMutableDictionary dictionary];
//    _allSelectedRows = [NSMutableArray array];
    
    
    [self handleNavigationBarItem];
    [self setupViews];
    [self loadData];
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}

#pragma mark 组装视图



-(void)setupViews{

    self.navigationItem.title =LOCALIZATION(@"Message_Contact_person");
    
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, viewWithNavNoTabbar)];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    nibEnterpriseContacts =(GQEnterpriseContactsCell*)[UINib nibWithNibName:@"GQEnterpriseContactsCell" bundle:[NSBundle mainBundle]];

    [self.view addSubview:mainTable];
    [mainTable registerNib:[UINib nibWithNibName:@"TableViewCell_dept" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [Common setExtraCellLineHidden:mainTable];
    if ([mainTable respondsToSelector:@selector(setSeparatorInset:)])
    {
        [mainTable setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([mainTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [mainTable setLayoutMargins:UIEdgeInsetsZero];
    }
    

}
#pragma mark 加载企业通讯录数据
-(void)loadData{
    
    enterpriseDeptData =[[NSMutableDictionary alloc] init];
    enterpriseData =[[NSMutableDictionary alloc] init];
    enterpriseUserData=[[NSMutableDictionary alloc]init];
    stepBarData =[[NSMutableArray alloc] init];
    WEAKSELF
    
    [weakSelf loadEnterpriseDataWithCompletionBlock:^{
        [weakSelf loadEnterpriseContactsRootData];
    }];
}
#pragma mark 加载企业通讯录部门数据
-(void) loadEnterpriseDataWithCompletionBlock:(void (^)(void))completionBlock{
    
    if ([enterpriseDeptData count]>0) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *myGId=[[ConfigManager sharedInstance].userDictionary objectForKey:@"gid"];
        NSArray *departArr=[[SQLiteManager sharedInstance] getAllDeptByGId:myGId];
        
        
        NSArray *allUserArr =[[[SQLiteManager sharedInstance] getAllUserByGid:myGId] allValues];
        NSArray *userArr = [allUserArr sortedArrayUsingFunction:nickNameSort1 context:NULL];

        for (MEnterpriseDept *md in departArr) {
            [enterpriseDeptData setObject:md forKey:[NSString stringWithFormat:@"%lld",[md.cid longLongValue]]];
            
            NSString *pkey=[NSString stringWithFormat:@"%@p",md.cid];
            NSString *skey=[NSString stringWithFormat:@"%@s",md.cid];
            NSString *pskey=[NSString stringWithFormat:@"%@s",md.pid];
            NSString *ppkey=[NSString stringWithFormat:@"%@p",md.pid];
            
            //当前部门的子部门
            if (![enterpriseData objectForKey:skey]) {
                [enterpriseData setObject:@"" forKey:skey];
            }
            
            if (![enterpriseData objectForKey:pkey]) {
                [enterpriseData setObject:@"" forKey:pkey];
            }
            
            //添加当前部门上一级部门的子部门
            NSString *psValue=[enterpriseData objectForKey:pskey];
            if(psValue && psValue.length>0){
                [enterpriseData setObject:[NSString stringWithFormat:@"%@,%@",psValue,md.cid] forKey:pskey];
            }else{
                [enterpriseData setObject:[NSString stringWithFormat:@"%lld",[md.cid longLongValue]]forKey:pskey];
            }
            
            //添加当前部门的父部门
            if([md.pid longLongValue]==0){
                [enterpriseData setObject:@"" forKey:pkey];
            }else{
                NSString *ppValue =[enterpriseData objectForKey:ppkey];
                if(ppValue && ppValue.length>0){
                    [enterpriseData setObject:[NSString stringWithFormat:@"%@,%@", ppValue,md.pid] forKey:pkey];
                    
                }else{
                    [enterpriseData setObject:[NSString stringWithFormat:@"%lld",[md.pid longLongValue]] forKey:pkey];
                }
            }
        }
        for (MEnterpriseUser *mu in userArr) {
            mu.gname =[[ConfigManager sharedInstance].userDictionary objectForKey:@"gname"];
            [enterpriseUserData setObject:mu forKey:mu.uid];
            NSString *key=[NSString stringWithFormat:@"%@u",mu.cid];
            
            if(![enterpriseData objectForKey:key]){
                [enterpriseData setObject:mu.uid forKey:key];
            }else{
                NSString *value=[NSString stringWithFormat:@"%@,%@",[enterpriseData objectForKey:key],mu.uid];
                [enterpriseData setObject:value forKey:key];
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
    weakSelf.enterpriseUsers=[weakSelf getEnterpriseTableUserDataByCId:dept.cid];
    
    MEnterpriseDept *stepDept =[[MEnterpriseDept alloc] init];
    stepDept.cid =@"0";
    stepDept.cname =[[ConfigManager sharedInstance].userDictionary objectForKey:@"gname"];
    
    weakSelf.stepBarData =[NSMutableArray arrayWithObject:stepDept];
    [mainTable reloadData];
    [weakSelf reloadAndConfigureStepBar];
}
#pragma mark  根据部门ID获取该部门人员及子部门
-(NSMutableArray *)getEnterpriseTableDataByCId:(NSString*)cid
{
    NSMutableArray *tableData =[[NSMutableArray alloc] init];
    
    //加载子部门
    NSString *childIds=[enterpriseData objectForKey:[NSString stringWithFormat:@"%@s",cid]];
    if(![childIds isEqualToString:@""]){
        NSArray *departIds=[childIds componentsSeparatedByString:@","];
        NSMutableArray *sortArr=[[NSMutableArray alloc] initWithCapacity:[departIds count]];
        for (NSString *key in departIds) {
            MEnterpriseDept *dept =[enterpriseDeptData objectForKey:key];
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
    NSString *userChildIds=[enterpriseData objectForKey:[NSString stringWithFormat:@"%@u",cid]];
    if(userChildIds &&userChildIds.length>0){
        
        NSArray *userIds=[userChildIds componentsSeparatedByString:@","];
        NSMutableArray *sortArr=[[NSMutableArray alloc] initWithCapacity:[userIds count]];
        for (NSString *key in userIds) {
            MEnterpriseUser *user =[enterpriseUserData objectForKey:key];
            user.normal =YES;
            [sortArr addObject:user];
        }
        [tableData addObjectsFromArray:sortArr];
        
    }
    return tableData;
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
        
        RMStepsBar *stepBar =[[RMStepsBar alloc] initWithFrame:CGRectMake(0, 0,scrollWidth, 30.0f)];
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
        
//        self.navigationItem.titleView = self.stepBar;
        self.navigationItem.titleView = stepBarButtomScrollView;
        
    }
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
        if ([enterpriseCurrentDept.cid integerValue]==0) {
            weakSelf.enterpriseUsers = [weakSelf getEnterpriseTableUserDataByCId:[NSString stringWithFormat:@"%lld", [enterpriseCurrentDept.cid longLongValue]]];
        }
        
        if (index <[self.stepBarData count]) {
            [self.stepBarData removeObjectsInRange:NSMakeRange(index+1, [self.stepBarData count]-index-1)];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [mainTable setContentOffset:CGPointMake(0, 0) animated:NO];
            [mainTable reloadData];
            [weakSelf reloadAndConfigureStepBar];
        });
    });
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == mainTable){
        if (indexPath.section==0)
        {
            id enterprise= [self.enterpriseContacts objectAtIndex:indexPath.row];
            if ([enterprise isKindOfClass:[MEnterpriseDept class]]){
                MEnterpriseDept *dept =(MEnterpriseDept*)enterprise;
                MEnterpriseDept *enterpriseCurrentDept =self.enterpriseCurrentDept;
                enterpriseCurrentDept.cid =dept.cid;
                enterpriseCurrentDept.cname=dept.cname;
                enterpriseCurrentDept.pid=dept.pid;
                WEAKSELF
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    weakSelf.enterpriseContacts =[weakSelf getEnterpriseTableDataByCId:[NSString stringWithFormat:@"%lld", [enterpriseCurrentDept.cid longLongValue]]];
                    weakSelf.enterpriseUsers=[weakSelf getEnterpriseTableUserDataByCId:nil];
                    MEnterpriseDept *stepDept =[[MEnterpriseDept alloc] init];
                    stepDept.cid =dept.cid;
                    stepDept.cname=dept.cname;
                    stepDept.pid=dept.pid;
                    [weakSelf.stepBarData addObject:stepDept];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [mainTable setContentOffset:CGPointMake(0, 0) animated:NO];
                        [mainTable reloadData];
                        [weakSelf reloadAndConfigureStepBar];
                    });
                });
            }
        }
        
    }
    else{
        
            GQEnterpriseContactsCell *cell = (GQEnterpriseContactsCell *)[tableView cellForRowAtIndexPath:indexPath];
            [cell btnAccessoryClicked:cell.btnAccessory];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (_canMultiselect) {
        return 2;
    }
    return 1;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == mainTable){
        if (section==0) {
            return [self.enterpriseContacts count];
        }
        return [self.enterpriseUsers count];

    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        TableViewCell_dept *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        MEnterpriseDept *md;
        md=self.enterpriseContacts[indexPath.row];
        cell.deptLabel.text=[NSString stringWithFormat:@"%@",md.cname];
        [cell.selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectBtn.tag=indexPath.row;
        
        //全部cell的选中状态
        
        NSDictionary *dict = _allSelectDepts[md.cid];
        
        if ([dict[@"deptSelected"] boolValue]) {
            
            [cell.selectBtn setImage:[UIImage imageNamed:@"select_d"] forState:UIControlStateNormal];
            
        }else{
            
            [cell.selectBtn setImage:[UIImage imageNamed:@"select_no_d"] forState:UIControlStateNormal];
        }
        
        return cell;
    }
    else if (indexPath.section==1)
    {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell1"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell1"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        UIButton *selectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame=CGRectMake(EdgeDis, 7, 30, 30);
        [selectBtn setImage:[UIImage imageNamed:@"select_no_d"] forState:UIControlStateNormal];
        [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        selectBtn.tag=1111;
        [cell.contentView addSubview:selectBtn];
        UIButton *imgBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        imgBtn.frame=CGRectMake(selectBtn.frame.size.width+EdgeDis*2, 2, 40, 40);
        [imgBtn setImage:[UIImage imageNamed:@"default_head"] forState:UIControlStateNormal];
        [cell.contentView addSubview:imgBtn];
        
        
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(imgBtn.frame.size.width+imgBtn.frame.origin.x+EdgeDis, 0, 100, 44)];
        nameLabel.tag=indexPath.row+10001;
        [cell.contentView addSubview:nameLabel];
        
        
        MEnterpriseUser *model = [self.enterpriseUsers objectAtIndex:indexPath.row];
        model.normal = YES;
        nameLabel.text=[NSString stringWithFormat:@"%@",model.uname];
        [imgBtn sd_setImageWithURL:[NSURL URLWithString:model.bigpicurl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_head"]];
        imgBtn.clipsToBounds =YES;
        imgBtn.layer.cornerRadius =20;
        NSDictionary *dict = _allSelectDepts[model.cid];
        
        if ([dict[@"deptSelected"] boolValue]) {
            
            [selectBtn setImage:[UIImage imageNamed:@"select_d"] forState:UIControlStateNormal];
            
        }else{
            
            [selectBtn setImage:[UIImage imageNamed:@"select_no_d"] forState:UIControlStateNormal];
        }
        return cell;
    }
    return nil;
}
//分割线对齐
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
#pragma mark-----selectBtnClick
-(void)selectBtnClick:(UIButton*)btn
{
    
    if (_canMultiselect) {
        
        MEnterpriseDept *sDept;
        NSMutableDictionary *dict;
        MEnterpriseUser *mUser;
        if (btn.tag!=1111) {
            sDept = self.enterpriseContacts[btn.tag];
            
            selected = [self deptIsSlected:sDept.cid];
            
            dict = [NSMutableDictionary dictionary];
            [dict setValue:sDept.cname forKey:@"cname"];
            [dict setValue:sDept.cid forKey:@"cid"];
        }
        else
        {
            mUser=self.enterpriseUsers[0];
            selected = [self deptIsSlected:mUser.cid];
            dict = [NSMutableDictionary dictionary];
            [dict setValue:mUser.uname forKey:@"cname"];
            [dict setValue:mUser.cid forKey:@"cid"];
        }
        
        
        if (selected) {
            
            [btn setImage:[UIImage imageNamed:@"select_no_d"] forState:UIControlStateNormal];
            [dict setValue:@(NO) forKey:@"deptSelected"];
            
        }else{
            
            [btn setImage:[UIImage imageNamed:@"select_d"] forState:UIControlStateNormal];
            [dict setValue:@(YES) forKey:@"deptSelected"];
        }
        
        if (btn.tag!=1111) {
            [_allSelectDepts setValue:dict forKey:sDept.cid];
        }
        else{
            [_allSelectDepts setValue:dict forKey:mUser.cid];
        }
        
        
    }else{
        
        [btn setImage:[UIImage imageNamed:@"select_d"] forState:UIControlStateNormal];
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            if (selectBlock)
            {
                selectBlock(self.enterpriseContacts[btn.tag]);
            }
        }];
        
    }
    
    
}

- (BOOL)deptIsSlected:(NSString*)cid{
    
    BOOL isSelected;
    
    NSDictionary *dict = _allSelectDepts[cid];
    
    isSelected = [dict[@"deptSelected"] boolValue];
    
    return isSelected;
    
}

#pragma mark GQEnterpriseContactsCellDelegate 选择框点击事件

-(void)clickedAccessoryBtnInEnterpriseContactsCell:(GQEnterpriseContactsCell*)cell isSelected:(BOOL)isSelected{
    id enterprise =cell.enterprise;
    if ([enterprise isKindOfClass:[MEnterpriseDept class]]) {
        [self handleSelectedDepartment:enterprise isSelected:isSelected];
        
    }
    
    [cell updateState];
    
   
}
#pragma mark 处理选中某个部门
-(void)handleSelectedDepartment:(MEnterpriseDept*)dm isSelected:(BOOL)isSelected
{
    NSMutableSet *subDeprtIds=[[NSMutableSet alloc] init];
    [self getAllSubDepartments:dm output:&subDeprtIds];
    [subDeprtIds addObject:[NSString stringWithFormat:@"%lld",[dm.cid longLongValue]]];
}
#pragma mark 根据部门获取该部门所有子部门ID
-(void) getAllSubDepartments:(MEnterpriseDept*)departData output:(NSMutableSet**)output{
    
    NSString *subIds=[enterpriseData objectForKey:[NSString stringWithFormat:@"%@s",departData.cid]];
    if([subIds isEqualToString:@""]){
        return ;
    }else{
        NSArray *subDeptArr=[subIds componentsSeparatedByString:@","];
        for (NSString *subdeptId in subDeptArr) {
            [*output addObject:subdeptId];
            [self getAllSubDepartments:(MEnterpriseDept*)[enterpriseDeptData objectForKey:subdeptId] output:output];
        }
    }
}
#pragma mark 处理导航条
-(void)handleNavigationBarItem{
//    self.navigationItem.title = @"加入审批";
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
}
-(void)clickLeftItem:(id)sender{
//    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
NSInteger nickNameSort1(id user1, id user2, void *context)
{
    MEnterpriseUser *u1,*u2;
    //类型转换
    u1 = (MEnterpriseUser*)user1;
    u2 = (MEnterpriseUser*)user2;
    return  [u1.pinyin localizedCompare:u2.pinyin];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setCanMultiselect:(BOOL)canMultiselect{
    
    
    _canMultiselect = canMultiselect;
    
    if (canMultiselect) {
        
        ILBarButtonItem *rightItem =[ILBarButtonItem barItemWithTitle:LOCALIZATION(@"Finished") themeColor:MainColor target:self action:@selector(clickConfirmItem)];
        self.navigationItem.rightBarButtonItem=rightItem;
        
    }

    
}


- (void)clickConfirmItem{
    
    if (_canMultiselect) {
        
        self.allSelectBlock(_allSelectDepts);
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
