//
//  ApproveDetailViewController.m
//  IM
//
//  Created by ZteCloud on 15/10/21.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "ApproveDetailViewController.h"
#import "SelectEnterpriseDeptViewController.h"
@interface ApproveDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *mainTable;
    UITextField *positionTF;
    UIButton *aBtn, *deptBtn;
    UILabel *nameLabel,*phoneLabel;
    UISwitch *sw;
    MEnterpriseDept *selectDept;
}

@end

@implementation ApproveDetailViewController

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
    cell.textLabel.textColor=ContentColor;
    switch (indexPath.section) {
        case 0:
        {
            NSArray *titles=[NSArray arrayWithObjects:@"姓  名",@"手  机", nil];
            cell.textLabel.text=[titles objectAtIndex:indexPath.row];
            UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 43, mainTable.frame.size.width, 0.5)];
            lineLabel.backgroundColor=RGBColor(195, 195, 195);
            lineLabel.tag=10004;
            [cell.contentView addSubview:lineLabel];
            nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50+EdgeDis, 0, mainTable.frame.size.width-50-EdgeDis*2, 44)];
            nameLabel.textAlignment=NSTextAlignmentRight;
            [cell.contentView addSubview:nameLabel];
            if (indexPath.row==0)
            {
                nameLabel.text=[NSString stringWithFormat:@"%@",self.cm.name];
            }
            if (indexPath.row==1)
            {
                nameLabel.text=[NSString stringWithFormat:@"%@",self.cm.mobile];
            }
            
        }
            break;
        case 1:
        {
            NSArray *titles=[NSArray arrayWithObjects:@"部  门",@"职  位", nil];
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
                [deptBtn setTitle:@"请选择部门" forState:UIControlStateNormal];
                [deptBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                if ([self.cm.status isEqualToString:@"CREATED"])
                {
                  [deptBtn addTarget:self action:@selector(deptBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                }
                if ([self.cm.status isEqualToString:@"APPROVED"]) {
                    [deptBtn setTitle:[NSString stringWithFormat:@"%@",self.cm.cname] forState:UIControlStateNormal];
                }
                
                [cell.contentView addSubview:deptBtn];
            }
            if (indexPath.row==1)
            {
                positionTF = [[UITextField alloc]initWithFrame:CGRectMake(50+EdgeDis, 0, mainTable.frame.size.width-50-EdgeDis*2, 44)];
                positionTF.textAlignment=NSTextAlignmentRight;
                positionTF.placeholder=@"请输入职位";
                if (self.cm.position)
                {
                    positionTF.text=self.cm.position;
                }
                [cell.contentView addSubview:positionTF];
                if ([self.cm.status isEqualToString:@"CREATED"])
                {
                    positionTF.userInteractionEnabled=YES;
                    [positionTF addTarget:self action:@selector(textFieldTextDidChanged:) forControlEvents:UIControlEventEditingChanged];
                }
                else
                {
                    positionTF.userInteractionEnabled=NO;
                }
            }
            
        }
            break;
        case 2:
        {
            cell.textLabel.text=@"领  导";
            cell.textLabel.textColor=[UIColor blackColor];
            sw=[[UISwitch alloc]initWithFrame:CGRectMake(boundsWidth-EdgeDis*3-30, EdgeDis, 30, 30)];
//            sw.tintColor=MainColor;
            [sw addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventEditingChanged];
            if ([self.cm.groupManager isEqualToString:@"true"])
            {
                sw.on=YES;
                sw.userInteractionEnabled=NO;
            }
            if ([self.cm.status isEqualToString:@"CREATED"])
            {
                sw.userInteractionEnabled=YES;
            }
            else
            {
                sw.userInteractionEnabled=NO;
            }
            [cell.contentView addSubview:sw];
        }
            break;
        case 3:
        {
            cell.backgroundColor=BGColor;
            if ([self.cm.status isEqualToString:@"CREATED"])
            {
                NSArray *titles=[NSArray arrayWithObjects:@"同意",@"拒绝", nil];
                NSArray *colors=[NSArray arrayWithObjects:GreenColor,RedColor, nil];
                for (int i=0; i<2; i++)
                {
                    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame=CGRectMake(EdgeDis+mainTable.frame.size.width/2*i, 0, (mainTable.frame.size.width-EdgeDis*4)/2,44);
                    [btn setTitle:[NSString stringWithFormat:@"%@",titles[i]] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [btn setBackgroundColor:colors[i]];
                    [btn addTarget:self action:@selector(agreeOrRejectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    btn.tag=10001+i;
                    [cell.contentView addSubview:btn];
                    btn.layer.cornerRadius=3;
                    btn.layer.masksToBounds=YES;
                }
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
#pragma mark--------switchBtnClick:
-(void)switchBtnClick:(UISwitch*)sw1
{
    sw1.on=!sw1.on;
}
#pragma mark--------deptBtnClick
-(void)deptBtnClick:(UIButton*)btn
{
    SelectEnterpriseDeptViewController *selectDeptVC =[[SelectEnterpriseDeptViewController alloc] init];
//    selectUserVC.selectGroupUsers = YES;
//    [selectUserVC setSelectBlock:^(NSArray *responseArray){
//        CreatNotiViewController *vc = [[CreatNotiViewController alloc] init];
//        [vc setSuccessBlock:^{
//            [self getNotisFromServer];
//        }];
//        [vc.userArray addObjectsFromArray:responseArray];
//        [self.navigationController pushViewController:vc animated:YES];
//    }];
    GQNavigationController *selectDeptVCNav =[[GQNavigationController alloc] initWithRootViewController:selectDeptVC];
    [self presentViewController:selectDeptVCNav animated:YES completion:^{
        
    }];
    selectDeptVC.selectBlock=^(MEnterpriseDept *sDept){
//        NSLog(@"%@",sDept);
        selectDept=sDept;
        [deptBtn setTitle:[NSString stringWithFormat:@"%@",sDept.cname] forState:UIControlStateNormal];
        
    
    };
    NSLog(@"选择部门");
}
#pragma mark=------agreeOrRejectBtnClick
-(void)agreeOrRejectBtnClick:(UIButton*)btn
{
    if (btn.tag==10001)
    {
        if ([deptBtn.titleLabel.text isEqualToString:@"请选择部门"])
        {
            [MMProgressHUD showHUDWithTitle:@"请选择部门" isDismissLater:YES];
            return;
        }
        if ([positionTF.text isEqualToString:@""])
        {
            [MMProgressHUD showHUDWithTitle:@"请输入职位" isDismissLater:YES];
            return;
        }
    }
    [self confirmAddTenantReqWithAgree:(btn.tag==10001)?@"true":@"false"];
    
    
}
-(void)confirmAddTenantReqWithAgree:(NSString*)agree
{
    [MMProgressHUD showHUDWithTitle:@"正在审批..." isDismissLater:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:(selectDept)?[NSString stringWithFormat:@"%@",selectDept.cid]:@"" forKey:@"cid"];
        [parameters setObject:[NSString stringWithFormat:@"%@",self.cm.sessionId] forKey:@"sessionId"];
        [parameters setObject:[NSString stringWithFormat:@"%@",positionTF.text]forKey:@"position"];
        [parameters setObject:(sw.on)?@"true":@"false" forKey:@"groupManager"];
        [parameters setObject:agree forKey:@"status"];
        [parameters setObject:[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"] forKey:@"token"];

        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodRegConfirmAddTenant] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
//            NSLog(@"%@",msg);
            if(success && [data isKindOfClass:[NSDictionary class]]){
//                NSLog(@"%@",data);
                if (data[@"item"][@"adminStatus"])
                {
                    [MMProgressHUD showHUDWithTitle:@"审批成功" isDismissLater:YES];
                }
                else
                {
                    [MMProgressHUD showHUDWithTitle:@"残忍拒绝" isDismissLater:YES];
                }
                [NotiCenter postNotificationName:@"ChangeApprove" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD showHUDWithTitle:msg isDismissLater:YES];
                });
            }
        } failureBlock:^(NSString *description) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MMProgressHUD showHUDWithTitle:@"网络请求失败" isDismissLater:YES];
            });
        }];
    });
}
#pragma mark------textfield delegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==positionTF)
    {
        [UserDefault setObject:positionTF.text forKey:@"Position"];
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
#pragma mark 处理导航条
-(void)handleNavigationBarItem{
    self.navigationItem.title = @"加入审批";
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
