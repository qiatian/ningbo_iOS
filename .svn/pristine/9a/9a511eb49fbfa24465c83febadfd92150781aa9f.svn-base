//
//  UserHeaderCell.m
//  IM
//
//  Created by 周永 on 15/11/19.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "UserHeaderCell.h"
#import "Masonry.h"

@implementation UserHeaderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (UIImageView*)headerImageView{
    
    
    if (!_headerImageView) {
        
        CGFloat width = 60.0;
        
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.layer.cornerRadius = width * 0.5;
        [self.contentView addSubview:_headerImageView];
        
        [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(10.0);
            make.left.equalTo(self.contentView.mas_left).with.offset(10.0);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10.0);
            make.width.equalTo(@(width));
        }];
        
    }
    
    return _headerImageView;
    
}

- (UILabel*)titleLabel{
    
    
    if (!_titleLabel) {
        
        CGFloat height = self.contentView.frame.size.height - 2 * 10.0;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:20.0];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerImageView.mas_top);
            make.left.equalTo(_headerImageView.mas_right).with.offset(8.0);
            make.right.equalTo(self.contentView.mas_right);
            make.height.equalTo(@(height));
        }];
        
    }
    return _titleLabel;
}



- (UILabel*)autograpLabel{
    
    
    if (!_autograpLabel) {
        
        CGFloat height = self.contentView.frame.size.height - 2 * 10.0;
        
        _autograpLabel = [[UILabel alloc] init];
        _autograpLabel.font = [UIFont systemFontOfSize:15.0];
        _autograpLabel.textColor = [UIColor grayColor];
        _autograpLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_autograpLabel];
        
        [_autograpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).with.offset(10.0);
            make.left.equalTo(_headerImageView.mas_right).with.offset(10.0);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10.0);
            make.height.equalTo(@(height));
        }];
        
    }
    
    return _autograpLabel;
    
    
}

@end
