//
//  TaskDetailViewController.m
//  IM
//
//  Created by ZteCloud on 15/11/13.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "TableViewCell_taskDetail.h"
#import "TableViewCell_reply.h"
#import "UserDetailViewController.h"
#import "TaskDetailViewController2.h"
#import "UserFinishViewController.h"
@interface TaskDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate,UIAlertViewDelegate,AVAudioPlayerDelegate>
{
    UITableView *mainTable;
    UIView *commentBg,*belowBg;
    UITextField *commentTF;
    UIButton *commentBtn;
    UIButton *confirmBtn;
    
    NSMutableArray *replyArr;
    UILabel *progressLabel;
    NSString *progressValue,*lastPV;
    
     NSMutableArray *userConfirm,*userUnConfirm,*userFinish,*userUnFinish;
    UISlider *progressSlider;

    AVAudioSession *tapeSession;
    AVAudioPlayer *voicePlayer;
    UIImageView *voiceImgView;
    BOOL isSuspend;
    int currentPage;
}

@end

@implementation TaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    currentPage = 1;
    userConfirm = [[NSMutableArray alloc]initWithCapacity:0];
    userUnConfirm = [[NSMutableArray alloc]initWithCapacity:0];
    userFinish = [[NSMutableArray alloc]initWithCapacity:0];
    userUnFinish = [[NSMutableArray alloc]initWithCapacity:0];
    //监听键盘变化
    [NotiCenter addObserver:self selector:@selector(receiveKeyBoardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [NotiCenter addObserver:self selector:@selector(refreshBelowUI:) name:@"BelowUI" object:nil];
    replyArr = [[NSMutableArray alloc]initWithCapacity:0];
    [self handleNavigationBarItem];
    
    [self setTableUI];
    [self loadConfirmBtn];
    [self loadComment];
    
    [self requestTaskQueryWithID:self.taskId];
    [self requestTaskListReplyWithFlag:0];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    GQNavigationController *navi = (GQNavigationController*)self.navigationController;
    navi.canDragBack = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    GQNavigationController *navi = (GQNavigationController*)self.navigationController;
    navi.canDragBack = YES;
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

-(void)setTableUI
{
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, viewWithNavAndTabbar) style:UITableViewStylePlain];
    /*****/
    mainTable.backgroundColor=BGColor;
    mainTable.delegate=self;
    mainTable.dataSource=self;
//    mainTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTable];
    [mainTable registerNib:[UINib nibWithNibName:@"TableViewCell_taskDetail" bundle:nil] forCellReuseIdentifier:@"Cell0"];
    [mainTable registerNib:[UINib nibWithNibName:@"TableViewCell_reply" bundle:nil] forCellReuseIdentifier:@"Cell2"];
    [Common setExtraCellLineHidden:mainTable];
    belowBg = [[UIView alloc]initWithFrame:CGRectMake(0, boundsHeight-kTabBarHeight-NavBarHeight, boundsWidth, kTabBarHeight)];
    belowBg.backgroundColor=BGColor;
    [self.view addSubview:belowBg];
    
    //下拉加载回复
    
    __block TaskDetailViewController *blockSelf = self;
//    __block int blockPage = currentPage;
    
    [mainTable addPullToRefreshWithActionHandler:^{
        currentPage = 1;
        [blockSelf requestTaskListReplyWithFlag:0];
        [blockSelf requestTaskQueryWithID:blockSelf.taskId];
        
    }];
    
    [mainTable addInfiniteScrollingWithActionHandler:^{
        currentPage = currentPage + 1;
        [blockSelf requestTaskListReplyWithFlag:1];
    }];
}
-(void)refreshBelowUI:(NSNotification*)noti
{
    if (noti.userInfo) {
        if ([noti.userInfo[@"Status"] isEqualToString:@"CREATED"]) {
            commentBg.hidden=YES;
        }
        else
        {
            commentBg.hidden=NO;
        }
    }
    else
    {
        confirmBtn.hidden = YES;
        commentBg.hidden = NO;
    }
}

-(void)loadConfirmBtn
{
    dispatch_async(dispatch_get_main_queue(), ^{
        confirmBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.frame=CGRectMake(0, boundsHeight-kTabBarHeight-NavBarHeight, boundsWidth, kTabBarHeight);
        confirmBtn.backgroundColor=ContentColor;
        [confirmBtn setTitle:LOCALIZATION(@"confirm_recived") forState:UIControlStateNormal];
        [confirmBtn setTitleColor:MainColor forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:confirmBtn];
    });
}
//create comment
-(void)loadComment
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!commentBg)
        {
            commentBg = [[UIView alloc]initWithFrame:CGRectMake(0, boundsHeight-kTabBarHeight-NavBarHeight, boundsWidth, kTabBarHeight)];
            commentBg.backgroundColor=RGBColor(195, 195, 195);
            [self.view addSubview:commentBg];
            commentTF =[[UITextField alloc]initWithFrame:CGRectMake(EdgeDis, EdgeDis, commentBg.frame.size.width-EdgeDis*3-60, 30)];
            commentTF.borderStyle=UITextBorderStyleRoundedRect;
            commentTF.placeholder=LOCALIZATION(@"input_response");
            commentTF.font=[UIFont systemFontOfSize:13];
            commentTF.textColor=[UIColor grayColor];
            commentTF.backgroundColor=[UIColor whiteColor];
            commentTF.delegate=self;
            [commentBg addSubview:commentTF];
            commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            commentBtn.frame=CGRectMake(commentBg.frame.size.width-EdgeDis-60, commentTF.frame.origin.y, 60, commentTF.frame.size.height);
            [commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [commentBtn setBackgroundColor:MainColor];
            [commentBtn setTitle:LOCALIZATION(@"response") forState:UIControlStateNormal];
            [commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [commentBg addSubview:commentBtn];
            commentBtn.titleLabel.font=[UIFont systemFontOfSize:13];
            commentBtn.layer.cornerRadius=3;
            commentBtn.layer.masksToBounds=YES;
        }
    });
    
}
//取得键盘变化的通知方法
- (void)receiveKeyBoardFrameChange:(NSNotification *)noti{
    NSValue *value = [noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect;
    [value getValue:&rect];
    
    [UIView animateWithDuration:[[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue] animations:^{
        
        [UIView setAnimationCurve:[[noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]integerValue]];
        commentBg.frame = CGRectMake(0, rect.origin.y-kTabBarHeight-NavBarHeight, boundsWidth, kTabBarHeight);
        mainTable.frame = CGRectMake(0, 0, boundsWidth, commentBg.frame.origin.y);
    }];
}
#pragma mark------------confirmBtnClick
-(void)confirmBtnClick:(UIButton*)btn
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"]] forKey:@"token"];
        [parameters setObject:self.taskDetail.taskId forKey:@"taskId"];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodTaskConfirm] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
            if(success && [data isKindOfClass:[NSDictionary class]]){
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"success_commit") isDismissLater:YES];
//                self.taskDetail.userStatus=@"CONFIRMED";
//                self.taskDetail.confirmedUserCount=[NSString stringWithFormat:@"%d",[self.taskDetail.confirmedUserCount integerValue]+1];
//                [self loadComment];
                
                [self requestTaskQueryWithID:self.taskId];
                
                [mainTable.pullToRefreshView stopAnimating];
                [mainTable.infiniteScrollingView stopAnimating];
                [NotiCenter postNotificationName:@"ConfirmTask" object:nil];
                
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
#pragma mark---------requestTaskQueryWithID
-(void)requestTaskQueryWithID:(NSString*)taskId
{
//    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"loading") isDismissLater:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"]] forKey:@"token"];
        [parameters setObject:self.taskId forKey:@"taskId"];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodTaskQuery] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
            if(success && [data isKindOfClass:[NSDictionary class]]){
//                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"data_loaded") isDismissLater:YES];
                TaskQuery *tq=[[TaskQuery alloc]initWithDictionary:data[@"task"]];
                self.taskDetail=tq;
                if ([tq.status isEqualToString:@"FINISHED"]) {
                    [self addFinishView];
                    return;
                }
                else if ([tq.status isEqualToString:@"DELAYED"])
                {
                    [self addDelayView];
                    return;
                }
                if ([self.taskDetail.userStatus isEqualToString:@"CREATED"]) {
                    NSDictionary *dic=[NSDictionary dictionaryWithObject:@"CREATED" forKey:@"Status"];
                    [NotiCenter postNotificationName:@"BelowUI" object:nil userInfo:dic];

                }
                else
                {
                    [NotiCenter postNotificationName:@"BelowUI" object:nil userInfo:nil];
                }
//                [self requestTaskListReplyWithFlag:1];
                [userConfirm removeAllObjects];
                [userUnConfirm removeAllObjects];
                [userUnFinish removeAllObjects];
                [userFinish removeAllObjects];
                for (NSDictionary *dic in data[@"users"]) {
                    UserTaskModel *userTm=[[UserTaskModel alloc]initWithDictionary:dic];
                    if ([userTm.status isEqualToString:@"CONFIRMED"]||[userTm.status isEqualToString:@"DELAYED"]||[userTm.status isEqualToString:@"FINISHED"]) {
                        [userConfirm addObject:userTm];
                    }
                    else
                    {
                        [userUnConfirm addObject:userTm];
                    }
                    if ([userTm.progress integerValue]==100) {
                        [userFinish addObject:userTm];
                    }
                    else
                    {
                        [userUnFinish addObject:userTm];
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
-(void)addFinishView
{
    TaskDetailViewController2 *tvc=[[TaskDetailViewController2 alloc]init];
    self.tModel.status=@"FINISHED";
    self.tModel.userStatus=@"FINISHED";
    tvc.taskDetail=self.tModel;
    [self.view addSubview:tvc.view];
    [self addChildViewController:tvc];
    [[SQLiteManager sharedInstance] updateBoardsStatus:@"FINISHED" withTaskId:self.tModel.taskId withUid:[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"] notificationName:nil];
    [NotiCenter postNotificationName:@"TaskFINISHED" object:nil userInfo:[NSDictionary dictionaryWithObject:self.tModel forKey:@"TModel"]];
}
-(void)addDelayView
{
    TaskDetailViewController2 *tvc=[[TaskDetailViewController2 alloc]init];
    self.tModel.status=@"DELAYED";
    self.tModel.userStatus=@"DELAYED";
    tvc.taskDetail=self.tModel;
    [self.view addSubview:tvc.view];
    [self addChildViewController:tvc];
    [[SQLiteManager sharedInstance] updateBoardsStatus:@"DELAYED" withTaskId:self.tModel.taskId withUid:[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"] notificationName:nil];

}
-(void)reloadDataTable
{
    [mainTable reloadData];
}
#pragma mark-------taskListReply
-(void)requestTaskListReplyWithFlag:(int)flag
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"]] forKey:@"token"];
        [parameters setObject:@(currentPage) forKey:@"page"];
        [parameters setObject:self.taskId forKey:@"taskId"];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodTaskListReply] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
            //            NSLog(@"%@",msg);
            if(success && [data isKindOfClass:[NSDictionary class]]){
                //                NSLog(@"%@",data);
                
                if (flag == 1 && replyArr.count < 10) {
                    
                    return ;
                    
                }
                
                if (flag == 0) {
                    [replyArr removeAllObjects];
                }
                
                if ([data[@"replies"] count] == 0 && flag == 1) {
                    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"no_data")  isDismissLater:YES];
                }
                
                for (NSDictionary *dic in data[@"replies"])
                {
                    ReplyModel *rm=[[ReplyModel alloc]initWithDictionary:dic];
                    [replyArr addObject:rm];
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
//textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [commentBtn setTitle:LOCALIZATION(@"response") forState:UIControlStateNormal];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    commentTF.text=@"";
}
#pragma mark-----commentBtn Click
-(void)commentBtnClick:(UIButton *)btn
{
    if ([commentBtn.titleLabel.text isEqualToString:LOCALIZATION(@"response")])
    {
        NSString *Str = [commentTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *Str1 = [Str stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([commentTF.text isEqualToString:@""] || Str1.length == 0)
        {
            [self.view makeToast:LOCALIZATION(@"input_response")];
            [self.view endEditing:YES];
        }
        else
        {
            [self requestTaskAddReply];
            [self.view endEditing:YES];
        }
        
    }
    else
    {
        
        
    }
}
-(void)requestTaskAddReply
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"]] forKey:@"token"];
        [parameters setObject:self.tModel.taskId forKey:@"taskId"];
        [parameters setObject:@"TEXT" forKey:@"contentType"];
        [parameters setObject:commentTF.text forKey:@"content"];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodTaskAddReply] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
//            NSLog(@"%@",msg);
            if(success && [data isKindOfClass:[NSDictionary class]]){
//                NSLog(@"%@",data);
                [self requestTaskListReplyWithFlag:0];
                [mainTable.pullToRefreshView stopAnimating];
                [mainTable.infiniteScrollingView stopAnimating];
                [NotiCenter postNotificationName:@"TaskAddReply" object:nil];
                [self.view makeToast:LOCALIZATION(@"task_reply_success")];
                
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
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        return replyArr.count;
    }
    if (section==0&&self.taskDetail) {
        return 1;
    }
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (self.taskDetail.attachmentUrl&&[self.taskDetail.contentType isEqualToString:@"VOICE"])
        {
            return 180;
        }
        CGSize constraint=CGSizeMake(boundsWidth-EdgeDis*4, MAXFLOAT);
        CGSize size=[self.tModel.content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
//        CGSize size = [self.taskDetail.content boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        CGFloat height=MAX(size.height+10, 0);
        if (height>25&&[self.taskDetail.contentType isEqualToString:@"TEXT"]) {
            if (self.taskDetail.attachmentUrl) {
                return 100+height+EdgeDis+60*height/25/2;
            }
            return 180+height+EdgeDis;
        }
        if (self.taskDetail.attachmentUrl) {
            return 80+height+80;
        }
        return 80+height;
    }
    return 50;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        NSNumber *currenUid=[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"];
        TableViewCell_taskDetail *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell0"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (UIView *subviews in cell.bgView.subviews) {
            if (subviews.tag>10000) {
                [subviews removeFromSuperview];
            }
        }
        cell.nameLabel.text=([currenUid integerValue] == [self.taskDetail.creatorUid integerValue])?@"我":self.taskDetail.creatorName;
        cell.timeLabel.text=[NSString stringWithFormat:@"%@%@",LOCALIZATION(@"finish_time"),[Common getChineseTimeFrom:[self.taskDetail.plannedFinishTime doubleValue]]];
//         if ([self.taskDetail.contentType isEqualToString:@"TEXT"])[self.tModel.content hasPrefix:@"http:"]
        if ([self.taskDetail.contentType isEqualToString:@"VOICE"])
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
            voiceDurationView.text=[NSString stringWithFormat:@"%@''",self.taskDetail.voiceDuration];
            [voiceView addSubview:voiceDurationView];
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playVoice:)];
            [voiceView addGestureRecognizer:tap];
        }
        else
        {
            cell.contentLabel.hidden=NO;
            cell.contentLabel.text=self.taskDetail.content;
            [cell.contentLabel sizeToFit];

        }
        NSInteger unConfirmNum=[self.taskDetail.userCount integerValue]-userConfirm.count;
        
        NSString *str = [LOCALIZATION(@"Message_allSure") stringByAppendingFormat:@"%@",self.taskDetail.userCount];
        NSString *str1 = [str stringByAppendingString:LOCALIZATION(@"Message_people")];
        
        NSString *str2 = [[NSString alloc]initWithFormat:@"%d",unConfirmNum];
        NSString *str3 = [str2 stringByAppendingString:LOCALIZATION(@"Message_person_not")];
        NSString *str4 = [str3 stringByAppendingFormat:@"%@",self.taskDetail.userCount];
        NSString *str5 = [str4 stringByAppendingString:LOCALIZATION(@"Message_people")];
        
        cell.confirmLabel.text=(userConfirm.count==[self.taskDetail.userCount integerValue])?str1:str5;
        if (self.taskDetail.attachmentUrl) {
            ClickImage * attachImg=[[ClickImage alloc]init];
            attachImg.canClick=YES;
            [attachImg sd_setImageWithURL:[NSURL URLWithString:self.taskDetail.attachmentUrl] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                float scale;
                scale = image.size.width/image.size.height;
                @try{
                    if ([self.taskDetail.contentType isEqualToString:@"VOICE"]) {
                        attachImg.frame=CGRectMake(5, cell.contentLabel.frame.origin.y+cell.contentLabel.frame.size.height+EdgeDis*2+5, 60*scale, 60);
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
        if ([self.taskDetail.userStatus isEqualToString:@"CREATED"]) {
            [cell.statusBtn setTitle:LOCALIZATION(@"task_not_confirm") forState:UIControlStateNormal];
            [cell.statusBtn setBackgroundImage:[UIImage imageNamed:@"bg_red"] forState:UIControlStateNormal];
        }
        else
        {
            [cell.statusBtn setTitle:@"" forState:UIControlStateNormal];
            [cell.statusBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        [cell.personBtn addTarget:self action:@selector(personBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    if (indexPath.section==1) {
        TableViewCell_reply *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell2"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ReplyModel *rm=[replyArr objectAtIndex:indexPath.row];
        cell.nameLabel.text=rm.name;
        cell.contentLabel.text=rm.content;
        cell.timeLabel.text=[Common getChineseTimeFrom:[rm.createTime doubleValue]];
        if (rm.bigpicurl && rm.bigpicurl.length>0) {
            [cell.ivAvatar setImageWithUrl:rm.bigpicurl placeHolder:[Common getImageFromColor:[UIColor colorWithRGBHex:rm.name.hash % 0xffffff]] progress:nil completed:^(UIImage *image) {
                [cell.ivAvatar setImage:image];
            } failureBlock:^(NSError *error) {
                if (rm.name && rm.name.length>0) {
                    cell.labAvatar.text =[rm.name substringToIndex:1];
//                    cell.ivAvatar.image=[UIImage imageNamed:@"default_head"];
                }
            }];
        }else{
            [cell.ivAvatar setImage:[Common getImageFromColor:[UIColor colorWithRGBHex:rm.name.hash % 0xffffff]]];
            if (rm.name && rm.name.length>0){
                cell.labAvatar.text =[rm.name substringToIndex:1];
//                cell.ivAvatar.image=[UIImage imageNamed:@"default_head"];
            }
        }
        
        return cell;
        
    }
    else
    {
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return 25;
    }
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *myView=[[UIView alloc]init];
    myView.backgroundColor=BGColor;
    
    if (section==1) {
        UIImageView *replyImg=[[UIImageView alloc]initWithFrame:CGRectMake(EdgeDis, 0, 24, 24)];
        replyImg.image=[UIImage imageNamed:@"task_reply"];
        [myView addSubview:replyImg];
        UILabel *replyLabel=[[UILabel alloc]initWithFrame:CGRectMake(replyImg.frame.origin.x+replyImg.frame.size.width+EdgeDis, 0, 200, 25)];
        replyLabel.textColor=[UIColor grayColor];
        replyLabel.text=(replyArr.count!=0)?[NSString stringWithFormat:@"%@%lu%@",LOCALIZATION(@"task_all"),(unsigned long)replyArr.count,LOCALIZATION(@"task_reply_num")]:LOCALIZATION(@"no_response");
        replyLabel.font=[UIFont systemFontOfSize:13];
        [myView addSubview:replyLabel];
    }
    return myView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (![self.taskDetail.userStatus isEqualToString:@"CREATED"])
    {
        if (section == 0) {
            return 60;
        }
    }
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ((self.taskDetail)&&![self.taskDetail.userStatus isEqualToString:@"CREATED"])
    {

        if (section == 0) {
            NSString *currenUid=[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"];
            UIView *myView=[[UIView alloc]init];
            myView.backgroundColor=[UIColor whiteColor];
            progressLabel=[[UILabel alloc]init];
            progressLabel.bounds=CGRectMake(0, 0, 50, 21);
            progressLabel.center=CGPointMake(boundsWidth/2, 10);
            progressLabel.textAlignment=NSTextAlignmentCenter;
            progressLabel.textColor=MainColor;
            progressLabel.font=[UIFont systemFontOfSize:12];
            progressLabel.text=[NSString stringWithFormat:@"%@%%",self.taskDetail.progress];

            [myView addSubview:progressLabel];
            progressSlider=[[UISlider alloc]initWithFrame:CGRectMake(EdgeDis*2, progressLabel.frame.size.height, boundsWidth-EdgeDis*6, 20)];
            progressSlider.thumbTintColor=MainColor;
            progressSlider.minimumValue=0.0;
            progressSlider.maximumValue=100.0;
            progressSlider.backgroundColor=[UIColor clearColor];
            progressSlider.userInteractionEnabled=NO;
            //        UIImage *img = [UIImage createImageWithColor:[UIColor hexChangeFloat:@"4683EC"] size:CGSizeMake(30, 30)];
            //        [progressSlider setThumbImage:img forState:UIControlStateNormal];
            progressSlider.value=[self.taskDetail.progress integerValue];
            [myView addSubview:progressSlider];

            UILabel *zeroLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, 50, 20)];
            zeroLabel.text=@"0%";
            zeroLabel.textAlignment=NSTextAlignmentCenter;
            zeroLabel.font=[UIFont systemFontOfSize:12];
            zeroLabel.textColor=[UIColor grayColor];
            [myView addSubview:zeroLabel];
            UILabel *handsLabel=[[UILabel alloc]initWithFrame:CGRectMake(boundsWidth-60, 40, 50, 20)];
            handsLabel.textColor=[UIColor grayColor];
            handsLabel.text=@"100%";
            handsLabel.font=[UIFont systemFontOfSize:12];
            handsLabel.textAlignment=NSTextAlignmentCenter;
            [myView addSubview:handsLabel];
            //        UIImageView *arrowImg=[[UIImageView alloc]initWithFrame:CGRectMake(boundsWidth-30, 15, 30, 30)];
            //        arrowImg.image=[UIImage imageNamed:@"arrow_come"];
            //        [myView addSubview:arrowImg];
            //        UITapGestureRecognizer *arrowTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(finishDetail:)];
            //        [arrowImg addGestureRecognizer:arrowTap];
            UIButton *arrowBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            arrowBtn.frame=CGRectMake(boundsWidth-30, 15, 30, 30);
            [arrowBtn setBackgroundImage:[UIImage imageNamed:@"arrow_come"] forState:UIControlStateNormal];
            [arrowBtn addTarget:self action:@selector(finishDetail:) forControlEvents:UIControlEventTouchUpInside];
            [myView addSubview:arrowBtn];
            if ([currenUid integerValue] != [self.taskDetail.creatorUid integerValue]) {
                progressLabel.text=[NSString stringWithFormat:@"%@%%",self.taskDetail.userProgress];
                lastPV=self.taskDetail.userProgress;
                progressSlider.userInteractionEnabled=YES;
                progressSlider.value=[self.taskDetail.userProgress integerValue];
                [progressSlider addTarget:self action:@selector(sliderChangeClick:) forControlEvents:UIControlEventTouchUpInside];


                //            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                //
                //            [progressSlider addGestureRecognizer:tap];
                UILabel *showLabel=[[UILabel alloc]initWithFrame:CGRectMake(boundsWidth/2-50, zeroLabel.frame.origin.y, 100, zeroLabel.frame.size.height)];
                showLabel.font=[UIFont systemFontOfSize:10];
                showLabel.textColor=[UIColor grayColor];
                showLabel.text=LOCALIZATION(@"slider_right");
                [myView addSubview:showLabel];
            }
            return myView;
        }else{

            UIView *moreView = [[UIView alloc] init];
            UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.5 - 50, -10, 100, 50)];
            [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
            [moreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [moreBtn addTarget:self action:@selector(loadMoreReply:) forControlEvents:UIControlEventTouchUpInside];
            [moreView addSubview:moreBtn];
            return moreView;

        }
    }

    return nil;
}


- (void)loadMoreReply:(UIButton*)btn{
    
    currentPage++;
    [self requestTaskListReplyWithFlag:1];
    
}

-(void)finishDetail:(UITapGestureRecognizer*)tap
{
    UserFinishViewController *uvc=[[UserFinishViewController alloc]init];
    uvc.userFinish=userFinish;
    uvc.userUnFinish=userUnFinish;
    [self.navigationController pushViewController:uvc animated:YES];
}
- (void)tapAction:(UITapGestureRecognizer*)tap{
    
    CGPoint location = [tap locationInView:progressSlider];
    
    CGFloat length = progressSlider.frame.size.width;
    
    CGFloat progress = location.x / length;
    
    progressSlider.value = progress;
    
    NSLog(@"%.2f",progressSlider.value);
    
}
-(CGFloat)ContenLabelHeight
{
    CGSize constraint=CGSizeMake(boundsWidth-EdgeDis*4, 20000);
    CGSize size=[self.taskDetail.content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height=MAX(size.height+10, 0);
    return height+EdgeDis;
}
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
            amrPath = [NSString stringWithFormat:@"%@/%@%d.amr", docDirPath , @"temp0",tap.view.tag];
            filePath = [NSString stringWithFormat:@"%@/%@%d.mav", docDirPath , @"temp0",tap.view.tag];
            [audioData writeToFile:amrPath atomically:YES];
            [OpenCoreAmrManager amrToWav:amrPath wavSavePath:filePath];
        }
        else
        {
            filePath = [NSString stringWithFormat:@"%@/%@%d.mav", docDirPath , @"temp0",tap.view.tag];
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
#pragma mark---------sliderChangeClick
-(void)sliderChangeClick:(UISlider*)sd
{
    progressValue=[NSString stringWithFormat:@"%.0f",sd.value];
    if ([progressValue integerValue]<[lastPV integerValue]+1) {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"task_require") isDismissLater:YES];
        progressLabel.text=[NSString stringWithFormat:@"%@%%",lastPV];
        progressSlider.value=[lastPV integerValue];
        return;
    }
    progressLabel.text=[NSString stringWithFormat:@"%.0f%%",sd.value];
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:LOCALIZATION(@"notice") message:[NSString stringWithFormat:@"%@:%.0f%%",LOCALIZATION(@"pls_confirm"),sd.value] delegate:self cancelButtonTitle:LOCALIZATION(@"discover_cancel") otherButtonTitles:LOCALIZATION(@"confirm"), nil];
    alertView.delegate = self;
    [alertView show];
}
#pragma mark-----------uialertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self updateProgress];
    }
    else
    {
        progressLabel.text=[NSString stringWithFormat:@"%@%%",lastPV];
        progressSlider.value=[lastPV integerValue];
    }
}
-(void)updateProgress
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"]] forKey:@"token"];
        [parameters setObject:self.taskDetail.taskId forKey:@"taskId"];
        [parameters setObject:progressValue forKey:@"progress"];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodTaskUpdateProgress] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
            if(success && [data isKindOfClass:[NSDictionary class]]){
                [NotiCenter postNotificationName:@"UpdateProgress" object:nil];
                lastPV=data[@"item"][@"progress"];
                
                if ([lastPV integerValue]==100) {
                    [self addFinishView];
                }
                else
                {
                    [self requestTaskQueryWithID:self.taskId];
                }
                
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
#pragma mark---scroll
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [commentTF resignFirstResponder];

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
