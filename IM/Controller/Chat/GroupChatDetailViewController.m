//
//  GroupChatDetailViewController.m
//  IM
//
//  Created by zuo guoqing on 14-10-9.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "GroupChatDetailViewController.h"
#import "AllUserViewController.h"
#import "NoticeListViewController.h"

@interface GroupChatDetailViewController ()<GQGroupUsersCellDelegate>

@end

@implementation GroupChatDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRSQLGroupUser:) name:NOTIFICATION_R_SQL_GROUPUSER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRSQLGroupUser:) name:NOTIFICATION_D_SQL_GROUPUSER_RELOAD object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteChatInfo) name:DELETECHATINFO object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=NO;
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

-(void)notificationRSQLGroupUser:(NSNotification*)notification{
    NSLog(@"从数据库中加群组");
    [self loadData];
}


-(void)loadData{
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
//        weakSelf.group =[[[SQLiteManager sharedInstance] getAllGroups] objectForKey:weakSelf.group.groupid];
        weakSelf.group =[[[SQLiteManager sharedInstance] getAllOnlyGroups] objectForKey:weakSelf.group.groupid];
        [[SQLiteManager sharedInstance] setUserArrayByGroupModel:weakSelf.group];
        
        MGroupDetailCell *cell_0_0=[[MGroupDetailCell alloc] init];
//        cell_0_0占位object
        
        MGroupDetailCell *cell_1_0=[[MGroupDetailCell alloc] init];
        cell_1_0.text =LOCALIZATION(@"Message_quanName");
        cell_1_0.detailText = self.group.groupName;
        cell_1_0.showSwitch = [NSNumber numberWithBool:NO];
        cell_1_0.hiddenArrow = [NSNumber numberWithBool:NO];
        
        MGroupDetailCell *cell_1_1=[[MGroupDetailCell alloc] init];
//        cell_1_1.text =@"群成员";//占位object
        
        MGroupDetailCell *cell_1_2=[[MGroupDetailCell alloc] init];
        cell_1_2.text =LOCALIZATION(@"Message_topMetting");
        cell_1_2.showSwitch=[NSNumber numberWithBool:YES];
        cell_1_2.hiddenArrow = [NSNumber numberWithBool:YES];
        
        MGroupDetailCell *cell_1_3=[[MGroupDetailCell alloc] init];
        cell_1_3.text =LOCALIZATION(@"Message_NO_Excuse");
        cell_1_3.showSwitch=[NSNumber numberWithBool:YES];
        cell_1_3.hiddenArrow = [NSNumber numberWithBool:YES];
        
        MGroupDetailCell *cell_2_0=[[MGroupDetailCell alloc] init];
        cell_2_0.text =LOCALIZATION(@"Message_search_metting");
        cell_2_0.showSwitch=[NSNumber numberWithBool:NO];
        cell_2_0.hiddenArrow = [NSNumber numberWithBool:NO];
        
        MGroupDetailCell *cell_2_1=[[MGroupDetailCell alloc] init];
        cell_2_1.text =LOCALIZATION(@"Message_clean_metting");
        cell_2_1.showSwitch=[NSNumber numberWithBool:NO];
        cell_2_1.hiddenArrow = [NSNumber numberWithBool:YES];

        
        
        [weakSelf.groupDetails setObject:@[cell_0_0] forKey:@"0"];
//        [weakSelf.groupDetails setObject:@[weakSelf.group] forKey:@"0"];
        [weakSelf.groupDetails setObject:@[cell_1_0,cell_1_1,cell_1_2,cell_1_3] forKey:@"1"];
        [weakSelf.groupDetails setObject:@[cell_2_0,cell_2_1] forKey:@"2"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tbView reloadData];
            self.tbView.hidden = NO;
        });
    });
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.navigationItem.title = LOCALIZATION(@"Message_quan_sezhi");
    self.navigationItem.title = self.group.groupName;

    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    self.tbView.backgroundColor =[UIColor colorWithRGBHex:0xe5e5e5];
    self.nibGroupChatDetailUsersCell =[UINib nibWithNibName:@"GQGroupChatDetailUsersCell" bundle:[NSBundle mainBundle]];
    
    UIView *tableFooterView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 60)];
    tableFooterView.backgroundColor =[UIColor colorWithRGBHex:0xe5e5e5];
    UIButton *deleteBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.layer.masksToBounds = YES;
    deleteBtn.layer.cornerRadius = 5;
    [deleteBtn setFrame:CGRectMake(10, 20, boundsWidth - 20, 40)];
    [deleteBtn setBackgroundImage:[Common getImageFromColor:[UIColor hexChangeFloat:@"f4504f"]] forState:UIControlStateNormal];
    [deleteBtn setTitle:LOCALIZATION(@"Message_delandout") forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:deleteBtn];
    self.tbView.tableFooterView =tableFooterView;
    self.groupDetails =[[NSMutableDictionary alloc] init];
    
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (!self.group && self.chatMessage) {
            MGroup *chatGroup =[[[SQLiteManager sharedInstance] getAllOnlyGroups] objectForKey:[weakSelf.chatMessage.msgOtherId substringFromIndex:1]];
            weakSelf.group = chatGroup;
            [self loadData];
        }
        else
        {
            [self loadData];
        }
    });

    
    self.tbView.hidden = YES;
    
}

-(void)clickLeftItem:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)deleteBtnClicked:(UIButton*)sender{

    sender.enabled = NO;
    
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *myToken =[[ConfigManager sharedInstance].userDictionary  objectForKey:@"token"];
        NSString *myUid =[[ConfigManager sharedInstance].userDictionary  objectForKey:@"uid"];
        NSMutableDictionary *params =[[NSMutableDictionary alloc] init];
        [params setObject:myToken forKey:@"token"];
        [params setObject:weakSelf.group.groupid forKey:@"groupid"];
        if ([weakSelf.group.uid longLongValue] ==[myUid longLongValue]) {
            //自己是群主退群
            if ([weakSelf.group.users count]>1) {
                MGroupUser *newUser= [weakSelf.group.users objectAtIndex:1];
                [params setObject:newUser.uid forKey:@"newuid"];
                [params setObject:newUser.uname forKey:@"newname"];
                
                [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodQuitGroup] parameters:params successBlock:^(BOOL success, id data, NSString *msg) {
                    if (success) {

                        [[SQLiteManager sharedInstance] deleteGroupUserId:myUid groupId:weakSelf.group.groupid notificationName:NOTIFICATION_D_SQL_GROUPUSER_NOT_RELOAD];
                        [[SQLiteManager sharedInstance] deleteGroupId:weakSelf.group.groupid notificationName:NOTIFICATION_D_SQL_GROUP];
                        [[SQLiteManager sharedInstance] deleteGroupMessagesWithSessionId:[NSString stringWithFormat:@"g%@",weakSelf.group.groupid] notificationName:NOTIFICATION_R_SQL_MESSAGE];
                        //
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        });
                        }else{
                           sender.enabled = YES;
                    }
                } failureBlock:^(NSString *description) {
                   sender.enabled = YES;
                }];

            }else{
                
                [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodRemoveGroup] parameters:params successBlock:^(BOOL success, id data, NSString *msg) {
                    if (success) {

                        [[SQLiteManager sharedInstance] deleteGroupUserId:myUid groupId:weakSelf.group.groupid notificationName:NOTIFICATION_D_SQL_GROUPUSER_NOT_RELOAD];
                        [[SQLiteManager sharedInstance] deleteGroupId:weakSelf.group.groupid notificationName:NOTIFICATION_D_SQL_GROUP];
                        
                        [[SQLiteManager sharedInstance] deleteGroupMessagesWithSessionId:[NSString stringWithFormat:@"g%@",weakSelf.group.groupid] notificationName:NOTIFICATION_R_SQL_MESSAGE];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        });
                        
                    }else{
                        sender.enabled = YES;
                    }
                } failureBlock:^(NSString *description) {
                    sender.enabled = YES;
                }];
                
            }
        }else{
            [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodQuitGroup] parameters:params successBlock:^(BOOL success, id data, NSString *msg) {
                if (success) {
                    
                    [[SQLiteManager sharedInstance] deleteGroupUserId:myUid groupId:weakSelf.group.groupid notificationName:NOTIFICATION_D_SQL_GROUPUSER_NOT_RELOAD];
                    [[SQLiteManager sharedInstance] deleteGroupId:weakSelf.group.groupid notificationName:NOTIFICATION_D_SQL_GROUP];
                    
                    [[SQLiteManager sharedInstance] deleteGroupMessagesWithSessionId:[NSString stringWithFormat:@"g%@",weakSelf.group.groupid] notificationName:NOTIFICATION_R_SQL_MESSAGE];

                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        
                    });
                    
                    
                }else{
                   sender.enabled = YES;
                }
                
            } failureBlock:^(NSString *description) {
                sender.enabled = YES;
            }];
        }
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  GQGroupUserContainerDelegate
-(void)userItemTapedInGroupUserContainer:(GQGroupUserItem*)userItem{
    NSLog(@"进入企业用户名片页面");
    EnterpriseUserCardViewController *userCard =[[EnterpriseUserCardViewController alloc] initWithNibName:@"EnterpriseUserCardViewController" bundle:[NSBundle mainBundle]];
    userCard.user =userItem.groupUser;
    [self.navigationController pushViewController:userCard animated:YES];
}
-(void)addBtnClickedInGroupUserContainer{
    NSLog(@"增加群组人员");
    
    SelectEnterpriseUserViewController *selectUserVC =[[SelectEnterpriseUserViewController alloc] init];
    selectUserVC.groupName =self.group.groupName;
    selectUserVC.groupId =self.group.groupid;
    NSMutableArray *userIds =[[NSMutableArray alloc] init];
    for (MGroupUser *gu in self.group.users) {
        if (gu && gu.uid && [NSString stringWithFormat:@"%@",gu.uid].length>0) {
            [userIds addObject:gu.uid];
        }
    }
    selectUserVC.disabledContactIds =[NSMutableArray arrayWithArray:userIds];
    
    GQNavigationController *selectUserVCNav =[[GQNavigationController alloc] initWithRootViewController:selectUserVC];
    [self presentViewController:selectUserVCNav animated:YES completion:^{
        
    }];
    
}
-(void)btnDeleteClickedInGroupUserItemWithUsers:(NSMutableArray*)users isReload:(BOOL)isReload  deleteUserId:(NSString*)deleteUserId{
    NSLog(@"删除群组人员");

    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *myToken =[[ConfigManager sharedInstance].userDictionary  objectForKey:@"token"];
        NSMutableDictionary *params =[[NSMutableDictionary alloc] init];
        [params setObject:myToken forKey:@"token"];
        [params setObject:weakSelf.group.groupid forKey:@"groupid"];
        [params setObject:[NSArray arrayWithObject:deleteUserId] forKey:@"users"];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodRemoveGroupMember] parameters:params successBlock:^(BOOL success, id data, NSString *msg) {
            
            [[SQLiteManager sharedInstance] deleteGroupUserId:deleteUserId groupId:weakSelf.group.groupid notificationName:NOTIFICATION_D_SQL_GROUPUSER_RELOAD];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.group.users =[NSMutableArray arrayWithArray:users];
                self.group.showDelete =YES;
                
                if (isReload) {
                    [self.tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                }
                
            });
        } failureBlock:^(NSString *description) {
            NSLog(@"%@",description);
        }];
    });
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
//    NSArray *sectionArry =[self.groupDetails objectForKey:[NSString stringWithFormat:@"%d",section]];
//    return [sectionArry count];
    
    //屏蔽tag
    if(section != 0)
    {
        NSArray *sectionArry =[self.groupDetails objectForKey:[NSString stringWithFormat:@"%d",section]];
        return [sectionArry count];
    }
    else
    {
        return 0;
    }
    //end
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *sectionArry =[self.groupDetails objectForKey:[NSString stringWithFormat:@"%d",indexPath.section]];
    if(indexPath.section == 0)
    {
        UITableViewCell *eventCell = [tableView dequeueReusableCellWithIdentifier:@"GQGroupUsersCell"];
        if(!eventCell){
            eventCell= [[GQGroupUsersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GQGroupUsersCell"];
            eventCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        for(UIView *view in [eventCell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        CGFloat buttonWidth  = boundsWidth/3.0;
        for(int i = 0 ; i < 3 ; i ++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0+buttonWidth*i, 0, buttonWidth, 65);
            [eventCell.contentView addSubview:button];
            [button setImageEdgeInsets:UIEdgeInsetsMake(10, (buttonWidth-30)/2, 65-30-10, (buttonWidth-30)/2)];
            [button setBackgroundColor: [UIColor whiteColor]];
            button.tag = i;
            [button addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, buttonWidth, 25)];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = [UIColor lightGrayColor];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont systemFontOfSize:12];
            [button addSubview:titleLabel];
            if(i == 0)
            {
                [button setImage:[UIImage imageNamed:@"chat_group_noti.png"] forState:UIControlStateNormal];
                titleLabel.text = LOCALIZATION(@"Message_gonggao");
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(buttonWidth-0.5, 20, 0.5, 25)];
                line.backgroundColor =[UIColor lightGrayColor];
                [button addSubview:line];
            }
            else if(i == 1)
            {
                [button setImage:[UIImage imageNamed:@"chat_group_files.png"] forState:UIControlStateNormal];
                titleLabel.text =   LOCALIZATION(@"Message_file");
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(buttonWidth-0.5, 20, 0.5, 25)];
                line.backgroundColor =[UIColor lightGrayColor];
                [button addSubview:line];
            }
            else
            {
                [button setImage:[UIImage imageNamed:@"chat_group_photo.png"] forState:UIControlStateNormal];
                titleLabel.text = LOCALIZATION(@"Message_photo");
            }
            [eventCell.contentView addSubview:button];
        }
        return eventCell;
    }
    else if(indexPath.row == 1 && indexPath.section == 1)
    {
        GQGroupUsersCell *cell = [[GQGroupUsersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GQGroupUsersCellCell" userCount:self.group.users.count];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        [cell loadCellWithData:self.group.users];
        return cell;
    }
    else
    {
        GQGroupChatDetailUsersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GQGroupChatDetailUsersCell"];
        if(!cell){
            cell=(GQGroupChatDetailUsersCell*)[[self.nibGroupChatDetailUsersCell instantiateWithOwner:self options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.groupDetail = [sectionArry objectAtIndex:indexPath.row];
        cell.zjSwitch.indexPath = indexPath;
        [cell.zjSwitch addTarget:self action:@selector(zjSwitchEvent:) forControlEvents:UIControlEventValueChanged];
        if(indexPath.section == 1)
        {
            if(indexPath.row == 2)
            {
//                NSLog(@"置顶聊天row isOn = %hhd",[[[[[NSUserDefaults standardUserDefaults] objectForKey:SettingTopKey] objectForKey:_group.groupid] objectForKey:_group.groupid] boolValue]);
                cell.zjSwitch.on = [[[[[NSUserDefaults standardUserDefaults] objectForKey:SettingTopKey] objectForKey:_group.groupid] objectForKey:_group.groupid] boolValue];
            }
            else if(indexPath.row == 3)
            {
                //            NSLog(@"消息面打扰 isOn = %hhd",sender.on);
                cell.zjSwitch.on = [[[[NSUserDefaults standardUserDefaults] objectForKey:SettingDisturbKey] objectForKey:_group.groupid] boolValue];
            }
        }
        return cell;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.groupDetails count];
}


#pragma mark UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 10)];
    headerView.backgroundColor =[UIColor colorWithRGBHex:0xe5e5e5];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0)
    {
//        int row =ceil(([self.group.users count]+2)/4.0);
//        return 30+row*100;
        return 65;
    }
    else if(indexPath.row == 1 && indexPath.section == 1)
    {
        return 95;
    }
    else
    {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 1&&indexPath.row == 1){
        //查看所有联系人
        AllUserViewController *vc = [[AllUserViewController alloc] init];
        vc.groupUser = self.group;
        vc.canDeleteUser = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row ==0 && indexPath.section ==1) {
        UITextField *textField =[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 250, 30)];
        textField.borderStyle=UITextBorderStyleRoundedRect;
        textField.delegate =self;
        textField.returnKeyType =UIReturnKeyDone;
        CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:LOCALIZATION(@"Message_xiugai_name")  contentView:textField cancelButtonTitle:nil];
        alertView.keyboardHeight=216;
        [textField becomeFirstResponder];
        alertView.showBlurBackground = NO;
        [alertView addButtonWithTitle:LOCALIZATION(@"Message_cancel")
                                 type:CXAlertViewButtonTypeDefault
                              handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                  [alertView dismiss];
                                  [textField resignFirstResponder];
                                  
                              }];
        [alertView addButtonWithTitle:LOCALIZATION(@"Message_good")
                                 type:CXAlertViewButtonTypeCancel
                              handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                  [alertView dismiss];
                                  [textField resignFirstResponder];
                                  if (textField.text && textField.text.length>0) {
                                      [self handleModifyGroupWithName:textField.text];
                                      
                                  }
                                  
                              }];
        
        self.createGroupChatAlertView =alertView;
        [self.createGroupChatAlertView show];
    }
    else if (indexPath.row ==0 && indexPath.section ==2) {
        ChatMoreViewController *chatVC =[[ChatMoreViewController alloc] init];
        chatVC.chatGroup = _group;
        chatVC.isGroup =YES;
        chatVC.footViewShow = NO;
        [self.navigationController pushViewController:chatVC animated:YES];
    }
    else if (indexPath.row ==1 && indexPath.section ==2) {
        //清空
        CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:LOCALIZATION(@"EnterpriseUserCardViewController_Prompt") message:LOCALIZATION(@"sure_to_delete") cancelButtonTitle:LOCALIZATION(@"discover_cancel")];
        [alertView addButtonWithTitle:LOCALIZATION(@"confirm") type:CXAlertViewButtonTypeDefault handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
            [[SQLiteManager sharedInstance] deleteGroupMessagesWithSessionId:[NSString stringWithFormat:@"g%@",_group.groupid] notificationName:DELETECHATINFO];
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_cleaning") isDismissLater:NO];
            [alertView dismiss];
        }];
        
        [alertView show];
    }
}

#pragma mark GQGroupUsersCellDelegate

-(void)tapGroupUser:(int)index
{
    NSLog(@"进入企业用户名片页面");
    EnterpriseUserCardViewController *userCard =[[EnterpriseUserCardViewController alloc] initWithNibName:@"EnterpriseUserCardViewController" bundle:[NSBundle mainBundle]];
    userCard.user = [self.group.users objectAtIndex:index];
    [self.navigationController pushViewController:userCard animated:YES];
}

-(void)addGroupUser
{
    NSLog(@"添加用户");
    SelectEnterpriseUserViewController *selectUserVC =[[SelectEnterpriseUserViewController alloc] init];
    selectUserVC.groupName =self.group.groupName;
    selectUserVC.groupId =self.group.groupid;
    NSMutableArray *userIds =[[NSMutableArray alloc] init];
    for (MGroupUser *gu in self.group.users) {
        if (gu && gu.uid && [NSString stringWithFormat:@"%@",gu.uid].length>0) {
            [userIds addObject:gu.uid];
        }
    }
    selectUserVC.disabledContactIds =[NSMutableArray arrayWithArray:userIds];
    GQNavigationController *selectUserVCNav =[[GQNavigationController alloc] initWithRootViewController:selectUserVC];
    [self presentViewController:selectUserVCNav animated:YES completion:^{
    }];
}


#pragma mark cell 中按钮以及switch事件
-(void)topButtonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
        {
            NSLog(@"公告");
            NoticeListViewController * noticeListView = [[NoticeListViewController alloc]init];
            noticeListView.hidesBottomBarWhenPushed = YES;
            noticeListView.group = self.group;
            [self.navigationController pushViewController:noticeListView animated:YES];
        }
            break;
        case 1:
            NSLog(@"文件");
            break;
        case 2:
            NSLog(@"相册");
            break;
  
        default:
            break;
    }
}

-(void)zjSwitchEvent:(ZJSwitch *)sender
{
    if(sender.indexPath.section == 1)
    {
        
        if(sender.indexPath.row == 2)
        {
            NSLog(@"置顶聊天 isOn = %hhd",sender.on);
            NSMutableDictionary *mainDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:SettingTopKey]];
            if (!mainDic) {
                mainDic = [[NSMutableDictionary alloc] init];
            }
            if(_group.groupid)
            {
                //不知道他们为什么会crash，报错说的是key不能为nil
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[mainDic objectForKey:_group.groupid]];
                if (!dic) {
                    dic = [[NSMutableDictionary alloc] init];
                }
                [dic setValue:[NSString stringWithFormat:@"%d",sender.on] forKey:_group.groupid];
//                [dic setValue:[NSString stringWithFormat:@"%@",[NSDate date]] forKey:SettingTopTime];
                [dic setValue:[NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970]*1000] forKey:SettingTopTime];
                [mainDic setValue:dic forKey:_group.groupid];
                [[NSUserDefaults standardUserDefaults] setValue:mainDic forKey:SettingTopKey];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_R_SQL_MESSAGE object:nil];
            }
        }
        else if(sender.indexPath.row == 3)
        {
            if(_group.groupid)
            {
                //不知道他们为什么会crash，报错说的是key不能为nil
                NSLog(@"消息面打扰 isOn = %hhd",sender.on);
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:SettingDisturbKey]];
                if (!dic) {
                    dic = [[NSMutableDictionary alloc] init];
                }
                [dic setValue:[NSString stringWithFormat:@"%d",sender.on] forKey:_group.groupid];
                [[NSUserDefaults standardUserDefaults] setValue:dic forKey:SettingDisturbKey];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_R_SQL_MESSAGE object:nil];
            }
        }
    }
}

#pragma mark 处理创建群组名称
-(void)handleModifyGroupWithName:(NSString*)groupName{
    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_fixing") isDismissLater:NO];
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *myToken =[[ConfigManager sharedInstance].userDictionary  objectForKey:@"token"];
        NSMutableDictionary *params =[[NSMutableDictionary alloc] init];
        [params setObject:myToken forKey:@"token"];
        [params setObject:weakSelf.group.groupid forKey:@"groupid"];
        [params setObject:groupName forKey:@"groupName"];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodModifyGroup] parameters:params successBlock:^(BOOL success, id data, NSString *msg) {
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_fixSuccess") isDismissLater:YES];

            [[SQLiteManager sharedInstance] updateGroupName:groupName groupId:weakSelf.group.groupid notificationName:NOTIFICATION_U_SQL_GROUP];
            weakSelf.group.groupName = groupName;
            
            self.navigationItem.title = groupName;
            
            [self loadData];
            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
//            });
        } failureBlock:^(NSString *description) {
            
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_fixFil") isDismissLater:YES];
        }];
    });

}


#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self.createGroupChatAlertView dismiss];
    
    if (textField.text && textField.text.length>0) {
        [self handleModifyGroupWithName:textField.text];
    }
    return YES;
}

@end
