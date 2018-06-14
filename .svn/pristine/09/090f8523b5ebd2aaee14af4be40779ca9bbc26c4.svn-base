
//
//  MessageListViewController.m
//  IM
//
//  Created by zuo guoqing on 14-12-5.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "MessageListViewController.h"
#import "NotiListViewController.h"
#import "CreatNotiViewController.h"

#define MoreFuncCount 3

@interface MessageListViewController ()<UISearchBarDelegate,UISearchDisplayDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
{
    //UISearchBar *tmpSearchBar;
    UISearchDisplayController *searchDisplayController;
    NSMutableArray *resultArray;//搜索结果使用
    UIView *moreFounctionView;
    //UIImageView *navBarHairlineImageView;
}

@property(nonatomic,strong) UISearchBar *tmpSearchBar;
@property(nonatomic,strong) NSMutableArray *notiArray;//消息里面的通知的message

@end

@implementation MessageListViewController

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRSQLMessage) name:NOTIFICATION_R_SQL_MESSAGE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationDSQLMessage) name:NOTIFICATION_D_SQL_MESSAGE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationUSQLMessageReadState) name:NOTIFICATION_U_SQL_MESSAGE_READSTATE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationUSQLMessageSendState) name:NOTIFICATION_U_SQL_MESSAGE_SENDSTATE object:nil];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate tabbarController].navigationItem.title = self.tabBarItem.title;

    [appDelegate.drawerController removGestureRecognizers];
    appDelegate.centerButton.hidden=NO;
    ILBarButtonItem *rightItem=[ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_contact_add.png"] selectedImage:nil target:self action:@selector(clickRightItem:)];
    [[appDelegate tabbarController].navigationItem setRightBarButtonItem:rightItem];
    //navBarHairlineImageView.hidden = NO;
//    int i = self.messageList.count * 60 + 60 + self.tmpSearchBar.frame.size.height;
//    int i1 = viewWithNavAndTabbar;
//    if (i > i1){
//        self.tbView.scrollEnabled =YES;
//    
//    }else{
//        self.tbView.scrollEnabled = NO;
//    
//    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tbView setEditing:NO];
    //解决出现上半部分白屏的问题，操蛋
    [searchDisplayController setActive:YES animated:NO];
    [searchDisplayController setActive:NO animated:NO];
    //navBarHairlineImageView.hidden = YES;
    
}
-(void)notificationRSQLMessage{
    
    [self loadData];
}




-(void)notificationDSQLMessage{
    [self loadData];
}

-(void)notificationUSQLMessageReadState{
    
    [self loadData];
}

-(void)notificationUSQLMessageSendState{
    [self loadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tbView)
    {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tbView) {
        if(section == 0)
        {
            if([self.notiArray count])
            {
                return 1;
            }
            return 0;
        }
        else
        {
            int i = self.messageList.count * 60 + 60 + self.tmpSearchBar.frame.size.height;
            int i1 = viewWithNavAndTabbar;
            if (i > i1){
                self.tbView.scrollEnabled =YES;
                
            }else{
                self.tbView.scrollEnabled = NO;
                self.tbView.contentOffset = CGPointMake(0, 0);
                
            }
            return [self.messageList count];
        }
    }
    else
    {
        return [resultArray count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GQMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GQMessageCell"];
    
    if(!cell){
        cell=(GQMessageCell*)[[self.nibMessage instantiateWithOwner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MMessage *mm;

    if (tableView == self.tbView) {
        if(indexPath.section == 0 && indexPath.row == 0)
        {
            mm =[self.notiArray objectAtIndex:0];
        }
        else
        {
            if(indexPath.row < self.messageList.count)
            {
                mm =[self.messageList objectAtIndex:indexPath.row];
            }
        }
    }
    else
    {
        if(indexPath.row < resultArray.count)
        {
            mm =[resultArray objectAtIndex:indexPath.row];
        }
    }
    if(mm)
    {
        cell.message =mm;
    }
    
    return cell;

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tbView) {
        if(indexPath.section != 0)
        {
            return YES;
        }
    }
    return NO;
    
}




- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return LOCALIZATION(@"Message_table_del");
}


//这个方法用于解决ios8系统的cell侧滑崩溃
-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                         title: LOCALIZATION(@"Message_table_del")
                                                                       handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                           NSLog(@"删除");
                                                               if (tableView == self.tbView&&indexPath.section != 0)
                                                                   {
                                                                      
                                                                        if(indexPath.row < self.messageList.count)
                                                                           {
                                                                           MMessage *mm =[self.messageList objectAtIndex:indexPath.row];
                                                                           [[SQLiteManager sharedInstance] updateSessionShowStateByMsgOtherId :mm.msgOtherId notificationName:NOTIFICATION_U_SQL_MESSAGE_READSTATE];
                                                                                   [self.tbView reloadData];
                                                                            }
                                                                       
                                                                    }
                                                                }];
    
                                                                        NSArray *arr = @[rowAction];
                                                                        return arr;
    
}




-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tbView&&indexPath.section != 0)
    {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            if(indexPath.row < self.messageList.count)
            {
                MMessage *mm =[self.messageList objectAtIndex:indexPath.row];
                [[SQLiteManager sharedInstance] updateSessionShowStateByMsgOtherId :mm.msgOtherId notificationName:NOTIFICATION_U_SQL_MESSAGE_READSTATE];
                
                [self.tbView reloadData];
               
                    
                }
                
            }
        }
    }


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    GQMessageCell *cell =(GQMessageCell*)[tableView cellForRowAtIndexPath:indexPath];
//    [cell showBadgeWithNumber:0 NoDisturb:NO];
    
    if(tableView == self.tbView && indexPath.section == 0)
    {
        MMessage *mm =[self.notiArray objectAtIndex:0];//去最近的一个通知
        
        //查看通知哟
        NotiListViewController *vc = [[NotiListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[SQLiteManager sharedInstance] updateMessageReadStateByMsgOtherId:mm.msgOtherId notificationName:NOTIFICATION_U_SQL_MESSAGE_READSTATE];
        });
    }
    else
    {
        MMessage *mm;
        if(tableView != self.tbView)
        {
            if(indexPath.row < resultArray.count)
            {
                mm = [resultArray objectAtIndex:indexPath.row];
            }
        }
        else
        {
            if(indexPath.row < self.messageList.count)
            {
                mm = [self.messageList objectAtIndex:indexPath.row];
            }
        }
        if(mm)
        {
            [[MessageBadge sharedManager] updateMessageBadge:MessageBadgeUpdateStatusReadMessage userinfo:mm];
            WEAKSELF
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [[SQLiteManager sharedInstance] updateMessageReadStateByMsgOtherId:mm.msgOtherId notificationName:NOTIFICATION_U_SQL_MESSAGE_READSTATE];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([mm.type intValue]==MMessageTypeChat) {
                        ChatViewController *chatVC =[[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:[NSBundle mainBundle]];
                        chatVC.chatMessage = mm;
                        chatVC.isGroup =NO;
                        [weakSelf.navigationController pushViewController:chatVC animated:YES];
                        
                    }else{
                        ChatViewController *chatVC =[[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:[NSBundle mainBundle]];
                        chatVC.chatMessage = mm;
                        chatVC.isGroup =YES;
                        [weakSelf.navigationController pushViewController:chatVC animated:YES];
                    }
                });
            });
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    //navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    [self setupViews];
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLanguageChangedNotification:)
                                                 name:kNotificationLanguageChanged object:nil];
    
    
}

//- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
//    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
//        return (UIImageView *)view;
//    }
//    for (UIView *subview in view.subviews) {
//        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
//        if (imageView) {
//            return imageView;
//        }
//    }
//    return nil;
//}


- (void)receiveLanguageChangedNotification:(NSNotification*)notif{
    
    [Localisator sharedInstance].saveInUserDefaults = YES;
    
    if ([notif.name isEqualToString:kNotificationLanguageChanged])
    {
        [self titleSetting];
        [self.tbView reloadData];
    }
}

- (void)titleSetting{
    
  self.tmpSearchBar.placeholder = LOCALIZATION(@"Message_tmpSearchBar_placeholder");

}

-(void)clickRightItem:(id)sender{

    [self showMoreFounctionView];

}

#pragma mark -
#pragma mark - 部门更多功能界面以及事件
-(void)showMoreFounctionView
{
    if(!moreFounctionView)
    {
        moreFounctionView = [[UIView alloc] initWithFrame:CGRectMake(0, boundsHeight-(viewWithNavNoTabbar), boundsWidth, viewWithNavNoTabbar)];
        moreFounctionView.backgroundColor = [UIColor hexChangeFloat:@"000000" alpha:0.5];
        moreFounctionView.alpha = 0;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 85)];
        view.backgroundColor = [UIColor whiteColor];
        [moreFounctionView addSubview:view];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];

        [moreFounctionView addGestureRecognizer:singleTap];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(boundsWidth-31, -6, 12, 6)];
        imageView.image = [UIImage imageNamed:@"more_triangle.png"];
        [view addSubview:imageView];
        
        CGFloat buttonWidth = boundsWidth/MoreFuncCount;
        for(int i = 0 ; i < MoreFuncCount ; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0+buttonWidth*i, 8, buttonWidth, 50);
            [view addSubview:button];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.origin.x, button.frame.size.height+button.frame.origin.y, button.frame.size.width, 14)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor hexChangeFloat:@"878787"];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:12.0f];
            [view addSubview:label];
            
            switch (i) {
                case 0:
                    [button addTarget:self action:@selector(createGroupIM:) forControlEvents:UIControlEventTouchUpInside];
                    [button setImage:[UIImage imageNamed:@"group_im.png"] forState:UIControlStateNormal];
                    label.text = LOCALIZATION(@"Message_GroupChat");
                    break;
//                case 1:
//                    [button addTarget:self action:@selector(createGroupNotification:) forControlEvents:UIControlEventTouchUpInside];
//                    [button setImage:[UIImage imageNamed:@"group_noti.png"] forState:UIControlStateNormal];
//                    label.text = @"新建通知";
//                    break;
                case 1:
                    [button addTarget:self action:@selector(createGroupMessage:) forControlEvents:UIControlEventTouchUpInside];
                    [button setImage:[UIImage imageNamed:@"group_msg.png"] forState:UIControlStateNormal];
                    label.text = LOCALIZATION(@"Message_BulkMessage");
                    break;
                case 2:
                    [button addTarget:self action:@selector(createGroupEmail:) forControlEvents:UIControlEventTouchUpInside];
                    [button setImage:[UIImage imageNamed:@"group_email.png"] forState:UIControlStateNormal];
                    label.text = LOCALIZATION(@"Message_BulkMail");
                    break;
                    
                default:
                    break;
            }
        }
    }
    [self.navigationController.view addSubview:moreFounctionView];
    ((GQNavigationController *)(self.navigationController)).canDragBack = NO;
    [UIView animateWithDuration:0.3 animations:^{
        moreFounctionView.alpha = 1;
    }];
}

-(void)hiddenMoreFounctionView
{
    ((GQNavigationController *)(self.navigationController)).canDragBack = YES;
    [UIView animateWithDuration:0.3 animations:^{
        moreFounctionView.alpha = 0;
    } completion:^(BOOL finished) {
        [moreFounctionView removeFromSuperview];
    }];
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    [self hiddenMoreFounctionView];
}


-(void)createGroupIM:(UIButton *)sender
{
    NSLog(@"发起群聊");
    [self handleCreateGroupWithName:LOCALIZATION(@"Message_TempChat")];
    [self hiddenMoreFounctionView];
//    UITextField *textField =[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 250, 30)];
//    textField.borderStyle=UITextBorderStyleRoundedRect;
//    textField.delegate =self;
//    textField.returnKeyType =UIReturnKeyDone;
//    CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"请输入群组名称！"  contentView:textField cancelButtonTitle:nil];
//    alertView.keyboardHeight = 216;
//    [textField becomeFirstResponder];
//    alertView.showBlurBackground = NO;
//    [alertView addButtonWithTitle:@"取消"
//                             type:CXAlertViewButtonTypeDefault
//                          handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
//                              [alertView dismiss];
//                              [textField resignFirstResponder];
//                              
//                          }];
//    [alertView addButtonWithTitle:@"好"
//                             type:CXAlertViewButtonTypeCancel
//                          handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
//                              [alertView dismiss];
//                              [textField resignFirstResponder];
//                              if (textField.text && textField.text.length>0) {
//                                  [self handleCreateGroupWithName:textField.text];
//                                  
//                              }
//                              
//                          }];
//    
//    self.createGroupChatAlertView =alertView;
//    [self.createGroupChatAlertView show];
}

//-(void)createGroupNotification:(UIButton *)sender
//{
//    SelectEnterpriseUserViewController *selectUserVC =[[SelectEnterpriseUserViewController alloc] init];
//    //    selectUserVC.groupName = groupName;
//    selectUserVC.selectGroupUsers = YES;
//    [selectUserVC setSelectBlock:^(NSArray *responseArray){
//        CreatNotiViewController *vc = [[CreatNotiViewController alloc] init];
//        [vc.userArray addObjectsFromArray:responseArray];
//        [self.navigationController pushViewController:vc animated:YES];
//    }];
//    GQNavigationController *selectUserVCNav =[[GQNavigationController alloc] initWithRootViewController:selectUserVC];
//    [self presentViewController:selectUserVCNav animated:YES completion:^{
//        [self hiddenMoreFounctionView];
//    }];
//    NSLog(@"新建通知");
//}



#pragma mark 处理创建群组名称
-(void)handleCreateGroupWithName:(NSString*)groupName{
    SelectEnterpriseUserViewController *selectUserVC =[[SelectEnterpriseUserViewController alloc] init];
    selectUserVC.groupName =groupName;
    selectUserVC.selectGroupUsers = YES;
    selectUserVC.fromMessageList = YES;
    selectUserVC.fromChatDetail = YES;
    [selectUserVC setSelectBlock:^(NSArray *responseArray){
        //单聊的回调
        if(responseArray.count > 1)
        {
            return;
        }
        for(id model in responseArray)
        {
            if([model isKindOfClass:[MEnterpriseUser class]])
            {
                [self hiddenMoreFounctionView];
                ChatViewController *chatVC =[[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:[NSBundle mainBundle]];
                chatVC.chatUser = model;
                chatVC.isGroup =NO;
                [self.navigationController pushViewController:chatVC animated:YES];
            }
        }
    }];
    GQNavigationController *selectUserVCNav =[[GQNavigationController alloc] initWithRootViewController:selectUserVC];
    [selectUserVC setCreatGroupBlock:^(MGroup *model){
        [selectUserVCNav dismissViewControllerAnimated:YES completion:^{
            //群聊的回调
            [self hiddenMoreFounctionView];
            MGroup *group = model;
            ChatViewController *chatVC =[[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:[NSBundle mainBundle]];
            chatVC.chatGroup = group;
            chatVC.isGroup =YES;
            [self.navigationController pushViewController:chatVC animated:YES];
        }];
    }];
    [self presentViewController:selectUserVCNav animated:YES completion:^{}];
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

#pragma mark OCUCPhoneCellDelegate
-(void)sendSmsWithPhones:(NSArray*)phoneNumbers{
    
    if([MFMessageComposeViewController canSendText]){
        MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];
        messageComposeViewController.messageComposeDelegate = self;
        [messageComposeViewController setRecipients:phoneNumbers];
        [messageComposeViewController setBody:@""];
        //self.messageCompose =self.messageComposeViewController;
        [self presentViewController:messageComposeViewController animated:YES completion:nil];
        
        
    }else{
        CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"" message:LOCALIZATION(@"Message_CXAlertView_message3") cancelButtonTitle:LOCALIZATION(@"Message_CXAlertView_title3")];
        alertView.showBlurBackground = YES;
        [alertView show];
    }
}

-(void)createGroupEmail:(UIButton *)sender
{
    NSLog(@"群发邮件");
    SelectEnterpriseUserViewController *selectUserVC =[[SelectEnterpriseUserViewController alloc] init];
    //    selectUserVC.groupName = groupName;
    selectUserVC.selectGroupUsers = YES;
    selectUserVC.isGroupEmail = YES;
    
    [selectUserVC setSelectBlock:^(NSArray *responseArray){
        
        NSMutableArray *msgArray = [NSMutableArray array];
        for(id model in responseArray)
        {
            if([model isKindOfClass:[MEnterpriseUser class]])
            {
                MEnterpriseUser *user = model;
                //如果email存在
                if (user.email) {
                    [msgArray addObject:user.email];
                }
            }
        }
        [self sendEmailWithEmails:msgArray];
    }];
    
    GQNavigationController *selectUserVCNav =[[GQNavigationController alloc] initWithRootViewController:selectUserVC];
    [self presentViewController:selectUserVCNav animated:YES completion:^{
        
    }];
}

-(void)createGroupMessage:(UIButton *)sender
{
    NSLog(@"群发短信");
    
    SelectEnterpriseUserViewController *selectUserVC =[[SelectEnterpriseUserViewController alloc] init];
    //    selectUserVC.groupName = groupName;
    selectUserVC.selectGroupUsers = YES;
    selectUserVC.isGroupMessage = YES;
    [selectUserVC setSelectBlock:^(NSArray *responseArray){
        
        NSMutableArray *msgArray = [NSMutableArray array];
        for(id model in responseArray)
        {
            if([model isKindOfClass:[MEnterpriseUser class]])
            {
                MEnterpriseUser *user = model;
                if (user.mobile) {
                    [msgArray addObject:user.mobile];
                }
            }
        }
        [self sendSmsWithPhones:msgArray];
    }];
    
    GQNavigationController *selectUserVCNav =[[GQNavigationController alloc] initWithRootViewController:selectUserVC];
    [self presentViewController:selectUserVCNav animated:YES completion:^{
        [self hiddenMoreFounctionView];
    }];
}

#pragma mark OCUCMailCellDelegate
-(void)sendEmailWithEmails:(NSArray*)emails
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposeViewController =[[MFMailComposeViewController alloc] init];
        mailComposeViewController.mailComposeDelegate=self;
        [mailComposeViewController setSubject:@""];                                               //邮件主题
        [mailComposeViewController setToRecipients:emails]; //收件人
        //        [mailComposeViewController setCcRecipients:[NSArray array]];                              //抄送
        //        [mailComposeViewController setBccRecipients:[NSArray array]];                             //密送
        [mailComposeViewController setMessageBody:@"" isHTML:NO];                                 //邮件内容
        //self.mailCompose =self.mailComposeViewController;
        [self presentViewController:mailComposeViewController animated:YES completion:nil];
    }
    else
    {
         CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"" message:LOCALIZATION(@"Message_CXAlertView_message2") cancelButtonTitle:LOCALIZATION(@"Message_CXAlertView_title2")];
        alertView.showBlurBackground = YES;
        [alertView show];
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
        {
            
        }
            break;
        case MFMailComposeResultFailed:
        {
 CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"" message:LOCALIZATION(@"Message_CXAlertView_message1") cancelButtonTitle:LOCALIZATION(@"Message_CXAlertView_title1")];
            alertView.showBlurBackground = YES;
            [alertView show];
        }
            break;
        case MFMailComposeResultSent:
        {
            
        }
            break;
            
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
        {
            
        }
            break;
        case MessageComposeResultFailed:
        {
           CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"" message:LOCALIZATION(@"Message_CXAlertView_message") cancelButtonTitle:LOCALIZATION(@"Message_CXAlertView_title")];
            alertView.showBlurBackground = YES;
            [alertView show];
        }
            break;
        case MessageComposeResultSent:
        {
            
        }
            break;
            
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}


-(void)setupViews{

    for (UIView *view in [self.view subviews]) {
        [view removeFromSuperview];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.nibMessage =[UINib nibWithNibName:@"GQMessageCell" bundle:[NSBundle mainBundle]];
//    CGFloat orgin_y = 0;
//    if(CURRENT_SYS_VERSION < 7.0999999)
//    {
//        orgin_y = 64;
//    }
    self.tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, viewWithNavAndTabbar)];
    self.tbView.backgroundColor = [UIColor whiteColor];
    self.tbView.dataSource = self;
    self.tbView.delegate = self;
    [self.view addSubview:self.tbView];
    self.tbView.tableFooterView=[[UIView alloc] init];
    self.tmpSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 44)];
    self.tmpSearchBar.placeholder = LOCALIZATION(@"Message_tmpSearchBar_placeholder");
    self.tmpSearchBar.delegate = self;
    self.tbView.tableHeaderView = self.tmpSearchBar;
    UIImage *img = [UIImage createImageWithColor:[UIColor hexChangeFloat:@"f2f2f2"] size:CGSizeMake(boundsWidth, 30)];
    [self.tmpSearchBar setBackgroundImage:img];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.tmpSearchBar contentsController:appDelegate.tabbarController];
    // searchResultsDataSource 就是 UITableViewDataSource
    searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)initData
{
    resultArray = [[NSMutableArray alloc] init];
    self.notiArray = [[NSMutableArray alloc] init];
}

#pragma mark - UISearchDisplayController delegate
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    resultArray = [NSMutableArray array];
    
    if (searchString.length>0) {
        
        [self filterContentForSearchText:searchString];
        
    }
    
    return YES;
}


//消息
- (void)filterContentForSearchText:(NSString*)searchText{
    
    
    //消息搜索 sessionname是名字 msg是消息
    NSPredicate *sessionnamePredicate = [NSPredicate predicateWithFormat:@"sessionname contains [cd] %@",searchText];
    NSPredicate *msgPredicate = [NSPredicate predicateWithFormat:@"msg contains [cd] %@",searchText];
//    NSPredicate *pinyinPredicate = [NSPredicate predicateWithFormat:@"pinyin contains[cd] %@", searchText];
    
    //messagelist里面代表总共有多个聊天 -- 除了 "我的通知" 以外的聊天数
    //然后根据messaglist的每一个聊天记录的sessionid 从数据库中取出每一个聊天中的所有聊天记录
    
    NSDictionary *facemap = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"faceMap" ofType:@"plist"]];
    NSData *cssData=[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bubblechat" ofType:@"css"]];
    DTCSSStylesheet *cssSheet=[[DTCSSStylesheet alloc] initWithStyleBlock:[[NSString alloc] initWithData:cssData encoding:NSUTF8StringEncoding]];
    
    NSMutableArray *messageArray = [NSMutableArray array];
    
    for (int i=0; i<self.messageList.count; i++) {
        
        MMessage *mm =[self.messageList objectAtIndex:i];//
        
        NSArray *messages =[[SQLiteManager sharedInstance]getPrivateMessagesWithKeyId:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]] sessionId:mm.sessionid faceMap:facemap cssSheet:cssSheet offset:0 limit:-1];
        
        [messageArray addObjectsFromArray:messages];
        
    }
    
    
    //搜索messagelist里面 -- 当前messagelist里面的
    //sessionname中了关键字 -- 名字中包含搜索的字 只显示最后一条聊天消息 其余的相同名字的聊天消息都去掉
    NSArray *sessionArrray = [messageArray filteredArrayUsingPredicate:sessionnamePredicate];
    NSMutableArray *useArray = [NSMutableArray array];
    
    if (sessionArrray.count>0) {
        
       [useArray addObject:[sessionArrray lastObject]];
        
        NSString *sessionname = [[sessionArrray lastObject] sessionname];
        
        for (int i = 0; i<sessionArrray.count-1; i++) {
            
            if (![sessionname isEqualToString:[sessionArrray[i] sessionname]]) {
                
                [useArray addObject:[sessionArrray[i] sessionname]];
                
                sessionname = [sessionArrray[i] sessionname];
                
            }
        }
    }
    
    //msg中了关键字
    NSArray *msgArray = [messageArray filteredArrayUsingPredicate:msgPredicate];
    //拼音中了关键字
//    NSArray *pinyinArray = [messageArray filteredArrayUsingPredicate:pinyinPredicate];
    
    [resultArray addObjectsFromArray:useArray];
    [resultArray addObjectsFromArray:msgArray];
//    [resultArray addObject:pinyinArray];
    
    
    //拼音搜索
//    if([resultArray count] == 0)
//    {
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pinyin contains[cd] %@", searchText];
//        [resultArray setArray:[self.messageList filteredArrayUsingPredicate:predicate]];
//    }
}

/**
 *  加载数据
 */
-(void)loadData{
    
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *allMessageArray =[[[SQLiteManager sharedInstance] getAllMessages] allValues];
        HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
        [outputFormat setToneType:ToneTypeWithoutTone];
        [outputFormat setVCharType:VCharTypeWithV];
        [outputFormat setCaseType:CaseTypeLowercase];
        
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        NSMutableArray *notiArr = [[NSMutableArray alloc] init];
        for (MMessage *message in allMessageArray) {
            message.pinyin=[PinyinHelper toHanyuPinyinStringWithNSString:message.sessionname withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
            
            NSString *settingkey;
            if ([[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]] isEqualToString:message.keyid]) {
                //自己发
                settingkey = message.sessionid;
            }
            else
            {
                //别人发
                settingkey = message.keyid;
            }
            message.top = [[[[[NSUserDefaults standardUserDefaults] objectForKey:SettingTopKey] objectForKey:[message.sessionid hasPrefix:@"g"]?[message.sessionid substringFromIndex:1]:settingkey] objectForKey:[message.sessionid hasPrefix:@"g"]?[message.sessionid substringFromIndex:1]:settingkey] boolValue];
            message.topTime = [[[[NSUserDefaults standardUserDefaults] objectForKey:SettingTopKey] objectForKey:[message.sessionid hasPrefix:@"g"]?[message.sessionid substringFromIndex:1]:settingkey] objectForKey:SettingTopTime];

            message.NoDisturb = [[[[NSUserDefaults standardUserDefaults] objectForKey:SettingDisturbKey] objectForKey:[message.sessionid hasPrefix:@"g"]?[message.sessionid substringFromIndex:1]:settingkey] boolValue];
            if ([message.sessionState intValue]) {
                
                //处理通知数据start
                if([message.msgOtherId isEqualToString:NotiOhterId])
                {
                    [notiArr addObject:message];
                }
                //处理通知数据end
                else
                {
                    [tempArr addObject:message];
                }
            }
        }
        
        if([notiArr count])
        {
//            [weakSelf.notiArray removeAllObjects];
            weakSelf.notiArray = nil;
            weakSelf.notiArray = [NSMutableArray array];
            NSArray *array = [notiArr sortedArrayUsingFunction:timeSort context:nil];
//            [weakSelf.notiArray setArray:array];
            [weakSelf.notiArray addObjectsFromArray:array];
        }
        else
        {
            weakSelf.notiArray = nil;
            weakSelf.notiArray = [NSMutableArray array];
            MMessage *mm=[[MMessage alloc]init];
            mm.identity =[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
            mm.msgId =[NSString stringWithUUID];
            mm.modeltype = @"3";
            mm.contenttype = @"0";
            mm.type = @"1";
            mm.sendTime =[NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970]*1000];
            mm.msg = @"";
            mm.keyid = [[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"];
            mm.username = [[ConfigManager sharedInstance].userDictionary objectForKey:@"uname"];
             mm.msgOtherName = LOCALIZATION(@"Message_myNotification");
            mm.msgOtherId = NotiOhterId;//瞎鸡巴写一个标记，哈哈
            if(mm)
            {
                [weakSelf.notiArray addObject:mm];
            }
        }
        
        //排序前
        NSArray *array = [tempArr sortedArrayUsingFunction:customSort context:nil];
        NSArray *array1 = [array sortedArrayUsingFunction:customSort1 context:nil];
        weakSelf.messageList = array1;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tbView reloadData];
            [[MessageBadge sharedManager] updateMessageBadge:MessageBadgeUpdateStatusReciveMessage userinfo:weakSelf.messageList];
        });
        
        
    });
}



NSInteger customSort(MMessage *obj1, MMessage *obj2,void* context){
    if ((int)obj1.top   < (int)obj2.top) {
        return (NSComparisonResult)NSOrderedDescending;
    }
    
    else if ((int)obj1.top   > (int)obj2.top) {
        return (NSComparisonResult)NSOrderedAscending;
    }
    else
    {
        if ([(NSString *)obj1.sendTime doubleValue] < [(NSString *)obj2.sendTime doubleValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        else if ([(NSString *)obj1.sendTime doubleValue] > [(NSString *)obj2.sendTime doubleValue])
        {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }
}

NSInteger customSort1(MMessage *obj1, MMessage *obj2,void* context){
    if (obj1.top &&(int)obj2.top) {
        if ([(NSString *)obj1.topTime doubleValue] < [(NSString *)obj2.topTime doubleValue])
        {
            //多个置顶时，随着接收新消息而变化位置（做个判断）
            if ([(NSString *)obj1.sendTime doubleValue] < [(NSString *)obj2.sendTime doubleValue]){
                
                 return (NSComparisonResult)NSOrderedDescending;
            
            }  else if ([(NSString *)obj1.sendTime doubleValue] > [(NSString *)obj2.sendTime doubleValue]){
            
               return (NSComparisonResult)NSOrderedAscending;
            
            }
            
        return (NSComparisonResult)NSOrderedDescending;
        }
    }

    return (NSComparisonResult)NSOrderedSame;
}

NSInteger timeSort(MMessage *obj1, MMessage *obj2,void* context){
    if ([(NSString *)obj1.sendTime doubleValue] < [(NSString *)obj2.sendTime doubleValue]) {
        return (NSComparisonResult)NSOrderedDescending;
    }
    else if ([(NSString *)obj1.sendTime doubleValue] > [(NSString *)obj2.sendTime doubleValue])
    {
        return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
