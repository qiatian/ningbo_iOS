//
//  ZTEDiscvoerViewController.m
//  IM
//
//  Created by 周永 on 15/11/6.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "ZTEDiscvoerViewController.h"
#import "ZTESettingViewController.h"
#import "ZTESettingDetailController.h"
#import "ZTEPersonalProfileController.h"
#import "EditUserInfoViewController.h"
#import "ZTESalaryViewController.h"
#import "SGAlertController.h"
#import "ZTEUserProfileTools.h"
#import "UIImageView+WebCache.h"
#import "UserHeaderCell.h"
#import <MessageUI/MessageUI.h>

@interface ZTEDiscvoerViewController ()<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UITableView  *tableView;

@property (nonatomic, strong) NSDictionary *titleDict;      //cell标题字典

@property (nonatomic, strong) NSDictionary *imageNameDict;  //图片名称字典

@property (nonatomic, strong) SGAlertController *shareViewController;

@end

@implementation ZTEDiscvoerViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    _titleDict = @{
                   @"1":@[@"discover_salary",@"discover_feedback"],
                   @"2":@[@"discover_setting"]
                   };
    
    _imageNameDict = @{
                       @"1":@[@"mysalary.png",@"feedBack.png"],
                       @"2":@[@"setting.png"]
                       };
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLanguageChangedNotification:)
                                                 name:kNotificationLanguageChanged
                                               object:nil];
    
    [self configureUI];
    
}

- (void)receiveLanguageChangedNotification:(NSNotification*)notif{
    
    [Localisator sharedInstance].saveInUserDefaults = YES;
    
    if ([notif.name isEqualToString:kNotificationLanguageChanged])
    {
        [self titleSetting];
        [self.tableView reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self titleSetting];
//    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
//    [appDelegate tabbarController].navigationItem.title = self.tabBarItem.title;
    
    [self.tableView reloadData];
}

- (void)titleSetting{
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate tabbarController].navigationItem.title = LOCALIZATION(self.tabBarItem.title);
    [[appDelegate tabbarController].navigationItem setRightBarButtonItem:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (void)configureUI{

    //防止tableview被导航栏挡住
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"7.0" options: NSNumericSearch];
    if (order == NSOrderedSame || order == NSOrderedDescending)
    {
        // OS version >= 7.0
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //tableview分割线左侧短一部分
//    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableView.sectionHeaderHeight = 100.0;
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
    
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1 + _titleDict.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1) {
        return 2;
    }
    
    return 1;
}

////@"discover_workCircle.png",@"discover_store.png",@"discover_scane.png",@"discover_leader.png",@"discover_appStrore.png"

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Cell";
    static NSString *headerCellUseId = @"headerCell";
    
    if (indexPath.section == 0) {
        
        UserHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:headerCellUseId];
        
        if (!cell) {
            cell = [[UserHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headerCellUseId];
        }
        
        NSString *bigPicUrl = [ConfigManager sharedInstance].userDictionary[@"bigpicurl"];
        
        [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:bigPicUrl] placeholderImage:[UIImage imageNamed:@"default_head"]];
        
        NSString *name = [ConfigManager sharedInstance].userDictionary[kZTEPersonalProfileName];
        NSString *mobile = [ConfigManager sharedInstance].userDictionary[kZTEPersonalProfileMobile];
        NSString *company = [ConfigManager sharedInstance].userDictionary[kZTEPersonalProfileCompany];
        NSString *dept = [ConfigManager sharedInstance].userDictionary[kZTEPersonalProfileDepartment];
        
        NSString *titleString = [NSString stringWithFormat:@"%@  %@",name,mobile];
        cell.titleLabel.text = titleString?titleString:@"";
        
        NSString *bottomString = [NSString stringWithFormat:@"%@  %@",company,dept];
        cell.autograpLabel.text = bottomString?bottomString:@"";
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *key = [NSString stringWithFormat:@"%d",indexPath.section];
        
        NSString *text = LOCALIZATION(_titleDict[key][indexPath.row]);
        
        NSString *imageName = _imageNameDict[key][indexPath.row];
        cell.imageView.image = [UIImage imageNamed:imageName];
            
        cell.textLabel.text = text?text:@"";
        
        return cell;
    }
}


#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 80;
    }
    
    return 44;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    switch ((int)indexPath.section) {
        case 0: //测试
        {
            ZTEPersonalProfileController *personalProfileVC = [[ZTEPersonalProfileController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:personalProfileVC animated:YES];
            
        }
            break;
        case 1://我的工资
        {
            if (indexPath.row == 0) {
                //跳转到工资界面
                ZTESalaryViewController *salaryVC = [[ZTESalaryViewController alloc] init];
                [self.navigationController pushViewController:salaryVC animated:YES];
            }else{
                
                ZTESettingDetailController *settingDetailVC = [[ZTESettingDetailController alloc] initWithStyle:UITableViewStyleGrouped];
                settingDetailVC.title = LOCALIZATION(@"discover_feedback");
                settingDetailVC.detailTitle = ZTESettingDetailTitleFeedback;
                
                [self.navigationController pushViewController:settingDetailVC animated:YES];
                
            }
            
        }
            break;
        case 2:{//设置
            ZTESettingViewController *settingVC = [[ZTESettingViewController alloc]init];
            [self.navigationController pushViewController:settingVC animated:YES];
        }
            break;
        default:
            break;
    }
    
    
}

#pragma mark - private method

//点击推荐弹出分享框
- (void)showShareViewController{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        _shareViewController = [[SGAlertController alloc] initWithTitle:LOCALIZATION(@"dis_rec_title") CancelTitle:LOCALIZATION(@"discover_cancel")];
        
//        [alert setMailShareImage:[UIImage imageNamed:@"email"] messsageShareImage:[UIImage imageNamed:@"message"]];
        /**
         * 设置按钮事件block
         */
        
        __block ZTEDiscvoerViewController *blockSelf = self;
        
        [_shareViewController setMailShareHandler:^{
            
            [blockSelf showEmailShare];
            
        } messageShareHandler:^{
            
            [blockSelf showMessageShare];
            
        }];
        
        [self presentViewController:_shareViewController animated:YES completion:nil];
    });
    
    
    
}

//短信分享
- (void)showMessageShare{
    
    NSString *link = @"http://123.58.34.116:8088/download/ImClientNingbo.apk";
    
    [self showMessageView:[NSArray array] title:@"" body:[NSString stringWithFormat:@"%@ %@",LOCALIZATION(@"share_info"),link]];
    
}

//邮件分享
- (void)showEmailShare{
    
    NSString *link = @"http://123.58.34.116:8088/download/ImClientNingbo.apk";
    
    [self showMailView:[NSArray array] title:@"" body:[NSString stringWithFormat:@"%@ %@",LOCALIZATION(@"share_info"),link]];
    
}

#pragma mark - message & email delegate


-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"msg_success_send") isDismissLater:YES];
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"msg_failed_send") isDismissLater:YES];
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"msg_cancel") isDismissLater:YES];
            break;
        default:
            break;
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error{
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    
    switch (result) {
        case MFMailComposeResultCancelled: {
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"email_cancel") isDismissLater:YES];
            break;
        }
        case MFMailComposeResultSaved: {
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"email_saved") isDismissLater:YES];
            break;
        }
        case MFMailComposeResultSent: {
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"email_send") isDismissLater:YES];
            break;
        }
        case MFMailComposeResultFailed: {
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"emial_failed") isDismissLater:YES];
            break;
        }
        default: {
            break;
        }
    }
    
}

#pragma mark - send message & email
//发送邮件

-(void)showMailView:(NSArray *)phones title:(NSString *)title body:(NSString *)body{
    
    [_shareViewController dismissViewControllerAnimated:YES completion:nil];
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController * controller = [[MFMailComposeViewController alloc] init];
        controller.navigationBar.tintColor = [UIColor redColor];
        [controller setMessageBody:body isHTML:NO];
        controller.mailComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        
    }
    else
    {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"emile_not_support") isDismissLater:YES];
        
    }
    
}


//发送短信
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    
    [_shareViewController dismissViewControllerAnimated:YES completion:nil];
    
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"msg_not_support") isDismissLater:YES];
        
    }
}




@end
