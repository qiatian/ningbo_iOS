//
//  LKStoreViewController.m
//  IM
//
//  Created by  pipapai_tengjun on 15/7/6.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "NewsLeaderViewController.h"
#import "NewsLeaderTableViewCell.h"
#import "OutLinkViewController.h"

@interface NewsLeaderViewController ()<UITableViewDelegate,UITableViewDataSource,NewsLeaderTableViewCellDelegate>
{
    UIScrollView *topScrollView;
    UITableView *modeTableView;
    NSMutableArray *imageArray;
    
    NSArray *titleArray;
    NSArray *iconArray;
    NSArray *urlArray;
}
@end

@implementation NewsLeaderViewController
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
    self.view.backgroundColor = [UIColor hexChangeFloat:@"f3f3f3"];
    self.navigationItem.title = @"咨询导航";
    
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];

    titleArray = @[@[@"36氪",@"虎嗅网",@"钛媒体"],@[@"财经网",@"东方财富网",@"金融界"],@[@"腾讯新闻",@"网易新闻",@"凤凰资讯"]];
    iconArray = @[@[@"LKStore_36Kr.png",@"LKStore_huxiu.png",@"LKStore_tai.png"],@[@"LKStore_business.png",@"LKStore_east.png",@"LKStore_jin.png"],@[@"LKStore_tengxun.png",@"LKStore_wang.png",@"LKStore_fenghuang.png"]];
    urlArray = @[@[@"http://36kr.com",@"http://www.huxiu.com",@"http://www.tmtpost.com"],@[@"http://www.caijing.com.cn",@"http://www.eastmoney.com",@"http://www.m.jrj.com.cn"],@[@"http://news.qq.com",@"http://news.163.com",@"http://news.ifeng.com"]];
    [self configureLKViewController];
}

- (void)configureLKViewController{
    imageArray = [NSMutableArray arrayWithObjects:@"LKStore_Banner1.png",@"LKStore_Banner2.png",@"LKStore_Banner3.png", nil];
    topScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 161)];
    topScrollView.backgroundColor = [UIColor clearColor];
    topScrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, topScrollView.frame.size.height);
    topScrollView.showsHorizontalScrollIndicator = NO;
    topScrollView.showsVerticalScrollIndicator = NO;
    topScrollView.pagingEnabled = YES;
    
    for (int i = 0; i<[imageArray count]; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*i, 0, self.view.frame.size.width, topScrollView.frame.size.height)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = [UIImage imageNamed:imageArray[i]];
        [topScrollView addSubview:imageView];
    }
    
    modeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, viewWithNavNoTabbar)];
    modeTableView.backgroundColor = [UIColor clearColor];
    modeTableView.delegate = self;
    modeTableView.dataSource = self;
    modeTableView.showsVerticalScrollIndicator = NO;
    modeTableView.showsHorizontalScrollIndicator = NO;
    modeTableView.tableHeaderView = topScrollView;
    [modeTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:modeTableView];
}

- (void)clickLeftItem:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray * arr = [NSArray arrayWithObjects:@"科技",@"财经",@"新闻", nil];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    view.backgroundColor = [UIColor clearColor];
    UIImageView * line1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
    line1.backgroundColor = [UIColor hexChangeFloat:@"dbdddd"];
    [view addSubview:line1];
    UIImageView * line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 19.5, self.view.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor hexChangeFloat:@"dbdddd"];
    [view addSubview:line];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, view.frame.size.width-20, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor hexChangeFloat:@"8A8C8C"];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:15];
    label.text = arr[section];
    [view addSubview:label];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return boundsWidth/3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DiscoverTableViewCell";
    NewsLeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[NewsLeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate =self;
    }
    [cell loadDataWithTitleName:titleArray[indexPath.section] ImageName:iconArray[indexPath.section] IndexPath:indexPath];
    return cell;
}

- (void)didButtonClicked:(NSIndexPath *)path{
    OutLinkViewController * detailView = [[OutLinkViewController alloc]init];
    detailView.titleString = titleArray[path.section][path.row];
    detailView.urlString = urlArray[path.section][path.row];
    detailView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailView animated:YES];
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
