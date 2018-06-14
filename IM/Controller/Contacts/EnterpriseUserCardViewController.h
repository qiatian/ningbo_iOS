//
//  EnterpriseUserCardViewController.h
//  IM
//
//  Created by zuo guoqing on 14-10-11.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "GQBaseViewController.h"
#import "MEnterpriseUser.h"
#import "FastDFSManager.h"
#import "GQEnterpriseUserCardCell.h"
#import "IBActionSheet.h"
#import  <MessageUI/MessageUI.h>
#import "Common.h"
#import "GQLoadImageView.h"
#import "HTTPAddress.h"
#import "HTTPClient.h"
#import "ConfigManager.h"
#import "SQLiteManager.h"
#import "UIImage+fixOrientation.h"
#import "ChatViewController.h"
#import "NSString+DTUtilities.h"

@interface EnterpriseUserCardViewController : GQBaseViewController<UITableViewDataSource,UITableViewDelegate,IBActionSheetDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (nonatomic,assign) CGFloat viewWidth;

@property (nonatomic,strong) MEnterpriseUser *user;
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (weak, nonatomic) IBOutlet UIButton *btnVoice;
@property (weak, nonatomic) IBOutlet UIButton *btnVideo;
@property (weak, nonatomic) IBOutlet UIButton *btnChat;
@property(nonatomic,strong) UINib *nibEnterpriseUserCard;
@property(nonatomic,strong) NSMutableArray *userData;
- (IBAction)clickedVoiceBtn:(id)sender;
- (IBAction)clickedVideoBtn:(id)sender;
- (IBAction)clickedChatBtn:(id)sender;
@property(nonatomic,strong) IBActionSheet *asHomeMobile;
@property(nonatomic,strong) IBActionSheet *asMobile;
@property(nonatomic,strong) IBActionSheet *asAvatar;
@property(nonatomic,strong) MFMessageComposeViewController* messageComposeViewController;
@property(nonatomic,strong) MFMailComposeViewController *mailComposeViewController;

@property(nonatomic,strong) GQLoadImageView  *ivAvatar;

//当之传入userIdStr的时候，获取用户信息在加载界面
@property (nonatomic,copy) NSString *userIdStr;


-(void)reloadUserInfoView;

@end
