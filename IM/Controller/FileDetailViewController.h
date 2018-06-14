//
//  FileDetailViewController.h
//  IM
//
//  Created by zuo guoqing on 14-12-15.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GQBaseViewController.h"
#import "MMessage.h"
#import "MBProgressHUD.h"
#import <MediaPlayer/MediaPlayer.h>
#import <QuickLook/QuickLook.h>
#import "Common.h"

typedef NS_ENUM(NSInteger, FileDetailState) {
    FileDetailStateNotExist=0,
    FileDetailStateNotStart = 1,
    FileDetailStateDownload = 2,
    FileDetailStateCompleted=3,
};

@interface FileDetailViewController : GQBaseViewController<MBProgressHUDDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate>
@property(nonatomic,strong)MMessage *message;
@property (weak, nonatomic) IBOutlet UIImageView *ivIcon;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labSize;
@property (weak, nonatomic) IBOutlet UIButton *btnDownload;
@property (weak, nonatomic) IBOutlet UIButton *btnBrowser;
@property (weak, nonatomic) IBOutlet UIProgressView *vProgress;
@property (weak, nonatomic) IBOutlet UIButton *btnStop;
@property(strong,nonatomic)MBProgressHUD *recordingHud;

@property(nonatomic) FileDetailState fileState;
@property(nonatomic,strong) NSNumber *actualFileLength;

@property(nonatomic,assign) BOOL isVideo;//是否是视频


- (IBAction)clickedDownloadBtn:(id)sender;
- (IBAction)clickedBrowserBtn:(id)sender;
- (IBAction)clickedStopBtn:(id)sender;


@end
