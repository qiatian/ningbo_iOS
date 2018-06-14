//
//  ApproveListViewController.m
//  IM
//
//  Created by ZteCloud on 15/10/21.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "ApproveListViewController.h"
#import "TableViewCell_approve.h"
#import "ApproveCell.h"
#import "ApproveDetailViewController.h"
@interface ApproveListViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate>
{
    UITableView *mainTable;
    NSMutableArray *dataArr;
    NSInteger currentPage;
}

@end

@implementation ApproveListViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataArr =[[NSMutableArray alloc]initWithCapacity:0];
    [NotiCenter addObserver:self selector:@selector(refreshTableList) name:@"ChangeApprove" object:nil];
    [self refreshTableList];
    [self handleNavigationBarItem];
    [self setTable];
}
-(void)setTable
{
    self.nibApprove =[UINib nibWithNibName:@"TableViewCell_approve" bundle:[NSBundle mainBundle]];
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight-NavBarHeight) style:UITableViewStylePlain];
    mainTable.backgroundColor=BGColor;
    mainTable.delegate=self;
    mainTable.dataSource=self;
    mainTable.showsVerticalScrollIndicator=NO;
    mainTable.rowHeight=100;
    mainTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTable];
    [mainTable registerNib:[UINib nibWithNibName:@"ApproveCell" bundle:nil] forCellReuseIdentifier:@"Cell1"];
//    [mainTable registerNib:[UINib nibWithNibName:@"TableViewCell_approve" bundle:nil] forCellReuseIdentifier:@"approveCell"];
    ApproveListViewController *blockSelf=self;
    
    //下拉刷新
    [mainTable addPullToRefreshWithActionHandler:^{
        NSLog(@"0000");
        currentPage=0;
        [blockSelf getApplicationListReq];
    }];
    //上拉加载
    [mainTable addInfiniteScrollingWithActionHandler:^{
        NSLog(@"1111");
        currentPage=currentPage+2;
        [blockSelf getApplicationListReq];
        
    }];
    [mainTable.pullToRefreshView setTitle:LOCALIZATION(@"refreshing") forState:SVPullToRefreshStateAll];
    
}
-(void)getApplicationListReq
{
    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"loading_user_enter") isDismissLater:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"]] forKey:@"token"];
        [parameters setObject:[NSString stringWithFormat:@"%d",currentPage] forKey:@"page"];
        
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodGetApplication] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
//            NSLog(@"%@",msg);
            if(success && [data isKindOfClass:[NSDictionary class]]){
//                NSLog(@"%@",data);
                [MMProgressHUD showHUDWithTitle:data[@"res"][@"resMessage"] isDismissLater:YES];
                NSMutableArray *arr=[[NSMutableArray alloc]initWithCapacity:0];
                for (NSDictionary*dic in data[@"item"])
                {
                    Consumer *cm=[[Consumer alloc]initWithDictionary:dic];
                    [arr addObject:cm];
                }
                if (currentPage==0)
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
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"network_failed") isDismissLater:YES];
            });
            
        }];
    });
}
-(void)refreshTableList
{
    currentPage=0;
    [self getApplicationListReq];
}
#pragma mark--------tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    TableViewCell_approve *cell=[tableView dequeueReusableCellWithIdentifier:@"approveCell"];
//    cell.selectionStyle=
//    NSArray *nibs;
//    @try{
//        nibs=[[NSBundle mainBundle] loadNibNamed:@"TableViewCell_approve" owner:self options:nil];
//    }
//    @catch(NSException *exception) {
//        NSLog(@"exception:%@", exception);
//    }
//    @finally {
//        
//    }
//    if ([nibs count]>0)
//    {
//        self.customCell = [nibs objectAtIndex:0];
//        cell = self.customCell;
//    }
    
    
//    TableViewCell_approve *cell = [tableView dequeueReusableCellWithIdentifier:@"approveCell"];
//    if(!cell){
//        cell=(TableViewCell_approve*)[[self.nibApprove instantiateWithOwner:self options:nil] objectAtIndex:0];
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    }
    
    
    
//    TableViewCell_approve *cell=[tableView dequeueReusableCellWithIdentifier:@"approveCell"];
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    ApproveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    Consumer *tm=[dataArr objectAtIndex:indexPath.row];
    cell.nameLabel.text=tm.name;
    cell.numLabel.text=[NSString stringWithFormat:@"%@%@%@%@",LOCALIZATION(@"approval_mobile"),tm.mobile,LOCALIZATION(@"approval_tojoin"),[[ConfigManager sharedInstance].userDictionary objectForKey:@"gname"]];
    cell.timeLabel.text=[NSString stringWithFormat:@"%@",[Common getChineseTimeFrom:[tm.createTime longLongValue]]];
    if ([tm.status isEqualToString:@"APPROVED"])
    {
        [cell.statusBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [cell.statusBtn setTitle:LOCALIZATION(@"approval_accept") forState:UIControlStateNormal];
        [cell.statusBtn setBackgroundImage:[UIImage imageNamed:@"bg_white"] forState:UIControlStateNormal];
    }
    if ([tm.status isEqualToString:@"INVALID"])
    {
        [cell.statusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.statusBtn setTitle:LOCALIZATION(@"approval_invalid") forState:UIControlStateNormal];
        [cell.statusBtn setBackgroundImage:[UIImage imageNamed:@"bg_gray"] forState:UIControlStateNormal];
    }
    if ([tm.status isEqualToString:@"REJECTED"])
    {
        [cell.statusBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cell.statusBtn setTitle:LOCALIZATION(@"approval_refuse") forState:UIControlStateNormal];
        [cell.statusBtn setBackgroundImage:[UIImage imageNamed:@"bg_white"] forState:UIControlStateNormal];
    }
    if ([tm.status isEqualToString:@"CANCELLED"])
    {
        [cell.statusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.statusBtn setTitle:LOCALIZATION(@"approval_cancel") forState:UIControlStateNormal];
        [cell.statusBtn setBackgroundImage:[UIImage imageNamed:@"bg_gray"] forState:UIControlStateNormal];
    }
    if ([tm.status isEqualToString:@"CREATED"])
    {
        [cell.statusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.statusBtn setTitle:LOCALIZATION(@"approval_to_deal") forState:UIControlStateNormal];
        [cell.statusBtn setBackgroundImage:[UIImage imageNamed:@"bg_red"] forState:UIControlStateNormal];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApproveDetailViewController *avc=[[ApproveDetailViewController alloc]init];
    avc.cm=dataArr[indexPath.row];
    [self.navigationController pushViewController:avc animated:YES];
}

#pragma mark------------searchBtnClick
-(void)searchBtnClick:(UIButton*)btn
{
}
#pragma mark--------------enrollBtnClick
-(void)enrollBtnClick:(UIButton*)btn
{
    
}
#pragma mark---------joinBtnClick
-(void)joinBtnClick:(UIButton*)btn
{
    
}
#pragma mark 处理导航条
-(void)handleNavigationBarItem{
    self.navigationItem.title = LOCALIZATION(@"approval_title");
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
