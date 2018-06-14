//
//  JoinEnterpriseViewController.m
//  IM
//
//  Created by ZteCloud on 15/10/12.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "JoinEnterpriseViewController.h"
#import "LoginViewController1.h"
@interface JoinEnterpriseViewController ()
{
    BOOL isCancel;
}
@end

@implementation JoinEnterpriseViewController
-(void) viewWillAppear:(BOOL)animated{
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
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=BGColor;
//    [self setUI];
    [self handleNavigationBarItem];
    if (self.tModel)
    {
        [self applyAddTenantReq];
    }
    else
    {
        [self setUI];
    }
    
}
-(void)applyAddTenantReq
{
    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"JoinEnterpriseViewController_JoinLoading") isDismissLater:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:[NSString stringWithFormat:@"%@",self.tModel.tenantId] forKey:@"tenantId"];
        [parameters setObject:[UserDefault objectForKey:@"AName"] forKey:@"name"];
        [parameters setObject:[ConFunc DESEncrypt:[UserDefault objectForKey:@"APsw"] WithKey:nil] forKey:@"password"];
        [parameters setObject:[UserDefault objectForKey:@"RPhone"] forKey:@"mobile"];
        [parameters setObject:[NSString stringWithFormat:@"%@",[UserDefault objectForKey:@"SessionId"]] forKey:@"sessionId"];
        [parameters setObject:[NSString stringWithFormat:@"%@",[UserDefault objectForKey:@"SessionKey"]]forKey:@"sessionKey"];
        
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodRegAddTenant] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
//            NSLog(@"%@",msg);
            if(success && [data isKindOfClass:[NSDictionary class]]){
//                NSLog(@"%@",data);
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"JoinEnterpriseViewController_JoinFinish") isDismissLater:YES];
                [self setUI];
                
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD showHUDWithTitle:[NSString stringWithFormat:@"%@",msg] isDismissLater:YES];
                });
            }
        } failureBlock:^(NSString *description) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"RequestFail") isDismissLater:YES];
            });
        }];
    });
}
-(void)setUI
{
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 30)];
    label1.text=[NSString stringWithFormat:@"%@",LOCALIZATION(@"JoinEnterpriseViewController_Joined")];
    label1.textColor=[UIColor grayColor];
    label1.font=[UIFont systemFontOfSize:13];
    label1.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:label1];
    UILabel *companyLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, label1.frame.origin.y+label1.frame.size.height, boundsWidth, 30)];
    companyLabel.text=(self.tModel)?[NSString stringWithFormat:@"%@",self.tModel.tenantName]:[UserDefault objectForKey:@"TenantName"];
    companyLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:companyLabel];
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(0,companyLabel.frame.origin.y+companyLabel.frame.size.height, boundsWidth, 30)];
    label2.text=[NSString stringWithFormat:@"%@",LOCALIZATION(@"JoinEnterpriseViewController_JoinWaite")];
    label2.textColor=[UIColor grayColor];
    label2.font=[UIFont systemFontOfSize:13];
    label2.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:label2];
    
    UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame=CGRectMake(EdgeDis, label2.frame.size.height+label2.frame.origin.y, boundsWidth-EdgeDis*2, 40);
    cancelBtn.backgroundColor=MainColor;
    [cancelBtn setTitle:LOCALIZATION(@"JoinEnterpriseViewController_JoinCancel") forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    cancelBtn.layer.cornerRadius=3;
    cancelBtn.layer.masksToBounds=YES;
}
#pragma mark---------cancelBtnClick
-(void)cancelBtnClick:(UIButton *)btn
{
    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"JoinEnterpriseViewController_CancelLoading") isDismissLater:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        
        [parameters setObject:[NSString stringWithFormat:@"%@",[UserDefault objectForKey:@"SessionId"]] forKey:@"sessionId"];
        
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodRegCancleTenant] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
//            NSLog(@"%@",msg);
            if(success && [data isKindOfClass:[NSDictionary class]]){
//                NSLog(@"%@",data);
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"JoinEnterpriseViewController_CancelFinish") isDismissLater:YES];
                AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
                [appDelegate gotoLoginController];
                [UserDefault removeObjectForKey:@"AName"];
                [UserDefault removeObjectForKey:@"APsw"];
                [UserDefault removeObjectForKey:@"ACPsw"];
                [UserDefault removeObjectForKey:@"RPhone"];
                [UserDefault removeObjectForKey:@"RCode"];
                isCancel=YES;
                
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD showHUDWithTitle:[NSString stringWithFormat:@"%@",msg] isDismissLater:YES];
                });
            }
        } failureBlock:^(NSString *description) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"RequestFail") isDismissLater:YES];
            });
        }];
    });
}
#pragma mark 处理导航条
-(void)handleNavigationBarItem{
    self.navigationItem.title = LOCALIZATION(@"ConnectEnterpriseViewController_NavTitle");
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
}
-(void)clickLeftItem:(id)sender{
    if (isCancel)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
        [appDelegate gotoLoginController];
        [UserDefault removeObjectForKey:@"AName"];
        [UserDefault removeObjectForKey:@"APsw"];
        [UserDefault removeObjectForKey:@"ACPsw"];
        [UserDefault removeObjectForKey:@"RPhone"];
        [UserDefault removeObjectForKey:@"RCode"];
    }
    
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

@end
