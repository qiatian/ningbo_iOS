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
@interface TaskDetailViewController2 ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate>
{
    UITableView *mainTable;
    NSMutableArray *userFinishs,*userUnfinishs,*userConfirm,*userUnConfirm;
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
    [self requestTaskQueryWithID:self.taskDetail.taskId];
}
-(void)setTableUI
{
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight-NavBarHeight) style:UITableViewStylePlain];
    mainTable.backgroundColor=BGColor;
    mainTable.delegate=self;
    mainTable.dataSource=self;
    //    mainTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTable];
    [mainTable registerNib:[UINib nibWithNibName:@"TableViewCell_taskDetail" bundle:nil] forCellReuseIdentifier:@"Cell0"];
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
    [MMProgressHUD showHUDWithTitle:@"正在加载..." isDismissLater:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"]] forKey:@"token"];
        [parameters setObject:taskId forKey:@"taskId"];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodTaskQuery] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
            NSLog(@"%@",msg);
            if(success && [data isKindOfClass:[NSDictionary class]]){
                NSLog(@"%@",data);
                [MMProgressHUD showHUDWithTitle:@"加载完成" isDismissLater:YES];
                for (NSDictionary *dic in data[@"users"]) {
                    UserTaskModel *userTm=[[UserTaskModel alloc]initWithDictionary:dic];
                    if ([userTm.progress integerValue]!=100) {
                        [userUnfinishs addObject:userTm];
                    }
                    else
                    {
                        [userFinishs addObject:userTm];
                    }
                    if ([userTm.status isEqualToString:@"CONFIRMED"]||[userTm.status isEqualToString:@"DELAYED"]) {
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
                [MMProgressHUD showHUDWithTitle:@"网络请求失败" isDismissLater:YES];
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
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (self.taskDetail.attachmentUrl)
        {
            return 180;
        }
        CGSize constraint=CGSizeMake(boundsWidth-EdgeDis*4, 20000);
        CGSize size=[self.taskDetail.content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat height=MAX(size.height, 0);
        if (height>24) {
            return 180+height+EdgeDis;
        }
        return 80+height;
    }
    return 44;
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
        cell.timeLabel.text=[NSString stringWithFormat:@"完成时间%@",[Common getChineseTimeFrom:[self.taskDetail.plannedFinishTime doubleValue]]];
        cell.contentLabel.text=self.taskDetail.content;
        [cell.contentLabel sizeToFit];
        cell.confirmLabel.text=(self.taskDetail.confirmedUserCount==self.taskDetail.userCount)?[NSString stringWithFormat:@"全部已确认(共%@人)",self.taskDetail.userCount]:[NSString stringWithFormat:@"%@人未确认(共%@人)",self.taskDetail.confirmedUserCount,self.taskDetail.userCount];
        if (self.taskDetail.attachmentUrl) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.taskDetail.attachmentUrl]];
            UIImage *img = [UIImage imageWithData:data];
            float scale;
            scale = img.size.width/img.size.height;
            CGRect rect=CGRectMake(5, cell.contentLabel.frame.origin.y+cell.contentLabel.frame.size.height+EdgeDis, 60*scale, 60);
            ClickImage * attachImg=[[ClickImage alloc]initWithFrame:rect];
            attachImg.canClick=YES;
            [attachImg sd_setImageWithURL:[NSURL URLWithString:self.taskDetail.attachmentUrl] placeholderImage:[UIImage imageNamed:@""]];
            attachImg.tag=10001+indexPath.row;
            [cell.bgView addSubview:attachImg];
        }
        if ([self.taskDetail.isDelayingMessageSent isEqualToString:@"true"]) {
            [cell.statusBtn setTitle:@"已延后" forState:UIControlStateNormal];
            [cell.statusBtn setBackgroundImage:[UIImage imageNamed:@"bg_orange"] forState:UIControlStateNormal];
        }
        else
        {
            [cell.statusBtn setTitle:@"" forState:UIControlStateNormal];
            [cell.statusBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
        if ([self.taskDetail.userStatus isEqualToString:@"CREATED"]) {
            [cell.statusBtn setTitle:@"未确认" forState:UIControlStateNormal];
            [cell.statusBtn setBackgroundImage:[UIImage imageNamed:@"bg_red"] forState:UIControlStateNormal];
        }
        if ([self.taskDetail.userStatus isEqualToString:@"FINISHED"]) {
            [cell.statusBtn setTitle:@"已完成" forState:UIControlStateNormal];
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
        
        UIImageView *replyImg=[[UIImageView alloc]initWithFrame:CGRectMake(EdgeDis, EdgeDis+2, 24, 24)];
        replyImg.image=[UIImage imageNamed:@"task_reply"];
        [cell.contentView addSubview:replyImg];
        UILabel *replyLabel=[[UILabel alloc]initWithFrame:CGRectMake(replyImg.frame.origin.x+replyImg.frame.size.width+EdgeDis, 0, 100, 44)];
        replyLabel.textColor=[UIColor grayColor];
        replyLabel.text=([self.taskDetail.replyCount integerValue]!=0)?[NSString stringWithFormat:@"共有%@条回复",self.taskDetail.replyCount]:@"暂无回复";
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
        UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(boundsWidth-120-EdgeDis, 0, 120, 44)];
        timeLabel.font=[UIFont systemFontOfSize:12];
        timeLabel.textColor=[UIColor grayColor];
        timeLabel.text=[NSString stringWithFormat:@"完成时间%@",[Common getChineseTimeFrom:(long long)um.createTime]];
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
        UILabel *progressLabel=[[UILabel alloc]initWithFrame:CGRectMake(boundsWidth-100-EdgeDis, 0, 100, 44)];
        progressLabel.font=[UIFont systemFontOfSize:12];
        progressLabel.textColor=[UIColor grayColor];
        progressLabel.text=[NSString stringWithFormat:@"完成进度%@%%",um.progress];
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
        finishLabel.text=[NSString stringWithFormat:@"已完成(%d人)",userFinishs.count];
        finishLabel.font=[UIFont systemFontOfSize:13];
        [myView addSubview:finishLabel];
    }
    if (section==3) {
        UILabel *unfinishLabel=[[UILabel alloc]initWithFrame:CGRectMake(EdgeDis, 0, 100, 25)];
        unfinishLabel.textColor=[UIColor grayColor];
        unfinishLabel.text=[NSString stringWithFormat:@"未完成(%d人)",userUnfinishs.count];
        unfinishLabel.font=[UIFont systemFontOfSize:13];
        [myView addSubview:unfinishLabel];
    }
    return myView;
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
    self.navigationItem.title = @"任务详情";
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
}
-(void)clickLeftItem:(id)sender{
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
