//
//  DiscoverViewController.m
//  IM
//
//  Created by 陆浩 on 15/4/14.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverTableViewCell.h"
#import "CircleViewController.h"
#import "NewsLeaderViewController.h"

@interface DiscoverViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *imageArray;
    NSArray *titleArray;
}

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor hexChangeFloat:@"f3f3f3"];

    CGFloat orgin_y = 0;
    if(CURRENT_SYS_VERSION < 7.0999999)
    {
        orgin_y = 64;
    }

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, orgin_y, self.view.frame.size.height, viewWithNavAndTabbar)];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    
    imageArray = [NSArray arrayWithObjects:@"discover_workCircle.png",@"discover_store.png",@"discover_scane.png",@"discover_leader.png",@"discover_appStrore.png", nil];
    titleArray = [NSArray arrayWithObjects:@"工作圈",@"领客商城",@"扫一扫名片",@"资讯导航",@"应用超市", nil];
    // Do any additional setup after loading the view.
    
    NSLog(@"sharedInstance===%@",[ConfigManager sharedInstance].userDictionary);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.drawerController removGestureRecognizers];
    appDelegate.centerButton.hidden=NO;
    [appDelegate tabbarController].navigationItem.title = self.tabBarItem.title;
    [[appDelegate tabbarController].navigationItem setRightBarButtonItem:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.drawerController removGestureRecognizers];
//    appDelegate.centerButton.hidden=YES;
    [[appDelegate tabbarController].navigationItem setLeftBarButtonItem:nil];
    
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    view.backgroundColor = [UIColor clearColor];
    UIImageView * line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 19.5, self.view.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor hexChangeFloat:@"dbdddd"];
    [view addSubview:line];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    else if (section ==1){
        return 2;
    }
    else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DiscoverTableViewCell";
    DiscoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[DiscoverTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        cell.titleLabel.text = [titleArray objectAtIndex:indexPath.row];
        cell.logoImageView.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
        if (indexPath.row == 1) {
            cell.lineImageView.frame = CGRectMake(0, 49.5, self.view.frame.size.width, 0.5);
        }
    }
    else if (indexPath.section == 1){
        cell.titleLabel.text = [titleArray objectAtIndex:indexPath.row+2];
        cell.logoImageView.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row+2]];
        if (indexPath.row == 1) {
            cell.lineImageView.frame = CGRectMake(0, 49.5, self.view.frame.size.width, 0.5);
        }
    }
    else{
        cell.titleLabel.text = [titleArray objectAtIndex:indexPath.row+4];
        cell.logoImageView.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row+4]];
        cell.lineImageView.frame = CGRectMake(0, 49.5, self.view.frame.size.width, 0.5);
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                //工作圈
//                CircleViewController *vc = [[CircleViewController alloc] init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:vc animated:YES];
                UnworkedViewController * unworkView = [[UnworkedViewController alloc]init];
                unworkView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:unworkView animated:YES];
            }
                break;
              case 1:
            {
                //领客商城
                UnworkedViewController * unworkView = [[UnworkedViewController alloc]init];
                unworkView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:unworkView animated:YES];

            }
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
                //扫一扫名片
                UnworkedViewController * unworkView = [[UnworkedViewController alloc]init];
                unworkView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:unworkView animated:YES];
            }
                break;
            case 1:
            {
                //资讯导航
                NewsLeaderViewController * nlView = [[NewsLeaderViewController alloc]init];
                nlView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:nlView animated:YES];
            }
                break;
            default:
                break;
        }
    }
    else{
        //应用超市
        UnworkedViewController * unworkView = [[UnworkedViewController alloc]init];
        unworkView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:unworkView animated:YES];
    }
}




@end
