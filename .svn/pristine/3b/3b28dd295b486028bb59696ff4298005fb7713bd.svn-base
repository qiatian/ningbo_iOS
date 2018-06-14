//
//  ChatDetailViewController.m
//  IM
//
//  Created by syj on 15/4/25.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "ChatDetailViewController.h"
#import "ChatMoreViewController.h"

@interface ChatDetailViewController ()

@end

@implementation ChatDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteChatInfo) name:DELETECHATINFO object:nil];
}

-(void)deleteChatInfo
{
    NSLog(@"聊天清空成功");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_clean_success") isDismissLater:YES];
    });
    [_delegate deleteChatSuccess];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_R_SQL_MESSAGE object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)loadData{
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MGroupDetailCell *cell_1_0=[[MGroupDetailCell alloc] init];
        cell_1_0.text =LOCALIZATION(@"Message_topMetting");
        cell_1_0.showSwitch=[NSNumber numberWithBool:YES];
        cell_1_0.hiddenArrow = [NSNumber numberWithBool:YES];
        
        MGroupDetailCell *cell_1_1=[[MGroupDetailCell alloc] init];
        cell_1_1.text =LOCALIZATION(@"Message_NO_Excuse");
        cell_1_1.showSwitch=[NSNumber numberWithBool:YES];
        cell_1_1.hiddenArrow = [NSNumber numberWithBool:YES];

        MGroupDetailCell *cell_2_1=[[MGroupDetailCell alloc] init];
        cell_2_1.text =LOCALIZATION(@"Message_search_metting");
        cell_2_1.showSwitch=[NSNumber numberWithBool:NO];
        cell_2_1.hiddenArrow = [NSNumber numberWithBool:NO];

        MGroupDetailCell *cell_2_2=[[MGroupDetailCell alloc] init];
        cell_2_2.text =LOCALIZATION(@"Message_clean_metting");
        cell_2_2.showSwitch=[NSNumber numberWithBool:NO];
        cell_2_2.hiddenArrow = [NSNumber numberWithBool:YES];
        
        [weakSelf.groupDetails setObject:@[weakSelf.chatUser] forKey:@"0"];
        [weakSelf.groupDetails setObject:@[cell_1_0,cell_1_1] forKey:@"1"];
        [weakSelf.groupDetails setObject:@[cell_2_1,cell_2_2] forKey:@"2"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tbView reloadData];
        });
    });
}

- (void)hideEmptySeparators:(UITableView *)tableView
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [tableView setTableFooterView:v];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = LOCALIZATION(@"Message_chat_shezhi");
    
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    self.tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, viewWithoutNavNoTabbar)];
    self.tbView.delegate = self;
    self.tbView.dataSource = self;
    self.tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tbView];
    [self hideEmptySeparators:self.tbView];
    self.tbView.backgroundColor =[UIColor colorWithRGBHex:0xe5e5e5];
    self.nibGroupChatDetailUsersCell =[UINib nibWithNibName:@"GQGroupChatDetailUsersCell" bundle:[NSBundle mainBundle]];
    
    self.groupDetails =[[NSMutableDictionary alloc] init];
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (!self.chatUser && self.chatMessage) {
            NSString *myGId=[[ConfigManager sharedInstance].userDictionary objectForKey:@"gid"];
            MEnterpriseUser *chatUser =[[[SQLiteManager sharedInstance] getAllUserByGid:myGId] objectForKey:weakSelf.chatMessage.msgOtherId];
            weakSelf.chatUser = chatUser;
            [self loadData];
        }
        else
        {
            [self loadData];
        }
    });
}

-(void)clickLeftItem:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  GQGroupUserContainerDelegate
-(void)userItemTapedInGroupUserContainer:(MEnterpriseUser*)userItem{
    NSLog(@"进入企业用户名片页面");
    EnterpriseUserCardViewController *userCard =[[EnterpriseUserCardViewController alloc] initWithNibName:@"EnterpriseUserCardViewController" bundle:[NSBundle mainBundle]];
    userCard.user =userItem;
    [self.navigationController pushViewController:userCard animated:YES];
}

-(void)addBtnClickedInGroupUserContainer{
    NSLog(@"增加群组人员");
    SelectEnterpriseUserViewController *selectUserVC =[[SelectEnterpriseUserViewController alloc] init];
    GQNavigationController *selectUserVCNav =[[GQNavigationController alloc] initWithRootViewController:selectUserVC];
    if(self.group&&[self.group.users count])
    {
        selectUserVC.groupName =self.group.groupName;
        selectUserVC.groupId =self.group.groupid;
        NSMutableArray *userIds =[[NSMutableArray alloc] init];
        for (MGroupUser *gu in self.group.users) {
            if (gu && gu.uid && [NSString stringWithFormat:@"%@",gu.uid].length>0) {
                [userIds addObject:gu.uid];
            }
        }
        selectUserVC.disabledContactIds =[NSMutableArray arrayWithArray:userIds];
        selectUserVC.fromChatDetail = YES;
    }
    else
    {
        selectUserVC.groupName = LOCALIZATION(@"Message_TempChat");
        selectUserVC.fromChatDetail = YES;
        selectUserVC.currentChatUid = _chatUser.uid;
        selectUserVC.disabledContactIds =[NSMutableArray arrayWithArray:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",_chatUser.uid], nil]];
        [selectUserVC setCreatGroupBlock:^(MGroup *model){
            [selectUserVCNav dismissViewControllerAnimated:YES completion:^{
                MGroup *group = model;
                ChatViewController *chatVC =[[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:[NSBundle mainBundle]];
                chatVC.chatGroup = group;
                chatVC.isGroup =YES;
                [self.navigationController pushViewController:chatVC animated:YES];
            }];
        }];
    }
    [self presentViewController:selectUserVCNav animated:YES completion:^{
        
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tbView)
    {
        CGFloat sectionHeaderHeight = 30;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *sectionArry =[self.groupDetails objectForKey:[NSString stringWithFormat:@"%d",section]];
    return [sectionArry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *sectionArry =[self.groupDetails objectForKey:[NSString stringWithFormat:@"%d",indexPath.section]];
    GQGroupChatDetailUsersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GQGroupChatDetailUsersCell"];
    if(!cell){
        cell=(GQGroupChatDetailUsersCell*)[[self.nibGroupChatDetailUsersCell instantiateWithOwner:self options:nil] objectAtIndex:0];
    }
    cell.groupDetail=[sectionArry objectAtIndex:indexPath.row];
    cell.chatUserContainer.delegate =self;
    cell.zjSwitch.indexPath = indexPath;
    [cell.zjSwitch addTarget:self action:@selector(zjSwitchEvent:) forControlEvents:UIControlEventValueChanged];
    if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            NSLog(@"置顶聊天row isOn = %hhd",[[[[[NSUserDefaults standardUserDefaults] objectForKey:SettingTopKey] objectForKey:_chatUser.uid] objectForKey:_chatUser.uid] boolValue]);
            cell.zjSwitch.on = [[[[[NSUserDefaults standardUserDefaults] objectForKey:SettingTopKey] objectForKey:_chatUser.uid] objectForKey:_chatUser.uid] boolValue];
        }
        else if(indexPath.row == 1)
        {
//            NSLog(@"消息面打扰 isOn = %hhd",sender.on);
//            NSLog(@"===%@\n====%@",[[NSUserDefaults standardUserDefaults] objectForKey:SettingDisturbKey],[[[NSUserDefaults standardUserDefaults] objectForKey:SettingDisturbKey] objectForKey:_chatUser.uid]);
            cell.zjSwitch.on = [[[[NSUserDefaults standardUserDefaults] objectForKey:SettingDisturbKey] objectForKey:_chatUser.uid] boolValue];
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.groupDetails count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 10)];
    headerView.backgroundColor =[UIColor colorWithRGBHex:0xe5e5e5];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return 60;
    }else{
        return 44;
    }
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row ==0 && indexPath.section ==2) {
        ChatMoreViewController *chatVC = [[ChatMoreViewController alloc] init];
        chatVC.chatUser = _chatUser;
        chatVC.isGroup =NO;
        chatVC.footViewShow = NO;
        [self.navigationController pushViewController:chatVC animated:YES];
        
    }

    else if (indexPath.row ==1 && indexPath.section ==2) {
        //清空
        CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:LOCALIZATION(@"EnterpriseUserCardViewController_Prompt") message:LOCALIZATION(@"sure_to_delete") cancelButtonTitle:LOCALIZATION(@"discover_cancel")];
        
        [alertView addButtonWithTitle:LOCALIZATION(@"confirm") type:CXAlertViewButtonTypeDefault handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
            
            [[SQLiteManager sharedInstance] deleteChatUserMessageWithKeyId:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]] sessionId:_chatUser.uid notificationName:DELETECHATINFO];
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_cleaning") isDismissLater:NO];
            
            [alertView dismiss];
            
        }];
        
        [alertView show];
    }
}


-(void)zjSwitchEvent:(ZJSwitch *)sender
{
    if(sender.indexPath.section == 1)
    {
        if(sender.indexPath.row == 0)
        {
            NSLog(@"置顶聊天 isOn = %hhd",sender.on);
            NSMutableDictionary *mainDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:SettingTopKey]];
            if (!mainDic) {
                mainDic = [[NSMutableDictionary alloc] init];
            }
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[mainDic objectForKey:_chatUser.uid]];
            if (!dic) {
                dic = [[NSMutableDictionary alloc] init];
            }
            [dic setValue:[NSString stringWithFormat:@"%d",sender.on] forKey:_chatUser.uid];
            [dic setValue:[NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970]*1000] forKey:SettingTopTime];
            [mainDic setValue:dic forKey:_chatUser.uid];
            [[NSUserDefaults standardUserDefaults] setValue:mainDic forKey:SettingTopKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_R_SQL_MESSAGE object:nil];
        }
        else if(sender.indexPath.row == 1)
        {
            NSLog(@"消息面打扰 isOn = %hhd",sender.on);
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:SettingDisturbKey]];
            if (!dic) {
                dic = [[NSMutableDictionary alloc] init];
            }
            [dic setValue:[NSString stringWithFormat:@"%d",sender.on] forKey:_chatUser.uid];
            [[NSUserDefaults standardUserDefaults] setValue:dic forKey:SettingDisturbKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_R_SQL_MESSAGE object:nil];
        }
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
