//
//  RegisterViewController.m
//  IM
//
//  Created by ZteCloud on 15/10/10.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "RegisterViewController.h"
#import "AcountInfoViewController.h"
#import "ForgetPswViewController.h"
@interface RegisterViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *mainTable;
    UITextField *phoneTF,*codeTF;
    UIButton *nextBtn,*codeBtn;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self handleNavigationBarItem];
    [self setTable];
}
#pragma mark------setTable
-(void)setTable
{
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight) style:UITableViewStylePlain];
    mainTable.backgroundColor=BGColor;
    mainTable.delegate=self;
    mainTable.dataSource=self;
    mainTable.showsVerticalScrollIndicator=NO;
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTable];
    UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight/1.5)];
    [control addTarget:self action:@selector(controlTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    mainTable.tableFooterView = control;
    
}
//control touch
-(void)controlTouchUpInside{
    [phoneTF resignFirstResponder];
    [codeTF resignFirstResponder];
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
            NSArray *titles=[NSArray arrayWithObjects:LOCALIZATION(@"Register_Mobile"),LOCALIZATION(@"Register_Certify"), nil];
            cell.textLabel.text=[titles objectAtIndex:indexPath.row];
            UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 43, mainTable.frame.size.width, 0.5)];
            lineLabel.backgroundColor=RGBColor(195, 195, 195);
            lineLabel.tag=10004;
            [cell.contentView addSubview:lineLabel];
            if (indexPath.row==0)
            {
                phoneTF=[[UITextField alloc]initWithFrame:CGRectMake(50+EdgeDis, 0, mainTable.frame.size.width-50-EdgeDis*2-100, 44)];
                phoneTF.placeholder=LOCALIZATION(@"Register_MobileHolder");
                phoneTF.tag=10003;
                phoneTF.textAlignment=NSTextAlignmentRight;
                //                phoneTF.textColor=mainCharaterColor;
                //                phoneTF.font=FontSize13;
                phoneTF.delegate=self;
                [cell.contentView addSubview:phoneTF];
                codeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
                codeBtn.frame=CGRectMake(boundsWidth-80-EdgeDis, 7, 80,30);
                [codeBtn setTitle:LOCALIZATION(@"Register_SendCode") forState:UIControlStateNormal];
                [codeBtn setTitleColor:MainColor forState:UIControlStateNormal];
//                [codeBtn setBackgroundColor:MainColor];
                codeBtn.tag=10001+indexPath.row;
                codeBtn.titleLabel.font=[UIFont systemFontOfSize:13];
                [codeBtn addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:codeBtn];
                codeBtn.layer.borderWidth=1.0f;
                codeBtn.layer.borderColor=[MainColor CGColor];
                codeBtn.layer.cornerRadius=5;
                codeBtn.layer.masksToBounds=YES;
                if ([UserDefault objectForKey:@"RPhone"])
                {
                    phoneTF.text=[UserDefault objectForKey:@"RPhone"];
                }
                
            }
            if (indexPath.row==1)
            {
                NSLog(@"%f",cell.textLabel.frame.size.width);
                codeTF=[[UITextField alloc]initWithFrame:CGRectMake(50+EdgeDis, 0, mainTable.frame.size.width-50-EdgeDis*2, 44)];
                codeTF.placeholder=LOCALIZATION(@"Register_CertifyHolder");
                codeTF.tag=10003;
                codeTF.textAlignment=NSTextAlignmentRight;
                //                pwsTF.textColor=mainCharaterColor;
                //                pwsTF.font=FontSize13;
                codeTF.delegate=self;
                [cell.contentView addSubview:codeTF];
                if ([UserDefault objectForKey:@"RCode"])
                {
                    codeTF.text=[UserDefault objectForKey:@"RCode"];
                }
            }
            
        }
            break;
        case 1:
        {
            cell.backgroundColor=BGColor;
            nextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            nextBtn.frame=CGRectMake(EdgeDis, 0, mainTable.frame.size.width-EdgeDis*2,44);
            [nextBtn setTitle:LOCALIZATION(@"Register_Next") forState:UIControlStateNormal];
            [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [nextBtn setBackgroundColor:MainColor];
            [nextBtn addTarget:self action:@selector(toNext:) forControlEvents:UIControlEventTouchUpInside];
            //            loginBtn.titleLabel.font=titleFontSize;
            nextBtn.tag=10001+indexPath.row;
            [cell.contentView addSubview:nextBtn];
            nextBtn.layer.cornerRadius=3;
            nextBtn.layer.masksToBounds=YES;
        }
            break;
            
        default:
            break;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return EdgeDis;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *myView=[[UIView alloc]init];
    myView.backgroundColor=BGColor;
    return myView;
}
#pragma mark--------getCode
-(void)getCode:(UIButton*)btn
{
    if ([phoneTF.text isEqualToString:@""])
    {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Register_MobileHolder") isDismissLater:YES];
        return;
    }
    [self codeReq];
}
-(void)codeReq
{
    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Register_GetCode") isDismissLater:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:phoneTF.text forKey:@"mobile"];
        [parameters setObject:@"0" forKey:@"type"];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodRegGetCode] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
//            NSLog(@"%@",msg);
            if(success && [data isKindOfClass:[NSDictionary class]]){
//                NSLog(@"%@",data);
                [MMProgressHUD showHUDWithTitle:data[@"res"][@"resMessage"] isDismissLater:YES];
                NSLog(@"%@",data[@"item"][@"sessionId"]);
                [UserDefault setObject:data[@"item"][@"sessionId"] forKey:@"SessionId"];
                [UserDefault setObject:data[@"item"][@"sessionKey"] forKey:@"SessionKey"];
                [UserDefault setObject:data[@"res"][@"reCode"] forKey:@"Code"];
            
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD showHUDWithTitle:msg isDismissLater:YES];
                });
            }
        } failureBlock:^(NSString *description) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"RequestFail") isDismissLater:YES];
            });
        }];
    });
}
#pragma mark=------toNext
-(void)toNext:(UIButton*)btn
{
    if ([phoneTF.text isEqualToString:@""])
    {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Register_MobileHolder") isDismissLater:YES];
        return;
    }
    if ([codeTF.text isEqualToString:@""])
    {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Register_CertifyHolder") isDismissLater:YES];
        return;
    }
    [self confirmCodeReq];
    
    
    
}
-(void)confirmCodeReq
{
    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Register_ReqLoading") isDismissLater:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:phoneTF.text forKey:@"mobile"];
        [parameters setObject:[NSString stringWithFormat:@"%@",[UserDefault objectForKey:@"SessionId"]] forKey:@"sessionId"];
        [parameters setObject:[NSString stringWithFormat:@"%@",[UserDefault objectForKey:@"SessionKey"]]forKey:@"sessionKey"];
        [parameters setObject:codeTF.text forKey:@"code"];
        [parameters setObject:@"0" forKey:@"type"];
        NSLog(@"%@     %@",codeTF.text,[UserDefault objectForKey:@"SessionKey"]);
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodRegConfirmCode] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
//            NSLog(@"%@",msg);
            if(success && [data isKindOfClass:[NSDictionary class]]){
//                NSLog(@"%@",data);
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Register_ReqFinish") isDismissLater:YES];
                [UserDefault setObject:data[@"item"][@"sessionId"] forKey:@"SessionId"];
                [UserDefault setObject:data[@"item"][@"sessionKey"] forKey:@"SessionKey"];
                if (self.isRegister)
                {
                    AcountInfoViewController *avc=[[AcountInfoViewController alloc]init];
                    [self.navigationController pushViewController:avc animated:YES];
                    
                }
                else
                {
                    ForgetPswViewController *fvc=[[ForgetPswViewController alloc]init];
                    [self.navigationController pushViewController:fvc animated:YES];
                }
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD showHUDWithTitle:msg isDismissLater:YES];
                });
            }
        } failureBlock:^(NSString *description) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"RequestFail") isDismissLater:YES];
            });
        }];
    });
}
#pragma mark------textfield delegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==phoneTF)
    {
        [UserDefault setObject:phoneTF.text forKey:@"RPhone"];
    }
    if (textField==codeTF)
    {
        [UserDefault setObject:codeTF.text forKey:@"RCode"];
    }
}
#pragma mark 处理导航条
-(void)handleNavigationBarItem{
    self.navigationItem.title = (self.isRegister)?LOCALIZATION(@"Register_NavTitle1"):LOCALIZATION(@"Register_NavTitle2");
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
}
-(void)clickLeftItem:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    [UserDefault removeObjectForKey:@"RPhone"];
    [UserDefault removeObjectForKey:@"RCode"];
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
