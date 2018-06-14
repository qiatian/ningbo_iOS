//
//  SelectCommonUserViewController.m
//  IM
//
//  Created by 陆浩 on 15/7/5.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "SelectCommonUserViewController.h"
#import "ContactsTableViewCell.h"
#import "LocalContactsViewController.h"
#define DefaultGesTapTag    10000

@interface SelectCommonUserViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UITableView *contactsTableView;
    NSArray *titleArray;
    NSArray *imageArray;
    UITextField *telephoneInputField;
    UIScrollView *scrollView;
    NSMutableArray *nowSelectArray;
}

@end

@implementation SelectCommonUserViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    nowSelectArray = [[NSMutableArray alloc] init];
    
    self.navigationItem.title = LOCALIZATION(@"EnterpriseUserCardViewController_Contact");
    self.view.backgroundColor = [UIColor hexChangeFloat:@"ffffff"];
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    ILBarButtonItem *rightItem=[ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_save.png"] selectedImage:nil target:self action:@selector(clickRightItem:)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    titleArray = @[LOCALIZATION(@"Message_LocalAddressBook"),LOCALIZATION(@"Message_Enterprise_organizational")];
    imageArray = @[@"Contact_local.png",@"Contact_comp.png"];
    contactsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, viewWithNavAndTabbar)];
    contactsTableView.backgroundColor = [UIColor clearColor];
    contactsTableView.dataSource = self;
    contactsTableView.delegate = self;
    contactsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:contactsTableView];

    CGFloat orgin_y = 64+64;
    if(CURRENT_SYS_VERSION < 7.0999999)
    {
        orgin_y = 64;
    }
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-orgin_y, boundsWidth, 64)];
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleArray count] + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < titleArray.count)
    {
        static NSString *CellIdentifier = @"ContactsTableViewCell";
        ContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[ContactsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.titleLabel.text = [titleArray objectAtIndex:indexPath.row];
        cell.logoImageView.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"InputTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 5, boundsWidth-70, 32)];
        view.backgroundColor = [UIColor clearColor];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 4;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor hexChangeFloat:@"ececec"].CGColor;
        [cell.contentView addSubview:view];
        
        telephoneInputField = [[UITextField alloc] initWithFrame:CGRectMake(view.frame.origin.x+10, 5, view.frame.size.width-20, 32)];
        telephoneInputField.placeholder = LOCALIZATION(@"Message_pleaseShhuru");
        telephoneInputField.keyboardType = UIKeyboardTypeNumberPad;
        [cell.contentView addSubview:telephoneInputField];
        
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sureButton.frame = CGRectMake(boundsWidth-60, 5, 50, 32);
        [sureButton setTitle:LOCALIZATION(@"con_add") forState:UIControlStateNormal];
        sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [sureButton setTitleColor:[UIColor hexChangeFloat:@"0081cc"] forState:UIControlStateNormal];
        [sureButton addTarget:self action:@selector(sureAddNormalTelephone) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:sureButton];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 41.5, boundsWidth, 0.5)];
        line.backgroundColor = [UIColor hexChangeFloat:@"ececec"];
        [cell.contentView addSubview:line];

        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        LocalContactsViewController *selectUserVC =[[LocalContactsViewController alloc] init];
        selectUserVC.forSelectUser = YES;
        [selectUserVC setSelectBlock:^(RHPerson *person){
            MeetingUserModel *model = [[MeetingUserModel alloc] init];
            model.userName = person.name;
            model.userAvatar = @"";
            model.userId = @"";
            if(person.phoneNumberString && [person.phoneNumberString length]>0)
            {
                NSArray *phoneArray = [person.phoneNumberString componentsSeparatedByString:@"、"];
                if(phoneArray.count)
                {
                    model.telephone = phoneArray[0];
                    
                    if([self hasContaintTelephone:model.telephone])
                    {
                        [self.view makeToast:LOCALIZATION(@"Message_baohan")];
                        return;
                    }
                    [nowSelectArray addObject:model];
                    [self addUserItemsToScrollView];
                }
                else
                {
                    [self.view makeToast:LOCALIZATION(@"Message_NOnamber")];
                }
            }
            else
            {
                [self.view makeToast:LOCALIZATION(@"Message_NOnamber")];
            }
        }];
        [self.navigationController pushViewController:selectUserVC animated:YES];
        
    }
    if(indexPath.row == 1)
    {
        SelectEnterpriseUserViewController *selectUserVC =[[SelectEnterpriseUserViewController alloc] init];
        selectUserVC.selectGroupUsers = YES;
        selectUserVC.disabledContactIds =[NSMutableArray arrayWithArray:_disableUserIds];
        [selectUserVC setSelectBlock:^(NSArray *responseArray){
            for(int i = 0 ; i < responseArray.count ; i ++)
            {
                MEnterpriseUser *user = responseArray[i];
                MeetingUserModel *model = [[MeetingUserModel alloc] init];
                model.userName = user.uname;
                model.userAvatar = user.bigpicurl;
                model.userId = [NSString stringWithFormat:@"%@",user.uid];
                model.telephone = [NSString stringWithFormat:@"%@",user.mobile];
                [nowSelectArray addObject:model];
            }
            [self addUserItemsToScrollView];
        }];
        GQNavigationController *selectUserVCNav =[[GQNavigationController alloc] initWithRootViewController:selectUserVC];
        [self presentViewController:selectUserVCNav animated:YES completion:^{
        }];
    }
}

#pragma mark- Button Events
-(void)scrollViewWillBeginDragging:(UIScrollView *)tscrollView
{
    if(tscrollView == contactsTableView)
    {
        [self hiddenKeyBoard];
    }
}


-(void)hiddenKeyBoard
{
    [telephoneInputField resignFirstResponder];
}

-(void)clickLeftItem:(UIButton *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)clickRightItem:(UIButton *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if(_selectBlock)
        {
            _selectBlock(nowSelectArray);
        }
    }];
}

-(void)sureAddNormalTelephone
{
    [telephoneInputField resignFirstResponder];
    if([telephoneInputField.text length] == 0)
    {
        [self.view makeToast:LOCALIZATION(@"Message_pleaseShhuru")];
        return;
    }
    
    if([self hasContaintTelephone:telephoneInputField.text])
    {
        [self.view makeToast:LOCALIZATION(@"Message_baohan")];
        return;
    }
    
    MeetingUserModel *model = [[MeetingUserModel alloc] init];
    model.userName = LOCALIZATION(@"Message_Mettinger");
    model.userAvatar = @"";
    model.userId = @"";
    model.telephone = telephoneInputField.text;
    [nowSelectArray addObject:model];
    [self addUserItemsToScrollView];
    telephoneInputField.text = nil;
}

#pragma mark - 底部选中成员
-(void)addUserItemsToScrollView{
    [scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    
    int count =[nowSelectArray count];
    for (int i=0; i<count; i++) {
        
        GQUserItem *userItem =[[GQUserItem alloc] initWithFrame:CGRectMake(12+52*i, 0, 40, 64)];
        userItem.user = nowSelectArray[i];
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userItemTaped:)];
        [userItem addGestureRecognizer:tap];
        userItem.tag =i+DefaultGesTapTag;
        [scrollView addSubview:userItem];
    }
    scrollView.scrollEnabled =YES;
    scrollView.contentSize =CGSizeMake(12+52*count+40, 64) ;
    if(count == 0)
    {
        contactsTableView.frame = CGRectMake(0, 0, boundsWidth, viewWithNavNoTabbar);
    }
    else
    {
        contactsTableView.frame = CGRectMake(0, 0, boundsWidth, viewWithNavNoTabbar-64-44);
    }
}

-(void)userItemTaped:(UITapGestureRecognizer *)tap{
    GQUserItem *userItem =(GQUserItem *)tap.view;
    int index = userItem.tag - DefaultGesTapTag;
    [nowSelectArray removeObjectAtIndex:index];
    [self addUserItemsToScrollView];
}

- (BOOL)hasContaintTelephone:(NSString*)tel{
    //判断成员中是否有该成员号码的成员了
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"telephone contains[cd] %@", tel];
    [resultArray setArray:[nowSelectArray filteredArrayUsingPredicate:predicate]];
    if(resultArray.count)
    {
        return YES;
    }
    return NO;
}


@end
