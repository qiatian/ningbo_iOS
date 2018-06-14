//
//  BoardDetailCell.m
//  IM
//
//  Created by 周永 on 15/11/17.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "BoardDetailCell.h"
#import "Masonry.h"

@implementation BoardDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setSubviewsForCell];
        
        
    }
    
    
    return self;
    
    
    
}

- (void)setSubviewsForCell{
    
    //标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:22.0];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor redColor];
//    _titleLabel.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.mas_top).with.offset(5.0);
        make.left.equalTo(self.contentView.mas_left).with.offset(10.0);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10.0);
//        make.height.equalTo(@(50.0));
        
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(5);
        make.left.equalTo(self.contentView.mas_left).with.offset(10.0);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10.0);
        make.height.equalTo(@(2.0));
    }];
    
    //内容
    _contentTextView = [[UITextView alloc] init];
    _contentTextView.font = [UIFont systemFontOfSize:18.0];
    _contentTextView.editable = NO;
    _contentTextView.textColor = [UIColor grayColor];
    [self.contentView addSubview:_contentTextView];
    
    [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(lineView.mas_bottom).with.offset(5.0);
        make.left.equalTo(self.contentView.mas_left).with.offset(10.0);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10.0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-80.0);
        
    }];
    
    _stampImageView = [[UIImageView alloc] init];
    [_stampImageView sizeToFit];
    [self.contentView addSubview:_stampImageView];
    
    [_stampImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.right.equalTo(self.contentView.mas_right).with.offset(-30.0);
        make.bottom.equalTo(self.contentView.mas_bottom);
        
    }];
    
    
    //日期
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_timeLabel];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10.0);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10.0);
        make.width.equalTo(@(100.0));
        
    }];
    
    //部门
    _deptLabel = [[UILabel alloc] init];
    _deptLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_deptLabel];
    
    [_deptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(_timeLabel.mas_top).with.offset(-5.0);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10.0);
        make.width.equalTo(@(100.0));
        
    }];
    
    
}


@end
