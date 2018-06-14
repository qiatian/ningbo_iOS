//
//  MeetingMainListViewController.m
//  IM
//
//  Created by 陆浩 on 15/6/29.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "MeetingMainListViewController.h"
#import "MeetintListTableViewCell.h"
#import "AlwaysMeetingListViewController.h"
#import "MeetingDetailViewController.h"
#import "SelectCommonUserViewController.h"

@interface MeetingMainListViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    NSMutableArray *dataArray;
    UITableView *meetTableView;
    UIView *headerView1;
    UIView *headerView2;
    UISearchDisplayController *searchDisplayController;
    UISearchBar *tmpSearchBar;
    
    NSMutableArray *resultArray;
    
    UIView *tipBgCreatView;
}

@end

@implementation MeetingMainListViewController

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRSQLMessage) name:NOTIFICATION_RELOADVOIPLIST object:nil];
        
    }
    return self;
}

-(void)notificationRSQLMessage{
    [self loadData];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LOCALIZATION(@"conferenceCall");

    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshListView) name:NOTIFICATION_RELOADVOIPLIST object:nil];
    
    dataArray = [[NSMutableArray alloc] init];
    resultArray = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor hexChangeFloat:@"ffffff"];
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    ILBarButtonItem *rightItem=[ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"meet_creat"] selectedImage:nil target:self action:@selector(clickRightItem:)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    [dataArray setArray:[[SQLiteManager sharedInstance] getAllHistoryMeeting]];

    meetTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, viewWithNavNoTabbar)];
    meetTableView.backgroundColor = [UIColor clearColor];
    meetTableView.dataSource = self;
    meetTableView.delegate = self;
    meetTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:meetTableView];
    [self configureTableViewHeaderView];
    [self loadData];
    
    NSArray *array = [[SQLiteManager sharedInstance] getAllHistoryMeeting];
    NSArray *carray = [[SQLiteManager sharedInstance] getAllCommonMeeting];
    
    BOOL hasTip = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasTip"] boolValue];//只提示一次
    if(array.count == 0 && carray.count == 0 && !hasTip)
    {
        //常用会议以及历史会议都没有的时候需要提示他创建会议
        [self configureTipCreatMeetingView];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"hasTip"];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=NO;
    ((KKNavigationController *)self.navigationController).canDragBack = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=YES;
    ((KKNavigationController *)self.navigationController).canDragBack = NO;
    [meetTableView reloadData];
}

-(void)configureTipCreatMeetingView
{
    tipBgCreatView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight)];
    tipBgCreatView.backgroundColor = [UIColor hexChangeFloat:@"000000" alpha:0.5];
    [self.view addSubview:tipBgCreatView];
    
    CGFloat orgin_y = 0;
    if(CURRENT_SYS_VERSION < 7.0999999)
    {
        orgin_y = 64;
    }
    UIImageView *tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(boundsWidth-290, orgin_y+10, 255, 220)];
    tipImageView.image = [UIImage imageNamed:@"meet_guide"];
    [tipBgCreatView addSubview:tipImageView];
}

-(void)configureTableViewHeaderView
{
    tmpSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 44)];
    tmpSearchBar.placeholder = LOCALIZATION(@"con_search");
    // 添加 searchbar 到 headerview
    meetTableView.tableHeaderView = tmpSearchBar;
    UIImage *img = [UIImage createImageWithColor:[UIColor hexChangeFloat:@"f2f2f2"] size:CGSizeMake(boundsWidth, 30)];
    [tmpSearchBar setBackgroundImage:img];
    
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:tmpSearchBar contentsController:self];
    searchDisplayController.delegate = self;
    // searchResultsDataSource 就是 UITableViewDataSource
    searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    headerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 30)];
    headerView2.backgroundColor = [UIColor hexChangeFloat:@"f2f2f2"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor hexChangeFloat:@"929292"];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.text = LOCALIZATION(@"con_record");
    [headerView2 addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickLeftItem:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)refreshListView
{
    [dataArray setArray:[[SQLiteManager sharedInstance] getAllHistoryMeeting]];
    [meetTableView reloadData];
}

-(void)clickRightItem:(id)sender{
    if(tipBgCreatView)
    {
        [tipBgCreatView removeFromSuperview];
    }
    SelectCommonUserViewController *selectUserVC =[[SelectCommonUserViewController alloc] init];
    [selectUserVC setSelectBlock:^(NSArray *responseArray){
        if(responseArray.count == 0)
        {
            [self.view makeToast:LOCALIZATION(@"Message_noChoseMettinger")];
            return ;
        }
        
        MeetingModel *model = [[MeetingModel alloc] init];
        model.meetingTitle = @"";
        model.commonMeeting = @"0";
        model.showInRecordMeeting = @"1";
        model.meetingId = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
        model.meetingPwd = @"";
        model.meetingLastConnectTime = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
        [model.meetingUserArray addObjectsFromArray:responseArray];
        //插入创建会议者
        [self insertCreateUser:model];
        
//        [[SQLiteManager sharedInstance] insertMeetingWithArray:@[model] notification:NOTIFICATION_RELOADVOIPLIST];
        [[SQLiteManager sharedInstance] insertHistoryMeetingWithArray:@[model] notification:NOTIFICATION_RELOADVOIPLIST];
        
        MeetingDetailViewController *vc = [[MeetingDetailViewController alloc] init];
        vc.meetingId = model.meetingId;
        vc.firstCreatMeeting = YES;
        [self.navigationController pushViewController:vc animated:YES];
//        [meetTableView reloadData];
//  有数据库通知了，这里可以不用手动调用刷新
    }];
    GQNavigationController *selectUserVCNav =[[GQNavigationController alloc] initWithRootViewController:selectUserVC];
    [self presentViewController:selectUserVCNav animated:YES completion:^{
    }];
}

- (void)insertCreateUser:(MeetingModel*)modal{
    
    MeetingUserModel *createUser = [[MeetingUserModel alloc] init];
    createUser.userId = [NSString stringWithFormat:@"%@",[ConfigManager sharedInstance].userDictionary[@"uid"]];
    createUser.userName = [ConfigManager sharedInstance].userDictionary[@"name"];;
    createUser.userAvatar = [ConfigManager sharedInstance].userDictionary[@"bigpicurl"];;
    createUser.telephone = [ConfigManager sharedInstance].userDictionary[@"mob"];
    [modal.meetingUserArray insertObject:createUser atIndex:0];
    
}

#pragma mark -
#pragma mark - UITableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == meetTableView)
    {
        if(indexPath.section == 0)
        {
            return 60;
        }
        else
        {
            return [MeetintListTableViewCell cellHeightWithModel:nil];
        }
    }
    return [MeetintListTableViewCell cellHeightWithModel:nil];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == meetTableView)
    {
        if(section == 0)
        {
            return 1;
        }
        else
        {
            return [dataArray count];
        }
    }
    else
    {
        return [resultArray count];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == meetTableView)
    {
        return 2;
    }
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == meetTableView)
    {
        if(section == 0)
        {
            return 0;
        }
        else
        {
            return 30;
        }
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == meetTableView)
    {
        if(section == 0)
        {
            return [[UIView alloc] initWithFrame:CGRectZero];
        }
        else
        {
            return headerView2;
        }
    }
    return [[UIView alloc] initWithFrame:CGRectZero];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == meetTableView)
    {
        if(indexPath.section == 0)
        {
            static NSString *CellIdentifier = @"CommonMeetintListTableViewCell";
            CommonMeetintListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[CommonMeetintListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.backgroundColor=[UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
        }
        else
        {
            static NSString *CellIdentifier = @"MeetintListTableViewCell";
            MeetintListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[MeetintListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withType:YES];
                cell.backgroundColor=[UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            MeetingModel *model = [dataArray objectAtIndex:indexPath.row];
            [cell loadCellWithModel:model];
            return cell;
        }
    }
    else
    {
        static NSString *CellIdentifier = @"MeetintListTableViewCell";
        MeetintListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[MeetintListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withType:YES];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        MeetingModel *model = [resultArray objectAtIndex:indexPath.row];
        [cell loadCellWithModel:model];
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == meetTableView) {
        if(indexPath.section != 0)
        {
            return YES;
        }
    }
    return NO;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return LOCALIZATION(@"Message_table_del");
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MeetingModel *model = [dataArray objectAtIndex:indexPath.row];
//        if([model.commonMeeting intValue] == 1)
//        {
//            //如果是常用会议，则这条数据是不能删除的，只能将记录状态改为0，但是如果这个会议开了，则再次将记录状态改为1
//            model.showInRecordMeeting = @"0";
//            [[SQLiteManager sharedInstance] insertMeetingWithArray:[NSArray arrayWithObject:model] notification:NOTIFICATION_RELOADVOIPLIST];
//        }
//        else
//        {
//            [[SQLiteManager sharedInstance] deleteMeetingWithId:model.meetingId notification:NOTIFICATION_RELOADVOIPLIST];
//        }
        [[SQLiteManager sharedInstance] deleteHistoryMeetingWithId:model.meetingId notification:NOTIFICATION_RELOADVOIPLIST];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == meetTableView)
    {
        if(indexPath.section == 0)
        {
            AlwaysMeetingListViewController *vc = [[AlwaysMeetingListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            MeetingModel *model = [dataArray objectAtIndex:indexPath.row];
            MeetingDetailViewController *vc = [[MeetingDetailViewController alloc] init];
            vc.fromHistory = YES;
            vc.meetingId = model.meetingId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else
    {
        MeetingModel *model = [resultArray objectAtIndex:indexPath.row];
        MeetingDetailViewController *vc = [[MeetingDetailViewController alloc] init];
        vc.meetingId = model.meetingId;
        vc.fromHistory = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UISearchDisplayController delegate
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString];
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText{
    if(dataArray.count == 0)
    {
        return;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"meetingTitle contains[cd] %@", searchText];
    [resultArray setArray:[dataArray filteredArrayUsingPredicate:predicate]];
}


/**
 *  加载数据
 */
-(void)loadData{
    
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [dataArray setArray:[[SQLiteManager sharedInstance] getAllHistoryMeeting]];
        
        NSMutableArray *topArr = [[NSMutableArray alloc] init];
        NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
        for (MeetingModel *meet in dataArray) {
            
            NSString *meettingID = meet.meetingId;
            
            NSDictionary *mainDic = [[NSUserDefaults standardUserDefaults] objectForKey:SettingMettingTopKey];
            NSDictionary *dict = [mainDic objectForKey:meettingID];
            
            meet.top1 = [dict[meettingID] intValue];
            meet.topTime1 = dict[SettingTopTime];
            
            
            if (meet.top1) {
                
                [topArr addObject:meet];
            }else{
                [tmpArr addObject:meet];
            }
            
        }
        
        //排序前
        NSMutableArray *array = [topArr sortedArrayUsingFunction:customSort4 context:nil];
        NSMutableArray *array1 = [array sortedArrayUsingFunction:customSort5 context:nil];
        
        NSMutableArray *array2 = [tmpArr sortedArrayUsingFunction:customSort5 context:nil];
        dataArray = [NSMutableArray arrayWithArray:array1];
        [dataArray addObjectsFromArray:array2];
        dispatch_async(dispatch_get_main_queue(), ^{
            [meetTableView reloadData];
        });
    });
}

NSInteger customSort4(MeetingModel *obj1, MeetingModel *obj2,void* context){
    if ((int)obj1.top1   < (int)obj2.top1) {
        return (NSComparisonResult)NSOrderedDescending;
    }
    
    else if ((int)obj1.top1   > (int)obj2.top1) {
        return (NSComparisonResult)NSOrderedAscending;
    }
    else
    {
        if ([(NSString *)obj1.sendTime doubleValue] < [(NSString *)obj2.sendTime doubleValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        else if ([(NSString *)obj1.sendTime doubleValue] > [(NSString *)obj2.sendTime doubleValue])
        {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }
}

NSInteger customSort5(MeetingModel *obj1, MeetingModel *obj2,void* context){
    if (obj1.top1 &&(int)obj2.top1) {
        if ([(NSString *)obj1.topTime1 doubleValue] < [(NSString *)obj2.topTime1 doubleValue])
        {
            //多个置顶时，随着接收新消息而变化位置（做个判断）
            if ([(NSString *)obj1.sendTime doubleValue] < [(NSString *)obj2.sendTime doubleValue]){
                
                return (NSComparisonResult)NSOrderedDescending;
                
            }  else if ([(NSString *)obj1.sendTime doubleValue] > [(NSString *)obj2.sendTime doubleValue]){
                
                return (NSComparisonResult)NSOrderedAscending;
                
            }
            
            return (NSComparisonResult)NSOrderedDescending;
        }
    }
    
    return (NSComparisonResult)NSOrderedSame;
}

NSInteger timeSort1(MeetingModel *obj1, MeetingModel *obj2,void* context){
    if ([(NSString *)obj1.sendTime doubleValue] < [(NSString *)obj2.sendTime doubleValue]) {
        return (NSComparisonResult)NSOrderedDescending;
    }
    else if ([(NSString *)obj1.sendTime doubleValue] > [(NSString *)obj2.sendTime doubleValue])
    {
        return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame;
}


@end
