//
//  SysPwdViewController.m
//  IM
//
//  Created by 陆浩 on 15/5/4.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "SysPwdViewController.h"

@interface SysPwdViewController ()
{
    UITextField *oldPwdField;
    UITextField *newPwdField;
    UITextField *confirmPwdField;
}

@end

@implementation SysPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
    self.navigationItem.title = @"修改密码";
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];

    ILBarButtonItem *rightItem = [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_save.png"] highlightedImage:nil target:self action:@selector(clickRightItem:)];
    [self.navigationItem setRightBarButtonItem:rightItem];

    [self configureInputView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickLeftItem:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)clickRightItem:(id)sender{
    if([oldPwdField.text length] == 0)
    {
        [MMProgressHUD showHUDWithTitle:@"请输入原密码" isDismissLater:YES];
        return;
    }
    if([newPwdField.text length] == 0)
    {
        [MMProgressHUD showHUDWithTitle:@"请输入新密码" isDismissLater:YES];
        return;
    }
    if([confirmPwdField.text length] == 0)
    {
        [MMProgressHUD showHUDWithTitle:@"请输入确认密码" isDismissLater:YES];
        return;
    }
    if(![newPwdField.text isEqualToString:confirmPwdField.text])
    {
        [MMProgressHUD showHUDWithTitle:@"确认密码与新密码不一致" isDismissLater:YES];
        return;
    }

    //这边提交修改密码操作！！！！fuck
    [self sendPwdToServer];
}

#pragma mark -
#pragma mark - Configure View
-(void)configureInputView
{
    UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(-0.5, 10, boundsWidth+1, 43)];
    bgView1.backgroundColor = [UIColor whiteColor];
    bgView1.layer.borderColor = [UIColor hexChangeFloat:@"dddddd"].CGColor;
    bgView1.layer.borderWidth = 0.5;
    bgView1.userInteractionEnabled = YES;
    [self.view addSubview:bgView1];

    UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(-0.5, bgView1.frame.size.height+bgView1.frame.origin.y+10, boundsWidth+1, 86)];
    bgView2.backgroundColor = [UIColor whiteColor];
    bgView2.layer.borderColor = [UIColor hexChangeFloat:@"dddddd"].CGColor;
    bgView2.layer.borderWidth = 0.5;
    bgView2.userInteractionEnabled = YES;
    [self.view addSubview:bgView2];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, bgView2.frame.size.height/2, bgView2.frame.size.width-10, 0.5)];
    line.backgroundColor = [UIColor hexChangeFloat:@"dddddd"];
    [bgView2 addSubview:line];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 11.5, 70, 20)];
    label1.backgroundColor = [UIColor clearColor];
    label1.textAlignment = NSTextAlignmentRight;
    label1.font = [UIFont systemFontOfSize:16.0f];
    label1.text = @"原密码";
    [bgView1 addSubview:label1];
    
    oldPwdField = [[UITextField alloc] initWithFrame:CGRectMake(label1.frame.size.width+20, 6, boundsWidth-(label1.frame.size.width+20)-20, 30)];
    oldPwdField.secureTextEntry = YES;
    [bgView1 addSubview:oldPwdField];

    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 11.5, 70, 20)];
    label2.backgroundColor = [UIColor clearColor];
    label2.textAlignment = NSTextAlignmentRight;
    label2.font = [UIFont systemFontOfSize:16.0f];
    label2.text = @"新密码";
    [bgView2 addSubview:label2];
    
    newPwdField = [[UITextField alloc] initWithFrame:CGRectMake(label2.frame.size.width+20, 6, boundsWidth-(label2.frame.size.width+20)-20, 30)];
    newPwdField.secureTextEntry = YES;
    [bgView2 addSubview:newPwdField];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 11.5+43, 70, 20)];
    label3.backgroundColor = [UIColor clearColor];
    label3.textAlignment = NSTextAlignmentRight;
    label3.font = [UIFont systemFontOfSize:16.0f];
    label3.text = @"确认密码";
    [bgView2 addSubview:label3];
    
    confirmPwdField = [[UITextField alloc] initWithFrame:CGRectMake(label3.frame.size.width+20, 6+43, boundsWidth-(label3.frame.size.width+20)-20, 30)];
    confirmPwdField.secureTextEntry = YES;
    [bgView2 addSubview:confirmPwdField];
}

#pragma mark -
#pragma mark - Change PWD Events
-(void)sendPwdToServer
{
    [MMProgressHUD showHUDWithTitle:@"正在修改..." isDismissLater:NO];
    
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //判断是否已登录
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:[ConFunc DESEncrypt:oldPwdField.text WithKey:nil] forKey:@"oldPwd"];
        [parameters setObject:[ConFunc DESEncrypt:newPwdField.text WithKey:nil] forKey:@"newPwd"];
        [parameters setObject:[ConFunc DESEncrypt:confirmPwdField.text WithKey:nil] forKey:@"chkPwd"];
        [parameters setObject:[[ConfigManager sharedInstance].userDictionary  objectForKey:@"token"] forKey:@"token"];
        
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodChangePwd] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
            if(success && [data isKindOfClass:[NSDictionary class]]){
                [ConfigManager sharedInstance].isLogin=YES;
                NSDictionary *initDic = [ConfigManager sharedInstance].loginDictionary;
                NSDictionary *loginDictionary =[NSDictionary dictionaryWithObjectsAndKeys:[initDic objectForKey:@"enterpriseNo"],@"enterpriseNo",[initDic objectForKey:@"accountNo"],@"accountNo",newPwdField.text,@"passwordNo",[initDic objectForKey:@"isAutoLogin"],@"isAutoLogin",[initDic objectForKey:@"isRememberPassword"],@"isRememberPassword", nil];
                [ConfigManager sharedInstance].loginDictionary =loginDictionary;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD showHUDWithTitle:@"修改成功！" isDismissLater:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD dismiss];
                    CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"修改失败" message:msg cancelButtonTitle:@"确认"];
                    alertView.showBlurBackground = YES;
                    [alertView show];
                });
            }
        } failureBlock:^(NSString *description) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MMProgressHUD dismiss];
                CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"修改失败" message:description cancelButtonTitle:@"确认"];
                alertView.showBlurBackground = YES;
                [alertView show];
            });
            
        }];
    });
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
