//
//  AudioConferenceViewController.m
//  IM
//
//  Created by syj on 14-8-28.
//  Copyright (c) 2014年 rongfzh. All rights reserved.
//

#import "AudioConferenceViewController.h"

@interface AudioConferenceViewController ()

@end

@implementation AudioConferenceViewController
@synthesize callID;
@synthesize callType;
@synthesize callUser;
@synthesize callerAccount;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"0x344552"];
    
    [self setupTopView];
    
    [self setupView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callDown) name:@"VOIPcallDown" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callBegin) name:@"VOIPcallBegin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callFail) name:@"VOIPcallFail" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [super viewWillDisappear:YES];
    
//    if (callType == 0) {
////        [self makeCall:@"82194200000046" withPhone:@"" withType:0 withVoipType:1];
//        [self switchStatus:0];
//        [[CCPManager ShareInstance] makeCall:callUser.viopId withPhone:@"" withType:0 withVoipType:1];
//    }
//    else
//    {
//        [self switchStatus:2];
//    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBackView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupTopView
{
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 44+(CURRENT_SYS_VERSION>=7?20:0))];
    topView.tag = 100;
    topView.image = [UIImage imageNamed:@"AudioConference_top.png"];
    topView.userInteractionEnabled = YES;
    [self.view addSubview:topView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, (CURRENT_SYS_VERSION>=7?20:0), boundsWidth, 44)];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont boldSystemFontOfSize:22];
    titleLab.text = LOCALIZATION(@"Message_Void_Phone");
    [topView addSubview:titleLab];
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//    backBtn.frame = CGRectMake(10, 7+(CURRENT_SYS_VERSION>=7?20:0), 40, 30);
//    [backBtn addTarget:self action:@selector(goBackView) forControlEvents:UIControlEventTouchUpInside];
//    [topView addSubview:backBtn];
//    [self.view addSubview:topView];
}

- (void)setupView
{
    UIImageView *topView = (UIImageView *)[self.view viewWithTag:100];
    peopleHPBG = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topView.frameBottom+100, boundsWidth, 100)];
    peopleHPBG.backgroundColor = [UIColor clearColor];
    [self.view addSubview:peopleHPBG];
    peopleHPBG.contentSize = CGSizeMake(0, 0);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((boundsWidth-50)/2, 10, 50, 50);
    [btn setBackgroundImage:[UIImage imageNamed:@"headBG.png"] forState:UIControlStateNormal];
    [peopleHPBG addSubview:btn];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 50, 30)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = FONT12;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = LOCALIZATION(@"Message_dcf");
    [peopleHPBG addSubview:nameLabel];
    
    //    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    btn.frame = CGRectMake(70, 10, 50, 50);
    //    [btn setBackgroundImage:[UIImage imageNamed:@"AudioConference_add.png"] forState:UIControlStateNormal];
    //    [peopleHPBG addSubview:btn];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 60, 50, 30)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = FONT12;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    //    lab.text = @"董春飞";
    [peopleHPBG addSubview:nameLabel];
    
    cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(0, boundsHeight-47-(CURRENT_SYS_VERSION>=7?0:20), 300, 42);
    [cancleBtn setBackgroundImage:[UIImage imageNamed:@"voip_cancel_long.png"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(refuseClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancleBtn];
    
    statusLab = [[UILabel alloc] initWithFrame:CGRectMake(5, btn.frameY-30, boundsWidth-5, 30)];
    statusLab.backgroundColor = [UIColor clearColor];
    statusLab.textColor = [UIColor grayColor];
    statusLab.font = FONT12;
    statusLab.text = LOCALIZATION(@"Message_calling");
    statusLab.hidden = YES;
    [self.view addSubview:statusLab];
    
    timeLab = [[UILabel alloc] initWithFrame:CGRectMake(5, cancleBtn.frameY-30, boundsWidth-10, 30)];
    timeLab.backgroundColor = [UIColor clearColor];
    timeLab.textColor = [UIColor blackColor];
    timeLab.textAlignment = NSTextAlignmentCenter;
    timeLab.font = FONT14;
    timeLab.text = LOCALIZATION(@"Message_jietong");
    //    timeLab.hidden = YES;
    [self.view addSubview:timeLab];
    
    
    huatongBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 101, 81)];
    huatongBG.image = [UIImage imageNamed:@"AudioConference_huatongBG.png"];
    huatongBG.center = self.view.center;
    huatongBG.hidden = YES;
    [self.view addSubview:huatongBG];
    
    UIImageView *huatong = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 48, 61)];
    huatong.image = [UIImage imageNamed:@"AudioConference_huatong.png"];
    [huatongBG addSubview:huatong];
    
    volumeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    volumeBtn.frame = CGRectMake(10,timeLab.frameY-40, 50, 50);
    [volumeBtn setBackgroundImage:[UIImage imageNamed:@"AudioConference_volumeBtn.png"] forState:UIControlStateNormal];
    [volumeBtn setBackgroundImage:[UIImage imageNamed:@"AudioConference_volumeBtn2.png"] forState:UIControlStateSelected];
    [volumeBtn addTarget:self action:@selector(showhuatongBG) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:volumeBtn];
    
    muteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    muteBtn.frame = CGRectMake(70,timeLab.frameY-40, 50, 50);
    [muteBtn setBackgroundImage:[UIImage imageNamed:@"AudioConference_muteBtn.png"] forState:UIControlStateNormal];
    [muteBtn setBackgroundImage:[UIImage imageNamed:@"AudioConference_muteBtn2.png"] forState:UIControlStateSelected];
    [muteBtn addTarget:self action:@selector(muteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:muteBtn];
    
    refuseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refuseBtn.frame = CGRectMake(10,cancleBtn.frameY-45, 120, 45);
    [refuseBtn setBackgroundImage:[UIImage imageNamed:@"AudioConference_refuse.png"] forState:UIControlStateNormal];
    [refuseBtn setTitle:LOCALIZATION(@"Message_DetailRefuse") forState:UIControlStateNormal];
    [refuseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    refuseBtn.hidden = YES;
    [refuseBtn addTarget:self action:@selector(refuseClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refuseBtn];
    
    accrptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    accrptBtn.frame = CGRectMake(boundsWidth-130,cancleBtn.frameY-45, 120, 45);
    [accrptBtn setBackgroundImage:[UIImage imageNamed:@"AudioConference_accept.png"] forState:UIControlStateNormal];
    [accrptBtn setTitle:LOCALIZATION(@"Message_jieting") forState:UIControlStateNormal];
    [accrptBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    accrptBtn.hidden = YES;
    [accrptBtn addTarget:self action:@selector(acceptClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:accrptBtn];
    
}

- (void)showhuatongBG
{
    huatongBG.hidden = !huatongBG.hidden;
}

- (void)muteBtnClick
{
    muteBtn.selected = !muteBtn.selected;
    volumeBtn.selected = muteBtn.selected;
}

- (void)switchStatus:(int)type
{
    switch (type) {
        case 0://6.2消息_聊天插入语音会议单人呼叫状态
        {
            statusLab.hidden = NO;
            timeLab.hidden = NO;
            volumeBtn.hidden = YES;
            muteBtn.hidden = YES;
            huatongBG.hidden = YES;
            refuseBtn.hidden = YES;
            accrptBtn.hidden = YES;
            cancleBtn.hidden = NO;
            [self setupPeopleView:NO];
        }
            break;
        case 1://6.3消息_聊天插入语音会议单人通话状态 6.4消息_聊天插入语音会议单人通话状态静音和扬声器
        {
            statusLab.hidden = YES;
            timeLab.hidden = NO;
            volumeBtn.hidden = NO;
            muteBtn.hidden = NO;
            huatongBG.hidden = YES;
            refuseBtn.hidden = YES;
            accrptBtn.hidden = YES;
            cancleBtn.hidden = NO;
            [self setupPeopleView:NO];
        }
            break;
        case 2://6.5消息_聊天插入语音会议单人被呼叫状态
        {
            statusLab.hidden = YES;
            timeLab.hidden = YES;
            volumeBtn.hidden = YES;
            muteBtn.hidden = YES;
            huatongBG.hidden = YES;
            refuseBtn.hidden = NO;
            accrptBtn.hidden = NO;
            cancleBtn.hidden = YES;
            [self setupPeopleView:YES];
        }
            break;
        default:
            break;
    }
}

- (void)setupPeopleView:(BOOL)isCalled
{
    for(UIView *v in peopleHPBG.subviews)
        [v removeFromSuperview];
    if(isCalled)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10, 10, 50, 50);
        [btn setBackgroundImage:[UIImage imageNamed:@"headBG.png"] forState:UIControlStateNormal];
        [peopleHPBG addSubview:btn];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(70, 10-2, boundsWidth-70, 30)];
        lab.backgroundColor = [UIColor clearColor];
        lab.textColor = [UIColor blackColor];
        lab.font = [UIFont systemFontOfSize:22];
        lab.text = callUser.uname;
        [peopleHPBG addSubview:lab];
        
        lab = [[UILabel alloc] initWithFrame:CGRectMake(70, 40-2, boundsWidth-70, 30)];
        lab.backgroundColor = [UIColor clearColor];
        lab.textColor = [UIColor blackColor];
        lab.font = [UIFont systemFontOfSize:13];
        lab.text = LOCALIZATION(@"Message_callYou_videoMett");
        [peopleHPBG addSubview:lab];
    }
    else
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10, 10, 50, 50);
        [btn setBackgroundImage:[UIImage imageNamed:@"headBG.png"] forState:UIControlStateNormal];
        [peopleHPBG addSubview:btn];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 50, 30)];
        lab.backgroundColor = [UIColor clearColor];
        lab.font = FONT12;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = callUser.uname;
        [peopleHPBG addSubview:lab];
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(70, 10, 50, 50);
        [btn setBackgroundImage:[UIImage imageNamed:@"AudioConference_add.png"] forState:UIControlStateNormal];
        [peopleHPBG addSubview:btn];
        
        lab = [[UILabel alloc] initWithFrame:CGRectMake(70, 60, 50, 30)];
        lab.backgroundColor = [UIColor clearColor];
        lab.font = FONT12;
        lab.textAlignment = NSTextAlignmentCenter;
        //    lab.text = @"董春飞";
        [peopleHPBG addSubview:lab];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2) {
        [self.navigationController popViewControllerAnimated:YES];
        [[ECDevice sharedInstance].VoIPManager releaseCall:callID];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)callFail
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LOCALIZATION(@"EnterpriseUserCardViewController_Prompt") message:LOCALIZATION(@"Message_call_filed") delegate:self cancelButtonTitle:LOCALIZATION(@"Message_CXAlertView_title") otherButtonTitles:nil, nil];
    alert.tag = 2;
    [alert show];
}

- (void)callDown
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LOCALIZATION(@"EnterpriseUserCardViewController_Prompt") message:LOCALIZATION(@"Message_call_break") delegate:self cancelButtonTitle:LOCALIZATION(@"Message_CXAlertView_title") otherButtonTitles:nil, nil];
    alert.tag = 1;
    [alert show];

}

- (void)callBegin
{
    timeSeconds = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

- (void)onTimer {
	[self updateLabel];
}


-(void)updateLabel {
    timeSeconds ++;
    int h= timeSeconds/3600;
    int m= (timeSeconds-h*3600)/60;
    int s= (timeSeconds-h*3600) % 60;
    if (h>0) {
        timeLab.text = [NSString stringWithFormat:@"%02d:%02d:%02d", h, m,s];
    }
    else
    {
        timeLab.text = [NSString stringWithFormat:@"%02d:%02d",m,s];
    }
}


- (void)acceptClick
{
    [self switchStatus:1];
    NSLog(@"--%@",callID);
    [[ECDevice sharedInstance].VoIPManager acceptCall:callID];
}
- (void)refuseClick
{
    [[ECDevice sharedInstance].VoIPManager releaseCall:callID];
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
