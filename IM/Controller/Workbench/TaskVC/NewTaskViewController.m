//
//  NewTaskViewController.m
//  IM
//
//  Created by ZteCloud on 15/11/10.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "NewTaskViewController.h"
#import "TableViewCell_receive.h"
#import "ReceiverViewController.h"
#define ORIGINAL_MAX_WIDTH 600.0f

@interface NewTaskViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVAudioPlayerDelegate>
{
    UITableView *mainTable;
    UIScrollView *topScrollView,*belowSV;
    UIView *lineView,*lineView1,*hLineView;
    UIButton *currentBtn,*dateBgAlphaView;
    UIButton *dateBtn,*attachmentBtn,*imgBtn;
    UITextView *taskTextView;
    UILabel *holdLabel;
    BOOL isSpread;
    NSMutableArray *receiveArr;
    UIDatePicker *endPicker;
    NSString *attachmentUrl,*voiceUrl;
    NSDate *finishDate;
    UIButton *voiceBtn,*playBtn,*deleteBtn;
    
    AVAudioSession *tapeSession;
    UIView *myView;
    UIImage *attachmentImg;
    NSString *voiceTime;
    
    BOOL isRecoding;
    CGRect  keyboardRect;
}

@end

@implementation NewTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isRecoding = NO;
    // Do any additional setup after loading the view.
    //监听键盘变化
    [NotiCenter addObserver:self selector:@selector(receiveKeyBoardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [NotiCenter addObserver:self selector:@selector(refreshTable) name:@"RefreshNewTaskTable" object:nil];
    [self handleNavigationBarItem];
    [self setTable];
    [self configureDatePickerView];
    
}
-(void)refreshTable
{
    if (receiveArr.count==0) {
        isSpread=NO;
    }
    
    [mainTable reloadData];
}
-(void)setTable
{
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight-NavBarHeight) style:UITableViewStyleGrouped];
    mainTable.backgroundColor=BGColor;
    mainTable.delegate=self;
    mainTable.dataSource=self;
    mainTable.showsVerticalScrollIndicator=NO;
    [self.view addSubview:mainTable];
    UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight/1.5)];
    [control addTarget:self action:@selector(controlTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    mainTable.tableFooterView = control;
    [mainTable registerNib:[UINib nibWithNibName:@"TableViewCell_receive" bundle:nil] forCellReuseIdentifier:@"Cell0"];
}
//control touch
-(void)controlTouchUpInside{
    [taskTextView resignFirstResponder];
}
-(void)initRecoding
{
    if ([[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending)
    {
        //7.0第一次运行会提示，是否允许使用麦克风
        tapeSession = [AVAudioSession sharedInstance];
        NSError *sessionError;
        //AVAudioSessionCategoryPlayAndRecord用于录音和播放
        [tapeSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if(tapeSession == nil)
            NSLog(@"Error creating session: %@", [sessionError description]);
        else
            [tapeSession setActive:YES error:nil];
    }
    
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    playName = [NSString stringWithFormat:@"%@/play.wav",docDir];
    //录音设置
    recorderSettingsDict =[[NSDictionary alloc] initWithObjectsAndKeys:
                           [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                           [NSNumber numberWithInt:8000.0],AVSampleRateKey,
                           [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                           [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                           [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                           [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                           nil];
}
//判断是否允许使用麦克风7.0新增的方法requestRecordPermission
-(BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                }
                else {
                    bCanRecord = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:nil
                                                    message:LOCALIZATION(@"mic_info")
                                                   delegate:nil
                                          cancelButtonTitle:LOCALIZATION(@"close")
                                          otherButtonTitles:nil] show];
                    });
                }
            }];
        }
    }
    
    return bCanRecord;
}
#pragma mark--------tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 1;
    }
    return 2;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSpread&&indexPath.section==0) {
        return 100;
    }
    return 44;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    else
    {
        for (UIView *subviews in cell.contentView.subviews) {
            if (subviews.tag>10000) {
                [subviews removeFromSuperview];
            }
        }
    }
    NSArray *titles=[NSArray arrayWithObjects:LOCALIZATION(@"finish_time") ,LOCALIZATION(@"accessory_file"), nil];
    
    if (indexPath.section==0)
    {
        TableViewCell_receive *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell0"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        for (UIView *subviews in cell.contentView.subviews) {
            if (subviews.tag>1000) {
                [subviews removeFromSuperview];
            }
        }
        cell.numLabel.text=@"";
        cell.receiveLabel.text=[NSString stringWithFormat:@"%@",LOCALIZATION(@"ReceiverViewController_NavTitle")];
        if (isSpread) {
            cell.numLabel.text = [NSString stringWithFormat:@"%ld%@",(unsigned long)receiveArr.count,LOCALIZATION(@"Message_peopler")];
            
            NSInteger numberOfRow = (boundsWidth-20-52)/59;
            
            for(int i = 0 ; i < numberOfRow+1 ; i ++)
            {
                if(i<[receiveArr count]+1)
                {
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame = CGRectMake(10+59*i, 30, 52, 52);
                    button.layer.masksToBounds = YES;
                    button.layer.cornerRadius = 26;
                    button.tag = 10001+i;
                    [cell.contentView addSubview:button];
                    
                    if(i == [receiveArr count]||i == numberOfRow)
                    {
                        [button setImage:[UIImage imageNamed:@"chat_add_user.png"] forState:UIControlStateNormal];
                        [button addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    else
                    {
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.origin.x, button.frame.size.height+button.frame.origin.y, button.frame.size.width, 100-button.frame.size.height-button.frame.origin.y)];
                        label.textColor = [UIColor grayColor];
                        label.textAlignment = NSTextAlignmentCenter;
                        label.font = [UIFont systemFontOfSize:13.0f];
                        label.backgroundColor = [UIColor clearColor];
                        label.tag=10001+i;
                        
                        MGroupUser *groupUser = [receiveArr objectAtIndex:i];
                        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:groupUser.bigpicurl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"chat_settingHead.png"]];
                        
                        label.text = groupUser.uname;
                        [cell.contentView addSubview:label];
                        [button addTarget:self action:@selector(receiverButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
            }
        }
        return cell;
    }
    if (indexPath.section==1)
    {
        cell.textLabel.text=titles[indexPath.row];
        NSDate *now =[NSDate date];
        if (!finishDate) {
            finishDate=now;
        }
        
//        NSCalendar *calendar=[NSCalendar currentCalendar];
//        NSUInteger unitFlags=NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
//        NSDateComponents *dateComponet=[calendar components:unitFlags fromDate:now];
//        int year=[dateComponet year];
//        int month=[dateComponet month];
//        int day=[dateComponet day];
//        int hour=[dateComponet hour];
//        int minute=[dateComponet minute];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];

        if (indexPath.row==0) {
            UIImageView *arrowImg=[[UIImageView alloc]initWithFrame:CGRectMake(boundsWidth-30, EdgeDis, 30, 30)];
            arrowImg.image=[UIImage imageNamed:@"arrow_come"];
            arrowImg.tag=10001+indexPath.row;
            [cell.contentView addSubview:arrowImg];
            dateBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            dateBtn.frame=CGRectMake(boundsWidth/2-EdgeDis, 0, 150, 44);
//            [dateBtn setTitle:[NSString stringWithFormat:@"%@",[formatter stringFromDate:now]] forState:UIControlStateNormal];
            [dateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [dateBtn addTarget:self action:@selector(showFinishDatePicker) forControlEvents:UIControlEventTouchUpInside];
            dateBtn.titleLabel.font=[UIFont systemFontOfSize:14];
            dateBtn.tag=indexPath.row+10001;
            [cell.contentView addSubview:dateBtn];
            if (finishDate) {
                [dateBtn setTitle:[formatter stringFromDate:finishDate] forState:UIControlStateNormal] ;
            }
            
        }
        if (indexPath.row==1)
        {
            attachmentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            attachmentBtn.frame=CGRectMake(boundsWidth-40, 0, 44, 44);
            [attachmentBtn setImage:[UIImage imageNamed:@"task_attach"] forState:UIControlStateNormal];
            [attachmentBtn setImage:[UIImage imageNamed:@"task_delete"] forState:UIControlStateSelected];
            attachmentBtn.tag=10001+indexPath.row;
            [attachmentBtn addTarget:self action:@selector(attachmentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:attachmentBtn];
            attachmentBtn.imageEdgeInsets=UIEdgeInsetsMake(10, 10, 10, 10);
            imgBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            imgBtn.frame=CGRectMake(attachmentBtn.frame.origin.x-100, 0, 100, 44);
            imgBtn.tag=10001+indexPath.row;
            imgBtn.titleLabel.font=[UIFont systemFontOfSize:13];
            [cell.contentView addSubview:imgBtn];
            imgBtn.imageEdgeInsets=UIEdgeInsetsMake(5, 50, 5, 0);
            if (attachmentImg) {
                attachmentBtn.selected=YES;
                
                [imgBtn setTitle:LOCALIZATION(@"task_upload") forState:UIControlStateNormal];
                [imgBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                imgBtn.imageEdgeInsets=UIEdgeInsetsMake(5, 0, 5, 50);
                [imgBtn setImage:attachmentImg forState:UIControlStateNormal];
            }
        }
        
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        if (receiveArr.count==0) {
            SelectEnterpriseUserViewController *selectUserVC =[[SelectEnterpriseUserViewController alloc] init];
            //    selectUserVC.groupName = groupName;
            selectUserVC.selectGroupUsers = YES;
            [selectUserVC setSelectBlock:^(NSArray *responseArray){
                if (responseArray.count>0) {
                    isSpread=YES;
                    receiveArr=[NSMutableArray arrayWithArray:responseArray];
                    [mainTable reloadData];
                }
            }];
            GQNavigationController *selectUserVCNav =[[GQNavigationController alloc] initWithRootViewController:selectUserVC];
            [self presentViewController:selectUserVCNav animated:YES completion:^{
                
            }];
        }
        else
        {
            ReceiverViewController *rvc=[[ReceiverViewController alloc]init];
            rvc.receiverArr=receiveArr;
            [self.navigationController pushViewController:rvc animated:YES];
        }
        
    }
    if (indexPath.section==1&&indexPath.row==1) {
        
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return EdgeDis;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView=[[UIView alloc]init];
    headerView.backgroundColor=BGColor;
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==1) {
        return boundsHeight-64-44*3-EdgeDis*2;
    }
    return EdgeDis;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==1) {
        if (!myView) {
            myView=[[UIView alloc]init];
            myView.backgroundColor=BGColor;
            topScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, EdgeDis, boundsWidth,44)];
            topScrollView.backgroundColor=[UIColor whiteColor];
            [myView addSubview:topScrollView];
            NSArray *titleArray=[NSArray arrayWithObjects:LOCALIZATION(@"voice"),LOCALIZATION(@"text"), nil];
            NSArray *imgnos=[NSArray arrayWithObjects:@"task_voice",@"task_word", nil];
            NSArray *imgs=[NSArray arrayWithObjects:@"task_voice_s",@"task_word_s", nil];
            for (NSInteger i=0; i<titleArray.count; i++)
            {
                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                btn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:15];
                btn.frame=CGRectMake(i*topScrollView.frame.size.width/titleArray.count,0, topScrollView.frame.size.width/titleArray.count, 44);
                [btn setImage:[UIImage imageNamed:imgnos[i]] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:imgs[i]] forState:UIControlStateSelected];
                [btn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag=i;
                [topScrollView addSubview:btn];
                if (i==0) {
                    currentBtn=btn;
                    btn.selected=YES;
                    lineView=[[UIView alloc]initWithFrame:CGRectMake(btn.frame.origin.x+btn.frame.size.width-1, 0, 0.5, 44)];
                    lineView.backgroundColor=[UIColor grayColor];
                    [btn addSubview:lineView];
                }
                
            }
            lineView1=[[UIView alloc]initWithFrame:CGRectMake(0, 43, boundsWidth, 1)];
            lineView1.backgroundColor=BGColor;
            [topScrollView addSubview:lineView1];
            hLineView=[[UIView alloc]initWithFrame:CGRectMake(0, 43, boundsWidth/2, 1)];
            hLineView.backgroundColor=MainColor;
            [topScrollView addSubview:hLineView];
            
            
            belowSV =[[UIScrollView alloc]initWithFrame:CGRectMake(0, topScrollView.frame.size.height+topScrollView.frame.origin.y, boundsWidth, 170)];
            belowSV.showsHorizontalScrollIndicator=NO;
            belowSV.pagingEnabled=YES;
            belowSV.delegate=self;
            belowSV.backgroundColor=BGColor;
            [myView addSubview:belowSV];
            voiceBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            voiceBtn.bounds=CGRectMake(0, 50, 150, 150);
            voiceBtn.center=CGPointMake(boundsWidth/2, belowSV.frame.size.height/2);
            [voiceBtn setImage:[UIImage imageNamed:@"task_tape"] forState:UIControlStateNormal];
            [voiceBtn setTitle:LOCALIZATION(@"click_record") forState:UIControlStateNormal];
            [voiceBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            voiceBtn.titleLabel.font=[UIFont systemFontOfSize:15];
//            voiceBtn.userInteractionEnabled=NO;
            [voiceBtn addTarget:self action:@selector(voiceBtnClick:) forControlEvents:UIControlEventTouchDown];
            [voiceBtn addTarget:self action:@selector(upBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [voiceBtn addTarget:self action:@selector(upBtnClick:) forControlEvents:UIControlEventTouchCancel];
            [belowSV addSubview:voiceBtn];
            voiceBtn.imageEdgeInsets=UIEdgeInsetsMake(20, 20, 15, 15);
            voiceBtn.titleEdgeInsets=UIEdgeInsetsMake(130, -110, 0, 0);
            playBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            playBtn.hidden=YES;
            playBtn.bounds=CGRectMake(0, 20, 150, 150);
            playBtn.center=CGPointMake(boundsWidth/2, belowSV.frame.size.height/2);
            [playBtn setImage:[UIImage imageNamed:@"task_tape_play"] forState:UIControlStateNormal];
            [playBtn setImage:[UIImage imageNamed:@"task_tape_stop"] forState:UIControlStateSelected];
            [playBtn setTitle:@"" forState:UIControlStateNormal];
            [playBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            playBtn.titleLabel.font=[UIFont systemFontOfSize:15];
            [playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [belowSV addSubview:playBtn];
            
            deleteBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            deleteBtn.frame=CGRectMake(boundsWidth/2-15,belowSV.frame.size.height-30, 30, 30);
            deleteBtn.hidden=YES;
            [deleteBtn setImage:[UIImage imageNamed:@"task_tape_delet"] forState:UIControlStateNormal];
            [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [belowSV addSubview:deleteBtn];
            
            
            taskTextView=[[UITextView alloc]initWithFrame:CGRectMake(belowSV.frame.size.width, 0, belowSV.frame.size.width, belowSV.frame.size.height)];
            taskTextView.backgroundColor=[UIColor whiteColor];
            taskTextView.delegate=self;
            taskTextView.font=[UIFont systemFontOfSize:14];
            [belowSV addSubview:taskTextView];
            holdLabel=[[UILabel alloc]initWithFrame:CGRectMake(2, 5, taskTextView.frame.size.width-5*2, 20)];
            holdLabel.text=LOCALIZATION(@"task_content_nil");
            holdLabel.textColor=RGBColor(195, 195, 195);
            holdLabel.enabled=NO;
            holdLabel.backgroundColor=[UIColor clearColor];
            [taskTextView addSubview:holdLabel];
            belowSV.contentSize=CGSizeMake(boundsWidth*2, belowSV.frame.size.height);
        }
        
        return myView;
    }
    return nil;
}
#pragma mark-------addButtonClick
-(void)addButtonClick:(UIButton*)btn
{
    SelectEnterpriseUserViewController *selectUserVC =[[SelectEnterpriseUserViewController alloc] init];
    NSMutableArray *userIds =[[NSMutableArray alloc] init];
    for (MGroupUser *gu in receiveArr) {
        if (gu && gu.uid && [NSString stringWithFormat:@"%@",gu.uid].length>0) {
            [userIds addObject:gu.uid];
        }
    }
    selectUserVC.disabledContactIds =[NSMutableArray arrayWithArray:userIds];
    [selectUserVC setSelectBlock:^(NSArray *responseArray){
        if (responseArray.count>0) {
            isSpread=YES;
            [receiveArr addObjectsFromArray:responseArray];
            [mainTable reloadData];
        }
    }];
    selectUserVC.selectGroupUsers = YES;
    GQNavigationController *selectUserVCNav =[[GQNavigationController alloc] initWithRootViewController:selectUserVC];
    [self presentViewController:selectUserVCNav animated:YES completion:^{
    }];
    
    
}
#pragma mark----------voiceBtnClick
-(void)voiceBtnClick:(UIButton*)btn
{
    [self initRecoding];
   [voiceBtn setImage:[UIImage imageNamed:@"task_tape_down"] forState:UIControlStateNormal];
    //按下录音
    if ([self canRecord]) {
        
        NSError *error = nil;
        //必须真机上测试,模拟器上可能会崩溃
        recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:playName] settings:recorderSettingsDict error:&error];
        
        if (recorder) {
//            recorder.meteringEnabled = YES;
            [recorder prepareToRecord];
            [recorder peakPowerForChannel:0];
            [recorder record];
//            //启动定时器
//            timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(levelTimer:) userInfo:nil repeats:YES];
            self.startRecordDate=[NSDate date];
            
        } else
        {
            int errorCode = CFSwapInt32HostToBig ([error code]);
            NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
            
        }
    }
}
-(void)upBtnClick:(UIButton*)btn
{
    self.endRecordDate=[NSDate date];
    //松开 结束录音
    
    if ([self.endRecordDate timeIntervalSinceDate:self.startRecordDate]>1) {
        voiceTime=[NSString stringWithFormat:@"%.f",[self.endRecordDate timeIntervalSinceDate:self.startRecordDate]];
        [playBtn setTitle:[NSString stringWithFormat:@"%@''",voiceTime] forState:UIControlStateNormal];
        [self showPlay];
        //录音停止
        [recorder stop];
        recorder = nil;
        //结束定时器
        [timer invalidate];
        timer = nil;
    }
    else
    {
        [self.view makeToast:LOCALIZATION(@"record_time_short")];
        [voiceBtn setImage:[UIImage imageNamed:@"task_tape"] forState:UIControlStateNormal];
    }
}
-(void)playBtnClick:(UIButton*)btn
{
    btn.selected=!btn.selected;
    NSError *playerError;
    //播放
    if (btn.selected) {
       
        player = nil;
//        NSString *testacc=[[NSBundle mainBundle]pathForResource:@"test" ofType:@"aac"];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:playName] error:&playerError];
        
        if (player == nil)
        {
            NSLog(@"ERror creating player: %@", [playerError description]);
        }else{
            [tapeSession setCategory:AVAudioSessionCategoryPlayback error:nil];
            player.delegate=self;
            [player prepareToPlay];
            [player play];
        }
    }
    else
    {
        [player stop];
    }
    
}
#pragma mark-------AVAudioPlayer delegate
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    playBtn.selected=!playBtn.selected;
}
-(void)deleteBtnClick:(UIButton*)btn
{
    playBtn.selected=NO;
    [player stop];
    playName=nil;
    voiceTime=nil;
    [self hiddenPlay];
}
-(void)showPlay
{
    voiceBtn.hidden=YES;
    playBtn.hidden=NO;
    deleteBtn.hidden=NO;
}
-(void)hiddenPlay
{
    voiceBtn.hidden=NO;
    [voiceBtn setImage:[UIImage imageNamed:@"task_tape"] forState:UIControlStateNormal];
    playBtn.hidden=YES;
    deleteBtn.hidden=YES;
}
#pragma mark-----------receiverButtonClick
-(void)receiverButtonClick:(UIButton*)btn
{
    
}
#pragma mark---------attachmentBtnClick
-(void)attachmentBtnClick:(UIButton*)btn
{
    if (!btn.selected) {
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.delegate = self;
        ipc.allowsEditing = NO;
        [self presentViewController:ipc animated:YES completion:NULL];
    }
    else
    {
        btn.selected=NO;
        attachmentUrl=nil;
        attachmentImg=nil;
        [imgBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [imgBtn setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if ([navigationController isKindOfClass:[UIImagePickerController class]]) {
        
        viewController.navigationItem.rightBarButtonItem.width = 10;
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInf
{
    UIImage *newImage = [image scaledToSize:CGSizeMake(25,25) highQuality:YES];
    [MMProgressHUD showHUDWithTitle:[NSString stringWithFormat:@"%@%@",LOCALIZATION(@"accessory_file"),LOCALIZATION(@"committing")] isDismissLater:NO];
    [imgBtn setImage:newImage forState:UIControlStateNormal];
    attachmentImg=newImage;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self uploadImgWithImg:image];
    });
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark-----上传图片
-(void)uploadImgWithImg:(UIImage*)uploadImg
{
    UIImage * newImage = uploadImg;
    // 压缩
    UIImage * tempImage = [self imageByScalingToMaxSize:newImage];
    NSString *fileName = [NSString stringWithFormat:@"%@%@",[ZTEUserProfileTools generateUuidString],@".jpeg"];
    
    NSString *imageFilePath  = [ZTEUserProfileTools saveImage:tempImage WithName:fileName];
    
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    [dic setObject:[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"] forKey:@"token"];
    NSString *apiPrefix = [NSString stringWithFormat:@"%@",ApiPrefix];
    NSRange suffixRange = [apiPrefix rangeOfString:@"zteim4ios"];
    NSString *apiUse = [apiPrefix substringWithRange:NSMakeRange(0, suffixRange.location)];
    NSString *newURL = [NSString stringWithFormat:@"%@interface/genericUploadFile.aspx",apiUse];
    [ZTEUserProfileTools postRequestWithURL:newURL postParems:dic picFilePath:imageFilePath picFileName:fileName withComplete:^(NSDictionary *dic) {
        
        if (dic[@"fileUrl"]) {
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"upload_success") isDismissLater:YES];
             attachmentBtn.selected=YES;
            [imgBtn setTitle:LOCALIZATION(@"task_upload") forState:UIControlStateNormal];
            [imgBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            imgBtn.imageEdgeInsets=UIEdgeInsetsMake(5, 0, 5, 40);
            attachmentUrl = [NSString stringWithFormat:@"%@",dic[@"fileUrl"]];
        }
        else
        {
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"upload_failed") isDismissLater:YES];
        }
    } failureBlock:^(NSString *description) {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"upload_failed") isDismissLater:YES];
    }];
}
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage
{
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}
- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;

        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;

        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;

    [sourceImage drawInRect:thumbnailRect];

    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");

    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Configure DatePickerView
-(void)configureDatePickerView
{
    dateBgAlphaView = [UIButton buttonWithType:UIButtonTypeCustom];
    dateBgAlphaView.frame = self.view.bounds;
    dateBgAlphaView.backgroundColor = [UIColor hexChangeFloat:@"000000" alpha:0.5];
    dateBgAlphaView.alpha = 0;
    [dateBgAlphaView addTarget:self action:@selector(hiddenDatePicker) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:dateBgAlphaView];
    
    endPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, boundsWidth, 200)];
    endPicker.backgroundColor = [UIColor whiteColor];
    endPicker.datePickerMode = UIDatePickerModeDateAndTime;
    endPicker.minimumDate = [[NSDate date] dateByAddingTimeInterval:5*60];
    endPicker.date = [NSDate dateWithTimeIntervalSinceNow:65*60];
    [endPicker addTarget:self action:@selector(endDatePickerChange:) forControlEvents:UIControlEventValueChanged];
    [dateBgAlphaView addSubview:endPicker];
}
-(void)showFinishDatePicker
{
    [self.view endEditing:YES];
    [self.navigationController.view bringSubviewToFront:dateBgAlphaView];
    [UIView animateWithDuration:0.3 animations:^{
        dateBgAlphaView.alpha = 1;
        endPicker.frame = CGRectMake(0, boundsHeight-200, boundsWidth, 300);
    }];
    [self endDatePickerChange:endPicker];
}
-(void)hiddenDatePicker
{
    [UIView animateWithDuration:0.3 animations:^{
        dateBgAlphaView.alpha = 0;
//        startPicker.frame = CGRectMake(0, boundsHeight, boundsWidth, 300);
        endPicker.frame = CGRectMake(0, boundsHeight, boundsWidth, 300);
    }];
}
-(void)endDatePickerChange:(UIDatePicker *)picker
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    [dateBtn setTitle:[formatter stringFromDate:picker.date] forState:UIControlStateNormal] ;
    finishDate=picker.date;
}
#pragma mark----------语音或文字
-(void)topBtnClick:(UIButton *)btn
{
    if (currentBtn==nil)
    {
        btn.selected=YES;
        currentBtn=btn;
    }
    else if (currentBtn!=nil&& currentBtn==btn)
    {
        btn.selected=YES;
    }
    else if(currentBtn!=btn&&currentBtn!=nil)
    {
        currentBtn.selected=NO;
        btn.selected=YES;
        currentBtn=btn;
    }
    if (btn.tag==0) {
        [self.view endEditing:YES];
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    hLineView.frame=CGRectMake(btn.frame.origin.x, btn.frame.size.height-1, btn.frame.size.width, 1);
    belowSV.contentOffset=CGPointMake(btn.tag*boundsWidth, 0);
    [UIView commitAnimations];
    
    
}
#pragma mark-------scrollView Delegate
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    if (scrollView==belowSV)
    {
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        for (UIView *view in topScrollView.subviews) {
            if (view.tag!=currentBtn.tag&&[view isKindOfClass:[UIButton class]]) {
                btn=(UIButton*)[view viewWithTag:view.tag];
            }
            
        }
//        ||(scrollView.contentOffset.x>boundsWidth&&scrollView.contentOffset.x<boundsWidth/2*3)
        if ((scrollView.contentOffset.x>boundsWidth/2&&scrollView.contentOffset.x<boundsWidth)||(scrollView.contentOffset.x<boundsWidth/2&&scrollView.contentOffset.x>0))
        {
            if (currentBtn==btn)
            {
                btn.selected=YES;
            }
            else
            {
                currentBtn.selected=NO;
                btn.selected=YES;
                currentBtn=btn;
            }
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.0];
            hLineView.frame=CGRectMake(currentBtn.frame.origin.x, currentBtn.frame.size.height-1, currentBtn.frame.size.width, 1);
            [UIView commitAnimations];
        }
        
    }
}
#pragma mark 处理导航条
-(void)handleNavigationBarItem{
    self.navigationItem.title = LOCALIZATION(@"create_task");
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    ILBarButtonItem *rigthItem=[ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_save.png"] highlightedImage:[UIImage imageNamed:@"nav_save.png"] target:self action:@selector(clickRightItem:)];
    [self.navigationItem setRightBarButtonItem:rigthItem];
}
-(void)clickLeftItem:(id)sender{
    [player stop];
    [UserDefault removeObjectForKey:@"DeptName"];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark---------新建任务
-(void)clickRightItem:(id)sender{
    UIButton *btn=(UIButton*)sender;
    [self.view endEditing:YES];
    if (receiveArr.count==0) {
        [self.view makeToast:LOCALIZATION(@"newtask_receiver")];
        return;
    }
    if (playName==nil&&[taskTextView.text isEqualToString:@""]) {
        [self.view makeToast:LOCALIZATION(@"choose_voice_text")];
        return;
    }
    if (belowSV.contentOffset.x==0&&playName==nil) {
        [self.view makeToast:LOCALIZATION(@"file_invalid")];
    }
    if (belowSV.contentOffset.x==0&&playName) {
        btn.userInteractionEnabled=NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableDictionary * dic=[NSMutableDictionary dictionary];
            [dic setObject:[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"] forKey:@"token"];
            NSString *apiPrefix = [NSString stringWithFormat:@"%@",ApiPrefix];
            NSRange suffixRange = [apiPrefix rangeOfString:@"zteim4ios"];
            NSString *apiUse = [apiPrefix substringWithRange:NSMakeRange(0, suffixRange.location)];
            NSString *fileURL = [NSString stringWithFormat:@"%@interface/genericUploadFile.aspx",apiUse];
            [ZTEUserProfileTools postRequestWithURL:fileURL postParems:dic picFilePath:playName picFileName:@"play.wav" withComplete:^(NSDictionary *dic) {
//                NSLog(@"%@",dic);
                voiceUrl=dic[@"fileUrl"];
                [self taskAddReqWithBtn:btn];
            } failureBlock:^(NSString *description) {
//                NSLog(@"%@",description);
                btn.userInteractionEnabled=YES;
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"upload_failed_voice") isDismissLater:YES];
            }];
            
        });
    }
    else
    {
        [self taskAddReqWithBtn:btn];
    }
}
-(void)taskAddReqWithBtn:(UIButton*)btn
{
    NSDate *now=[NSDate date];
    NSTimeInterval nowStamp=[now timeIntervalSince1970]*1000;
    NSTimeInterval timeStamp=[finishDate timeIntervalSince1970]*1000;
    if (nowStamp>timeStamp) {
        btn.userInteractionEnabled=YES;
//        @"完成时间应大于手机当前时间"
        [self.view makeToast:LOCALIZATION(@"finishtimeovercurrent")];
        return ;
    }
    WEAKSELF
    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"committing") isDismissLater:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *userArr=[[NSMutableArray alloc]initWithCapacity:0];
        for (MEnterpriseUser *mUser in receiveArr) {
            [userArr addObject:mUser.uid];
        }
        btn.userInteractionEnabled=NO;
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"] forKey:@"token"];
        [parameters setObject:(belowSV.contentOffset.x==0)?@"VOICE":@"TEXT" forKey:@"contentType"];
        [parameters setObject:(belowSV.contentOffset.x==0)?voiceUrl:taskTextView.text forKey:@"content"];
        [parameters setObject:(attachmentUrl)?attachmentUrl:@"" forKey:@"attachmentUrl"];
        [parameters setObject:[NSString stringWithFormat:@"%.0f",timeStamp] forKey:@"finishTime"];
        [parameters setObject:userArr forKey:@"users"];
        [parameters setObject:(belowSV.contentOffset.x==0&&voiceTime)?voiceTime:@"" forKey:@"voiceDuration"];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodTaskAdd] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
//            NSLog(@"%@",msg);
            if(success && [data isKindOfClass:[NSDictionary class]]){
//                NSLog(@"%@",data);
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"create_success") isDismissLater:YES];
                [NotiCenter postNotificationName:@"NewTaskAdd" object:nil];
                [self clickLeftItem:nil];
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD showHUDWithTitle:msg isDismissLater:YES];
                    btn.userInteractionEnabled=YES;
                });
            }
        } failureBlock:^(NSString *description) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"network_failed") isDismissLater:YES];
                btn.userInteractionEnabled=YES;
            });
        }];
    });
    
}
#pragma mark--------//取得键盘变化的通知方法
- (void)receiveKeyBoardFrameChange:(NSNotification *)noti{
    NSValue *value = [noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect;
    [value getValue:&rect];
    keyboardRect=rect;
    [UIView animateWithDuration:[[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue] animations:^{
        
        [UIView setAnimationCurve:[[noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]integerValue]];
//        .frame = CGRectMake(0, rect.origin.y-kTabBarHeight, kScreenW, kTabBarHeight);
//        commentTable.frame = CGRectMake(0, NavBarHeight, kScreenW, commentBg.frame.origin.y-NavBarHeight);
        mainTable.frame = CGRectMake(0, 0, boundsWidth, rect.origin.y);
        
        
    }];
    
    
}
#pragma mark---textView Delegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length==0)
    {
        holdLabel.text= LOCALIZATION(@"task_content_nil");
    }
    else
    {
        holdLabel.text=@"";
        if (textView.text.length > 200)
        {
            textView.text = [textView.text substringToIndex:200];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];

    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:belowSV];
    
    if (CGRectContainsPoint(voiceBtn.frame, point)) {
        
        isRecoding = YES;
        [self voiceBtnClick:nil];
        
    }
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    if (isRecoding) {
        [self upBtnClick:nil];
        isRecoding = NO;
    }
    
}
@end
