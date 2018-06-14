//
//  SalaryBottomViewCell.m
//  IM
//
//  Created by 周永 on 15/11/12.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "SalaryBottomViewCell.h"
#import "Masonry.h"

@implementation SalaryBottomViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (UIImageView*)colorImage{
    
    
    if (!_colorImage) {
        
        _colorImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10.0, self.frame.size.height)];
        
        [self.contentView addSubview:_colorImage];
    }
    
    return _colorImage;
}

- (UILabel*)salaryLabel{
    
    if (!_salaryLabel) {
        _salaryLabel = [[UILabel alloc] init];
        _salaryLabel.textAlignment = NSTextAlignmentRight;
        _salaryLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_salaryLabel];
        
        [_salaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.contentView.mas_top).with.offset(5);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-5);
            make.right.equalTo(self.contentView.mas_right).with.offset(-5);
            
        }];
    }
    
    return _salaryLabel;
    
}

@end
