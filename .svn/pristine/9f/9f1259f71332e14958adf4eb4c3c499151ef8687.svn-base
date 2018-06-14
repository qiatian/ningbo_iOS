//
//  JobViewController.m
//  IM
//
//  Created by ZteCloud on 15/11/9.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "JobViewController.h"
#import "ApproveListViewController.h"
#import "MeetingMainListViewController.h"
#import "TaskViewController.h"
#import "ZTEBoardViewController.h"
#import "ZTEBoardNotificationDataSource.h"
#import "ZTENotificationModal.h"
//#import "ApproveListViewController1.h"
#import "NotiListViewController.h"
#import "OutLinkViewController.h"
#import "BoardViewFlowLayout.h"
#import "TaskDetailViewController.h"
#import "ZTESalaryViewController.h"
@interface JobViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    UITableView *topTableView;
    UIScrollView *btnScrollView;
    UIView *guardView,*guardView1,*taskView,*taskDelayView;
    
    ZTENotificationModal *currentModal;
    NSMutableArray *promptArr,*delayArr;
}



@end

@implementation JobViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.drawerController setupGestureRecognizers];
    appDelegate.centerButton.hidden=NO;
    [appDelegate tabbarController].navigationItem.title = self.tabBarItem.title;
    [[appDelegate tabbarController].navigationItem setRightBarButtonItem:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //监听键盘变化
    [NotiCenter addObserver:self selector:@selector(receiveKeyBoardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLanguageChangedNotification:)
                                                 name:kNotificationLanguageChanged
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillExite:) name:@"AppWillLogout" object:nil];
    [NotiCenter addObserver:self selector:@selector(taskPromtp:) name:@"TaskPrompt" object:nil];
    [NotiCenter addObserver:self selector:@selector(taskDelay:) name:@"TaskDelay" object:nil];
    [NotiCenter addObserver:self selector:@selector(taskFinish:) name:@"TaskFINISHED" object:nil];
    
    [NotiCenter addObserver:self selector:@selector(notifi:) name:@"dealNoti" object:nil];
    
    promptArr =[[NSMutableArray alloc]initWithCapacity:0];
    delayArr =[[NSMutableArray alloc]initWithCapacity:0];
    
    [self setTopTable];
    [self setBelowBtns];

    
}
///////////////////////////////////
- (void)notifi:(NSNotification*)noti{
    
    [topTableView reloadData];
    
    
}

-(void)taskPromtp:(NSNotification*)noti
{
    if (noti) {
        ZTENotificationModal *promptMD=[[ZTENotificationModal alloc]initWithNotificationModal:noti.userInfo contentType:@"3"];
        [promptArr addObject:promptMD];
    }
    if (noti==nil||promptArr.count==1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            ZTENotificationModal *promptMD=[promptArr objectAtIndex:0];
            MyAlertView *alert = [[MyAlertView alloc] initWithFrame:CGRectMake(EdgeDis*2, boundsHeight/2-180, boundsWidth-EdgeDis*4, 180) title:[NSString stringWithFormat:@"%@",LOCALIZATION(@"task_prompt")] message:@"" cancelButtonTitle:[NSString stringWithFormat:@"%@",LOCALIZATION(@"Message_IKnow")] otherButtonTitles:[NSString stringWithFormat:@"%@",LOCALIZATION(@"task_dealwith")] delegate:self isDelay:NO];
            alert.tag = 2;
            alert.nameLabel.text=promptMD.creatorName;
            alert.timeLabel.text=[NSString stringWithFormat:@"%@%@",LOCALIZATION(@"finish_time"),[Common getChineseTimeFrom:[promptMD.plannedFinishTime longLongValue]]];
            if ([promptMD.content hasPrefix:@"http"]) {
                alert.contentLabel.text=[NSString stringWithFormat:@"%@",LOCALIZATION(@"task_voice")];
            }else
            {
                alert.contentLabel.text=[NSString stringWithFormat:@"%@",promptMD.content];
            }
            
            alert.promptLabel.text=[NSString stringWithFormat:@"%@%@%%,%@！",LOCALIZATION(@"task_finished_progress"),promptMD.progress,LOCALIZATION(@"task_prompt_care")];
            [alert showInView:self.view];
        });
        
        
    }
    
}
-(void)createCXAlertView
{
    
//    CXAlertView *delayAV=[[CXAlertView alloc]initWithTitle:@"延迟原因" contentView:[self getContentViewWithModel:nil] cancelButtonTitle:@"忽略"];
//    [delayAV addButtonWithTitle:@"提交" type:CXAlertViewButtonTypeDefault handler:nil];
//    [delayAV show];
    [NSString stringWithFormat:@"%@",LOCALIZATION(@"Message_IKnow")];
    MyAlertView *alert = [[MyAlertView alloc] initWithFrame:CGRectMake(EdgeDis*2, boundsHeight/2-180, boundsWidth-EdgeDis*4, 180) title:@"延期原因" message:@"" cancelButtonTitle:@"知道了" otherButtonTitles:@"立即处理" delegate:self isDelay:NO];
    alert.tag = 1;
    alert.nameLabel.text=@"123";
    alert.timeLabel.text=@"完成时间12月15日15:30";
    alert.contentLabel.text=@"紧急会议紧急会议";
    [alert showInView:self.view];
}
-(void)taskDelay:(NSNotification*)noti
{
    if (noti) {
        ZTENotificationModal *commonModal=[[ZTENotificationModal alloc]initWithNotificationModal:noti.userInfo contentType:@"2"];
        [delayArr addObject:commonModal];
    }
    if (noti==nil||delayArr.count==1) {
         dispatch_async(dispatch_get_main_queue(), ^{
             ZTENotificationModal *commonModal=delayArr[0];
             MyAlertView *alert = [[MyAlertView alloc] initWithFrame:CGRectMake(EdgeDis*2, boundsHeight/2-180, boundsWidth-EdgeDis*4, 260) title:[NSString stringWithFormat:@"%@",LOCALIZATION(@"task_delay_reason")] message:@"" cancelButtonTitle:[NSString stringWithFormat:@"%@",LOCALIZATION(@"task_delay_cancel")] otherButtonTitles:[NSString stringWithFormat:@"%@",LOCALIZATION(@"Message_Submit")] delegate:self isDelay:YES];
             alert.tag = 1;
             alert.nameLabel.text=commonModal.creatorName;
             alert.timeLabel.text=[NSString stringWithFormat:@"%@%@",LOCALIZATION(@"finish_time"),[Common getChineseTimeFrom:[commonModal.plannedFinishTime longLongValue]]];
             if ([commonModal.content hasPrefix:@"http"]) {
                 alert.contentLabel.text=[NSString stringWithFormat:@"%@",LOCALIZATION(@"task_voice")];
             }else
             {
                 alert.contentLabel.text=[NSString stringWithFormat:@"%@",commonModal.content];
             }
             [alert showInView:self.view];
        
         });
        
    }
    
}
#pragma mark-----MyAlertView Delegate
-(void)doSomething:(MyAlertView *)hehe indexInt:(NSInteger)indexInt
{
    
    if (hehe.tag==1) {
        ZTENotificationModal *modal=delayArr[0];
        if (indexInt==1) {
            if ([hehe.resonTV.text isEqualToString:@""]) {
                [self.view endEditing:YES];
                [self.view makeToast:LOCALIZATION(@"task_delay_reson")];
                return;
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
                [parameters setObject:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"]] forKey:@"token"];
                [parameters setObject:@"TEXT" forKey:@"contentType"];
                [parameters setObject:(hehe.resonTV.text)?[NSString stringWithFormat:@"%@:%@",LOCALIZATION(@"task_delay_reason"),hehe.resonTV.text]:[NSString stringWithFormat:@"%@:",LOCALIZATION(@"task_delay_reason")] forKey:@"content"];
                [parameters setObject:modal.taskId forKey:@"taskId"];
                [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodTaskAddReply] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
//                    NSLog(@"%@",msg);
                    if(success && [data isKindOfClass:[NSDictionary class]]){
//                        NSLog(@"%@",data);
                        [hehe removeView];
                        [self.view makeToast:LOCALIZATION(@"success_commit")];
                        
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
        [delayArr removeObjectAtIndex:0];
        if (delayArr.count>0) {
            [self taskDelay:nil];
        }
    }
    else if (hehe.tag==2)
    {
        ZTENotificationModal *model=promptArr[0];
        TaskModel *tm=[[TaskModel alloc]init];
        tm.content=model.content;
        tm.createTime=model.createTime;
        tm.creatorUid=model.creatorUid;
        tm.tenantId=model.tenantId;
        tm.creatorAppocUserId=model.creatorAppocUserId;
        tm.creatorName=model.creatorName;
        tm.isDelayingMessageSent=model.isDelayingMessageSent;
        tm.isDeleted=[model.isDeleted boolValue];
        tm.isNeedNotify=model.isNeedNotify;
        tm.plannedFinishTime=model.plannedFinishTime;
        tm.progress=model.progress;
        tm.status=model.status;
        tm.taskId=model.taskId;
        tm.userCount=model.userCount;
        if (indexInt==1) {
            [hehe removeView];
            TaskDetailViewController *tvc=[[TaskDetailViewController alloc]init];
            tvc.taskId=model.taskId;
            tvc.tModel=tm;
            [self.navigationController pushViewController:tvc animated:YES];
        }
        [promptArr removeObjectAtIndex:0];
        if (promptArr.count>0) {
//            [self performSelectorOnMainThread:@selector(taskPromtp:) withObject:nil waitUntilDone:YES];
            [self performSelector:@selector(taskPromtp:) withObject:nil afterDelay:0.0];
        }
    }
    
}
-(void)taskFinish:(NSNotification*)noti
{
    
}
- (void)appWillExite:(NSNotification*)notif{
    
//    [_notificationDatasource removeObserver:self forKeyPath:@"boardDataArray"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AppWillLogout" object:nil];
    
}
-(void)setTopTable
{
    
    _notificationDatasource = [ZTEBoardNotificationDataSource sharedInstance];
    _notificationDatasource.vc = self;
    
    //KVO 观察boardDataArray的变化
//    [_notificationDatasource addObserver:self forKeyPath:@"boardDataArray" options:NSKeyValueObservingOptionNew context:nil];
    
    CGFloat buttonHeight = boundsHeight>480?114:70;
    topTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight-kTabBarHeight-buttonHeight*2-NavBarHeight) style:UITableViewStyleGrouped];
    topTableView.delegate=_notificationDatasource;
    topTableView.dataSource=_notificationDatasource;

    [self.view addSubview:topTableView];
    
    [Common setExtraCellLineHidden:topTableView];
}


-(void)setBelowBtns
{
//    int top = boundsHeight>480?37:15;
    CGFloat buttonHeight = boundsHeight>480?114:70;
    CGFloat buttonWidth = (boundsWidth / 2);
    
    btnScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, boundsHeight-kTabBarHeight-buttonHeight*2-NavBarHeight, boundsWidth, buttonHeight*2)];
    btnScrollView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:btnScrollView];
    
    NSArray *arr = [NSArray arrayWithObjects:@"board",@"discover_salary",@"task",@"Message_Notification_meeting", nil];
    NSArray *imgArr = [NSArray arrayWithObjects:@"job_blackboard",@"job_policy",@"job_task",@"message_Noti",nil];
    UIButton *btn;
    
    
    for (int i = 0; i < [arr count]; i ++) {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        int index = i%2;
        int row = i/2;
        btn.frame = CGRectMake(index * buttonWidth,row * buttonHeight,buttonWidth+0.5, buttonHeight+0.5);
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[imgArr objectAtIndex:i]]];
        imageView.bounds = CGRectMake(0, 0, 50, 50);
        imageView.center = btn.center;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50 * 0.5;
        [btnScrollView addSubview:imageView];

        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = [BGColor CGColor];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(btnsClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.origin.x,imageView.frame.origin.y + imageView.frame.size.height + 2, buttonWidth, 20)];
        label.tag = i;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor hexChangeFloat:@"909090"];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = LOCALIZATION(arr[i]);
        [btnScrollView addSubview:label];
        [btnScrollView addSubview:btn];
    }
    btnScrollView.contentSize=CGSizeMake(boundsWidth, buttonHeight*arr.count/2);
    
}
//接收到语言切换通知后  设置主页各模块显示的文字
- (void)configureScrollViewLocalString{
    
    NSArray *arr = [NSArray arrayWithObjects:@"board",@"discover_salary",@"task",@"Message_Notification_meeting", nil];
    
    for (int i =0 ; i< btnScrollView.subviews.count; i++) {
        
        UIView *view = btnScrollView.subviews[i];
        
        if ([view isKindOfClass:[UILabel class]]) {
            
            UILabel *label = (UILabel*)view;
            label.text = LOCALIZATION(arr[label.tag]);
        }
    }
}

- (void)btnsClick:(UIButton *)btn
{
    int index = btn.tag - 100;
    switch (index) {
            //        case -1:
            //        {
            //            NSLog(@"添加应用");
            //        }
            //            break;
        case 0:
        {
            //小黑板
            BoardViewFlowLayout *flowLayout = [[BoardViewFlowLayout alloc] init];
            ZTEBoardViewController *blackboardVC = [[ZTEBoardViewController alloc] initWithCollectionViewLayout:flowLayout];
            [self.navigationController pushViewController:blackboardVC animated:YES];
        }
            break;
        case 5:
        {
            NSString *apiPrefix = [NSString stringWithFormat:@"%@",ApiPrefix];
            NSRange suffixRange = [apiPrefix rangeOfString:@"zteim4ios"];
            NSString *apiUse = [apiPrefix substringWithRange:NSMakeRange(0, suffixRange.location)];
            NSString *newURL = [NSString stringWithFormat:@"%@web/form/showFormPage1.aspx",apiUse];
            OutLinkViewController *vc = [[OutLinkViewController alloc] init];
            vc.urlString = [NSString stringWithFormat:@"%@?token=%@&t=%.0f",newURL,[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"],[[NSDate date] timeIntervalSince1970]*1000];
            vc.titleString = LOCALIZATION(@"government");
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 2:
        {
            TaskViewController *tvc=[[TaskViewController alloc]init];
            [self.navigationController pushViewController:tvc animated:YES];
//            UnworkedViewController *unworked =[[UnworkedViewController alloc] initWithNibName:@"UnworkedViewController" bundle:[NSBundle mainBundle]];
//            [self.navigationController pushViewController:unworked animated:YES];
        }
            break;
        case 3:
        {
            //查看通知哟
            NotiListViewController *vc = [[NotiListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        case 1:
        {
            //跳转到工资界面
            ZTESalaryViewController *salaryVC = [[ZTESalaryViewController alloc] init];
            [self.navigationController pushViewController:salaryVC animated:YES];
        }
            break;
        default:
        {
            UnworkedViewController *unworked =[[UnworkedViewController alloc] initWithNibName:@"UnworkedViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:unworked animated:YES];
        }
            break;
    }
}
#pragma mark-------tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    return cell;
}
#pragma mark--------//取得键盘变化的通知方法
- (void)receiveKeyBoardFrameChange:(NSNotification *)noti{
    NSValue *value = [noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect;
    [value getValue:&rect];
    
    [UIView animateWithDuration:[[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue] animations:^{
        
        [UIView setAnimationCurve:[[noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]integerValue]];
        MyAlertView *mv;
        for (UIView *view in self.view.subviews) {
            if ([[view class] isSubclassOfClass:[MyAlertView class]]) {
                mv=(MyAlertView*)view;
            }
        }
        if (rect.origin.y==boundsHeight) {
            taskDelayView.center=CGPointMake(boundsWidth/2, boundsWidth-NavBarHeight);
            mv.center=CGPointMake(boundsWidth/2, boundsHeight/2-NavBarHeight);
        }
        else
        {
            taskDelayView.center = CGPointMake(boundsWidth/2,rect.origin.y-boundsHeight/2+50);
            mv.center=CGPointMake(boundsWidth/2,rect.origin.y-boundsHeight/2+30);
        }
        
    }];
    
    
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
- (void)receiveLanguageChangedNotification:(NSNotification*)notif{
    
    [Localisator sharedInstance].saveInUserDefaults = YES;
    
    if ([notif.name isEqualToString:kNotificationLanguageChanged])
    {
        //刷新界面
        [self configureScrollViewLocalString];
        [topTableView reloadData];
    }
}

@end
