//
//  CompanyInfoViewController.m
//  IM
//
//  Created by ZteCloud on 15/10/12.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "CompanyInfoViewController.h"

@interface CompanyInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *mainTable;
    UITextField *cNameTF,*addrTF,*addrDTF;
    UIButton *onceLearnBtn;
}

@end

@implementation CompanyInfoViewController
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
    [cNameTF resignFirstResponder];
    [addrDTF resignFirstResponder];
}
#pragma mark------tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2) {
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
        case 2:
        {
            NSArray *titles=[NSArray arrayWithObjects:@"公司地址",@"", nil];
            cell.textLabel.text=[titles objectAtIndex:indexPath.row];
            UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 43, mainTable.frame.size.width, 0.5)];
            lineLabel.backgroundColor=RGBColor(195, 195, 195);
            lineLabel.tag=10004;
            [cell.contentView addSubview:lineLabel];
            if (indexPath.row==0)
            {
                addrTF=[[UITextField alloc]initWithFrame:CGRectMake(50+EdgeDis, 0, mainTable.frame.size.width-50-EdgeDis*2, 44)];
                addrTF.placeholder=@"请输入您的密码";
                addrTF.tag=10003;
                addrTF.textAlignment=NSTextAlignmentRight;
                //                phoneTF.textColor=mainCharaterColor;
                //                phoneTF.font=FontSize13;
                addrTF.delegate=self;
                [cell.contentView addSubview:addrTF];
                
            }
            if (indexPath.row==1)
            {
                NSLog(@"%f",cell.textLabel.frame.size.width);
                addrDTF=[[UITextField alloc]initWithFrame:CGRectMake(EdgeDis, 0, mainTable.frame.size.width-EdgeDis*2, 44)];
                addrDTF.placeholder=@"请输入详细地址";
                addrDTF.tag=10003;
                addrDTF.textAlignment=NSTextAlignmentRight;
                //                pwsTF.textColor=mainCharaterColor;
                //                pwsTF.font=FontSize13;
                addrDTF.delegate=self;
                [cell.contentView addSubview:addrDTF];
                if ([UserDefault objectForKey:@"CDaddr"]) {
                    addrDTF.text=[UserDefault objectForKey:@"CDaddr"];
                }
            }
            
        }
            break;
        case 1:
        {
            cell.backgroundColor=BGColor;
            onceLearnBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            onceLearnBtn.frame=CGRectMake(EdgeDis, 0, mainTable.frame.size.width-EdgeDis*2,44);
            [onceLearnBtn setTitle:LOCALIZATION(@"CompanyInfoViewController_Register") forState:UIControlStateNormal];
            [onceLearnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [onceLearnBtn setBackgroundColor:MainColor];
            [onceLearnBtn addTarget:self action:@selector(onceLearnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            //            loginBtn.titleLabel.font=titleFontSize;
            onceLearnBtn.tag=10001+indexPath.row;
            [cell.contentView addSubview:onceLearnBtn];
            onceLearnBtn.layer.cornerRadius=3;
            onceLearnBtn.layer.masksToBounds=YES;
        }
            break;
        case 0:
        {
            cell.textLabel.text=[NSString stringWithFormat:@"%@",LOCALIZATION(@"CompanyInfoViewController_CompanyName")];
            cNameTF=[[UITextField alloc]initWithFrame:CGRectMake(50+EdgeDis, 0, mainTable.frame.size.width-50-EdgeDis*2, 44)];
            cNameTF.placeholder=LOCALIZATION(@"CompanyInfoViewController_CompanyNameHolder");
            cNameTF.tag=10003;
            cNameTF.textAlignment=NSTextAlignmentRight;
            //                phoneTF.textColor=mainCharaterColor;
            //                phoneTF.font=FontSize13;
            cNameTF.delegate=self;
            [cell.contentView addSubview:cNameTF];
            if ([UserDefault objectForKey:@"CName"]) {
                cNameTF.text=[UserDefault objectForKey:@"CName"];
            }
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
#pragma mark=------addTenantReq
-(void)onceLearnBtnClick:(UIButton*)btn
{
    [self addTenantReq];
}
-(void)addTenantReq
{
    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"CompanyInfoViewController_RegisterLoading") isDismissLater:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:[NSString stringWithFormat:@"%@",cNameTF.text] forKey:@"tenantName"];
        [parameters setObject:[UserDefault objectForKey:@"AName"] forKey:@"linkman"];
        [parameters setObject:[ConFunc DESEncrypt:[UserDefault objectForKey:@"APsw"] WithKey:nil] forKey:@"password"];
        [parameters setObject:[UserDefault objectForKey:@"RPhone"] forKey:@"mobile"];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodAddTenant] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
//            NSLog(@"%@",msg);
            if(success && [data isKindOfClass:[NSDictionary class]]){
//                NSLog(@"%@",data);
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"CompanyInfoViewController_RegisterFinish") isDismissLater:YES];
                AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
                [appDelegate gotoLoginController];
                [UserDefault removeObjectForKey:@"AName"];
                [UserDefault removeObjectForKey:@"APsw"];
                [UserDefault removeObjectForKey:@"ACPsw"];
                
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
    if (textField==cNameTF)
    {
        [UserDefault setObject:cNameTF.text forKey:@"CName"];
    }
    if (textField==addrDTF)
    {
        [UserDefault setObject:addrDTF.text forKey:@"CDaddr"];
    }
}
#pragma mark 处理导航条
-(void)handleNavigationBarItem{
    self.navigationItem.title = LOCALIZATION(@"CompanyInfoViewController_NavTitle");
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
