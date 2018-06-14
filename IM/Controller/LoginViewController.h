//
//  LoginViewController.h
//  IM
//
//  Created by zuo guoqing on 14-9-11.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "MMProgressHUD.h"
#import "GQTouchScrollView.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate,GQTouchScrollViewDelegate>
{
    UITextField         *enterpriseTF;
    UITextField         *accountTF;
    UITextField         *passwordTF;
    
    UIButton            *rememberPassBtn, *autoLoginBtn;
    UIButton            *loginBtn;
    UIScrollView        *scView;
    GQTouchScrollView   *mainScrollView;
    UIImageView         *logoView;
}


@property(nonatomic,strong)NSString *defaultEnterpriseNo;
@property(nonatomic,strong)NSString *defaultAccountNo;
@property(nonatomic,strong)NSString *defaulPasswordNo;
@property(nonatomic)BOOL isAutoLogin;
@property(nonatomic)BOOL isRememberPassword;

-(void)handleEnterpriseNo:(NSString*)enterpriseNo accountNo:(NSString*)accountNo passwordNo:(NSString*)passwordNo isAutoLogin:(BOOL)isAutoLogin isRememberPassword:(BOOL)isRememberPassword;
-(void)handleEnterpriseContactWithData:(NSDictionary *)data;
@end
