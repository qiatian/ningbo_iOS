//
//  ProfileCell.m
//  Discover
//
//  Created by 周永 on 15/11/6.
//  Copyright © 2015年 shuige. All rights reserved.
//

#import "ZTEProfileCell.h"
#import "Masonry.h"

@interface ZTEProfileCell()


@end

@implementation ZTEProfileCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
    }
    
    return self;
    
}


- (UIImageView*)leftHeaderImageView{
    
    if (!_leftHeaderImageView) {
        _leftHeaderImageView = [[UIImageView alloc] init];
        _leftHeaderImageView.layer.masksToBounds = YES;
        _leftHeaderImageView.layer.cornerRadius =  30.0;
//        [_leftHeaderImageView sizeToFit];
        [self.contentView addSubview:_leftHeaderImageView];
        [_leftHeaderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            if (self.accessoryType == UITableViewCellAccessoryNone) {
                make.right.equalTo(self.contentView.mas_right).with.offset(-10);
            }else{
                make.right.equalTo(self.contentView.mas_right);
            }
            make.width.equalTo(@(60.0));
        }];
        
    }
    
    return _leftHeaderImageView;
    
    
}

- (UILabel*)leftInfoLabel{
    
    if (!_leftInfoLabel) {
        _leftInfoLabel = [[UILabel alloc] init];
        _leftInfoLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_leftInfoLabel];
        [_leftInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            if (self.accessoryType == UITableViewCellAccessoryNone) {
                make.right.equalTo(self.contentView.mas_right).with.offset(-10);
            }else{
                make.right.equalTo(self.contentView.mas_right);
            }
            make.width.equalTo(@(220.0));
        }];
    }
    
    return _leftInfoLabel;
    
    
}

- (UITextField*)leftTextField{
    
    
    if (!_leftTextField) {
        _leftTextField = [[UITextField alloc] init];
        //**///////////////////
        _leftTextField.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_leftTextField];
        [_leftTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom);
            if (self.accessoryType == UITableViewCellAccessoryNone) {
                make.right.equalTo(self.contentView.mas_right).with.offset(-10);
            }else{
                make.right.equalTo(self.contentView.mas_right);
            }
            make.width.equalTo(@(220.0));
        }];
    }
    
    return _leftTextField;
    
}

- (void)setCustomAccessoryImage:(UIImage *)customAccessoryImage{
    
    //自定义accessory view
    _customAccessoryImage = customAccessoryImage;
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_deleteButton sizeToFit];
    [_deleteButton setBackgroundImage:customAccessoryImage forState:UIControlStateNormal];

    self.accessoryView = _deleteButton;
    
}


@end









