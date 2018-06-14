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
#import "NSString+Helpers.h"
#import "ZTEBoardDetailViewController.h"

@interface ZTEBoardNotificationDataSource ()

@property (nonatomic, strong) UITextView *cscTextView;

@end

@implementation ZTEBoardNotificationDataSource

+(instancetype)sharedInstance{
    
    static ZTEBoardNotificationDataSource *shared = nil;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        shared = [[self alloc] init];
        
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
    }
    
    ZTENotificationModal *modal = _boardDataArray[self.boardDataArray.count - indexPath.row - 1];

    
    if (modal.contentType.intValue == 4) {//小黑板
        
        cell.titleLabel.text = modal.title;
        cell.timeLabel.text = [NSString timeStringForTimeGettedFromServer:[NSNumber numberWithDouble:modal.createTime.doubleValue] timeFormatter:@"yyyy-MM-dd"];
        cell.contentLabel.text = modal.content;
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    
}

#pragma mark - setter & getter

- (NSMutableArray*)boardDataArray{
    
    if (!_boardDataArray) {
        
        _boardDataArray = [[SQLiteManager sharedInstance] getAllBoardsFromSQLite];
        
    }
    
    return _boardDataArray;
}


@end

















