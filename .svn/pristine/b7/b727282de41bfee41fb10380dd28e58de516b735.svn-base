//
//  ChatMoreViewController.m
//  IM
//
//  Created by syj on 15/4/28.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "ChatMoreViewController.h"


#import "AudioConferenceViewController.h"

#import "MTZRadialMenu.h"

@interface ChatMoreViewController () <MTZRadialMenuDelegate,UISearchBarDelegate,UISearchDisplayDelegate,MFMailComposeViewControllerDelegate>
{
    UISearchBar *tmpSearchBar;
    UISearchDisplayController *searchDisplayController;
    NSMutableArray *resultArray;//搜索结果使用
}
@property (nonatomic, getter=isMicrophoneRecording) BOOL microphoneRecording;
@property (strong, nonatomic) MTZRadialMenu *microphoneRadialMenu;
@property (strong, nonatomic) MTZRadialMenuItem *microphoneRecordingStopAction;
@property (strong, nonatomic) MTZRadialMenuItem *microphoneRecordingPlaybackPlayAction;
@property (strong, nonatomic) MTZRadialMenuItem *microphoneRecordingPlaybackPauseAction;
@property (strong, nonatomic) MTZRadialMenuItem *microphoneRecordingSendAction;
@property (nonatomic,copy) NSString *str;
@end

@implementation ChatMoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.footViewShow = YES;
    }
    return self;
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=YES;
    
    //    self.tbView.frame = CGRectMake(self.tbView.frame.origin.x, self.tbView.frame.origin.y, boundsWidth, self.tbView.frame.size.height);
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
    
    [self loadData];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=NO;
    [self hideBoardWithVoiceBtnSelected:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    if(self.audioPlayer)
    {
        [self.audioPlayer stop];
    }
}


//单机隐藏键盘
- (void)touchHiddenKeyBoard:(UIGestureRecognizer *)sender
{
    [self.inputTextView resignFirstResponder];
    [self hideBoardWithVoiceBtnSelected:NO];
}


-(void)hideBoardWithVoiceBtnSelected:(BOOL)voiceBtnSelected{
   }

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self setupViews];
    [self loadData];
}

- (void)initData
{
    resultArray = [[NSMutableArray alloc] init];
}

-(void)clickLeftItem:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)clickRightItem:(id)sender{
    
    
    if (self.isGroup) {
        NSLog(@"进入群聊详情页面");
        GroupChatDetailViewController *detail =[[GroupChatDetailViewController alloc] initWithNibName:@"GroupChatDetailViewController" bundle:[NSBundle mainBundle]];
        detail.group =self.chatGroup;
        
        //        detail.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        ChatDetailViewController *detail =[[ChatDetailViewController alloc] init];
        detail.chatUser =self.chatUser;
        detail.delegate = self;
        //        detail.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}




-(void)setupViews{
    
    
    if (self.isGroup) {
        self.navigationItem.title =self.chatGroup.groupName;
    }else{
        self.navigationItem.title =self.chatUser.uname;
    }
    
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    

    
    
    self.nibChat =[UINib nibWithNibName:@"GQChatCell" bundle:[NSBundle mainBundle]];
    self.tbView = [[UITableView alloc] initWithFrame:CGRectMake(-50, 44, boundsWidth + 50, viewWithNavNoTabbar-INPUTVIEWHEIGHT - 44) style:UITableViewStylePlain];
    [self.tbView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tbView.dataSource = self;
    self.tbView.delegate = self;
    self.tbView.tableFooterView =[[UIView alloc] init];
//    [self.tbView addLongPressRecognizer];
//    [self.tbView addSingleDoubleTapRecognizer];
    [self.tbView setBackgroundColor:[UIColor clearColor]];
    self.tbView.hidden = !self.footViewShow;
    [self.view setBackgroundColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1]];
    [self.view addSubview:self.tbView];
    
    self.faceSwitchView = [[FaceSwitchView alloc] initWithFrame:CGRectMake(0, self.tbView.frame.size.height, boundsWidth, 255)];
//    [self.view addSubview:self.faceSwitchView];
    
    CGRect mainScreenFrame=[[UIScreen mainScreen] bounds];
    self.faceBoard = [[FaceBoard alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(mainScreenFrame), boundsWidth, 216) ];
    self.faceBoard.m_delegate=self;
    [self.view addSubview:self.faceBoard];
    
    self.shareMenuBoard =[[ShareMenuBoard alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(mainScreenFrame), boundsWidth, 216)];
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
    
    self.btnHold.layer.cornerRadius =4.0f;
    self.btnHold.clipsToBounds =YES;
    self.btnHold.layer.borderColor=[UIColor colorWithRGBHex:0x999999].CGColor;
    self.btnHold.layer.borderWidth=1.0f;
    [self.btnHold setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.btnHold setTitle:LOCALIZATION(@"Message_talks") forState:UIControlStateNormal];
    [self.btnHold setTitle:LOCALIZATION(@"Message_talk_Ending") forState:UIControlStateHighlighted];
    
    
    self.inputTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(43 + 35, (INPUTVIEWHEIGHT - 30)/2, boundsWidth - (43 + 35 + 40), 30)];
    [self.faceSwitchView addSubview:self.inputTextView];
    self.inputTextView .isScrollable = NO;
    self.inputTextView .contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.inputTextView .minNumberOfLines = 1;
    self.inputTextView .maxNumberOfLines = 3;
    self.inputTextView .returnKeyType = UIReturnKeyDone; //just as an example
    self.inputTextView .font = [UIFont systemFontOfSize:15.0f];
    self.inputTextView .delegate = self;
    self.inputTextView .internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.inputTextView .backgroundColor = [UIColor whiteColor];
    self.inputTextView .placeholder = @"";
    self.inputTextView .layer.cornerRadius =4.0f;
    self.inputTextView.layer.borderColor =[UIColor grayColor].CGColor;
    self.inputTextView.layer.borderWidth =0.5f;
    
    
    self.faceMap = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"faceMap" ofType:@"plist"]];
    NSData *cssData=[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bubblechat" ofType:@"css"]];
    self.cssSheet=[[DTCSSStylesheet alloc] initWithStyleBlock:[[NSString alloc] initWithData:cssData encoding:NSUTF8StringEncoding]];
    

    
    //    [self.microphoneRadialMenu displayMenu];
    inputTextHeight = self.inputTextView.frame.size.height;
    
    self.footview = [[ChatMoreFooterView alloc] initWithFrame:CGRectMake(0, self.tbView.frame.origin.y + self.tbView.frame.size.height, boundsWidth, boundsHeight - (self.tbView.frame.origin.y + self.tbView.frame.size.height))];
    self.footview.delegate = self;
    [self.view addSubview:self.footview];
    self.footview.hidden = !self.footViewShow;
    
    tmpSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 44)];
    tmpSearchBar.placeholder = LOCALIZATION(@"Message_tmpSearchBar_placeholder");
    tmpSearchBar.delegate = self;
    // 添加 searchbar 到 headerview
    [self.view addSubview:tmpSearchBar];
    UIImage *img = [UIImage createImageWithColor:[UIColor hexChangeFloat:@"f2f2f2"] size:CGSizeMake(boundsWidth, 30)];
    [tmpSearchBar setBackgroundImage:img];
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:tmpSearchBar contentsController:self];
    // searchResultsDataSource 就是 UITableViewDataSource
    searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

-(void)loadData{
    
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (weakSelf.isGroup) {
            if (weakSelf.chatGroup && weakSelf.chatGroup.groupid && [NSString stringWithFormat:@"%@",weakSelf.chatGroup.groupid].length>0) {
                weakSelf.messageArray =[[SQLiteManager sharedInstance] getGroupMessagesWithSessionId:[NSString stringWithFormat:@"g%@",weakSelf.chatGroup.groupid] faceMap:weakSelf.faceMap cssSheet:weakSelf.cssSheet offset:0 limit:-1];//需要修改
            }else{
                return ;
            }
            
        }else{
            if (weakSelf.chatUser && weakSelf.chatUser.uid && [NSString stringWithFormat:@"%@",weakSelf.chatUser.uid].length>0) {
                weakSelf.messageArray =[[SQLiteManager sharedInstance]getPrivateMessagesWithKeyId:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]] sessionId:weakSelf.chatUser.uid faceMap:weakSelf.faceMap cssSheet:weakSelf.cssSheet offset:0 limit:-1];//需要修改
                
            }else{
                return;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(weakSelf.footViewShow == YES)
            {
                [weakSelf.tbView reloadData];
                [weakSelf tbViewScrollToBottom];
            }
        });
    });
    
}

-(void)tbViewScrollToBottom{
    if (self.tbView.contentSize.height > self.tbView.frame.size.height){
        CGPoint offset = CGPointMake(0, self.tbView.contentSize.height - self.tbView.frame.size.height);
        [self.tbView setContentOffset:offset animated:NO];
    }
}

- (IBAction)voipVoiceBtnClicked:(id)sender {
    [self.view makeToast:LOCALIZATION(@"Message_pleaseHond")];
}

- (IBAction)voipVideoBtnClicked:(id)sender {
    [self.view makeToast:LOCALIZATION(@"Message_pleaseHond")];
}


#pragma mark ShareMenuBoardDelegate
-(void)shareMenuClickedWithType:(ShareMenuType)type{
    
    
    switch (type) {
        case ShareMenuTypePhoto:{
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
                
                UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
                ipc.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
                ipc.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:ipc.sourceType];
                ipc.delegate = self;
                ipc.allowsEditing = NO;
                [self presentViewController:ipc animated:YES completion:NULL];
            }else{
                CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:LOCALIZATION(@"Message_No_Photos") message:@"" cancelButtonTitle:LOCALIZATION(@"LoginViewController1_Confirm")];
                alertView.showBlurBackground = YES;
                [alertView show];
            }
            
        }
            break;
        case ShareMenuTypeShoot:{
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                
                UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
                ipc.sourceType =  UIImagePickerControllerSourceTypeCamera;
                ipc.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:ipc.sourceType];
                ipc.delegate = self;
                ipc.videoQuality = UIImagePickerControllerQualityTypeHigh;
                ipc.videoMaximumDuration = 30;
                ipc.allowsEditing = YES;
                [self presentViewController:ipc animated:YES completion:NULL];
            }else{
                CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:LOCALIZATION(@"Message_No_Voide") message:@"" cancelButtonTitle:LOCALIZATION(@"LoginViewController1_Confirm")];
                alertView.showBlurBackground = YES;
                [alertView show];
            }
            
        }
            break;
//        case ShareMenuTypeRecord:{
//            
//        }
//            break;
//        case ShareMenuTypeFile:{
//            //跳到文件列表
//            
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                NSString *filePath =[[NSBundle mainBundle] pathForResource:@"sample.pdf" ofType:nil];
//                NSDictionary *uploadResult=[[FastDFSManager sharedInstance] handleWithActionName:@"upload" localFileName:filePath remoteFilename:nil groupName:nil];
//                if ([[uploadResult objectForKey:@"code"] intValue] ==0) {
//                    [self sendFileUrlToServer:[uploadResult objectForKey:@"masterUrl"] contentType:MMessageContentTypeFile filePath:filePath fileSize:[NSString stringWithFormat:@"%@",[uploadResult objectForKey:@"fileSize"]]];
//                    
//                }else{
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:LOCALIZATION(@"Message_changchuang_File") message:@"" cancelButtonTitle:LOCALIZATION(@"LoginViewController1_Confirm")];
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
            
        }
            break;
        case ShareMenuTypeVideo:{
            
        }
            break;
            
        default:
            break;
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_changchuanging") isDismissLater:NO];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        
        
        if ([mediaType isEqualToString:@"public.image"]){
            UIImage *originalImage=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
            UIImage* masterImage = [Common createThumbnilFromUIImage:originalImage max:1000];
            if (masterImage) {
                NSString* masterFileName = [NSString stringWithFormat:@"%@/%@%@.jpg",APPCachesDirectory,@"tmp/chatimage/",[Common generateID]];
                
                NSData* masterData = UIImageJPEGRepresentation(masterImage,1.0);
                
                BOOL success = [masterData writeToFile:masterFileName atomically:NO];
                if (success) {
                    NSDictionary *uploadResult=[[FastDFSManager sharedInstance] handleWithActionName:@"upload" localFileName:masterFileName remoteFilename:nil groupName:nil];
                    
                    if ([[uploadResult objectForKey:@"code"] intValue] ==0) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MMProgressHUD updateStatus:LOCALIZATION(@"Message_changchuang_Success")];
                        });
                        
                        
                        [self sendFileUrlToServer:[uploadResult objectForKey:@"masterUrl"] contentType:MMessageContentTypePhoto filePath:masterFileName fileSize:[NSString stringWithFormat:@"%@",[uploadResult objectForKey:@"fileSize"]]];
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MMProgressHUD dismissAfterDelay:1.0f];;
                        });
                        
                        
                        
                    }else{
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MMProgressHUD dismiss];
                            CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:LOCALIZATION(@"Message_changchuang_Pfile") message:@"" cancelButtonTitle:LOCALIZATION(@"confirm" )];
                            alertView.showBlurBackground = YES;
                            [alertView show];
                            
                        });
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MMProgressHUD dismiss];
                        CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:LOCALIZATION(@"Message_changchuang_Pfile") message:@"" cancelButtonTitle:LOCALIZATION(@"confirm" )];
                        alertView.showBlurBackground = YES;
                        [alertView show];
                    });
                }
                
            }
            
        }else if ([mediaType isEqualToString:@"public.movie"]){
            
            NSData *videoData = [NSData dataWithContentsOfURL:[info objectForKey:UIImagePickerControllerMediaURL]];
            if (videoData) {
                NSString* videoPath = [NSString stringWithFormat:@"%@/%@%@.MOV",APPCachesDirectory,@"tmp/chatmovie/",[Common generateID]];
                BOOL success = [videoData writeToFile:videoPath atomically:NO];
                
                if (success) {
                    NSDictionary *uploadResult=[[FastDFSManager sharedInstance] handleWithActionName:@"upload" localFileName:videoPath remoteFilename:nil groupName:nil];
                    if ([[uploadResult objectForKey:@"code"] intValue] ==0) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MMProgressHUD updateStatus:LOCALIZATION(@"Message_changchuang_Success")];
                        });
                        
                        
                        [self sendFileUrlToServer:[uploadResult objectForKey:@"masterUrl"] contentType:MMessageContentTypeVideo filePath:videoPath fileSize:[NSString stringWithFormat:@"%@",[uploadResult objectForKey:@"fileSize"]]];
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MMProgressHUD dismissAfterDelay:1.0f];;
                        });
                        
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MMProgressHUD dismiss];
                            CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:LOCALIZATION(@"Message_changchuang_Mfile") message:@"" cancelButtonTitle:LOCALIZATION(@"confirm")];
                            alertView.showBlurBackground = YES;
                            [alertView show];
                            
                        });
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MMProgressHUD dismiss];
                        CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:LOCALIZATION(@"Message_changchuang_Mfile") message:@"" cancelButtonTitle:LOCALIZATION(@"confirm")];
                        alertView.showBlurBackground = YES;
                        [alertView show];
                    });
                }
                
                
            }
            
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [picker dismissViewControllerAnimated:YES completion:NULL];
        });
        
    });
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
            if (weakSelf.isGroup) {
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
            
            [[MQTTManager sharedInstance] sendMMessage:mm voiceData:nil notificationName:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.inputTextView.text =@"";
                [weakSelf hideBoardWithVoiceBtnSelected:NO];
            });
        });
        
    }
    
}




#pragma mark 发送语音到MQTT服务器
-(void)sendAmrDataToServer:(NSData*)amrData duration:(NSTimeInterval)duration wavPath:(NSString*)wavPath amrPath:(NSString*)amrPath{
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
            mm.voicelength =[NSString stringWithFormat:@"%lld",(long long)duration];
            if (weakSelf.isGroup) {
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
            [[MQTTManager sharedInstance] sendMMessage:mm voiceData:amrData notificationName:nil];
            
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
        
        self.endRecordDate =[NSDate date];
        
        NSString *recordName =[[[recorder.url absoluteString] lastPathComponent] stringByDeletingPathExtension];
        NSString *amrPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.amr",recordName]];
        NSString *wavPath =[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",recordName]];
        [OpenCoreAmrManager wavToAmr:wavPath amrSavePath:amrPath];
        NSData *amrData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:amrPath]];
        
        
        [self sendAmrDataToServer:amrData duration:[self.endRecordDate timeIntervalSinceDate:self.startRecordDate] wavPath:wavPath amrPath:amrPath];
        
    }else{
        
    }
}


- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{
    NSLog(@"audioRecorderEncodeErrorDidOccur");
}

#pragma mark  AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (flag) {
        [self.audioPlayer stop];
    }
}


- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
}


- (IBAction)holdBtnTouchDown:(id)sender{
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
    
    NSDictionary *recordSettings = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithFloat: 16000.0],AVSampleRateKey,[NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,[NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,[NSNumber numberWithInt: 1], AVNumberOfChannelsKey,nil];
    
    NSURL *recordUrl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat:@"%lld.wav",(long long)[[NSDate date] timeIntervalSince1970]*1000]]];
    
    NSError *error =nil;
    self.audioRecorder = [[ AVAudioRecorder alloc] initWithURL:recordUrl settings:recordSettings error:&error];
    self.audioRecorder.meteringEnabled = YES;
    self.audioRecorder.delegate =self;
    
    if ([self.audioRecorder prepareToRecord] == YES){
        self.startRecordDate =[NSDate date];
        [self.audioRecorder record];
        NSLog(@"recording");
        [self showRecordingHud];
    }else {
        NSLog(@"AVAudioRecorder:%@" , [error localizedDescription]);
    }
    ;
    
}


-(void)showRecordingHud{
    self.recordingHud = [[MBProgressHUD alloc] initWithView:self.view.window];
    [self.view.window addSubview:self.recordingHud];
    UIImageView *iv =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"voice1.png"]];
    iv.animationImages = [NSArray arrayWithObjects:
                          [UIImage imageNamed:@"voice1.png"],
                          [UIImage imageNamed:@"voice2.png"],
                          [UIImage imageNamed:@"voice3.png"],
                          [UIImage imageNamed:@"voice4.png"],
                          [UIImage imageNamed:@"voice5.png"],
                          [UIImage imageNamed:@"voice6.png"],
                          [UIImage imageNamed:@"voice7.png"],
                          [UIImage imageNamed:@"voice8.png"],
                          [UIImage imageNamed:@"voice9.png"],
                          [UIImage imageNamed:@"voice10.png"],nil];
    
    iv.animationDuration = 1;
    iv.animationRepeatCount = 0;
    [iv startAnimating];
    self.recordingHud.customView = iv;
    self.recordingHud.mode = MBProgressHUDModeCustomView;
    self.recordingHud.delegate = self;
    self.recordingHud.labelText = LOCALIZATION(@"Mesage_hand_top");
    [self.recordingHud show:YES];
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


#pragma mark IBActionSheetDelegate
-(void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(actionSheet ==self.asSendFailure){
        if (buttonIndex==0) {
            NSLog(@"重发消息按钮点击");
            NSData *amrData =nil;
            if ([self.sendFailureMsg.contenttype intValue]==MMessageContentTypeVoice) {
                amrData= [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.sendFailureMsg.amrPath]];
            }
            
            [[MQTTManager sharedInstance] sendMMessage:self.sendFailureMsg voiceData:amrData notificationName:nil];
            self.inputTextView.text =@"";
            [self hideBoardWithVoiceBtnSelected:NO];
        }
    }
}


#pragma mark HPGrowingTextViewDelegate
//HPGrowingTextView  auto scroll to bottom
- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView{
    [growingTextView scrollRangeToVisible:[growingTextView selectedRange]];
    [growingTextView setIsScrollable:NO];
    [growingTextView setIsScrollable:YES];
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
        return NO;
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
    
    CGRect mainScreenFrame=self.view.frame;
    CGFloat deltaY =CGRectGetHeight(mainScreenFrame)-r.size.height;
    
}


- (void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height{
    NSLog(@"didChangeHeight:======%f",height);
    //    [self.tbView setFrame:CGRectMake(0, 44, boundsWidth, self.faceSwitchView.frame.origin.y-44)];
    [self tbViewScrollToBottom];
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

-(void)clickedCopyBtnOnMessageToolView:(MMessage*)message{
    NSLog(@"clickedCopyBtnOnMessageToolView");
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = message.msg;
}

//转发
-(void)clickedForwardBtnOnMessageToolView:(MMessage*)message{
    NSLog(@"clickedForwardBtnOnMessageToolView");
    
    SelectEnterpriseUserViewController *selectUserVC =[[SelectEnterpriseUserViewController alloc] init];
    [selectUserVC setSelectBlock:^(NSArray *responseArray){
        NSLog(@"%@",responseArray);
    }];
    
    
    
    GQNavigationController *selectUserVCNav =[[GQNavigationController alloc] initWithRootViewController:selectUserVC];
    [self presentViewController:selectUserVCNav animated:YES completion:^{
        
    }];
    
    
}
-(void)clickedDeleteBtnOnMessageToolView:(MMessage *)message{

    [[SQLiteManager sharedInstance] deleteMessageByIds:[NSArray arrayWithObject:message.msgId] notificationName:NOTIFICATION_R_SQL_MESSAGE];
    
}
-(void)deleteOneMessageSuccess
{
    NSLog(@"deleteOneMessageSuccess");
    [self loadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_R_SQL_MESSAGE object:nil];
}

-(void)clickedMultipleForwardBtnOnMessageToolView:(MMessage *)message{
    NSLog(@"clickedMultipleForwardBtnOnMessageToolView");

    
    
}

#pragma mark UITableViewDataSource UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == _tbView)
    {
        return [self.messageArray count];
    }
    else
    {
        return [resultArray count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     MMessage *mm;
    if(tableView == _tbView)
    {
        mm =[self.messageArray objectAtIndex:indexPath.row];
    }
    else
    {
        mm =[resultArray objectAtIndex:indexPath.row];
    }
    
    if([mm.type intValue]!= 0 && [mm.type intValue] != 1)
    {
        return 60;
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
    
    NSLog(@"cellForRowAtIndexPath");
    
    GQChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    
    if(!cell){
        cell=(GQChatCell*)[[self.nibChat instantiateWithOwner:self options:nil] objectAtIndex:0];
    }
    
    MMessage *mm;
    if(tableView == _tbView)
    {
        mm =[self.messageArray objectAtIndex:indexPath.row];
    }
    else
    {
        mm =[resultArray objectAtIndex:indexPath.row];
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
    cell.message =mm;

    UIButton *selectButton = (UIButton *)[cell.contentView viewWithTag:indexPath.row+100000];
    if(!selectButton)
    {
        selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectButton setImage:[UIImage imageNamed:@"contact_noselect"] forState:UIControlStateNormal];
        [selectButton setImage:[UIImage imageNamed:@"contact_select"] forState:UIControlStateSelected];
        [selectButton setFrame:CGRectMake(boundsWidth+10, cell.ivAvatar.frame.origin.y+cell.ivAvatar.frame.size.height/2-15, 30, 30)];
        [selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        selectButton.tag = indexPath.row+100000;
        [cell.contentView addSubview:selectButton];
    }
    selectButton.selected = mm.selected;

    return cell;
}

- (void)selectButtonClick:(UIButton *)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    MMessage *mm =[self.messageArray objectAtIndex:button.tag-100000];
    mm.selected = button.selected;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"didSelectRowAtIndexPath");
    
    MMessage *selectMessage = resultArray[indexPath.row];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didClickedReusltMessage" object:nil userInfo:@{@"msg":selectMessage}];
    
    ChatViewController *chatVC = self.navigationController.viewControllers[1];

    chatVC.isFromChatRecode = YES;

    [self.navigationController popToViewController:chatVC animated:NO];
    
}


- (void)tableView:(UITableView *)tableView didRecognizeLongPressOnRowAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point{
    NSLog(@"didRecognizeLongPressOnRowAtIndexPath,%f,%f",point.x,point.y);
    
    UIImageView *testImg = [[UIImageView alloc] initWithFrame:CGRectMake(point.x, point.y, 1,1)];
    testImg.backgroundColor = [UIColor redColor];
    
    GQChatCell *cell =(GQChatCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell addSubview:testImg];
    
    CGRect cellRect =[self.view.window convertRect:[self.tbView rectForRowAtIndexPath:indexPath] fromView:self.view];
    
    CGRect frame = CGRectMake(cell.cvBubble.frame.origin.x, cell.cvBubble.frame.origin.y,cell.cvBubble.boxView.frame.size.width, cell.cvBubble.boxView.frame.size.height);
    
    if (CGRectContainsPoint(frame, point)) {
        NSLog(@"复制，转发，删除，更多");
        
        CGFloat yy =cellRect.origin.y-self.tbView.contentOffset.y-64;
        BOOL isUp =(yy>0)? NO:YES;
        
        CGFloat middleX =CGRectGetMidX(cell.cvBubble.frame);
        CGRect toolViewRect=CGRectZero;
        if (middleX-110<10) {
            toolViewRect =CGRectMake(10, isUp? yy+CGRectGetMaxY(cell.cvBubble.frame)+118: 104+yy , 220, 50);
        }else if(middleX+110>310){
            //删除按钮加三角
            toolViewRect =CGRectMake(70, isUp? yy+CGRectGetMaxY(cell.cvBubble.frame)+118: 104+yy, 220, 50);
            
        }else{
            toolViewRect =CGRectMake(middleX-110, isUp? yy+CGRectGetMaxY(cell.cvBubble.frame)+118: 104+yy, 220, 50);
            
        }
        
        GQMessageToolView *toolView =[[GQMessageToolView alloc] initWithFrame:toolViewRect isUp:isUp middleX:middleX];
        toolView.message =cell.message;
        toolView.delegate =self;
        [toolView showInWindow:self.view.window withFrame:toolViewRect];
        
    }
}


- (void)tableView:(UITableView *)tableView didRecognizeSingleTapOnRowAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point{
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
            user=self.chatUser;
        }
        
        EnterpriseUserCardViewController *userCard =[[EnterpriseUserCardViewController alloc] initWithNibName:@"EnterpriseUserCardViewController" bundle:[NSBundle mainBundle]];
        userCard.user =user;
        //        userCard.hidesBottomBarWhenPushed =YES;
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
            [cell.cvBubble.voiceAnimationView startAnimating];
            
            [self.audioPlayer stop];
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
            
            NSError *error =nil;
            self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath:cell.message.wavPath] error:&error];
            self.audioPlayer.numberOfLoops = 0;
            self.audioPlayer.delegate =self;
            [self.audioPlayer play];
            NSLog(@"playing");
        }
        else if ([cell.message.contenttype intValue]==MMessageContentTypePhoto)
        {
            QLPreviewController *previewController = [[QLPreviewController alloc] init];
            
            previewController.dataSource = self;
            previewController.delegate = self;
            previewController.currentPreviewItemIndex = 0;
            [[self navigationController] pushViewController:previewController animated:YES];
            previewController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        }
        else if ([cell.message.contenttype intValue]==MMessageContentTypeVideo||[cell.message.contenttype intValue]==MMessageContentTypeFile||[cell.message.contenttype intValue]==MMessageContentTypePhoto){
            
            if (cell.message.videoPath && cell.message.videoPath.length>0) {
                MPMoviePlayerViewController *playerViewController =[[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:cell.message.videoPath]];
                [self presentMoviePlayerViewControllerAnimated:playerViewController];
                
                MPMoviePlayerController *player = [playerViewController moviePlayer];
                player.controlStyle = MPMovieControlStyleFullscreen;
                player.shouldAutoplay = YES;
                player.repeatMode = MPMovieRepeatModeNone;
                [player setFullscreen:NO animated:YES];
                player.scalingMode = MPMovieScalingModeAspectFit;
                [player play];
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
    }else if (CGRectContainsPoint(cell.ivSendFailure.frame, point)){
        self.inputTextView.text =@"";
        [self hideBoardWithVoiceBtnSelected:NO];
        
        self.asSendFailure = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(LOCALIZATION(@"discover_cancel"), nil) destructiveButtonTitle:NSLocalizedString(LOCALIZATION(@"Message_agin_message"), nil) otherButtonTitles:nil];
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
//        //        userCard.hidesBottomBarWhenPushed =YES;
//        [self.navigationController pushViewController:userCard animated:YES];
//    }else if (CGRectContainsPoint(cell.cvBubble.frame, point)){
//        NSLog(@"双击cvBubble");
//    }
}

-(CGFloat)calcCellHeight:(MMessage*)mm{
    CGFloat cellHeight =44.0f;
    switch ([mm.contenttype intValue]) {
        case MMessageContentTypeText:{
            CGSize textSize=[FaceHelper calcShufflingLabelRect:mm.msg font:[UIFont systemFontOfSize:14.0f] maxWidth:MAXWIDTH lineHeight:20.0f imageWidth:20.0f];
            
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
    
    if ([mm.type integerValue] == MMessageTypeGroupChat) {
        return cellHeight + 20;
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
                                [weakSelf.tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    
    [self.microphoneRadialMenu dismissMenuAnimated:YES];
}

- (void)microphoneStop
{
    NSLog(@"Microphone: Stop");
    
    // The camera is no longer recording.
    self.microphoneRecording = NO;
    
    [self.microphoneRadialMenu setItem:self.microphoneRecordingPlaybackPlayAction forLocation:MTZRadialMenuLocationCenter];
}

- (void)microphoneRecordingSend
{
    NSLog(@"Microphone: Sending Recording");
    
    // TODO: Stop Recording and send.
    self.microphoneRecording = NO;
    
    [self.microphoneRadialMenu dismissMenuAnimated:YES];
}

- (void)microphoneRecordingPlaybackPlay
{
    NSLog(@"Microphone: Play");
    
    [self.microphoneRadialMenu setItem:self.microphoneRecordingPlaybackPauseAction forLocation:MTZRadialMenuLocationCenter];
}

- (void)microphoneRecordingPlaybackPause
{
    NSLog(@"Microphone: Pause");
    
    [self.microphoneRadialMenu setItem:self.microphoneRecordingPlaybackPlayAction forLocation:MTZRadialMenuLocationCenter];
}


#pragma mark MTZRadialMenuDelegate

- (void)radialMenuWillDisplay:(MTZRadialMenu *)radialMenu
{
    NSLog(@"radialMenuWillDisplay");
    
    //    if (radialMenu == self.cameraRadialMenu) {
    //        radialMenu.tintColor = [UIColor colorWithHue:1.0f/6.0f saturation:1.0f brightness:1.0f alpha:1.0f];
    //    }
}

- (void)radialMenuDidDisplay:(MTZRadialMenu *)radialMenu
{
    NSLog(@"radialMenuDidDisplay");
    //
    //    [self holdBtnTouchDown:nil]
}

- (void)radialMenuWillDismiss:(MTZRadialMenu *)radialMenu
{
    NSLog(@"radialMenuWillDismiss");
    
    //    if (radialMenu == self.cameraRadialMenu) {
    //        radialMenu.tintColor = self.view.tintColor;
    //    }
}

- (void)radialMenuDidDismiss:(MTZRadialMenu *)radialMenu
{
    NSLog(@"radialMenuDidDismiss");
    
    //    if (radialMenu == self.cameraRadialMenu) {
    //        [self resetCameraRadialMenu];
    if (radialMenu == self.microphoneRadialMenu) {
        [self resetMicrophoneRadialMenu];
    }
}

#pragma mark --ChatMoreFooterViewDelegate

- (void)copyText
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSMutableArray *selecterArray = [NSMutableArray array];
    
    for (int i = 0; i < [self.messageArray count]; i++) {
        MMessage *mm =[self.messageArray objectAtIndex:i];
        if (mm.selected) {
            [selecterArray addObject:mm];
        }
    }
    if([selecterArray count])
    {
        if([selecterArray count] > 1)
        {
            [self.view makeToast:LOCALIZATION(@"Message_onlyCopy_one")];
            return;
        }
        else
        {
            [self.view makeToast:LOCALIZATION(@"Message_copy_Sucessed")];
            MMessage *mm =[selecterArray objectAtIndex:0];
            pasteboard.string = mm.msg;
        }
    }
    else
    {
        [self.view makeToast:LOCALIZATION(@"Message_not_copy_anything")];
    }
}

- (void)sendToOther
{
    NSMutableArray *selecterArray = [NSMutableArray array];
    for (int i = 0; i < [self.messageArray count]; i++) {
        MMessage *mm =[self.messageArray objectAtIndex:i];
        if (mm.selected) {
            [selecterArray addObject:mm];
        }
    }
    if(![selecterArray count])
    {
        [self.view makeToast:LOCALIZATION(@"Message_not_choose")];
        return;
    }

    SelectEnterpriseUserViewController *selectUserVC =[[SelectEnterpriseUserViewController alloc] init];
    [selectUserVC setSelectBlock:^(NSArray *responseArray){
        if(responseArray.count == 0)
        {
            return ;
        }
        ChatViewController *chatVC =[[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:[NSBundle mainBundle]];
        chatVC.chatUser =[responseArray objectAtIndex:0];
        chatVC.isGroup =NO;
        [self.navigationController pushViewController:chatVC animated:YES];
        for (int i = 0; i < [selecterArray count]; i++) {
            MMessage *mm =[selecterArray objectAtIndex:i];
            switch ([mm.contenttype intValue]) {
                case MMessageContentTypeText:
                    [chatVC sendTextToServer:mm];
                    break;
                case MMessageContentTypeFile:
                    
                    break;
                case MMessageContentTypePhoto:
                    
                    break;
                case MMessageContentTypeVoice:
                    
                    break;
                case MMessageContentTypeVideo:
                    
                    break;
                default:
                    break;
            }
        }

    }];
    GQNavigationController *selectUserVCNav =[[GQNavigationController alloc] initWithRootViewController:selectUserVC];
    [self presentViewController:selectUserVCNav animated:YES completion:^{
        
    }];

}

- (void)deleteSelectMessage
{
    NSMutableArray *deleteMs = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.messageArray count]; i++) {
        MMessage *mm =[self.messageArray objectAtIndex:i];
        if (mm.selected) {
            [deleteMs addObject:mm.msgId];
        }
    }
    if ([deleteMs count] > 0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteOneMessageSuccess) name:@"deleteOneMessageSuccess" object:nil];
        [[SQLiteManager sharedInstance] deleteMessageByIds:deleteMs notificationName:@"deleteOneMessageSuccess"];
    }
    else
    {
        [self.view makeToast:LOCALIZATION(@"Message_not_chooseDele")];
    }
}

- (void)emailMessage
{
    
    NSMutableArray *selecterArray = [NSMutableArray array];
    
    for (int i = 0; i < [self.messageArray count]; i++) {
        MMessage *mm =[self.messageArray objectAtIndex:i];
        if (mm.selected) {
            [selecterArray addObject:mm.msg];
        }
    }
    if([selecterArray count] == 0)
    {
        [self.view makeToast:LOCALIZATION(@"Message_not_choose")];
            return;
    }
    else{
        
        self.str = [selecterArray componentsJoinedByString:@"  "];

    }
    
    //MMessage *mm =[selecterArray objectAtIndex:0];
   // MMessage *mm = self.str;

    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposeViewController =[[MFMailComposeViewController alloc] init];
        mailComposeViewController.mailComposeDelegate=self;
        [mailComposeViewController setSubject:@""];                                               //邮件主题//收件人
        //        [mailComposeViewController setCcRecipients:[NSArray array]];                              //抄送
        //        [mailComposeViewController setBccRecipients:[NSArray array]];                             //密送
        [mailComposeViewController setMessageBody:self.str isHTML:NO];                                 //邮件内容
        //self.mailCompose =self.mailComposeViewController;
        [self presentViewController:mailComposeViewController animated:YES completion:nil];
    }
    else
    {
        CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"deviceNOMail", nil) cancelButtonTitle:NSLocalizedString(@"comfirm", nil)];
        alertView.showBlurBackground = YES;
        [alertView show];
        
    }
}


#pragma mark MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
        {
        }
            break;
        case MFMailComposeResultSaved:
        {
        }
            break;
        case MFMailComposeResultSent:
        {
        }
            break;
        case MFMailComposeResultFailed:
        {
            CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"sendMailFailed", nil) cancelButtonTitle:NSLocalizedString(@"comfirm", nil)];
            alertView.showBlurBackground = YES;
            [alertView show];
            
        }
            break;
            
        default:
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UISearchDisplayController delegate
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString];
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText{

    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (id model in self.messageArray) {
        if ([model isKindOfClass:[MMessage class]]) {
            MMessage *mm = model;
            NSRange range = [mm.msg rangeOfString:searchText];
            if(range.location != NSNotFound)
            {
                [arr addObject:mm];
            }
        }
    }
    [resultArray setArray:arr];
}


#pragma mark --ChatSetting  delegate

-(void)deleteChatSuccess
{
    [self loadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
