//
//  SalaryDetailCell.m
//  IM
//
//  Created by 周永 on 15/11/12.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "SalaryDetailCell.h"
#import "Masonry.h"

@implementation SalaryDetailCell


- (UILabel*)detailSalayLabel{
    
    
    if (!_detailSalayLabel) {
        
        _detailSalayLabel = [[UILabel alloc] init];
        _detailSalayLabel.textAlignment = NSTextAlignmentCenter;
        _detailSalayLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_detailSalayLabel];
        
        [_detailSalayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.contentView.mas_top).with.offset(5.0);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.height.equalTo(@(self.contentView.frame.size.height * 0.5));
        }];

        
    }
    
    
    return _detailSalayLabel;
    
}

- (UILabel*)detailTitleLabel{
    
    
    if (!_detailTitleLabel) {
        
        _detailTitleLabel = [[UILabel alloc] init];
        _detailTitleLabel.textColor = [UIColor grayColor];
        _detailTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_detailTitleLabel];
        
        [_detailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_detailSalayLabel.mas_bottom).with.offset(-5.0);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.height.equalTo(@(self.contentView.frame.size.height * 0.5));
            
        }];
    }
    
    return _detailTitleLabel;
    
}

@end
