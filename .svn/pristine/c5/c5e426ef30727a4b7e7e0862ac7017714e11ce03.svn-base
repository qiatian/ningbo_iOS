//
//  ChatViewController.h
//  IM
//
//  Created by zuo guoqing on 14-11-25.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GQBaseViewController.h"
#import "FaceBoard.h"
#import "ShareMenuBoard.h"
#import "FaceSwitchView.h"
#import "HPGrowingTextView.h"
#import "MEnterpriseUser.h"
#import "MGroup.h"
#import "MQTTManager.h"
#import <AVFoundation/AVFoundation.h>
#import "OpenCoreAmrManager.h"
#import "GQChatCell.h"
#import "GroupChatDetailViewController.h"
#import "UITableView+LongPress.h"
#import "EnterpriseUserCardViewController.h"
#import "GQMessageToolView.h"
#import "ILBarButtonItem.h"
#import <MediaPlayer/MediaPlayer.h>
#import "FileDetailViewController.h"
#import "MBProgressHUD.h"
#import "IBActionSheet.h"
#import "Toast+UIView.h"
#import "ChatDetailViewController.h"
#import "ChatMoreViewController.h"

#define INPUTVIEWHEIGHT 48

@interface ChatViewController : GQBaseViewController<FaceBoardDelegate,HPGrowingTextViewDelegate,ShareMenuBoardDelegate,UITextFieldDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate,UITableViewDelegateLongPress,UITableViewDataSource,GQMessageToolViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate,IBActionSheetDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate,ChatDetailViewDelegate,GroupChatDetailViewDelegate>{
    CGFloat m_KeyboardHeight;
    CGFloat inputTextHeight;
    NSTimer *timer; //计时器
    int timeSeconds;
    BOOL sendVoice;
}

@property(nonatomic,strong) IBActionSheet *asSendFailure;
@property(nonatomic,assign) BOOL isDragging;
@property (strong, nonatomic) FaceSwitchView *faceSwitchView;
@property (strong, nonatomic) HPGrowingTextView *inputTextView;
@property (strong, nonatomic) UIButton *btnVoice;
@property (strong, nonatomic) UIButton *btnSwitch;
@property (strong, nonatomic) UIButton *btnMore;
@property (strong, nonatomic) UIButton *btnHold;

@property (strong, nonatomic) FaceBoard *faceBoard;
@property (strong, nonatomic) ShareMenuBoard *shareMenuBoard;
@property(nonatomic,strong) MEnterpriseUser *chatUser;
@property(nonatomic,strong) MGroup *chatGroup;
@property(nonatomic,strong) MMessage *chatMessage;
@property(nonatomic,assign) BOOL isGroup;

@property (strong, nonatomic) IBOutlet UITableView *tbView;
@property(nonatomic,strong) NSMutableArray *messageArray;
@property(nonatomic,strong) UINib *nibChat;

@property(nonatomic,strong)DTCSSStylesheet *cssSheet;
@property(nonatomic,strong)NSDictionary *faceMap;

@property(nonatomic,strong)AVAudioRecorder *audioRecorder;
@property(nonatomic,strong)AVAudioPlayer *audioPlayer;
@property(strong,nonatomic) NSDate *startRecordDate;
//@property(strong,nonatomic) NSDate *endRecordDate;
@property(strong,nonatomic)MBProgressHUD *recordingHud;

@property(nonatomic,strong) MMessage *sendFailureMsg;

@property (nonatomic, assign) BOOL isForward;
@property (nonatomic, copy) NSString *forwardMsg;//转发的文字
@property (nonatomic, copy) NSString *forwardFilePath;//转发的文件路径
@property (nonatomic, copy) NSString *forwardAmrPath;
@property (nonatomic, copy) NSString *forwardWavPath;
@property (nonatomic, copy) NSString *forwardVoiceLength;

@property (nonatomic, assign) BOOL isFromTempGroup;//从临时群组进入
@property (nonatomic, assign) BOOL isFromChatRecode;//从查找聊天记录进入

@property (nonatomic,assign)  BOOL isClickedeleteBtn;//删除按钮是否被点击
@property (nonatomic,assign)  int  deleteCell;       //删除了哪一行

- (IBAction)voipVoiceBtnClicked:(id)sender;
- (IBAction)voipVideoBtnClicked:(id)sender;
- (IBAction)holdBtnTouchDown:(id)sender;
- (IBAction)holdBtnTouchUpInside:(id)sender;
- (IBAction)holdBtnTouchUpOutside:(id)sender;
- (IBAction)voiceBtnClicked:(id)sender;
- (IBAction)switchBtnClicked:(id)sender;
- (IBAction)moreBtnClicked:(id)sender;

-(void)sendTextToServer:(MMessage *)message;


@end
