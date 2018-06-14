//
//  GroupContactsViewController.m
//  IM
//
//  Created by 陆浩 on 15/4/22.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "GroupContactsViewController.h"
#import "ContactsTableViewCell.h"

@interface GroupContactsViewController ()

@end

@implementation GroupContactsViewController
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
    [self setupViews];
    [self loadData];

    // Do any additional setup after loading the view.
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_R_SQL_GROUPUSER object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRSQLGroupUser:) name:NOTIFICATION_R_SQL_GROUPUSER object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_D_SQL_GROUPUSER_RELOAD object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationDSQLGroupUser:) name:NOTIFICATION_D_SQL_GROUPUSER_RELOAD object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_R_SQL_USER object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRSQLUser) name:NOTIFICATION_R_SQL_USER object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_U_SQL_GROUP object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationUSQLGroup:) name:NOTIFICATION_U_SQL_GROUP object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_D_SQL_GROUP object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationDSQLGroup:) name:NOTIFICATION_D_SQL_GROUP object:nil];
    }
    return self;
}

-(void)notificationRSQLUser{
    [self loadGroupContactsData];
}

-(void)notificationDSQLGroup:(NSNotification*)notification{
    [self loadGroupContactsData];
}

-(void)notificationUSQLGroup:(NSNotification*)notification{
    [self loadGroupContactsData];
}

-(void)notificationRSQLGroupUser:(NSNotification*)notification{
    [self loadGroupContactsData];
}

-(void)notificationDSQLGroupUser:(NSNotification*)notification{
    [self loadGroupContactsData];
}

#pragma mark 组装视图
-(void)setupViews{
    self.groupTBView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, viewWithNavNoTabbar)];
    self.groupTBView.backgroundColor=BGColor;
    self.groupTBView.delegate = self;
    self.groupTBView.dataSource = self;
    self.groupTBView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.groupTBView];
    [self handleNormalNavigationBarItem];
    
    self.nibGroupContacts =[UINib nibWithNibName:@"GQGroupContactsCell" bundle:[NSBundle mainBundle]];
    self.groupTBView.tableFooterView =[[UIView alloc] init];
}


#pragma mark 导航条点击事件
-(void)clickLeftItem:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickRightItem:(id)sender{
    UITextField *textField =[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 250, 30)];
    textField.borderStyle=UITextBorderStyleRoundedRect;
    textField.delegate =self;
    textField.returnKeyType =UIReturnKeyDone;
    CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:LOCALIZATION(@"GroupContactsViewController_Title")  contentView:textField cancelButtonTitle:nil];
    alertView.keyboardHeight = 216;
    [textField becomeFirstResponder];
    alertView.showBlurBackground = NO;
    [alertView addButtonWithTitle:LOCALIZATION(@"GroupContactsViewController_Cancel")
                             type:CXAlertViewButtonTypeDefault
                          handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                              [alertView dismiss];
                              [textField resignFirstResponder];
                              
                          }];
    [alertView addButtonWithTitle:LOCALIZATION(@"GroupContactsViewController_Confirm")
                             type:CXAlertViewButtonTypeCancel
                          handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                              [alertView dismiss];
                              [textField resignFirstResponder];
                              if (textField.text && textField.text.length>0) {
                                  [self handleCreateGroupWithName:textField.text];
                              }
                              else{
                                  [self.view makeToast:LOCALIZATION(@"GroupContactsViewController_Title")];
                                  return ;
                              }
                          }];
    
    self.createGroupChatAlertView =alertView;
    [self.createGroupChatAlertView show];
}

#pragma mark 加载数据
-(void)loadData{
    [self loadGroupContactsData];
}

#pragma mark 加载我的群聊通讯录
-(void)loadGroupContactsData{
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *sortedArray = [NSArray arrayWithArray:[[[SQLiteManager sharedInstance] getAllOnlyGroups] allValues]];
        NSArray *array = [sortedArray sortedArrayUsingComparator:^(MGroup *model1,MGroup *model2) {
            long val1 = [model1.createTime longLongValue];
            long val2 = [model2.createTime longLongValue];
            if (val1 > val2) {
                return NSOrderedAscending;
            } else {
                return NSOrderedDescending;
            }
        }];
        weakSelf.groupContacts = [NSMutableArray arrayWithArray:array];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray *hasUsersArr=[[NSMutableArray alloc]initWithCapacity:0];
            for (MGroup *mg in weakSelf.groupContacts) {
                MGroup *newMg=[[[SQLiteManager sharedInstance] getAllOnlyGroups] objectForKey:mg.groupid];
                [[SQLiteManager sharedInstance] setUserArrayByGroupModel:newMg];

                if (newMg.groupid.length == 0)  {
                }else {
                    [hasUsersArr addObject:newMg];
                }
            }
            
            weakSelf.groupContacts=[NSMutableArray arrayWithArray:hasUsersArr];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.groupTBView reloadData];
            });

        });        
    });
}



#pragma mark -------------------------------------------------------------------------
#pragma mark 处理正常情况下的导航条
-(void)handleNormalNavigationBarItem{
    self.navigationItem.title = LOCALIZATION(@"GroupContactsViewController_NavTitle");
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    ILBarButtonItem *rightItem = [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_add.png"]highlightedImage:nil target:self action:@selector(clickRightItem:)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 0.5)];
    lineView.backgroundColor=[UIColor grayColor];
    [self.view addSubview:lineView];
}

#pragma mark 处理创建群组名称
-(void)handleCreateGroupWithName:(NSString*)groupName{
    
    groupName = [groupName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([groupName length] == 0)
    {
        [self.view makeToast:LOCALIZATION(@"GroupContactsViewController_GroupNameLimit")];
        return;
    }
    SelectEnterpriseUserViewController *selectUserVC =[[SelectEnterpriseUserViewController alloc] init];
    selectUserVC.groupName = groupName;
    selectUserVC.fromChatDetail = YES;
    GQNavigationController *selectUserVCNav =[[GQNavigationController alloc] initWithRootViewController:selectUserVC];
    [selectUserVC setCreatGroupBlock:^(MGroup *model){
        [selectUserVCNav dismissViewControllerAnimated:YES completion:^{
            MGroup *group = model;
            ChatViewController *chatVC =[[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:[NSBundle mainBundle]];
            chatVC.chatGroup = group;
            chatVC.isGroup =YES;
            [self.navigationController pushViewController:chatVC animated:YES];
        }];
    }];
    [self presentViewController:selectUserVCNav animated:YES completion:^{
    }];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self.createGroupChatAlertView dismiss];
    
    if (textField.text && textField.text.length>0) {
        [self handleCreateGroupWithName:textField.text];
    }
    return YES;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MGroup *group =[self.groupContacts objectAtIndex:indexPath.row];
    ChatViewController *chatVC =[[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:[NSBundle mainBundle]];
    chatVC.chatGroup = group;
    chatVC.isGroup =YES;
    chatVC.isFromTempGroup = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 42;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.groupContacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"ContactsTableViewCell";
    GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[GroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MGroup *group =[self.groupContacts objectAtIndex:indexPath.row];
    [cell loadCellWithModel:group];
    return cell;
}

@end
