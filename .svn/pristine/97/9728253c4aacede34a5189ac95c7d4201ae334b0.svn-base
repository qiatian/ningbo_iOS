//
//  VoipViewController.m
//  IM
//
//  Created by 陆浩 on 15/6/28.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "VoipViewController.h"
#import "UIButton+WebCache.h"
//#import "CCPManager.h"
//#import "CommonClass.h"
#import "MMessage.h"
#import "CameraDeviceInfo.h"


@interface VoipViewController ()
{
    UILabel *topTitleLabel;
    UILabel *voipTypeLabel;
    UIButton *avatarImageView;
    UILabel *nameLabel;
    UILabel *eventLabel;
    UILabel *callTimeLabel;//通话计时
    UIImageView *voipBgView;
    
    NSTimer *callTimer; //计时器
    int timeSeconds;
    
    //底部拨打电话按钮页面
    UIView *makeCallView;
    UIButton *freeCallBtn;//免费电话按钮,如果对方不在线，则需要通过网络电话拨打真实号码
    UIButton *callDownBtn;//挂断按钮
    
    //接通之后的底部按钮页面
    UIView *hasConnectView;
    UIButton *voiceButton;//扬声器按钮
    UIButton *muteBtnButton;//话筒静音按钮
    
    //更换SDK 将视频按钮 改为 切换摄像头的按钮
    UIButton *changCamerBut;  //切换摄像头的按钮
    
    UIButton *bottomCallDownButton;//挂断按钮

    
    //接通之后的底部按钮页面
    UIView *acceptCallView;
    UIButton *acceptButton;//接听按钮
    UIButton *rejectButton;//拒接按钮
    UIButton *msmButton;//拒接并发短信按钮
    
    //视频显示图层
    UIView *localVideoView;//自己的视频视图
    UIView *remoteVideoView;//对方的视频视图
   // UIButton *changeVideoCamaraBtn;//切换摄像头的按钮

    NSArray *camaraInfoArray;//摄像设备数组
    NSInteger curCameraIndex;
    
    
    BOOL callDownBtnClicked;
    BOOL callIsValid;  //电话是否接通
    int callUserDownCount;
    NSTimeInterval callTimeInterval;
    
    int h;   //时
    int m;   //分
    int s;   //秒

}

@end


@implementation VoipViewController

@synthesize callID;
@synthesize callType;
@synthesize callUser;
@synthesize callerAccount;
@synthesize voipType;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    callDownBtnClicked = NO;
    callUserDownCount = 0 ;
    callIsValid = NO;
    callTimeInterval = 0;
    
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callDown:) name:VOIPCALLDOWN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callBegin:) name:VOIPCALLBEGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callFail:) name:VOIPCALLFAIL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callUserDown) name:@"KNOTIFICATION_onConnected" object:nil];

    [self configureVoipView];
    [self configureCallHasConnectView];
    [self configureMakeCallBottomView];
    [self configureAcceptBottomView];
    
    if(voipType == VIDEO)
    {
        [self configureVideoView];
    }
    
    if(callType == 0)
    {
        //拨打  不论是视频还是语音都是走这边方法
        [self showMakeCallView];
        [self makeCall];
    }
    else
    {
        //接听
        [self showAcceptCallView];
        [self showAcceptUserInfo];
    }
    
    //关闭扬声器  免提设置
    
    [[ECDevice sharedInstance].VoIPManager enableLoudsSpeaker:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}

-(void)showAcceptUserInfo
{
    //接听电话的时候需要先获取对方用户信息加载
    callUser = [[SQLiteManager sharedInstance] getUserByVoipId:callerAccount];
    [self refreshCallUserInfo];
}


#pragma mark -
#pragma mark - Configure View
-(void)refreshCallUserInfo
{
    if(!callUser.bigpicurl || [callUser.bigpicurl length] == 0)
    {
        [avatarImageView setBackgroundImage:[Common getImageFromColor:[UIColor colorWithRGBHex:callUser.uname.hash % 0xffffff]] forState:UIControlStateNormal];
        [avatarImageView setTitle:[callUser.uname substringToIndex:1] forState:UIControlStateNormal];
    }
    else
    {
        __weak UIButton *tmp = avatarImageView;
        __weak MEnterpriseUser *user = callUser;
        [avatarImageView setImageWithURL:[NSURL URLWithString:callUser.bigpicurl] forState:UIControlStateNormal placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if(image)
            {
                [tmp setBackgroundImage:image forState:UIControlStateNormal];
            }
            else
            {
                [tmp setBackgroundImage:[Common getImageFromColor:[UIColor colorWithRGBHex:user.uname.hash % 0xffffff]] forState:UIControlStateNormal];
                [tmp setTitle:[user.uname substringToIndex:1] forState:UIControlStateNormal];
            }
        }];
    }
    nameLabel.text = callUser.uname;
}

- (void)configureVoipView
{
    voipBgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    voipBgView.image = [UIImage imageNamed:@"voip_bg"];
    [self.view addSubview:voipBgView];
    
    topTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, boundsWidth, 20)];
    topTitleLabel.backgroundColor = [UIColor clearColor];
    topTitleLabel.font = [UIFont systemFontOfSize:16.0];
    topTitleLabel.text = LOCALIZATION(@"Message_QiXiNet_Call");
    if(voipType == VIDEO)
    {
        topTitleLabel.text = LOCALIZATION(@"Message_QiXiNet_shiping");
    }
    topTitleLabel.textColor = [UIColor whiteColor];
    topTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:topTitleLabel];
    
    voipTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, topTitleLabel.frame.origin.y+topTitleLabel.frame.size.height+10, boundsWidth, 20)];
    voipTypeLabel.backgroundColor = [UIColor clearColor];
    voipTypeLabel.font = [UIFont systemFontOfSize:13.0];
    voipTypeLabel.text = LOCALIZATION(@"Message_wifi_free");
    voipTypeLabel.textAlignment = NSTextAlignmentCenter;
    voipTypeLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:voipTypeLabel];

    avatarImageView = [[UIButton alloc] initWithFrame:CGRectMake((boundsWidth-75)/2, voipTypeLabel.frame.origin.y+voipTypeLabel.frame.size.height+65, 75, 75)];
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width/2;
    avatarImageView.layer.borderColor = [UIColor hexChangeFloat:@"6fc0f7"].CGColor;
    avatarImageView.layer.borderWidth = 1;
    avatarImageView.userInteractionEnabled = NO;
    [self.view addSubview:avatarImageView];
    
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, avatarImageView.frame.origin.y+avatarImageView.frame.size.height+65, boundsWidth, 20)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont systemFontOfSize:18.0];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:nameLabel];
    
    eventLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nameLabel.frame.origin.y+nameLabel.frame.size.height+10, boundsWidth, 20)];
    eventLabel.backgroundColor = [UIColor clearColor];
    eventLabel.font = [UIFont systemFontOfSize:13.0];
    eventLabel.textAlignment = NSTextAlignmentCenter;
    eventLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:eventLabel];
    eventLabel.hidden = NO;
    
    callTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nameLabel.frame.origin.y+nameLabel.frame.size.height+10, boundsWidth, 20)];
    callTimeLabel.backgroundColor = [UIColor clearColor];
    callTimeLabel.font = [UIFont systemFontOfSize:16.0];

    callTimeLabel.textAlignment = NSTextAlignmentCenter;
    callTimeLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:callTimeLabel];
    callTimeLabel.hidden = YES;
    
    [self refreshCallUserInfo];
}

-(void)configureMakeCallBottomView
{
    //拨打电话底部按钮
    makeCallView = [[UIView alloc] initWithFrame:self.view.bounds];
    makeCallView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:makeCallView];
    makeCallView.userInteractionEnabled = YES;
    
    freeCallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    freeCallBtn.frame = CGRectMake(25, boundsHeight-120, boundsWidth-50, 40);
    freeCallBtn.layer.masksToBounds = YES;
    freeCallBtn.layer.cornerRadius = 6;
    freeCallBtn.backgroundColor = [UIColor whiteColor];
    [freeCallBtn setTitle:LOCALIZATION(@"Message_FreeCall") forState:UIControlStateNormal];
    [freeCallBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [freeCallBtn addTarget:self action:@selector(clickFreeCall) forControlEvents:UIControlEventTouchUpInside];
    [makeCallView addSubview:freeCallBtn];
    freeCallBtn.hidden = YES;
    
    callDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    callDownBtn.frame = CGRectMake(25, boundsHeight-60, boundsWidth-50, 40);
    callDownBtn.layer.masksToBounds = YES;
    callDownBtn.layer.cornerRadius = 6;
    callDownBtn.backgroundColor = [UIColor hexChangeFloat:@"e34d4e"];
    [callDownBtn setImage:[UIImage imageNamed:@"voip_cancel_long"] forState:UIControlStateNormal];
    [callDownBtn addTarget:self action:@selector(refuseClick) forControlEvents:UIControlEventTouchUpInside];
    [makeCallView addSubview:callDownBtn];
}


-(void)configureAcceptBottomView
{
    acceptCallView = [[UIView alloc] initWithFrame:self.view.bounds];
    acceptCallView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:acceptCallView];
    acceptCallView.userInteractionEnabled = YES;
    
//    msmButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    msmButton.frame = CGRectMake(25, boundsHeight-120, (boundsWidth-70)/2, 40);
//    msmButton.layer.masksToBounds = YES;
//    msmButton.layer.cornerRadius = 6;
//    msmButton.backgroundColor = [UIColor hexChangeFloat:@"54b8f3"];
//    [msmButton setImage:[UIImage imageNamed:@"voip_sms"] forState:UIControlStateNormal];
//    [msmButton addTarget:self action:@selector(refuseClickAndMsm) forControlEvents:UIControlEventTouchUpInside];
//    [acceptCallView addSubview:msmButton];

    acceptButton = [UIButton buttonWithType:UIButtonTypeCustom];
    acceptButton.frame = CGRectMake(25, boundsHeight-120, boundsWidth-50, 40);
    acceptButton.layer.masksToBounds = YES;
    acceptButton.layer.cornerRadius = 6;
    acceptButton.backgroundColor = [UIColor hexChangeFloat:@"3fc540"];
    [acceptButton setImage:[UIImage imageNamed:@"voip_accept"] forState:UIControlStateNormal];
    [acceptButton addTarget:self action:@selector(acceptClick) forControlEvents:UIControlEventTouchUpInside];
    [acceptCallView addSubview:acceptButton];
    
    rejectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rejectButton.frame = CGRectMake(25, boundsHeight-60, boundsWidth-50, 40);
    rejectButton.layer.masksToBounds = YES;
    rejectButton.layer.cornerRadius = 6;
    rejectButton.backgroundColor = [UIColor hexChangeFloat:@"e34d4e"];
    [rejectButton setImage:[UIImage imageNamed:@"voip_cancel_long"] forState:UIControlStateNormal];
    [rejectButton addTarget:self action:@selector(refuseClick) forControlEvents:UIControlEventTouchUpInside];
    [acceptCallView addSubview:rejectButton];
    acceptCallView.hidden = YES;
}

-(void)configureCallHasConnectView
{
    int actionNum = 3;
    if(voipType == VIDEO)
    {
        actionNum = 4;
    }
    CGFloat buttonWidth = boundsWidth/actionNum;
    //接通之后的界面
    hasConnectView = [[UIView alloc] initWithFrame:CGRectMake(0, boundsHeight-buttonWidth-10, boundsWidth, buttonWidth)];
    hasConnectView.backgroundColor = [UIColor clearColor];
    hasConnectView.userInteractionEnabled = YES;
    [self.view addSubview:hasConnectView];
    for(int i = 0 ; i < actionNum ; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonWidth*i, 0, buttonWidth, buttonWidth);
        button.backgroundColor = [UIColor clearColor];
        [hasConnectView addSubview:button];
        switch (i) {
            case 0:
                voiceButton = button;
                break;
            case 1:
                muteBtnButton = button;
                break;
            case 2:
                if(voipType == VOICE){
                    bottomCallDownButton = button;
                }
                else{
                    changCamerBut = button;
                }
                break;
            case 3:
                bottomCallDownButton = button;
                break;
            default:
                break;
        }
    }
    [voiceButton setImage:[UIImage imageNamed:@"voip_voice_off"] forState:UIControlStateNormal];
    [voiceButton setImage:[UIImage imageNamed:@"voip_voice_on"] forState:UIControlStateSelected];
    [voiceButton addTarget:self action:@selector(clickVoiceButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [muteBtnButton setImage:[UIImage imageNamed:@"voip_sound_off"] forState:UIControlStateNormal];
    [muteBtnButton setImage:[UIImage imageNamed:@"voip_sound_on"] forState:UIControlStateSelected];
    [muteBtnButton addTarget:self action:@selector(clickMuteButton:) forControlEvents:UIControlEventTouchUpInside];

    //更换SDK 将视频按钮名称该名称
    [changCamerBut setImage:[UIImage imageNamed:@"摄像头Off"] forState:UIControlStateNormal];
    [changCamerBut setImage:[UIImage imageNamed:@"摄像头On"] forState:UIControlStateSelected];
    //更换SDK 将视频按钮点击事件换成 切换摄像头点击事件
    //[videoButton addTarget:self action:@selector(clickVideoButton:) forControlEvents:UIControlEventTouchUpInside];
    [changCamerBut addTarget:self action:@selector(changeVideoCamara) forControlEvents:UIControlEventTouchUpInside];

    
    [bottomCallDownButton addTarget:self action:@selector(callUserDown) forControlEvents:UIControlEventTouchUpInside];
    [bottomCallDownButton setImage:[UIImage imageNamed:@"voip_cancel"] forState:UIControlStateNormal];
}

-(void)configureVideoView
{
    localVideoView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 80, 100)];
    remoteVideoView = [[UIView alloc] initWithFrame:self.view.bounds];
    remoteVideoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inVideoClickOtherSpace)];
    [remoteVideoView addGestureRecognizer:tap];

    
//    changeVideoCamaraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    changeVideoCamaraBtn.frame = CGRectMake(boundsWidth-70-15, 35, 70, 35);
//    [changeVideoCamaraBtn addTarget:self action:@selector(changeVideoCamara) forControlEvents:UIControlEventTouchUpInside];
//    [changeVideoCamaraBtn setImage:[UIImage imageNamed:@"voip_camera_switch"] forState:UIControlStateNormal];
    
    int rates= 150;
    [[ECDevice sharedInstance].VoIPManager setVideoBitRates:rates];//设置码率
    [[ECDevice sharedInstance].VoIPManager setVideoView:remoteVideoView andLocalView:localVideoView];//设置显示图层
    [self defaultSetForwardCamara];//设置前置摄像头
    
    [self.view addSubview:localVideoView];
    [self.view addSubview:remoteVideoView];
    [self.view sendSubviewToBack:localVideoView];
    [self.view sendSubviewToBack:remoteVideoView];
//    [self.view addSubview:changeVideoCamaraBtn];
//    changeVideoCamaraBtn.hidden = YES;
    localVideoView.hidden = YES;
    remoteVideoView.hidden = YES;

}

#pragma mark -
#pragma mark - Video Founctions
-(void)defaultSetForwardCamara
{
    //默认设置前置摄像头
    camaraInfoArray = [[ECDevice sharedInstance].VoIPManager getCameraInfo];
    curCameraIndex = camaraInfoArray.count-1;
    if (curCameraIndex >= 0)
    {
        CameraDeviceInfo *camera = [camaraInfoArray objectAtIndex:curCameraIndex];
        NSInteger cameraIndex = camera.index;
        if (cameraIndex >= camaraInfoArray.count) {
            return;
        }
        
        NSInteger fps = 12;
        NSInteger capabilityIndex = 0;
        [[ECDevice sharedInstance].VoIPManager selectCamera:cameraIndex capability:capabilityIndex fps:fps rotate:Rotate_Auto];
    }
}

-(void)changeVideoCamara
{
    curCameraIndex ++;
    if (curCameraIndex >= camaraInfoArray.count)
    {
        curCameraIndex = 0;
    }
    CameraDeviceInfo *camera = [camaraInfoArray objectAtIndex:curCameraIndex];
    NSInteger cameraIndex = camera.index;
    if (cameraIndex >= camaraInfoArray.count) {
        return;
    }
    NSInteger fps = 12;
    NSInteger capabilityIndex = 0;
    [[ECDevice sharedInstance].VoIPManager selectCamera:cameraIndex capability:capabilityIndex fps:fps rotate:Rotate_Auto];
}


#pragma mark -
#pragma mark - ChangeView When Different Status

-(void)showVideoView
{
    //显示视频页面
    changCamerBut.hidden = NO;
    voipBgView.hidden = YES;
    localVideoView.hidden = NO;
    remoteVideoView.hidden = NO;
    avatarImageView.hidden = YES;
    topTitleLabel.hidden = YES;
    voipTypeLabel.hidden = YES;
}

//更换SDK 去掉视频通话切换到音频通话
//-(void)changeVideoToVoice
//{
//    //视频通话切换到音频通话
//    changeVideoCamaraBtn.hidden = YES;//语音通话不存在切换摄像头这个玩意儿
//    voipBgView.hidden = NO;
//    localVideoView.hidden = YES;
//    remoteVideoView.hidden = YES;
//    avatarImageView.hidden = NO;
//    topTitleLabel.hidden = NO;
//    voipTypeLabel.hidden = NO;
//}

-(void)showConnectCallView
{
    avatarImageView.hidden = NO;
    callTimeLabel.hidden = NO;
    eventLabel.hidden = YES;
    hasConnectView.hidden = NO;
    makeCallView.hidden = YES;
    acceptCallView.hidden = YES;
    if(voipType == VIDEO)
    {
        [self showVideoView];
    }
}

-(void)showMakeOrginCallView
{
    //显示拨打落地电话
    eventLabel.text = LOCALIZATION(@"Mesage_Call_FreeCall");
    callTimeLabel.text = @"";
    callTimeLabel.hidden = YES;
    eventLabel.hidden = NO;
    hasConnectView.hidden = YES;
    makeCallView.hidden = NO;
    acceptCallView.hidden = YES;
    freeCallBtn.hidden = NO;
}

-(void)showMakeCallView
{
    eventLabel.text = LOCALIZATION(@"Message_Play_calling");
    callTimeLabel.text = @"";
    callTimeLabel.hidden = YES;
    eventLabel.hidden = NO;
    hasConnectView.hidden = YES;
    makeCallView.hidden = NO;
    acceptCallView.hidden = YES;
    freeCallBtn.hidden = YES;
}

-(void)showAcceptCallView
{
//    eventLabel.text = @"正在拨打...";
//    callTimeLabel.text = @"";
    callTimeLabel.hidden = YES;
    eventLabel.hidden = NO;
    hasConnectView.hidden = YES;
    makeCallView.hidden = YES;
    acceptCallView.hidden = NO;
}

-(void)inVideoHiddenOtherView
{
    //视频过程中，点击空白区域隐藏时间姓名还有底部按钮
    nameLabel.hidden = YES;
    callTimeLabel.hidden = YES;
    hasConnectView.hidden = YES;
    
}

-(void)inVideoShowOtherView
{
    //视频过程中，点击空白区域显示时间姓名还有底部按钮
    nameLabel.hidden = NO;
    callTimeLabel.hidden = NO;
    hasConnectView.hidden = NO;
   
}

-(void)inVideoClickOtherSpace
{
    //点击空白区域
    if(nameLabel.hidden)
    {
        [self inVideoShowOtherView];
    }
    else
    {
        [self inVideoHiddenOtherView];
    }
}

#pragma mark -
#pragma mark - Call Notification Events
- (void)callFail:(NSNotification *)noti
{
    NSString *callid = noti.object[@"callId"];
    NSString *reasonCode = noti.object[@"reasonCode"];
    if(!callid || [callid length] == 0 || [reasonCode intValue] == 4 || [reasonCode intValue] == ECErrorType_OtherSideOffline)
    {
        //对方不在线
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_duifan_noLin") isDismissLater:YES];
        if(voipType == VOICE)
        {
            //语音电话不在线显示免费落地电话按钮
            [self showMakeOrginCallView];
        }
        else if(voipType == VIDEO)
        {
            //视频电话不在线直接退出界面
            [self exitVoipView];
        }
    }
    else
    {
        
        if (reasonCode.intValue == ECErrorType_TemporarilyNotAvailable) {//请求超时
            
            //A打电话出去  B长时间没有接（则A自动挂断 请求超时）
//            [self handleCallHangUp:CallHangUpTypeTimeOut userInfo:nil];
            [MMProgressHUD showHUDWithTitle:@"无人应答" isDismissLater:YES];
        }else{
            
            [MMProgressHUD showHUDWithTitle:@"对方忙" isDismissLater:YES];
        }
        [self exitVoipView];
        
        
    }
    [[DeviceDelegateHelper ShareInstance] releaseCalling:callID];
}

//- (void)callMediaChange:(NSNotification *)noti
//{
//    NSInteger type = [noti.object[@"requestCode"] integerValue];
//    if (type == 0)
//    {
//        //0为增加视频
//        [self showVideoView];
//    }
//    else
//    {
//        //1为删除视频
//        [self changeVideoToVoice];
//    }
////    回复类型，1代表同意，0代表拒绝，默认同意
//    [[CCPManager ShareInstance].voipCallService responseSwitchCallMediaType:callID withAction:1];
//    videoButton.selected = !videoButton.selected;
//}


- (void)callDown:(NSNotification*)noti
{
    
    if (callDownBtnClicked == NO && callIsValid == NO) {//别人挂断的
        
        if (callType == 0) {
            
            //A打电话出去 B挂断
//            [self handleCallHangUp:CallHangUpTypeOtherNotConnect userInfo:nil];
            
        }else{
            //B打电话进来 B挂断（A没有接听 也是B挂断）
//            [self handleCallHangUp:CallHangUpTypeNotAnswer userInfo:nil];
        }
        
    }
    
    if (callIsValid == YES) {//接通之后挂断电话
        //A打电话出去 B接听后挂掉
        //A打电话出去 B接听后 A 挂掉
        //B打电话进来 A接听后挂掉
        //B打电话进来 A接听后 B 挂掉
        if (callUserDownCount == 1 || callUserDownCount == 0) {
            callUserDownCount++;
//            [self handleCallHangUp:CallHangUpTypeDownConnected userInfo:@{@"timeSeconds":@(timeSeconds)}];
        }
        
        
    }
    
    [self exitVoipView];
}


- (void)callBegin:(NSNotification*)noti
{
    callIsValid = YES;
    
    if (voipType == 1) {
        [self clickVoiceButton:voiceButton];
    }
    
    [self showConnectCallView]; //不论是视频通话 还是音频通话都在这里面绘制界面
    timeSeconds = 0;
    callTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(updateTimeLabel) userInfo:nil repeats:YES];
}


#pragma mark -
#pragma mark - Call Events
-(void)makeCall
{
    eventLabel.text = LOCALIZATION(@"Message_Play_calling");
    callTimeLabel.text = @"";
    // 更换SDK  拨打电话
    if (callUser) {
        [[ECDevice sharedInstance] getUserState:(callUser.viopId)?callUser.viopId:@"" completion:^(ECError *error, ECUserState *state) {
            NSLog(@"#############%@",state);
        }];
        callID =[[DeviceDelegateHelper ShareInstance] makeCall:(callUser.viopId)?callUser.viopId:@"" withPhone:@"" withType:voipType withVoipType:1];
    }
}

- (void)clickFreeCall
{
    eventLabel.text = LOCALIZATION(@"Message_Play_calling");
    callTimeLabel.text = @"";
    //更换SDK  拨打免费电话（落地电话）所要调用的SDK 方法
    callID =[[DeviceDelegateHelper ShareInstance] makeCall:callUser.viopId withPhone:callUser.mobile withType:LandingCall withVoipType:0];
}


- (void)clickVoiceButton:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [[ECDevice sharedInstance].VoIPManager enableLoudsSpeaker:sender.selected];
}

- (void)clickMuteButton:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [[ECDevice sharedInstance].VoIPManager setMute:sender.selected];

}

//- (void)clickVideoButton:(UIButton *)sender
//{
//    sender.selected = !sender.selected;
//    NSInteger type = [[CCPManager ShareInstance].voipCallService getCallMediaType:callID];
//    if (type == EVoipCallType_Video)
//    {
//        type = EVoipCallType_Voice;
//        [self changeVideoToVoice];
//    }
//    else
//    {
//        type = EVoipCallType_Video;
//        [self showVideoView];
//    }
//    [[CCPManager ShareInstance].voipCallService requestSwitchCall:callID toMediaType:type];
//}

- (void)acceptClick
{
    [[DeviceDelegateHelper ShareInstance] acceptInComingCall:callID];
}

- (void)refuseClick
{
    
    callDownBtnClicked = YES;
    
    //自己挂断电话
    
    if (callType == 1) {
        // 更换SDK   是接电话的一方 则按拒接按钮 （没有接听）就发送这个通知
//        [self handleCallHangUp:CallHangUpTypeNotAnswer userInfo:nil];
        
    }else{
        //是自己拨打电话 然后再按拒接按钮 是取消呼出
//        [self handleCallHangUp:CallHangUpTypeSelfNotConnect userInfo:nil];
        
    }
    
    // 更换SDK   呼叫方和被呼叫方 都没有接听的情况下 A 直接点击挂断电话按钮 调用的方法
    [[DeviceDelegateHelper ShareInstance] rejectInComingCall:callID];
    // 退出电话界面
    [self exitVoipView];
}



-(void)callUserDown
{
    
    callUserDownCount++;
    
    if(callTimer)
    {
        callIsValid = YES;
        [callTimer invalidate];
        callTimer = nil;
    }
    
    // B打A电话，A接听后 再挂断； A打B电话，B接听 再挂断；
    [[DeviceDelegateHelper ShareInstance] releaseCalling:callID];
    //    [self exitVoipView];
    [self callDown:nil];
}



- (void)refuseClickAndMsm
{
    // 更换SDK   呼叫方和被呼叫方 都没有接听的情况下直接点击挂断电话按钮 调用的方法
    [[DeviceDelegateHelper ShareInstance] rejectInComingCall:callID];
    //退出电话界面
    [UIView animateWithDuration:0.6 animations:^{
        self.view.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        [self sendSmsWithPhones:[NSArray arrayWithObject:callUser.mobile]];
    }];
}

-(void)sendSmsWithPhones:(NSArray*)phoneNumbers{
    
    if([MFMessageComposeViewController canSendText]){
        AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
        MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];
        messageComposeViewController.messageComposeDelegate = appDelegate.mainNav;
        [messageComposeViewController setRecipients:phoneNumbers];
        [messageComposeViewController setBody:LOCALIZATION(@"Message_sorry")];
        [appDelegate.mainNav presentViewController:messageComposeViewController animated:YES completion:nil];
        
    }else{
        CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"" message:LOCALIZATION(@"Message_CXAlertView_message") cancelButtonTitle:LOCALIZATION(@"EnterpriseUserCardViewController_Confirm")];
        alertView.showBlurBackground = YES;
        [alertView show];
    }
}

- (void)exitVoipView
{
    if(callTimer)
    {
        callIsValid = YES;
        [callTimer invalidate];
        callTimer = nil;
    }
    //退出电话界面
    [UIView animateWithDuration:0.6 animations:^{
        self.view.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    }];
}



#pragma mark -
#pragma mark - Timer Events

-(void)updateTimeLabel {
    timeSeconds ++;
    int hour= timeSeconds/3600;
    int minutes= (timeSeconds-h*3600)/60;
    int seconde= (timeSeconds-h*3600) % 60;
    if (hour>0) {
        callTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minutes,seconde];
    }
    else
    {
        callTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",minutes,seconde];
    }
}

- (void)handleCallHangUp:(CallHangUpType)type userInfo:(NSDictionary*)userInfo{
    
    CallHangUpType hangupType = type;
    
    //   区分语音和视频  加了currentCallType字段区分
    switch (hangupType) {
        case CallHangUpTypeTimeOut:
            [self insertCallHangUpMessageToDatabase:@" 语音电话 无人应答 ，呼叫超时" type:CallHangUpTypeTimeOut];
            break;
            
        case CallHangUpTypeDownConnected:
        {
            int timeInterval = [[userInfo valueForKey:@"timeSeconds"] intValue];
            
            [self convertVoipTimeToFormatter:timeInterval];
            
            NSString *message;
            
            if (h > 0 ) {
                message = [NSString stringWithFormat:@" %@通话 通话时长 %02d:%02d:%02d",(self.voipType==1)?@"视频":@"语音",h,m,s];
            }else{
                
                message = [NSString stringWithFormat:@" %@通话 通话时长 %02d:%02d",(self.voipType==1)?@"视频":@"语音",m,s];
            }
            [self insertCallHangUpMessageToDatabase:message type:CallHangUpTypeDownConnected];
        }
            break;
            
        case CallHangUpTypeOtherNotConnect:
            [self insertCallHangUpMessageToDatabase:[NSString stringWithFormat:@" %@通话 对方拒绝您的呼叫请求",(self.voipType==1)?@"视频":@"语音"] type:CallHangUpTypeOtherNotConnect];
            break;
            
        case CallHangUpTypeSelfNotConnect:
            [self insertCallHangUpMessageToDatabase:[NSString stringWithFormat:@" %@通话 已取消",(self.voipType==1)?@"视频":@"语音"] type:CallHangUpTypeSelfNotConnect];
            break;
            
        case CallHangUpTypeNotAnswer:
            [self insertCallHangUpMessageToDatabase:[NSString stringWithFormat:@" %@通话 未接听，点击回拨",(self.voipType==1)?@"视频":@"语音"] type:CallHangUpTypeNotAnswer];
            
        default:
            break;
    }
}


- (void)convertVoipTimeToFormatter:(NSTimeInterval)timeInterval{
    
    //将通话时长转化为时分秒格式
    m = 0;
    h = 0;
    s = 0;
    if (timeInterval / 3600 > 0){
        h = timeInterval / 3600;
        if ((timeInterval - h * 3600) / 60 > 0){
            m = timeInterval / 60;
            s = timeInterval -(h * 3600) - (m * 60);
        }else{
            
            s = timeInterval - h * 3600;
        }
    }else if(timeInterval / 60 > 0){
        
        m = timeInterval / 60;
        s = (timeInterval - m * 60);
        
    } else {
        
        s = timeInterval;
    }
    
}

//将挂断电话的信息插入数据库
- (void)insertCallHangUpMessageToDatabase:(NSString*)message type:(CallHangUpType)type{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MMessage *mm =[[MMessage alloc] init];
        mm.msgId =[NSString stringWithUUID];
        
        mm.contenttype =[NSString stringWithFormat:@"%d",MMessageContentTypeText];
        mm.msg = message;
        
        if (callType == 0) {//打电话
            mm.keyid = [NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
            mm.srState =[NSString stringWithFormat:@"%d",MMessageSRStateSendSuccess];
            mm.sessionname=self.callUser.uname;
            mm.sessionid = self.callUser.uid;
            mm.username =[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"name"]];
        }else{
            mm.keyid = self.callUser.uid;
            mm.srState =[NSString stringWithFormat:@"%d",MMessageSRStateReceiveUnread];
            mm.sessionname=self.callUser.uname;
            mm.sessionid =[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
            mm.username =self.callUser.uname;
            
        }
        
        mm.identity =[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
        mm.headpicurl =[[ConfigManager sharedInstance].userDictionary objectForKey:@"bigpicurl"];
        mm.modeltype= @"0";
        mm.sendTime =[NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970]*1000];
        mm.msgOtherId =self.callUser.uid;
        mm.msgOtherName =mm.sessionname;
        mm.msgOtherAvatar=self.callUser.bigpicurl;
        mm.type =[NSString stringWithFormat:@"%d",MMessageTypeChat];
        mm.bigpicurl = [NSString stringWithFormat:@"%@-%d",@"callHangUp",self.voipType];//无所不用其极
        
        NSDictionary *faceMap = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"faceMap" ofType:@"plist"]];
        NSData *cssData=[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bubblechat" ofType:@"css"]];
        DTCSSStylesheet *cssSheet=[[DTCSSStylesheet alloc] initWithStyleBlock:[[NSString alloc] initWithData:cssData encoding:NSUTF8StringEncoding]];
        //[mm handleFaceMap:faceMap cssSheet:cssSheet];
        [[SQLiteManager sharedInstance] insertMessagesToSQLite:[NSArray arrayWithObject:mm] notificationName:NOTIFICATION_R_SQL_MESSAGE];
        
    });
}

@end
