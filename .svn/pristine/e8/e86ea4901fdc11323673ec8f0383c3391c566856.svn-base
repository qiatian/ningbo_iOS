//
//  NotiListTableViewCell.h
//  IM
//
//  Created by 陆浩 on 15/5/20.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotiModel.h"

@interface NotiListTableViewCell : UITableViewCell

-(void)loadCellWithDic:(NotiListModel *)model withHostName:(NSString *)name;

@end

@interface NotiDetailTableViewCell : UITableViewCell

-(void)loadCellWithTitle:(NSString *)title subTitle:(NSString *)subTitle;

-(void)loadCellWithModel:(NotiDetailModel *)model isMine:(BOOL)isMine;

@end

@interface NotiDetailUserTableViewCell : UITableViewCell

-(void)loadCellWithAgreeNum:(int)agreeNum refuseNum:(int)refuseNum waitNum:(int)waitNum totalNum:(int)totalNum isMine:(BOOL)isMine;

+(CGFloat)heightCellForRow:(BOOL)isMine;

@end


@interface NotiUserListTableViewCell : UITableViewCell

@property(nonatomic,assign)BOOL isMine;

@property(nonatomic,strong)UIButton *styleSelectButton;  //参加会议人员的cell后面的圆圈

-(void)loadCellWithDic:(id)userDic;

@end

@interface NotiExternTableViewCell : UITableViewCell

-(void)loadCellWithString:(NSString *)string;

+(CGFloat)heightCellForRow:(NSString *)string;

@end







