//
//  ZTEBoardNotificationController.m
//  IM
//
//  Created by 周永 on 15/11/21.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "ZTEBoardNotificationDataSource.h"
#import "BoardNotificationCell.h"
#import "ZTENotificationModal.h"
#import "ApproveListViewController.h"
#import "ZTEBoardDetailViewController.h"
#import "TaskDetailViewController.h"
#import "TaskDetailViewController2.h"
#import "NSString+Helpers.h"
@interface ZTEBoardNotificationDataSource ()


@end

@implementation ZTEBoardNotificationDataSource

+(instancetype)sharedInstance{
    
    static ZTEBoardNotificationDataSource *shared = nil;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        shared = [[self alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:shared selector:@selector(resetBoardArray:) name:@"AppWillLogout" object:nil];
        
        
    });
    
    return shared;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.boardDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseId = @"Cell";
    
    BoardNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (!cell) {
        cell = [[BoardNotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    ZTENotificationModal *modal = _boardDataArray[self.boardDataArray.count - indexPath.row - 1];
    NSString *contentType = modal.contentType;
    
    
    if (contentType.intValue == 4) {//小黑板
        
        cell.titleLabel.text = modal.title;
        NSNumber *time = [NSNumber numberWithDouble:modal.createTime.longLongValue];
        cell.timeLabel.text = [NSString timeStringForTimeGettedFromServer:time timeFormatter:@"yyyy-MM-dd"];
//        cell.timeLabel.text = [NSString stringWithFormat:@"%@",modal.createTime];
        cell.contentLabel.text = modal.content;
    }
    if ([contentType integerValue]==0) {//申请加入企业
        cell.titleLabel.textColor=MainColor;
        cell.titleLabel.frame=CGRectMake(cell.titleLabel.frame.origin.x, cell.titleLabel.frame.origin.y, 120, cell.titleLabel.frame.size.height);
        cell.titleLabel.text=modal.name;
        [cell.titleLabel sizeToFit];
        cell.timeLabel.text=[NSString timeStringForTimeGettedFromServer:[NSNumber numberWithLongLong:modal.createTime.longLongValue] timeFormatter:@"yyyy-MM-dd"];
        cell.centerLabel.font=[UIFont systemFontOfSize:15];
        cell.centerLabel.text=LOCALIZATION(@"approval_tojoin");
        cell.contentLabel.text=[NSString stringWithFormat:@"%@%@%@",LOCALIZATION(@"approval_mobile"),modal.mobile,LOCALIZATION(@"approval_tojoin")];
        
    }
    if ([contentType integerValue]==1) {//新建任务
//        NSString *currenUid=[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"];
        cell.titleLabel.textColor=MainColor;
        cell.titleLabel.frame=CGRectMake(cell.titleLabel.frame.origin.x, cell.titleLabel.frame.origin.y, 120, cell.titleLabel.frame.size.height);
        cell.titleLabel.text=modal.creatorName;
//        [cell.titleLabel sizeToFit];
        cell.timeLabel.font=[UIFont systemFontOfSize:15];
        cell.timeLabel.text=[NSString timeStringForTimeGettedFromServer:[NSNumber numberWithLongLong:modal.createTime.longLongValue] timeFormatter:@"yyyy-MM-dd"];;
//        cell.centerLabel.font=[UIFont systemFontOfSize:15];
//        cell.centerLabel.text=[NSString stringWithFormat:@"%@%@",LOCALIZATION(@"task_finish_time"),[Common getChineseTimeFrom:[modal.plannedFinishTime longLongValue]]];
        if ([modal.content hasPrefix:@"http"]) {
            cell.contentLabel.text=[NSString stringWithFormat:@"%@",LOCALIZATION(@"task_voice")];
        }else
        {
            cell.contentLabel.text=[NSString stringWithFormat:@"%@",modal.content];
        }
        
        
    }
    
    
    return cell;
}
#pragma mark - Table view data delegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    
    return 70.0;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //新的信息显示在上面 反过来显示
    ZTENotificationModal *model = _boardDataArray[self.boardDataArray.count - indexPath.row - 1];
    
    NSString *contentType = model.contentType;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (contentType.intValue == 4) {//小黑板
        
        [dict setValue:model.content forKey:@"content"];
        [dict setValue:model.title forKey:@"title"];
        [dict setValue:model.createTime forKey:@"createTime"];
        [dict setValue:model.deptName forKey:@"deptName"];
        
        ZTEBoardDetailViewController *detailVC = [[ZTEBoardDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
        detailVC.boardDetailDict = dict;
        
        [self.vc.navigationController pushViewController:detailVC animated:YES];
        
    }
    if ([contentType integerValue]==0) {
        ApproveListViewController *avc=[[ApproveListViewController alloc]init];
        [self.vc.navigationController pushViewController:avc animated:YES];
    }
    
    if ([contentType integerValue]==1) {
        ZTENotificationModal *zm=[[SQLiteManager sharedInstance] getTaskModelWithTaskId:model.taskId];
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
        tm.status=zm.status;
        tm.taskId=model.taskId;
        tm.userCount=model.userCount;
        if ([model.content hasPrefix:@"http"]) {
            tm.contentType=@"VOICE";
        }
        else
        {
            tm.contentType=@"TEXT";
        }
        if ([zm.status isEqualToString:@"DELAYED"]||[zm.status isEqualToString:@"FINISHED"]) {
            TaskDetailViewController2 *tvc=[[TaskDetailViewController2 alloc]init];
            tvc.taskDetail=tm;
            [self.vc.navigationController pushViewController:tvc animated:YES];
        }
        else
        {
            TaskDetailViewController *tvc=[[TaskDetailViewController alloc]init];
            tvc.taskId=model.taskId;
            tvc.tModel=tm;
            [self.vc.navigationController pushViewController:tvc animated:YES];
        }
    }
}
#pragma mark - setter & getter

- (NSMutableArray*)boardDataArray{
    
    if (!_boardDataArray) {
        
        NSString *uid = [ConfigManager sharedInstance].userDictionary[@"uid"];
        
        _boardDataArray = [[SQLiteManager sharedInstance] getAllBoardsFromSQLiteWithTarget:uid];
        
    }
    
    return _boardDataArray;
}


- (void)resetBoardArray:(NSNotification*)notif{
    
    _boardDataArray = nil;
    
}

@end

















