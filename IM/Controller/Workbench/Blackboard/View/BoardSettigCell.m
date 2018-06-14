//
//  BoardSettigCell.m
//  IM
//
//  Created by 周永 on 15/11/17.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "BoardSettigCell.h"
#import "Masonry.h"

@implementation BoardSettigCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel*)detailLabel{
    
    
    if (!_detailLabel) {
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        _detailLabel.textColor = [UIColor grayColor];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_detailLabel];
        
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textLabel.mas_top);
            make.bottom.equalTo(self.textLabel.mas_bottom);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10.0);
            make.left.equalTo(self.contentView.mas_left).with.offset(150);
        }];
    }
    
    
    return _detailLabel;
    
}

@end
