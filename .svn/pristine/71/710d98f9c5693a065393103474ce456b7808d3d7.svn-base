//
//  LoginViewController.m
//  IM
//
//  Created by zuo guoqing on 14-9-11.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "LoginViewController.h"
#import "MQTTManager.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"LoginViewController dealloc");
}

- (void)showMoreAccounts
{
    scView.hidden = !scView.hidden;
}

#pragma mark GQTouchScrollViewDelegate
-(void)touchEndWithPoint:(CGPoint)point{
    [enterpriseTF resignFirstResponder];
    [accountTF resignFirstResponder];
    [passwordTF resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImageView.image = [UIImage imageNamed:@"loginBG.png"];
    [self.view addSubview:bgImageView];
    
    
    mainScrollView =[[GQTouchScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [mainScrollView setM_delegate:self];
    [self.view addSubview:mainScrollView];
    
    mainScrollView.backgroundColor = [UIColor clearColor];
    logoView = [[UIImageView alloc] initWithFrame:CGRectMake((boundsWidth-90)/2, 50, 90, 90)];
    logoView.image = [UIImage imageNamed:@"Icon-72.png"];
    logoView.layer.borderColor = [UIColor whiteColor].CGColor;
    logoView.layer.borderWidth = 2.0f;
    logoView.layer.masksToBounds = YES;
    logoView.layer.cornerRadius = 10;
    logoView.hidden =NO;
    [mainScrollView addSubview:logoView];
    
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    v.backgroundColor = [UIColor clearColor];
    enterpriseTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 160, boundsWidth-40, 40)];
    enterpriseTF.delegate = self;
    enterpriseTF.layer.borderWidth = 1;
    enterpriseTF.layer.borderColor = [[UIColor whiteColor] CGColor];
    enterpriseTF.backgroundColor = [UIColor clearColor];
    enterpriseTF.placeholder = @"企业ID";
    enterpriseTF.leftView = v;
    enterpriseTF.textColor = [UIColor whiteColor];
    enterpriseTF.leftViewMode = UITextFieldViewModeAlways;
    enterpriseTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [enterpriseTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [mainScrollView addSubview:enterpriseTF];
    
    v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    v.backgroundColor = [UIColor clearColor];
    accountTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 210, boundsWidth-40, 40)];
    accountTF.delegate = self;
    accountTF.backgroundColor = [UIColor clearColor];
    accountTF.layer.borderWidth = 1;
    accountTF.layer.borderColor = [[UIColor whiteColor] CGColor];
    accountTF.placeholder = @"工号";
    accountTF.leftView = v;
    accountTF.leftViewMode = UITextFieldViewModeAlways;
    accountTF.textColor = [UIColor whiteColor];
    accountTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [accountTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [mainScrollView addSubview:accountTF];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setImage:[UIImage imageNamed:@"login_more.png"] forState:UIControlStateNormal];
    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 13, 15, 10)];
    moreBtn.frame = CGRectMake(boundsWidth-66-15, 0, 40, 40);
    [moreBtn addTarget:self action:@selector(showMoreAccounts) forControlEvents:UIControlEventTouchUpInside];
    [accountTF addSubview:moreBtn];
//屏蔽下拉框
    moreBtn.hidden = YES;
    
    v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    v.backgroundColor = [UIColor clearColor];
    passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 249, boundsWidth-40, 40)];
    passwordTF.delegate = self;
    passwordTF.backgroundColor = [UIColor clearColor];
    passwordTF.layer.borderWidth = 1;
    passwordTF.layer.borderColor = [[UIColor whiteColor] CGColor];
    passwordTF.placeholder = @"密码";
    passwordTF.leftView = v;
    passwordTF.leftViewMode = UITextFieldViewModeAlways;
    passwordTF.secureTextEntry = YES;
    passwordTF.textColor = [UIColor whiteColor];
    passwordTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [passwordTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [mainScrollView addSubview:passwordTF];
    
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"登  录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [loginBtn setBackgroundColor:[UIColor hexChangeFloat:@"2da1d4"]];
    loginBtn.frame = CGRectMake(20, 310, boundsWidth-40, 47.5);
    [loginBtn addTarget:self action:@selector(loginReq) forControlEvents:UIControlEventTouchUpInside];

    [mainScrollView addSubview:loginBtn];
    
    rememberPassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rememberPassBtn.frame = CGRectMake(20, loginBtn.frameBottom+10, 85, 20);
    rememberPassBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rememberPassBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rememberPassBtn setTitle:@"记住密码" forState:UIControlStateNormal];
    [rememberPassBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rememberPassBtn setImage:[UIImage imageNamed:@"contact_noselect.png"] forState:UIControlStateNormal];
    [rememberPassBtn setImage:[UIImage imageNamed:@"contact_select.png"] forState:UIControlStateSelected];
    [rememberPassBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 65)];
    [rememberPassBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [rememberPassBtn addTarget:self action:@selector(rememberPassBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:rememberPassBtn];
    
    autoLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    autoLoginBtn.frame = CGRectMake(boundsWidth-102, loginBtn.frameBottom+10, 85, 20);
    autoLoginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [autoLoginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [autoLoginBtn setTitle:@"自动登录" forState:UIControlStateNormal];
    [autoLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [autoLoginBtn setImage:[UIImage imageNamed:@"contact_noselect.png"] forState:UIControlStateNormal];
    [autoLoginBtn setImage:[UIImage imageNamed:@"contact_select.png"] forState:UIControlStateSelected];
    [autoLoginBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 65)];
    [autoLoginBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [autoLoginBtn addTarget:self action:@selector(autoLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:autoLoginBtn];
    //测试账号选择

    if (self.defaultEnterpriseNo && self.defaultEnterpriseNo.length>0) {
        enterpriseTF.text =self.defaultEnterpriseNo;
    }
    
    if (self.defaultAccountNo && self.defaultAccountNo.length>0) {
        accountTF.text =self.defaultAccountNo;
    }
    
    if (self.defaulPasswordNo && self.defaulPasswordNo.length>0) {
        passwordTF.text =self.defaulPasswordNo;
    }
    
    scView = [[UIScrollView alloc] initWithFrame:CGRectMake(accountTF.frameX, accountTF.frameBottom, accountTF.frameWidth, 120)];
    scView.layer.borderWidth = 2;
    scView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    scView.hidden = YES;
    scView.backgroundColor = [UIColor clearColor];
    scView.showsVerticalScrollIndicator = NO;
    [mainScrollView addSubview:scView];
    
    UILabel *lab = nil;
    NSArray *tmpArr = [NSArray arrayWithObjects:@"0220000573",@"0220000657",@"0220000661", nil];
    for(int i = 0; i < 3; i++)
    {
        lab = [[UILabel alloc] initWithFrame:CGRectMake(0, i*40, accountTF.frameWidth, 40)];
        lab.backgroundColor = [UIColor whiteColor];
        lab.text = [tmpArr objectAtIndex:i];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor blackColor];
        __weak UIScrollView *weakView = scView;
        __weak UITextField *tfView = accountTF;
        [weakView addSubview:lab];
        [lab whenTapped:^{
            weakView.hidden = YES;
            tfView.text = lab.text;
        }];
        
        lab = [[UILabel alloc] initWithFrame:CGRectMake(0, i*40-1, accountTF.frameWidth, 1)];
        lab.backgroundColor = BGColor;
        [weakView addSubview:lab];
    }
    scView.contentSize = CGSizeMake(0, 0);
    
    
    enterpriseTF.text=self.defaultEnterpriseNo;
    accountTF.text =self.defaultAccountNo;
    passwordTF.text= self.defaulPasswordNo;
    rememberPassBtn.selected =self.isRememberPassword;
    autoLoginBtn.selected =self.isAutoLogin;
}

-(void)handleEnterpriseNo:(NSString*)enterpriseNo accountNo:(NSString*)accountNo passwordNo:(NSString*)passwordNo isAutoLogin:(BOOL)isAutoLogin isRememberPassword:(BOOL)isRememberPassword{
    self.defaulPasswordNo =passwordNo;
    self.defaultAccountNo =accountNo;
    self.defaultEnterpriseNo =enterpriseNo;
    self.isAutoLogin=isAutoLogin;
    self.isRememberPassword =isRememberPassword;
}

- (void)rememberPassBtnClick{
    rememberPassBtn.selected = !rememberPassBtn.selected;
    self.isRememberPassword =rememberPassBtn.selected;
    if (!self.isRememberPassword) {
        self.isAutoLogin =NO;
        autoLoginBtn.selected =NO;
    }
}

- (void)autoLoginBtnClick{
    autoLoginBtn.selected = !autoLoginBtn.selected;
    self.isAutoLogin =autoLoginBtn.selected;
    if(self.isAutoLogin){
        self.isRememberPassword =YES;
        rememberPassBtn.selected=YES;
    }
}

- (void)testAccountUse:(int)type
{
    switch (type) {
        case 1:
            accountTF.text = @"0220000573";
            passwordTF.text = @"123456";
            enterpriseTF.text = @"1";
            break;
        case 2:
            accountTF.text = @"0220000657";
            passwordTF.text = @"123456";
            enterpriseTF.text = @"1";
            break;
        case 3:
            accountTF.text = @"0220000661";
            passwordTF.text = @"123456";
            enterpriseTF.text = @"1";
            break;
            
        default:
            break;
    }
}


-(void)viewDidAppear:(BOOL)animated{
    if (self.isAutoLogin && [ConfigManager sharedInstance].loginDictionary && [ConfigManager sharedInstance].loginDictionary.count>0) {
        [self loginReq];
    }
    
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
}

-(void)keyboardWillShow:(NSNotification*)noti{
    if(boundsHeight<500)
    {
        CGRect keyboardRect = [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        logoView.hidden =YES;
        [mainScrollView setContentOffset:CGPointMake(0, CGRectGetMaxY(rememberPassBtn.frame)+10-[UIScreen mainScreen].bounds.size.height+keyboardRect.size.height)];
    }
}

-(void)keyboardWillHide:(NSNotification*)noti{
    if(boundsHeight<500)
    {
        [mainScrollView setContentOffset:CGPointZero];
        logoView.hidden =NO;
    }
}



-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)loginReq{
    
    [MMProgressHUD showHUDWithTitle:@"正在登录..." isDismissLater:NO];
    
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         //判断是否已登录
       
        NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
        NSUserDefaults *defalue = [NSUserDefaults standardUserDefaults];
        NSString *deviceToken = [defalue objectForKey:@"deviceToken"];
        
//        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//        int appCurVersionNum = [[infoDictionary objectForKey:@"CFBundleShortVersionString"] intValue];
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:accountTF.text forKey:@"jid"];
        [parameters setObject:[ConFunc DESEncrypt:passwordTF.text WithKey:nil] forKey:@"pwd"];
        [parameters setObject:enterpriseTF.text forKey:@"gid"];
        [parameters setObject:@"ios" forKey:@"clientType"];
        [parameters setObject:version forKey:@"version"];
        if(deviceToken)
        {
            [parameters setObject:deviceToken forKey:@"apnsToken"];
        }
//        [parameters setObject:[infoDictionary objectForKey:@"CFBundleShortVersionString"] forKey:@"versionCode"];
        
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodLogin] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
            if(success && [data isKindOfClass:[NSDictionary class]]){
                [ConfigManager sharedInstance].isLogin=YES;
                if(self.isAutoLogin || self.isRememberPassword){
                    if (enterpriseTF.text && enterpriseTF.text.length>0 && accountTF.text && accountTF.text.length>0 &&passwordTF.text && passwordTF.text.length>0) {
                        NSDictionary *loginDictionary =[NSDictionary dictionaryWithObjectsAndKeys:enterpriseTF.text,@"enterpriseNo",accountTF.text,@"accountNo",passwordTF.text,@"passwordNo",[NSNumber numberWithBool:self.isAutoLogin],@"isAutoLogin",[NSNumber numberWithBool:self.isRememberPassword],@"isRememberPassword", nil];
                        [ConfigManager sharedInstance].loginDictionary =loginDictionary;
                    }else{
                        [ConfigManager sharedInstance].loginDictionary =[NSDictionary dictionary];

                    }

                }else{
                    [ConfigManager sharedInstance].loginDictionary =[NSDictionary dictionary];
                }
                [ConfigManager sharedInstance].userDictionary =[data objectForKey:@"user"];
               
                [weakSelf loadGroupContacts];
                
                //delete by 陆浩
                [weakSelf loadEnterpriseContacts:^(void) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ENTERPRISECONTACT_FINISHED_LOAD object:nil];
                    });
                }];
                //end
                
                [[SQLiteManager sharedInstance] updateMessageMsgOtherIdByMyUid:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]]];
                
                [[MQTTManager sharedInstance] connect];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD showHUDWithTitle:@"登录成功！" isDismissLater:YES];
                    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
                    [appDelegate gotoDrawerController];
                });

            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD dismiss];
                    CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"登录失败" message:msg cancelButtonTitle:@"确认"];
                    alertView.showBlurBackground = YES;
                    [alertView show];
                });
            }
        } failureBlock:^(NSString *description) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MMProgressHUD dismiss];
                CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"登录失败" message:description cancelButtonTitle:@"确认"];
                alertView.showBlurBackground = YES;
                [alertView show];
            });
        }];
        
        /*
        [HTTPClient asynchronousGetRequest:ApiPrefix method:[HTTPAddress MethodLogin] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
            if(success && [data isKindOfClass:[NSDictionary class]]){
                [ConfigManager sharedInstance].isLogin=YES;
                if(self.isAutoLogin || self.isRememberPassword){
                    if (enterpriseTF.text && enterpriseTF.text.length>0 && accountTF.text && accountTF.text.length>0 &&passwordTF.text && passwordTF.text.length>0) {
                        NSDictionary *loginDictionary =[NSDictionary dictionaryWithObjectsAndKeys:enterpriseTF.text,@"enterpriseNo",accountTF.text,@"accountNo",passwordTF.text,@"passwordNo",[NSNumber numberWithBool:self.isAutoLogin],@"isAutoLogin",[NSNumber numberWithBool:self.isRememberPassword],@"isRememberPassword", nil];
                        [ConfigManager sharedInstance].loginDictionary =loginDictionary;
                    }else{
                        [ConfigManager sharedInstance].loginDictionary =[NSDictionary dictionary];
                        
                    }
                    
                }else{
                    [ConfigManager sharedInstance].loginDictionary =[NSDictionary dictionary];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD showHUDWithTitle:@"登录成功！" isDismissLater:YES];
                });
                
                //[CCPVoipManager sharedInstance].isLogin= YES;
                
                [ConfigManager sharedInstance].userDictionary =[data objectForKey:@"user"];
                
                
                [weakSelf loadGroupContacts];
                
                //delete by 陆浩
                [weakSelf loadEnterpriseContacts:^(void) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ENTERPRISECONTACT_FINISHED_LOAD object:nil];
                    });
                }];
                //end
                
                
                [[SQLiteManager sharedInstance] updateMessageMsgOtherIdByMyUid:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]]];
                
                [[MQTTManager sharedInstance] connect];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"%@",data);
                    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
                    [appDelegate gotoDrawerController];
                });
                
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD dismiss];
                    CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"登录失败" message:msg cancelButtonTitle:@"确认"];
                    alertView.showBlurBackground = YES;
                    [alertView show];
                });
            }
        } failureBlock:^(NSString *description) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MMProgressHUD dismiss];
                CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"登录失败" message:description cancelButtonTitle:@"确认"];
                alertView.showBlurBackground = YES;
                [alertView show];
            });
            
        }];
        */
    });
         
}


-(void)loadGroupContacts{
    NSString *myToken =[[ConfigManager sharedInstance].userDictionary  objectForKey:@"token"];
    [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodFindGroup] parameters:[NSDictionary dictionaryWithObject:myToken forKey:@"token"] successBlock:^(BOOL success, id data, NSString *msg) {
        NSArray *gitems =[data objectForKey:@"item"];
        NSMutableArray *groups =[[NSMutableArray alloc] init];
        NSMutableArray *groupUsers =[[NSMutableArray alloc] init];
        
        HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
        [outputFormat setToneType:ToneTypeWithoutTone];
        [outputFormat setVCharType:VCharTypeWithV];
        [outputFormat setCaseType:CaseTypeLowercase];
        
        for (NSDictionary *gitem in gitems) {
            MGroup *mg =[[MGroup alloc] init];
            mg.createTime =[gitem objectForKey:@"createTime"];
            mg.groupName =[gitem objectForKey:@"groupName"];
            mg.groupid =[gitem objectForKey:@"groupid"];
            mg.len =[gitem objectForKey:@"len"];
            mg.name =[gitem objectForKey:@"name"];
            mg.uid =[gitem objectForKey:@"uid"];
            mg.ver =[gitem objectForKey:@"ver"];
            mg.maxLen =[gitem objectForKey:@"maxLen"];
            mg.isTemp =[gitem objectForKey:@"isTemp"];
            
            NSMutableArray *users =[[NSMutableArray alloc] init];
            NSArray *userlist =[gitem objectForKey:@"userlist"];
            for (NSDictionary *guitem in userlist) {
                MGroupUser *user =[[MGroupUser alloc] init];
                user.autograph =[guitem objectForKey:@"autograph"];
                user.cid =[guitem objectForKey:@"cid"];
                user.cname =[guitem objectForKey:@"cname"];
                user.email =[guitem objectForKey:@"email"];
                user.fax =[guitem objectForKey:@"fax"];
                user.gid =[guitem objectForKey:@"gid"];
                user.groupVer =[guitem objectForKey:@"groupVer"];
                user.groupids =[guitem objectForKey:@"groupids"];
                user.jid =[guitem objectForKey:@"jid"];
                user.mobile =[guitem objectForKey:@"mob"];
                
                user.minipicurl =[guitem objectForKey:@"minipicurl"];
                user.bigpicurl =[guitem objectForKey:@"bigpicurl"];
                user.extNumber =[guitem objectForKey:@"extNumber"];
                
                user.uname =[guitem objectForKey:@"name"];
                user.post =[guitem objectForKey:@"post"];
                user.pwd =[guitem objectForKey:@"pwd"];
                user.remark =[guitem objectForKey:@"remark"];
                user.telephone =[guitem objectForKey:@"telephone"];
                user.uid =[guitem objectForKey:@"uid"];
                user.viopId =[guitem objectForKey:@"viopId"];
                user.viopPwd =[guitem objectForKey:@"viopPwd"];
                user.viopSid =[guitem objectForKey:@"viopSid"];
                user.viopSidPwd =[guitem objectForKey:@"viopSidPwd"];
                user.pinyin=[PinyinHelper toHanyuPinyinStringWithNSString:user.uname withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
                user.groupid =[gitem objectForKey:@"groupid"];
                [users addObject:user];
                if ([user.uid longLongValue]>0) {
                    [groupUsers addObject:user];
                }
                
            }
            mg.users =[NSArray arrayWithArray:users];
            [groups addObject:mg];
            
        }
        [[SQLiteManager sharedInstance] deleteGroup];
        [[SQLiteManager sharedInstance] deleteGroupUsers];

        
        [[SQLiteManager sharedInstance] insertGroupsToSQLite:groups];
        [[SQLiteManager sharedInstance] insertGroupUsersToSQLite:groupUsers notificationName:NOTIFICATION_R_SQL_GROUPUSER];
        
    } failureBlock:^(NSString *description) {
        NSLog(@"url=%@,error=%@",[HTTPAddress MethodFindGroup],description);
    }];
}

-(void)loadEnterpriseContacts:(void (^)(void))allCompletionBlock{
    
    NSString *myToken =[[ConfigManager sharedInstance].userDictionary  objectForKey:@"token"];
    NSString *myGid =[[ConfigManager sharedInstance].userDictionary  objectForKey:@"gid"];
    [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodEnterpriseContact] parameters:[NSDictionary dictionaryWithObject:myToken forKey:@"token"] successBlock:^(BOOL success, id data, NSString *msg) {
        if (success && data) {
            MEnterpriseCompany *company =[[MEnterpriseCompany alloc] init];
            NSDictionary *firm =[data objectForKey:@"firm"];
            company.gid =[firm objectForKey:@"gid"];
            company.gname =[firm objectForKey:@"name"];
            
            NSArray *composition =[firm objectForKey:@"composition"];
            NSMutableArray *nodeDepts =[[NSMutableArray alloc] init];
            NSMutableArray *rootCIds =[[NSMutableArray alloc] init];
            for (NSDictionary *node in composition) {
                MEnterpriseDept *nodeDept=[[MEnterpriseDept alloc] init];
                nodeDept.cid =[NSString stringWithFormat:@"%d",[[node objectForKey:@"cid"] intValue]];
                nodeDept.gid =[NSString stringWithFormat:@"%d",[[node objectForKey:@"gid"] intValue]];
                nodeDept.isroot =[NSString stringWithFormat:@"%d",[[node objectForKey:@"isroot"] intValue]];;
                nodeDept.cname =[node objectForKey:@"name"];
                nodeDept.pid =[NSString stringWithFormat:@"%d",[[node objectForKey:@"pid"] intValue]];
                [nodeDepts addObject:nodeDept];
                if ([nodeDept.pid intValue]==0) {
                    [rootCIds addObject:nodeDept.cid];
                }
                
            }
            company.rootCIds =[NSMutableArray arrayWithArray:rootCIds];
            [[SQLiteManager sharedInstance] insertDeptsToSQLite:nodeDepts];
            [[SQLiteManager sharedInstance] insertCompanysToSQLite:[NSArray arrayWithObject:company]];

        }
    } failureBlock:^(NSString *description) {
        NSLog(@"url=%@,error=%@",[HTTPAddress MethodEnterpriseContact],description);
    }];
    
    
    NSMutableDictionary *firstParameter =[[NSMutableDictionary alloc] init];
    [firstParameter setObject:myToken forKey:@"token"];
    [firstParameter setObject:myGid forKey:@"gid"];
    [firstParameter setObject:[NSNumber numberWithInt:1] forKey:@"page"];
    [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodFindUserByGid] parameters:firstParameter successBlock:^(BOOL success, id data, NSString *msg) {
        int maxcount =[[data objectForKey:@"maxcount"] intValue];
        [self handleEnterpriseContactWithData:data];
        
        NSMutableArray *parameters =[[NSMutableArray alloc] init];
        NSMutableArray *urls =[[NSMutableArray alloc] init];
        for (int i=0; i<maxcount/20; i++) {
            NSMutableDictionary *parameter =[[NSMutableDictionary alloc] init];
            [parameter setObject:myToken forKey:@"token"];
            [parameter setObject:myGid forKey:@"gid"];
            [parameter setObject:[NSNumber numberWithInt:i+2] forKey:@"page"];
            
            [urls addObject:[HTTPAddress MethodFindUserByGid]];
            [parameters addObject:parameter];
        }
        
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodFindUserByGid] parameters:parameters singleSuccessBlock:^(NSString *url, BOOL success, id data, NSString *msg) {
            [self handleEnterpriseContactWithData:data];
        } singleFailureBlock:^(NSString *description) {
            NSLog(@"error=%@",description);
        } allCompletionBlock:^(NSArray *operations) {
            if (allCompletionBlock) {
                allCompletionBlock();
            }
        }];
        
    } failureBlock:^(NSString *description) {
        NSLog(@"url=%@,error=%@",[HTTPAddress MethodFindUserByGid],description);
    }];
    
    
}


-(void)handleEnterpriseContactWithData:(NSDictionary *)data{
    
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    
    NSArray *items=[data objectForKey:@"item"];
    NSMutableArray *enterpriseUsers =[[NSMutableArray alloc] init];
    for (NSDictionary *item in items) {
        MEnterpriseUser *user=[[MEnterpriseUser alloc] init];
        user.autograph =[item objectForKey:@"autograph"];
        user.cid =[item objectForKey:@"cid"];
        user.cname =[item objectForKey:@"cname"];
        user.email =[item objectForKey:@"email"];
        user.fax =[item objectForKey:@"fax"];
        user.gid =[item objectForKey:@"gid"];
        user.groupVer =[item objectForKey:@"groupVer"];
        user.groupids =[item objectForKey:@"groupids"];
        user.jid =[item objectForKey:@"jid"];
        user.mobile =[item objectForKey:@"mob"];
        
        user.minipicurl =[item objectForKey:@"minipicurl"];
        user.bigpicurl =[item objectForKey:@"bigpicurl"];
        user.extNumber =[item objectForKey:@"extNumber"];
        
        user.uname =[item objectForKey:@"name"];
        user.post =[item objectForKey:@"post"];
        user.pwd =[item objectForKey:@"pwd"];
        user.remark =[item objectForKey:@"remark"];
        user.telephone =[item objectForKey:@"telephone"];
        user.uid =[item objectForKey:@"uid"];
        user.viopId =[item objectForKey:@"viopId"];
        user.viopPwd =[item objectForKey:@"viopPwd"];
        user.viopSid =[item objectForKey:@"viopSid"];
        user.viopSidPwd =[item objectForKey:@"viopSidPwd"];
        user.pinyin=[PinyinHelper toHanyuPinyinStringWithNSString:user.uname withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
        if([user.uid longLongValue] == [[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"] longLongValue])
        {
            //NSLog(@"妈的不能把自己加入到通讯录里面，知道不，草草草，换过账号需要把自己从原来的数据库里面删掉");
            [[SQLiteManager sharedInstance] deleteUserId:[NSString stringWithFormat:@"%@",user.uid]];
        }
        else
        {
            [enterpriseUsers addObject:user];
        }
    }
    [[SQLiteManager sharedInstance] insertUsersToSQLite:enterpriseUsers notificationName:nil];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
