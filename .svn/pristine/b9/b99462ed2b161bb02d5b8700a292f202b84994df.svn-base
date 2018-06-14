//
//  AmendDepartmentViewController.m
//  IM
//
//  Created by ZteCloud on 15/11/4.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "AmendDepartmentViewController.h"
#import "SelectEnterpriseDeptViewController.h"
@interface AmendDepartmentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *mainTable;
    UITextField *deptTF,*fDeptTF;
    UILabel *fDeptLabel;
    UIButton *deleteBtn,*codeBtn;
    MEnterpriseDept *selectDept;
}

@end

@implementation AmendDepartmentViewController

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
    [deptTF resignFirstResponder];
    [fDeptTF resignFirstResponder];
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
            NSArray *titles=[NSArray arrayWithObjects:LOCALIZATION(@"NewDepartmentViewController_DeptName"),LOCALIZATION(@"NewDepartmentViewController_ofDept"), nil];
            cell.textLabel.text=[titles objectAtIndex:indexPath.row];
            UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 43, mainTable.frame.size.width, 0.5)];
            lineLabel.backgroundColor=RGBColor(195, 195, 195);
            lineLabel.tag=10004;
            [cell.contentView addSubview:lineLabel];
            if (indexPath.row==0)
            {
                deptTF=[[UITextField alloc]initWithFrame:CGRectMake(50+EdgeDis, 0, mainTable.frame.size.width-50-EdgeDis*2, 44)];
                deptTF.placeholder=LOCALIZATION(@"NewDepartmentViewController_DeptHolder");
                deptTF.tag=10003;
                deptTF.textAlignment=NSTextAlignmentRight;
                deptTF.delegate=self;
                [deptTF addTarget:self action:@selector(textFieldTextDidChanged:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:deptTF];
                
                if ([UserDefault objectForKey:@"DeptName"])
                {
                    deptTF.text=[UserDefault objectForKey:@"DeptName"];
                }
                else
                {
                    deptTF.text=[NSString stringWithFormat:@"%@",self.dept.cname];
                }
                
            }
            if (indexPath.row==1)
            {
                UIImageView *arrowImg=[[UIImageView alloc]initWithFrame:CGRectMake(boundsWidth-30, EdgeDis, 30, 30)];
                arrowImg.image=[UIImage imageNamed:@"arrow_come"];
                [cell.contentView addSubview:arrowImg];
//                NSLog(@"%f",cell.textLabel.frame.size.width);
                fDeptLabel=[[UILabel alloc]initWithFrame:CGRectMake(50+EdgeDis, 0, mainTable.frame.size.width-50-EdgeDis*2-30, 44)];
                fDeptLabel.tag=10003;
                fDeptLabel.textAlignment=NSTextAlignmentRight;
                [cell.contentView addSubview:fDeptLabel];
                if (self.dept.pid)
                {
                    fDeptLabel.text=[NSString stringWithFormat:@"%@",self.leaderDept];
                }
            }
            
        }
            break;
        case 1:
        {
            cell.backgroundColor=BGColor;
            deleteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            deleteBtn.frame=CGRectMake(EdgeDis, 0, mainTable.frame.size.width-EdgeDis*2,44);
            [deleteBtn setTitle:LOCALIZATION(@"AmendDepartmentViewController_DeleteDept") forState:UIControlStateNormal];
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1)
    {
        SelectEnterpriseDeptViewController *selectDeptVC =[[SelectEnterpriseDeptViewController alloc] init];
        GQNavigationController *selectDeptVCNav =[[GQNavigationController alloc] initWithRootViewController:selectDeptVC];
        [self presentViewController:selectDeptVCNav animated:YES completion:^{
            
        }];
        selectDeptVC.selectBlock=^(MEnterpriseDept *sDept){
//            NSLog(@"%@",sDept);
            selectDept=sDept;
            fDeptLabel.text=[NSString stringWithFormat:@"%@",sDept.cname];
            
            
        };
    }
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
#pragma mark--------删除

-(void)deleteBtnClick:(UIButton*)btn
{
    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"AmendDepartmentViewController_DeleLoding") isDismissLater:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:self.dept.cid forKey:@"cid"];
        [parameters setObject:[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"] forKey:@"token"];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodDeleteDept] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
//            NSLog(@"%@",msg);
            if(success && [data isKindOfClass:[NSDictionary class]]){
//                NSLog(@"%@",data);
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"AmendDepartmentViewController_DeleFinish") isDismissLater:YES];
                [[SQLiteManager sharedInstance] deleteDeptWithId:self.dept.cid];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_D_SQL_DEPT object:nil];
                });
                [self clickLeftItem:nil];
                
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
    if (textField==deptTF)
    {
        [UserDefault setObject:deptTF.text forKey:@"DeptName"];
    }
    if (textField==fDeptTF)
    {
        [UserDefault setObject:fDeptTF.text forKey:@""];
    }
}
-(void)textFieldTextDidChanged:(UITextField*)textfield
{
    UITextRange *selectedRange = [textfield markedTextRange];
    NSString * newText = [textfield textInRange:selectedRange];
    //获取高亮部分
    if(newText.length>0)
        return;
    
    if ([deptTF.text length]>10) {
        dispatch_async(dispatch_get_main_queue(), ^{
            deptTF.text=[deptTF.text substringToIndex:10];
            [self.view endEditing:YES];
            [self.view makeToast:LOCALIZATION(@"NewDepartmentViewController_DeptNameLimit")];
        });
        
    }
    
}
#pragma mark 处理导航条
-(void)handleNavigationBarItem{
    self.navigationItem.title = LOCALIZATION(@"AmendDepartmentViewController_NavTitle");
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    ILBarButtonItem *rigthItem=[ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_save.png"] highlightedImage:[UIImage imageNamed:@"nav_save.png"] target:self action:@selector(clickRightItem:)];
    [self.navigationItem setRightBarButtonItem:rigthItem];
}
-(void)clickLeftItem:(id)sender{
    [UserDefault removeObjectForKey:@"DeptName"];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)clickRightItem:(id)sender{
    NSLog(@"确定修改");
    WEAKSELF
    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"AmendDepartmentViewController_AmendLoding") isDismissLater:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:self.dept.cid forKey:@"cid"];
        [parameters setObject:(selectDept.cid)?selectDept.cid:self.dept.pid forKey:@"pid"];
        [parameters setObject:deptTF.text forKey:@"groupName"];
        [parameters setObject:[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"] forKey:@"token"];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodUpdateDept] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
//            NSLog(@"%@",msg);
            if(success && [data isKindOfClass:[NSDictionary class]]){
//                NSLog(@"%@",data);
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"AmendDepartmentViewController_AmendFinish") isDismissLater:YES];
                NSString *newPid=(selectDept.cid)?selectDept.cid:self.dept.pid;
                self.dept.pid=newPid;
                self.dept.cname=deptTF.text;
                [[SQLiteManager sharedInstance] insertDeptsToSQLite:[NSArray arrayWithObjects:weakSelf.dept, nil]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_R_SQL_DEPT object:nil];
                });
                [self clickLeftItem:nil];
                
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
