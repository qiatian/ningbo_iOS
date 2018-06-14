//
//  SGSettingViewController.m
//  Discover
//
//  Created by 周永 on 15/11/5.
//  Copyright © 2015年 shuige. All rights reserved.
//

#import "ZTESettingViewController.h"
#import "ZTESettingDetailController.h"
#import "UITextView+Placeholder.h"
#import "AppDelegate.h"
#import "ZTEBoardNotificationDataSource.h"

#define EdgeDis    8
#define ForceUpdateTag 100000

@interface ZTESettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>{
    NSString *downloadUrl;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray     *titleArray;
@property (nonatomic, strong) NSArray   *languageArray;

//要切换语言的控件
@property (nonatomic, strong) UILabel  *versionLabel;
@property (nonatomic, strong) UIButton *exitButton;

@end

@implementation ZTESettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed = YES;
    
    _titleArray = @[@"discover_notification",@"discover_font",@"discover_password",@"discover_lan",@"discover_update"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLanguageChangedNotification:)
                                                 name:kNotificationLanguageChanged
                                               object:nil];
    
    
    _languageArray = [Localisator sharedInstance].availableLanguagesArray;
    
    [self configureUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)configureUI{
    
    
    [self configureLocalizationString];
    
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    
}

- (void)configureLocalizationString{
    
    self.navigationItem.title = LOCALIZATION(@"discover_setting");
    
}

- (void)backToPrePage{
    
    _versionLabel.text = LOCALIZATION(@"dis_update_noti");
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - UITableViewDatasource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _titleArray.count;
    
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = LOCALIZATION(_titleArray[indexPath.row]);
    
    return cell;
}


#pragma mark - UITableViewDeleagte

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 100.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0;
    
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView = [[UIView alloc]init];
    
//    footerView.backgroundColor = [UIColor redColor];
    //版本label
    _versionLabel = [[UILabel alloc] init];
    _versionLabel.frame = CGRectMake(EdgeDis,2 * EdgeDis, self.view.frame.size.width - 2 * EdgeDis, 20);
    _versionLabel.text = LOCALIZATION(@"dis_update_noti");
    _versionLabel.font = [UIFont systemFontOfSize:12.0];
    _versionLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:_versionLabel];
    
    //退出账号
    _exitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _exitButton.frame = CGRectMake(EdgeDis, 20 + 2 * EdgeDis ,self.view.frame.size.width - 2 * EdgeDis, 44);
    _exitButton.layer.masksToBounds = YES;
    _exitButton.layer.cornerRadius = 5.0;
    
    [_exitButton setTitle:LOCALIZATION(@"discover_exit") forState:UIControlStateNormal];
    [_exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_exitButton setBackgroundImage:[UIImage imageNamed:@"exitAndDel.png"] forState:UIControlStateNormal];
    [_exitButton addTarget:self action:@selector(exitAndDelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:_exitButton];
    
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ZTESettingDetailController *settingDetailVC = [[ZTESettingDetailController alloc] initWithStyle:UITableViewStyleGrouped];
    settingDetailVC.title = LOCALIZATION(_titleArray[indexPath.row]);
    
    switch (indexPath.row) {
        case 0://消息
            settingDetailVC.detailTitle = ZTESettingDetailTitleMessage;
            break;
        case 1://字体
            settingDetailVC.detailTitle = ZTESettingDetailTitleFont;
            break;
        case 2://密码
            settingDetailVC.detailTitle = ZTESettingDetailTitlePassword;
            break;
        case 3://切换语言 之前是意见反馈，后来变成切换语言。
            [self switchLanguage];
            
            break;
        case 4://更新
        {
            [self checkUpdate];
        }
            return;
        default:
            break;
    }
    
    if (indexPath.row != ZTESettingDetailTitleUpate) {
        [self.navigationController pushViewController:settingDetailVC animated:YES];
    }
    
}


#pragma mark - button clicked
//点击退出登录
- (void)exitAndDelBtnClick{
    
    [[ZTEUserProfileTools sharedTools] logOut];
    
}

//检查更新
- (void)checkUpdate
{
    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"checking") isDismissLater:NO];
    
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:@"ios" forKey:@"client_type"];
        [parameters setObject:[NSString stringWithFormat:@"%d",[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]integerValue]]  forKey:@"version"];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodSoftUpdate] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
            NSLog(@"%@",msg);
            if(success && [data isKindOfClass:[NSDictionary class]]){
                NSString *tipMsg = @"";
                if(data[@"software"])
                {
                    NSDictionary *dic = data[@"software"];
                    BOOL forceUpdate = [dic[@"forceUpdate"] intValue] == 1?YES:NO;
                    
                    downloadUrl = dic[@"update_url"];
                    
                    //存在，则说明有新版本
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LOCALIZATION(@"new_version") message:dic[@"updateLog"] delegate:self cancelButtonTitle:LOCALIZATION(@"discover_cancel") otherButtonTitles:LOCALIZATION(@"update_now"), nil];
                    [alert show];
                    
                    if(forceUpdate)
                    {
                        alert.tag = ForceUpdateTag;
                    }
                    [MMProgressHUD dismiss];
                }
                else
                {
                    tipMsg = @"no_update";
                    [MMProgressHUD showHUDWithTitle:LOCALIZATION(tipMsg) isDismissLater:YES];
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"failed_checkout") isDismissLater:YES];
                });
            }
        } failureBlock:^(NSString *description) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"network_failed") isDismissLater:YES];
            });
        }];
    });
}


//切换语言
- (void)switchLanguage{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:LOCALIZATION(@"discover_lan") delegate:self cancelButtonTitle:LOCALIZATION(@"discover_cancel") destructiveButtonTitle:nil otherButtonTitles:LOCALIZATION(@"dis_lan_en"),LOCALIZATION(@"dis_lan_ch"), nil];
    
    [actionSheet showInView:self.tableView];
    
}


- (void)receiveLanguageChangedNotification:(NSNotification*)notif{
    
    [Localisator sharedInstance].saveInUserDefaults = YES;
    
    if ([notif.name isEqualToString:kNotificationLanguageChanged])
    {
        [self configureLocalizationString];
        [self.tableView reloadData];
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {//英文
        
        NSString *lan = _languageArray[1];
        
        [[Localisator sharedInstance] setLanguage:lan];
        
    }
    
    if (buttonIndex == 1) {//中文
        
        NSString *lan = _languageArray[2];
        
        [[Localisator sharedInstance] setLanguage:lan];
        
    }
    
    self.indexBtn = buttonIndex + 1;
    NSString * indexStr = [NSString stringWithFormat:@"%d",self.indexBtn];
    [[NSUserDefaults standardUserDefaults]setValue:indexStr forKey:@"index"];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (1 == buttonIndex) {
        
        NSURL *url = [NSURL URLWithString:downloadUrl];
        [[UIApplication sharedApplication] openURL:url];
    }
    //    else
    //    {
    //        if(alertView.tag == ForceUpdateTag)
    //        {
    //            exit(0);
    //        }
    //    }
}


@end
















