//
//  AboutLingKeViewController.m
//  IM
//
//  Created by 陆浩 on 15/5/6.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "AboutLingKeViewController.h"

@interface AboutLingKeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *aboutTableView;
    NSArray *titleArray;
}

@end

@implementation AboutLingKeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
    self.navigationItem.title = @"设置";
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    aboutTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, viewWithNavNoTabbar)];
    aboutTableView.delegate = self;
    aboutTableView.dataSource = self;
    aboutTableView.backgroundColor = [UIColor clearColor];
    aboutTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:aboutTableView];
    [self configureHeaderView];
    titleArray = @[@"欢迎页",@"功能介绍",@"系统通知",@"帮助"];
    // Do any additional setup after loading the view.
}

-(void)configureHeaderView
{
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 120)];
    view.backgroundColor = [UIColor hexChangeFloat:@"1e344b"];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((boundsWidth-60)/2, 20, 60, 60)];
    logoImageView.image = [UIImage imageNamed:@"lingke_icon.png"];
    [view addSubview:logoImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 120-40, boundsWidth, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"领客企信 Linker IM 1.0";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];

    aboutTableView.tableHeaderView = view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickLeftItem:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [titleArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 43;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"AboutUITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor=[UIColor hexChangeFloat:@"ffffff"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [titleArray objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
