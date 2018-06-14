//
//  MoreViewController.m
//  IM
//
//  Created by liuguangren on 14-9-13.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "MoreViewController.h"
#import "SQLiteManager.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//解决iOS7 tableview分割线左侧短一部分
- (void)doForIOSTableviewLine:(UITableView *)tableView
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
}

-(void)clickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BGColor;
    
    ILBarButtonItem *leftItem =[ILBarButtonItem barItemWithImage:[[UIImage imageNamed:@"back.png"] imageResizedToSize:CGSizeMake(40, 30)] highlightedImage:[[UIImage imageNamed:@"back.png"] imageResizedToSize:CGSizeMake(40, 30)] target:self action:@selector(clickLeftItem)];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    
    nameArr = [NSMutableArray arrayWithObjects:@"消息提醒",@"密码修改",@"检测更新",@"意见反馈",@"关于我们",@"拨打客服", nil];
    
    UITableView *setTab = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, boundsWidth-20, viewWithNavNoTabbar)];
    setTab.backgroundColor = [UIColor clearColor];
    setTab.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    setTab.sectionFooterHeight = 10;
    setTab.sectionHeaderHeight = 10;
    setTab.delegate = self;
    setTab.dataSource = self;
    [self.view addSubview:setTab];
    
    [self doForIOSTableviewLine:setTab];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 64)];
    footView.backgroundColor = [UIColor clearColor];
    
    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    delBtn.frame = CGRectMake(0, 20, boundsWidth, 44);
    [delBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [delBtn setBackgroundImage:[UIImage imageNamed:@"exitAndDel.png"] forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(exitAndDelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:delBtn];
    
    setTab.tableFooterView = footView;
}

- (void)exitAndDelBtnClick
{
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SQLiteManager sharedInstance] clearTableWithNames:[NSArray arrayWithObjects:@"tbl_company",@"tbl_dept",@"tbl_user",@"tbl_group", @"tbl_groupuser",nil]];
        
        NSMutableDictionary *loginDictionary =[NSMutableDictionary dictionaryWithDictionary:[ConfigManager sharedInstance].loginDictionary];
        if (loginDictionary && loginDictionary.count>0) {
            [loginDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"isAutoLogin"];
            [ConfigManager sharedInstance].loginDictionary =loginDictionary;
        }else{
            [ConfigManager sharedInstance].loginDictionary =[NSDictionary dictionary];
        }

        [[ConfigManager sharedInstance] clearALLConfig];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //[[CCPVoipManager sharedInstance] disConnectToCCP];
            [[MQTTManager sharedInstance].mqttClient stopNetworkEventLoop];
            [((AppDelegate *)[UIApplication sharedApplication].delegate) gotoLoginController];
            
        });
        
    });
    
}

#pragma mark -TableView
#pragma TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==0?2:4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier=@"moreviewCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
    }
    
    cell.textLabel.text = [nameArr objectAtIndex:indexPath.section*2+indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = [[UIColor lightGrayColor] CGColor];

    UIView *backgrdView = [[UIView alloc] initWithFrame:cell.frame];
    backgrdView.backgroundColor = [UIColor whiteColor];
    cell.backgroundView = backgrdView;
    return  cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 20)];
    view.backgroundColor = BGColor;
    return view;
}

#pragma tableview delegate methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int index = indexPath.section*2+indexPath.row;
    switch (index) {
        case 0:
        {
            SetViewController *nextVC = [[SetViewController alloc] init];
            nextVC.flag = 0;
            nextVC.title = [nameArr objectAtIndex:nextVC.flag];
            [self.navigationController pushViewController:nextVC animated:YES];
        }
            break;
        case 1:
        {
            SetViewController *nextVC = [[SetViewController alloc] init];
            nextVC.flag = 1;
            nextVC.title = [nameArr objectAtIndex:nextVC.flag];
            [self.navigationController pushViewController:nextVC animated:YES];
        }
            break;
        case 2:
        {
            alertMessage(@"当前已是最新版本，无需更新！");
        }
            break;
        case 3:
        {
            SetViewController *nextVC = [[SetViewController alloc] init];
            nextVC.flag = 3;
            nextVC.title = [nameArr objectAtIndex:nextVC.flag];
            [self.navigationController pushViewController:nextVC animated:YES];
        }
            break;
        case 4:
        {
            SetViewController *nextVC = [[SetViewController alloc] init];
            nextVC.flag = 4;
            nextVC.title = [nameArr objectAtIndex:nextVC.flag];
            [self.navigationController pushViewController:nextVC animated:YES];
        }
            break;
        case 5:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://10086"]];
        }
            break;
        default:
            break;
    }
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
