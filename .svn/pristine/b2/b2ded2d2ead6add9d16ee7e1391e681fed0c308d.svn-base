//
//  FileDetailViewController.m
//  IM
//
//  Created by zuo guoqing on 14-12-15.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "FileDetailViewController.h"

@interface FileDetailViewController ()

@end

@implementation FileDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=NO;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
}

-(void)setupViews{
    self.navigationItem.title =@"文件详情";
    
    ILBarButtonItem *leftItem =[ILBarButtonItem barItemWithBackItem:@"返回" target:self action:@selector(clickedLeftItem:)];
    self.navigationItem.leftBarButtonItem =leftItem;
    
    NSString *fileExt =[[self.message.bigpicurl lastPathComponent] pathExtension];
    [self.ivIcon setImage:[Common getIconFromExt:fileExt]];

    [self.btnDownload setBackgroundImage:[UIImage imageWithFileName:@"file_blue_btn@2x.png"] forState:UIControlStateNormal];
    [self.btnDownload setTitle:@"下载" forState:UIControlStateNormal];
    [self.btnDownload setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
//    [self.btnBrowser setBackgroundImage:[UIImage imageWithFileName:@"file_white_btn@2x.png"] forState:UIControlStateNormal];
//    [self.btnBrowser setTitle:@"在线预览" forState:UIControlStateNormal];
//    [self.btnBrowser setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    self.vProgress.progressViewStyle= UIProgressViewStyleDefault;
//    [self.btnStop setBackgroundImage:[UIImage imageWithFileName:@"file_stop_btn@2x.png"] forState:UIControlStateNormal];
    if(_isVideo)
    {
//        self.btnBrowser.hidden = YES;
        self.vProgress.hidden = YES;
        self.btnStop.hidden = YES;
    }
    
    
    self.labName.text =self.message.msg;
    self.labSize.text =[NSString stringWithFormat:@"%.2fMB",[self.message.filelength longLongValue]/1024.0f/1024];

//    WEAKSELF
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        weakSelf.fileState = [weakSelf checkIsDownloaded];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self showProgressView:NO fileState:weakSelf.fileState];
//            [self loadDataWithFileState:weakSelf.fileState];
//        });
//    });
}

-(void)showProgressView:(BOOL)isShow fileState:(FileDetailState)fileState{
    if (isShow) {
        if(!_isVideo)
        {
            self.vProgress.hidden =NO;
            self.btnStop.hidden =NO;
        }
//        self.btnBrowser.hidden =YES;
        self.btnDownload.hidden =YES;
    }else{
        self.vProgress.hidden =YES;
        self.btnStop.hidden =YES;
        if(!_isVideo)
        {
//            self.btnBrowser.hidden =NO;
            self.btnDownload.hidden =NO;
        }
//        if (fileState==FileDetailStateCompleted) {
//            [self.btnDownload setTitle:@"下载完成" forState:UIControlStateNormal];
//        }else if(fileState== FileDetailStateDownload){
//            [self.btnDownload setTitle:@"恢复下载" forState:UIControlStateNormal];
//        }else if(fileState== FileDetailStateNotStart){
//            [self.btnDownload setTitle:@"下载原文件" forState:UIControlStateNormal];
//        }else{
//            [self.btnDownload setTitle:@"文件不存在" forState:UIControlStateNormal];
//        }
//        
     
    }
}



-(void)clickedLeftItem:(id)sender{
    [self showProgressView:NO fileState:self.fileState];
    
    AFHTTPRequestOperation *downloadOperation =[[HTTPClient sharedClient] getOperationByUrl:self.message.bigpicurl];
    if (![downloadOperation isPaused]) {
        [downloadOperation pause];
    }else{
        [self checkIsDownloaded];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadDataWithFileState:(FileDetailState)state{
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (state==FileDetailStateDownload ||state==FileDetailStateNotStart) {
            [HTTPClient asynchronousGetRequest:self.message.bigpicurl successBlock:^(BOOL success, id responseObject, NSString *downloadPath) {
                if (success) {
                    [weakSelf fileDownloadCompletedWithPath:downloadPath];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.fileState =FileDetailStateCompleted;
                        [weakSelf showProgressView:NO fileState:weakSelf.fileState];
                        
                        if (weakSelf.view.window) {
                            weakSelf.recordingHud = [[MBProgressHUD alloc] initWithView:weakSelf.view.window];
                            [weakSelf.view.window addSubview:weakSelf.recordingHud];
                            UIImageView *iv =[[UIImageView alloc]initWithImage:[UIImage imageWithFileName:@"file_finish_btn@2x.png"]];
                            weakSelf.recordingHud.customView = iv;
                            weakSelf.recordingHud.mode = MBProgressHUDModeCustomView;
                            weakSelf.recordingHud.delegate = weakSelf;
                            weakSelf.recordingHud.color =[UIColor whiteColor];
                            weakSelf.recordingHud.labelText = @"下载完成";
                            weakSelf.recordingHud.labelColor = [UIColor blackColor];
                            
                            [weakSelf.recordingHud show:YES];
                            [weakSelf.recordingHud hide:YES afterDelay:2];
                            
                            [weakSelf.btnDownload setTitle:@"已下载" forState:UIControlStateNormal];
                            weakSelf.btnDownload.userInteractionEnabled = NO;
                            [self.navigationController popViewControllerAnimated:YES];
                            
                            [self.btnDownload setTitle:@"完成!" forState:UIControlStateNormal];
                            
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_R_SQL_MESSAGE object:nil];
                            
                        }
                    });
                }
            } failureBlock:^(NSString *description) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"downloadFailure:%@",description);
                    if (weakSelf.fileState !=FileDetailStateDownload) {
                        weakSelf.fileState =FileDetailStateNotStart;
                    }
                });
            } progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.fileState =FileDetailStateDownload;
                    [weakSelf.vProgress setProgress:((CGFloat)totalBytesRead/totalBytesExpectedToRead) animated:YES];
                });
            }];
        }
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fileDownloadCompletedWithPath:(NSString*)downloadPath{
    if ([self.message.contenttype intValue]==MMessageContentTypeVideo) {
        if (!(self.message.videoPath && self.message.videoPath.length>0)) {
            self.message.videoPath =downloadPath;
            [[SQLiteManager sharedInstance] updateMessageVideoPath:downloadPath ByBigpicurl:self.message.bigpicurl];
        }
    }else{
        if (!(self.message.filePath && self.message.filePath.length>0)) {
            self.message.filePath =downloadPath;
            [[SQLiteManager sharedInstance] updateMessageFilePath:downloadPath ByBigpicurl:self.message.bigpicurl];
        }
    }

}

-(FileDetailState)checkIsDownloaded{
    NSString *fileName =[self.message.bigpicurl lastPathComponent];
    if (fileName && fileName.length>0) {
        NSString *downloadPath =[NSString stringWithFormat:@"%@/tmp/download/%@",APPCachesDirectory,fileName];
        NSData *downloadData =[NSData dataWithContentsOfFile:downloadPath];
        if (downloadData){
            self.actualFileLength =[NSNumber numberWithUnsignedInteger:downloadData.length];
            if (downloadData.length ==[self.message.filelength longLongValue]) {
                [self fileDownloadCompletedWithPath:downloadPath];
                return FileDetailStateCompleted;
            }else{
                return FileDetailStateDownload;
            }
        }else{
            return FileDetailStateNotStart;
        }
    }else{
        return FileDetailStateNotExist;
    }
}

- (IBAction)clickedDownloadBtn:(UIButton*)sender {
    
    sender.enabled = NO;
    [self.btnDownload setTitle:@"下载中..." forState:UIControlStateNormal];
    
    self.fileState = [self checkIsDownloaded];
    [self showProgressView:NO fileState:self.fileState];
    [self loadDataWithFileState:self.fileState];

    
//    [self showProgressView:YES fileState:self.fileState];
//    
//    AFHTTPRequestOperation *downloadOperation =[[HTTPClient sharedClient] getOperationByUrl:self.message.bigpicurl];
//    
//    WEAKSELF
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        if (weakSelf.fileState==FileDetailStateDownload) {
//            if ([downloadOperation isPaused]) {
//                [downloadOperation resume];
//            }else{
//                [downloadOperation handleRequestOffset:weakSelf.actualFileLength];
//                [downloadOperation start];
//            }
//        }else if(weakSelf.fileState==FileDetailStateNotStart){
//            [downloadOperation start];
//        }else if (weakSelf.fileState==FileDetailStateCompleted){
//            [downloadOperation cancel];
//        }else{
//            [downloadOperation cancel];
//        }
//        
//    });
}

- (IBAction)clickedBrowserBtn:(id)sender {
    if ([self.message.contenttype intValue]==MMessageContentTypeVideo && self.message.videoPath && self.message.videoPath.length>0) {
        MPMoviePlayerViewController *playerViewController =[[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:self.message.videoPath]];
        [self presentMoviePlayerViewControllerAnimated:playerViewController];
        
        MPMoviePlayerController *player = [playerViewController moviePlayer];
        player.controlStyle = MPMovieControlStyleFullscreen;
        player.shouldAutoplay = YES;
        player.repeatMode = MPMovieRepeatModeNone;
        [player setFullscreen:NO animated:YES];
        player.scalingMode = MPMovieScalingModeAspectFit;
        [player play];
    }else if(self.message.filePath && self.message.filePath.length>0){
        
        if ([QLPreviewController canPreviewItem:[NSURL fileURLWithPath:self.message.filePath]]) {
            QLPreviewController *previewController = [[QLPreviewController alloc] init];
            previewController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            previewController.dataSource = self;
            previewController.delegate = self;
            previewController.currentPreviewItemIndex = 0;
            [[self navigationController] pushViewController:previewController animated:YES];
        }else{
            CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"该文件不支持在线预览" message:@"" cancelButtonTitle:@"确认"];
            alertView.showBlurBackground = YES;
            [alertView show];
        }

    }
}

- (IBAction)clickedStopBtn:(id)sender {
    [self showProgressView:NO fileState:self.fileState];
    
    AFHTTPRequestOperation *downloadOperation =[[HTTPClient sharedClient] getOperationByUrl:self.message.bigpicurl];
    if (![downloadOperation isPaused]) {
        [downloadOperation pause];
    }else{
        [self checkIsDownloaded];
    }
}


#pragma mark QLPreviewControllerDataSource

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    if (self.message.filePath && self.message.filePath.length>0) {
        return [NSURL fileURLWithPath:self.message.filePath];
    }else{
        return nil;
    }
    
}

@end
