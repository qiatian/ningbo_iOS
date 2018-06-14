//
//  NewColleagueViewController.m
//  IM
//
//  Created by ZteCloud on 15/11/2.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "NewColleagueViewController.h"
#import "SelectEnterpriseDeptViewController.h"
@interface NewColleagueViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *mainTable;
    UITextField *positionTF,*nameTF,*phoneTF;
    UIButton *aBtn,*startBtn, *deptBtn;
    UISwitch *sw;
    MEnterpriseDept *selectDept;
}

@end

@implementation NewColleagueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [NotiCenter addObserver:self selector:@selector(textFieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
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
    [positionTF resignFirstResponder];
    [nameTF resignFirstResponder];
    [phoneTF resignFirstResponder];
}
#pragma mark------tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section<2) {
        return 2;
    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
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
            NSArray *titles=[NSArray arrayWithObjects:LOCALIZATION(@"NewColleagueViewController_Name"),LOCALIZATION(@"NewColleagueViewController_Mobile"), nil];
            cell.textLabel.text=[titles objectAtIndex:indexPath.row];
            UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 43, mainTable.frame.size.width, 0.5)];
            lineLabel.backgroundColor=RGBColor(195, 195, 195);
            lineLabel.tag=10004;
            [cell.contentView addSubview:lineLabel];
            if (indexPath.row==0)
            {
                nameTF=[[UITextField alloc]initWithFrame:CGRectMake(50+EdgeDis, 0, mainTable.frame.size.width-50-EdgeDis*2, 44)];
                nameTF.placeholder=LOCALIZATION(@"NewColleagueViewController_NameHolder");
                nameTF.textColor=ContentColor;
                nameTF.tag=10003+indexPath.row;
                nameTF.textAlignment=NSTextAlignmentRight;
                nameTF.delegate=self;
                [nameTF addTarget:self action:@selector(nameTextFieldTextDidChanged:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:nameTF];
                if ([UserDefault objectForKey:@"ColleagueName"])
                {
                    nameTF.text=[UserDefault objectForKey:@"ColleagueName"];
                }
            }
            if (indexPath.row==1)
            {
                phoneTF=[[UITextField alloc]initWithFrame:CGRectMake(50+EdgeDis, 0, mainTable.frame.size.width-50-EdgeDis*2, 44)];
                phoneTF.placeholder=LOCALIZATION(@"NewColleagueViewController_MobileHolder");
                phoneTF.textColor=ContentColor;
                phoneTF.tag=10003+indexPath.row;
                phoneTF.textAlignment=NSTextAlignmentRight;
                phoneTF.delegate=self;
                [cell.contentView addSubview:phoneTF];
                if ([UserDefault objectForKey:@"ColleaguePhone"])
                {
                    phoneTF.text=[UserDefault objectForKey:@"ColleaguePhone"];
                }
            }
            
            
        }
            break;
        case 1:
        {
            NSArray *titles=[NSArray arrayWithObjects:LOCALIZATION(@"NewColleagueViewController_Dept"),LOCALIZATION(@"NewColleagueViewController_Position"), nil];
            cell.textLabel.text=[titles objectAtIndex:indexPath.row];
            UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 43, mainTable.frame.size.width, 0.5)];
            lineLabel.backgroundColor=RGBColor(195, 195, 195);
            lineLabel.tag=10004;
            [cell.contentView addSubview:lineLabel];
            
            if (indexPath.row==0)
            {
                UIImageView *arrowImg=[[UIImageView alloc]initWithFrame:CGRectMake(boundsWidth-30, EdgeDis, 30, 30)];
                arrowImg.image=[UIImage imageNamed:@"arrow_come"];
                [cell.contentView addSubview:arrowImg];
                deptBtn=[UIButton buttonWithType:UIButtonTypeCustom];
                deptBtn.frame=CGRectMake(boundsWidth-EdgeDis-20-90, 0, 90, 44);
                [deptBtn setTitle:LOCALIZATION(@"NewColleagueViewController_DeptHolder") forState:UIControlStateNormal];
                deptBtn.tag=10001+indexPath.row;
                [deptBtn addTarget:self action:@selector(deptBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [deptBtn setTitleColor:ContentColor forState:UIControlStateNormal];
                [cell.contentView addSubview:deptBtn];
                if ([UserDefault objectForKey:@"ColleagueDept"])
                {
                    [deptBtn setTitle:[UserDefault objectForKey:@"ColleagueDept"] forState:UIControlStateNormal];
                }
            }
            if (indexPath.row==1)
            {
                positionTF = [[UITextField alloc]initWithFrame:CGRectMake(50+EdgeDis, 0, mainTable.frame.size.width-50-EdgeDis*2, 44)];
                positionTF.textAlignment=NSTextAlignmentRight;
                positionTF.placeholder=LOCALIZATION(@"NewColleagueViewController_PositionHolder");
                positionTF.tag=10001+indexPath.row;
                [positionTF addTarget:self action:@selector(textFieldTextDidChanged:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:positionTF];
                if ([UserDefault objectForKey:@"ColleaguePosition"])
                {
                    phoneTF.text=[UserDefault objectForKey:@"ColleaguePosition"];
                }
            }
            
        }
            break;
        case 2:
        {
            cell.textLabel.text=LOCALIZATION(@"NewColleagueViewController_Leader");
            sw=[[UISwitch alloc]initWithFrame:CGRectMake(boundsWidth-EdgeDis*3-30, EdgeDis, 30, 30)];
            //            sw.tintColor=MainColor;
//            [sw addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:sw];
        }
            break;
        case 3:
        {
            cell.backgroundColor=BGColor;
            startBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            startBtn.frame=CGRectMake(EdgeDis, 0, mainTable.frame.size.width-EdgeDis*2,44);
            [startBtn setTitle:LOCALIZATION(@"NewDepartmentViewController_Confirm") forState:UIControlStateNormal];
            [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [startBtn setBackgroundColor:MainColor];
            [startBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            startBtn.tag=10001+indexPath.row;
            [cell.contentView addSubview:startBtn];
            startBtn.layer.cornerRadius=3;
            startBtn.layer.masksToBounds=YES;
            
            
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
#pragma mark--------switchBtnClick:
-(void)switchBtnClick:(UISwitch*)sw1
{
    sw1.on=!sw1.on;
}
#pragma mark-----startBtnClick
-(void)startBtnClick:(UIButton*)btn
{
    if ([nameTF.text isEqualToString:@""])
    {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"NewColleagueViewController_NameHolder") isDismissLater:YES];
        return;
    }
    if ([phoneTF.text isEqualToString:@""])
    {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"NewColleagueViewController_MobileHolder") isDismissLater:YES];
        return;
    }
    if ([deptBtn.titleLabel.text isEqualToString:LOCALIZATION(@"NewColleagueViewController_DeptHolder")])
    {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"NewColleagueViewController_DeptHolder") isDismissLater:YES];
        return;
    }
    [self addUserReqWithBtn:btn];
}
#pragma mark--------deptBtnClick
-(void)deptBtnClick:(UIButton*)btn
{
    SelectEnterpriseDeptViewController *selectDeptVC =[[SelectEnterpriseDeptViewController alloc] init];
    GQNavigationController *selectDeptVCNav =[[GQNavigationController alloc] initWithRootViewController:selectDeptVC];
    [self presentViewController:selectDeptVCNav animated:YES completion:^{
        
    }];
    selectDeptVC.selectBlock=^(MEnterpriseDept *sDept){
        NSLog(@"%@",sDept);
        selectDept=sDept;
        [deptBtn setTitle:[NSString stringWithFormat:@"%@",sDept.cname] forState:UIControlStateNormal];
        [UserDefault setObject:[NSString stringWithFormat:@"%@",sDept.cname] forKey:@"ColleagueDept"];
    };
    NSLog(@"选择部门");
}
-(void)addUserReqWithBtn:(UIButton*)btn
{
    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"NewColleagueViewController_Loading") isDismissLater:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:nameTF.text forKey:@"name"];
        [parameters setObject:selectDept.cid forKey:@"cid"];
        [parameters setObject:positionTF.text forKey:@"position"];
        [parameters setObject:phoneTF.text forKey:@"mobile"];
        [parameters setObject:(sw.on)?@"true":@"false" forKey:@"groupManager"];
        [parameters setObject:[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"] forKey:@"token"];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodAddUser] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
//            NSLog(@"%@",msg);
            if(success && [data isKindOfClass:[NSDictionary class]]){
//                NSLog(@"%@",data);
                NSDictionary *items=[data objectForKey:@"item"];
                MEnterpriseUser *newUser=[[MEnterpriseUser alloc] init];
                newUser.cid =[items objectForKey:@"cid"];
                newUser.cname =[items objectForKey:@"cname"];
                newUser.groupManager =[items objectForKey:@"groupManager"];
                newUser.uname =[items objectForKey:@"name"];
                newUser.post =[items objectForKey:@"position"];
                newUser.uid =[items objectForKey:@"uid"];
                newUser.mobile=[items objectForKey:@"mobile"];
                newUser.gid=[[ConfigManager sharedInstance].userDictionary objectForKey:@"gid"];
                NSMutableArray *enterpriseUsers =[[NSMutableArray alloc] init];
                [enterpriseUsers addObject:newUser];
                [[SQLiteManager sharedInstance] insertUsersToSQLite:enterpriseUsers notificationName:NOTIFICATION_R_SQL_USER];
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"NewColleagueViewController_Finish") isDismissLater:YES];
                [self clickLeftItem:btn];
                
                
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
    if (textField==positionTF)
    {
        [UserDefault setObject:positionTF.text forKey:@"ColleaguePosition"];
    }
    if (textField==nameTF)
    {
        [UserDefault setObject:nameTF.text forKey:@"ColleagueName"];
    }
    if (textField==phoneTF)
    {
        [UserDefault setObject:phoneTF.text forKey:@"ColleaguePhone"];
    }
}
-(void)textFieldTextDidChanged:(UITextField*)textfield
{
    UITextRange *selectedRange = [textfield markedTextRange];
    NSString * newText = [textfield textInRange:selectedRange];
    //获取高亮部分
    if(newText.length>0)
        return;
    if ([positionTF.text length]>10) {
        dispatch_async(dispatch_get_main_queue(), ^{
            positionTF.text=[positionTF.text substringToIndex:10];
            [self.view endEditing:YES];
            [self.view makeToast:LOCALIZATION(@"NewColleagueViewController_PositionLimit")];
        });
        
        
    }
}
-(void)nameTextFieldTextDidChanged:(UITextField*)textfield
{
    UITextRange *selectedRange = [textfield markedTextRange];
    NSString * newText = [textfield textInRange:selectedRange];
    //获取高亮部分
    if(newText.length>0)
        return;
    if ([nameTF.text length]>10) {
        dispatch_async(dispatch_get_main_queue(), ^{
            nameTF.text=[nameTF.text substringToIndex:10];
            [self.view endEditing:YES];
            [self.view makeToast:LOCALIZATION(@"NewColleagueViewController_NameLimit")];
        });
    }
}
#pragma mark 处理导航条
-(void)handleNavigationBarItem{
    self.navigationItem.title = LOCALIZATION(@"EnterpriseMangerViewController_NewColleague");
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
}
-(void)clickLeftItem:(id)sender{
    [UserDefault removeObjectForKey:@"ColleagueName"];
    [UserDefault removeObjectForKey:@"ColleaguePhone"];
    [UserDefault removeObjectForKey:@"ColleagueDept"];
    [UserDefault removeObjectForKey:@"ColleaguePosition"];
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
