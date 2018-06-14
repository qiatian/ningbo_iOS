//
//  UnfoldViewCell.m
//  IM
//
//  Created by 周永 on 15/11/13.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "UnfoldViewCell.h"
#import "Masonry.h"

@implementation UnfoldViewCell


- (UILabel*)detailTitleLabel{
    
    
    if (!_detailTitleLabel) {
        
        _detailTitleLabel = [[UILabel alloc] init];
        _detailTitleLabel.textAlignment = NSTextAlignmentLeft;
        _detailTitleLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_detailTitleLabel];
        
        [_detailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.left.equalTo(self.contentView.mas_left).with.offset(15);
            make.height.equalTo(@(self.contentView.frame.size.height));
            make.width.equalTo(@(self.contentView.frame.size.width * 0.5));
        }];
        
        
        _detailSalayLabel = [[UILabel alloc] init];
        _detailSalayLabel.textColor = [UIColor grayColor];
        _detailSalayLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_detailSalayLabel];
        
        [_detailSalayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_detailTitleLabel.mas_top);
            make.right.equalTo(self.contentView.mas_right).with.offset(-15);
            make.height.equalTo(_detailTitleLabel.mas_height);
            make.width.equalTo(_detailTitleLabel.mas_width);
        }];
        
        
    }
    
    
    return _detailTitleLabel;
    
}

@end
