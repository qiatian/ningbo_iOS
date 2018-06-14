//
//  TableViewCell_reply.m
//  IM
//
//  Created by ZteCloud on 15/11/16.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "TableViewCell_reply.h"

@implementation TableViewCell_reply

- (void)awakeFromNib {
    // Initialization code
    self.ivAvatar.clipsToBounds =YES;
    self.ivAvatar.layer.cornerRadius =0.5*self.ivAvatar.frame.size.height;
    self.contentLabel.font=[UIFont systemFontOfSize:13];
    self.contentLabel.textColor=[UIColor grayColor];
    self.timeLabel.font=[UIFont systemFontOfSize:13];
    self.timeLabel.textColor=[UIColor grayColor];
    self.labAvatar.textColor=[UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
