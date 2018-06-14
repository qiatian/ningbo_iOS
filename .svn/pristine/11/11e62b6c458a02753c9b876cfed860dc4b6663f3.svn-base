//
//  EditDetailViewController.m
//  IM
//
//  Created by  pipapai_tengjun on 15/6/28.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "EditDetailViewController.h"
#import "RegexKitLite.h"

@interface EditDetailViewController ()
{
    UITextField * textfiled1;
    UITextField * textfiled2;
    UITextField * textfiled3;
    UITextField * textfiled4;//常驻地
    UILabel     * cardNumLabel;
    NSArray     * cardArray;
    NSMutableDictionary * userInfoDictionary;
}
@end

@implementation EditDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
    self.navigationItem.title = self.navTitle;
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    ILBarButtonItem *rigthItem=[ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_save.png"] highlightedImage:[UIImage imageNamed:@"nav_save.png"] target:self action:@selector(comformSaveInfo)];
    [self.navigationItem setRightBarButtonItem:rigthItem];
    userInfoDictionary = [NSMutableDictionary dictionaryWithDictionary:[ConfigManager sharedInstance].userDictionary];

    [self configTextfieldView];
}

- (void)configTextfieldView{
    UIView * dipView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 42*5)];
    dipView.backgroundColor = [UIColor whiteColor];
    dipView.layer.masksToBounds = YES;
    dipView.layer.borderColor = [UIColor hexChangeFloat:@"e1e1e1"].CGColor;
    dipView.layer.borderWidth = 1;
    [self.view addSubview:dipView];
    
    if (self.type == EditUserCardType) {
        //编辑名片
        cardArray = [NSArray arrayWithObjects:@"公司",@"工号",@"部门",@"职位",@"常驻地", nil];
        for (int i=0; i<[cardArray count]; i++) {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 13+i*42, 60, 16)];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = [UIColor blackColor];
            label.text = cardArray[i];
            [dipView addSubview:label];
        }
        //公司信息编辑
        textfiled1 = [self configTextfieldWithPlaceholder:@"请输入公司名称" Index:0];
        [dipView addSubview:textfiled1];
        
        UIImageView * line1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 41.5, self.view.frame.size.width-10, 0.5)];
        line1.backgroundColor = [UIColor hexChangeFloat:@"e7e7e7"];
        [dipView addSubview:line1];
        
        //工号显示  不给编辑
        cardNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 42, self.view.frame.size.width-100, 42)];
        cardNumLabel.backgroundColor = [UIColor clearColor];
        cardNumLabel.textAlignment = NSTextAlignmentLeft;
        cardNumLabel.font = [UIFont systemFontOfSize:16];
        cardNumLabel.textColor = [UIColor hexChangeFloat:@"bdbdbd"];
        cardNumLabel.text = [userInfoDictionary objectForKey:@"jid"];
        [dipView addSubview:cardNumLabel];
        
        UIImageView * line2 = [[UIImageView alloc]initWithFrame:CGRectMake(10, cardNumLabel.frame.size.height + cardNumLabel.frame.origin.y-0.5, self.view.frame.size.width-10, 0.5)];
        line2.backgroundColor = [UIColor hexChangeFloat:@"e7e7e7"];
        [dipView addSubview:line2];
        
        cardNumLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showInfoNotice)];
        [cardNumLabel addGestureRecognizer:tap];
        
        //部门信息编辑
        textfiled2 = [self configTextfieldWithPlaceholder:@"请输入部门信息" Index:2];
        [dipView addSubview:textfiled2];
        
        UIImageView * line3 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 42*3-0.5, self.view.frame.size.width-10, 0.5)];
        line3.backgroundColor = [UIColor hexChangeFloat:@"e7e7e7"];
        [dipView addSubview:line3];

        
        //职位信息编辑
        textfiled3 = [self configTextfieldWithPlaceholder:@"请输入职位信息" Index:3];
        [dipView addSubview:textfiled3];
        
        
        UIImageView * line4 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 42*4-0.5, self.view.frame.size.width-10, 0.5)];
        line4.backgroundColor = [UIColor hexChangeFloat:@"e7e7e7"];
        [dipView addSubview:line4];
        
        
        //职位信息编辑
        textfiled4 = [self configTextfieldWithPlaceholder:@"请输入常驻地" Index:4];
        [dipView addSubview:textfiled4];

        
        
        NSString * gname = [userInfoDictionary objectForKey:@"gname"];
        NSString * cname = [userInfoDictionary objectForKey:@"cname"];
        NSString * post = [userInfoDictionary objectForKey:@"post"];
        NSString * address = [userInfoDictionary objectForKey:@"permAddress"];

        if (!IsNilNull(gname) &&[gname length]) {
            textfiled1.text = gname;
        }
        
        if (!IsNilNull(cname) &&[cname length]) {
            textfiled2.text = cname;
        }

        if (!IsNilNull(post) &&[post length]) {
            textfiled3.text = post;
        }
        if (!IsNilNull(address) &&[address length]) {
            textfiled4.text = address;
        }

        [textfiled1 becomeFirstResponder];
    }
    else{
        NSString * titleStr = @"";
        NSString * infoStr = @"";
        switch (self.type) {
            case EditUserNameType:
                titleStr = @"姓名";
                infoStr = [userInfoDictionary objectForKey:@"name"];
                break;
            case EditUserSexType:
                titleStr = @"性别";
                if ([[userInfoDictionary objectForKey:@"sex"] boolValue]) {
                    infoStr = @"男";
                }
                else{
                    infoStr = @"女";
                }
                break;
            case EditUserAutographType:
                titleStr = @"个性签名";
                infoStr = [userInfoDictionary objectForKey:@"autograph"];
                break;
            case EditUserMobType:
                titleStr = @"工作电话";
                infoStr = [userInfoDictionary objectForKey:@"mob"];
                break;
            case EditUserTelType:
                titleStr = @"家庭电话";
                infoStr = [userInfoDictionary objectForKey:@"telephone"];
                break;
            case EditUserEmailType:
                titleStr = @"邮箱地址";
                infoStr = [userInfoDictionary objectForKey:@"email"];
                break;
            default:
                break;
        }
        
        dipView.frame = CGRectMake(0, 10, self.view.frame.size.width, 42);
        
        cardNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 16*4, 42)];
        cardNumLabel.backgroundColor = [UIColor clearColor];
        cardNumLabel.textAlignment = NSTextAlignmentLeft;
        cardNumLabel.font = [UIFont systemFontOfSize:16];
        cardNumLabel.textColor = [UIColor hexChangeFloat:@"000000"];
        cardNumLabel.text = titleStr;
        [dipView addSubview:cardNumLabel];
        
        //部门信息编辑
        textfiled1 = [self configTextfieldWithPlaceholder:[NSString stringWithFormat:@"请输入%@信息",titleStr] Index:0];
        if (!IsNilNull(infoStr) && [infoStr length]) {
            textfiled1.text = infoStr;
        }
        [dipView addSubview:textfiled1];
        [textfiled1 becomeFirstResponder];
    }
}

- (UITextField *)configTextfieldWithPlaceholder:(NSString *)title Index:(int)index{
    UITextField * sender = [[UITextField alloc]initWithFrame:CGRectMake(80, 42*index, self.view.frame.size.width-100, 42)];
    if (self.type != EditUserCardType) {
        sender.frame = CGRectMake(cardNumLabel.frame.size.width + cardNumLabel.frame.origin.x +10, 0, self.view.frame.size.width - cardNumLabel.frame.size.width - cardNumLabel.frame.origin.x -20, 42);
    }
    sender.backgroundColor = [UIColor clearColor];
    sender.font = [UIFont systemFontOfSize:16];
    sender.textAlignment = NSTextAlignmentLeft;
    sender.placeholder = title;
    sender.textColor = [UIColor hexChangeFloat:@"bdbdbd"];
    sender.clearButtonMode = UITextFieldViewModeWhileEditing;
    return sender;
}

- (void)showInfoNotice{
//    [MMProgressHUD showHUDWithTitle:@"工号信息不可修改" isDismissLater:YES];
}

-(void)clickLeftItem:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)comformSaveInfo{
    if (self.type == EditUserCardType) {
        //名片信息保存
        NSString * gname = [userInfoDictionary objectForKey:@"gname"];
        NSString * cname = [userInfoDictionary objectForKey:@"cname"];
        NSString * post = [userInfoDictionary objectForKey:@"post"];
        NSString * address = [userInfoDictionary objectForKey:@"permAddress"];
        
        if ([textfiled1.text length] == 0 || [textfiled2.text length] == 0 || [textfiled3.text length] == 0 || [textfiled4.text length] == 0) {
            [MMProgressHUD showHUDWithTitle:@"请填写完整后提交保存" isDismissLater:YES];
            return;
        }
        else{
            if ([textfiled1.text isEqualToString:gname] && [textfiled2.text isEqualToString:cname] && [textfiled3.text isEqualToString:post] && [textfiled4.text isEqualToString:address]) {
                //信息未做修改
                [MMProgressHUD showHUDWithTitle:@"信息未作修改，请修改后提交" isDismissLater:YES];
                return;
            }
            else{
                NSDictionary * pDic = [NSDictionary dictionaryWithObjectsAndKeys:textfiled1.text,@"gname",textfiled2.text,@"cname",textfiled3.text,@"post",textfiled4.text,@"permAddress",[userInfoDictionary objectForKey:@"token"],@"token", nil];
                [MMProgressHUD showHUDWithTitle:@"正在保存..." isDismissLater:YES];
                [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodUpdateUser] parameters:pDic successBlock:^(BOOL success, id data, NSString *msg) {
                    if (data) {
                        if ([data isKindOfClass:[NSDictionary class]]) {
                            NSDictionary * dic = (NSDictionary *)data;
                            NSDictionary * resDic = [dic objectForKey:@"res"];
                            if ([resDic objectForKey:@"reCode"] && [[resDic objectForKey:@"reCode"]intValue]==1 ) {
                                [userInfoDictionary setObject:textfiled1.text forKey:@"gname"];
                                [userInfoDictionary setObject:textfiled2.text forKey:@"cname"];
                                [userInfoDictionary setObject:textfiled3.text forKey:@"post"];
                                [userInfoDictionary setObject:textfiled4.text forKey:@"permAddress"];
                                [ConfigManager sharedInstance].userDictionary = userInfoDictionary;

                                [MMProgressHUD showHUDWithTitle:@"名片信息修改成功" isDismissLater:YES];
                                
                                [self.navigationController popViewControllerAnimated:YES];
                                [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoChange object:nil];
                            }
                            
                        }
                        else{
                            [MMProgressHUD showHUDWithTitle:@"返回数据格式错误" isDismissLater:YES];
                        }
                    }
                    else{
                        [MMProgressHUD showHUDWithTitle:@"返回数据为空" isDismissLater:YES];
                    }
                } failureBlock:^(NSString *description) {
                    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"network_failed") isDismissLater:YES];
                    return;
                }];
            }
        }
    }
    else{
        NSString * oldStr = @"";
        NSString * keyStr = @"";
        switch (self.type) {
            case EditUserNameType:
                keyStr = @"name";
                oldStr = [userInfoDictionary objectForKey:@"name"];
                break;
            case EditUserSexType:
                keyStr = @"sex";
                if ([[userInfoDictionary objectForKey:@"sex"] boolValue]) {
                    oldStr = @"男";
                }
                else{
                    oldStr = @"女";
                }
                if (![textfiled1.text isEqualToString:@"男"] && ![textfiled1.text isEqualToString:@"女"]) {
                    [MMProgressHUD showHUDWithTitle:@"请输入正确信息" isDismissLater:YES];
                    return;
                }
                
                break;
            case EditUserAutographType:
                keyStr = @"autograph";
                oldStr = [userInfoDictionary objectForKey:@"autograph"];
                break;
            case EditUserMobType:
            {
                if(![self isMobileNumber:textfiled1.text])
                {
                    [textfiled1 resignFirstResponder];
                    [self.view makeToast:@"请输入正确的手机号"];
                    return;
                }
            }
                keyStr = @"mob";
                oldStr = [userInfoDictionary objectForKey:@"mob"];
                break;
            case EditUserTelType:
            {
                if(![self isMobileNumber:textfiled1.text]||![self isHomeNumber:textfiled1.text])
                {
                    [textfiled1 resignFirstResponder];
                    [self.view makeToast:@"请输入正确的手机号"];
                    return;
                }
            }
                keyStr = @"telephone";
                oldStr = [userInfoDictionary objectForKey:@"telephone"];
                break;
            case EditUserEmailType:
            {
                if(![self isEmailAddress:textfiled1.text])
                {
                    [textfiled1 resignFirstResponder];
                    [self.view makeToast:@"请输入正确的手机号"];
                    return;
                }
            }
                keyStr = @"email";
                oldStr = [userInfoDictionary objectForKey:@"email"];
                break;
            default:
                break;
        }
        if (!IsNilNull(textfiled1.text) && [textfiled1.text length]) {
            if ([textfiled1.text isEqualToString:oldStr]) {
                [MMProgressHUD showHUDWithTitle:@"信息未做修改，请修改后提交" isDismissLater:YES];
            }
            else{
                [MMProgressHUD showHUDWithTitle:@"正在保存..." isDismissLater:YES];
                NSDictionary * pDic = [NSDictionary dictionaryWithObjectsAndKeys:textfiled1.text,keyStr,[userInfoDictionary objectForKey:@"token"],@"token", nil];
                [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodUpdateUser] parameters:pDic successBlock:^(BOOL success, id data, NSString *msg) {
                    if (data) {
                        if ([data isKindOfClass:[NSDictionary class]]) {
                            NSDictionary * dic = (NSDictionary *)data;
                            NSDictionary * resDic = [dic objectForKey:@"res"];
                            if ([resDic objectForKey:@"reCode"] && [[resDic objectForKey:@"reCode"]intValue]==1 ) {
                                [userInfoDictionary setObject:textfiled1.text forKey:keyStr];
                                [ConfigManager sharedInstance].userDictionary = userInfoDictionary;
                                
                                [MMProgressHUD showHUDWithTitle:[NSString stringWithFormat:@"%@信息修改成功",self.navTitle] isDismissLater:YES];
                                [self.navigationController popViewControllerAnimated:YES];
                                [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoChange object:nil];
                            }
                        }
                        else{
                            [MMProgressHUD showHUDWithTitle:@"返回数据格式错误" isDismissLater:YES];
                        }
                    }
                    else{
                        [MMProgressHUD showHUDWithTitle:@"返回数据为空" isDismissLater:YES];
                    }
                } failureBlock:^(NSString *description) {
                    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"network_failed") isDismissLater:YES];
                    return;
                }];

            }
        }
        else{
            [MMProgressHUD showHUDWithTitle:@"请将信息填写完整后提交" isDismissLater:YES];
        }
    }
    
}


- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    BOOL isMatch = [mobileNum isMatchedByRegex:phoneRegex];
    return isMatch;
}

-(BOOL)isEmailAddress:(NSString *)string
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if([emailTest evaluateWithObject:string])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isHomeNumber:(NSString *)mobileNum
{
    //判断是否是座机号码的正则
    NSString * regexp= @"^(0[0-9]{2,3}\\-)?([2-9][0-9]{6,7})+(\\-[0-9]{1,4})?$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexp];
    
    if ([regextestmobile evaluateWithObject:mobileNum])
    {
        return YES;
    }
    else
    {
        return NO;
    }
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
