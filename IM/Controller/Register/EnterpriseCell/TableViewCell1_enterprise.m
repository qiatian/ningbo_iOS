//
//  TableViewCell1_enterprise.m
//  IM
//
//  Created by ZteCloud on 15/10/12.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "TableViewCell1_enterprise.h"

@implementation TableViewCell1_enterprise

- (void)awakeFromNib {
    // Initialization code
    self.eNameLabel.font=[UIFont systemFontOfSize:13];
    self.eNameLabel.textColor=[UIColor grayColor];
    
    [self.joinBtn setTitleColor:MainColor forState:UIControlStateNormal];
    self.joinBtn.titleLabel.font=[UIFont systemFontOfSize:13];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
