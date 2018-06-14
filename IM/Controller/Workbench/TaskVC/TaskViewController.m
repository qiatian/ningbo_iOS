//
//  TaskViewController.m
//  IM
//
//  Created by ZteCloud on 15/11/10.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "TaskViewController.h"
#import "TableViewCell_task.h"
#import "NewTaskViewController.h"
#import "TaskDetailViewController.h"
#import "TaskDetailViewController2.h"

@interface TaskViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate,AVAudioPlayerDelegate,UIAlertViewDelegate>
{
    UITableView *mainTable,*siftTable;
    NSMutableArray *dataArr,*myTasks;
    NSInteger currentPage;
    
    
    AVAudioPlayer *voicePlayer;
    AVAudioSession *tapeSession;
    UIImageView *voiceImgView;
    BOOL isSuspend;
    UIView *siftBgView;
    
    UIButton *currentBtn;
    NSInteger currentRow;
    
    NSIndexPath *indexPathWillDelete;
    
}

@end

@implementation TaskViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self handleNavigationBarItem];
    
    [NotiCenter addObserver:self selector:@selector(taskDidChange:) name:@"NewTaskAdd" object:nil];
    [NotiCenter addObserver:self selector:@selector(taskDidChange:) name:@"ConfirmTask" object:nil];
    [NotiCenter addObserver:self selector:@selector(taskDidChange:) name:@"UpdateProgress" object:nil];
    [NotiCenter addObserver:self selector:@selector(taskDidChange:) name:@"TaskAddReply" object:nil];
    [NotiCenter addObserver:self selector:@selector(taskDidChange:) name:@"TaskFINISHED" object:nil];
    dataArr =[[NSMutableArray alloc]initWithCapacity:0];
    myTasks=[[NSMutableArray alloc]initWithCapacity:0];
    [self setTable];
    _taskStatus=@"ALL";
    currentPage=1;
    [self getTaskListReqWithStatus:_taskStatus];
//    [self requestTaskDeleteWithTaskId:nil];
}
-(void)taskDidChange:(NSNotification *)notification
{
    currentPage=1;
    [self getTaskListReqWithStatus:_taskStatus];
}
-(void)setTable
{
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight-NavBarHeight) style:UITableViewStylePlain];
    mainTable.backgroundColor=BGColor;
    mainTable.delegate=self;
    mainTable.dataSource=self;
    mainTable.showsVerticalScrollIndicator=NO;
    mainTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTable];
    [mainTable registerNib:[UINib nibWithNibName:@"TableViewCell_task" bundle:nil] forCellReuseIdentifier:@"Cell"];
    WEAKSELF
    TaskViewController *blockSelf=self;
    __block NSInteger blcokPage= currentPage;    //下拉刷新
    [mainTable addPullToRefreshWithActionHandler:^{
        NSLog(@"0000");
        blcokPage=0;
        [blockSelf getTaskListReqWithStatus:weakSelf.taskStatus];
    }];
    //上拉加载
    [mainTable addInfiniteScrollingWithActionHandler:^{
        NSLog(@"1111");
        blcokPage++;
        [blockSelf getTaskListReqWithStatus:weakSelf.taskStatus];
        
    }];
    [mainTable.pullToRefreshView setTitle:LOCALIZATION(@"refreshing") forState:SVPullToRefreshStateAll];
    
}
-(void)getTaskListReqWithStatus:(NSString*)queryStatus
{
//    [MMProgressHUD showHUDWithTitle:@"" isDismissLater:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"]] forKey:@"token"];
        [parameters setObject:[NSString stringWithFormat:@"%d",currentPage] forKey:@"page"];
        [parameters setObject:queryStatus forKey:@"queryStatus"];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodTaskList] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
//            NSLog(@"%@",msg);
            if(success && [data isKindOfClass:[NSDictionary class]]){
//                NSLog(@"%@",data);
                NSMutableArray *arr=[[NSMutableArray alloc]initWithCapacity:0];
                NSString *currenUid=[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"];
                
                for (NSDictionary*dic in data[@"tasks"])
                {
                    TaskModel *tm=[[TaskModel alloc]initWithDictionary:dic];
                    [arr addObject:tm];
                    if ([_taskStatus isEqualToString:@"ALL"]&&[currenUid integerValue] == [tm.creatorUid integerValue]) {
                        [myTasks addObject:tm];
                    }
                }
                if (currentPage==1)
                {
                    [dataArr removeAllObjects];
                }
                [dataArr addObjectsFromArray:arr];
                if (dataArr.count==0) {
                    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"no_more_data") isDismissLater:YES];
                }
                else
                {
//                    [MMProgressHUD showHUDWithTitle:@"" isDismissLater:YES];
                }
                [mainTable reloadData];
                [mainTable.pullToRefreshView stopAnimating];
                [mainTable.infiniteScrollingView stopAnimating];
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD showHUDWithTitle:msg isDismissLater:YES];
                    [mainTable.pullToRefreshView stopAnimating];
                    [mainTable.infiniteScrollingView stopAnimating];
                });
            }
        } failureBlock:^(NSString *description) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"network_failed") isDismissLater:YES];
                [mainTable.pullToRefreshView stopAnimating];
                [mainTable.infiniteScrollingView stopAnimating];
            });
            
        }];
    });
}

#pragma mark--------tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==mainTable) {
        return dataArr.count;
    }
    else
    {
        return 5;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==mainTable) {
        TaskModel *tm=[dataArr objectAtIndex:indexPath.row];
        if (tm.attachmentUrl)
        {
            return 180;
        }
        if ([tm.contentType isEqualToString:@"VOICE"]) {
            return 110;
        }
        return 100;
    }
    return 44;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==mainTable) {
        NSString *currenUid=[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"];
        TableViewCell_task *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (UIView *subviews in cell.bgView.subviews) {
            if (subviews.tag>10000) {
                [subviews removeFromSuperview];
            }
        }
        TaskModel *tm=[dataArr objectAtIndex:indexPath.row];
        cell.nameLabel.text=([currenUid integerValue] == [tm.creatorUid integerValue])?@"我":tm.creatorName;
        [cell.nameLabel sizeToFit];
        if (tm.finishTime) {
            cell.timeLabel.text=[NSString stringWithFormat:@"%@%@",LOCALIZATION(@"finish_time"),[Common getChineseTimeFrom:[tm.finishTime doubleValue]]];
        }
        else
        {
            cell.timeLabel.text=[NSString stringWithFormat:@"%@%@",LOCALIZATION(@"finish_time"),[Common getChineseTimeFrom:[tm.plannedFinishTime doubleValue]]];
        }
        
        if ([tm.contentType isEqualToString:@"VOICE"])
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
            voiceDurationView.text=[NSString stringWithFormat:@"%@''",tm.voiceDuration];
            [voiceView addSubview:voiceDurationView];
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playVoice:)];
            [voiceView addGestureRecognizer:tap];
        }
        else if ([tm.contentType isEqualToString:@"TEXT"])
        {
            cell.contentLabel.hidden=NO;
            cell.contentLabel.text=tm.content;
        }
        if (tm.attachmentUrl) {
            ClickImage * attachImg=[[ClickImage alloc]init];
            attachImg.canClick=YES;
            attachImg.backgroundColor=[UIColor grayColor];
            [attachImg sd_setImageWithURL:[NSURL URLWithString:tm.attachmentUrl] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                float scale;
                scale = image.size.width/image.size.height;
                @try{
                    if ([tm.contentType isEqualToString:@"VOICE"]) {
                        attachImg.frame=CGRectMake(5, cell.contentLabel.frame.origin.y+cell.contentLabel.frame.size.height+EdgeDis*2+3, 60*scale, 60);
                    }
                    else
                    {
                        attachImg.frame=CGRectMake(5, cell.contentLabel.frame.origin.y+cell.contentLabel.frame.size.height+EdgeDis, 60*scale, 60);
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
        if ([tm.status isEqualToString:@"CREATED"]) {
            [cell.statusBtn setTitle:@"" forState:UIControlStateNormal];
            [cell.statusBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            
        }
        else if ([tm.status isEqualToString:@"DELAYED"])
        {
            [cell.statusBtn setTitle:LOCALIZATION(@"task_delayed") forState:UIControlStateNormal];
            [cell.statusBtn setBackgroundImage:[UIImage imageNamed:@"bg_orange"] forState:UIControlStateNormal];
        }
        else if ([tm.status isEqualToString:@"FINISHED"]) {
            [cell.statusBtn setTitle:LOCALIZATION(@"task_finised") forState:UIControlStateNormal];
            [cell.statusBtn setBackgroundImage:[UIImage imageNamed:@"bg_green"] forState:UIControlStateNormal];
        }
        else
        {
            [cell.statusBtn setTitle:@"" forState:UIControlStateNormal];
            [cell.statusBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        if ([tm.userStatus isEqualToString:@"CREATED"]) {
            [cell.statusBtn setTitle:LOCALIZATION(@"task_not_confirm") forState:UIControlStateNormal];
            [cell.statusBtn setBackgroundImage:[UIImage imageNamed:@"bg_red"] forState:UIControlStateNormal];
        }
        if ([tm.userStatus isEqualToString:@"FINISHED"]) {
            [cell.statusBtn setTitle:LOCALIZATION(@"task_finised") forState:UIControlStateNormal];
            [cell.statusBtn setBackgroundImage:[UIImage imageNamed:@"bg_green"] forState:UIControlStateNormal];
        }
        if ([tm.replyCount integerValue]!=0) {
            cell.replyLabel.text=[NSString stringWithFormat:@"%@%@%@",LOCALIZATION(@"task_all"),tm.replyCount,LOCALIZATION(@"task_reply_num")];
        }
        else
        {
            cell.replyLabel.text=[NSString stringWithFormat:@"%@",LOCALIZATION(@"task_detail")];
        }
        if (tm.confirmedUserCount==tm.userCount)
        {
            cell.confirmLabel.text=LOCALIZATION(@"task_all_confirm");
        }
        else
        {
            NSInteger unConfirmNum=[tm.userCount integerValue]-[tm.confirmedUserCount integerValue];
            NSString *str = [[NSString alloc]initWithFormat:@"%d",unConfirmNum];
            NSString *str2 = [str stringByAppendingString:LOCALIZATION(@"Message_pSure")];
            cell.confirmLabel.text = str2;
        }
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteTask:)];
        [cell.contentView addGestureRecognizer:longPress];
        
        return cell;
    }
    else
    {
        UITableViewCell *siftCell=[tableView dequeueReusableCellWithIdentifier:@"siftCell"];
        if (!siftCell) {
            siftCell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"siftCell"];
            siftCell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        else
        {
            for (UIView *subviews in siftCell.contentView.subviews) {
                if (subviews.tag>10000) {
                    [subviews removeFromSuperview];
                }
            }
        }
        NSArray *siftTitles=[NSArray arrayWithObjects:LOCALIZATION(@"sift_all"),LOCALIZATION(@"sift_unconfirm"),LOCALIZATION(@"sift_confirm"),LOCALIZATION(@"sift_finished"),LOCALIZATION(@"sift_deleted"), nil];
        NSArray *siftImgs=[NSArray arrayWithObjects:@"sift_all",@"sift_unconfirm",@"sift_confirm",@"sift_finished",@"sift_deleted", nil];
        NSArray *siftImgsno=[NSArray arrayWithObjects:@"sift_all_pre",@"sift_unconfirm_pre",@"sift_confirm_pre",@"sift_finished_pre",@"sift_deleted_pre", nil];
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(EdgeDis, 0, 200, 44);
        btn.tag=indexPath.row+10001;
        [btn setTitle:siftTitles[indexPath.row] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:MainColor forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:siftImgsno[indexPath.row]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:siftImgs[indexPath.row]] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(siftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [siftCell.contentView addSubview:btn];
        btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets=UIEdgeInsetsMake(0, EdgeDis, 0, 0);
        btn.imageEdgeInsets=UIEdgeInsetsMake(10, 0, 10, 176);
        if (indexPath.row==0) {
            btn.selected=YES;
            currentBtn=btn;
        }
        if (indexPath.row>0&&indexPath.row<4) {
            btn.frame=CGRectMake(EdgeDis*5, 0, 200, 44);
        }
        return siftCell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [voicePlayer stop];
    [voiceImgView stopAnimating];
    if (tableView==mainTable) {
        TaskModel *tm=[dataArr objectAtIndex:indexPath.row];
        if ([tm.status isEqualToString:@"DELAYED"]||[tm.status isEqualToString:@"FINISHED"]||[tm.userStatus isEqualToString:@"FINISHED"]) {
            TaskDetailViewController2 *tvc=[[TaskDetailViewController2 alloc]init];
            tvc.taskDetail=tm;
            [self.navigationController pushViewController:tvc animated:YES];
        }
        else
        {
            TaskDetailViewController *tvc=[[TaskDetailViewController alloc]init];
            tvc.taskId=tm.taskId;
            tvc.tModel=tm;
            [self.navigationController pushViewController:tvc animated:YES];
        }

    }
    else
    {
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        currentRow=indexPath.row+10001;
        UIButton *btn=(UIButton*)[cell.contentView viewWithTag:currentRow];
        if (currentBtn.tag!=currentRow) {
            currentBtn.selected=!currentBtn.selected;
            btn.selected=!btn.selected;
            currentBtn=btn;
        }
        if (btn.tag==10001) {
            _taskStatus=@"ALL";
        }
        if (btn.tag==10002) {
            _taskStatus=@"CREATED";
        }
        if (btn.tag==10003) {
            _taskStatus=@"CONFIRMED";
        }
        if (btn.tag==10004) {
            _taskStatus=@"FINISHED";
        }
        if (btn.tag==10005) {
            _taskStatus=@"DELETED";
        }
        [self hiddenSiftTable:nil];
    }
    
    
}
#pragma mark--------siftBtnClick
-(void)siftBtnClick:(UIButton*)btn
{
    if (currentBtn!=btn) {
        currentBtn.selected=!currentBtn.selected;
        btn.selected=!btn.selected;
        currentBtn=btn;
    }
    if (btn.tag==10001) {
        _taskStatus=@"ALL";
    }
    if (btn.tag==10002) {
        _taskStatus=@"CREATED";
    }
    if (btn.tag==10003) {
        _taskStatus=@"CONFIRMED";
    }
    if (btn.tag==10004) {
        _taskStatus=@"FINISHED";
    }
    if (btn.tag==10005) {
        _taskStatus=@"DELETED";
    }
    [self hiddenSiftTable:nil];
}
#pragma mark--------播放录音
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
        TaskModel *tm=[dataArr objectAtIndex:(tap.view.tag-10001)];
        NSError *playerError;
        voicePlayer=nil;
        
        NSURL *url = [[NSURL alloc]initWithString:tm.content];
        NSData * audioData = [NSData dataWithContentsOfURL:url];
        
        //将数据保存到本地指定位置
        NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath,*amrPath ;
        if ([tm.content hasSuffix:@"amr"]) {
            NSLog(@"amr---mav");
            amrPath = [NSString stringWithFormat:@"%@/%@%d.amr", docDirPath , @"temp",tap.view.tag];
            filePath = [NSString stringWithFormat:@"%@/%@%d.mav", docDirPath , @"temp",tap.view.tag];
            [audioData writeToFile:amrPath atomically:YES];
            [OpenCoreAmrManager amrToWav:amrPath wavSavePath:filePath];
        }
        else
        {
            filePath = [NSString stringWithFormat:@"%@/%@%d.mav", docDirPath , @"temp",tap.view.tag];
            [audioData writeToFile:filePath atomically:YES];
        }
        
        //播放本地音乐
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        voicePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&playerError];
        //    voicePlayer=[[AVAudioPlayer alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tm.content]] error:&playerError];
        voicePlayer.volume=1.0;
        [voicePlayer prepareToPlay];
        if (voicePlayer == nil)
        {
            NSLog(@"ERror creating player: %@", [playerError description]);
        }else{
            [tapeSession setCategory:AVAudioSessionCategoryPlayback error:nil];
            voicePlayer.delegate=self;
            [voicePlayer play];
            voiceImgView=(UIImageView*)[tap.view viewWithTag:100010];
            voiceImgView.animationImages =[NSArray arrayWithObjects:[UIImage imageWithFileName:@"chat_voice_playing1.png"],[UIImage imageWithFileName:@"chat_voice_playing2.png"],[UIImage imageWithFileName:@"chat_voice_playing3.png"],nil];
            voiceImgView.animationDuration =1;
            [voiceImgView startAnimating];
        }
        
    }
    else
    {
        [voicePlayer stop];
        [voiceImgView stopAnimating];
    }
    
    
}
#pragma mark-------AVAudioPlayer delegate
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    isSuspend=!isSuspend;
    [voiceImgView stopAnimating];
    [player stop];
}
#pragma mark 处理导航条
-(void)handleNavigationBarItem{
    UIView *topTitleView=[[UIView alloc]initWithFrame:CGRectMake(EdgeDis*3, 0, boundsWidth-EdgeDis*6, 44)];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, topTitleView.frame.size.width/2-20, topTitleView.frame.size.height)];
    titleLabel.text=LOCALIZATION(@"task_task");
    titleLabel.textAlignment=NSTextAlignmentRight;
    [topTitleView addSubview:titleLabel];
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(titleLabel.frame.size.width, EdgeDis, 30, 30)];
    imgView.image=[UIImage imageNamed:@"task_sift"];
    [topTitleView addSubview:imgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(siftTapAction:)];
    [topTitleView addGestureRecognizer:tap];
    self.navigationItem.titleView=topTitleView;
    
    
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    ILBarButtonItem *rigthItem=[ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"task_add"] highlightedImage:[UIImage imageNamed:@"task_add"] target:self action:@selector(newTask)];
    [self.navigationItem setRightBarButtonItem:rigthItem];
}
-(void)siftTapAction:(UITapGestureRecognizer*)tap
{
    NSLog(@"ddddd");
    if (siftBgView.hidden) {
        siftBgView.hidden=NO;
        siftTable.hidden=NO;
        mainTable.userInteractionEnabled=NO;
        
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            siftBgView.hidden=YES;
            siftTable.hidden=YES;
        } completion:^(BOOL finished) {
            mainTable.userInteractionEnabled=YES;
        }];
        
    }
    if (!siftBgView) {
        siftBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight)];
        siftBgView.backgroundColor=[UIColor clearColor];
        [self.view addSubview:siftBgView];
        UITapGestureRecognizer *siftTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenSiftTable:)];
        [siftBgView addGestureRecognizer:siftTap];
        siftTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 220) style:UITableViewStylePlain];
        siftTable.dataSource=self;
        siftTable.delegate=self;
        [self.view addSubview:siftTable];
        mainTable.userInteractionEnabled=NO;
    }
    
}
-(void)hiddenSiftTable:(UITapGestureRecognizer*)tap
{
    NSLog(@"sssss");
    [UIView animateWithDuration:0.5 animations:^{
        siftBgView.hidden=YES;
        siftTable.hidden=YES;
    } completion:^(BOOL finished) {
        mainTable.userInteractionEnabled=YES;
        currentPage=1;
        if (![_taskStatus isEqualToString:@""]) {
            [self getTaskListReqWithStatus:_taskStatus];
        }
        else
        {
            
        }
    }];
    
}


- (void)deleteTask:(UILongPressGestureRecognizer*)longPress{
    
    
    if (longPress.state == UIGestureRecognizerStateBegan) {

        CGPoint point = [longPress locationInView:mainTable];

        indexPathWillDelete = [mainTable indexPathForRowAtPoint:point];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOCALIZATION(@"notice") message:LOCALIZATION(@"type_delete") delegate:self cancelButtonTitle:LOCALIZATION(@"discover_cancel") otherButtonTitles:LOCALIZATION(@"confirm"), nil];
        [alertView show];
    }
}

-(void)clickLeftItem:(id)sender{
    [voicePlayer stop];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)newTask
{
    NewTaskViewController *nvc=[[NewTaskViewController alloc]init];
    [self.navigationController pushViewController:nvc animated:YES];
}
-(void)requestTaskDeleteWithTaskId:(NSString*)taskId
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"]] forKey:@"token"];
        [parameters setObject:taskId forKey:@"taskId"];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodTaskDelete] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
            
//            NSLog(@"%@",msg);
            if(success && [data isKindOfClass:[NSDictionary class]]){
                
                [dataArr removeObjectAtIndex:indexPathWillDelete.row];
                indexPathWillDelete = nil;
                [mainTable reloadData];
                
                
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
#pragma mark - UIAlerViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (buttonIndex == 1) {//删除任务
        
        TaskModel *tm=[dataArr objectAtIndex:indexPathWillDelete.row];
        
        [self requestTaskDeleteWithTaskId:tm.taskId];
        
        
    }
    
}
@end
