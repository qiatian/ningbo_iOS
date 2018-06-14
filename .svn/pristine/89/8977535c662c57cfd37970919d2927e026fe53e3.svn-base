//
//  AcountInfoViewController.m
//  IM
//
//  Created by ZteCloud on 15/10/12.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "AcountInfoViewController.h"
#import "ConnectEnterpriseViewController.h"
@interface AcountInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *mainTable;
    UITextField *nameTF,*pswTF,*confirmPswTF;
    UIButton *nextBtn;
}

@end

@implementation AcountInfoViewController

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
    [nameTF resignFirstResponder];
    [confirmPswTF resignFirstResponder];
}
#pragma mark------tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        return 2;
    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
            NSArray *titles=[NSArray arrayWithObjects:LOCALIZATION(@"AcountInfoViewController_Paw"),LOCALIZATION(@"AcountInfoViewController_Confirm"), nil];
            cell.textLabel.text=[titles objectAtIndex:indexPath.row];
            UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 43, mainTable.frame.size.width, 0.5)];
            lineLabel.backgroundColor=RGBColor(195, 195, 195);
            lineLabel.tag=10004;
            [cell.contentView addSubview:lineLabel];
            if (indexPath.row==0)
            {
                pswTF=[[UITextField alloc]initWithFrame:CGRectMake(50+EdgeDis, 0, mainTable.frame.size.width-50-EdgeDis*2, 44)];
                pswTF.placeholder=LOCALIZATION(@"AcountInfoViewController_PawHolder");
                pswTF.tag=10003;
                pswTF.textAlignment=NSTextAlignmentRight;
                //                phoneTF.textColor=mainCharaterColor;
                //                phoneTF.font=FontSize13;
                pswTF.delegate=self;
                pswTF.secureTextEntry=YES;
                [cell.contentView addSubview:pswTF];
                if ([UserDefault objectForKey:@"APsw"])
                {
                    pswTF.text=[UserDefault objectForKey:@"APsw"];
//                    NSLog(@"%@",pswTF.text);
                }
                
            }
            if (indexPath.row==1)
            {
//                NSLog(@"%f",cell.textLabel.frame.size.width);
                confirmPswTF=[[UITextField alloc]initWithFrame:CGRectMake(50+EdgeDis, 0, mainTable.frame.size.width-50-EdgeDis*2, 44)];
                confirmPswTF.placeholder=LOCALIZATION(@"AcountInfoViewController_ConfirmHolder");
                confirmPswTF.tag=10003;
                confirmPswTF.textAlignment=NSTextAlignmentRight;
                //                pwsTF.textColor=mainCharaterColor;
                //                pwsTF.font=FontSize13;
                confirmPswTF.secureTextEntry=YES;
                confirmPswTF.delegate=self;
                [cell.contentView addSubview:confirmPswTF];
                if ([UserDefault objectForKey:@"ACPsw"])
                {
                    confirmPswTF.text=[UserDefault objectForKey:@"ACPsw"];
                }
            }
            
        }
            break;
        case 2:
        {
            cell.backgroundColor=BGColor;
            nextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            nextBtn.frame=CGRectMake(EdgeDis, 0, mainTable.frame.size.width-EdgeDis*2,44);
            [nextBtn setTitle:LOCALIZATION(@"AcountInfoViewController_Next") forState:UIControlStateNormal];
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
        case 0:
        {
            cell.textLabel.text=[NSString stringWithFormat:@"%@",LOCALIZATION(@"AcountInfoViewController_Name")];
            nameTF=[[UITextField alloc]initWithFrame:CGRectMake(50+EdgeDis, 0, mainTable.frame.size.width-50-EdgeDis*2, 44)];
            nameTF.placeholder=LOCALIZATION(@"AcountInfoViewController_NameHolder");
            nameTF.tag=10003;
            nameTF.textAlignment=NSTextAlignmentRight;
            //                phoneTF.textColor=mainCharaterColor;
            //                phoneTF.font=FontSize13;
            nameTF.delegate=self;
            [cell.contentView addSubview:nameTF];
            if ([UserDefault objectForKey:@"AName"])
            {
                nameTF.text=[UserDefault objectForKey:@"AName"];
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
#pragma mark=------toNext
-(void)toNext:(UIButton*)btn
{
    if ([nameTF.text isEqualToString:@""])
    {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"AcountInfoViewController_NameHolder") isDismissLater:YES];
        return;
    }
    if ([pswTF.text isEqualToString:@""])
    {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"AcountInfoViewController_PawHolder") isDismissLater:YES];
        return;
    }
    if ([confirmPswTF.text isEqualToString:@""])
    {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"AcountInfoViewController_ConfirmHolder") isDismissLater:YES];
        return;
    }
    ConnectEnterpriseViewController *cvc=[[ConnectEnterpriseViewController alloc]init];
    [self.navigationController pushViewController:cvc animated:YES];
}
#pragma mark------textfield delegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==nameTF)
    {
        [UserDefault setObject:nameTF.text forKey:@"AName"];
    }
    if (textField==pswTF)
    {
        [UserDefault setObject:pswTF.text forKey:@"APsw"];
    }
    if (textField==confirmPswTF)
    {
        [UserDefault setObject:confirmPswTF.text forKey:@"ACPsw"];
    }
}
#pragma mark 处理导航条
-(void)handleNavigationBarItem{
    self.navigationItem.title = LOCALIZATION(@"AcountInfoViewController_NavTitle");
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
}
-(void)clickLeftItem:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    [UserDefault removeObjectForKey:@"AName"];
    [UserDefault removeObjectForKey:@"APsw"];
    [UserDefault removeObjectForKey:@"ACPsw"];
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
