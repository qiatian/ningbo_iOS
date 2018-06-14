//
//  NewsCenterViewController.m
//  IM
//
//  Created by liuguangren on 14-9-17.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "NewsCenterViewController.h"

@interface NewsCenterViewController ()

@end

@implementation NewsCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)clickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setImage:[UIImage imageNamed:@"wb_newsBack.png"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 35)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 50, 30);
    [btn addTarget:self action:@selector(clickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    CycleScrollView *scView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 170) pictures:[NSArray arrayWithObjects:@"wb_newsSC.png",@"wb_newsSC.png",@"wb_newsSC.png",@"wb_newsSC.png", nil]];
    scView.delegate = self;
    [scView setControlHidden:NO];
    [self.view addSubview:scView];
    
    newsTab = [[UITableView alloc] initWithFrame:CGRectMake(0, scView.frameBottom, boundsWidth, viewWithNavNoTabbar-scView.frameBottom)];
    newsTab.backgroundColor = [UIColor whiteColor];
    newsTab.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    newsTab.delegate = self;
    newsTab.dataSource = self;
    newsTab.rowHeight = 80;
    [self.view addSubview:newsTab];
    
    if ([newsTab respondsToSelector:@selector(setSeparatorInset:)]) {
        [newsTab setSeparatorInset:UIEdgeInsetsZero];
    }
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [newsTab setTableFooterView:view];
}
#pragma CycleScrollViewDelegate
- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didScrollImageView:(int)index
{
    
}

#pragma mark -TableView
#pragma TableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier=@"newsListCellIdentifier";
    
    NewsCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if(!cell)
    {
        cell = [[NewsCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    if(indexPath.row == 1)
    {
        cell.playImg.hidden = NO;
    }
    else if (indexPath.row == 2)
    {
        cell.zhuanImg.hidden = NO;
        cell.playImg.hidden = NO;
    }
    else
    {
        cell.zhuanImg.hidden = YES;
        cell.playImg.hidden = YES;
    }
    
    return  cell;
    
}

#pragma tableview delegate methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailNewsViewController *nextVC = [[DetailNewsViewController alloc] init];
    nextVC.title = @"新闻中心";
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
