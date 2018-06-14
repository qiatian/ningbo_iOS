//
//  AmendColleagueViewController.m
//  IM
//
//  Created by ZteCloud on 15/11/4.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "AmendColleagueViewController.h"
#import "SelectEnterpriseDeptViewController.h"
@interface AmendColleagueViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *mainTable;
    UITextField *positionTF;
    UIButton *deleteBtn, *deptBtn;
    UILabel *nameLabel,*phoneLabel;
    UISwitch *sw;
    MEnterpriseDept *selectDept;
}

@end

@implementation AmendColleagueViewController

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
    switch (indexPath.section) {
        case 0:
        {
            NSArray *titles=[NSArray arrayWithObjects:LOCALIZATION(@"NewColleagueViewController_Name"),LOCALIZATION(@"NewColleagueViewController_Mobile"), nil];
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
                nameLabel.text=[NSString stringWithFormat:@"%@",self.amendUser.uname];
            }
            if (indexPath.row==1)
            {
                nameLabel.text=[NSString stringWithFormat:@"%@",self.amendUser.mobile];
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
                [deptBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [deptBtn addTarget:self action:@selector(deptBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:deptBtn];
                if (self.amendUser.cname)
                {
                    [deptBtn setTitle:self.amendUser.cname forState:UIControlStateNormal];
                }
                else
                {
                    [deptBtn setTitle:LOCALIZATION(@"NewColleagueViewController_DeptHolder") forState:UIControlStateNormal];
                }
            }
            if (indexPath.row==1)
            {
                positionTF = [[UITextField alloc]initWithFrame:CGRectMake(50+EdgeDis, 0, mainTable.frame.size.width-50-EdgeDis*2, 44)];
                positionTF.textAlignment=NSTextAlignmentRight;
                positionTF.placeholder=LOCALIZATION(@"NewColleagueViewController_PositionHolder");
                if (self.amendUser.post)
                {
                    positionTF.text=self.amendUser.post;
                }
                [positionTF addTarget:self action:@selector(textFieldTextDidChanged:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:positionTF];
            }
            
        }
            break;
        case 2:
        {
            cell.textLabel.text=LOCALIZATION(@"NewColleagueViewController_Leader");
            cell.textLabel.textColor=[UIColor blackColor];
            sw=[[UISwitch alloc]initWithFrame:CGRectMake(boundsWidth-EdgeDis*4-30, EdgeDis, 30, 30)];
//            [sw addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventValueChanged];
            if ([self.amendUser.groupManager isEqualToString:@"true"])
            {
                sw.on=YES;
            }
            [cell.contentView addSubview:sw];
        }
            break;
        case 3:
        {
            cell.backgroundColor=BGColor;
            deleteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            deleteBtn.frame=CGRectMake(EdgeDis, 0, mainTable.frame.size.width-EdgeDis*2,44);
            [deleteBtn setTitle:LOCALIZATION(@"AmendColleagueViewController_DeleteColleague") forState:UIControlStateNormal];
            [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [deleteBtn setBackgroundColor:[UIColor redColor]];
            [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            deleteBtn.tag=10001+indexPath.row;
            [cell.contentView addSubview:deleteBtn];
            deleteBtn.layer.cornerRadius=3;
            deleteBtn.layer.masksToBounds=YES;
            
            
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
-(void)managerAmendUserDept
{
    WEAKSELF
    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"AmendColleagueViewController_AmendLoding") isDismissLater:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:self.amendUser.uid forKey:@"uid"];
        [parameters setObject:(selectDept.cid)?selectDept.cid:self.amendUser.cid forKey:@"cid"];
        [parameters setObject:positionTF.text forKey:@"position"];
        [parameters setObject:(sw.on)?@"true":@"false" forKey:@"groupManager"];
        [parameters setObject:[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"] forKey:@"token"];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodModifyUserDept] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
//            NSLog(@"%@",msg);
            if(success && [data isKindOfClass:[NSDictionary class]]){
//                NSLog(@"%@",data);
                self.amendUser.post=positionTF.text;
                self.amendUser.cid=(selectDept.cid)?selectDept.cid:self.amendUser.cid;
                self.amendUser.cname=deptBtn.titleLabel.text;
                self.amendUser.groupManager=(sw.on)?@"true":@"false";
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"AmendColleagueViewController_AmendFinish") isDismissLater:YES];
                [[SQLiteManager sharedInstance] insertUsersToSQLite:[NSArray arrayWithObject:weakSelf.amendUser] notificationName:NOTIFICATION_R_SQL_USER];
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
#pragma mark=------deleteBtnClick
-(void)deleteBtnClick:(UIButton*)btn
{
    
    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"AmendColleagueViewController_DeleteLoding") isDismissLater:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:self.amendUser.uid forKey:@"uid"];
        [parameters setObject:[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"] forKey:@"token"];
        
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodDeleteUser] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
//            NSLog(@"%@",msg);
            if(success && [data isKindOfClass:[NSDictionary class]]){
                NSLog(@"%@",data);
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"AmendColleagueViewController_DeleteFinish") isDismissLater:YES];
                [[SQLiteManager sharedInstance] deleteUserId:[NSString stringWithFormat:@"%@",self.amendUser.uid]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_D_SQL_USER object:nil];
                });
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
-(void)confirmAddTenantReqWithAgree:(NSString*)agree
{
    
}

#pragma mark------textfield delegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==positionTF)
    {
        [UserDefault setObject:positionTF.text forKey:@"Position"];
    }
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location>10) {
        return NO;
    }
    NSString *toBeString=[textField.text stringByReplacingCharactersInRange:range withString:string];
    if (positionTF==textField) {
        if ([toBeString length]>10) {
            textField.text=[toBeString substringToIndex:10];
            [self.view endEditing:YES];
            [self.view makeToast:LOCALIZATION(@"NewColleagueViewController_PositionLimit")];
            return NO;
        }
    }
    return YES;
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
    self.navigationItem.title = LOCALIZATION(@"AmendColleagueViewController_NavTitle");
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    ILBarButtonItem *rigthItem=[ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_save.png"] highlightedImage:[UIImage imageNamed:@"nav_save.png"] target:self action:@selector(clickRightItem:)];
    [self.navigationItem setRightBarButtonItem:rigthItem];
}
-(void)clickLeftItem:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)clickRightItem:(id)sender{
    NSLog(@"确定修改");
    [self managerAmendUserDept];
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
