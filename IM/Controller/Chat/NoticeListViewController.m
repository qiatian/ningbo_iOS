//
//  NoticeListViewController.m
//  IM
//
//  Created by  pipapai_tengjun on 15/7/14.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "NoticeListViewController.h"
#import "AddNoticeViewController.h"
#import "NoticeTableViewCell.h"
#import "NoticeCellModel.h"

@interface NoticeListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * dataArray;
    UITableView * noticeTableView;
}
@end

@implementation NoticeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
    self.navigationItem.title = @"公告";
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    ILBarButtonItem *rigthItem=[ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_contact_add.png"] highlightedImage:[UIImage imageNamed:@"nav_contact_add.png"] target:self action:@selector(editNewNotice)];
    [self.navigationItem setRightBarButtonItem:rigthItem];
    
    [self getDataFromServer];
    [self configureNoticeListView];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refrshNoticeListView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"refrshNoticeListView" object:nil];
}

- (void)refreshList{
    [self getDataFromServer];
}

- (void)configureNoticeListView{
    noticeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, viewWithNavNoTabbar)];
    noticeTableView.backgroundColor = [UIColor clearColor];
    noticeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    noticeTableView.delegate = self;
    noticeTableView.dataSource =self;
    [self.view addSubview:noticeTableView];
}

- (void)getDataFromServer{
    
    NSDictionary * pDic = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithLongLong:[self.group.groupid longLongValue]],@"recvGroupId",
                           [[ConfigManager sharedInstance].userDictionary objectForKey:@"token"],@"token",
                           nil];
    [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodChatContentQuery] parameters:pDic successBlock:^(BOOL success, id data, NSString *msg) {
        if(success){
            if (data) {
                if ([data isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * dataDic = (NSDictionary *)data;
                    NSArray * array = [dataDic objectForKey:@"item"];
                    [dataArray removeAllObjects];
                    for (NSDictionary * dic  in array) {
                        NoticeCellModel * model = [[NoticeCellModel alloc]initWithDictionary:dic error:nil];
                        [dataArray addObject:model];
                    }
                    [noticeTableView reloadData];
                }
            }
            else{
                [MMProgressHUD showHUDWithTitle:@"返回数据为空" isDismissLater:YES];
            }
        }
        else{
            [MMProgressHUD showHUDWithTitle:msg isDismissLater:YES];
        }
    } failureBlock:^(NSString *description) {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"network_failed") isDismissLater:YES];
        return;
    }];
}

- (void)clickLeftItem:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editNewNotice{
    AddNoticeViewController * addNoticeView = [[AddNoticeViewController alloc]init];
    addNoticeView.hidesBottomBarWhenPushed = YES;
    addNoticeView.group = self.group;
    [self.navigationController pushViewController:addNoticeView animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 ) {
        return 0;
    }
    else{
        return [dataArray count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID=@"cellID";
    NoticeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
    }
    NoticeCellModel * model = [dataArray objectAtIndex:indexPath.row];
    [cell loadDataForCellWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
