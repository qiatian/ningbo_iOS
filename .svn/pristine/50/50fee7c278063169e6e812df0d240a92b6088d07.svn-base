//
//  TaskReplyListViewController.m
//  IM
//
//  Created by ZteCloud on 15/11/17.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "TaskReplyListViewController.h"
#import "TableViewCell_reply.h"
@interface TaskReplyListViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate>
{
    UITableView *mainTable;
    NSMutableArray *dataArr;
    NSInteger currentPage;
}

@end

@implementation TaskReplyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self handleNavigationBarItem];
    dataArr =[[NSMutableArray alloc]initWithCapacity:0];
    [self setTable];
    currentPage=1;
    [self getReplyListReq];
}
-(void)setTable
{
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 1, boundsWidth, boundsHeight-NavBarHeight-1) style:UITableViewStylePlain];
    mainTable.backgroundColor=BGColor;
    mainTable.delegate=self;
    mainTable.dataSource=self;
    mainTable.showsVerticalScrollIndicator=NO;
    [self.view addSubview:mainTable];
    [mainTable registerNib:[UINib nibWithNibName:@"TableViewCell_reply" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [Common setExtraCellLineHidden:mainTable];
    TaskReplyListViewController *blockSelf=self;
    
    //下拉刷新
    [mainTable addPullToRefreshWithActionHandler:^{
        NSLog(@"0000");
        currentPage=1;
        [blockSelf getReplyListReq];
    }];
    //上拉加载
    [mainTable addInfiniteScrollingWithActionHandler:^{
        NSLog(@"1111");
        currentPage=currentPage+1;
        [blockSelf getReplyListReq];
        
    }];
    [mainTable.pullToRefreshView setTitle:@"正在刷新..." forState:SVPullToRefreshStateAll];
    
}
-(void)getReplyListReq
{
    //    [MMProgressHUD showHUDWithTitle:@"正在获取用户加入企业列表..." isDismissLater:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"]] forKey:@"token"];
        [parameters setObject:[NSString stringWithFormat:@"%d",currentPage] forKey:@"page"];
        [parameters setObject:self.taskId forKey:@"taskId"];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodTaskListReply] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
            NSLog(@"%@",msg);
            if(success && [data isKindOfClass:[NSDictionary class]]){
                NSLog(@"%@",data);
                //                [MMProgressHUD showHUDWithTitle:data[@"res"][@"resMessage"] isDismissLater:YES];
                NSMutableArray *arr=[[NSMutableArray alloc]initWithCapacity:0];
                for (NSDictionary *dic in data[@"replies"])
                {
                    ReplyModel *rm=[[ReplyModel alloc]initWithDictionary:dic];
                    [arr addObject:rm];
                }
                if (currentPage==1)
                {
                    [dataArr removeAllObjects];
                }
                [dataArr addObjectsFromArray:arr];
                [mainTable reloadData];
                [mainTable.pullToRefreshView stopAnimating];
                [mainTable.infiniteScrollingView stopAnimating];
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD showHUDWithTitle:msg isDismissLater:YES];
                });
            }
        } failureBlock:^(NSString *description) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MMProgressHUD showHUDWithTitle:@"网络请求失败" isDismissLater:YES];
            });
            
        }];
    });
}
#pragma mark--------tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell_reply *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    ReplyModel *rm=[dataArr objectAtIndex:indexPath.row];
    cell.nameLabel.text=rm.name;
    cell.contentLabel.text=rm.content;
    cell.timeLabel.text=[Common getChineseTimeFrom:(long long)rm.createTime];
    cell.ivAvatar.image=[UIImage imageNamed:@"default_head"];
    return cell;
}
#pragma mark 处理导航条
-(void)handleNavigationBarItem{
    self.navigationItem.title = @"任务回复";
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
