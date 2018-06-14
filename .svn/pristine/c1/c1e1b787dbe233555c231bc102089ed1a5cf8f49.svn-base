 //
//  NotiListViewController.m
//  IM
//
//  Created by 陆浩 on 15/5/19.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "NotiListViewController.h"
#import "NotiListTableViewCell.h"
#import "NotiDetailViewController.h"
#import "CreatNotiViewController.h"
#import "NotiModel.h"

@interface NotiListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *dataArray;
    UITableView *notiTableView;
    NSMutableDictionary *allUserDic;
    NSNumber *page;
}
@property (nonatomic, assign) BOOL  refreshing;
@property (nonatomic, assign) NSInteger  offset;      //偏移量，默认为0
@end

@implementation NotiListViewController


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=YES;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
     _offset = 1;
    _refreshing = NO;
    self.navigationItem.title = LOCALIZATION(@"Message_Notification_meeting");
    self.view.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
    dataArray = [[NSMutableArray alloc] init];
    
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    ILBarButtonItem *rightItem=[ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_contact_add.png"] selectedImage:nil target:self action:@selector(clickRightItem:)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    
    [self getNotisFromServerWithFlag:0];
    
    notiTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, viewWithNavNoTabbar)];
    notiTableView.backgroundColor = [UIColor clearColor];
    notiTableView.dataSource = self;
    notiTableView.delegate = self;
    notiTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:notiTableView];
    
    // 第66-92行为加的上拉和下拉
    NotiListViewController *blockSelf = self;
    //下拉刷新
    [notiTableView addPullToRefreshWithActionHandler:^{
        
        NSLog(@"下拉刷新");
        
       if (!blockSelf.refreshing) {
            _offset = 1;
        [blockSelf getNotisFromServerWithFlag:0];
           
        }
        
    }];
    //上拉刷新  分页显示
    [notiTableView addInfiniteScrollingWithActionHandler:^{
        NSLog(@"上拉刷新");
        
       if (!blockSelf.refreshing) {
        
            NSLog(@"上拉刷新通知列表");
           blockSelf.offset = blockSelf.offset + 5;
           
            [blockSelf getNotisFromServerWithFlag:1];
        }
        
    }];
    
    [notiTableView.pullToRefreshView setTitle:LOCALIZATION(@"drag_refresh") forState:SVPullToRefreshStateAll];
    

    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *myGId = [[ConfigManager sharedInstance].userDictionary objectForKey:@"gid"];
        allUserDic = [NSMutableDictionary dictionaryWithDictionary:[[SQLiteManager sharedInstance] getAllUserByGid:myGId]];
    });
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotisFromServer) name:@"NotiStatusChangeNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_ENTERPRISECONTACT_FINISHED_LOAD object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshViewWithNotice) name:NOTIFICATION_ENTERPRISECONTACT_FINISHED_LOAD object:nil];

    // Do any additional setup after loading the view.
}

- (void)refreshViewWithNotice{
    [self getNotisFromServer];//刷新列表数据
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickLeftItem:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickRightItem:(id)sender{
    SelectEnterpriseUserViewController *selectUserVC =[[SelectEnterpriseUserViewController alloc] init];
    selectUserVC.selectGroupUsers = YES;
    [selectUserVC setSelectBlock:^(NSArray *responseArray){
        CreatNotiViewController *vc = [[CreatNotiViewController alloc] init];
        [vc setSuccessBlock:^{
            [self getNotisFromServer];
        }];
        [vc.userArray addObjectsFromArray:responseArray];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    GQNavigationController *selectUserVCNav =[[GQNavigationController alloc] initWithRootViewController:selectUserVC];
    [self presentViewController:selectUserVCNav animated:YES completion:^{
    }];
    NSLog(@"新建通知");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -
#pragma mark - UITableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NotiListTableViewCell";
    NotiListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[NotiListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NotiListModel *model = [dataArray objectAtIndex:indexPath.row];
    NSString *hostName = @"";
    if([model.creator longLongValue] == [[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"] longLongValue])
    {
        hostName = [ConfigManager sharedInstance].userDictionary[@"name"];
    }
    else
    {
        MEnterpriseUser *mu = [allUserDic objectForKey:[NSString stringWithFormat:@"%@",model.creator]];
        hostName = mu.uname?mu.uname:@"";
    }
    [cell loadCellWithDic:model withHostName:hostName];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotiListModel *dic = [dataArray objectAtIndex:indexPath.row];
    NotiDetailViewController *vc = [[NotiDetailViewController alloc] init];
    vc.notiId = dic.id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark - Getnotis From Server

-(void)getNotisFromServer
{
    NSString *token = [[ConfigManager sharedInstance].userDictionary  objectForKey:@"token"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"5",@"limit",token,@"token", nil];
    [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodGetInform] parameters:dic successBlock:^(BOOL success, id data, NSString *msg) {
        if(data[@"item"]&&[data[@"item"] isKindOfClass:[NSArray class]])
        {
            NSArray *array = data[@"item"];
            [dataArray removeAllObjects];
            for(int i = 0 ; i < [array count]; i++)
            {
                NSDictionary *dic = [array objectAtIndex:i];
                if(dic && [dic isKindOfClass:[NSDictionary class]])
                {
                    NotiListModel *model = [[NotiListModel alloc] initWithDictionary:dic error:nil];
                    [dataArray addObject:model];
                }
            }
        }
        [notiTableView reloadData];
    } failureBlock:^(NSString *description) {
        NSLog(@"网络请求失败");
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"network_failed") isDismissLater:YES];
    }];
}



//分页拉取通知列表的请求接口（为了修改加载列表慢而写的方法）
-(void)getNotisFromServerWithFlag:(NSInteger)flag
{
    if (flag == 0) {
       page = [NSNumber numberWithInteger:0];
    }else{
      page = [NSNumber numberWithInteger:_offset];
    }
    self.refreshing = YES;
    //NSNumber *page = [NSNumber numberWithInteger:_offset];
    NSString *token = [[ConfigManager sharedInstance].userDictionary  objectForKey:@"token"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"5",@"limit",token,@"token", page,@"offset",nil];
    [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodGetInform] parameters:dic successBlock:^(BOOL success, id data, NSString *msg) {
        if(data[@"item"]&&[data[@"item"] isKindOfClass:[NSArray class]])
        {
        //第236-257行为数据请求成功后上拉下拉刷新通知列表
            if (flag == 0) {//下拉刷新
                [dataArray removeAllObjects];
                NSArray *array = data[@"item"];
                for(int i = 0 ; i < [array count]; i++)
                {
                    NSDictionary *dic = [array objectAtIndex:i];
                    if(dic && [dic isKindOfClass:[NSDictionary class]])
                    {
                        NotiListModel *model = [[NotiListModel alloc] initWithDictionary:dic error:nil];
                        [dataArray addObject:model];
                    }
                }
                
                
            }else{//上推刷新
                
                if ([data[@"item"] count] == 0) {
                    
                    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"data_loaded") isDismissLater:YES];
                    
                }else{

                    NSArray *array = data[@"item"];
                    for(int i = 0 ; i < [array count]; i++)
                    {
                        NSDictionary *dic = [array objectAtIndex:i];
                        if(dic && [dic isKindOfClass:[NSDictionary class]])
                        {
                            NotiListModel *model = [[NotiListModel alloc] initWithDictionary:dic error:nil];
                            [dataArray addObject:model];
                        }
                    }
                }
                
            }
            
        }
        [notiTableView reloadData];
        self.refreshing = NO;
        [notiTableView.pullToRefreshView stopAnimating];
        [notiTableView.infiniteScrollingView stopAnimating];
    } failureBlock:^(NSString *description) {
        NSLog(@"网络请求失败");
        [MMProgressHUD showHUDWithTitle:description isDismissLater:YES];
    }];
}

//if(data[@"item"]&&[data[@"item"] isKindOfClass:[NSArray class]])
//{
//    if([data[@"item"] count])
//    {
//        detailModel = [[NotiDetailModel alloc] initWithDictionary:data[@"item"][0] error:nil];
//        if ([detailModel.status isEqualToString:@"2"]) {
//            
//            if (!self.cancelAlert && [Common isControllerVisible:self.navigationController]) {
//                self.cancelAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该会议通知已被取消" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                self.cancelAlert.tag = 6001;
//                [self.cancelAlert show];
//            }
//            
//        } else {
//            if([detailModel.creator longLongValue] == [[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"] longLongValue])
//            {
//                isMine = YES;
//            }
//            else
//            {
//                isMine = NO;
//            }
//        }
//        
//        
//    }
//}
//if(data[@"users"]&&[data[@"users"] isKindOfClass:[NSArray class]])
//{
//    [detailModel.users_array removeAllObjects];
//    NSMutableArray *userArray = [NSMutableArray arrayWithArray:data[@"users"]];
//    for(NSDictionary * dic in userArray)
//    {
//        NotiUserModel *model = [[NotiUserModel alloc] initWithDictionary:dic error:nil];
//        [detailModel.users_array addObject:model];
//    }
//}


@end
