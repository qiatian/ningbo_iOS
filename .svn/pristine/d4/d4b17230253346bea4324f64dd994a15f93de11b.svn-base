//
//  InMeetingViewController.m
//  IM
//
//  Created by 陆浩 on 15/7/6.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "InMeetingViewController.h"
#import "InMeetingUserItem.h"
#import "SelectCommonUserViewController.h"


#define DefaultGesTapTag    100000
#define ExitChatRoomAlert   10001
#define RejectUserAlert     10002//踢出、挂断成员

@interface InMeetingViewController ()<UIAlertViewDelegate>
{
    UIScrollView *meetingScrollerView;
    UIView *userBgView;
    UILabel *timeLabel;
    NSTimer *timer;
    int timeSeconds;
    NSString *roomNumber;
    NSMutableArray *itemArray;
    NSString *currentRemoveVoipTel;
    
    NSString *meetingNum;
}

@end

@implementation InMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    itemArray = [[NSMutableArray alloc] init];
    
    self.navigationItem.title = @"电话会控";
    self.view.backgroundColor = [UIColor hexChangeFloat:@"ffffff"];
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    ILBarButtonItem *rightItem=[ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"meet_release"] selectedImage:nil target:self action:@selector(clickRightItem:)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    //绘制 电话会控的界面
    [self configureMeetingView];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //创建电话会议的请求
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeChatRoomResponse:) name:VOIPCALLMakeChatRoom object:nil];
    // 会议解散的原因
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissChatRoomResponse:) name:VOIPCALLDismissChatRoom object:nil];
    //会议过程中有人加入 会议
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jointChatRoomResponse:) name:VOIPCALLJointChatRoom object:nil];
    //会议过程中有人退出 会议
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitChatRoomResponse:) name:VOIPCALLExitChatRoom object:nil];
    //会议过程中 踢出成员
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeUserChatRoomResponse:) name:VOIPCALLRemoveUserChatRoom object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refuseChatRoomResponse:) name:VOIPCALLRefuseChatRoom object:nil];
    
    
    // Do any additional setup after loading the view.
    
    //创建会议室 并且发起聊天
    [self makeChatRoom];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickLeftItem:(id)sender
{
    [self dismissChatRoom];
//    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickRightItem:(id)sender
{
    //解散会议
    [self dismissChatRoom];
}

#pragma mark -
#pragma mark - Configure View

-(void)configureMeetingView
{
    meetingScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, viewWithNavNoTabbar)];
    [self.view addSubview:meetingScrollerView];
    CGFloat height = boundsHeight==480 ? 160 : 180;
    UIImageView *topBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, height)];
    topBgView.image = [UIImage imageNamed:@"meeting_bg"];
    [meetingScrollerView addSubview:topBgView];
    
    GQLoadImageView *ivAvatar =[[GQLoadImageView alloc] initWithFrame:CGRectMake((topBgView.frame.size.width-85)/2, boundsHeight==480 ? 20 : 35, 85, 85)];
    ivAvatar.userInteractionEnabled =YES;
    ivAvatar.clipsToBounds =YES;
    ivAvatar.layer.cornerRadius = ivAvatar.frame.size.width/2;
    [topBgView addSubview:ivAvatar];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ivAvatar.frame.size.height+ivAvatar.frame.origin.y+20, boundsWidth, 30)];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont systemFontOfSize:18];
    timeLabel.text = @"00 : 00";
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [topBgView addSubview:timeLabel];
    timeLabel.hidden = YES;
    
    UILabel *labAvatar =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, ivAvatar.frame.size.width, ivAvatar.frame.size.height)];
    labAvatar.textColor =[UIColor whiteColor];
    labAvatar.textAlignment =NSTextAlignmentCenter;
    labAvatar.font =[UIFont boldSystemFontOfSize:20.0f];
    [ivAvatar addSubview:labAvatar];
    
    NSString *uname = [[ConfigManager sharedInstance].userDictionary  objectForKey:@"name"];
    NSString *bigPic = [[ConfigManager sharedInstance].userDictionary  objectForKey:@"bigpicurl"];
    
    if (bigPic && bigPic.length>0) {
        WEAKSELF
        [ivAvatar setImageWithUrl:bigPic placeHolder:[Common getImageFromColor:[UIColor colorWithRGBHex:uname.hash % 0xffffff]] progress:nil completed:^(UIImage *image) {
            [ivAvatar setImage:image];
        } failureBlock:^(NSError *error) {
            if (uname && uname.length>0) {
                labAvatar.text =[uname substringToIndex:1];
            }
        }];
    }else{
        [ivAvatar setImage:[Common getImageFromColor:[UIColor colorWithRGBHex:uname.hash % 0xffffff]]];
        if (uname && uname.length>0){
            labAvatar.text =[uname substringToIndex:1];
        }
    }
    
    userBgView = [[UIView alloc] initWithFrame:CGRectMake(0, topBgView.frame.size.height, boundsWidth, 0)];
    userBgView.backgroundColor = [UIColor clearColor];
    [meetingScrollerView addSubview:userBgView];
    
    //配置会议成员的View
    [self configureAndRefreshUserButtonView];
}

-(void)configureAndRefreshUserButtonView
{
    int numInRow = 4;
    CGFloat itemWidth = boundsWidth/numInRow;
    NSInteger allUserNum = _meetingModel.meetingUserArray.count;
    for (int i=0; i<_meetingModel.meetingUserArray.count; i++) {
        UIView *view = [userBgView viewWithTag:i+DefaultGesTapTag];//用tag值来找控件
        int row = i/numInRow;
        int index = i%numInRow;
        if(!view)
        {
            InMeetingUserItem *userItem =[[InMeetingUserItem alloc] initWithFrame:CGRectMake(index*itemWidth, row*(itemWidth+15), itemWidth, itemWidth)];
            userItem.user = _meetingModel.meetingUserArray[i];
            //为成员头像添加点击事件
            UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userItemTaped:)];
            [userItem addGestureRecognizer:tap];
            userItem.tag =i+DefaultGesTapTag;
            [userBgView addSubview:userItem];
            
            [itemArray addObject:userItem];
        }
    }
    
    int row = allUserNum/numInRow;
    int index = allUserNum%numInRow;
    UIView *view = [userBgView viewWithTag:DefaultGesTapTag-1];//用tag值来找控件
    if(!view)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = itemWidth/2;
        button.tag = DefaultGesTapTag-1;
        [userBgView addSubview:button];
        [button setImage:[UIImage imageNamed:@"chat_add_user.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        view = button;
    }
    view.frame = CGRectMake(index*itemWidth, row*(itemWidth+15), itemWidth, itemWidth);
    
    CGRect frame = userBgView.frame;
    frame.size.height = view.frame.size.height+view.frame.origin.y+20;
    userBgView.frame = frame;
    meetingScrollerView.contentSize = CGSizeMake(boundsWidth, frame.size.height+frame.origin.y);
}

-(void)addButtonClick:(UIButton *)sender
{
    SelectCommonUserViewController *selectUserVC =[[SelectCommonUserViewController alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(MeetingUserModel *model in _meetingModel.meetingUserArray)
    {
        //如果有userid则说明是从企业通讯录选取出来的
        if(model.userId && model.userId.length > 0)
        {
            [array addObject:model.userId];
        }
    }
    selectUserVC.disableUserIds = array;
    [selectUserVC setSelectBlock:^(NSArray *responseArray){
        
        if(responseArray.count > 0)
        {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            int oldItemNum = [itemArray count];
            for(MeetingUserModel *model in responseArray)
            {
                if(![self hasContaintTelephone:model.telephone])
                {
                    [_meetingModel.meetingUserArray addObject:model];
                    [array addObject:model.telephone];
                }
            }
            
            [[SQLiteManager sharedInstance] insertMeetingWithArray:[NSArray arrayWithObjects:_meetingModel, nil] notification:NOTIFICATION_RELOADVOIPLIST];
            //在会议进行中加入成员 也要更新历史记录里面的数据 不然历史记录看不到新增加的人
            [[SQLiteManager sharedInstance] insertHistoryMeetingWithArray:@[_meetingModel] notification:NOTIFICATION_RELOADVOIPLIST];
            
            [self configureAndRefreshUserButtonView];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadMeetingUser" object:nil];
            
            
            //新增的成员直接发起邀请
            for(int i = oldItemNum ; i < [itemArray count] ; i++)
            {
                InMeetingUserItem *item = itemArray[i];
                item.type = waiteconnect;
            }
            //更换SDK   单独的发起会议聊天(拨打VOIP电话) 和点击重连调用的SDK方法一样
            [self inviteMemberByPhoneArray:array];
        }
    }];
    
    GQNavigationController *selectUserVCNav =[[GQNavigationController alloc] initWithRootViewController:selectUserVC];
    [self presentViewController:selectUserVCNav animated:YES completion:^{
        
    }];
}

-(void)userItemTaped:(UITapGestureRecognizer *)tap
{
    InMeetingUserItem *userItem =(InMeetingUserItem *)tap.view;
    // 如果点击的头像当前状态是 连接失败或者是挂断状态 则点击后为VOIP落地电话
    if(userItem.type == reconnect || userItem.type == hangUp)
    {
        userItem.type = waiteconnect;
        [self inviteMemberByPhoneArray:[NSArray arrayWithObject:userItem.user.telephone]];
    }
    //如果点击头像当前状态是 连接状态 则点击后为挂断改成员电话
    if(userItem.type == hasconnect)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"你确定挂断该成员电话？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = RejectUserAlert;
        [alert show];
        currentRemoveVoipTel = userItem.user.telephone;
    }
}

-(void)onTimer
{
    timeSeconds ++;
    int h= timeSeconds/3600;
    int m= (timeSeconds-h*3600)/60;
    int s= (timeSeconds-h*3600) % 60;
    if (h>0) {
        timeLabel.text = [NSString stringWithFormat:@"%02d : %02d : %02d", h, m,s];
    }
    else
    {
        timeLabel.text = [NSString stringWithFormat:@"%02d : %02d",m,s];
    }
}

- (BOOL)hasContaintTelephone:(NSString*)tel{
    //判断成员中是否有该成员号码的成员了
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"telephone contains[cd] %@", tel];
    [resultArray setArray:[_meetingModel.meetingUserArray filteredArrayUsingPredicate:predicate]];
    if(resultArray.count)
    {
        return YES;
    }
    return NO;
}

#pragma mark -
#pragma mark - Voip Events
-(void)makeChatRoom
{
    //VOIP落地
    [MMProgressHUD showHUDWithTitle:@"正在创建电话会议..." isDismissLater:NO];
    //更换SDk 创建会议调用的SDK方法
    ECCreateMeetingParams *params=[[ECCreateMeetingParams alloc]init];
    params.meetingType =ECMeetingType_MultiVoice;
    params.meetingName= @"电话会议";
    params.meetingPwd=@"";
    params.square=30;
    params.autoClose=NO;
    params.autoJoin= YES;
    params.autoDelete= NO;
    params.voiceMod=2;
    params.keywords=@"";
    [[ECDevice sharedInstance].meetingManager createMultMeetingByType:params completion:^(ECError *error, NSString *meetingNumber) {
        NSLog(@"%@",meetingNumber);
        if (error.errorCode == ECErrorType_NoError)
        {
            [MMProgressHUD showHUDWithTitle:@"电话会议创建成功" isDismissLater:YES];
            meetingNum=[NSString stringWithFormat:@"%@",meetingNumber];
            
            [MMProgressHUD showHUDWithTitle:@"正在邀请成员加入" isDismissLater:NO];
            
            timeLabel.hidden = NO;
            timeSeconds = 0;
            timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
            
            //返回聊天室房间号则说明创建成功
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            for(MeetingUserModel *model in _meetingModel.meetingUserArray)
            {
                [array addObject:model.telephone];
            }
            
            for(InMeetingUserItem *item in itemArray)
            {
                item.type = waiteconnect;
            }
            
            //            //把自己的手机号码加进去
            //            NSString *mobile = [ConfigManager sharedInstance].userDictionary[@"mob"];
            //            [array addObject:mobile];
            
            //邀请成员
            [self inviteMemberByPhoneArray:array];
        }
        else
        {
            NSLog(@"创建会议失败");
            [MMProgressHUD showHUDWithTitle:[NSString stringWithFormat:@"%@",error.errorDescription] isDismissLater:YES];
            //聊天室创建失败
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
}

-(void)inviteMemberByPhoneArray:(NSArray *)array
{
    //更换SDK  创建会议开始和点击重连 都调用的SDK方法
    [[ECDevice sharedInstance].meetingManager inviteMembersJoinMultiMediaMeeting:meetingNum andIsLoandingCall:YES andMembers:array completion:^(ECError *error, NSString *meetingNumber) {
        NSLog(@"%@   %@",error,meetingNumber);
        if(error.errorCode==ECErrorType_NoError)
        {
            [MMProgressHUD showHUDWithTitle:@"邀请成功" isDismissLater:YES];
        }
        else
        {
            [MMProgressHUD showHUDWithTitle:@"邀请失败" isDismissLater:YES];
        }
    }];
}

-(void)removeMemberFromChatRoom:(NSString *)voipTel
{
    currentRemoveVoipTel = voipTel;
    //更换SDk  踢出会议成员 调用的SDk方法
    ECVoIPAccount *voipAc=[[ECVoIPAccount alloc]init];
    voipAc.isVoIP=NO;
    voipAc.account=voipTel;
    
    [[ECDevice sharedInstance].meetingManager removeMemberFromMultMeetingByMeetingType:ECMeetingType_MultiVoice andMeetingNumber:meetingNum andMember:voipAc completion:^(ECError *error, ECVoIPAccount *memberVoip) {
        NSLog(@"%@   %@",error,memberVoip);
        if (error.errorCode == ECErrorType_NoError)
        {
            NSLog(@"踢出会议成员");
            for(InMeetingUserItem *item in itemArray)
            {
                if([item.user.telephone isEqualToString:memberVoip.account])
                {
                    item.type = hangUp;
                }
            }
        }
        else
        {
            [self.view makeToast:[NSString stringWithFormat:@"%@踢出失败",memberVoip.account]];
        }
    }];
}

-(void)dismissChatRoom
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"你确定退出并解散该会议？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = ExitChatRoomAlert;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == ExitChatRoomAlert)
    {
        if(buttonIndex == 1)
        {
            [MMProgressHUD showHUDWithTitle:@"正在解散会议..." isDismissLater:NO];
            //更换SDk  点击左右的item 退出并解散会议 调用的方法
            [[ECDevice sharedInstance].meetingManager deleteMultMeetingByMeetingType:ECMeetingType_MultiVoice andMeetingNumber:meetingNum completion:^(ECError *error, NSString *meetingNumber) {
                if (error.errorCode==ECErrorType_NoError) {
                    NSLog(@"会议解散成功！");
                    [MMProgressHUD showHUDWithTitle:@"会议已解散" isDismissLater:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    NSLog(@"会议解散失败！");
                    [MMProgressHUD showHUDWithTitle:[NSString stringWithFormat:@"%ld",(long)error.errorCode] isDismissLater:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }
    else if(alertView.tag == RejectUserAlert)
    {
        if(buttonIndex == 1)
        {
            //更换SDK 踢出成员或挂断该成员通话
            [self removeMemberFromChatRoom:currentRemoveVoipTel];
        }
    }
}

#pragma mark -
#pragma mark - Voip Response
#pragma mark -
#pragma mark - Voip Response
// 会议解散的原因
-(void)dismissChatRoomResponse:(NSNotification *)noti
{
    NSLog(@"%@",noti.object);
    //更换SDK  会议解散的原因 CloopenReason是SDK中的类
    ECMultiVoiceMeetingMsg *reson = noti.object;
    if(reson.type == MultiVoice_DELETE)
    {
        [MMProgressHUD showHUDWithTitle:@"会议已解散" isDismissLater:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [MMProgressHUD showHUDWithTitle:reson.roomNo isDismissLater:YES];
    }
}

//会议过程中有人加入 会议
-(void)jointChatRoomResponse:(NSNotification *)noti
{
    //更换SDk  有人加入聊天室消息类定义
    ECMultiVoiceMeetingMsg *response = noti.object;
    NSArray *numArray = response.joinArr;
    for(InMeetingUserItem *item in itemArray)
    {
        for(ECVoIPAccount *eac in numArray)
        {
            if([item.user.telephone isEqualToString:eac.account])
            {
                item.type = hasconnect;
            }
        }
    }
}


//会议过程中有人退出 会议
-(void)exitChatRoomResponse:(NSNotification *)noti
{
    //更换SDK  有人退出聊天室消息类定义
    ECMultiVoiceMeetingMsg *response = noti.object;
    NSArray *numArray = response.exitArr;
    
    for(InMeetingUserItem *item in itemArray)
    {
        for(ECVoIPAccount *eac in numArray)
        {
            if([item.user.telephone isEqualToString:eac.account])
            {
                item.type = hangUp;
            }
        }
    }
}

//会议过程中 踢出成员
-(void)removeUserChatRoomResponse:(NSNotification *)noti
{
    NSString *member = noti.object[@"member"];
    [self removeMemberFromChatRoom:member];
    
}


-(void)refuseChatRoomResponse:(NSNotification *)noti
{
    
    ECMultiVoiceMeetingMsg *response = noti.object;
    NSArray *numArray = response.refuseArr;
    
    for(InMeetingUserItem *item in itemArray)
    {
        for(ECVoIPAccount *eac in numArray)
        {
            if([item.user.telephone isEqualToString:eac.account])
            {
                item.type = hangUp;
            }
        }
    }
}



@end
