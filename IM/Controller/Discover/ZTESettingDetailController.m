//
//  ZTESettingDetailController.m
//  Discover
//
//  Created by 周永 on 15/11/6.
//  Copyright © 2015年 shuige. All rights reserved.
//

#import "ZTESettingDetailController.h"
#import "UITextView+Placeholder.h"
#import "ZTEUserProfileTools.h"
#import "Masonry.h"
#import "SettingDetailCell.h"

#import "PIGuideView.h"
#import  "AppDelegate.h"

@interface ZTESettingDetailController ()<UITextViewDelegate>

@property (nonatomic, strong) NSArray        *dataArray;
@property (nonatomic, strong) UITextView     *feedbackInputTextView;
@property (nonatomic, strong) UILabel        *placeholderLabel;
@property (nonatomic, copy  ) NSString       *feedbackText;
@property (nonatomic, strong) NSMutableArray *passwordTextFieldsArray;
@end

@implementation ZTESettingDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    _dataArray = [self getDataArray];
    
    _passwordTextFieldsArray = [NSMutableArray array];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseId = @"Cell";
    
    SettingDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (!cell) {
        
        cell = [[SettingDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    [self configureMessageCell:cell AtIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableView Delegate


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (_detailTitle == ZTESettingDetailTitleAbout) {
        return 150.0;
    }
    
    return 10.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (_detailTitle == ZTESettingDetailTitleFeedback) {
        return 150.0;
    }
    
    if (_detailTitle == ZTESettingDetailTitleAbout) {
        //footerview的高度是 : 总高度-headerview高度-n*cell高度 + tabbar高度
        CGFloat height = self.view.frame.size.height - 150.0 - _dataArray.count * 44 - 64 + 44;
        return height;
    }
    
    return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] init];
    
    if (_detailTitle == ZTESettingDetailTitleAbout) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"day"];
        [headerView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(headerView);
        }];
    }
    
    return headerView;
}


- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView = [[UIView alloc] init];
    
    //设置反馈页面的footerview
    if (_detailTitle == ZTESettingDetailTitleFeedback) {
        
        _feedbackInputTextView = [[UITextView alloc] initWithPlaceholder:LOCALIZATION(@"dis_feedback_content")];
//        _feedbackInputTextView.delegate = self;
        [footerView addSubview:_feedbackInputTextView];
        
        [_feedbackInputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(footerView).with.insets(UIEdgeInsetsMake(10, 0, 10, 0));
        }];
        
//        [self initPlaceholderLabelForTextView];
        
    }
    
    //设置 “关于我们” 页面的footerview
    if (_detailTitle == ZTESettingDetailTitleAbout) {
        
        UILabel *englishInfoLabel = [[UILabel alloc] init];
        englishInfoLabel.text = @"Copyright © 2014-2015 ZTECloud All Rights Reserved";
        englishInfoLabel.font = [UIFont systemFontOfSize:10.0];
        englishInfoLabel.textAlignment = NSTextAlignmentCenter;
        [footerView addSubview:englishInfoLabel];
        
        [englishInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footerView.mas_left).with.offset(10);
            make.right.equalTo(footerView.mas_right).with.offset(-10);
            make.bottom.equalTo(footerView.mas_bottom);
            make.height.equalTo(@(30.0));
        }];
        
        UILabel *chineseInfoLabel = [[UILabel alloc] init];
        chineseInfoLabel.text = @"中兴云服务有限公司 版权所有";
        chineseInfoLabel.textAlignment = NSTextAlignmentCenter;
        chineseInfoLabel.font = [UIFont systemFontOfSize:15.0];
        [footerView addSubview:chineseInfoLabel];
        
        [chineseInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footerView.mas_left).with.offset(50);
            make.right.equalTo(footerView.mas_right).with.offset(-50);
            make.bottom.equalTo(englishInfoLabel.mas_top).with.offset(10);
            make.height.equalTo(@(30.0));
        }];
        
    }
    
    return footerView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    switch (_detailTitle) {
            
        case ZTESettingDetailTitleMessage: {
            
            break;
        }
        case ZTESettingDetailTitleFont: {
            
            if (indexPath.row == 0) {
                [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:10.0] forKey:@"chatFont"];
                
            }
            if (indexPath.row == 1) {
                [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:14.0] forKey:@"chatFont"];
            }
            
            if (indexPath.row == 2) {
                [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:18.0] forKey:@"chatFont"];
            }
            
            if (indexPath.row == 3) {
                [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:22.0] forKey:@"chatFont"];
            }
            

            [self setCheckImageForCell:indexPath];

            break;
        }
        case ZTESettingDetailTitlePassword: {
            
            break;
        }
        case ZTESettingDetailTitleUpate: {
            
            break;
        }
        case ZTESettingDetailTitleFeedback: {
            //清除未选中cell图片
            [self clearFeedbackCellExceptRowAtIndexpath:indexPath];
            //设置反馈文字
            NSString *string = LOCALIZATION(_dataArray[indexPath.row]);
            _feedbackInputTextView.text = LOCALIZATION(string);
            _feedbackInputTextView.placeholder = @"";
            break;
        }
        case ZTESettingDetailTitleAbout: {
            [self aboutPageCellDidSelectRowAtIndexPath:indexPath];
            break;
        }
        default: {
            break;
        }
    }

}

- (void)setCheckImageForCell:(NSIndexPath*)indexPath{
    
    NSIndexPath *allIndexPath ;
    
    for (int i = 0 ; i < self.dataArray.count; i++) {
        
        allIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:allIndexPath];
        
        if (indexPath.row == allIndexPath.row) {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    
}

#pragma mark - clear cell
//清楚未选择的cell的图片到未选择状态
- (void)clearFeedbackCellExceptRowAtIndexpath:(NSIndexPath*)indexPath{
    
    
    for (int i = 0; i< _dataArray.count; i++) {
        //得到当前选中的cell
        SettingDetailCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (i == indexPath.row) {
            cell.CheckImageView.image = [UIImage imageNamed:@"select_d"];
        }else{
            cell.CheckImageView.image = [UIImage imageNamed:@"select_no_d"];
        }
        
    }
    
}

#pragma mark - configure detail cell

//根据当前页面设置cell
- (void)configureMessageCell:(SettingDetailCell*)cell AtIndexPath:(NSIndexPath*)indexPath{
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (self.detailTitle) {
        case ZTESettingDetailTitleMessage://消息
            cell.textLabel.text = LOCALIZATION(_dataArray[indexPath.row]);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 0) {
                NSString * shockStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"shock"];
                if (!shockStr) {
                    // 默认开启
                    cell.setSwitch.on = YES;
                }
                else{
                    if ([shockStr isEqualToString:@"0"]) {
                        cell.setSwitch.on = NO;
                    }
                    else{
                        cell.setSwitch.on = YES;
                    }
                }
                
            }else{
                
                NSString * soundStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"sound"];
                if (!soundStr) {
                    // 默认开启
                    cell.setSwitch.on = YES;
                }
                else{
                    if ([soundStr isEqualToString:@"0"]) {
                        cell.setSwitch.on = NO;
                    }
                    else{
                        cell.setSwitch.on =YES;
                    }
                }
            cell.setSwitch.tag = indexPath.row ;
            }
            break;
        case ZTESettingDetailTitleFont:{//字体
            cell.textLabel.text = LOCALIZATION(_dataArray[indexPath.row]);
            //根据row来设置字体大小，有需求可以替换成switch语句单独设置
            cell.textLabel.font = [UIFont systemFontOfSize:(10 + 4 *indexPath.row)];
            NSNumber *font      = [[NSUserDefaults standardUserDefaults] valueForKey:@"chatFont"];
            
            if (!font) {
                font = @(14.0);
            }
            
            NSInteger row = (font.intValue - 10)/4;
            if (indexPath.row == row) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    
            break;
        case ZTESettingDetailTitlePassword://密码
            cell.titleString = LOCALIZATION(_dataArray[indexPath.row]); //必须先赋值titleString
            if (indexPath.row == 0) {
                [cell.passwordTxt becomeFirstResponder];
            }
            cell.passwordTxt.placeholder = @""; //触发一下get方法
            [_passwordTextFieldsArray addObject:cell.passwordTxt];
            break;
        case ZTESettingDetailTitleUpate://更新
            break;
        case ZTESettingDetailTitleFeedback://反馈
            cell.textLabel.text = LOCALIZATION(_dataArray[indexPath.row]);
            cell.CheckImageView.image = [UIImage imageNamed:@"select_no_d"];
            break;
        case ZTESettingDetailTitleAbout://关于我们
            self.tableView.scrollEnabled = NO;
            cell.textLabel.text = LOCALIZATION(_dataArray[indexPath.row]);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        default:
            break;
    }
    
    
    
}
/*
 *“关于我们” 界面cell选中时调用
 */
- (void)aboutPageCellDidSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    
    switch (indexPath.row) {
        case 0:   //欢迎页
        {
            /*
             后期要修改
             */
            PIGuideView *guideView = [[PIGuideView alloc] init];
            self.view = guideView;
        }
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        default:
            break;
    }
    
    
}

/*
 *“反馈” 界面cell选中时调用
 */
- (void)feedbackPageCellDidSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    
    _feedbackText = LOCALIZATION(_dataArray[indexPath.row]);
    
    [_feedbackInputTextView becomeFirstResponder];
    
    _feedbackInputTextView.text = _feedbackText;
    
}




#pragma mark - getter & setter
//初始化数据数组
- (NSArray*)getDataArray{
    
    NSMutableArray *array = [NSMutableArray array];
    
    switch (_detailTitle) {
            
        case ZTESettingDetailTitleMessage:{
            [array addObjectsFromArray:@[@"dis_noti_shack",@"dis_noti_voice"]];
        }
            break;
            
        case ZTESettingDetailTitleFont:{
            [array addObjectsFromArray:@[@"dis_font_small",@"dis_font_middle",@"dis_font_big",@"dis_font_super"]];
        }
            break;
            
        case ZTESettingDetailTitlePassword:{
            [array addObjectsFromArray:@[@"dis_psw_orig",@"dis_psw_new",@"dis_psw_confirm"]];
        }
            break;
        case ZTESettingDetailTitleFeedback:{
            
            [array addObjectsFromArray:@[@"dis_feedback_bug",@"dis_feedback_bad",@"dis_feedback_exper",@"dis_feedback_slow",@"dis_feedback_other"]];
        }
            break;
        case ZTESettingDetailTitleAbout:{
            [array addObjectsFromArray:@[@"dis_about_welcome",@"dis_about_func",@"dis_about_sysnoti"]];
        }
            break;
        default:
            return nil;
            break;
    }
    
    
    if (_detailTitle == ZTESettingDetailTitleFeedback || _detailTitle == ZTESettingDetailTitlePassword) {
        
        UIButton *checkButton = [[UIButton alloc] init];
        [checkButton setBackgroundImage:[UIImage imageNamed:@"nav_save"] forState:UIControlStateNormal];
        [checkButton addTarget:self action:@selector(commitData) forControlEvents:UIControlEventTouchUpInside];
        [checkButton sizeToFit];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:checkButton];
        
    }
    
    return array;
    
}


#pragma mark - private method

//提交数据
- (void)commitData{
    
    
    if (_detailTitle == ZTESettingDetailTitleFeedback) {  //提交反馈数据
        
        [self sendFeedbackToServer];
        
    }
    
    if (_detailTitle == ZTESettingDetailTitlePassword) {    //提交密码数据
        
        NSString *orignalPassword;
        NSString *newPassword;
        NSString *confirmNewPassword;
        
        UITextField *textField = _passwordTextFieldsArray[0];
        if (textField.text.length > 0) {
            orignalPassword = textField.text;
        }else{
            orignalPassword = @"";
        }
        
        textField = _passwordTextFieldsArray[1];
        
        if (textField.text.length > 0) {
            newPassword = textField.text;
        }else{
            newPassword = @"";
        }
        
        textField = _passwordTextFieldsArray[2];
        
        if (textField.text.length > 0) {
            confirmNewPassword = textField.text;
        }else{
            confirmNewPassword = @"";
        }
        
        //判断密码是否有效
        if (orignalPassword.length !=0 && newPassword.length !=0 && confirmNewPassword.length != 0) {
            
           
            if ([newPassword isEqualToString:confirmNewPassword]) {
                
                
                [self setupNewPassword:newPassword withcheckPassword:confirmNewPassword orignalPassword:orignalPassword];
                
                
            }else{
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"psw_notmatch") isDismissLater:YES];
            }
            
        }else{
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"info_incomplete") isDismissLater:YES];
        }
        
    }
    
}
/**
 *  发送意见反馈
 */
-(void)sendFeedbackToServer{
    //发送意见反馈
    if([_feedbackInputTextView.text length] == 0)
    {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"pls_input") isDismissLater:YES];
        return;
    }
    if([_feedbackInputTextView.text length] > 500)
    {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"dis_feedback_content") isDismissLater:YES];
        return;
    }
    
    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"committing") isDismissLater:NO];
    
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //判断是否已登录
        CGRect rect_screen = [[UIScreen mainScreen]bounds];
        CGSize size_screen = rect_screen.size;
        CGFloat scale_screen = [UIScreen mainScreen].scale;
        
        int width = size_screen.width*scale_screen;
        int height = size_screen.height*scale_screen;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *timeStr = [formatter stringFromDate:[NSDate date]];
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:[[ConfigManager sharedInstance].userDictionary objectForKey:@"name"] forKey:@"name"];
        [parameters setObject:[[ConfigManager sharedInstance].userDictionary objectForKey:@"mob"] forKey:@"mobile"];
        [parameters setObject:@"user" forKey:@"type"];
        [parameters setObject:[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"] forKey:@"token"];
        [parameters setObject:timeStr forKey:@"time"];
        [parameters setObject:[NSString stringWithFormat:@"%d*%d",width,height] forKey:@"resolution"];
        [parameters setObject:[UIDevice currentDevice].model forKey:@"device"];
        
        [parameters setObject:[NSString stringWithFormat:@"%@",_feedbackInputTextView.text] forKey:@"content"];
        
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodSaveFeedback] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
            if(success && [data isKindOfClass:[NSDictionary class]]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"success_commit") isDismissLater:YES];
                    _feedbackInputTextView.text = nil;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"failed_commit") isDismissLater:YES];
                });
            }
        } failureBlock:^(NSString *description) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"failed_commit") isDismissLater:YES];
            });
        }];
    });
}

//更新密码
-(void)setupNewPassword:(NSString*)newPassword withcheckPassword:(NSString*)checkPassword orignalPassword:(NSString*)orignalPassword{
    
    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"setting_psw") isDismissLater:NO];
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        
        [parameters setObject:[ConFunc DESEncrypt:newPassword WithKey:nil] forKey:@"newPwd"];
        [parameters setObject:[ConFunc DESEncrypt:checkPassword WithKey:nil] forKey:@"chkPwd"];
        [parameters setObject:[ConFunc DESEncrypt:orignalPassword WithKey:nil] forKey:@"oldPwd"];
        [parameters setObject:[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"] forKey:@"token"];
        
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodModifyPassword] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
            NSLog(@"%@",msg);
            if(success && [data isKindOfClass:[NSDictionary class]]){
                NSLog(@"%@",data);
                [MMProgressHUD showHUDWithTitle:data[@"res"][@"resMessage"] isDismissLater:YES];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD showHUDWithTitle:msg isDismissLater:YES];
                });
            }
        } failureBlock:^(NSString *description) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"network_failed") isDismissLater:YES];
            });
        }];
    });
}


@end




























