//
//  MeetintListTableViewCell.h
//  IM
//
//  Created by 陆浩 on 15/6/30.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingModel.h"
@interface CommonMeetintListTableViewCell : UITableViewCell

@end


@interface MeetintListTableViewCell : UITableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withType:(BOOL)mainView;

-(void)loadCellWithModel:(MeetingModel *)model;

+(CGFloat)cellHeightWithModel:(id)model;

@end
