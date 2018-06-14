//
//  NewBoardTypeCell.m
//  IM
//
//  Created by 周永 on 15/11/17.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "NewBoardTypeCell.h"
#import "Masonry.h"

@implementation NewBoardTypeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (UITextField*)textField{
    
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        [self.contentView addSubview:_textField];
        
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.bottom.equalTo(self.contentView).with.offset(-5.0);
            make.top.equalTo(self.contentView.mas_top).with.offset(5.0);
            make.width.equalTo(@(200.0));
        }];
        
    }
    
    return _textField;
    
    
}

@end
