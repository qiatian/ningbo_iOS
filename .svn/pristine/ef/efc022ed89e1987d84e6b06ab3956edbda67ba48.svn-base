//
//  NotiDetailViewController.m
//  IM
//
//  Created by 陆浩 on 15/5/20.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "NotiDetailViewController.h"
#import "NotiListTableViewCell.h"
#import "AllMettingUserViewController.h"
#import "RefuseReasonViewController.h"
#import "NotiModel.h"

@interface NotiDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *notiTableView;
    NSMutableDictionary *allUserDic;
    BOOL isMine;//这个会议是我的创建的么？？
    UIView *bottomView;
    NotiDetailModel *detailModel;
    NotiUserModel *model1;
    NSString *str2;
}

@end

@implementation NotiDetailViewController

@synthesize notiId;
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LOCALIZATION(@"Message_Details_meeting");
    self.view.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
    
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    
    notiTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, viewWithNavNoTabbar)];
    notiTableView.backgroundColor = [UIColor clearColor];
    notiTableView.dataSource = self;
    notiTableView.delegate = self;
    notiTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:notiTableView];
    notiTableView.hidden = YES;
    NSString *myGId = [[ConfigManager sharedInstance].userDictionary objectForKey:@"gid"];
    allUserDic = [NSMutableDictionary dictionaryWithDictionary:[[SQLiteManager sharedInstance] getAllUserByGid:myGId]];
    
    [self getNotisFromServer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotisFromServer) name:@"NotiStatusChangeNotification" object:nil];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickLeftItem:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)configureBottomView
{
    //    if(!isMine && detailModel.dealStatus)
    //    {
    //        //如果会议接受者返回值有这个则说明操作过了，操作过了，就不允许再操作了
    //        return;
    //    }
    //    if(isMine && [detailModel.status intValue] == 2)
    //    {
    //        //如果会议发起者返回状态是已取消，则这个会议不再可以操作
    //        return;
    //    }
    
    
    
    // 判断是否过期的判断
    //if([detailModel.startTime longLongValue]/1000 >= [[NSDate date] timeIntervalSince1970])
      
     if([detailModel.status intValue] != 0)
    {
        [bottomView removeFromSuperview];
        
        //没有过期，可以执行事件，过期了或者执行过事件之后还执行个jb事件
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, viewWithNavNoTabbar-60, boundsWidth, 60)];
        bottomView.backgroundColor = [UIColor clearColor];
        
        UIButton *bottomLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        bottomLeftButton.frame = CGRectMake(10, 10, (boundsWidth-30)/2, 40);
        bottomLeftButton.backgroundColor = [UIColor hexChangeFloat:@"ee6261"];
        bottomLeftButton.layer.masksToBounds = YES;
        bottomLeftButton.layer.cornerRadius = 6;
        [bottomLeftButton addTarget:self action:@selector(bottomLeftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:bottomLeftButton];
        
        UIButton *bottomRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        bottomRightButton.frame = CGRectMake(bottomLeftButton.frame.size.width+bottomLeftButton.frame.origin.x+10, 10, (boundsWidth-30)/2, 40);
        bottomRightButton.backgroundColor = [UIColor hexChangeFloat:@"76d659"];
        bottomRightButton.layer.masksToBounds = YES;
        bottomRightButton.layer.cornerRadius = 6;
        [bottomRightButton addTarget:self action:@selector(bottomRightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:bottomRightButton];
        
        if ([detailModel.status isEqualToString:@"2"] || [detailModel.dealStatus isEqualToString:@"a"] || [detailModel.dealStatus isEqualToString:@"r"]){
            bottomRightButton.hidden = YES;
            bottomLeftButton.hidden = YES;
            
        }else if(isMine)
        {
            [bottomLeftButton setTitle:LOCALIZATION(@"Message_cancelMeeting") forState:UIControlStateNormal];
            [bottomRightButton setTitle:LOCALIZATION(@"Message_key_reminder") forState:UIControlStateNormal];
        }
        else
        {
            [bottomLeftButton setTitle:LOCALIZATION(@"Message_DetailRefuse") forState:UIControlStateNormal];
            [bottomRightButton setTitle:LOCALIZATION(@"Message_DetailAgree") forState:UIControlStateNormal];
        }
        
        [self.view addSubview:bottomView];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 60)];
        view.backgroundColor = [UIColor clearColor];
        notiTableView.tableFooterView = view;
    }
}

-(void)bottomLeftButtonClick:(UIButton *)sender
{
    RefuseReasonViewController * rv = [[RefuseReasonViewController alloc]init];
    if(isMine)
    {
        if(detailModel.status && [detailModel.status intValue] == 2)
        {
            [self.view makeToast:LOCALIZATION(@"Message_You_canceled_the_notice")];
            return;
        }
        //取消会议
        rv.isCancelNoti = YES;
    }
    else
    {
        if(detailModel.dealStatus && [detailModel.dealStatus isEqualToString:@"r"])
        {
            [self.view makeToast:LOCALIZATION(@"Message_You_refused_the_notice")];
            return;
        }
        //拒绝
        rv.isCancelNoti = NO;
    }
    rv.noticId = self.notiId;
    [self.navigationController pushViewController:rv animated:YES];
}

-(void)bottomRightButtonClick:(UIButton *)sender
{
    if(isMine)
    {
        if(detailModel.status && [detailModel.status intValue] == 2)
        {
            [self.view makeToast:LOCALIZATION(@"Message_You_canceled_the_notice_noMes")];
            return;
        }
        //一键通知
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_sending_reminders") isDismissLater:NO];
        NSDictionary * datadic = [NSDictionary dictionaryWithObjectsAndKeys:[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"],@"token",[NSString stringWithFormat:@"%@",self.notiId],@"informId", nil];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodRemindInform] parameters:datadic successBlock:^(BOOL success, id data, NSString *msg) {
            if(success)
            {
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_remind_success") isDismissLater:YES];
            }
            else
            {
                [MMProgressHUD showHUDWithTitle:msg isDismissLater:YES];
            }
        } failureBlock:^(NSString *description) {
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"network_failed") isDismissLater:YES];
        }];
    }
    else
    {
        if(detailModel.dealStatus && [detailModel.dealStatus isEqualToString:@"a"])
        {
            [self.view makeToast:LOCALIZATION(@"Message_accepted_the_notice")];
            return;
        }
        //同意
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_receiving_notification") isDismissLater:NO];
        NSDictionary * datadic = [NSDictionary dictionaryWithObjectsAndKeys:[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"],@"token",[NSString stringWithFormat:@"%@",self.notiId],@"informId", nil];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodAcceptInform] parameters:datadic successBlock:^(BOOL success, id data, NSString *msg) {
            if(success)
            {
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_accepted_success") isDismissLater:YES];
                [self getNotisFromServer];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotiStatusChangeNotification" object:nil];
            }
            else
            {
                [MMProgressHUD showHUDWithTitle:msg isDismissLater:YES];
            }
        } failureBlock:^(NSString *description) {
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"network_failed") isDismissLater:YES];
        }];
    }
}

#pragma mark -
#pragma mark - UITableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row < 5)
        {
            return 44;
        }
        else
        {
            return [NotiDetailUserTableViewCell heightCellForRow:isMine];
        }
    }
    else if(indexPath.section == 1)
    {
        return [NotiExternTableViewCell heightCellForRow:detailModel.remark];
    }
    else
    {
        return 44;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!detailModel)
    {
        return 0;
    }
    if(section == 0)
    {
        return 6;
    }
    if(section == 2){
        if([detailModel.status intValue] == 2 || [detailModel.dealStatus isEqualToString:@"r"]){
            return 2;
            
        }
        if ([detailModel.status intValue] == 1 || [detailModel.status intValue] == 0) {
            return 1;
        }
            
        
        }
    
    else
    {
        return 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(isMine)
    {
        return 3;
    }
    else
    {
        return 3;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 20)];
        view.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 40, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = LOCALIZATION(@"Message_note");
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        [view addSubview:titleLabel];
        return view;
    }
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 0;
    }
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row<5)
        {
            static NSString *CellIdentifier = @"NotiDetailTableViewCell";
            NotiDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[NotiDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.backgroundColor=[UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            NSString *title = @"";
            NSString *subTitle = @"";
            switch (indexPath.row) {
                case 0:
                    title = LOCALIZATION(@"Message_subject");
                    subTitle = detailModel.title;
                    break;
                case 1:
                {
                    NSString *hostName = @"";
                    if(isMine)
                    {
                        hostName = [ConfigManager sharedInstance].userDictionary[@"name"];
                    }
                    else
                    {
                        MEnterpriseUser *mu = [allUserDic objectForKey:[NSString stringWithFormat:@"%@",detailModel.creator]];
                        hostName = mu.uname;
                    }
                    title = LOCALIZATION(@"Message_compere");
                    subTitle = hostName;
                }
                    break;
                case 2:
                {
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[detailModel.startTime longLongValue]/1000];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"MM-dd HH:mm"];
                    title = LOCALIZATION(@"Message_start");
                    subTitle = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
                }
                    break;
                case 3:
                {
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[detailModel.endTime longLongValue]/1000];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"MM-dd HH:mm"];
                    title = LOCALIZATION(@"Message_Ending");
                    subTitle = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
                }
                    break;
                case 4:
                {
                    title = LOCALIZATION(@"Message_adress");
                    subTitle = detailModel.address;
                }
                    break;
                    
                default:
                    break;
            }
            [cell loadCellWithTitle:title subTitle:subTitle];
            return cell;
        }
        else
        {
            static NSString *CellIdentifier = @"NotiDetailUserTableViewCell";
            NotiDetailUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[NotiDetailUserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.backgroundColor=[UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell loadCellWithAgreeNum:[detailModel.accepted intValue] refuseNum:[detailModel.refused intValue] waitNum:[detailModel.waitted intValue] totalNum:[detailModel.users_array count] isMine:isMine];
            return cell;
        }
    }
    else if (indexPath.section == 1)
    {
        
        static NSString *CellIdentifier = @"NotiExternTableViewCell";
        NotiExternTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[NotiExternTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell loadCellWithString:detailModel.remark];
        return cell;
    }
    else
    {
        
        if ([detailModel.status intValue] == 2){
            if (indexPath.row == 0) {
                static NSString *CellIdentifier = @"NotiDetailTableViewCell";
                NotiDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil)
                {
                    cell = [[NotiDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.backgroundColor=[UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                [cell loadCellWithModel:detailModel isMine:isMine];
                return cell;
            }
            if (indexPath.row == 1) {
                static NSString *CellIdentifier = @"NotiDetailTableViewCell";
                NotiDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil)
                {
                    cell = [[NotiDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.backgroundColor=[UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
                    cell.textLabel.textColor = [UIColor grayColor];
                }
                //cell.textLabel.text = LOCALIZATION(@"Message_cancel_reason");
                NSString *str = LOCALIZATION(@"Message_cancel_reason");
                NSString *str1 = [str stringByAppendingFormat:@" %@",detailModel.cancelpurpose];
                cell.textLabel.text = str1;
                return cell;
                
            }
            
            //            if ([_mettingUserArray[indexPath.row] isKindOfClass:[NotiUserModel class]]) {
            //                NotiUserModel * model = _mettingUserArray[indexPath.row];
            //                if ([model.status isEqualToString:@"r"] && [model.remark length] != 0)
            
        } else if ([detailModel.dealStatus isEqualToString:@"r"]){
            if (indexPath.row == 0) {
                static NSString *CellIdentifier = @"NotiDetailTableViewCell";
                NotiDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil)
                {
                    cell = [[NotiDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.backgroundColor=[UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                [cell loadCellWithModel:detailModel isMine:isMine];
                return cell;
            }
            if (indexPath.row == 1) {
                static NSString *CellIdentifier = @"NotiDetailTableViewCell";
                NotiDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil)
                {
                    cell = [[NotiDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.backgroundColor=[UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
                    cell.textLabel.textColor = [UIColor grayColor];
                }
                //cell.textLabel.text = LOCALIZATION(@"Message_cancel_reason");
                NSString *str = LOCALIZATION(@"Message_Refuse_reason");
                
                NSString *str1 = [str stringByAppendingFormat:@": %@",str2];
                cell.textLabel.text = str1;
                return cell;
            }
             
        }else if ([detailModel.status intValue] == 1 || [detailModel.status intValue] == 0 ) {
            
            static NSString *CellIdentifier = @"NotiDetailTableViewCell";
            NotiDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[NotiDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.backgroundColor=[UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell loadCellWithModel:detailModel isMine:isMine];
            return cell;
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 5)
    {
        //查看所有人员   //参会人员详情 待修改。
        AllMettingUserViewController *vc = [[AllMettingUserViewController alloc] init];
        vc.mettingUserArray = detailModel.users_array;
        vc.isMineMetting = isMine;
        vc.forSelectUser = YES;
        vc.canDeleteFirstUser = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark -
#pragma mark - Net Request
-(void)getNotisFromServer
{
    NSString *token = [[ConfigManager sharedInstance].userDictionary  objectForKey:@"token"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:notiId,@"informId",token,@"token", nil];
    [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodGetInform] parameters:dic successBlock:^(BOOL success, id data, NSString *msg) {
        NSLog(@"%@",data);
        
         //取出拒绝的原因
        if(data[@"rejectPurpose"]&&[data[@"rejectPurpose"]isKindOfClass:[NSString class]]){
            str2 = data[@"rejectPurpose"];
        }
        
        if(data[@"item"]&&[data[@"item"] isKindOfClass:[NSArray class]])
        {
            if([data[@"item"] count])
            {
                detailModel = [[NotiDetailModel alloc] initWithDictionary:data[@"item"][0] error:nil];
                
                model1 = [[NotiUserModel alloc] initWithDictionary:data[@"users"][0] error:nil];
                
                if ([detailModel.status isEqualToString:@"2"]) {
                    
                    if (!self.cancelAlert && [Common isControllerVisible:self.navigationController]) {
                        self.cancelAlert = [[UIAlertView alloc] initWithTitle:LOCALIZATION(@"Message_Tshi") message:LOCALIZATION(@"Message_The_metting_canceld") delegate:self cancelButtonTitle:LOCALIZATION(@"Message_CXAlertView_title3") otherButtonTitles:nil, nil];
                        self.cancelAlert.tag = 6001;
                        [self.cancelAlert show];
                    }
                    
                } else {
                    if([detailModel.creator longLongValue] == [[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"] longLongValue])
                    {
                        isMine = YES;
                    }
                    else
                    {
                        isMine = NO;
                    }
                }
                
                
            }
        }
        if(data[@"users"]&&[data[@"users"] isKindOfClass:[NSArray class]])
        {
            [detailModel.users_array removeAllObjects];
            NSMutableArray *userArray = [NSMutableArray arrayWithArray:data[@"users"]];
            for(NSDictionary * dic in userArray)
            {
                NotiUserModel *model = [[NotiUserModel alloc] initWithDictionary:dic error:nil];
                [detailModel.users_array addObject:model];
            }
        }
        notiTableView.hidden = NO;
        [notiTableView reloadData];
        [self configureBottomView];
    } failureBlock:^(NSString *description) {
        NSLog(@"网络请求失败");
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 6001) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

@end
