 //
//  ChatViewController.m
//  IM
//
//  Created by zuo guoqing on 14-11-25.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "ChatViewController.h"
#import "AudioConferenceViewController.h"
#import "MTZRadialMenu.h"
#import "ZLPhoto.h"
#import "QBImagePickerController.h"
#import "VoipViewController.h"
#import "AllUserViewController.h"
#import "ZTEUserProfileTools.h"
#import "TTOpenInAppActivity.h"
#import "MEnterpriseUser.h"
#import "Translator.h"

#define PICTIONSHEET   400000

#define VIDEOTIONSHEET   400001
#define MAKECALLTIONSHEET   400002

#define MessageLimit 15  //数据库获取消息的记录条数限制

typedef NS_ENUM(NSInteger, MessageType){
    MessageTypePrivate = 1,
    MessageTypeGroup = 2
};

@interface ChatViewController () <MTZRadialMenuDelegate,QBImagePickerControllerDelegate>
{
    UIImageView *lastAnimationImageView;// 播放语音动画的上一次动画view;
    NSInteger   voiceAnimationRow;//当前正在播放语音的cell的row，为-1的时候没有语音播放
    BOOL justFinishRecord;//刚好60s录制完，并且松开手指的时候不能播放
    
    
    int messageOffset;  //数据库获取条数的偏移量
    int messageCount;   //消息总数
    
    int loadCount;
    
    int h;   //时
    int m;   //分
    int s;   //秒
    
    CallType hangUpRecordType;
    
    BOOL isSelfRemoveFromGroup;//是不是被移出了某个群
    
    CallType currentCallType;
    
}

@property (nonatomic, strong) UIPopoverController *doucmentInteractionVC;

@property (nonatomic, getter = isMicrophoneRecording) BOOL microphoneRecording;
@property (strong, nonatomic) MTZRadialMenu *microphoneRadialMenu;
@property (strong, nonatomic) MTZRadialMenuItem *microphoneRecordingStopAction;
@property (strong, nonatomic) MTZRadialMenuItem *microphoneRecordingPlaybackPlayAction;
@property (strong, nonatomic) MTZRadialMenuItem *microphoneRecordingPlaybackPauseAction;
@property (strong, nonatomic) MTZRadialMenuItem *microphoneRecordingSendAction;
@property (strong, nonatomic) NSString *amrPath;
@property (strong, nonatomic) NSString *wavPath;
@property (strong, nonatomic) UIView *voiceView;

@property (nonatomic, copy)  NSString *vidioPath;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, assign) int uploadImageCount;


@property (nonatomic, assign) int messageLimit;
@property (nonatomic, assign) int voiceCallType;

@end

@implementation ChatViewController

#pragma mark - Life Circle 生命周期
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        voiceAnimationRow = -1;

        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRSQLMessage) name:NOTIFICATION_R_SQL_MESSAGE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationUSQLMessageSendState:) name:NOTIFICATION_U_SQL_MESSAGE_SENDSTATE object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(norificationUSQLGroupName:) name:NOTIFICATION_U_SQL_GROUP object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userRemovedFromGroup:) name:@"userRemovedFromGroup" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInvitedToJoinGroup:) name:@"invitedToJoin" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didClikcedReusltMesssage:) name:@"didClickedReusltMessage" object:nil];
        
        //监听语音电话结束通知
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voipcallHangUp:) name:CallHangUpNotification object:nil];
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(microphoneCancel) name:MICROPHONECANCEL object:nil];
    //    self.tbView.frame = CGRectMake(self.tbView.frame.origin.x, self.tbView.frame.origin.y, boundsWidth, self.tbView.frame.size.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _messageArray = [NSMutableArray array];
    
    [self setupViews];
    
    [self loadDataWithFlag:0];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //临时解决一下前面界面没做隐藏键盘操作，到聊天界面出现表情与更多功能重叠的bug
        [self hideBoardWithVoiceBtnSelected:NO];
    });
    //转发
    if (_isForward) {
        [self handleForwardMessage];
    }
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    //    appDelegate.centerButton.hidden=NO;
    [self hideBoardWithVoiceBtnSelected:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MICROPHONECANCEL object:nil];
    if(self.microphoneRadialMenu.menuVisible) {
        [self microphoneCancel];
    }
    if(self.audioPlayer)
    {
        voiceAnimationRow = -1;
        [lastAnimationImageView stopAnimating];
        [self.audioPlayer stop];
    }
}

#pragma mark - ConfigureUI UI设置

-(void)setupViews{
    
    if (self.chatMessage)
    {
        self.navigationItem.title =self.chatMessage.msgOtherName;
    }
    else
    {
        if (self.isGroup) {
            self.navigationItem.title =self.chatGroup.groupName;
        }else{
            self.navigationItem.title =self.chatUser.uname;
        }
    }
    
    ILBarButtonItem *leftItem = [ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];

    UIButton *callBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [callBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [callBtn setBackgroundColor:[UIColor clearColor]];
    [callBtn setBackgroundImage:[UIImage imageNamed:@"chat_call.png"] forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(makeVideoOrVoiceCall) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *callItem = [[UIBarButtonItem alloc] initWithCustomView:callBtn];
    
    UIButton * rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"chat_settingHead.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickRightItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    if(_isGroup)
    {
        MGroupUser * groupUser =[[[SQLiteManager sharedInstance] getAllOnlyGroups] objectForKey:[self.chatMessage.sessionid substringFromIndex:1]];
        
        if (groupUser || [[ConfigManager sharedInstance].createGroupId isEqualToString:self.chatGroup.groupid] || _isFromTempGroup) {
           self.navigationItem.rightBarButtonItem = rightItem;
        }
    }
    else
    {
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightItem,callItem, nil]];
    }
    
    UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
    
    
    self.nibChat = [UINib nibWithNibName:@"GQChatCell" bundle:[NSBundle mainBundle]];
    self.tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, viewWithNavNoTabbar-INPUTVIEWHEIGHT) style:UITableViewStylePlain];
    [self.tbView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tbView.dataSource = self;
    self.tbView.delegate = self;
    self.tbView.tableFooterView =[[UIView alloc] init];
    [self.tbView initGesture];
    [self.tbView addLongPressRecognizer];
    [self.tbView addSingleDoubleTapRecognizer];
    [self.tbView setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1]];
    
    
    __block ChatViewController *blockSelf = self;
    
    [self.tbView addPullToRefreshWithActionHandler:^{
        
        [blockSelf loadDataWithFlag:1];
        
    }];
    
    [self.view addSubview:self.tbView];
    
    self.faceSwitchView = [[FaceSwitchView alloc] initWithFrame:CGRectMake(0, self.tbView.frame.size.height, boundsWidth, 255)];
    [self.view addSubview:self.faceSwitchView];
    
    CGRect mainScreenFrame=[[UIScreen mainScreen] bounds];
    self.faceBoard = [[FaceBoard alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(mainScreenFrame), boundsWidth, 216) ];
    self.faceBoard.m_delegate=self;
    [self.view addSubview:self.faceBoard];
    
    self.shareMenuBoard = nil;
    if(_isGroup)
    {
        self.shareMenuBoard =[[ShareMenuBoard alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(mainScreenFrame), boundsWidth, 216) withoutVoipAction:YES];
    }
    else
    {
        self.shareMenuBoard =[[ShareMenuBoard alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(mainScreenFrame), boundsWidth, 216) withoutVoipAction:NO];
    }
    self.shareMenuBoard.m_delegate=self;
    [self.view addSubview:self.shareMenuBoard];
    
    
    self.btnSwitch = [[UIButton alloc] initWithFrame:CGRectMake(43, (INPUTVIEWHEIGHT - 30)/2, 30, 30)];
    [self.faceSwitchView addSubview:self.btnSwitch];
    [self.btnSwitch setImage:[UIImage imageNamed:@"chat_face.png" ] forState:UIControlStateNormal];
    [self.btnSwitch setImage:[UIImage imageNamed:@"chat_face.png"] forState:UIControlStateHighlighted];
    [self.btnSwitch setImage:[UIImage imageNamed:@"chat_keyboard.png" ] forState:UIControlStateSelected];
    [self.btnSwitch addTarget:self action:@selector(switchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnMore = [[UIButton alloc] initWithFrame:CGRectMake(5, (INPUTVIEWHEIGHT - 30)/2, 30, 30)];
    [self.faceSwitchView addSubview:self.btnMore];
    
    [self.btnMore setImage:[UIImage imageNamed:@"chat_add.png" ] forState:UIControlStateNormal];
    [self.btnMore setImage:[UIImage imageNamed:@"chat_add.png" ] forState:UIControlStateHighlighted];
    [self.btnMore setImage:[UIImage imageNamed:@"chat_keyboard.png"] forState:UIControlStateSelected];
    [self.btnMore addTarget:self action:@selector(moreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnHold.layer.cornerRadius = 4.0f;
    self.btnHold.clipsToBounds =YES;
    self.btnHold.layer.borderColor = [UIColor colorWithRGBHex:0x999999].CGColor;
    self.btnHold.layer.borderWidth=1.0f;
    [self.btnHold setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.btnHold setTitle:LOCALIZATION(@"Message_talks") forState:UIControlStateNormal];
    [self.btnHold setTitle:LOCALIZATION(@"Message_talk_Ending") forState:UIControlStateHighlighted];
    
    self.inputTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(43 + 35, (INPUTVIEWHEIGHT - 30)/2, boundsWidth - (43 + 35 + 40), 30)];
    [self.faceSwitchView addSubview:self.inputTextView];
    self.inputTextView .isScrollable = YES;
    self.inputTextView .contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.inputTextView .minNumberOfLines = 1;
    self.inputTextView .maxNumberOfLines = 4;
    self.inputTextView .returnKeyType = UIReturnKeyDone; //just as an example
    self.inputTextView .font = [UIFont systemFontOfSize:15.0f];
    self.inputTextView .delegate = self;
    self.inputTextView .internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    
    self.inputTextView .placeholder = @"";
    
    self.inputTextView .layer.cornerRadius =4.0f;
    self.inputTextView.layer.borderColor =[UIColor grayColor].CGColor;
    self.inputTextView.layer.borderWidth =0.5f;
    
    
    self.faceMap = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"faceMap" ofType:@"plist"]];
    NSData *cssData=[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bubblechat" ofType:@"css"]];
    self.cssSheet=[[DTCSSStylesheet alloc] initWithStyleBlock:[[NSString alloc] initWithData:cssData encoding:NSUTF8StringEncoding]];
    
    //    UIButton *voipVoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    voipVoiceBtn.backgroundColor = [UIColor whiteColor];
    //    voipVoiceBtn.frame = CGRectMake(boundsWidth/6, 7, boundsWidth/4, 30);
    //    [voipVoiceBtn addTarget:self action:@selector(voipVoiceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [voipVoiceBtn setTitle:@"语音聊天" forState:UIControlStateNormal];
    //    [voipVoiceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //    [self.view insertSubview:voipVoiceBtn aboveSubview:self.tbView];
    //
    //    UIButton *voipVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    voipVideoBtn.backgroundColor = [UIColor whiteColor];
    //    voipVideoBtn.frame = CGRectMake(boundsWidth/12*7, 7, boundsWidth/4, 30);
    //    [voipVideoBtn addTarget:self action:@selector(voipVoiceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [voipVideoBtn setTitle:@"视屏聊天" forState:UIControlStateNormal];
    //    [voipVideoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //    [self.view insertSubview:voipVideoBtn aboveSubview:self.tbView];
    
    // Microphone Radial Menu
    self.microphoneRecording = NO;
    //录音界面
    self.microphoneRadialMenu = [[MTZRadialMenu alloc] initWithBackgroundVisualEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    
    self.microphoneRadialMenu.frame = CGRectMake(self.faceSwitchView.frame.size.width -40, (INPUTVIEWHEIGHT - 40)/2, 40, 40);
    self.microphoneRadialMenu.delegate = self;
    [self.microphoneRadialMenu setImage:[UIImage imageNamed:@"chat_voice.png"] forState:UIControlStateNormal];
    [self.faceSwitchView addSubview:self.microphoneRadialMenu];
    
    MTZRadialMenuItem *microphoneCancel = [MTZRadialMenuItem menuItemWithRadialMenuStandardItem:MTZRadialMenuStandardItemCancel handler:^(MTZRadialMenu *radialMenu, MTZRadialMenuItem *menuItem) {
        [self microphoneCancel];
    }];
    [self.microphoneRadialMenu setItem:microphoneCancel forLocation:MTZRadialMenuLocationLeft];
    
    self.microphoneRecordingSendAction = [MTZRadialMenuItem menuItemWithRadialMenuStandardItem:MTZRadialMenuStandardItemConfirm handler:^(MTZRadialMenu *radialMenu, MTZRadialMenuItem *menuItem) {
        [self microphoneRecordingSend];
    }];
    self.microphoneRecordingSendAction.testTag = @"topitem";
    [self.microphoneRadialMenu setItem:self.microphoneRecordingSendAction forLocation:MTZRadialMenuLocationTop];
    
    self.microphoneRecordingStopAction = [MTZRadialMenuItem menuItemWithImage:[UIImage imageNamed:@"ActionCameraStop"] highlightedImage:[UIImage imageNamed:@"ActionCameraStopHighlighted"] handler:^(MTZRadialMenu *radialMenu, MTZRadialMenuItem *menuItem) {
        
        [self microphoneStop];
        
    }];
    [self.microphoneRadialMenu setItem:self.microphoneRecordingStopAction forLocation:MTZRadialMenuLocationCenter];
    
    // Microphone Recording Playback Play
    self.microphoneRecordingPlaybackPlayAction = [MTZRadialMenuItem menuItemWithRadialMenuStandardItem:MTZRadialMenuStandardItemPlay handler:^(MTZRadialMenu *radialMenu, MTZRadialMenuItem *menuItem) {
        [self microphoneRecordingPlaybackPlay];
    }];
    
    // Microphone Recording Playback Pause
    self.microphoneRecordingPlaybackPauseAction = [MTZRadialMenuItem menuItemWithRadialMenuStandardItem:MTZRadialMenuStandardItemPause handler:^(MTZRadialMenu *radialMenu, MTZRadialMenuItem *menuItem) {
        [self microphoneRecordingPlaybackPause];
    }];
    
    //    [self.microphoneRadialMenu displayMenu];
    inputTextHeight = self.inputTextView.frame.size.height;
    
    self.voiceView = [[UIView alloc] initWithFrame:CGRectMake(5,(INPUTVIEWHEIGHT - 30)/2, self.faceSwitchView.frame.size.width  - 10 - 125, 30)];
    self.voiceView.backgroundColor = [UIColor colorWithRGBHex:0x697277];
    self.voiceView.layer.cornerRadius = 5;
    [self.faceSwitchView addSubview:self.voiceView];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.voiceView.frameWidth - 50, 21)];
    img.image = [UIImage imageNamed:@"chat_voiceImage.png"];
    //    img.backgroundColor = [UIColor redColor];
    [self.voiceView  addSubview:img];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.voiceView.frameWidth - 40, 0, 40, 30)];
    timeLabel.tag = 110;
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = [UIColor whiteColor];
    [self.voiceView addSubview:timeLabel];
    
    //    self.audioPlot = [[EZAudioPlotGL alloc] initWithFrame:CGRectMake(5, 0, self.voiceView.frameWidth-25, self.voiceView.height)];
    //    [self.voiceView addSubview:self.audioPlot];
    //    self.audioPlot.backgroundColor = [UIColor colorWithRGBHex:0x697277];
    //    // Waveform color
    //    self.audioPlot.color           = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    //    // Plot type
    //    self.audioPlot.plotType        = EZPlotTypeBuffer;
    //    self.microphone = [EZMicrophone microphoneWithDelegate:self];
    [self showNomalInput];
    
}



#pragma mark - Chat Load Data Private Method 聊天加载消息时的一些自定义方法


//判断是否所有聊天记录都加载完成了
- (BOOL)isAllMessageLoaded{
    //进入界面第一次聊天的偏移量
    if (_messageArray.count >= messageCount && messageCount != 0) {//messageCount == 0时 表示要没有消息记录 清除消息记录要刷新一下tableview
        
        [self.tbView.pullToRefreshView stopAnimating];
        
        return YES;
        
    }else{
        
        return NO;
    }
    
}


//初始化加载消息的一些参数
- (void)initMessageParameters{
    
    loadCount = 1; //加载数据的次数
    messageOffset = messageCount - MessageLimit;
    _messageLimit = MessageLimit;
    
}

//从数据库获取聊天记录总数
- (NSInteger)getMessageCountWithMessageType:(MessageType)messageType andSessionid:(NSString*)sessionid{
    
    if (messageType == MessageTypePrivate) {
        return [[SQLiteManager sharedInstance] getPrivateMessagesConuntWithKeyId:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]] sessionId:sessionid];
    }else{
        
        return [[SQLiteManager sharedInstance] getGroupMessagesCountWithSessionid:sessionid];
    }
    
}
/**
 *  从数据库获取聊天记录
 *
 *  @param messageType 消息类型 -- 个人聊天 群聊
 *  @param keyid       个人聊天时用到的
 *  @param sessionid   聊天唯一标识
 *
 *  @return 返回所有消息
 */
- (NSMutableArray*)getMessagesOfMessageType:(MessageType)messageType keyid:(NSString*)keyid sessionid:(NSString*)sessionid{
    
    NSMutableArray *array;
    
    if (messageType == MessageTypePrivate) {
        
        array =[[SQLiteManager sharedInstance]getPrivateMessagesWithKeyId:keyid sessionId:sessionid faceMap:self.faceMap cssSheet:self.cssSheet offset:messageOffset limit:_messageLimit];
        
    }else{
        
        array = [[SQLiteManager sharedInstance]getGroupMessagesWithSessionId:sessionid faceMap:self.faceMap cssSheet:self.cssSheet offset:messageOffset limit:_messageLimit];
        
    }
    
    return array;
}

//加载聊天数据
-(void)loadDataWithFlag:(int)flag{//flag代表下拉刷新增加数据 (1) 还是默认的加载数据(0)

    if (flag == 1 && [self isAllMessageLoaded]) {

        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"data_loaded") isDismissLater:YES];

        return;
    }

    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /**
         *  如果是从MessageList中进入聊天界面，chatMessage由MessageList传进来，已经存在了。
         */
        if (weakSelf.chatMessage && weakSelf.chatMessage.sessionid && weakSelf.chatMessage.sessionid.length>0) {
            //群聊
            if (weakSelf.isGroup) {
                //通过群id（以g开头的，要去掉g）查找出当前进入的群
                MGroup *chatGroup =[[[SQLiteManager sharedInstance] getAllOnlyGroups] objectForKey:[weakSelf.chatMessage.msgOtherId substringFromIndex:1]];
                weakSelf.chatGroup = chatGroup;
            }
            else//个人聊天
            {
                NSString *myGId=[[ConfigManager sharedInstance].userDictionary objectForKey:@"gid"];
                //查询所有用户，根据uid取出当前聊天用户
                MEnterpriseUser *chatUser =[[[SQLiteManager sharedInstance] getAllUserByGid:myGId] objectForKey:weakSelf.chatMessage.msgOtherId];
                //当前聊天的用户
                weakSelf.chatUser = chatUser;
            }
            if (!weakSelf.isGroup)//个人聊天
            {
                /**
                 *  如果chatMessage的发送者是当前用户
                 */
                if ([[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]] isEqualToString:weakSelf.chatMessage.keyid]) {

                    NSString *sessionid;

                    if (weakSelf.chatMessage.sessionid) {
                        sessionid = weakSelf.chatMessage.sessionid;
                    }else{
                        sessionid = weakSelf.chatUser.uid;
                    }
                    //获取数据库聊天记录总数
                    messageCount = [weakSelf getMessageCountWithMessageType:MessageTypePrivate andSessionid:sessionid];
                    //获取总数后判断是否所有聊天记录已经加载完成
                    if ([weakSelf isAllMessageLoaded]) {
                        if (weakSelf.isClickedeleteBtn == YES) {
                            weakSelf.isClickedeleteBtn = NO;
                        }

                        else{
                            return ;
                        }
                    }

                    if (flag == 0) {//直接进入聊天界面

                        [weakSelf initMessageParameters];
                        //从数据库获取消息记录
                        NSString *keyid = [[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"];
                        weakSelf.messageArray = [weakSelf getMessagesOfMessageType:MessageTypePrivate keyid:keyid sessionid:sessionid];

                    }else{//下拉刷新

                        if (messageOffset == 0) {//如果下拉的时候offset == 0,表示已经可以一次性取完所有数据了，最后一次取多少数据如下
                            _messageLimit = messageCount - _messageLimit * (loadCount - 1);
                        }

                        NSString *keyid = [NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];

                        NSArray *array  = [weakSelf getMessagesOfMessageType:MessageTypePrivate keyid:keyid sessionid:sessionid];
                        [weakSelf.messageArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,array.count)]];
                    }
                    //偏移量变化
                    if (flag == 0) {
                        loadCount = 1;
                    }
                    messageOffset = (messageCount - _messageLimit * loadCount++) - _messageLimit;
                }
                /**
                 *  如果chatMessage的发送者不是当前用户
                 */
                else
                {
                    NSString *sessionid;
                    if (weakSelf.chatMessage.keyid) {
                        sessionid = weakSelf.chatMessage.keyid;
                    }else{
                        sessionid = weakSelf.chatGroup.groupid;
                    }
                    //获取数据库聊天记录总数
                    messageCount = [weakSelf getMessageCountWithMessageType:MessageTypePrivate andSessionid:sessionid];

                    //获取总数后判断是否所有聊天记录已经加载完成
                    if ([weakSelf isAllMessageLoaded]) {
                        if (weakSelf.isClickedeleteBtn == YES) {
                            weakSelf.isClickedeleteBtn = NO;
                        }

                        else{
                            return ;
                        }
                    }

                    if (flag == 0) {

                        NSString *keyid = [[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"];
                        [weakSelf initMessageParameters];

                        //从数据库获取消息记录
                        weakSelf.messageArray =[weakSelf getMessagesOfMessageType:MessageTypePrivate keyid:keyid sessionid:sessionid];

                    }else{
                        if (messageOffset == 0) {//如果下拉的时候offset ==0,表示已经可以一次性取完所有数据了，最后一次取多少数据如下
                            _messageLimit = messageCount - _messageLimit * (loadCount - 1);
                        }
                        NSString *keyid = [[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"];
                        NSArray *array  =[weakSelf getMessagesOfMessageType:MessageTypePrivate keyid:keyid sessionid:sessionid];

                        [weakSelf.messageArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,array.count)]];
                    }
                    //偏移量变化
                    if (flag == 0) {
                        loadCount = 1;
                    }
                    messageOffset = (messageCount - _messageLimit * loadCount++) - _messageLimit;

                    NSLog(@"messageCount = %d ,messageOffset = %d  ",messageCount,messageOffset);
                }
            }
            else//从MessageList界面进入群聊界面
            {
                NSString *sessionid;
                if (weakSelf.chatMessage.sessionid) {
                    sessionid = weakSelf.chatMessage.sessionid;
                }else{
                    sessionid = weakSelf.chatGroup.groupid;
                }
                //获取数据库聊天记录总数
                messageCount = [weakSelf getMessageCountWithMessageType:MessageTypeGroup andSessionid:sessionid];
                //获取总数后判断是否所有聊天记录已经加载完成
                if ([weakSelf isAllMessageLoaded]) {
                    if (weakSelf.isClickedeleteBtn == YES) {
                        weakSelf.isClickedeleteBtn = NO;
                    }

                    else{
                        return ;
                    }
                }
                if (flag == 0) {

                    [weakSelf initMessageParameters];
                    //从数据库获取消息记录
                    weakSelf.messageArray =[weakSelf getMessagesOfMessageType:MessageTypeGroup keyid:nil sessionid:sessionid];

                }else{

                    if (messageOffset == 0) {//如果下拉的时候offset ==0,表示已经可以一次性取完所有数据了，最后一次取多少数据如下

                        _messageLimit = messageCount - _messageLimit * (loadCount - 1);

                    }

                    NSArray *array  =[weakSelf getMessagesOfMessageType:MessageTypeGroup keyid:nil sessionid:sessionid];

                    [weakSelf.messageArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,array.count)]];
                }

                //偏移量变化
                if (flag == 0) {
                    loadCount = 1;
                }
                messageOffset = (messageCount - _messageLimit * loadCount++) - _messageLimit;
            }
        }else{//如果是从其他界面--通讯录 进入聊天界面

            if (weakSelf.isGroup) {//群聊
                /**
                 *  如果chatGroup存在
                 */
                if (weakSelf.chatGroup && weakSelf.chatGroup.groupid && [NSString stringWithFormat:@"%@",weakSelf.chatGroup.groupid].length>0) {
                    NSString *sessionid;
                    if (weakSelf.chatMessage.sessionid) {

                        sessionid = weakSelf.chatMessage.sessionid;
                    }else{

                        sessionid = [NSString stringWithFormat:@"g%@",weakSelf.chatGroup.groupid];
                    }

                    //获取数据库聊天记录总数
                    messageCount = [weakSelf getMessageCountWithMessageType:MessageTypeGroup andSessionid:sessionid];
                    //获取总数后判断是否所有聊天记录已经加载完成
                    if ([weakSelf isAllMessageLoaded]) {
                        if (weakSelf.isClickedeleteBtn == YES) {
                            weakSelf.isClickedeleteBtn = NO;
                        }

                        else{
                            return ;
                        }
                    }

                    if (flag == 0) {
                        NSString *sessionid = [NSString stringWithFormat:@"g%@",weakSelf.chatGroup.groupid];
                        [weakSelf initMessageParameters];
                        //从数据库获取消息记录
                        weakSelf.messageArray =[weakSelf getMessagesOfMessageType:MessageTypeGroup keyid:nil sessionid:sessionid];

                    }else{

                        if (messageOffset == 0) {//如果下拉的时候offset ==0,表示已经可以一次性取完所有数据了，最后一次取多少数据如下

                            _messageLimit = messageCount - _messageLimit * (loadCount - 1);

                        }

                        NSString *sessionid = [NSString stringWithFormat:@"g%@",weakSelf.chatGroup.groupid];
                        NSArray *array  =[weakSelf getMessagesOfMessageType:MessageTypeGroup keyid:nil sessionid:sessionid];

                        [weakSelf.messageArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,array.count)]];
                    }

                    //偏移量变化
                    if (flag == 0) {
                        loadCount = 1;
                    }
                    messageOffset = (messageCount - _messageLimit * loadCount++) - _messageLimit;

                }else{
                    return ;
                }

            }else{//个人聊天
                //如果chatUser存在
                if (weakSelf.chatUser && weakSelf.chatUser.uid && [NSString stringWithFormat:@"%@",weakSelf.chatUser.uid].length>0) {

                    NSString *sessionid;

                    if (weakSelf.chatMessage.sessionid) {
                        sessionid = weakSelf.chatMessage.sessionid;
                    }else{
                        sessionid = weakSelf.chatUser.uid;
                    }

                    //获取数据库聊天记录总数
                    messageCount = [weakSelf getMessageCountWithMessageType:MessageTypePrivate andSessionid:sessionid];

                    //获取总数后判断是否所有聊天记录已经加载完成
                    if ([weakSelf isAllMessageLoaded]) {
                        if (weakSelf.isClickedeleteBtn == YES) {
                            weakSelf.isClickedeleteBtn = NO;
                        }

                        else{
                            return ;
                        }
                    }

                    if (flag == 0) {
                        NSString *keyid = [NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
                        [weakSelf initMessageParameters];
                        //从数据库获取消息记录
                        weakSelf.messageArray =[weakSelf getMessagesOfMessageType:MessageTypePrivate keyid:keyid sessionid:sessionid];

                    }else{

                        if (messageOffset == 0) {//如果下拉的时候offset ==0,表示已经可以一次性取完所有数据了，最后一次取多少数据如下
                            _messageLimit = messageCount - _messageLimit * (loadCount - 1);
                        }

                        NSString *keyid = [NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]] ;

                        NSArray *array  =[weakSelf getMessagesOfMessageType:MessageTypePrivate keyid:keyid sessionid:sessionid];

                        [weakSelf.messageArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,array.count)]];
                    }
                    //偏移量变化
                    if (flag == 0) {
                        loadCount = 1;
                    }

                    messageOffset = (messageCount - _messageLimit * loadCount++) - _messageLimit;

                }else{
                    return;
                }
            }
        }

        if (messageOffset < 0) {
            messageOffset = 0;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tbView.pullToRefreshView stopAnimating];
            [self.tbView reloadData];
            if (flag == 1) {

                self.tbView.contentOffset = CGPointMake(0, 0);

                return ;
            }
            [weakSelf tbViewScrollToBottom];
        });
    });
}

-(void)loadDataWithFlag:(int)flag withIndex:(int)deleteCell //flag代表下拉刷新增加数据 (1) 还是默认的加载数据(0)
{//flag代表下拉刷新增加数据 (1) 还是默认的加载数据(0)

        if (flag == 1 && [self isAllMessageLoaded]) {
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"data_loaded") isDismissLater:YES];
            return;
        }

        WEAKSELF
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            /**
             *  如果是从MessageList中进入聊天界面，chatMessage由MessageList传进来，已经存在了。
             */
            if (weakSelf.chatMessage && weakSelf.chatMessage.sessionid && weakSelf.chatMessage.sessionid.length>0) {
                //群聊
                if (weakSelf.isGroup) {
                    //通过群id（以g开头的，要去掉g）查找出当前进入的群
                    MGroup *chatGroup =[[[SQLiteManager sharedInstance] getAllOnlyGroups] objectForKey:[weakSelf.chatMessage.msgOtherId substringFromIndex:1]];
                    weakSelf.chatGroup = chatGroup;
                }
                else//个人聊天
                {
                    NSString *myGId=[[ConfigManager sharedInstance].userDictionary objectForKey:@"gid"];
                    //查询所有用户，根据uid取出当前聊天用户
                    MEnterpriseUser *chatUser =[[[SQLiteManager sharedInstance] getAllUserByGid:myGId] objectForKey:weakSelf.chatMessage.msgOtherId];
                    //当前聊天的用户
                    weakSelf.chatUser = chatUser;
                }

                if (!weakSelf.isGroup)//个人聊天
                {
                    /**
                     *  如果chatMessage的发送者是当前用户
                     */
                    if ([[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]] isEqualToString:weakSelf.chatMessage.keyid]) {

                        NSString *sessionid;

                        if (weakSelf.chatMessage.sessionid) {
                            sessionid = weakSelf.chatMessage.sessionid;
                        }else{
                            sessionid = weakSelf.chatUser.uid;
                        }
                        //获取数据库聊天记录总数
                        messageCount = [weakSelf getMessageCountWithMessageType:MessageTypePrivate andSessionid:sessionid];

                        //获取总数后判断是否所有聊天记录已经加载完成
                        if ([weakSelf isAllMessageLoaded]) {
                            if (weakSelf.isClickedeleteBtn == YES) {
                                weakSelf.isClickedeleteBtn = NO;
                            }
                            else{
                                return ;
                            }
                        }

                        if (flag == 0) {//直接进入聊天界面

                            [weakSelf initMessageParameters];
                            //从数据库获取消息记录
                            NSString *keyid = [[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"];
                            weakSelf.messageArray = [weakSelf getMessagesOfMessageType:MessageTypePrivate keyid:keyid sessionid:sessionid];

                        }else{//下拉刷新

                            if (messageOffset == 0) {//如果下拉的时候offset ==0,表示已经可以一次性取完所有数据了，最后一次取多少数据如下

                                _messageLimit = messageCount - _messageLimit * (loadCount - 1);

                            }

                            NSString *keyid = [NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];

                            NSArray *array  = [weakSelf getMessagesOfMessageType:MessageTypePrivate keyid:keyid sessionid:sessionid];
                            [weakSelf.messageArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,array.count)]];

                        }

                        //偏移量变化
                        if (flag == 0) {
                            loadCount = 1;
                        }
                        messageOffset = (messageCount - _messageLimit * loadCount++) - _messageLimit;
                    }
                    /**
                     *  如果chatMessage的发送者不是当前用户
                     */
                    else
                    {

                        NSString *sessionid;

                        if (weakSelf.chatMessage.keyid) {
                            sessionid = weakSelf.chatMessage.keyid;
                        }else{
                            sessionid = weakSelf.chatGroup.groupid;
                        }

                        //获取数据库聊天记录总数
                        messageCount = [weakSelf getMessageCountWithMessageType:MessageTypePrivate andSessionid:sessionid];
                        //获取总数后判断是否所有聊天记录已经加载完成
                        if ([weakSelf isAllMessageLoaded]) {
                            if (weakSelf.isClickedeleteBtn == YES) {
                                weakSelf.isClickedeleteBtn = NO;
                            }

                            else{
                                return ;
                            }
                        }

                        if (flag == 0) {

                            NSString *keyid = [[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"];
                            [weakSelf initMessageParameters];

                            //从数据库获取消息记录
                            weakSelf.messageArray =[weakSelf getMessagesOfMessageType:MessageTypePrivate keyid:keyid sessionid:sessionid];

                        }else{

                            if (messageOffset == 0) {//如果下拉的时候offset ==0,表示已经可以一次性取完所有数据了，最后一次取多少数据如下

                                _messageLimit = messageCount - _messageLimit * (loadCount - 1);

                            }

                            NSString *keyid = [[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"];
                            NSArray *array  =[weakSelf getMessagesOfMessageType:MessageTypePrivate keyid:keyid sessionid:sessionid];

                            [weakSelf.messageArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,array.count)]];

                        }

                        //偏移量变化
                        if (flag == 0) {
                            loadCount = 1;
                        }
                        messageOffset = (messageCount - _messageLimit * loadCount++) - _messageLimit;

                        NSLog(@"messageCount = %d ,messageOffset = %d  ",messageCount,messageOffset);

                    }
                }
                else//从MessageList界面进入群聊界面
                {

                    NSString *sessionid;

                    if (weakSelf.chatMessage.sessionid) {
                        sessionid = weakSelf.chatMessage.sessionid;
                    }else{
                        sessionid = weakSelf.chatGroup.groupid;
                    }

                    //获取数据库聊天记录总数
                    messageCount = [weakSelf getMessageCountWithMessageType:MessageTypeGroup andSessionid:sessionid];

                    //获取总数后判断是否所有聊天记录已经加载完成
                    if ([weakSelf isAllMessageLoaded]) {
                        if (weakSelf.isClickedeleteBtn == YES) {
                            weakSelf.isClickedeleteBtn = NO;
                        }

                        else{
                            return ;
                        }
                    }

                    if (flag == 0) {

                        [weakSelf initMessageParameters];
                        //从数据库获取消息记录
                        weakSelf.messageArray =[weakSelf getMessagesOfMessageType:MessageTypeGroup keyid:nil sessionid:sessionid];

                    }else{

                        if (messageOffset == 0) {//如果下拉的时候offset ==0,表示已经可以一次性取完所有数据了，最后一次取多少数据如下

                            _messageLimit = messageCount - _messageLimit * (loadCount - 1);

                        }

                        NSArray *array  =[weakSelf getMessagesOfMessageType:MessageTypeGroup keyid:nil sessionid:sessionid];

                        [weakSelf.messageArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,array.count)]];

                    }

                    //偏移量变化
                    if (flag == 0) {
                        loadCount = 1;
                    }
                    messageOffset = (messageCount - _messageLimit * loadCount++) - _messageLimit;


                }

            }else{//如果是从其他界面--通讯录 进入聊天界面

                if (weakSelf.isGroup) {//群聊
                    /**
                     *  如果chatGroup存在
                     */
                    if (weakSelf.chatGroup && weakSelf.chatGroup.groupid && [NSString stringWithFormat:@"%@",weakSelf.chatGroup.groupid].length>0) {
                        NSString *sessionid;
                        if (weakSelf.chatMessage.sessionid) {

                            sessionid = weakSelf.chatMessage.sessionid;
                        }else{

                            sessionid = [NSString stringWithFormat:@"g%@",weakSelf.chatGroup.groupid];
                        }

                        //获取数据库聊天记录总数

                        messageCount = [weakSelf getMessageCountWithMessageType:MessageTypeGroup andSessionid:sessionid];

                        //获取总数后判断是否所有聊天记录已经加载完成
                        if ([weakSelf isAllMessageLoaded]) {
                            if (weakSelf.isClickedeleteBtn == YES) {
                                weakSelf.isClickedeleteBtn = NO;
                            }

                            else{
                                return ;
                            }
                        }
                        if (flag == 0) {
                            NSString *sessionid = [NSString stringWithFormat:@"g%@",weakSelf.chatGroup.groupid];
                            [weakSelf initMessageParameters];
                            //从数据库获取消息记录
                            weakSelf.messageArray =[weakSelf getMessagesOfMessageType:MessageTypeGroup keyid:nil sessionid:sessionid];
                        }else{

                            if (messageOffset == 0) {//如果下拉的时候offset ==0,表示已经可以一次性取完所有数据了，最后一次取多少数据如下

                                _messageLimit = messageCount - _messageLimit * (loadCount - 1);

                            }
                            NSString *sessionid = [NSString stringWithFormat:@"g%@",weakSelf.chatGroup.groupid];
                            NSArray *array  =[weakSelf getMessagesOfMessageType:MessageTypeGroup keyid:nil sessionid:sessionid];

                            [weakSelf.messageArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,array.count)]];

                        }

                        //偏移量变化
                        if (flag == 0) {
                            loadCount = 1;
                        }
                        messageOffset = (messageCount - _messageLimit * loadCount++) - _messageLimit;
                    }else{
                        return ;
                    }
                }else{//个人聊天
                    //如果chatUser存在
                    if (weakSelf.chatUser && weakSelf.chatUser.uid && [NSString stringWithFormat:@"%@",weakSelf.chatUser.uid].length>0) {

                        NSString *sessionid;

                        if (weakSelf.chatMessage.sessionid) {
                            sessionid = weakSelf.chatMessage.sessionid;
                        }else{
                            sessionid = weakSelf.chatUser.uid;
                        }

                        //获取数据库聊天记录总数
                        messageCount = [weakSelf getMessageCountWithMessageType:MessageTypePrivate andSessionid:sessionid];
                        //获取总数后判断是否所有聊天记录已经加载完成
                        if ([weakSelf isAllMessageLoaded]) {
                            if (weakSelf.isClickedeleteBtn == YES) {
                                weakSelf.isClickedeleteBtn = NO;
                            }
                            else{
                                return ;
                            }
                        }

                        if (flag == 0) {
                            NSString *keyid = [NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
                            [weakSelf initMessageParameters];
                            //从数据库获取消息记录
                            weakSelf.messageArray =[weakSelf getMessagesOfMessageType:MessageTypePrivate keyid:keyid sessionid:sessionid];

                        }else{

                            if (messageOffset == 0) {//如果下拉的时候offset ==0,表示已经可以一次性取完所有数据了，最后一次取多少数据如下
                                _messageLimit = messageCount - _messageLimit * (loadCount - 1);
                            }

                            NSString *keyid = [NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]] ;

                            NSArray *array  =[weakSelf getMessagesOfMessageType:MessageTypePrivate keyid:keyid sessionid:sessionid];

                            [weakSelf.messageArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,array.count)]];
                        }
                        //偏移量变化

                        if (flag == 0) {
                            loadCount = 1;
                        }
                        messageOffset = (messageCount - _messageLimit * loadCount++) - _messageLimit;

                    }else{
                        return;
                    }
                }
            }
            if (messageOffset < 0) {

                messageOffset = 0;
            }
            dispatch_async(dispatch_get_main_queue(), ^{

                [self.tbView.pullToRefreshView stopAnimating];
                [self.tbView reloadData];
                if (flag == 1) {

                    self.tbView.contentOffset = CGPointMake(0, 0);

                    return ;
                }
            });
        });
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.messageArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMessage *mm =[self.messageArray objectAtIndex:indexPath.row];
    if([mm.type intValue]!= 0 && [mm.type intValue] != 1)
    {
        if([mm.srState integerValue]==MMessageSRStateReceiveRead || [mm.srState integerValue] ==MMessageSRStateReceiveUnread){
            if ([mm.type integerValue] == MMessageTypeGroupChat) {
                return 60;
            }
        }
        return 40;
    }
    
    if (indexPath.row == 0 ) {
        mm.haveTimeLabel = YES;
        return [self calcCellHeight:mm];
    }
    else
    {
        MMessage *lastmm =[self.messageArray objectAtIndex:indexPath.row-1];
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        //创建了两个日期对象
        NSDate *date11 =[NSDate dateWithTimeIntervalSince1970:[lastmm.sendTime longLongValue]/1000];
        NSDate *date22 =[NSDate dateWithTimeIntervalSince1970:[mm.sendTime longLongValue]/1000];
        
        NSTimeInterval time=[date22 timeIntervalSinceDate:date11];
        // int mins = ((int)time)%(3600*24)/3600/60;
        int mins = ((int)time)/60;
        if (mins >= 5)
        {
            mm.haveTimeLabel = YES;
            return [self calcCellHeight:mm];
        }
        else
        {
            mm.haveTimeLabel = NO;
            return [self calcCellHeight:mm] - SENDTIME_HEIGHT  ;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifer = @"GQChatCell";
    GQChatCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if(!cell){
        cell=(GQChatCell*)[[self.nibChat instantiateWithOwner:self options:nil] objectAtIndex:0];
    }
    MMessage *message =[self.messageArray objectAtIndex:indexPath.row];
    
    //    NSArray *operatorIds =[message.operatorid componentsSeparatedByString:@","];
    //    NSMutableArray *operatorNames=[[NSMutableArray alloc] init];
    //    for (MGroupUser *user in self.chatGroup.users) {
    //        for (NSString *uid in operatorIds) {
    //            if ([uid isEqualToString:[NSString stringWithFormat:@"%@",user.uid]]) {
    //                if (user && user.uname && user.uname.length>0) {
    //                    [operatorNames addObject:user.uname];
    //                }
    //            }
    //        }
    //    }
    
    [[SQLiteManager sharedInstance] updateMessageReadStateByMsgOtherId:message.msgOtherId notificationName:NOTIFICATION_U_SQL_MESSAGE_READSTATE];
    
    if ([message.type intValue]==MMessageTypeCreateGroup||[message.type intValue]==MMessageTypeQuitGroup||[message.type intValue]==MMessageTypeModifyGroup||[message.type intValue]==MMessageTypeRemoveGroupMember||[message.type intValue]==MMessageTypeRemoveGroup||[message.type intValue]==MMessageTypeInviteGroup) {
        for (UIView *view in [cell.contentView subviews]) {
            [view removeFromSuperview];
        }
        UILabel *labSystem = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, boundsWidth-100, 30)];
        labSystem.backgroundColor = [UIColor grayColor];
        
        labSystem.font =[UIFont systemFontOfSize:12.0f];
        labSystem.textColor =[UIColor whiteColor];
        labSystem.text= [NSString stringWithFormat:@"%@",message.msg];
        labSystem.textAlignment = NSTextAlignmentCenter;
        labSystem.layer.masksToBounds = YES;
        labSystem.layer.cornerRadius = 5;
        [cell.contentView addSubview:labSystem];
        return cell;
    }
    
    if (self.isGroup) {
        cell.chatGroup =self.chatGroup;
    }
    if(indexPath.row == 0)
    {
        cell.lastMessage = nil;
        
    }
    else
    {
        cell.lastMessage = [self.messageArray objectAtIndex:indexPath.row - 1];
    }
    
    cell.message =message;
    
    if(voiceAnimationRow == indexPath.row)//&& voiceAnimationSection == indexPath.section)
    {
        //这边处理主要是为了解决，当新数据进来时候刷新tableview导致没有语音播放动画（此时正在播放语音）
        
        if ([cell.message.srState intValue]==MMessageSRStateReceiveUnread||
            [cell.message.srState intValue]==MMessageSRStateReceiveRead) {
            cell.cvBubble.voiceAnimationView.animationImages =[NSArray arrayWithObjects:[UIImage imageWithFileName:@"chat_voice_playing1.png"],[UIImage imageWithFileName:@"chat_voice_playing2.png"],[UIImage imageWithFileName:@"chat_voice_playing3.png"],nil];
        }else if([cell.message.srState intValue]== MMessageSRStateSending||
                 [cell.message.srState intValue]==MMessageSRStateSendFailed||
                 [cell.message.srState intValue]==MMessageSRStateSendSuccess){
            cell.cvBubble.voiceAnimationView.animationImages =[NSArray arrayWithObjects:[UIImage imageWithFileName:@"chat_voice_playing_right1.png"],[UIImage imageWithFileName:@"chat_voice_playing_right2.png"],[UIImage imageWithFileName:@"chat_voice_playing_right3.png"],nil];
        }
        
        cell.cvBubble.voiceAnimationView.animationDuration = 1;
        cell.cvBubble.voiceAnimationView.animationRepeatCount=[cell.message.voicelength longLongValue];
        
        
        [cell.cvBubble.voiceAnimationView startAnimating];
        lastAnimationImageView = cell.cvBubble.voiceAnimationView;
    }
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectRowAtIndexPath");
}


- (void)tableView:(UITableView *)tableView didRecognizeLongPressOnRowAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point{
    
    GQChatCell *cell =(GQChatCell *)[tableView cellForRowAtIndexPath:indexPath];
    CGRect cellRect =[self.view.window convertRect:[self.tbView rectForRowAtIndexPath:indexPath] fromView:self.view];
    CGRect frame = CGRectMake(cell.cvBubble.frame.origin.x, cell.cvBubble.frame.origin.y,cell.cvBubble.boxView.frame.size.width, cell.cvBubble.boxView.frame.size.height);
    
    if (CGRectContainsPoint(frame, point)) {
        CGFloat yy;
        yy =cellRect.origin.y-self.tbView.contentOffset.y-64;
        //        CGFloat yy =cellRect.origin.y-self.tbView.contentOffset.y-64;
        BOOL isUp =(yy>0)? NO:YES;
    
        float timeLabel;
        if (cell.haveTimeLabel) {
            timeLabel = 56;
        }
        else
        {
            timeLabel = 0;
        }
        
        CGFloat middleX =CGRectGetMidX(cell.cvBubble.frame);
        CGRect toolViewRect=CGRectZero;
        if (middleX-110<10) {
            toolViewRect =CGRectMake(10, isUp? yy+cell.cvBubble.boxView.frame.size.height + cell.cvBubble.frame.origin.y+64: 64+yy-cell.cvBubble.boxView.frame.size.height+cell.cvBubble.frame.origin.y , 220, 50);
        }else if(middleX+110>310){
            //删除按钮加三角
            toolViewRect =CGRectMake(70, isUp? yy+cell.cvBubble.boxView.frame.size.height+cell.cvBubble.frame.origin.y+64: 64+yy-(cell.cvBubble.boxView.frame.size.height)+cell.cvBubble.frame.origin.y, 220, 50);
            
        }else{
            toolViewRect =CGRectMake(middleX-110, isUp? yy+cell.cvBubble.boxView.frame.size.height+cell.cvBubble.frame.origin.y+64: 64+yy-cell.cvBubble.boxView.frame.size.height+cell.cvBubble.frame.origin.y, 220, 50);
            
        }
        
        GQMessageToolView *toolView =[[GQMessageToolView alloc] initWithFrame:toolViewRect isUp:isUp middleX:middleX];
        toolView.message =cell.message;
        toolView.delegate =self;
        [toolView showInWindow:self.view.window withFrame:toolViewRect];
        
    }
}


- (void)tableView:(UITableView *)tableView didRecognizeSingleTapOnRowAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point{
    
    MMessage *message = self.messageArray[indexPath.row];
    
    if (message.bigpicurl) {
        
        NSArray *infoArray = [message.bigpicurl componentsSeparatedByString:@"-"];
        
        
        if (infoArray.count > 0 && [infoArray[0] isEqualToString:@"callHangUp"]) {
            
            NSString *type;
            hangUpRecordType = [infoArray[1] intValue];
            
            if (hangUpRecordType == 1) {
                type = @"视频";
            }else{
                type = @"语音";
            }
            
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"注意" message:[NSString stringWithFormat:@"确认是否发起%@通话",type] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alterView.tag = 100;
            [alterView show];
            
            return;
        }
        
    }


    NSLog(@"didRecognizeSingleTapOnRowAtIndexPath");
    GQChatCell *cell =(GQChatCell *)[tableView cellForRowAtIndexPath:indexPath];
    CGRect cvBubbleFrame = CGRectMake(cell.cvBubble.frame.origin.x, cell.cvBubble.frame.origin.y,cell.cvBubble.boxView.frame.size.width, cell.cvBubble.boxView.frame.size.height);
    if (CGRectContainsPoint(cell.ivAvatar.frame, point)) {
        NSLog(@"点击头像");
        MEnterpriseUser *user =[[MEnterpriseUser alloc] init];
        NSDictionary *myUserDictionary =[ConfigManager sharedInstance].userDictionary;
        if ([cell.message.keyid isEqualToString:[NSString stringWithFormat:@"%@",[myUserDictionary objectForKey:@"uid"]]]) {
            user.uid =[myUserDictionary objectForKey:@"uid"];
            user.uname =[myUserDictionary objectForKey:@"name"];
            user.cid =[myUserDictionary objectForKey:@"cid"];
            user.cname=[myUserDictionary objectForKey:@"cname"];
            user.autograph=[myUserDictionary objectForKey:@"autograph"];
            user.email=[myUserDictionary objectForKey:@"email"];
            user.fax=[myUserDictionary objectForKey:@"fax"];
            user.gid=[myUserDictionary objectForKey:@"gid"];
            user.gname=[myUserDictionary objectForKey:@"gname"];
            user.groupVer=[myUserDictionary objectForKey:@"groupVer"];
            user.groupids=[myUserDictionary objectForKey:@"groupids"];
            user.bigpicurl=[myUserDictionary objectForKey:@"bigpicurl"];
            user.minipicurl=[myUserDictionary objectForKey:@"minipicurl"];
            user.extNumber=[myUserDictionary objectForKey:@"extNumber"];
            user.jid=[myUserDictionary objectForKey:@"jid"];
            user.mobile=[myUserDictionary objectForKey:@"mobile"];
            user.post=[myUserDictionary objectForKey:@"post"];
            user.pwd=[myUserDictionary objectForKey:@"pwd"];
            user.remark=[myUserDictionary objectForKey:@"remark"];
            user.telephone=[myUserDictionary objectForKey:@"telephone"];
            user.viopId=[myUserDictionary objectForKey:@"viopId"];
            user.viopSid=[myUserDictionary objectForKey:@"viopSid"];
            user.viopPwd=[myUserDictionary objectForKey:@"viopPwd"];
            user.viopSidPwd=[myUserDictionary objectForKey:@"viopSidPwd"];
        }else if([cell.message.keyid isEqualToString:self.chatUser.uid]){
            if (self.isGroup ) {
                user = ((MEnterpriseUser *)[self.chatGroup.users objectAtIndex:indexPath.row]);
            }
            else
                user=self.chatUser;
        }
        
        EnterpriseUserCardViewController *userCard =[[EnterpriseUserCardViewController alloc] initWithNibName:@"EnterpriseUserCardViewController" bundle:[NSBundle mainBundle]];
        
        //       userCard.hidesBottomBarWhenPushed =YES;
        if(user.uid)
        {
            userCard.user = user;
        }
        else
        {
            userCard.userIdStr = cell.message.keyid;
        }
        
        [self.navigationController pushViewController:userCard animated:YES];
    }else if (CGRectContainsPoint(cvBubbleFrame, point)){
        NSLog(@"单击cvBubble");
        if([cell.message.contenttype intValue]==MMessageContentTypeVoice){
            if ([cell.message.srState intValue]==MMessageSRStateReceiveUnread||
                [cell.message.srState intValue]==MMessageSRStateReceiveRead) {
                cell.cvBubble.voiceAnimationView.animationImages =[NSArray arrayWithObjects:[UIImage imageWithFileName:@"chat_voice_playing1.png"],[UIImage imageWithFileName:@"chat_voice_playing2.png"],[UIImage imageWithFileName:@"chat_voice_playing3.png"],nil];
            }else if([cell.message.srState intValue]== MMessageSRStateSending||
                     [cell.message.srState intValue]==MMessageSRStateSendFailed||
                     [cell.message.srState intValue]==MMessageSRStateSendSuccess){
                cell.cvBubble.voiceAnimationView.animationImages =[NSArray arrayWithObjects:[UIImage imageWithFileName:@"chat_voice_playing_right1.png"],[UIImage imageWithFileName:@"chat_voice_playing_right2.png"],[UIImage imageWithFileName:@"chat_voice_playing_right3.png"],nil];
            }
            
            cell.cvBubble.voiceAnimationView.animationDuration =1;
            cell.cvBubble.voiceAnimationView.animationRepeatCount=[cell.message.voicelength longLongValue];
            
            NSMutableArray *imagePathComponents = [NSMutableArray arrayWithArray:[cell.message.wavPath pathComponents]];
            NSString *file = [imagePathComponents lastObject];
            
            NSString *realPath = [[NSString stringWithFormat:@"%@/%@",APPCachesDirectory,@"tmp/chatVoice/"] stringByAppendingPathComponent:file];
            if([[NSString stringWithFormat:@"file://%@",realPath] isEqualToString:[self.audioPlayer.url description]]&&self.audioPlayer.isPlaying)
            {
                voiceAnimationRow = -1;
                [self.audioPlayer stop];
                [lastAnimationImageView stopAnimating];
                lastAnimationImageView = cell.cvBubble.voiceAnimationView;
                self.audioPlayer = nil;
            }
            else
            {
                [lastAnimationImageView stopAnimating];
                AVAudioSession *audioSession = [AVAudioSession sharedInstance];
                [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                if ([fileManager fileExistsAtPath:realPath]) {
                    NSLog(@"fileExist");
                }
                else
                {
                    NSLog(@"thisfileNotExist==%@",realPath);
                }
                [self.audioPlayer stop];
                self.audioPlayer = nil;
                
                NSError *error =nil;
                self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath:realPath] error:&error];
                self.audioPlayer.numberOfLoops = 0;
                self.audioPlayer.delegate =self;
                [self.audioPlayer play];
                
                voiceAnimationRow = indexPath.row;
                [cell.cvBubble.voiceAnimationView startAnimating];
                lastAnimationImageView = cell.cvBubble.voiceAnimationView;
            }
            NSLog(@"playing");
        }
        else if ([cell.message.contenttype intValue]==MMessageContentTypePhoto)
        {
            //预览
            
            ZLPhotoPickerBrowserViewController *browserVc = [[ZLPhotoPickerBrowserViewController alloc] init];
            [browserVc showHeadPortrait:cell.cvBubble.photoView originUrl:cell.message.bigpicurl];
        }
        else if ([cell.message.contenttype intValue]==MMessageContentTypeVideo||[cell.message.contenttype intValue]==MMessageContentTypeFile||[cell.message.contenttype intValue]==MMessageContentTypePhoto){
            
            if (cell.message.videoPath && cell.message.videoPath.length>0) {
                NSMutableArray *videoPathComponents = [NSMutableArray arrayWithArray:[cell.message.videoPath pathComponents]];
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                if ([fileManager fileExistsAtPath:cell.message.videoPath]) {
                    NSLog(@"videofileExist");
                }
                else
                {
                    NSLog(@"thisvideofileNotExist==%@",cell.message.videoPath);
                }
                
                NSString *file = [videoPathComponents lastObject];
                
                NSString* videoPath = [NSString stringWithFormat:@"%@/%@%@",APPCachesDirectory,@"tmp/download/",file];
                
                MPMoviePlayerViewController *playerViewController =[[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:videoPath]];
                [self presentMoviePlayerViewControllerAnimated:playerViewController];
                
                MPMoviePlayerController *player = [playerViewController moviePlayer];
                player.controlStyle = MPMovieControlStyleFullscreen;
                player.shouldAutoplay = YES;
                player.repeatMode = MPMovieRepeatModeNone;
                [player setFullscreen:NO animated:YES];
                player.scalingMode = MPMovieScalingModeAspectFit;
                [player play];
            }else{
                
                if (cell.message.filePath && cell.message.filePath > 0) {
                    
                    NSURL *URL = [NSURL fileURLWithPath:cell.message.filePath];
                    TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self.view andRect:self.view.bounds];
                    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:@[openInAppActivity]];
                    
                    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                        // Store reference to superview (UIActionSheet) to allow dismissal
                        openInAppActivity.superViewController = activityViewController;
                        // Show UIActivityViewController
                        [self presentViewController:activityViewController animated:YES completion:NULL];
                    } else {
                        // Create pop up
                        _doucmentInteractionVC = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
                        // Store reference to superview (UIPopoverController) to allow dismissal
                        openInAppActivity.superViewController = _doucmentInteractionVC;
                        // Show UIActivityViewController in popup
                        [_doucmentInteractionVC presentPopoverFromRect:self.view.bounds inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                    }
                    
                    
                    
                }else{
                    FileDetailViewController *fileDetail=[[FileDetailViewController alloc] initWithNibName:@"FileDetailViewController" bundle:[NSBundle mainBundle]];
                    fileDetail.message =cell.message;
                    if([cell.message.contenttype intValue]==MMessageContentTypeVideo)
                    {
                        fileDetail.isVideo = YES;
                    }
                    [self.navigationController pushViewController:fileDetail animated:YES];
                }
                
            }
        }
            
    }else if (CGRectContainsPoint(cell.ivSendFailure.frame, point)){
        self.inputTextView.text =@"";
        [self hideBoardWithVoiceBtnSelected:NO];
        
        self.asSendFailure = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(LOCALIZATION(@"discover_cancel" ), nil) destructiveButtonTitle:NSLocalizedString(LOCALIZATION(@"Message_agin_message"), nil) otherButtonTitles:nil];
        [self.asSendFailure showInWindow:self.view.window];
        self.sendFailureMsg=cell.message;
    }
}



- (void)tableView:(UITableView *)tableView didRecognizeDoubleTapOnRowAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point{
    NSLog(@"didRecognizeDoubleTapOnRowAtIndexPath");
    //
    //    GQChatCell *cell =(GQChatCell *)[tableView cellForRowAtIndexPath:indexPath];
    //    if (CGRectContainsPoint(cell.ivAvatar.frame, point)) {
    //        EnterpriseUserCardViewController *userCard =[[EnterpriseUserCardViewController alloc] initWithNibName:@"EnterpriseUserCardViewController" bundle:[NSBundle mainBundle]];
    //        userCard.user =self.chatUser;
    ////        userCard.hidesBottomBarWhenPushed =YES;
    //        [self.navigationController pushViewController:userCard animated:YES];
    //    }else if (CGRectContainsPoint(cell.cvBubble.frame, point)){
    //        NSLog(@"双击cvBubble");
    //    }
}

-(CGFloat)calcCellHeight:(MMessage*)mm{
    CGFloat cellHeight =44.0f;
    switch ([mm.contenttype intValue]) {
        case MMessageContentTypeText:{
            
            NSNumber *fontSize = [[NSUserDefaults standardUserDefaults] valueForKey:@"chatFont"];
            
            if (!fontSize) {
                
                fontSize = @(14.0);
                
            }
            
            CGSize lineSize = [@"test" sizeWithFont:[UIFont systemFontOfSize:fontSize.floatValue]];
            CGSize textSize=[FaceHelper calcShufflingLabelRect:mm.msg font:[UIFont systemFontOfSize:fontSize.floatValue] maxWidth:MAXWIDTH lineHeight:lineSize.height imageWidth:lineSize.height];
            
            cellHeight =SENDTIME_HEIGHT+textSize.height+3*INNER_MARGIN;
        }
            break;
        case MMessageContentTypePhoto:{
            UIImage *image=[[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:mm.bigpicurl];
            if (image) {
                if(image.size.height>image.size.width){
                    cellHeight =SENDTIME_HEIGHT+MAX_PHOTO_HEIGHT+2*PHOTO_BORDER_WIDTH+INNER_MARGIN;
                }else{
                    cellHeight =MAX_PHOTO_HEIGHT*image.size.height/image.size.width+SENDTIME_HEIGHT+INNER_MARGIN+2*PHOTO_BORDER_WIDTH;
                }
            }else{
                cellHeight =SENDTIME_HEIGHT+MAX_PHOTO_HEIGHT+2*PHOTO_BORDER_WIDTH+INNER_MARGIN;
            }
            
        }
            break;
        case MMessageContentTypeVideo:{
            cellHeight =SENDTIME_HEIGHT+100+INNER_MARGIN;
        }
            break;
        case MMessageContentTypeFile:{
            cellHeight =SENDTIME_HEIGHT+100+INNER_MARGIN;
        }
            break;
        case MMessageContentTypeVoice:{
            cellHeight =SENDTIME_HEIGHT+60+INNER_MARGIN;
        }
        default:
            break;
    }
    
    if([mm.srState integerValue]==MMessageSRStateReceiveRead || [mm.srState integerValue] ==MMessageSRStateReceiveUnread){
        if ([mm.type integerValue] == MMessageTypeGroupChat) {
            return cellHeight + 20;
        }
    }
    
    return cellHeight;
    
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MMessage *mm =(MMessage*)[self.messageArray objectAtIndex:indexPath.row];
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SDWebImageManager *manager=[SDWebImageManager sharedManager];
        if (mm.bigpicurl&&
            mm.bigpicurl.length>0&&
            [mm.contenttype intValue]==MMessageContentTypePhoto){
            
            UIImage *image=[manager.imageCache imageFromDiskCacheForKey:mm.bigpicurl];
            if (image) {
                
            }else{
                if ([mm.bigpicurl hasPrefix:@"assets-library"]) {
                    ALAssetsLibrary *assetslibrary = [[ALAssetsLibrary alloc] init];
                    [assetslibrary assetForURL:[NSURL URLWithString:mm.bigpicurl ] resultBlock:^(ALAsset *asset){
                        UIImage *img = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                        if(img){
                            [manager.imageCache storeImage:img forKey:mm.bigpicurl toDisk:YES];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakSelf.tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                            });
                        }
                    }failureBlock:^(NSError *error){
                        
                    }];
                }else{
                    [manager downloadImageWithURL:[NSURL URLWithString:mm.bigpicurl] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        if(image && finished){
                            
                            [manager.imageCache storeImage:image forKey:mm.bigpicurl toDisk:YES];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
//                                [weakSelf.tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                [weakSelf.tbView reloadData];
                                
                            });
                        }
                        
                    }];
                    
                    //                    [manager downloadWithURL:[NSURL URLWithString:mm.bigpicurl] options:SDWebImageLowPriority progress:^(NSUInteger receivedSize, long long expectedSize) {
                    //
                    //                    } completed:^(UIImage *img, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                    //                        if(img && finished){
                    //                            [manager.imageCache storeImage:img forKey:mm.bigpicurl toDisk:YES];
                    //                            dispatch_async(dispatch_get_main_queue(), ^{
                    //                                [weakSelf.tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    //                            });
                    //                        }
                    //                        
                    //                    }];
                }
                
            }
            
            
        }
    });
}


#pragma mark - Button Clicked 按钮点击方法

-(void)hideBoardWithVoiceBtnSelected:(BOOL)voiceBtnSelected{
    self.inputTextView.placeholder=@"";
    [self.inputTextView resignFirstResponder];
    
    CGRect mainScreenFrame=[[UIScreen mainScreen] bounds];
    [self.faceBoard setFrame:CGRectMake(0, CGRectGetHeight(mainScreenFrame), boundsWidth, 216) ];
    [self.shareMenuBoard setFrame:CGRectMake(0, CGRectGetHeight(mainScreenFrame), boundsWidth, 216) ];
    
    if (voiceBtnSelected) {
        [self.faceSwitchView setFrame:CGRectMake(0,viewWithNavNoTabbar - INPUTVIEWHEIGHT, boundsWidth, 260) bottomHeight:216];
        [self.tbView setFrame:CGRectMake(0, 0, boundsWidth, viewWithNavNoTabbar - INPUTVIEWHEIGHT)];
    }else{
        [self.faceSwitchView setFrame:CGRectMake(0,viewWithNavNoTabbar - CGRectGetHeight(self.inputTextView.frame) - (INPUTVIEWHEIGHT - inputTextHeight), boundsWidth, (INPUTVIEWHEIGHT - inputTextHeight)+216+CGRectGetHeight(self.inputTextView.frame)) bottomHeight:216];
        [self.tbView setFrame:CGRectMake(0, 0, boundsWidth, viewWithNavNoTabbar - CGRectGetHeight(self.inputTextView.frame) - (INPUTVIEWHEIGHT - inputTextHeight))];
        self.btnSwitch.selected =NO;
        self.btnMore.selected=NO;
    }
    
}



-(void)clickLeftItem:(id)sender{
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    self.messageArray = nil;
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)clickRightItem:(id)sender{
    if (self.isGroup) {
        NSLog(@"进入群聊详情页面");
        GroupChatDetailViewController *detail =[[GroupChatDetailViewController alloc] initWithNibName:@"GroupChatDetailViewController" bundle:[NSBundle mainBundle]];
        if(!self.chatGroup && self.chatMessage)
        {
            detail.chatMessage = self.chatMessage;
        }
        else
        {
            detail.group =self.chatGroup;
            
        }
        detail.delegate = self;
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        ChatDetailViewController *detail =[[ChatDetailViewController alloc] init];
        if(!self.chatUser && self.chatMessage)
        {
            detail.chatMessage = self.chatMessage;
        }
        else
        {
            detail.chatUser =self.chatUser;
        }
        detail.delegate = self;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

-(void)clickCallButton:(id)sender
{
    
}


-(void)clickedCopyBtnOnMessageToolView:(MMessage*)message{
    NSLog(@"clickedCopyBtnOnMessageToolView");
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = message.msg;
    

    
    
}

- (void)clickedTranslateBtnOnMessageToolView:(MMessage *)message{

    if (message.contenttype.intValue == MMessageContentTypeText) {
        if (message.msg && message.msg.length > 0) {
            
            [Translator translate:message.msg];
            
        }
    }
    
}

-(void)clickedForwardBtnOnMessageToolView:(MMessage*)message{
    NSLog(@"clickedForwardBtnOnMessageToolView");
    
    SelectEnterpriseUserViewController *selectUserVC =[[SelectEnterpriseUserViewController alloc] init];
    [selectUserVC setSelectBlock:^(NSArray *responseArray){
        
        if(responseArray.count == 0)
        {
            return ;
        }
        
        
        ChatViewController *chatVC =[[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:[NSBundle mainBundle]];
        chatVC.isForward = YES;
        chatVC.chatUser =[responseArray objectAtIndex:0];
        //处理message
        message.keyid =[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
        message.sessionid = chatVC.chatUser.uid;
        message.sessionname = chatVC.chatUser.uname;
        message.pinyin = chatVC.chatUser.pinyin;
        message.msgOtherId = message.sessionid;
        message.msgOtherName = message.sessionname;
        //////////////////////////////////////////////////////////////////////////////
        chatVC.chatMessage = message;
        chatVC.isGroup =NO;
        
        
        switch ([message.contenttype intValue]) {
            case MMessageContentTypeText:{
                chatVC.forwardMsg = message.msg;
                
            }
                break;
            case MMessageContentTypeFile:
                
                break;
            case MMessageContentTypePhoto:{
                chatVC.forwardFilePath = message.filePath;
            }
                
                break;
            case MMessageContentTypeVoice://语音不用转发
                /*
                 chatVC.forwardFilePath = message.wavPath;
                 chatVC.forwardAmrPath = message.amrPath;
                 chatVC.forwardWavPath = message.wavPath;
                 chatVC.forwardVoiceLength = message.voicelength;
                 */
                return;
            case MMessageContentTypeVideo:
                chatVC.forwardFilePath = message.videoPath;
                break;
            default:
                break;
        }
        
        [self.navigationController pushViewController:chatVC animated:YES];
    }];
    
    
    
    GQNavigationController *selectUserVCNav =[[GQNavigationController alloc] initWithRootViewController:selectUserVC];
    [self presentViewController:selectUserVCNav animated:YES completion:^{
        
    }];
}

-(void)clickedDeleteBtnOnMessageToolView:(MMessage *)message withIndex:(int)index{
    self.isClickedeleteBtn = YES;
    self.deleteCell = index;
    if(self.audioPlayer && self.audioPlayer.isPlaying)
    {
        //删除语音的时候需要停止播放语音
        voiceAnimationRow = -1;
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
    [[SQLiteManager sharedInstance] deleteMessageByIds:[NSArray arrayWithObject:message.msgId] notificationName:NOTIFICATION_R_SQL_MESSAGE];
}
-(void)deleteOneMessageSuccess
{
    NSLog(@"deleteOneMessageSuccess");
    [self loadDataWithFlag:0];
}

-(void)clickedMultipleForwardBtnOnMessageToolView:(MMessage *)message{
    NSLog(@"clickedMultipleForwardBtnOnMessageToolView");
    ChatMoreViewController *chatVC = [[ChatMoreViewController alloc] init];
    chatVC.chatUser = _chatUser;
    chatVC.chatGroup = _chatGroup;
    chatVC.isGroup =_isGroup;
    [self.navigationController pushViewController:chatVC animated:YES];
    
    
}

- (IBAction)voipVoiceBtnClicked:(id)sender {
    [self.view makeToast:LOCALIZATION(@"Message_pleaseHond")];
}

- (IBAction)voipVideoBtnClicked:(id)sender {
    [self.view makeToast:LOCALIZATION(@"Message_pleaseHond")];
}


- (IBAction)holdBtnTouchUpInside:(id)sender{
    [self.audioRecorder stop];
    [self.recordingHud hide:YES];
}

- (IBAction)holdBtnTouchUpOutside:(id)sender{
    [self.audioRecorder deleteRecording];
    self.recordingHud.labelText =LOCALIZATION(@"Message_changchuang_Cancel");
    [self.recordingHud show:YES];
    [self.recordingHud hide:YES afterDelay:2];
}

- (IBAction)voiceBtnClicked:(id)sender{
    
    self.btnVoice.selected=!self.btnVoice.selected;
    if (self.btnVoice.selected) {
        [self hideBoardWithVoiceBtnSelected:YES];
        self.btnHold.hidden =NO;
        self.inputTextView.hidden =YES;
        
    }else{
        [self.inputTextView becomeFirstResponder];
        self.btnHold.hidden =YES;
        self.inputTextView.hidden =NO;
    }
    
    self.btnSwitch.selected =NO;
    self.btnMore.selected=NO;
    
    
    
}
- (IBAction)switchBtnClicked:(id)sender{
    self.btnSwitch.selected =!self.btnSwitch.selected;
    if (self.btnSwitch.selected) {
        if (self.inputTextView.internalTextView.isFirstResponder) {
            [self.inputTextView resignFirstResponder];
        }else{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification object:nil];
        }
        self.faceBoard.hidden =NO;
    }else{
        [self.inputTextView becomeFirstResponder];
        
    }
    self.btnVoice.selected =NO;
    self.btnMore.selected =NO;
    self.shareMenuBoard.hidden =YES;
    self.btnHold.hidden =YES;
    self.inputTextView.hidden =NO;
}
- (IBAction)moreBtnClicked:(id)sender{
    self.btnMore.selected=!self.btnMore.selected;
    if (self.btnMore.selected) {
        if (self.inputTextView.internalTextView.isFirstResponder) {
            [self.inputTextView resignFirstResponder];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification object:nil];
        }
        self.shareMenuBoard.hidden =NO;
    }else{
        [self.inputTextView becomeFirstResponder];
    }
    
    self.btnSwitch.selected =NO;
    self.btnVoice.selected =NO;
    self.faceBoard.hidden =YES;
    
    self.btnHold.hidden =YES;
    self.inputTextView.hidden =NO;
}


#pragma mark - Notification 通知调用方法
//当前用户被移出了群
- (void)userRemovedFromGroup:(NSNotification*)noti{
    
    NSDictionary *userInfo = noti.userInfo;
    
    if ([userInfo[@"groupid"] isEqualToString:[self.chatMessage.sessionid substringFromIndex:1]]) {
        
        isSelfRemoveFromGroup = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

//用户被邀请加入群组
- (void)userInvitedToJoinGroup:(NSNotification*)noti{
    
    NSDictionary *userInfo = noti.userInfo;
    
    if ([userInfo[@"groupid"] isEqualToString:[self.chatMessage.sessionid substringFromIndex:1]]) {
        
        isSelfRemoveFromGroup = NO;
        self.chatMessage.isResendAfterRemovedFromGroup = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIButton *rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            [rightBtn setFrame:CGRectMake(0, 0, 30, 30)];
            [rightBtn setBackgroundColor:[UIColor clearColor]];
            [rightBtn setBackgroundImage:[UIImage imageNamed:@"chat_settingHead.png"] forState:UIControlStateNormal];
            [rightBtn addTarget:self action:@selector(clickRightItem:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
            self.navigationItem.rightBarButtonItem = rightItem;
            
        });
        
        
    }
    
    
}

-(void)notificationUSQLMessageSendState:(NSNotification*)noti{
    NSString *msgId =[[noti userInfo] objectForKey:@"msgId"];
    NSString *srState =[[noti userInfo] objectForKey:@"srState"];
    if (msgId && msgId.length>0) {
        for (int i=0;i<[self.messageArray count];i++) {
            MMessage *mm =[self.messageArray objectAtIndex:i];
            if ([mm.msgId isEqualToString:msgId]) {
                mm.srState=srState;
                GQChatCell *cell =(GQChatCell*)[self.tbView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                cell.message =mm;
            }
        }
    }
}

-(void)notificationRSQLMessage{
    //   如果点击了删除按钮 则 调用 另一个刷新表的 方法
    if (self.isClickedeleteBtn == YES) {
        [self loadDataWithFlag:0 withIndex:self.deleteCell];
        return;
    }
    [self loadDataWithFlag:0];
}

-(void)norificationUSQLGroupName:(NSNotification *)noti
{
    if (self.isGroup) {
        self.navigationItem.title = [noti object];
    }
}
#pragma mark - Other Delegate 其他代理
#pragma mark - Private method 私有方法




/**
 *  处理转发的信息
 */
- (void)handleForwardMessage{
    
    if (_forwardMsg) {
        self.inputTextView.text = _forwardMsg;
        [self sendTextToServer:nil];
        
        return;
    }
    
    if (_forwardFilePath) {
        
        MMessageContentType contentType = self.chatMessage.contenttype.intValue;
        
        if (contentType == MMessageContentTypeVoice) {
            
            NSData *amrData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:_forwardAmrPath]];
            [self sendAmrDataToServer:amrData duration:_forwardVoiceLength.intValue wavPath:_forwardWavPath amrPath:_forwardAmrPath];
            
            return;
        }
        
        NSString *fileUrl = self.chatMessage.bigpicurl;
        
        NSDictionary *fileAttrs =  [[NSFileManager defaultManager]attributesOfItemAtPath:_forwardFilePath error:nil];
        
        [self sendFileUrlToServer:fileUrl contentType:contentType filePath:_forwardFilePath fileSize:[NSString stringWithFormat:@"%@",fileAttrs[@"NSFileSize"]]];
    }
}


//单机隐藏键盘
- (void)touchHiddenKeyBoard:(UIGestureRecognizer *)sender
{
    [self.inputTextView resignFirstResponder];
    [self hideBoardWithVoiceBtnSelected:NO];
}

#pragma mark keyboard隐藏事件
-(void) keyboardWillHide:(NSNotification *) notification{
//    m_KeyboardHeight=216;
//
    
    if (!self.isFromChatRecode) {
        
        NSNumber *duration = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        CGRect mainScreenFrame=self.view.frame;
        //    CGFloat deltaY =CGRectGetHeight(mainScreenFrame)-CGRectGetHeight(self.inputTextView.frame)-226;
        
        [UIView animateWithDuration:[duration doubleValue] animations:^{
            [self.faceSwitchView setFrame:CGRectMake(0, CGRectGetHeight(mainScreenFrame)-CGRectGetHeight(self.inputTextView.frame)-216-(INPUTVIEWHEIGHT - inputTextHeight), boundsWidth, CGRectGetHeight(self.inputTextView.frame)+216+(INPUTVIEWHEIGHT - inputTextHeight)) bottomHeight:216];
            [self.faceBoard setFrame:CGRectMake(0, CGRectGetHeight(mainScreenFrame)-216, boundsWidth, 216)];
            [self.shareMenuBoard setFrame:CGRectMake(0, CGRectGetHeight(mainScreenFrame)-216, boundsWidth, 216)];
            
            [self.tbView setFrame:CGRectMake(0, 0, boundsWidth, CGRectGetHeight(mainScreenFrame)-216-CGRectGetHeight(self.inputTextView.frame)-(INPUTVIEWHEIGHT - inputTextHeight))];
            [self tbViewScrollToBottom];
        } completion:^(BOOL finished) {
            self.faceBoard.hpInputTextView = self.inputTextView;
        }];
    }
    
   
}


#pragma mark keyboard弹出事件
-(void) keyboardWillShow:(NSNotification *) notification{
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSNumber *duration = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    m_KeyboardHeight = keyboardRect.size.height;
    
    CGRect mainScreenFrame=self.view.frame;
//    CGFloat deltaY =CGRectGetHeight(mainScreenFrame)-CGRectGetHeight(keyboardRect)-CGRectGetHeight(self.inputTextView.frame)-10;
    
    
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        [self.faceSwitchView setFrame:CGRectMake(0, CGRectGetHeight(mainScreenFrame)-CGRectGetHeight(keyboardRect)-CGRectGetHeight(self.inputTextView.frame)-(INPUTVIEWHEIGHT - inputTextHeight), boundsWidth, CGRectGetHeight(keyboardRect)+CGRectGetHeight(self.inputTextView.frame)+(INPUTVIEWHEIGHT - inputTextHeight)) bottomHeight:CGRectGetHeight(keyboardRect)];
        [self.faceBoard setFrame:CGRectMake(0, CGRectGetHeight(mainScreenFrame), boundsWidth, 216)];
        [self.shareMenuBoard setFrame:CGRectMake(0, CGRectGetHeight(mainScreenFrame), boundsWidth, 216)];
        
        [self.tbView setFrame:CGRectMake(0, 0, boundsWidth, CGRectGetHeight(mainScreenFrame)-CGRectGetHeight(keyboardRect)-CGRectGetHeight(self.inputTextView.frame)-(INPUTVIEWHEIGHT - inputTextHeight))];
        [self tbViewScrollToBottom];
    } completion:^(BOOL finished){
        
    }];
}






-(void)handleSingleTap:(UIGestureRecognizer *)sender
{
    if(self.microphoneRadialMenu.menuVisible)
        [self.microphoneRadialMenu didTouch:sender];
}

-(void)showNomalInput
{
    self.voiceView.hidden = YES;
    self.inputTextView.hidden = NO;
    self.btnMore.hidden = NO;
}

-(void)showVoiceInput
{
    self.voiceView.hidden = NO;
    self.inputTextView.hidden = YES;
    self.btnMore.hidden = YES;
}



-(void)tbViewScrollToBottom{
    if (self.tbView.contentSize.height > self.tbView.frame.size.height){
        CGPoint offset = CGPointMake(0, self.tbView.contentSize.height - self.tbView.frame.size.height);
        [self.tbView setContentOffset:offset animated:NO];
    }
}




#pragma mark ShareMenuBoardDelegate
//分享面板
-(void)shareMenuClickedWithType:(ShareMenuType)type{
    
    switch (type) {
        case ShareMenuTypePhoto:{
            IBActionSheet* actionSheet = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCALIZATION(@"discover_cancel") destructiveButtonTitle:nil otherButtonTitles:LOCALIZATION(@"dis_header_takepic"),LOCALIZATION(@"dis_header_picker"),nil];
            actionSheet.tag = PICTIONSHEET;
            [actionSheet showInWindow:self.view.window];
        }
            break;
        case ShareMenuTypeShoot:{
            
            IBActionSheet* actionSheet = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCALIZATION(@"discover_cancel") destructiveButtonTitle:nil otherButtonTitles:LOCALIZATION(@"Message_playVoide"),LOCALIZATION(@"dis_header_picker"),nil];
            actionSheet.tag = VIDEOTIONSHEET;
            [actionSheet showInWindow:self.view.window];
        }
            break;
//        case ShareMenuTypeRecord:{
//            //聊天记录
//            ChatMoreViewController *chatVC = [[ChatMoreViewController alloc] init];
//            chatVC.chatUser = _chatUser;
//            chatVC.chatGroup = _chatGroup;
//            chatVC.isGroup =_isGroup;
//            [self.navigationController pushViewController:chatVC animated:YES];
//        }
//            break;
//        case ShareMenuTypeFile:{
//            //跳到文件列表
//            return;
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                NSString *filePath =[[NSBundle mainBundle] pathForResource:@"sample.pdf" ofType:nil];
//                NSDictionary *uploadResult=[[FastDFSManager sharedInstance] handleWithActionName:@"upload" localFileName:filePath remoteFilename:nil groupName:nil];
//                if ([[uploadResult objectForKey:@"code"] intValue] ==0) {
//                    [self sendFileUrlToServer:[uploadResult objectForKey:@"masterUrl"] contentType:MMessageContentTypeFile filePath:filePath fileSize:[NSString stringWithFormat:@"%@",[uploadResult objectForKey:@"fileSize"]]];
//                    
//                }else{
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:LOCALIZATION(@"Message_changchuang_File") message:@"" cancelButtonTitle:LOCALIZATION(@"Message_CXAlertView_title")];
//                        alertView.showBlurBackground = YES;
//                        [alertView show];
//                        
//                    });
//                }
//            });
//            
//            
//        }
//            break;
        case ShareMenuTypeVoice:{
            [self makeVoipCall];
        }
            break;
        case ShareMenuTypeVideo:{
            [self makeVideoCall];
        }
            break;
            
        default:
            break;
    }
}

-(void)makeVideoOrVoiceCall
{
    IBActionSheet *asAvatar = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(LOCALIZATION(@"discover_cancel"), nil) destructiveButtonTitle:NSLocalizedString(LOCALIZATION(@"Message_VideoCall"), nil) otherButtonTitles:NSLocalizedString(LOCALIZATION(@"Message_shiping_Call"), nil), nil];
    asAvatar.tag = MAKECALLTIONSHEET;
    [asAvatar showInWindow:self.view.window];
}

- (void)makeVoipCall
{
    VoipViewController *vc = [[VoipViewController alloc] init];
    vc.callType = 0;
    _voiceCallType = 1;
    vc.callUser = _chatUser;
    //更换SDK voip的类型 是点对点语音电话
    vc.voipType = VOICE;  //更换SDK SDK中定义的VOIP类型（点对点语音电话类型）
    currentCallType=VOICE;
    vc.view.alpha = 0.1;
    GQNavigationController *audioCallNav =[[GQNavigationController alloc] initWithRootViewController:vc];
    
    //这种方式 一般出现在需要使用者完成某件事，如输入密码，增加资料等操作后，才能回跳到前一个页面
    [self presentViewController:audioCallNav animated:NO completion:^{
        [UIView animateWithDuration:0.6 animations:^{
            vc.view.alpha = 1;
        }];
        
    }];
}

-(void)makeVideoCall
{
    VoipViewController *vc = [[VoipViewController alloc] init];
    vc.callType = 0;
    _voiceCallType = 1;
    vc.callUser = _chatUser;
    vc.voipType = VIDEO;
    currentCallType=VIDEO;
    vc.view.alpha = 0.1;
    
    GQNavigationController *audioCallNav =[[GQNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:audioCallNav animated:NO completion:^{
        [UIView animateWithDuration:0.6 animations:^{
            vc.view.alpha = 1;
        }];
    }];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileUploaded:) name:ZTEFileUplodedNotification object:nil];
    
    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_changchuanging") isDismissLater:NO];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];

        if ([mediaType isEqualToString:@"public.image"]){
            UIImage *originalImage=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
            UIImage *neworiginalImage =[originalImage fixOrientation];
            UIImage* masterImage = [Common createThumbnilFromUIImage:neworiginalImage max:1000];
            if (masterImage) {
                
                _filePath = [NSString stringWithFormat:@"%@/%@%@.jpg",APPCachesDirectory,@"tmp/chatimage/",[Common generateID]];
                
                NSData* masterData = UIImageJPEGRepresentation(masterImage,1.0);
                
                BOOL success = [masterData writeToFile:_filePath atomically:NO];
                
                if (success) {
                    
                    NSMutableDictionary * dir=[NSMutableDictionary dictionary];
                    
                    [dir setValue:[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"] forKey:@"token"];
                    
                    NSString *newURL = [ZTEUserProfileTools getUploadFileApiUrl];
                    
                    /**
                     *  上传
                     */

                     [ZTEUserProfileTools uploadFileWithURL:newURL postParems:dir FilePath:_filePath FileName:@"image.jpg" Asset:nil message:nil];
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MMProgressHUD dismiss];
                        CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:LOCALIZATION(@"Message_changchuang_Pfile") message:@"" cancelButtonTitle:LOCALIZATION(@"Message_CXAlertView_title")];
                        alertView.showBlurBackground = YES;
                        [alertView show];
                    });
                }
                
            }
            
        }else if ([mediaType isEqualToString:@"public.movie"]){
            NSData *videoData = [NSData dataWithContentsOfURL:[info objectForKey:UIImagePickerControllerMediaURL]];
            if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
            {
                //摄像头返回的，就要保存一下
                NSString* tmpPath = (NSString *)[[info objectForKey:UIImagePickerControllerMediaURL] path];
                UISaveVideoAtPathToSavedPhotosAlbum(tmpPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            }
            if (videoData) {
                _filePath = [NSString stringWithFormat:@"%@/%@%@.MOV",APPCachesDirectory,@"tmp/download/",[Common generateID]];
                BOOL success = [videoData writeToFile:_filePath atomically:NO];
                
                if (success) {
                     NSDictionary *fileAttrs =  [[NSFileManager defaultManager]attributesOfItemAtPath:_filePath error:nil];
                    NSString *fileSize = [NSString stringWithFormat:@"%@",fileAttrs[@"NSFileSize"]];
                    NSMutableDictionary * dir=[NSMutableDictionary dictionary];
                    
                    [dir setValue:[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"] forKey:@"token"];
                    
                    NSString *newURL = [ZTEUserProfileTools getUploadFileApiUrl];
                     MMessage *mm = [self createFileMessageWithFileURL:_filePath contentType:MMessageContentTypeVideo filePath:_filePath fileSize:fileSize];
                    /**
                     *  上传
                     */

                    [ZTEUserProfileTools uploadFileWithURL:newURL postParems:dir FilePath:_filePath FileName:@"test.mov" Asset:nil message:mm];

                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MMProgressHUD updateStatus:LOCALIZATION(@"Message_changchuang_Success")];
                    });
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MMProgressHUD dismissAfterDelay:1.0f];;
                    });
                    
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [picker dismissViewControllerAnimated:YES completion:NULL];
        });

    });
}
- (MMessage*)createFileMessageWithFileURL:(NSString*)fileUrl contentType:(MMessageContentType)contentType filePath:(NSString*)filePath fileSize:(NSString*)fileSize
{
    WEAKSELF
    MMessage *mm =[[MMessage alloc] init];
    mm.sendTime =[NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970]*1000];
    mm.msgId =[NSString stringWithUUID];
    mm.srState =[NSString stringWithFormat:@"%d",MMessageSRStateSending];
    mm.contenttype =[NSString stringWithFormat:@"%d",contentType];
    mm.msg =[fileUrl lastPathComponent];
    mm.keyid =[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
    mm.identity =[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
    mm.username =[[ConfigManager sharedInstance].userDictionary objectForKey:@"name"];
    mm.headpicurl =[[ConfigManager sharedInstance].userDictionary objectForKey:@"bigpicurl"];
    mm.modeltype= @"0";
    mm.bigpicurl= fileUrl;
    if (contentType==MMessageContentTypeVideo) {
        mm.videoPath=filePath;
    }else{
        mm.filePath=filePath;
    }

    mm.filelength =fileSize;
    if (self.chatMessage)
    {
        if (!weakSelf.isGroup)
        {
            if ([[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]]isEqualToString:weakSelf.chatMessage.keyid]) {
                mm.sessionid =weakSelf.chatMessage.sessionid;
                mm.sessionname=weakSelf.chatMessage.sessionname;
            }
            else
            {
                mm.sessionid =weakSelf.chatMessage.keyid;
                mm.sessionname=weakSelf.chatMessage.username;
            }
            mm.type =[NSString stringWithFormat:@"%d",MMessageTypeChat];
        }
        else
        {
            //判断你是否还属于这个群
            NSString *string = [NSString stringWithFormat:@"%@",weakSelf.chatMessage.sessionid];
            string = [string stringByReplacingOccurrencesOfString:@"g" withString:@""];
            MGroupUser *groupUser =[[[SQLiteManager sharedInstance] getAllOnlyGroups] objectForKey:string];
            if (!groupUser) {
                [weakSelf hideBoardWithVoiceBtnSelected:NO];
                [self.view makeToast:LOCALIZATION(@"Message_notGroup_noMessage")];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                });
                return nil;
            }
            //end
            mm.sessionid =weakSelf.chatMessage.sessionid;
            mm.sessionname=weakSelf.chatMessage.sessionname;
            mm.type =[NSString stringWithFormat:@"%d",MMessageTypeGroupChat];
        }
        mm.msgOtherId =mm.sessionid;
        mm.msgOtherName =mm.sessionname;
        mm.msgOtherAvatar=weakSelf.chatMessage.msgOtherAvatar;
    }
    else
    {
        if (weakSelf.isGroup) {
            //判断你是否还属于这个群
            MGroupUser *groupUser =[[[SQLiteManager sharedInstance] getAllOnlyGroups] objectForKey:[NSString stringWithFormat:@"%@",weakSelf.chatGroup.groupid]];
            if (!groupUser) {
                [weakSelf hideBoardWithVoiceBtnSelected:NO];
                [self.view makeToast:LOCALIZATION(@"Message_notGroup_noMessage")];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
                return nil;
            }
            //end
            mm.sessionid =[NSString stringWithFormat:@"g%@",weakSelf.chatGroup.groupid];
            mm.sessionname =weakSelf.chatGroup.groupName;
            mm.msgOtherId =mm.sessionid;
            mm.msgOtherName =mm.sessionname;
            mm.type =[NSString stringWithFormat:@"%d",MMessageTypeGroupChat];
        }else{
            mm.sessionid =weakSelf.chatUser.uid;
            mm.sessionname=weakSelf.chatUser.uname;
            mm.msgOtherId =mm.sessionid;
            mm.msgOtherName =mm.sessionname;
            mm.msgOtherAvatar=weakSelf.chatUser.bigpicurl;
            mm.type =[NSString stringWithFormat:@"%d",MMessageTypeChat];;
        }
    }

    return mm;
}
- (void)fileUploaded:(NSNotification*)notif{

    static int count = 0;
    
    count++;
    
    NSString *fileurl = notif.userInfo[@"fileUrl"];
    NSDictionary *fileAttrs =  [[NSFileManager defaultManager]attributesOfItemAtPath:_filePath error:nil];
    
    if ([_filePath hasSuffix:@".jpg"]) {
        
        if (count >= _uploadImageCount) {
            
            count = 0;
            
            [[NSNotificationCenter defaultCenter]removeObserver:self name:ZTEFileUplodedNotification object:nil];
            
        }
        
        [self sendFileUrlToServer:fileurl contentType:MMessageContentTypePhoto filePath:_filePath fileSize:[NSString stringWithFormat:@"%@",fileAttrs[@"NSFileSize"]]];
    }else{
        [[NSNotificationCenter defaultCenter]removeObserver:self name:ZTEFileUplodedNotification object:nil];
        [self sendFileUrlToServer:fileurl contentType:MMessageContentTypeVideo filePath:_filePath fileSize:[NSString stringWithFormat:@"%@",fileAttrs[@"NSFileSize"]]];
    }
    
    
    
}

- (void)video:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo {
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark 发送文件到MQTT服务器

-(void)sendFileUrlToServer:(NSString*)fileUrl contentType:(MMessageContentType)contentType filePath:(NSString*)filePath fileSize:(NSString*)fileSize{
    
    
    if (fileUrl && fileUrl.length>0) {
        WEAKSELF
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            MMessage *mm =[[MMessage alloc] init];
            mm.msgId =[NSString stringWithUUID];
            mm.srState =[NSString stringWithFormat:@"%d",MMessageSRStateSending];
            mm.contenttype =[NSString stringWithFormat:@"%d",contentType];
            mm.msg =[fileUrl lastPathComponent];
            
            mm.keyid =[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
            mm.identity =[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
            mm.username =[[ConfigManager sharedInstance].userDictionary objectForKey:@"name"];
            mm.headpicurl =[[ConfigManager sharedInstance].userDictionary objectForKey:@"bigpicurl"];
            
            mm.modeltype= @"0";
            mm.sendTime =[NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970]*1000];
            mm.bigpicurl= fileUrl;
            if (contentType==MMessageContentTypeVideo) {
                mm.videoPath=filePath;
            }else{
                mm.filePath=filePath;
            }
            
            mm.filelength =fileSize;
            if (self.chatMessage)
            {
                if (!weakSelf.isGroup)
                {
                    if ([[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]]isEqualToString:weakSelf.chatMessage.keyid]) {
                        mm.sessionid =weakSelf.chatMessage.sessionid;
                        mm.sessionname=weakSelf.chatMessage.sessionname;
                    }
                    else
                    {
                        mm.sessionid =weakSelf.chatMessage.keyid;
                        mm.sessionname=weakSelf.chatMessage.username;
                    }
                    mm.type =[NSString stringWithFormat:@"%d",MMessageTypeChat];
                }
                else
                {
                    //判断你是否还属于这个群
                    NSString *string = [NSString stringWithFormat:@"%@",weakSelf.chatMessage.sessionid];
                    string = [string stringByReplacingOccurrencesOfString:@"g" withString:@""];
                    MGroupUser *groupUser =[[[SQLiteManager sharedInstance] getAllOnlyGroups] objectForKey:string];
                    if (!groupUser) {
                        [weakSelf hideBoardWithVoiceBtnSelected:NO];
                        [self.view makeToast:LOCALIZATION(@"Message_notGroup_noMessage")];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        });
                        return ;
                    }
                    //end

                    mm.sessionid =weakSelf.chatMessage.sessionid;
                    mm.sessionname=weakSelf.chatMessage.sessionname;
                    mm.type =[NSString stringWithFormat:@"%d",MMessageTypeGroupChat];
                }
                mm.msgOtherId =mm.sessionid;
                mm.msgOtherName =mm.sessionname;
                mm.msgOtherAvatar=weakSelf.chatMessage.msgOtherAvatar;
            }
            else
            {
                if (weakSelf.isGroup) {
                    
                    //判断你是否还属于这个群
                    MGroupUser *groupUser =[[[SQLiteManager sharedInstance] getAllOnlyGroups] objectForKey:[NSString stringWithFormat:@"%@",weakSelf.chatGroup.groupid]];
                    if (!groupUser) {
                        [weakSelf hideBoardWithVoiceBtnSelected:NO];
                        [self.view makeToast:LOCALIZATION(@"Message_notGroup_noMessage")];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        });
                        return ;
                    }
                    //end
                    
                    mm.sessionid =[NSString stringWithFormat:@"g%@",weakSelf.chatGroup.groupid];
                    mm.sessionname =weakSelf.chatGroup.groupName;
                    mm.msgOtherId =mm.sessionid;
                    mm.msgOtherName =mm.sessionname;
                    mm.type =[NSString stringWithFormat:@"%d",MMessageTypeGroupChat];
                }else{
                    mm.sessionid =weakSelf.chatUser.uid;
                    mm.sessionname=weakSelf.chatUser.uname;
                    mm.msgOtherId =mm.sessionid;
                    mm.msgOtherName =mm.sessionname;
                    mm.msgOtherAvatar=weakSelf.chatUser.bigpicurl;
                    mm.type =[NSString stringWithFormat:@"%d",MMessageTypeChat];;
                    
                }
            }
            
            [[MQTTManager sharedInstance] sendMMessage:mm voiceData:nil notificationName:NOTIFICATION_R_SQL_MESSAGE];
            
            dispatch_async(dispatch_get_main_queue(), ^{
//                weakSelf.inputTextView.text =@"";
                [weakSelf hideBoardWithVoiceBtnSelected:NO];
            });
        });
    }
}


#pragma mark 发送语音到MQTT服务器
-(void)sendAmrDataToServer:(NSData*)amrData duration:(long)duration wavPath:(NSString*)wavPath amrPath:(NSString*)amrPath{
    if (amrData && amrData.length>0) {
        WEAKSELF
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            MMessage *mm =[[MMessage alloc] init];
            mm.msgId =[NSString stringWithUUID];
            mm.srState =[NSString stringWithFormat:@"%d",MMessageSRStateSending];
            mm.contenttype =[NSString stringWithFormat:@"%d",MMessageContentTypeVoice];
            mm.msg = LOCALIZATION(@"Message_Voice");
            mm.keyid =[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
            mm.identity =[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
            mm.username =[[ConfigManager sharedInstance].userDictionary objectForKey:@"name"];
            mm.headpicurl =[[ConfigManager sharedInstance].userDictionary objectForKey:@"bigpicurl"];
            
            mm.modeltype= @"0";
            mm.sendTime =[NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970]*1000];
            mm.wavPath =wavPath;
            mm.amrPath =amrPath;
            mm.voicelength =[NSString stringWithFormat:@"%ld",duration];
            if (self.chatMessage)
            {
                if (!weakSelf.isGroup)
                {
                    if ([[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]] isEqualToString:weakSelf.chatMessage.keyid]) {
                        mm.sessionid =weakSelf.chatMessage.sessionid;
                        mm.sessionname=weakSelf.chatMessage.sessionname;
                    }
                    else
                    {
                        mm.sessionid =weakSelf.chatMessage.keyid;
                        mm.sessionname=weakSelf.chatMessage.username;
                    }
                    mm.type =[NSString stringWithFormat:@"%d",MMessageTypeChat];
                }
                else
                {
                    //判断你是否还属于这个群
                    NSString *string = [NSString stringWithFormat:@"%@",weakSelf.chatMessage.sessionid];
                    string = [string stringByReplacingOccurrencesOfString:@"g" withString:@""];
                    MGroupUser *groupUser =[[[SQLiteManager sharedInstance] getAllOnlyGroups] objectForKey:string];
                    if (!groupUser) {
                        [weakSelf hideBoardWithVoiceBtnSelected:NO];
                        [self.view makeToast:LOCALIZATION(@"Message_notGroup_noMessage")];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        });
                        return ;
                    }
                    //end

                    mm.sessionid =weakSelf.chatMessage.sessionid;
                    mm.sessionname=weakSelf.chatMessage.sessionname;
                    mm.type =[NSString stringWithFormat:@"%d",MMessageTypeGroupChat];
                }
                mm.msgOtherId =mm.sessionid;
                mm.msgOtherName =mm.sessionname;
                mm.msgOtherAvatar=weakSelf.chatMessage.msgOtherAvatar;
            }
            else
            {
                if (weakSelf.isGroup) {
                    
                    //判断你是否还属于这个群
                    MGroupUser *groupUser =[[[SQLiteManager sharedInstance] getAllOnlyGroups] objectForKey:[NSString stringWithFormat:@"%@",weakSelf.chatGroup.groupid]];
                    if (!groupUser) {
                        [weakSelf hideBoardWithVoiceBtnSelected:NO];
                        [self.view makeToast:LOCALIZATION(@"Message_notGroup_noMessage")];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        });
                        return ;
                    }
                    //end

                    mm.sessionid =[NSString stringWithFormat:@"g%@",weakSelf.chatGroup.groupid];
                    mm.sessionname =weakSelf.chatGroup.groupName;
                    mm.msgOtherId =mm.sessionid;
                    mm.msgOtherName =mm.sessionname;
                    mm.type =[NSString stringWithFormat:@"%d",MMessageTypeGroupChat];
                }else{
                    mm.sessionid =weakSelf.chatUser.uid;
                    mm.sessionname=weakSelf.chatUser.uname;
                    mm.msgOtherId =mm.sessionid;
                    mm.msgOtherName =mm.sessionname;
                    mm.msgOtherAvatar=weakSelf.chatUser.bigpicurl;
                    mm.type =[NSString stringWithFormat:@"%d",MMessageTypeChat];;
                    
                }
            }
            [[MQTTManager sharedInstance] sendMMessage:mm voiceData:amrData notificationName:NOTIFICATION_R_SQL_MESSAGE];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.inputTextView.text =@"";
                [weakSelf hideBoardWithVoiceBtnSelected:NO];
            });
        });

    }
    
}

#pragma mark AudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    
    if (flag) {
        
//        self.endRecordDate =[NSDate date];
        
        NSString *recordName =[[[recorder.url absoluteString] lastPathComponent] stringByDeletingPathExtension];
        NSString *amrPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.amr",recordName]];
        
        NSString *wavPath =[[NSString stringWithFormat:@"%@/%@",APPCachesDirectory,@"tmp/chatVoice/"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",recordName]];
        
        [OpenCoreAmrManager wavToAmr:wavPath amrSavePath:amrPath];
        _amrPath = amrPath;
        _wavPath = wavPath;
        
    }else{
        
    }
}


- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{
    NSLog(@"audioRecorderEncodeErrorDidOccur");
}

#pragma mark  AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (flag) {
        voiceAnimationRow = -1;
        [self.audioPlayer stop];
    }
}


- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
}


- (IBAction)holdBtnTouchDown:(id)sender{
    [lastAnimationImageView stopAnimating];

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
	AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    
    NSDictionary *recordSettings = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithFloat: 16000.0],AVSampleRateKey,[NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,[NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,[NSNumber numberWithInt: 1], AVNumberOfChannelsKey,nil];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",APPCachesDirectory,@"tmp/chatVoice"]])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",APPCachesDirectory,@"tmp/chatVoice"] withIntermediateDirectories:YES attributes:nil error:nil];
    }

    NSURL *recordUrl = [NSURL fileURLWithPath:[[NSString stringWithFormat:@"%@/%@",APPCachesDirectory,@"tmp/chatVoice/"] stringByAppendingPathComponent: [NSString stringWithFormat:@"%lld.wav",(long long)[[NSDate date] timeIntervalSince1970]*1000]]];
    
    NSError *error =nil;
    self.audioRecorder = [[ AVAudioRecorder alloc] initWithURL:recordUrl settings:recordSettings error:&error];
    self.audioRecorder.meteringEnabled = YES;
    self.audioRecorder.delegate =self;
    
    if ([self.audioRecorder prepareToRecord] == YES){
        
        
        self.startRecordDate =[NSDate date];
        [self.audioRecorder record];
        [self voiceTimeBegin];
        NSLog(@"recording");
        [self showVoiceInput];
        
    }else {
        NSLog(@"AVAudioRecorder:%@" , [error localizedDescription]);
    }
    ;
    
}

- (void)voiceTimeBegin
{
    timeSeconds = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    ((UILabel *)[self.voiceView viewWithTag:110]).text = @"0\"";
}

- (void)voiceTimeEnd
{
    if(timer && [timer isValid])
    {
        [timer invalidate];
        timer = nil;
    }
}


- (void)onTimer {
    [self updateLabel];
}


-(void)updateLabel {
    timeSeconds ++;
    NSLog(@"update label and time seconds is %d",timeSeconds);
    ((UILabel *)[self.voiceView viewWithTag:110]).text = [NSString stringWithFormat:@"%2d\"", timeSeconds];
    if(timeSeconds >= 60)
    {
        justFinishRecord = YES;
        [self microphoneStop];
    }
}

-(void)showRecordingHud{
    self.recordingHud = [[MBProgressHUD alloc] initWithView:self.view.window];
	[self.view.window addSubview:self.recordingHud];
	UIImageView *iv =[[UIImageView alloc]initWithImage:[UIImage imageWithFileName:@"voice1.png"]];
	iv.animationImages = [NSArray arrayWithObjects:
                          [UIImage imageWithFileName:@"voice1.png"],
                          [UIImage imageWithFileName:@"voice2.png"],
                          [UIImage imageWithFileName:@"voice3.png"],
                          [UIImage imageWithFileName:@"voice4.png"],
                          [UIImage imageWithFileName:@"voice5.png"],
                          [UIImage imageWithFileName:@"voice6.png"],
                          [UIImage imageWithFileName:@"voice7.png"],
                          [UIImage imageWithFileName:@"voice8.png"],
                          [UIImage imageWithFileName:@"voice9.png"],
                          [UIImage imageWithFileName:@"voice10.png"],nil];
	
	iv.animationDuration = 1;
	iv.animationRepeatCount = 0;
	[iv startAnimating];
	self.recordingHud.customView = iv;
	self.recordingHud.mode = MBProgressHUDModeCustomView;
	self.recordingHud.delegate = self;
	self.recordingHud.labelText = LOCALIZATION(@"Mesage_hand_top");
	[self.recordingHud show:YES];
}





#pragma mark IBActionSheetDelegate
-(void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    NSLog(@"share menu clicked!");
    
    if(actionSheet.tag == PICTIONSHEET)
    {
        if (buttonIndex == 0) {
            //take photo
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:LOCALIZATION(@"Message_TheDeviceNotPhoto") message:@"" cancelButtonTitle:LOCALIZATION(@"Message_CXAlertView_title")];
                alertView.showBlurBackground = YES;
                [alertView show];
                return;
            }
            UIImagePickerController* controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            controller.allowsEditing = NO;
            controller.delegate = self;
            [self presentViewController:controller animated:YES completion:^{
            }];
        }
        else if (buttonIndex == 1) {
            //photo library
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
                QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsMultipleSelection = YES;
                imagePickerController.maximumNumberOfSelection = 6;
                imagePickerController.filterType = QBImagePickerControllerFilterTypePhotos;
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
                [self presentViewController:navigationController animated:YES completion:NULL];
                
//                UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
//                ipc.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
//                ipc.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:ipc.sourceType];
//                ipc.delegate = self;
//                ipc.allowsEditing = NO;
//                [self presentViewController:ipc animated:YES completion:NULL];
            }else{
                CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:LOCALIZATION(@"Message_No_Photos") message:@"" cancelButtonTitle:LOCALIZATION(@"Message_CXAlertView_title")];
                alertView.showBlurBackground = YES;
                [alertView show];
            }
        }
    }
    else if(actionSheet.tag == VIDEOTIONSHEET)
    {
        
        if (buttonIndex == 0) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                
                UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
                ipc.sourceType =  UIImagePickerControllerSourceTypeCamera;
                NSString *requiredMediaType1 = ( NSString *)kUTTypeMovie;
//                NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType1,nil];
                NSArray *arrMediaTypes = @[requiredMediaType1];
                [ipc setMediaTypes:arrMediaTypes];
                ipc.delegate = self;
                ipc.videoQuality = UIImagePickerControllerQualityTypeHigh;
                ipc.videoMaximumDuration = 30;
                ipc.allowsEditing = YES;
                [self presentViewController:ipc animated:YES completion:NULL];
                
            }else{
                CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:LOCALIZATION(@"Message_No_Voide") message:@"" cancelButtonTitle:LOCALIZATION(@"Message_CXAlertView_title")];
                alertView.showBlurBackground = YES;
                [alertView show];
            }
        }
        else if (buttonIndex == 1) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
                
                UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
                ipc.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                NSString *requiredMediaType1 = ( NSString *)kUTTypeMovie;
                NSArray *arrMediaTypes=[NSArray arrayWithObjects: requiredMediaType1,nil];
                [ipc setMediaTypes:arrMediaTypes];
                ipc.delegate = self;
                ipc.videoQuality = UIImagePickerControllerQualityTypeHigh;
                ipc.videoMaximumDuration = 30;
                ipc.allowsEditing = YES;
               // ipc.showsCameraControls = YES;
                [self presentViewController:ipc animated:YES completion:NULL];
            }else{
                CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:LOCALIZATION(@"Message_No_Voide") message:@"" cancelButtonTitle:LOCALIZATION(@"Message_CXAlertView_title")];
                alertView.showBlurBackground = YES;
                [alertView show];
            }

        }

    }
    else if(actionSheet.tag == MAKECALLTIONSHEET)
    {
        if (buttonIndex==0) {
            [self makeVoipCall];
        }else if (buttonIndex==1){
            [self makeVideoCall];
        }
    }
    else if(actionSheet ==self.asSendFailure){
        if (buttonIndex==0) {

            NSData *amrData =nil;
            if ([self.sendFailureMsg.contenttype intValue]==MMessageContentTypeVoice) {
                 amrData= [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.sendFailureMsg.amrPath]];
            }
            if (!self.sendFailureMsg.isResendAfterRemovedFromGroup && !isSelfRemoveFromGroup) {
                
                [[MQTTManager sharedInstance] sendMMessage:self.sendFailureMsg voiceData:amrData notificationName:NOTIFICATION_R_SQL_MESSAGE];
            }else{
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"removed_from_group") isDismissLater:YES];
            }
            
            self.inputTextView.text = @"";
            [self hideBoardWithVoiceBtnSelected:NO];
        }
    }
}


- (void)dismissImagePickerController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - QBImagePickerControllerDelegate

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileUploaded:) name:ZTEFileUplodedNotification object:nil];
    
    _uploadImageCount = assets.count;
    
    [self dismissImagePickerController];
    
    __block int i = 0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for(ALAsset *asset in assets)
        {
            i ++;
           UIImage *originalImage=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            UIImage *neworiginalImage =[originalImage fixOrientation];
            UIImage* masterImage = neworiginalImage;
            if (masterImage) {
                
                _filePath = [NSString stringWithFormat:@"%@/%@%@.jpg",APPCachesDirectory,@"tmp/chatimage/",[Common generateID]];
                
                NSData* masterData = UIImageJPEGRepresentation(masterImage,0.6);
                BOOL success = [masterData writeToFile:_filePath atomically:NO];
                
                sleep(0.9);
//                NSString *str1 = [LOCALIZATION(@"Message_loading") stringByAppendingFormat:@"%d",i];
//                NSString *str2 = [str1 stringByAppendingString:LOCALIZATION(@"Message_zhangPicker")];
                
//                [MMProgressHUD showHUDWithTitle:str2 isDismissLater:NO];
                
                if (success) {
                    NSMutableDictionary * dir=[NSMutableDictionary dictionary];
                    
                    [dir setValue:[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"] forKey:@"token"];
                    
                    NSString *newURL = [ZTEUserProfileTools getUploadFileApiUrl];
                    
                    /**
                     *  上传
                     */
                  //  [ZTEUserProfileTools uploadFileWithURL:newURL postParems:dir FilePath:_filePath FileName:@"image.jpg"];
                    [ZTEUserProfileTools uploadFileWithURL:newURL postParems:dir FilePath:_filePath FileName:@"image.jpg" Asset:nil message:nil];

                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MMProgressHUD updateStatus:LOCALIZATION(@"Message_changchuang_Success")];
                    });
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MMProgressHUD dismissAfterDelay:1.0f];;
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MMProgressHUD updateStatus:LOCALIZATION(@"Message_Loading_filed")];
                        [MMProgressHUD dismissAfterDelay:0.6];;
                    });
                }
            }
        }
    });
}

#pragma mark HPGrowingTextViewDelegate
//HPGrowingTextView  auto scroll to bottom
- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView{
    [growingTextView scrollRangeToVisible:[growingTextView selectedRange]];
}

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView{
    self.btnSwitch.selected =NO;
    self.btnMore.selected =NO;
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (text.length<=0 && range.length==1) {
        if (self.faceBoard.hpInputTextView) {//键盘删除按钮点击
            [self.faceBoard backFace];
            return NO;
        }
    }else if ([text isEqualToString:@"\n"]) {//键盘完成按钮点击
        [self sendTextToServer:nil];
        return NO;
    }else if ([text isEqualToString:@"@"]&&self.isGroup){
        
        [self hideBoardWithVoiceBtnSelected:NO];

        growingTextView.text = [growingTextView.text stringByAppendingString:@"@"];
        //这里需要弹出人员选择
        AllUserViewController *selectUserVC =[[AllUserViewController alloc] init];
        selectUserVC.forSelectUser = YES;
        selectUserVC.groupUser = self.chatGroup;
        
        [selectUserVC setSelectBlock:^(MGroupUser *user){
            growingTextView.text = [growingTextView.text stringByAppendingString:user.uname];
        }];
        GQNavigationController *selectUserVCNav =[[GQNavigationController alloc] initWithRootViewController:selectUserVC];
        [self presentViewController:selectUserVCNav animated:YES completion:^{
        }];
        return YES;
    }

    return YES;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = self.faceSwitchView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	[self.faceSwitchView setFrame:r bottomHeight:m_KeyboardHeight];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height{
    [self tbViewScrollToBottom];
}

#pragma mark 发送文字到MQTT服务器
-(void)sendTextToServer:(MMessage *)message{
    
    NSString *string = self.inputTextView.text;
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (string.length == 0) {
        return;
    }
    
    __block BOOL block_isSelfRemoveFromGroup = isSelfRemoveFromGroup;
    
    if (message) {
        WEAKSELF
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            MMessage *mm =[[MMessage alloc] init];
            mm.msgId =[NSString stringWithUUID];
            mm.srState =[NSString stringWithFormat:@"%d",MMessageSRStateSending];
            mm.contenttype =[NSString stringWithFormat:@"%d",MMessageContentTypeText];
            mm.msg = message.msg;
            mm.keyid =[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
            mm.identity =[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
            mm.username =[[ConfigManager sharedInstance].userDictionary objectForKey:@"name"];
            mm.headpicurl =[[ConfigManager sharedInstance].userDictionary objectForKey:@"bigpicurl"];
            
            mm.modeltype= @"0";
            mm.sendTime =[NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970]*1000];
            if (self.chatMessage)
            {
                if (!weakSelf.isGroup)
                {
                    if ([[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]] isEqualToString:weakSelf.chatMessage.keyid]) {
                        mm.sessionid =weakSelf.chatMessage.sessionid;
                        mm.sessionname=weakSelf.chatMessage.sessionname;
                    }
                    else
                    {
                        mm.sessionid =weakSelf.chatMessage.keyid;
                        mm.sessionname=weakSelf.chatMessage.username;
                    }
                    mm.msgOtherAvatar=weakSelf.chatMessage.msgOtherAvatar;
                    mm.type =[NSString stringWithFormat:@"%d",MMessageTypeChat];
                }
                else
                {
                    NSString *string = [NSString stringWithFormat:@"%@",weakSelf.chatMessage.sessionid];
                    string = [string stringByReplacingOccurrencesOfString:@"g" withString:@""];
                    MGroupUser *groupUser =[[[SQLiteManager sharedInstance] getAllOnlyGroups] objectForKey:string];
                    if (!groupUser) {
                        [weakSelf hideBoardWithVoiceBtnSelected:NO];
                        [self.view makeToast:LOCALIZATION(@"Message_notGroup_noMessage")]; //不在群组内 无法发消息
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        });
                        return ;
                    }
                    //end

                    mm.sessionid =weakSelf.chatMessage.sessionid;
                    mm.sessionname=weakSelf.chatMessage.sessionname;
                    mm.type =[NSString stringWithFormat:@"%d",MMessageTypeGroupChat];
                }
                mm.msgOtherId =mm.sessionid;
                mm.msgOtherName =mm.sessionname;
            }
            else
            {
                if (weakSelf.isGroup) {
                    
                    //判断你是否还属于这个群
                    MGroupUser *groupUser =[[[SQLiteManager sharedInstance] getAllOnlyGroups] objectForKey:[NSString stringWithFormat:@"%@",weakSelf.chatGroup.groupid]];
                    if (!groupUser) {
                        [weakSelf hideBoardWithVoiceBtnSelected:NO];
                        [self.view makeToast:LOCALIZATION(@"Message_notGroup_noMessage")];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        });
                        return ;
                    }
                    //end
                    mm.sessionid =[NSString stringWithFormat:@"g%@",weakSelf.chatGroup.groupid];
                    mm.sessionname =weakSelf.chatGroup.groupName;
                    mm.msgOtherId =mm.sessionid;
                    mm.msgOtherName =mm.sessionname;
                    mm.type =[NSString stringWithFormat:@"%d",MMessageTypeGroupChat];
                }else{
                    mm.sessionid =weakSelf.chatUser.uid;
                    mm.sessionname=weakSelf.chatUser.uname;
                    mm.msgOtherId =mm.sessionid;
                    mm.msgOtherName =mm.sessionname;
                    mm.msgOtherAvatar=weakSelf.chatUser.bigpicurl;
                    mm.type =[NSString stringWithFormat:@"%d",MMessageTypeChat];
                }
            }
            [[MQTTManager sharedInstance] sendMMessage:mm voiceData:nil notificationName:NOTIFICATION_R_SQL_MESSAGE];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.inputTextView.text =@"";
//                [weakSelf hideBoardWithVoiceBtnSelected:NO];
            });
        });
        return;
    }
    //文字消息
    if (self.inputTextView.text &&self.inputTextView.text.length>0) {
        WEAKSELF
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            MMessage *mm =[[MMessage alloc] init];
            mm.msgId =[NSString stringWithUUID];
            mm.srState =[NSString stringWithFormat:@"%d",MMessageSRStateSending];
            mm.contenttype =[NSString stringWithFormat:@"%d",MMessageContentTypeText];
            mm.msg =self.inputTextView.text;
            mm.keyid =[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
            mm.identity =[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
            mm.username =[[ConfigManager sharedInstance].userDictionary objectForKey:@"name"];
            mm.headpicurl =[[ConfigManager sharedInstance].userDictionary objectForKey:@"bigpicurl"];
            
            mm.modeltype= @"0";
            mm.sendTime =[NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970]*1000];
            if (self.chatMessage)
            {
                if (!weakSelf.isGroup)
                {
                    if ([[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]] isEqualToString:weakSelf.chatMessage.keyid]) {
                        mm.sessionid =weakSelf.chatMessage.sessionid;
                        mm.sessionname=weakSelf.chatMessage.sessionname;
                    }
                    else{
                        mm.sessionid =weakSelf.chatMessage.keyid;
                        mm.sessionname=weakSelf.chatMessage.username;
                    }
                    mm.type =[NSString stringWithFormat:@"%d",MMessageTypeChat];
                }
                else
                {
                    
                    //判断你是否还属于这个群
                    MGroupUser *groupUser ;
                    if (weakSelf.chatGroup.groupid) {
                        groupUser =[[[SQLiteManager sharedInstance] getAllOnlyGroups] objectForKey:weakSelf.chatGroup.groupid];
                    }else{
                        groupUser = [[[SQLiteManager sharedInstance] getAllOnlyGroups] objectForKey:[weakSelf.chatMessage.sessionid substringFromIndex:1]];
                    }
                    
                    if (!groupUser) {
                       
                        mm.srState =[NSString stringWithFormat:@"%d",MMessageSRStateSendFailed];
                        [[SQLiteManager sharedInstance] updateMessageSendStateByMsgId:mm.msgId isSendSuccess:NO notificationName:NOTIFICATION_U_SQL_MESSAGE_SENDSTATE];
                        
                        block_isSelfRemoveFromGroup = YES;
                        mm.isResendAfterRemovedFromGroup = YES;
                    }
                    
                    mm.sessionid =weakSelf.chatMessage.sessionid;
                    mm.sessionname=weakSelf.chatMessage.sessionname;
                    mm.type =[NSString stringWithFormat:@"%d",MMessageTypeGroupChat];
                }
                mm.msgOtherId =mm.sessionid;
                mm.msgOtherName =mm.sessionname;
                mm.msgOtherAvatar=weakSelf.chatMessage.msgOtherAvatar;
            }
            else
            {
                if (weakSelf.isGroup) {
                    
                    //判断你是否还属于这个群
                    MGroupUser *groupUser;
                    
                    if (weakSelf.chatGroup.groupid) {
                        groupUser =[[[SQLiteManager sharedInstance] getAllOnlyGroups] objectForKey:weakSelf.chatGroup.groupid];
                    }else{
                        groupUser = [[[SQLiteManager sharedInstance] getAllOnlyGroups] objectForKey:[weakSelf.chatMessage.sessionid substringFromIndex:1]];
                    }
                    
                    if (!groupUser) {
                        
                        mm.srState =[NSString stringWithFormat:@"%d",MMessageSRStateSendFailed];
                        [[SQLiteManager sharedInstance] updateMessageSendStateByMsgId:mm.msgId isSendSuccess:NO notificationName:NOTIFICATION_U_SQL_MESSAGE_SENDSTATE];
                        
                        block_isSelfRemoveFromGroup = YES;
                        mm.isResendAfterRemovedFromGroup = YES;
                    }
                    
                    mm.sessionid =[NSString stringWithFormat:@"g%@",weakSelf.chatGroup.groupid];
                    mm.sessionname =weakSelf.chatGroup.groupName;
                    mm.msgOtherId =mm.sessionid;
                    mm.msgOtherName =mm.sessionname;
                    mm.type =[NSString stringWithFormat:@"%d",MMessageTypeGroupChat];
                }else{
                    mm.sessionid =weakSelf.chatUser.uid;
                    mm.sessionname=weakSelf.chatUser.uname;
                    mm.msgOtherId =mm.sessionid;
                    mm.msgOtherName =mm.sessionname;
                    mm.msgOtherAvatar=weakSelf.chatUser.bigpicurl;
                    mm.type =[NSString stringWithFormat:@"%d",MMessageTypeChat];
                }
            }
            [mm handleFaceMap:weakSelf.faceMap cssSheet:weakSelf.cssSheet];
            
            if (!isSelfRemoveFromGroup && !mm.isResendAfterRemovedFromGroup) {
                [[MQTTManager sharedInstance] sendMMessage:mm voiceData:nil notificationName:nil];
            }
            
            //发送文字直接刷新tableview
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.inputTextView.text =@"";
//                [weakSelf hideBoardWithVoiceBtnSelected:NO];
                if (!_isForward) {
                   [weakSelf.messageArray addObject:mm];
                }
                [weakSelf.tbView reloadData];
                [weakSelf tbViewScrollToBottom];
            });
        });
    }else{
        return;
    }

}



#pragma mark FaceBoardDelegate
//发送表情


-(void)sendBtnClickedInFaceBoard{
    
    [self sendTextToServer:nil];
    
}




#pragma mark UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.isDragging =YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.isDragging =NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)ascrollView
{
    if (ascrollView ==self.tbView) {
        if (self.isDragging) {
            [self hideBoardWithVoiceBtnSelected:self.btnVoice.selected];
            
        }
    }
}


#pragma mark GQMessageToolViewCellDelegate



#pragma mark UITableViewDataSource UITableViewDelegate






#pragma mark - QLPreviewControllerDataSource

// Returns the number of items that the preview controller should preview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{
    //    NSInteger numToPreview = 0;
    //
    //	numToPreview = [self.dirArray count];
    //
    //    return numToPreview;
    return 1;
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller
{
    // if the preview dismissed (done button touched), use this method to post-process previews
}

// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
    [previewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"click.png"] forBarMetrics:UIBarMetricsDefault];
    
    NSURL *fileURL = nil;
    NSIndexPath *selectedIndexPath = [self.tbView indexPathForSelectedRow];
    MMessage *mm =  [_messageArray objectAtIndex:selectedIndexPath.row];

    fileURL = [NSURL fileURLWithPath:mm.filePath];
    return fileURL;
}

#pragma mark Microphone

- (void)resetMicrophoneRadialMenu
{
    [self.microphoneRadialMenu setItem:self.microphoneRecordingStopAction forLocation:MTZRadialMenuLocationCenter];
}

- (void)microphoneCancel
{
    NSLog(@"Microphone: Cancel");
    
    // TODO: Stop Recording.
    if(self.audioRecorder.isRecording)
    {
        [self.audioRecorder pause];
    }
    [self.microphoneRadialMenu dismissMenuAnimated:YES];
    [self.audioRecorder deleteRecording];
    _amrPath = nil;
}

- (void)microphoneStop
{
    NSLog(@"Microphone: Stop");
    // The camera is no longer recording.
    self.microphoneRecording = NO;
    
    [self.microphoneRadialMenu setItem:self.microphoneRecordingPlaybackPlayAction forLocation:MTZRadialMenuLocationCenter];
    [self.audioRecorder stop];
    
    [self voiceTimeEnd];
}
//发送录音
- (void)microphoneRecordingSend
{
    //考虑向上滑动发出，加上判断
    if(timer && [timer isValid]) {
        [self microphoneStop];
    }
    
    voiceAnimationRow = -1;
    [lastAnimationImageView stopAnimating];
    
    NSLog(@"Microphone: Sending Recording");

    
    
    [self audioRecorderDidFinishRecording:self.audioRecorder successfully:YES];
    
    [self.microphoneRadialMenu dismissMenuAnimated:YES];
    
    if (_amrPath) {

//        原先拿录音的开始时间和结束时间进行比较，但是停止录音的结束时间不一定是发送语音的结束时间  modify by qinjw
//        if ([self.endRecordDate timeIntervalSinceDate:self.startRecordDate]>1) {
        if (timeSeconds >= 1) {
            NSData *amrData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:_amrPath]];
            [self sendAmrDataToServer:amrData duration:timeSeconds wavPath:_wavPath amrPath:_amrPath];
        }
        else
        {
            [self.view makeToast:LOCALIZATION(@"Message_talkShort")];
        }

        _amrPath = nil;
    }
    else
    {
        [self.audioRecorder deleteRecording];
    }

}

- (void)microphoneRecordingPlaybackPlay
{
    if(justFinishRecord)
    {
        justFinishRecord = NO;
        return;
    }
    NSLog(@"Microphone: Play");
    
    if (_amrPath) {
        [self.microphoneRadialMenu setItem:self.microphoneRecordingPlaybackPauseAction forLocation:MTZRadialMenuLocationCenter];
        voiceAnimationRow = -1;

        [self.audioPlayer stop];
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        NSError *error =nil;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath:_wavPath] error:&error];
        self.audioPlayer.numberOfLoops = 0;
        self.audioPlayer.delegate =self;
        [self.audioPlayer play];
    }
    else{
        [self.microphoneRadialMenu setItem:self.microphoneRecordingPlaybackPlayAction forLocation:MTZRadialMenuLocationCenter];
    }

}

- (void)microphoneRecordingPlaybackPause
{
    NSLog(@"Microphone: Pause");
    [self.audioPlayer pause];
    [self.microphoneRadialMenu setItem:self.microphoneRecordingPlaybackPlayAction forLocation:MTZRadialMenuLocationCenter];
}


#pragma mark MTZRadialMenuDelegate

- (void)radialMenuWillDisplay:(MTZRadialMenu *)radialMenu
{
    NSLog(@"radialMenuWillDisplay");
    
    [self hideBoardWithVoiceBtnSelected:NO];
    //开始录音
    [self holdBtnTouchDown:nil];
    [self.tbView removeAllGestureRecognizer];

}

- (void)radialMenuDidDisplay:(MTZRadialMenu *)radialMenu
{
    NSLog(@"radialMenuDidDisplay");

//  [self holdBtnTouchDown:nil]
}

- (void)radialMenuWillDismiss:(MTZRadialMenu *)radialMenu
{
    NSLog(@"radialMenuWillDismiss");

    [self showNomalInput];
    [self.tbView addLongPressRecognizer];
    [self.tbView addSingleDoubleTapRecognizer];
    [self voiceTimeEnd];
}

- (void)radialMenuDidDismiss:(MTZRadialMenu *)radialMenu
{
    NSLog(@"radialMenuDidDismiss");
   if (radialMenu == self.microphoneRadialMenu) {
        [self resetMicrophoneRadialMenu];
    }
}



#pragma mark --ChatSetting  delegate

-(void)deleteChatSuccess
{
    [self loadDataWithFlag:0];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  tableview滚动到当前查找的消息
 */

- (void)tableViewScrollToMessage:(MMessage*)message{
    
    //消息在数据库中的位置
    int baseId = [[SQLiteManager sharedInstance] getRowIdOfMessage:message.msgId sessionid:message.sessionid];
    
    messageCount = [self getMessageCountWithMessageType:MessageTypeGroup andSessionid:message.sessionid];
    
    int currentCount = self.messageArray.count;
    
    int willLoadCount = _messageLimit -  (messageCount - baseId)%_messageLimit + (messageCount - baseId); //需要加载这么多数据
    //消息在self.messageArray中的位置
    int rowid = [self getMessageRowid:message];
    
    if (currentCount < messageCount) {
        
        self.messageArray =  [[SQLiteManager sharedInstance]getGroupMessagesWithSessionId:message.sessionid faceMap:self.faceMap cssSheet:self.cssSheet offset:(messageCount - willLoadCount) limit:-1];
        
        loadCount = willLoadCount/_messageLimit + 1;
        
        rowid = [self getMessageRowid:message];
        
        if (messageCount - willLoadCount > _messageLimit) {
            messageOffset = messageCount - willLoadCount - _messageLimit;
        }else{
            messageOffset = 0;
        }
        
        [self.tbView reloadData];
        
    }
    
    
    [self.tbView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rowid inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    
}

- (int)getMessageRowid:(MMessage*)message{
    
    int rowid = 0;
    
    for (int i = 0 ; i < self.messageArray.count; i++) {
        
        MMessage *msg = self.messageArray[i];
        
        if ([message.msgId isEqualToString:msg.msgId]) {
            
            rowid = i;
            
        }
    }
    
    return rowid;
}

- (void)didClikcedReusltMesssage:(NSNotification*)noti{
    
    MMessage *message = noti.userInfo[@"msg"];
    
    [self tableViewScrollToMessage:message];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 100) {//拨打语音视频通话
        
        if (buttonIndex == 1) {//拨打
            
            if (hangUpRecordType == 1) {
                [self makeVideoCall];
            }else{
                [self makeVoipCall];
            }
            
        }
    }
}



@end
