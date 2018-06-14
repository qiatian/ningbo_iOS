//
//  SalaryTopViewCell.m
//  IM
//
//  Created by 周永 on 15/11/12.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "SalaryTopViewCell.h"
#import "Masonry.h"

@implementation SalaryTopViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel*)salaryLabel{
    
    
    if (!_salaryLabel) {
        
        _salaryLabel = [[UILabel alloc] init];
        _salaryLabel.tag = 100;
        _salaryLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:35];
        _salaryLabel.textAlignment = NSTextAlignmentCenter;
        _salaryLabel.textColor = [UIColor orangeColor];
        [self.contentView addSubview:_salaryLabel];
        
        [_salaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(50);
            make.centerX.equalTo(self.contentView.mas_centerX);
        }];
        
        
        _titleLabel = [[UILabel alloc] init];
//        _titleLabel.text = @"本月工资";
        _titleLabel.font = [UIFont systemFontOfSize:20.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor grayColor];
        [self addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_salaryLabel.mas_bottom);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.width.equalTo(_salaryLabel.mas_width);
        }];
    }
    
    
    return _salaryLabel;
    
}


- (UICollectionView*)detailView{
    
    
    
    if (!_detailView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _detailView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        
        [self.contentView addSubview:_detailView];
        
        [_detailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.top.equalTo(_salaryLabel.mas_bottom).with.offset(100);
        }];
        
    }
    
    
    return _detailView;
    
}


@end
















