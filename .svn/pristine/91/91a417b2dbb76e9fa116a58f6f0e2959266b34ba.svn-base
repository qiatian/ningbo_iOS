//
//  MeetingDetailViewController.m
//  IM
//
//  Created by 陆浩 on 15/7/1.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "MeetingDetailViewController.h"
#import "UIButton+WebCache.h"
#import "SelectCommonUserViewController.h"
#import "AllMettingUserViewController.h"
#import "InMeetingViewController.h"

#define DefaultTag   10000
#define UserButtonDefine   20000

@interface MeetingDetailViewController ()<UITextFieldDelegate>
{
    UIScrollView *bgScrollerView;
    UITextField *meetingTitleTextField;
//    UITextField *passwordTextField;
    UIView *userBgView;
    UILabel *groupNumLabel;
    MeetingModel *detailModel;
    
    NSString *lastIsCommon;//从历史记录而来，记录历史记录里面原来的是否是常用会议
    
    
    UIScrollView *userScrollView;
}

@end

@implementation MeetingDetailViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=YES;
}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
//    appDelegate.centerButton.hidden=NO;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LOCALIZATION(@"Message_Details_meeting");
    self.view.backgroundColor = [UIColor hexChangeFloat:@"ffffff"];
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    //点击屏幕收起键盘
    [self setUpForDismissKeyboard];
    
    if(_firstCreatMeeting)//第一次创建会议
    {
        detailModel = [[SQLiteManager sharedInstance] getHistoryMeetingWithId:_meetingId];
        
        
        ILBarButtonItem *rightItem=[ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_save.png"] selectedImage:nil target:self action:@selector(clickRightItem:)];
        [self.navigationItem setRightBarButtonItem:rightItem];
    }
    else
    {
        if(_fromHistory)//会议记录
        {
            detailModel = [[SQLiteManager sharedInstance] getHistoryMeetingWithId:_meetingId];
            
            lastIsCommon =  detailModel.commonMeeting;
        }
        else//常用会议
        {
            detailModel = [[SQLiteManager sharedInstance] getMeetingWithId:_meetingId];
            ILBarButtonItem *rightItem=[ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_save.png"] selectedImage:nil target:self action:@selector(clickRightItem:)];
            [self.navigationItem setRightBarButtonItem:rightItem];
        }
    }
    
    

    
    
    [self configureInfoView];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUserItemView) name:@"ReloadMeetingUser" object:nil];

    
    
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)clickLeftItem:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickRightItem:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [self saveModelIntoDataBase];
}

-(void)saveModelIntoDataBase
{
    detailModel.meetingTitle = meetingTitleTextField.text;
    if(_firstCreatMeeting)
    {
        [[SQLiteManager sharedInstance] insertHistoryMeetingWithArray:[NSArray arrayWithObjects:detailModel, nil] notification:NOTIFICATION_RELOADVOIPLIST];
        if([detailModel.commonMeeting intValue] == 1)
        {
            [[SQLiteManager sharedInstance] insertMeetingWithArray:[NSArray arrayWithObjects:detailModel, nil] notification:NOTIFICATION_RELOADVOIPLIST];
        }
    }
    else if(!_fromHistory)
    {
        //常用会议进入
        if([detailModel.commonMeeting intValue] == 1)
        {
            //常用会议编辑保存，如果还是常用会议，则保存的时候形成一个新的常用会议将原来的常用会议删掉
            MeetingModel *model = [[SQLiteManager sharedInstance] getHistoryMeetingWithId:detailModel.meetingId];
            if(model && (![model.meetingTitle isEqualToString:detailModel.meetingTitle] || model.meetingUserArray.count != detailModel.meetingUserArray.count))
            {
                model.commonMeeting = @"0";
                [[SQLiteManager sharedInstance] insertHistoryMeetingWithArray:@[model] notification:nil];
                
                [[SQLiteManager sharedInstance] deleteMeetingWithId:detailModel.meetingId notification:nil];
                detailModel.meetingId = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
                [[SQLiteManager sharedInstance] insertMeetingWithArray:[NSArray arrayWithObjects:detailModel, nil] notification:NOTIFICATION_RELOADVOIPLIST];
            }
            else
            {
                [[SQLiteManager sharedInstance] insertMeetingWithArray:[NSArray arrayWithObjects:detailModel, nil] notification:NOTIFICATION_RELOADVOIPLIST];
            }
            
        }
        else
        {
            
            MeetingModel *model = [[SQLiteManager sharedInstance] getHistoryMeetingWithId:detailModel.meetingId];
            if(model)
            {
                model.commonMeeting = @"0";
                [[SQLiteManager sharedInstance] insertHistoryMeetingWithArray:@[model] notification:nil];
            }
            [[SQLiteManager sharedInstance] deleteMeetingWithId:detailModel.meetingId notification:NOTIFICATION_RELOADVOIPLIST];
        }
    }
}


-(void)configureInfoView
{
    bgScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, viewWithNavNoTabbar)];
    bgScrollerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgScrollerView];
    
    UIView *view1 = [self configureInputViewWithTitle:LOCALIZATION(@"Message_Metting_zhuti") placeholder:LOCALIZATION(@"Message_Please_Metting")];
    view1.frame = CGRectMake(0, 0, boundsWidth, 43);
    [bgScrollerView addSubview:view1];
    meetingTitleTextField = (UITextField *)[view1 viewWithTag:DefaultTag];
    
    if(_fromHistory)
    {
        meetingTitleTextField.userInteractionEnabled = NO;
        if([detailModel.meetingTitle length])
        {
            meetingTitleTextField.text = detailModel.meetingTitle;
        }
        else
        {
            meetingTitleTextField.text = LOCALIZATION(@"Message_NO_Metting_zhuti");
        }
    }
    else
    {
        if([detailModel.meetingTitle length])
        {
            meetingTitleTextField.text = detailModel.meetingTitle;
        }
    }

    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(10, view1.frame.size.height-0.5, boundsWidth-10, 0.5)];
    line1.backgroundColor = [UIColor hexChangeFloat:@"bbbbbb"];
    [view1 addSubview:line1];
    
//    UIView *view2 = [self configureInputViewWithTitle:@"会议密码" placeholder:@"请输入会议密码"];
//    view2.frame = CGRectMake(0, view1.frame.size.height+view1.frame.origin.y, boundsWidth, 43);
//    [bgScrollerView addSubview:view2];
//    passwordTextField = (UITextField *)[view2 viewWithTag:DefaultTag];
//    
//    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.frame.size.height-0.5, boundsWidth, 0.5)];
//    line2.backgroundColor = [UIColor hexChangeFloat:@"bbbbbb"];
//    [view2 addSubview:line2];
    
    CGFloat orgin_Y = 110+view1.frame.size.height+view1.frame.origin.y;
    UIView *commonView = [[UIView alloc] initWithFrame:CGRectMake(0, orgin_Y, boundsWidth, 43)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 120, 20)];
    titleLabel.font = [UIFont systemFontOfSize:15.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = LOCALIZATION(@"Message_addSometimesMetting");
    [commonView addSubview:titleLabel];
    UISwitch *commonSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(boundsWidth-45-10, 8, 45, 27)];
//    commonSwitch.tintColor = [UIColor hexChangeFloat:@"0181ca"];
    commonSwitch.onTintColor = [UIColor hexChangeFloat:@"0181ca"];
    [commonSwitch addTarget:self action:@selector(commonSwitchChange:) forControlEvents:UIControlEventValueChanged];
    [commonView addSubview:commonSwitch];
    commonSwitch.on = [detailModel.commonMeeting intValue] == 1?YES:NO;
    [bgScrollerView addSubview:commonView];

    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, commonView.frame.size.height-0.5, boundsWidth, 0.5)];
    line3.backgroundColor = [UIColor hexChangeFloat:@"bbbbbb"];
    [commonView addSubview:line3];
    
    
    
    //会议置顶
    UIView *SettopView = [[UIView alloc]initWithFrame:CGRectMake(0, orgin_Y+43 , boundsWidth, 43)];
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 11, 120, 20)];
    topLabel.font = [UIFont systemFontOfSize:15.0f];
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.text = @"会议置顶";
    [SettopView addSubview:topLabel];
    UISwitch *topSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(boundsWidth-45-10, 8, 45, 27)];
    topSwitch.onTintColor = [UIColor hexChangeFloat:@"0181ca"];
    [topSwitch addTarget:self action:@selector(topSwitchChange:) forControlEvents:UIControlEventValueChanged];
    [SettopView addSubview:topSwitch];
    
    
    topSwitch.on = NO;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:SettingMettingTopKey]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:SettingMettingTopKey] objectForKey:detailModel.meetingId]) {
            if ([[[[[NSUserDefaults standardUserDefaults] objectForKey:SettingMettingTopKey] objectForKey:detailModel.meetingId] objectForKey:detailModel.meetingId] boolValue]) {
                topSwitch.on = YES;
            }
        }
    }
    
    [bgScrollerView addSubview:SettopView];
    
    
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, SettopView.frame.size.height-0.5, boundsWidth, 0.5)];
    line4.backgroundColor = [UIColor hexChangeFloat:@"bbbbbb"];
    [SettopView addSubview:line4];

    
    
    [self configureAndRefreshUserView:view1.frame.size.height+view1.frame.origin.y];
    
    UIButton *meetingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    meetingButton.frame = CGRectMake(10, SettopView.frame.size.height+SettopView.frame.origin.y+20, boundsWidth-20, 40);
    [meetingButton setBackgroundColor:[UIColor hexChangeFloat:@"0181ca"]];
    [meetingButton setTitle:LOCALIZATION(@"Message_Metting_now") forState:UIControlStateNormal];
    meetingButton.layer.masksToBounds = YES;
    meetingButton.layer.cornerRadius = 6;
    [meetingButton addTarget:self action:@selector(startMeeting) forControlEvents:UIControlEventTouchUpInside];
    [bgScrollerView addSubview:meetingButton];
    
}

-(void)configureAndRefreshUserView:(CGFloat)orgin_y
{
    if(!userScrollView)
    {
        UIButton *view6 = [UIButton buttonWithType:UIButtonTypeCustom];
        view6.frame = CGRectMake(0, orgin_y, boundsWidth, 110);
        view6.backgroundColor = [UIColor whiteColor];
        [view6 addTarget:self action:@selector(seeAllNotiUser:) forControlEvents:UIControlEventTouchUpInside];
        [bgScrollerView addSubview:view6];
        
        UIView *line6 = [[UIView alloc] initWithFrame:CGRectMake(10, view6.frame.size.height-0.5, boundsWidth-10, 0.5)];
        line6.backgroundColor = [UIColor hexChangeFloat:@"bbbbbb"];
        [view6 addSubview:line6];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 100, 16)];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = LOCALIZATION(@"Message_Mettinger");
        [view6 addSubview:titleLabel];
        
        groupNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(boundsWidth-100-30, 6, 100, 16)];
        groupNumLabel.font = [UIFont systemFontOfSize:15];
        groupNumLabel.backgroundColor = [UIColor clearColor];
        groupNumLabel.textColor = [UIColor grayColor];
        groupNumLabel.textAlignment = NSTextAlignmentRight;
        [view6 addSubview:groupNumLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(boundsWidth-10-9, 6, 9, 16)];
        arrowImageView.image = [UIImage imageNamed:@"arrow.png"];
        [view6 addSubview:arrowImageView];
        
       
        
        userScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35, boundsWidth, 75)];
        userScrollView.backgroundColor = [UIColor clearColor];
        userScrollView.showsHorizontalScrollIndicator = NO;
        [view6 addSubview:userScrollView];

    }
    

    NSString *str = [NSString stringWithFormat:@"%ld",(unsigned long)detailModel.meetingUserArray.count];
    NSString *str1 = [str stringByAppendingString:LOCALIZATION(@"Message_peopler")];
    
    groupNumLabel.text = str1;
    
    [self configureUserScrollView];
}

- (void)configureUserScrollView{
    
    
    if (userScrollView) {
        [userScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    int userNumber = detailModel.meetingUserArray.count + 1;
    
    userScrollView.contentSize = CGSizeMake(10 + 59 * userNumber, 57);

    for (int i = 0; i<=detailModel.meetingUserArray.count; i++) {
        
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(10+59*i, 0, 52, 52);
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 26;
            button.tag = UserButtonDefine+i;
            [userScrollView addSubview:button];
            
            if(i == [detailModel.meetingUserArray count])//添加按钮
            {
                [button setImage:[UIImage imageNamed:@"chat_add_user.png"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                if(i < detailModel.meetingUserArray.count)
                {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.origin.x, button.frame.size.height+button.frame.origin.y, button.frame.size.width, userScrollView.frame.size.height-button.frame.size.height-button.frame.origin.y)];
                    label.textColor = [UIColor grayColor];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont systemFontOfSize:13.0f];
                    label.backgroundColor = [UIColor clearColor];
                    
                    MeetingUserModel *groupUser = [detailModel.meetingUserArray objectAtIndex:i];
                    [button sd_setBackgroundImageWithURL:[NSURL URLWithString:groupUser.userAvatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"chat_settingHead.png"]];
                    label.text = groupUser.userName;
                    [userScrollView addSubview:label];
                    [button addTarget:self action:@selector(userButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                }
                else
                {
                    [button removeFromSuperview];
                }
            }
        }
        
    }
    
}

-(UIView *)configureInputViewWithTitle:(NSString *)title placeholder:(NSString *)placeholder{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 43)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 70, 20)];
    titleLabel.font = [UIFont systemFontOfSize:15.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    [view addSubview:titleLabel];
    
    UITextField *tempTextField = [[UITextField alloc] initWithFrame:CGRectMake(70, 6, boundsWidth-10-80, 30)];
    tempTextField.placeholder = placeholder;
    tempTextField.textColor = [UIColor grayColor];
    tempTextField.textAlignment = NSTextAlignmentRight;
    tempTextField.font = [UIFont systemFontOfSize:15.0f];
    tempTextField.tag = DefaultTag;
    tempTextField.delegate = self;
    [view addSubview:tempTextField];
    
    return view;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark - Button Events
-(void)reloadUserItemView
{
    [self configureAndRefreshUserView:0];
}

-(void)commonSwitchChange:(UISwitch *)switchView
{
    if(switchView.on)
    {
        detailModel.commonMeeting = @"1";
        if(_fromHistory)
        {
            //成为常用会议的时候重新定义一个id
            [[SQLiteManager sharedInstance] insertMeetingWithArray:[NSArray arrayWithObjects:detailModel, nil] notification:NOTIFICATION_RELOADVOIPLIST];
        }
    }
    else
    {
        detailModel.commonMeeting = @"0";
        if(_fromHistory)
        {
            [[SQLiteManager sharedInstance] deleteMeetingWithId:detailModel.meetingId notification:NOTIFICATION_RELOADVOIPLIST];
        }
    }
    
    if(_fromHistory)
    {
        [[SQLiteManager sharedInstance] insertHistoryMeetingWithArray:[NSArray arrayWithObjects:detailModel, nil] notification:NOTIFICATION_RELOADVOIPLIST];
    }
}



-(void)topSwitchChange:(UISwitch *)switchView{
    
    //    topSwitch.on = [[[[[NSUserDefaults standardUserDefaults] objectForKey:SettingMettingTopKey] objectForKey:detailModel.meetingId] objectForKey:detailModel.meetingId] boolValue];
    
    NSLog(@"置顶聊天 isOn = %hhd",switchView.on);
    NSMutableDictionary *mainDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:SettingMettingTopKey]];
    if (!mainDic) {
        mainDic = [[NSMutableDictionary alloc] init];
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    
    if (switchView.on) {
        //关闭
        [dic setValue:[NSString stringWithFormat:@"%d",1] forKey:detailModel.meetingId];
    } else {
        //打开
        [dic setValue:[NSString stringWithFormat:@"%d",0] forKey:detailModel.meetingId];
    }
    [dic setValue:[NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970]*1000] forKey:SettingTopTime];
    [mainDic setObject:dic forKey:detailModel.meetingId];
    
    
    [[NSUserDefaults standardUserDefaults] setValue:mainDic forKey:SettingMettingTopKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RELOADVOIPLIST object:nil];
    
    
}



-(void)startMeeting
{
    detailModel.meetingTitle = meetingTitleTextField.text;
    if (_fromHistory){
        detailModel.meetingId = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    }
    InMeetingViewController *vc = [[InMeetingViewController alloc] init];
    vc.meetingModel = detailModel;
    [self.navigationController pushViewController:vc animated:YES];
    detailModel.meetingLastConnectTime = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    [[SQLiteManager sharedInstance] insertHistoryMeetingWithArray:[NSArray arrayWithObjects:detailModel, nil] notification:NOTIFICATION_RELOADVOIPLIST];
    
    if(!_fromHistory && !_firstCreatMeeting)
    {
        [self saveModelIntoDataBase];
    }
    
}

-(void)seeAllNotiUser:(UIButton *)sender
{
    AllMettingUserViewController *vc = [[AllMettingUserViewController alloc] init];
    vc.mettingUserArray = detailModel.meetingUserArray;
    vc.isMineMetting = NO;
    vc.canDeleteUser = YES;
    vc.fromHistoryMeeting = _fromHistory;
    vc.deletedUsersBlock = ^(NSArray *users){
        
        [self handleDeletedUserInDatabase:users];

    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)userButtonClick:(UIButton *)sender
{
    AllMettingUserViewController *vc = [[AllMettingUserViewController alloc] init];
    vc.mettingUserArray = detailModel.meetingUserArray;
    vc.isMineMetting = NO;
    vc.canDeleteUser = YES;
    vc.deletedUsersBlock = ^(NSArray *users){
        
        [self handleDeletedUserInDatabase:users];
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//删除会议成员后的处理
- (void)handleDeletedUserInDatabase:(NSArray*)users{
    
    [detailModel.meetingUserArray removeObjectsInArray:users];
    
    [[SQLiteManager sharedInstance] insertHistoryMeetingWithArray:@[detailModel] notification:NOTIFICATION_RELOADVOIPLIST];
    
    if (detailModel.commonMeeting.intValue == 1) {
        [[SQLiteManager sharedInstance] insertMeetingWithArray:@[detailModel] notification:NOTIFICATION_RELOADVOIPLIST];
    }
    
    [self configureAndRefreshUserView:0];

    
}

-(void)addButtonClick:(UIButton *)sender
{
    SelectCommonUserViewController *selectUserVC =[[SelectCommonUserViewController alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(MeetingUserModel *model in detailModel.meetingUserArray)
    {
        if(model.userId && model.userId.length > 0)
        {
            [array addObject:model.userId];
        }
    }
    selectUserVC.disableUserIds = array;
    [selectUserVC setSelectBlock:^(NSArray *responseArray){
        if(responseArray.count > 0)
        {
            for(MeetingUserModel *model in responseArray)
            {
                if(![self hasContaintTelephone:model.telephone])
                {
                    [detailModel.meetingUserArray addObject:model];
                }
            }
            
            [[SQLiteManager sharedInstance] insertHistoryMeetingWithArray:@[detailModel] notification:NOTIFICATION_RELOADVOIPLIST];
            //如果是常用会议 还要更新一下常用会议的数据库 不然常用会议看不到新添加的人
            if (detailModel.commonMeeting.intValue == 1) {
                
                
                [[SQLiteManager sharedInstance] insertMeetingWithArray:@[detailModel] notification:NOTIFICATION_RELOADVOIPLIST];
                
            }
            
            [self reloadUserItemView];
        }
    }];
    
    GQNavigationController *selectUserVCNav =[[GQNavigationController alloc] initWithRootViewController:selectUserVC];
    [self presentViewController:selectUserVCNav animated:YES completion:^{
        
    }];
}

- (BOOL)hasContaintTelephone:(NSString*)tel{
    //判断成员中是否有该成员号码的成员了
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"telephone contains[cd] %@", tel];
    [resultArray setArray:[detailModel.meetingUserArray filteredArrayUsingPredicate:predicate]];
    if(resultArray.count)
    {
        return YES;
    }
    return NO;
}


//点击屏幕收起键盘
- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
    
}


@end
