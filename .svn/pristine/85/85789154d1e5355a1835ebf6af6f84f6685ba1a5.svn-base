//
//  ZTEBoardDetailViewController.m
//  IM
//
//  Created by 周永 on 15/11/17.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "ZTEBoardDetailViewController.h"
#import "BoardDetailCell.h"
#import "NSString+Helpers.h"

@interface ZTEBoardDetailViewController ()

@end

@implementation ZTEBoardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BGColor;
    
    self.title = LOCALIZATION(@"board_detail");
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
}

- (void)clickLeftItem{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - table view datasource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *reuseId = @"Cell";
    
    BoardDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (!cell) {
        cell = [[BoardDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    
    NSMutableString *string = [NSMutableString stringWithString:_boardDetailDict[@"title"]];
    CGSize stringSize = [string boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20 , MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22.0]} context:nil].size;
    
    cell.titleLabel.text = _boardDetailDict[@"title"];
    
    if (stringSize.width > ([UIScreen mainScreen].bounds.size.width - 50)) {
        cell.titleLabel.textAlignment = NSTextAlignmentLeft;
    }else{
        cell.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    cell.contentTextView.text = _boardDetailDict[@"content"];
    cell.deptLabel.text = _boardDetailDict[@"deptName"];
    cell.stampImageView.image = [UIImage imageNamed:@"stamp"];
    
    NSNumber *time = _boardDetailDict[@"createTime"];
        
    cell.timeLabel.text = [NSString timeStringForTimeGettedFromServer:time timeFormatter:@"yyyy-MM-dd"];
    
    return cell;
    
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 300.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}

#pragma mark - private method


@end
