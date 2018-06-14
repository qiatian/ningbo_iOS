//
//  MeetingMainListViewController.m
//  IM
//
//  Created by 陆浩 on 15/6/29.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "AlwaysMeetingListViewController.h"
#import "MeetintListTableViewCell.h"
#import "MeetingDetailViewController.h"

@interface AlwaysMeetingListViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    NSMutableArray *dataArray;
    UITableView *meetTableView;
    
    UISearchDisplayController *searchDisplayController;
    UISearchBar *tmpSearchBar;
    NSMutableArray *resultArray;
}

@end

@implementation AlwaysMeetingListViewController

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
    self.navigationItem.title = LOCALIZATION(@"con_use");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshListView) name:NOTIFICATION_RELOADVOIPLIST object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRSQLMessage) name:NOTIFICATION_RELOADVOIPLIST object:nil];

    dataArray = [[NSMutableArray alloc] init];
    resultArray = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor hexChangeFloat:@"ffffff"];
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    meetTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, viewWithNavNoTabbar)];
    meetTableView.backgroundColor = [UIColor clearColor];
    meetTableView.dataSource = self;
    meetTableView.delegate = self;
    meetTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:meetTableView];
    
    //在数据库中取出所有会议 放入dataArray中
    //    [dataArray setArray:[[SQLiteManager sharedInstance] getAllCommonMeeting]];
    [self configureTableViewHeaderView];
    [self loadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    ((KKNavigationController *)self.navigationController).canDragBack = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=YES;
    ((KKNavigationController *)self.navigationController).canDragBack = NO;
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
    [dataArray setArray:[[SQLiteManager sharedInstance] getAllCommonMeeting]];
    [meetTableView reloadData];
}

#pragma mark -
#pragma mark - UITableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MeetintListTableViewCell cellHeightWithModel:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == meetTableView)
    {
        return [dataArray count];
    }
    else
    {
        return [resultArray count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MeetintListTableViewCell";
    MeetintListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[MeetintListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withType:NO];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MeetingModel *model = nil;
    if(tableView == meetTableView)
    {
        model = [dataArray objectAtIndex:indexPath.row];
    }
    else
    {
        model = [resultArray objectAtIndex:indexPath.row];
    }
    [cell loadCellWithModel:model];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == meetTableView)
    {
        return YES;
    }
    return NO;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MeetingModel *model = [dataArray objectAtIndex:indexPath.row];
        [[SQLiteManager sharedInstance] deleteMeetingWithId:model.meetingId notification:NOTIFICATION_RELOADVOIPLIST];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeetingModel *model = nil;
    if(tableView == meetTableView)
    {
        model = [dataArray objectAtIndex:indexPath.row];
    }
    else
    {
        model = [resultArray objectAtIndex:indexPath.row];
    }
    MeetingDetailViewController *vc = [[MeetingDetailViewController alloc] init];
    vc.meetingId = model.meetingId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
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
        
        [dataArray setArray:[[SQLiteManager sharedInstance] getAllCommonMeeting]];
        
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
        NSMutableArray *array = [topArr sortedArrayUsingFunction:customSort2 context:nil];
        NSMutableArray *array1 = [array sortedArrayUsingFunction:customSort3 context:nil];
        
        NSMutableArray *array2 = [tmpArr sortedArrayUsingFunction:customSort3 context:nil];
        dataArray = [NSMutableArray arrayWithArray:array1];
        [dataArray addObjectsFromArray:array2];
        dispatch_async(dispatch_get_main_queue(), ^{
            [meetTableView reloadData];
        });
    });
}

NSInteger customSort2(MeetingModel *obj1, MeetingModel *obj2,void* context){
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

NSInteger customSort3(MeetingModel *obj1, MeetingModel *obj2,void* context){
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
