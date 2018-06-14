//
//  ForgetPswViewController.m
//  IM
//
//  Created by ZteCloud on 15/10/15.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "ForgetPswViewController.h"

@interface ForgetPswViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *mainTable;
    UITextField *newPswTF,*addrTF,*addrDTF;
    UIButton *changeBtn;
}

@end

@implementation ForgetPswViewController

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
    [newPswTF resignFirstResponder];
    [addrDTF resignFirstResponder];
}
#pragma mark------tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
        
        case 1:
        {
            cell.backgroundColor=BGColor;
            changeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            changeBtn.frame=CGRectMake(EdgeDis, 0, mainTable.frame.size.width-EdgeDis*2,44);
            [changeBtn setTitle:LOCALIZATION(@"ForgetPswViewController_Confirm") forState:UIControlStateNormal];
            [changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [changeBtn setBackgroundColor:MainColor];
            [changeBtn addTarget:self action:@selector(changeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            //            loginBtn.titleLabel.font=titleFontSize;
            changeBtn.tag=10001+indexPath.row;
            [cell.contentView addSubview:changeBtn];
            changeBtn.layer.cornerRadius=3;
            changeBtn.layer.masksToBounds=YES;
        }
            break;
        case 0:
        {
            cell.textLabel.text=[NSString stringWithFormat:@"%@",LOCALIZATION(@"ForgetPswViewController_NewPaw")];
            newPswTF=[[UITextField alloc]initWithFrame:CGRectMake(50+EdgeDis, 0, mainTable.frame.size.width-50-EdgeDis*2, 44)];
            newPswTF.placeholder=LOCALIZATION(@"ForgetPswViewController_NewPawHolder");
            newPswTF.tag=10003;
            newPswTF.textAlignment=NSTextAlignmentRight;
            //                phoneTF.textColor=mainCharaterColor;
            //                phoneTF.font=FontSize13;
            newPswTF.delegate=self;
            newPswTF.secureTextEntry=YES;
            [cell.contentView addSubview:newPswTF];
            
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
#pragma mark=------change
-(void)changeBtnClick:(UIButton*)btn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self setUserPwdReq];
}
-(void)setUserPwdReq
{
    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"ForgetPswViewController_Loading") isDismissLater:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:[ConFunc DESEncrypt:newPswTF.text WithKey:nil] forKey:@"newPwd"];
        [parameters setObject:[ConFunc DESEncrypt:newPswTF.text WithKey:nil] forKey:@"chkPwd"];
        [parameters setObject:[UserDefault objectForKey:@"SessionId"] forKey:@"sessionId"];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodSetUserPwd] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
            NSLog(@"%@",msg);
            if(success && [data isKindOfClass:[NSDictionary class]]){
                NSLog(@"%@",data);
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"ForgetPswViewController_Finish") isDismissLater:YES];
                [UserDefault removeObjectForKey:@"RPhone"];
                [UserDefault removeObjectForKey:@"RCode"];
                [self.navigationController popViewControllerAnimated:YES];
                
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
    if (textField==newPswTF)
    {
        [UserDefault setObject:newPswTF.text forKey:@"CName"];
    }
    if (textField==addrDTF)
    {
        [UserDefault setObject:addrDTF.text forKey:@"CDaddr"];
    }
}
#pragma mark 处理导航条
-(void)handleNavigationBarItem{
    self.navigationItem.title = LOCALIZATION(@"ForgetPswViewController_NavTitle");
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
}
-(void)clickLeftItem:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
