//
//  LoginViewController1.m
//  IM
//
//  Created by ZteCloud on 15/10/10.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "LoginViewController1.h"
#import "RegisterViewController.h"
#import "JoinEnterpriseViewController.h"
#import "EnterpriseManager.h"

@interface LoginViewController1 ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *mainTable;
    UITextField *phoneTF,*pswTF;
    UIButton *loginBtn;
}

@end

@implementation LoginViewController1
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    if([ConfigManager sharedInstance].isLogin)
    {
        [self loginReq];
   
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [NotiCenter addObserver:self selector:@selector(boardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [NotiCenter addObserver:self selector:@selector(boardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self setTable];
}
-(void)boardWillShow:(NSNotification*)noti
{
    CGRect keyboardRect = [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSNumber *duration = [[noti userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.view.bounds;
    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    
    
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        
        if (keyboardRect.origin.y<362) {
            mainTable.frame=CGRectMake(0,keyboardRect.origin.y-362, mainTable.frame.size.width, mainTable.frame.size.height);
        }
    } completion:^(BOOL finished){
        
    }];
}
-(void)boardWillHide:(NSNotification*)noti
{
    NSNumber *duration = [[noti userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        
        mainTable.frame=CGRectMake(0, 0, mainTable.frame.size.width, mainTable.frame.size.height);
    } completion:^(BOOL finished) {
    }];
}
#pragma mark------setTable
-(void)setTable
{
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight) style:UITableViewStyleGrouped];
    mainTable.backgroundColor=BGColor;
    mainTable.delegate=self;
    mainTable.dataSource=self;
//    mainTable.scrollEnabled=NO;
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTable];
//    UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight/1.5)];
//    [control addTarget:self action:@selector(controlTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
//    mainTable.tableFooterView = control;
    
    UILabel *versonLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, boundsHeight-30, boundsWidth, 30)];
    versonLabel.text=[NSString stringWithFormat:@"Version v%@",[ConFunc getAppVersion]];
    versonLabel.textColor=[UIColor grayColor];
    versonLabel.textAlignment=NSTextAlignmentCenter;
    versonLabel.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:versonLabel];
}
//control touch
-(void)controlTouchUpInside{
    [phoneTF resignFirstResponder];
    [pswTF resignFirstResponder];
}
#pragma mark------tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    }
    else
    {
        for (UIView *subviews in cell.contentView.subviews) {
            if (subviews.tag>10000) {
                [subviews removeFromSuperview];
            }
        }
    }
    switch (indexPath.section) {
        case 0:
        {
            NSArray *titles=[NSArray arrayWithObjects:LOCALIZATION(@"LoginViewController1_Mobile"),LOCALIZATION(@"LoginViewController1_Paw"), nil];
            cell.textLabel.text=[titles objectAtIndex:indexPath.row];
            UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 43, mainTable.frame.size.width, 0.5)];
            lineLabel.backgroundColor=RGBColor(195, 195, 195);
            lineLabel.tag=10004;
            [cell.contentView addSubview:lineLabel];
            if (indexPath.row==0)
            {
                phoneTF=[[UITextField alloc]initWithFrame:CGRectMake(90+EdgeDis, 0, mainTable.frame.size.width-50-EdgeDis*2, 44)];
                phoneTF.placeholder=LOCALIZATION(@"LoginViewController1_MobileHolder");
                phoneTF.tag=10003+indexPath.row;
                phoneTF.textAlignment=NSTextAlignmentLeft;
//                phoneTF.textColor=mainCharaterColor;
//                phoneTF.font=FontSize13;
                phoneTF.delegate=self;
                [cell.contentView addSubview:phoneTF];
                if ([UserDefault objectForKey:@"LPhone"])
                {
                    phoneTF.text=[UserDefault objectForKey:@"LPhone"];
                }
            }
            if (indexPath.row==1)
            {
                pswTF=[[UITextField alloc]initWithFrame:CGRectMake(90+EdgeDis, 0, mainTable.frame.size.width-50-EdgeDis*2, 44)];
                pswTF.placeholder=LOCALIZATION(@"LoginViewController1_PawHolder");
                pswTF.tag=10003+indexPath.row;
                pswTF.textAlignment=NSTextAlignmentLeft;
//                pwsTF.textColor=mainCharaterColor;
//                pwsTF.font=FontSize13;
                pswTF.secureTextEntry=YES;
                pswTF.delegate=self;
                [cell.contentView addSubview:pswTF];
                if ([UserDefault objectForKey:@"LPsw"])
                {
                    pswTF.text=[UserDefault objectForKey:@"LPsw"];
                }
            }
       
        }
            break;
        case 1:
        {
            cell.backgroundColor=BGColor;
            loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            loginBtn.frame=CGRectMake(EdgeDis, 0, mainTable.frame.size.width-EdgeDis*2,44);
            [loginBtn setTitle:LOCALIZATION(@"LoginViewController1_Login") forState:UIControlStateNormal];
            [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [loginBtn setBackgroundColor:MainColor];
            [loginBtn addTarget:self action:@selector(toLogin:) forControlEvents:UIControlEventTouchUpInside];
//            loginBtn.titleLabel.font=titleFontSize;
            [cell.contentView addSubview:loginBtn];
            loginBtn.layer.cornerRadius=3;
            loginBtn.layer.masksToBounds=YES;
        }
            break;
            
        default:
            break;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 200;
    }
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *myView=[[UIView alloc]init];
    myView.backgroundColor=BGColor;
    if (section==0) {
        UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake((boundsWidth-90)/2, 50, 90, 90)];
        logoView.image = [UIImage imageNamed:@"Logo"];
        logoView.layer.borderColor = [UIColor whiteColor].CGColor;
        logoView.layer.borderWidth = 2.0f;
        logoView.layer.masksToBounds = YES;
        logoView.layer.cornerRadius = 10;
        logoView.hidden =NO;
        [myView addSubview:logoView];
        UILabel *wordLabel=[[UILabel alloc]initWithFrame:CGRectMake(EdgeDis, logoView.frame.size.height+logoView.frame.origin.y, boundsWidth-EdgeDis*2, 30)];
        wordLabel.text=LOCALIZATION(@"LoginViewController1_Ad");
        wordLabel.textColor=MainColor;
        wordLabel.font=[UIFont systemFontOfSize:13];
        wordLabel.textAlignment=NSTextAlignmentCenter;
        [myView addSubview:wordLabel];
        
    }
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(controlTouchUpInside)];
    [myView addGestureRecognizer:tap];
    return myView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==1) {
        return 30;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *myView=[[UIView alloc]init];
    myView.backgroundColor=BGColor;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(controlTouchUpInside)];
    [myView addGestureRecognizer:tap];
    return myView;
}
#pragma mark-----------forgetBtnClick
-(void)forgetBtnClick:(UIButton*)btn
{
    RegisterViewController *rvc=[[RegisterViewController alloc]init];
    rvc.isRegister=NO;
    [self.navigationController pushViewController:rvc animated:YES];
}
#pragma mark-------toLogin
-(void)toLogin:(UIButton *)btn
{
    [self controlTouchUpInside];
    [self loginReq];
}
- (void)loginReq{
    
    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"LoginViewController1_LoginLoading") isDismissLater:NO];
    
//    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //判断是否已登录
        
        NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
        NSUserDefaults *defalue = [NSUserDefaults standardUserDefaults];
        NSString *deviceToken = [defalue objectForKey:@"deviceToken"];
        
        //        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        //        int appCurVersionNum = [[infoDictionary objectForKey:@"CFBundleShortVersionString"] intValue];
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:phoneTF.text forKey:@"username"];
        [parameters setObject:[ConFunc DESEncrypt:pswTF.text WithKey:nil] forKey:@"pwd"];
        [parameters setObject:[NSString stringWithFormat:@"%d",[version intValue]] forKey:@"versionCode"];
        [parameters setObject:@"ios" forKey:@"clientType"];
        [parameters setObject:version forKey:@"version"];
        if(deviceToken)
        {
            [parameters setObject:deviceToken forKey:@"apnsToken"];
        }
        //        [parameters setObject:[infoDictionary objectForKey:@"CFBundleShortVersionString"] forKey:@"versionCode"];
//        [HTTPClient asynchronousGetRequest:ApiPrefix method:[HTTPAddress MethodLogin] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg){
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodLogin] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
            NSLog(@"%@",data);
            if(success && [data isKindOfClass:[NSDictionary class]]){
                
                BOOL isFormProcessor = [data[@"user"][@"isFormProcessor"] boolValue];
                [UserDefault setObject:@(!isFormProcessor) forKey:@"isSender"];
                
                [ConfigManager sharedInstance].isLogin=YES;
                [ConfigManager sharedInstance].loginDictionary =[NSDictionary dictionary];
                [UserDefault removeObjectForKey:@"NOTransit"];
                
           
                [ConfigManager sharedInstance].userDictionary =[data objectForKey:@"user"];
                [UserDefault setObject:data[@"user"][@"token"] forKey:@"TOKEN"];
                //加载组通讯录
                //                [weakSelf loadGroupContacts];
                
                [[EnterpriseManager sharedInstance] loadGroupContacts];
                
                //加载企业通讯录
                [[EnterpriseManager sharedInstance] loadEnterpriseContacts:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ENTERPRISECONTACT_FINISHED_LOAD object:nil];
                    });
                }];
                
                [[SQLiteManager sharedInstance] updateMessageMsgOtherIdByMyUid:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]]];
                
                [[MQTTManager sharedInstance] connect];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"LoginViewController1_LoginFinish") isDismissLater:YES];
                    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
                    [appDelegate gotoDrawerController];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD dismiss];
                    CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:LOCALIZATION(@"LoginViewController1_LoginFail") message:msg cancelButtonTitle:LOCALIZATION(@"LoginViewController1_Confirm")];
                    alertView.showBlurBackground = YES;
                    [alertView show];
                    if (data[@"sessionId"])
                    {
                        [UserDefault setObject:[NSString stringWithFormat:@"%@",data[@"sessionId"]] forKey:@"SessionId"];
                        [UserDefault setObject:[NSString stringWithFormat:@"%@",data[@"tenantName"]] forKey:@"TenantName"];
                        JoinEnterpriseViewController *jvc=[[JoinEnterpriseViewController alloc]init];
                        [self.navigationController pushViewController:jvc animated:YES];
                    }
                     
                    NSLog(@"%@    %@",msg,data);
                });
            }
        } failureBlock:^(NSString *description) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MMProgressHUD dismiss];
                CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:LOCALIZATION(@"LoginViewController1_LoginFail") message:description cancelButtonTitle:LOCALIZATION(@"LoginViewController1_Confirm")];
                alertView.showBlurBackground = YES;
                [alertView show];
            });
        }];
        
        
    });
    
}
#pragma mark------加载组通讯录
-(void)loadGroupContacts{
    NSString *myToken =[[ConfigManager sharedInstance].userDictionary  objectForKey:@"token"];
    
    if (!myToken) {
        return;
    }
    
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
#pragma mark------加载企业通讯录
-(void)loadEnterpriseContacts:(void (^)(void))allCompletionBlock{
    
    NSString *myToken =[[ConfigManager sharedInstance].userDictionary  objectForKey:@"token"];
    NSString *myGid =[[ConfigManager sharedInstance].userDictionary  objectForKey:@"gid"];
    
    if (!myToken || !myGid) {
        return;
    }
    
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
        
        user.groupManager=[item objectForKey:@"groupManager"];
        
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
            //NSLog(@"不能把自己加入到通讯录里面，，换过账号需要把自己从原来的数据库里面删掉");
            [[SQLiteManager sharedInstance] deleteUserId:[NSString stringWithFormat:@"%@",user.uid]];
        }
        else
        {
            [enterpriseUsers addObject:user];
        }
    }
    [[SQLiteManager sharedInstance] insertUsersToSQLite:enterpriseUsers notificationName:nil];
}
#pragma mark------textfield delegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==phoneTF)
    {
        [UserDefault setObject:phoneTF.text forKey:@"LPhone"];
    }
    if (textField==pswTF)
    {
        [UserDefault setObject:pswTF.text forKey:@"LPsw"];
    }
}
#pragma mark-----------registerBtnClick
-(void)registerBtnClick:(UIButton*)btn
{
    RegisterViewController *rvc=[[RegisterViewController alloc]init];
    rvc.isRegister=YES;
    [self.navigationController pushViewController:rvc animated:YES];
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
