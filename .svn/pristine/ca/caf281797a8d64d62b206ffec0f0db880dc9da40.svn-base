//
//  ChatMoreViewController.h
//  IM
//
//  Created by syj on 15/4/28.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
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
#import "ChatMoreFooterView.h"

#define INPUTVIEWHEIGHT 48
@interface ChatMoreViewController :GQBaseViewController<FaceBoardDelegate,HPGrowingTextViewDelegate,ShareMenuBoardDelegate,UITextFieldDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate,UITableViewDelegateLongPress,UITableViewDataSource,GQMessageToolViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate,IBActionSheetDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate,ChatDetailViewDelegate,ChatMoreFooterViewDelegate,MFMessageComposeViewControllerDelegate>{
    CGFloat m_KeyboardHeight;
    CGFloat inputTextHeight;
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
@property (strong, nonatomic) ChatMoreFooterView *footview;
@property (assign, nonatomic) BOOL footViewShow;

@property(nonatomic,strong) MEnterpriseUser *chatUser;
@property(nonatomic,strong) MGroup *chatGroup;
@property(nonatomic,assign) BOOL isGroup;

@property (strong, nonatomic) IBOutlet UITableView *tbView;
@property(nonatomic,strong) NSMutableArray *messageArray;
@property(nonatomic,strong) UINib *nibChat;

@property(nonatomic,strong)DTCSSStylesheet *cssSheet;
@property(nonatomic,strong)NSDictionary *faceMap;

@property(nonatomic,strong)AVAudioRecorder *audioRecorder;
@property(nonatomic,strong)AVAudioPlayer *audioPlayer;
@property(strong,nonatomic) NSDate *startRecordDate;
@property(strong,nonatomic) NSDate *endRecordDate;
@property(strong,nonatomic)MBProgressHUD *recordingHud;

@property(nonatomic,strong) MMessage *sendFailureMsg;

- (IBAction)voipVoiceBtnClicked:(id)sender;
- (IBAction)voipVideoBtnClicked:(id)sender;
- (IBAction)holdBtnTouchDown:(id)sender;
- (IBAction)holdBtnTouchUpInside:(id)sender;
- (IBAction)holdBtnTouchUpOutside:(id)sender;
- (IBAction)voiceBtnClicked:(id)sender;
- (IBAction)switchBtnClicked:(id)sender;
- (IBAction)moreBtnClicked:(id)sender;

@end
