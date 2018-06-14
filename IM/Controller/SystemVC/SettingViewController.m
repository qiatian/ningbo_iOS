//
//  SettingViewController.m
//  IM
//
//  Created by 陆浩 on 15/5/3.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "SettingViewController.h"
#import "SysStyleViewController.h"
#import "SysPwdViewController.h"
#import "FeedBackViewController.h"
#import "AboutLingKeViewController.h"
#define ForceUpdateTag 100000

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *settingsArray;
    NSString *downloadUrl;
}

@end

@implementation SettingViewController
-(void)viewWillAppear:(BOOL)animated
{
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
    self.view.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
    self.navigationItem.title = @"设置";
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, viewWithNavNoTabbar)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.scrollEnabled = NO;
    [self.view addSubview:tableView];
    //屏蔽tag
    settingsArray = @[@[@"修改密码",@"意见反馈",@"检查更新"]];
    //end
    
//    settingsArray = @[@[@"消息提醒",@"字体大小",@"更换主题"],@[@"修改密码",@"意见反馈",@"关于领客"]];
    
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.frame = CGRectMake(15, boundsHeight-120, boundsWidth-30, 45);
    logoutButton.backgroundColor = [UIColor hexChangeFloat:@"f2504e"];
    [logoutButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logoutButton.layer.masksToBounds = YES;
    logoutButton.layer.cornerRadius = 5.0f;
    [self.view addSubview:logoutButton];
    [logoutButton addTarget:self action:@selector(logoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

-(void)clickLeftItem:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)logoutButtonClick:(UIButton *)sender
{
    [self exitAndDelBtnClick];
}

#pragma mark -
#pragma mark - UITableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [settingsArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [(NSArray *)[settingsArray objectAtIndex:section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 9.5;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 43;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 0.5)];
    view.backgroundColor = [UIColor hexChangeFloat:@"dedede"];
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 9.5)];
    view.backgroundColor = [UIColor clearColor];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 9, boundsWidth, 0.5)];
    line.backgroundColor = [UIColor hexChangeFloat:@"dedede"];
    [view addSubview:line];
    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"UITableViewCellLeft";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor=[UIColor hexChangeFloat:@"ffffff"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.text = [[settingsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [[settingsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if([title isEqualToString:@"更换主题"])
    {
        SysStyleViewController *vc = [[SysStyleViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if([title isEqualToString:@"修改密码"])
    {
        SysPwdViewController *vc = [[SysPwdViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if([title isEqualToString:@"意见反馈"])
    {
        FeedBackViewController *vc = [[FeedBackViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if([title isEqualToString:@"关于领客"])
    {
        AboutLingKeViewController *vc = [[AboutLingKeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if([title isEqualToString:@"检查更新"])
    {
        [self checkUpdate];
    }
}

- (void)checkUpdate
{
    [MMProgressHUD showHUDWithTitle:@"正在检查更新..." isDismissLater:NO];
    
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:@"ios" forKey:@"client_type"];
        [parameters setObject:[NSString stringWithFormat:@"%d",[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]integerValue]]  forKey:@"version"];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodSoftUpdate] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
//            NSLog(@"%@",msg);
            if(success && [data isKindOfClass:[NSDictionary class]]){
                NSString *tipMsg = @"";
                if(data[@"software"])
                {
                    NSDictionary *dic = data[@"software"];
                    BOOL forceUpdate = [dic[@"forceUpdate"] intValue] == 1?YES:NO;
                    
                    downloadUrl = dic[@"update_url"];
                    
                    //存在，则说明有新版本
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"检测到新版本" message:dic[@"updateLog"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即更新", nil];
                    [alert show];

                    if(forceUpdate)
                    {
                        alert.tag = ForceUpdateTag;
                    }
                    [MMProgressHUD dismiss];
                }
                else
                {
                    tipMsg = @"当前版本已经是最新版本,无需更新.";
                    [MMProgressHUD showHUDWithTitle:tipMsg isDismissLater:YES];
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD showHUDWithTitle:@"检查失败" isDismissLater:YES];
                });
            }
        } failureBlock:^(NSString *description) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MMProgressHUD showHUDWithTitle:@"网络请求失败" isDismissLater:YES];
            });
        }];
    });
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
        [UserDefault removeObjectForKey:@"LPsw"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[MQTTManager sharedInstance].mqttClient stopNetworkEventLoop];
            [[MQTTManager sharedInstance].mqttClient disconnect];
            [MQTTManager sharedInstance].mqttClient = nil;
            [[DeviceDelegateHelper ShareInstance] disConnectVoip];
            
            [((AppDelegate *)[UIApplication sharedApplication].delegate) gotoLoginController];
        });
    });
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.pgyer.com/OxeM"]];
    }
    else
    {
        if(alertView.tag == ForceUpdateTag)
        {
            exit(0);
        };
    }
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
