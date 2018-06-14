//
//  NewDepartmentViewController.m
//  IM
//
//  Created by ZteCloud on 15/11/2.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "NewDepartmentViewController.h"
#import "SelectEnterpriseDeptViewController.h"
@interface NewDepartmentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *mainTable;
    UITextField *deptTF;
    UILabel *fDeptLabel;
    UIButton *startBtn;
    MEnterpriseDept *selectDept;
}


@end

@implementation NewDepartmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [NotiCenter addObserver:self selector:@selector(textFieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:deptTF];
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
                deptTF=[[UITextField alloc]initWithFrame:CGRectMake(50+EdgeDis*3, 0, mainTable.frame.size.width-50-EdgeDis*4, 44)];
                deptTF.placeholder=LOCALIZATION(@"NewDepartmentViewController_DeptHolder");
                deptTF.tag=10003;
                deptTF.textAlignment=NSTextAlignmentRight;
                //                phoneTF.textColor=mainCharaterColor;
                //                phoneTF.font=FontSize13;
                deptTF.delegate=self;
                [deptTF addTarget:self action:@selector(textFieldTextDidChanged:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:deptTF];
                
                if ([UserDefault objectForKey:@"NewDept"])
                {
                    deptTF.text=[UserDefault objectForKey:@"NewDept"];
                }
                
            }
            if (indexPath.row==1)
            {
                UIImageView *arrowImg=[[UIImageView alloc]initWithFrame:CGRectMake(boundsWidth-30, EdgeDis, 30, 30)];
                arrowImg.image=[UIImage imageNamed:@"arrow_come"];
                [cell.contentView addSubview:arrowImg];
                NSLog(@"%f",cell.textLabel.frame.size.width);
                fDeptLabel=[[UILabel alloc]initWithFrame:CGRectMake(50+EdgeDis*5, 0, mainTable.frame.size.width-50-EdgeDis*4-30, 44)];
                fDeptLabel.tag=10003;
                fDeptLabel.text=[NSString stringWithFormat:@"%@",self.leaderDept.cname];
                fDeptLabel.textAlignment=NSTextAlignmentRight;
                [cell.contentView addSubview:fDeptLabel];
             
            }
            
        }
            break;
        case 1:
        {
            cell.backgroundColor=BGColor;
            startBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            startBtn.frame=CGRectMake(EdgeDis, 0, mainTable.frame.size.width-EdgeDis*2,44);
            [startBtn setTitle:LOCALIZATION(@"NewDepartmentViewController_Confirm") forState:UIControlStateNormal];
            [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [startBtn setBackgroundColor:MainColor];
            [startBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            //            loginBtn.titleLabel.font=titleFontSize;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1)
    {
        SelectEnterpriseDeptViewController *selectDeptVC =[[SelectEnterpriseDeptViewController alloc] init];
        GQNavigationController *selectDeptVCNav =[[GQNavigationController alloc] initWithRootViewController:selectDeptVC];
        [self presentViewController:selectDeptVCNav animated:YES completion:^{
            
        }];
        selectDeptVC.selectBlock=^(MEnterpriseDept *sDept){
            NSLog(@"%@",sDept);
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
#pragma mark--------立即开通

-(void)startBtnClick:(UIButton*)btn
{
    if ([deptTF.text isEqualToString:@""])
    {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"NewDepartmentViewController_DeptHolder") isDismissLater:YES];
        return;
    }
    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"NewDepartmentViewController_Loading") isDismissLater:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:deptTF.text forKey:@"groupName"];
        [parameters setObject:(selectDept.pid)?selectDept.cid:self.leaderDept.cid forKey:@"pid"];
        [parameters setObject:[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"] forKey:@"token"];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodAddDept] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
//            NSLog(@"%@",msg);
            if(success && [data isKindOfClass:[NSDictionary class]]){
//                NSLog(@"%@",data);
                [MMProgressHUD showHUDWithTitle:data[@"res"][@"resMessage"] isDismissLater:YES];
                MEnterpriseDept *newDept=[[MEnterpriseDept alloc]init];
                newDept.cid=data[@"group"][@"cid"];
                newDept.cname=data[@"group"][@"name"];
                newDept.pid=data[@"group"][@"pid"];
                newDept.pname=data[@"group"][@"pname"];
                newDept.gid=data[@"group"][@"gid"];
                newDept.isroot=data[@"group"][@"isroot"];
                [[SQLiteManager sharedInstance] insertDeptsToSQLite:[NSArray arrayWithObjects:newDept, nil]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_R_SQL_DEPT object:nil];
                });
                [UserDefault removeObjectForKey:@"NewDept"];
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
    if (textField==deptTF&&![deptTF.text isEqualToString:@""])
    {
        [UserDefault setObject:deptTF.text forKey:@"NewDept"];
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
    self.navigationItem.title =LOCALIZATION(@"EnterpriseMangerViewController_NewDept");
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
}
-(void)clickLeftItem:(id)sender{
    deptTF.delegate=nil;
    [UserDefault removeObjectForKey:@"NewDept"];
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
