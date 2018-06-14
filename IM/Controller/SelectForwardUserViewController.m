//
//  SelectForwardUserViewController.m
//  IM
//
//  Created by zuo guoqing on 15-1-5.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "SelectForwardUserViewController.h"

@interface SelectForwardUserViewController ()

@end

@implementation SelectForwardUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self loadData];
}

-(void)setupViews{
    
    ILBarButtonItem *leftItem =[ILBarButtonItem barItemWithTitle:@"取消" themeColor:[UIColor whiteColor] target:self action:@selector(clickCancelItem:)];
    self.navigationItem.leftBarButtonItem=leftItem;
    [self.navigationItem setRightBarButtonItem:nil];
    
    
    PBFlatSegmentedControl *navSegmentedControl =[[PBFlatSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"企业",@"群组",nil] itemSize:CGSizeMake(80, 30) cornerRadius:15];
    [navSegmentedControl setFrame:CGRectMake(0, 5.0, 160.0f, 30.0f)];
    navSegmentedControl.selectedSegmentIndex=0;
    [navSegmentedControl addTarget:self action:@selector(navSegmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView =navSegmentedControl;
    
    
    self.nibEnterpriseContacts =[UINib nibWithNibName:@"GQEnterpriseContactsCell" bundle:[NSBundle mainBundle]];
    self.nibSelectForwardGroup =[UINib nibWithNibName:@"GQSelectForwardGroupCell" bundle:[NSBundle mainBundle]];
    self.tbView.tableFooterView =[[UIView alloc] init];
    
    UISearchBar *searchBar =self.searchDisplayController.searchBar;
    UIView *headerView =[[UIView alloc] initWithFrame:searchBar.bounds];
    [headerView addSubview:searchBar];
    self.tbView.tableHeaderView =headerView;
    
    
}

-(void)clickCancelItem:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


-(void)navSegmentedControlValueChanged:(PBFlatSegmentedControl*)sender{
    NSInteger index = sender.selectedSegmentIndex;
    if (index==0) {
        self.isGroup=NO;
        [self loadEnterpriseContactsRootData];;
    }else{
        self.isGroup =YES;
        [self.tbView reloadData];
    }
}


#pragma mark 加载企业通讯录数据
-(void)loadContactsData{
    self.enterpriseData =[[NSMutableDictionary alloc] init];
    self.enterpriseDeptData =[[NSMutableDictionary alloc] init];
    self.enterpriseUserData =[[NSMutableDictionary alloc] init];
    self.stepBarData =[[NSMutableArray alloc] init];
    WEAKSELF
    
    [weakSelf loadDataWithCompletionBlock:^{
        [weakSelf loadEnterpriseContactsRootData];
        
    }];
}

#pragma mark 加载企业通讯录根目录
-(void)loadEnterpriseContactsRootData{
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MEnterpriseDept *dept =[[MEnterpriseDept alloc] init];
        dept.cid =@"0";
        dept.cname =[[ConfigManager sharedInstance].userDictionary objectForKey:@"gname"];
        weakSelf.enterpriseCurrentDept =dept;
        weakSelf.enterpriseContacts =[weakSelf getEnterpriseTableDataByCId:dept.cid];
        
        
        MEnterpriseDept *stepDept =[[MEnterpriseDept alloc] init];
        stepDept.cid =@"0";
        stepDept.cname =[[ConfigManager sharedInstance].userDictionary objectForKey:@"gname"];
        
        weakSelf.stepBarData =[NSMutableArray arrayWithObject:stepDept];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tbView reloadData];
            
        });
    });
    
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
            user.normal =YES;
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
            dept.selectedNumber =[NSNumber numberWithInt:-1];
            [sortArr addObject:dept];
        }
        [tableData addObjectsFromArray:sortArr];
    }
    
    return tableData;
}


#pragma mark 加载企业通讯录数据
-(void) loadDataWithCompletionBlock:(void (^)(void))completionBlock{
    
    if ([self.enterpriseDeptData count]>0&& [self.enterpriseUserData count]>0) {
        return;
    }
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *myGId=[[ConfigManager sharedInstance].userDictionary objectForKey:@"gid"];
        NSArray *departArr=[[SQLiteManager sharedInstance] getAllDeptByGId:myGId];
        NSArray *userArr =[[[SQLiteManager sharedInstance] getAllUserByGid:myGId] allValues];
        
        for (MEnterpriseDept *md in departArr) {
            
            [weakSelf.enterpriseDeptData setObject:md forKey:[NSString stringWithFormat:@"%lld",[md.cid longLongValue]]];
            
            NSString *pkey=[NSString stringWithFormat:@"%@p",md.cid];
            NSString *skey=[NSString stringWithFormat:@"%@s",md.cid];
            NSString *pskey=[NSString stringWithFormat:@"%@s",md.pid];
            NSString *ppkey=[NSString stringWithFormat:@"%@p",md.pid];
            
            
            //当前部门的子部门
            if (![weakSelf.enterpriseData objectForKey:skey]) {
                [weakSelf.enterpriseData setObject:@"" forKey:skey];
            }
            
            if (![weakSelf.enterpriseData objectForKey:pkey]) {
                [weakSelf.enterpriseData setObject:@"" forKey:pkey];
            }
            
            //添加当前部门上一级部门的子部门
            NSString *psValue=[weakSelf.enterpriseData objectForKey:pskey];
            if(psValue && psValue.length>0){
                [weakSelf.enterpriseData setObject:[NSString stringWithFormat:@"%@,%@",psValue,md.cid] forKey:pskey];
            }else{
                [weakSelf.enterpriseData setObject:[NSString stringWithFormat:@"%lld",[md.cid longLongValue]]forKey:pskey];
            }
            
            
            //添加当前部门的父部门
            if([md.pid longLongValue]==0){
                [weakSelf.enterpriseData setObject:@"" forKey:pkey];
            }else{
                NSString *ppValue =[weakSelf.enterpriseData objectForKey:ppkey];
                if(ppValue && ppValue.length>0){
                    [weakSelf.enterpriseData setObject:[NSString stringWithFormat:@"%@,%@", ppValue,md.pid] forKey:pkey];
                    
                }else{
                    [weakSelf.enterpriseData setObject:[NSString stringWithFormat:@"%lld",[md.pid longLongValue]] forKey:pkey];
                }
            }
        }
        for (MEnterpriseUser *mu in userArr) {
            mu.gname =[[ConfigManager sharedInstance].userDictionary objectForKey:@"gname"];
            [weakSelf.enterpriseUserData setObject:mu forKey:mu.uid];
            NSString *key=[NSString stringWithFormat:@"%@u",mu.cid];
            
            if(![weakSelf.enterpriseData objectForKey:key]){
                [weakSelf.enterpriseData setObject:mu.uid forKey:key];
            }else{
                NSString *value=[NSString stringWithFormat:@"%@,%@",[weakSelf.enterpriseData objectForKey:key],mu.uid];
                [weakSelf.enterpriseData setObject:value forKey:key];
            }
            
        }
        
        weakSelf.groupContacts =[NSMutableArray arrayWithArray:[[[SQLiteManager sharedInstance] getAllGroups] allValues]];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock){
                completionBlock();
            }
        });
        
    });
    
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
            [weakSelf.tbView setContentOffset:CGPointMake(0, 0) animated:NO];
            [weakSelf.tbView reloadData];
        });
    });
}


-(void)loadData{
    [self loadContactsData];
}



#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (!self.isGroup) {
        return 40;
    }else{
        return 0;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (!self.isGroup && self.stepBarData && [self.stepBarData count]>0 ) {
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isGroup) {
        MGroup *group =[self.groupContacts objectAtIndex:indexPath.row];
        CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"确定发送给："  message:group.groupName cancelButtonTitle:nil];
        alertView.showBlurBackground = NO;
        [alertView addButtonWithTitle:@"取消"
                                 type:CXAlertViewButtonTypeDefault
                              handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                  [alertView dismiss];
                              }];
        [alertView addButtonWithTitle:@"确定"
                                 type:CXAlertViewButtonTypeCancel
                              handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                  [alertView dismiss];
                                  if (self.delegate && [self.delegate respondsToSelector:@selector(clickedSendBtnInSelectForwardUserViewControllerWithUser:)]) {
                                      [self.delegate clickedSendBtnInSelectForwardUserViewControllerWithUser:group];
                                  }
                                  
                                  [self dismissViewControllerAnimated:YES completion:^{}];
                                  
                              }];
        
        [alertView show];
    }else{
        
        if (indexPath.row<[self.enterpriseContacts count]) {
            id enterprise= [self.enterpriseContacts objectAtIndex:indexPath.row];
            if ([enterprise isKindOfClass:[MEnterpriseUser class ]]) {
                CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"确定发送给："  message:((MEnterpriseUser*)enterprise).uname cancelButtonTitle:nil];
                alertView.showBlurBackground = NO;
                [alertView addButtonWithTitle:@"取消"
                                         type:CXAlertViewButtonTypeDefault
                                      handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                          [alertView dismiss];
                                      }];
                [alertView addButtonWithTitle:@"确定"
                                         type:CXAlertViewButtonTypeCancel
                                      handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                          [alertView dismiss];
                                          
                                          if (self.delegate && [self.delegate respondsToSelector:@selector(clickedSendBtnInSelectForwardUserViewControllerWithUser:)]) {
                                              [self.delegate clickedSendBtnInSelectForwardUserViewControllerWithUser:enterprise];
                                          }
                                          
                                          [self dismissViewControllerAnimated:YES completion:^{}];
                                          
                                      }];
                
                [alertView show];
                
                
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
                    });
                });
            }
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
    
    if (self.isGroup) {
        return [self.groupContacts count];
    }else{
        return [self.enterpriseContacts count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isGroup) {
        GQSelectForwardGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GQSelectForwardGroupCell"];
        
        if(!cell){
            cell=(GQSelectForwardGroupCell*)[[self.nibSelectForwardGroup instantiateWithOwner:self options:nil] objectAtIndex:0];
        }
        
        cell.group =[self.groupContacts objectAtIndex:indexPath.row];
        return cell;
    }else{
        GQEnterpriseContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GQEnterpriseContactsCell"];
        
        if(!cell){
            cell=(GQEnterpriseContactsCell*)[[self.nibEnterpriseContacts instantiateWithOwner:self options:nil] objectAtIndex:0];
        }
        
        cell.enterprise =[self.enterpriseContacts objectAtIndex:indexPath.row];
        return cell;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
