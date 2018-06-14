//
//  ApproveCell.m
//  IM
//
//  Created by ZteCloud on 15/11/26.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "ApproveCell.h"

@implementation ApproveCell

- (void)awakeFromNib {
    // Initialization code
    self.nameLabel.textColor=MainColor;
    self.bgView.layer.cornerRadius=10;
    self.bgView.layer.masksToBounds=YES;
    self.bgView.layer.borderColor = [UIColor grayColor].CGColor;
    self.bgView.layer.borderWidth = 0.5;
    
    self.timeLabel.textColor=[UIColor grayColor];
    self.typeLabel.textColor=[UIColor grayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
