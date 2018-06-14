//
//  TaskDetailViewController2.m
//  IM
//
//  Created by ZteCloud on 15/11/17.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "TaskDetailViewController2.h"
#import "TableViewCell_taskDetail.h"
#import "TaskReplyListViewController.h"
#import "UserDetailViewController.h"
@interface TaskDetailViewController2 ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate,AVAudioPlayerDelegate>
{
    UITableView *mainTable;
    NSMutableArray *userFinishs,*userUnfinishs,*userConfirm,*userUnConfirm;
    
    
    
    AVAudioSession *tapeSession;
    AVAudioPlayer *voicePlayer;
    UIImageView *voiceImgView;
    BOOL isSuspend;
    CGFloat cellHeight;
}

@end

@implementation TaskDetailViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //监听键盘变化
    [NotiCenter addObserver:self selector:@selector(receiveKeyBoardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];

    userFinishs = [[NSMutableArray alloc]initWithCapacity:0];
    userUnfinishs = [[NSMutableArray alloc]initWithCapacity:0];
    userConfirm = [[NSMutableArray alloc]initWithCapacity:0];
    userUnConfirm = [[NSMutableArray alloc]initWithCapacity:0];
    [self handleNavigationBarItem];
    [self setTableUI];
    @try{
        [self requestTaskQueryWithID:self.taskDetail.taskId];
    }
    @catch(NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }
    
}
-(void)setTableUI
{
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight-NavBarHeight) style:UITableViewStylePlain];
    mainTable.backgroundColor=BGColor;
    mainTable.delegate=self;
    mainTable.dataSource=self;
    //    mainTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTable];
    [mainTable registerNib:[UINib nibWithNibName:@"TableViewCell_taskDetail" bundle:nil] forCellReuseIdentifier:@"Cell01"];
//    [mainTable registerNib:[UINib nibWithNibName:@"TableViewCell_reply" bundle:nil] forCellReuseIdentifier:@"Cell2"];
    [Common setExtraCellLineHidden:mainTable];
}
//取得键盘变化的通知方法
- (void)receiveKeyBoardFrameChange:(NSNotification *)noti{
    NSValue *value = [noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect;
    [value getValue:&rect];
    
    [UIView animateWithDuration:[[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue] animations:^{
        
        [UIView setAnimationCurve:[[noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]integerValue]];
        mainTable.frame = CGRectMake(0, 0, boundsWidth, rect.origin.y);
        
        
    }];
}
#pragma mark---------requestTaskQueryWithID
-(void)requestTaskQueryWithID:(NSString*)taskId
{
//    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"data_loaded") isDismissLater:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"]] forKey:@"token"];
        [parameters setObject:taskId forKey:@"taskId"];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodTaskQuery] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
//            NSLog(@"%@",msg);
            if(success && [data isKindOfClass:[NSDictionary class]]){
//                NSLog(@"%@",data);
//                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"data_loaded") isDismissLater:YES];
                TaskQuery *tq=[[TaskQuery alloc]initWithDictionary:data[@"task"]];
                self.tDetail=tq;
                
                for (NSDictionary *dic in data[@"users"]) {
                    UserTaskModel *userTm=[[UserTaskModel alloc]initWithDictionary:dic];
                    if ([userTm.progress integerValue]!=100) {
                        [userUnfinishs addObject:userTm];
                    }
                    else
                    {
                        [userFinishs addObject:userTm];
                    }
                    if ([userTm.status isEqualToString:@"CONFIRMED"]||[userTm.status isEqualToString:@"DELAYED"]||[userTm.status isEqualToString:@"FINISHED"]) {
                        [userConfirm addObject:userTm];
                    }
                    else
                    {
                        [userUnConfirm addObject:userTm];
                    }
                    
                }
                [mainTable reloadData];
                [mainTable.pullToRefreshView stopAnimating];
                [mainTable.infiniteScrollingView stopAnimating];
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD showHUDWithTitle:msg isDismissLater:YES];
                });
            }
        } failureBlock:^(NSString *description) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"network_failed") isDismissLater:YES];
            });
            
        }];
    });
}
#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2) {
        return userFinishs.count;
    }
    if (section==3) {
        return userUnfinishs.count;
    }
    if (self.tDetail&&section==0) {
        return 1;
    }
    if (section==1) {
        return 1;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
//        if (self.tDetail.attachmentUrl&&[self.tDetail.contentType isEqualToString:@"VOICE"])
        if([self.taskDetail.content hasPrefix:@"http"])
        {
            if (self.tDetail.attachmentUrl) {
                return 180;
            }
            return 110;
        }
        CGSize constraint=CGSizeMake(boundsWidth-EdgeDis*4, MAXFLOAT);
        CGSize size=[self.taskDetail.content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
//        CGSize size = [self.taskDetail.content boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        CGFloat height=MAX(size.height+10, 0);
        if (height>25&&[self.tDetail.contentType isEqualToString:@"TEXT"]) {
            if (self.tDetail.attachmentUrl) {
                cellHeight=100+height+EdgeDis+60*height/25/2;
                return cellHeight;
            }
            cellHeight=180+height+EdgeDis;
            return cellHeight;
        }
        if (self.tDetail.attachmentUrl) {
            cellHeight=80+height+80;
            return cellHeight;
        }
        cellHeight=80+height;
        return cellHeight;
    }
    return 44;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        NSNumber *currenUid=[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"];
        TableViewCell_taskDetail *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell01"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (UIView *subviews in cell.bgView.subviews) {
            if (subviews.tag>10000) {
                [subviews removeFromSuperview];
            }
        }
        cell.nameLabel.text=([currenUid integerValue] == [self.taskDetail.creatorUid integerValue])?@"我":self.taskDetail.creatorName;
        if (self.tDetail.finishTime) {
            cell.timeLabel.text=[NSString stringWithFormat:@"%@%@",LOCALIZATION(@"finish_time"),[Common getChineseTimeFrom:[self.tDetail.finishTime doubleValue]]];
        }
        else
        {
            cell.timeLabel.text=[NSString stringWithFormat:@"%@%@",LOCALIZATION(@"finish_time"),[Common getChineseTimeFrom:[self.tDetail.plannedFinishTime doubleValue]]];
        }
//        if([self.taskDetail.content hasPrefix:@"http"])
        if([self.tDetail.contentType isEqualToString:@"VOICE"])
        {
            cell.contentLabel.hidden=YES;
            UIView *voiceView=[[UIView alloc]initWithFrame:CGRectMake(EdgeDis, cell.nameLabel.frame.origin.y+cell.nameLabel.frame.size.height+3, 80, 40)];
            voiceView.tag=10001+indexPath.row;
            [cell.bgView addSubview:voiceView];
            voiceView.layer.borderColor=[UIColor grayColor].CGColor;
            voiceView.layer.borderWidth=1.0;
            voiceView.layer.cornerRadius=5;
            UIImageView *voiceAnimationView =[[UIImageView alloc]initWithFrame:CGRectMake(EdgeDis,EdgeDis/2 , 28,32)];
            [voiceAnimationView setImage:[UIImage imageWithFileName:@"chat_voice_playing3.png"]];
            voiceAnimationView.tag=100010;
            [voiceView addSubview:voiceAnimationView];
            UILabel *voiceDurationView=[[UILabel alloc] initWithFrame:CGRectMake(voiceAnimationView.frame.origin.x+voiceAnimationView.frame.size.width+EdgeDis, voiceAnimationView.frame.origin.y, 30, voiceAnimationView.frame.size.height)];
            voiceDurationView.backgroundColor =[UIColor clearColor];
            voiceDurationView.text=[NSString stringWithFormat:@"%@''",self.tDetail.voiceDuration];
            [voiceView addSubview:voiceDurationView];
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playVoice:)];
            [voiceView addGestureRecognizer:tap];
        }
//        if ([self.taskDetail.contentType isEqualToString:@"TEXT"])
        else
        {
            cell.contentLabel.hidden=NO;
            cell.contentLabel.text=self.taskDetail.content;
            [cell.contentLabel sizeToFit];
//            cell.contentLabel.backgroundColor=[UIColor redColor];
        }
        cell.confirmLabel.text=([self.tDetail.userCount integerValue]==userConfirm.count)?[NSString stringWithFormat:@"%@%@%@",LOCALIZATION(@"Message_allSure"),self.tDetail.userCount,LOCALIZATION(@"Message_people")]:[NSString stringWithFormat:@"%lu%@%@%@",(unsigned long)userUnConfirm.count,LOCALIZATION(@"Message_person_not"),self.tDetail.userCount,LOCALIZATION(@"Message_people")];
        
        if (self.tDetail.attachmentUrl) {
            ClickImage * attachImg=[[ClickImage alloc]init];
            attachImg.canClick=YES;
            [attachImg sd_setImageWithURL:[NSURL URLWithString:self.tDetail.attachmentUrl] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                float scale;
                scale = image.size.width/image.size.height;
                @try{
                    if ([self.tDetail.contentType isEqualToString:@"VOICE"]) {
                        attachImg.frame=CGRectMake(5, cell.contentLabel.frame.origin.y+cell.contentLabel.frame.size.height+EdgeDis*3, 60*scale, 60);
                    }
                    else
                    {
//                        attachImg.frame=CGRectMake(5, cell.contentLabel.frame.size.height+cell.contentLabel.frame.origin.y, 60*scale, 60);
                        attachImg.frame=CGRectMake(5, cellHeight-120, 60*scale, 60);
                        
                        
                    }
                }
                @catch(NSException *exception) {
                    NSLog(@"exception:%@", exception);
                }
                @finally {
                    
                }
                
            }];
            attachImg.tag=10001+indexPath.row;
            [cell.bgView addSubview:attachImg];
        }
        if ([self.tDetail.status isEqualToString:@"CREATED"]) {
            [cell.statusBtn setTitle:@"" forState:UIControlStateNormal];
            [cell.statusBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            
        }
        else if ([self.tDetail.status isEqualToString:@"DELAYED"])
        {
            [cell.statusBtn setTitle:LOCALIZATION(@"task_delayed") forState:UIControlStateNormal];
            [cell.statusBtn setBackgroundImage:[UIImage imageNamed:@"bg_orange"] forState:UIControlStateNormal];
        }
        else if ([self.tDetail.status isEqualToString:@"FINISHED"]) {
            [cell.statusBtn setTitle:LOCALIZATION(@"task_finised") forState:UIControlStateNormal];
            [cell.statusBtn setBackgroundImage:[UIImage imageNamed:@"bg_green"] forState:UIControlStateNormal];
        }
        else
        {
            [cell.statusBtn setTitle:@"" forState:UIControlStateNormal];
            [cell.statusBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        if ([self.tDetail.status isEqualToString:@"FINISHED"]) {
            [cell.statusBtn setTitle:LOCALIZATION(@"task_finised") forState:UIControlStateNormal];
            [cell.statusBtn setBackgroundImage:[UIImage imageNamed:@"bg_green"] forState:UIControlStateNormal];
        }
        if ([self.tDetail.userStatus isEqualToString:@"CREATED"]) {
            [cell.statusBtn setTitle:LOCALIZATION(@"task_not_confirm") forState:UIControlStateNormal];
            [cell.statusBtn setBackgroundImage:[UIImage imageNamed:@"bg_red"] forState:UIControlStateNormal];
        }
        if ([self.tDetail.userStatus isEqualToString:@"FINISHED"]) {
            [cell.statusBtn setTitle:LOCALIZATION(@"task_finised") forState:UIControlStateNormal];
            [cell.statusBtn setBackgroundImage:[UIImage imageNamed:@"bg_green"] forState:UIControlStateNormal];
        }
        
        [cell.personBtn addTarget:self action:@selector(personBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    if (indexPath.section==1) {
        static NSString *CellIdentifier = @"Cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor=[UIColor hexChangeFloat:@"ffffff"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            for (UIView *subviews in cell.contentView.subviews) {
                if (subviews.tag>10000) {
                    [subviews removeFromSuperview];
                }
            }
        }
        
        UIImageView *replyImg=[[UIImageView alloc]initWithFrame:CGRectMake(EdgeDis, EdgeDis+2, 24, 24)];
        replyImg.image=[UIImage imageNamed:@"task_reply"];
        replyImg.tag=indexPath.row+10001;
        [cell.contentView addSubview:replyImg];
        UILabel *replyLabel=[[UILabel alloc]initWithFrame:CGRectMake(replyImg.frame.origin.x+replyImg.frame.size.width+EdgeDis, 0, 100, 44)];
        replyLabel.textColor=[UIColor grayColor];
        replyLabel.tag=indexPath.row+10001;
        replyLabel.text=([self.tDetail.replyCount integerValue]!=0)?[NSString stringWithFormat:@"%@%@%@",LOCALIZATION(@"task_all"),self.tDetail.replyCount,LOCALIZATION(@"task_reply_num")]:[NSString stringWithFormat:@"%@",LOCALIZATION(@"task_reply_no")];
        [cell.contentView addSubview:replyLabel];
        return cell;
    }
    if (indexPath.section==2) {
        static NSString *CellIdentifier = @"Cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor=[UIColor hexChangeFloat:@"ffffff"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else
        {
            for (UIView *subviews in cell.contentView.subviews) {
                if (subviews.tag>10000) {
                    [subviews removeFromSuperview];
                }
            }
        }
        UserTaskModel *um=[userFinishs objectAtIndex:indexPath.row];
        cell.imageView.image=[UIImage imageNamed:@"default_head"];
        cell.textLabel.text=[NSString stringWithFormat:@"%@",um.name];
        UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(boundsWidth-200-EdgeDis*3, 0, 200, 44)];
        timeLabel.font=[UIFont systemFontOfSize:12];
        timeLabel.textAlignment=NSTextAlignmentRight;
        timeLabel.textColor=[UIColor grayColor];
//        timeLabel.text=[NSString stringWithFormat:@"%@%@",LOCALIZATION(@"finish_time"),[Common getChineseTimeFrom:(long long)um.createTime]];
        timeLabel.text=[NSString stringWithFormat:@"%@%@%%",LOCALIZATION(@"task_finish_progress"),um.progress];
        timeLabel.tag=10001+indexPath.row;
        [cell.contentView addSubview:timeLabel];
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"Cell3";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor=[UIColor hexChangeFloat:@"ffffff"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            for (UIView *subviews in cell.contentView.subviews) {
                if (subviews.tag>10000) {
                    [subviews removeFromSuperview];
                }
            }
        }
        UserTaskModel *um=[userUnfinishs objectAtIndex:indexPath.row];
        cell.imageView.image=[UIImage imageNamed:@"default_head"];
        cell.textLabel.text=[NSString stringWithFormat:@"%@",um.name];
        UILabel *progressLabel=[[UILabel alloc]initWithFrame:CGRectMake(boundsWidth-200-EdgeDis*3, 0, 200, 44)];
        progressLabel.font=[UIFont systemFontOfSize:12];
        progressLabel.textAlignment=NSTextAlignmentRight;
        progressLabel.textColor=[UIColor grayColor];
        progressLabel.text=[NSString stringWithFormat:@"%@%@%%",LOCALIZATION(@"task_finish_progress"),um.progress];
        progressLabel.tag=10001+indexPath.row;
        [cell.contentView addSubview:progressLabel];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        
        TaskReplyListViewController *tvc=[[TaskReplyListViewController alloc]init];
        tvc.taskId=self.taskDetail.taskId;
        [self.navigationController pushViewController:tvc animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section>1) {
        return 25;
    }
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *myView=[[UIView alloc]init];
    myView.backgroundColor=BGColor;
    if (section==2) {
        
        UILabel *finishLabel=[[UILabel alloc]initWithFrame:CGRectMake(EdgeDis, 0, 100, 25)];
        finishLabel.textColor=[UIColor grayColor];
        NSString *str = [LOCALIZATION(@"Message_did") stringByAppendingFormat:@"%d",userFinishs.count];
        NSString *str1 = [str stringByAppendingString:LOCALIZATION(@"Message_people")];
        finishLabel.text=str1;
        finishLabel.font=[UIFont systemFontOfSize:13];
        [myView addSubview:finishLabel];
    }
    if (section==3) {
        UILabel *unfinishLabel=[[UILabel alloc]initWithFrame:CGRectMake(EdgeDis, 0, 100, 25)];
        unfinishLabel.textColor=[UIColor grayColor];
        
        NSString *str2 = [LOCALIZATION(@"Message_no_did") stringByAppendingFormat:@"%d",userUnfinishs.count];
        NSString *str3 = [str2 stringByAppendingString:LOCALIZATION(@"Message_people")];
        unfinishLabel.text=str3;
        unfinishLabel.font=[UIFont systemFontOfSize:13];
        [myView addSubview:unfinishLabel];
    }
    return myView;
}
#pragma mark------playVoice
-(void)playVoice:(UITapGestureRecognizer*)tap
{
    isSuspend=!isSuspend;
    NSLog(@"%d",tap.view.tag);
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
    if (isSuspend) {
        NSError *playerError;
        voicePlayer=nil;
        
        NSURL *url = [[NSURL alloc]initWithString:self.taskDetail.content];
        NSData * audioData = [NSData dataWithContentsOfURL:url];
        
        //将数据保存到本地指定位置
        NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath,*amrPath ;
        if ([self.taskDetail.content hasSuffix:@"amr"]) {
            NSLog(@"amr---mav");
            amrPath = [NSString stringWithFormat:@"%@/%@%d.amr", docDirPath , @"temp1",tap.view.tag];
            filePath = [NSString stringWithFormat:@"%@/%@%d.mav", docDirPath , @"temp1",tap.view.tag];
            [audioData writeToFile:amrPath atomically:YES];
            [OpenCoreAmrManager amrToWav:amrPath wavSavePath:filePath];
        }
        else
        {
            filePath = [NSString stringWithFormat:@"%@/%@%d.mav", docDirPath , @"temp1",tap.view.tag];
            [audioData writeToFile:filePath atomically:YES];
        }
        
        //播放本地音乐
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        voicePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&playerError];
        voicePlayer.volume=1.0;
        
        if (voicePlayer == nil)
        {
            NSLog(@"ERror creating player: %@", [playerError description]);
        }else{
            [tapeSession setCategory:AVAudioSessionCategoryPlayback error:nil];
            voicePlayer.delegate=self;
            [voicePlayer prepareToPlay];
            [voicePlayer play];
            voiceImgView=(UIImageView*)[tap.view viewWithTag:100010];
            voiceImgView.animationImages =[NSArray arrayWithObjects:[UIImage imageWithFileName:@"chat_voice_playing1.png"],[UIImage imageWithFileName:@"chat_voice_playing2.png"],[UIImage imageWithFileName:@"chat_voice_playing3.png"],nil];
            voiceImgView.animationDuration =1;
            [voiceImgView startAnimating];
        }
    }
    else
    {
        [voiceImgView stopAnimating];
        [voicePlayer stop];
    }
   
    
}
#pragma mark-------AVAudioPlayer delegate
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    isSuspend=!isSuspend;
    [voiceImgView stopAnimating];
    [player stop];
}
#pragma mark----------personBtnClick
-(void)personBtnClick:(UIButton*)btn
{
    NSLog(@"人员详情");
    UserDetailViewController *uvc=[[UserDetailViewController alloc]init];
    uvc.userUnConfirm=[NSMutableArray arrayWithArray:userUnConfirm];
    uvc.userConfirm=userConfirm;
    [self.navigationController pushViewController:uvc animated:YES];
}
#pragma mark 处理导航条
-(void)handleNavigationBarItem{
    self.navigationItem.title = LOCALIZATION(@"task_details");
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
}
-(void)clickLeftItem:(id)sender{
    [voicePlayer stop];
    [self.navigationController popViewControllerAnimated:YES];
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

@end
