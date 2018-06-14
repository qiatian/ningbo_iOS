//
//  BoardContentEditCell.m
//  IM
//
//  Created by 周永 on 15/11/16.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "BoardContentEditCell.h"
#import "UITextView+Placeholder.h"
#import "Masonry.h"



@interface BoardContentEditCell()<UITextViewDelegate>



@end

@implementation BoardContentEditCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _titleField = [[UITextField alloc] init];
        _titleField.placeholder = LOCALIZATION(@"board_edittitle");
        [_titleField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        _titleField.textColor = [UIColor redColor];
        _titleField.font = [UIFont systemFontOfSize:20.0];
        _titleField.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleField];
        
        [_titleField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.left.equalTo(self.contentView.mas_left).with.offset(10.0);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10.0);
            make.height.mas_equalTo(@(44.0));
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.userInteractionEnabled = YES;
        lineView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleField.mas_bottom).with.offset(5.0);
            make.left.equalTo(self.contentView.mas_left).with.offset(10.0);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10.0);
            make.height.equalTo(@(1.0));
        }];
        
        _boardTextView = [[UITextView alloc] initWithPlaceholder:LOCALIZATION(@"board_content_placeholder")];
        _boardTextView.font = [UIFont systemFontOfSize:20.0];
//        _boardTextView.delegate = self;
        
        [self.contentView addSubview:_boardTextView];
        
        [_boardTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineView.mas_bottom).with.offset(5.0);
            make.left.right.equalTo(lineView);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10.0);
        }];
    }
    
    return self;
    
}


#pragma mark - textview delegate


- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}


@end
