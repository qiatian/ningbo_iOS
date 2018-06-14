//
//  BoardViewCell.m
//  IM
//
//  Created by 周永 on 15/11/16.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "BoardViewCell.h"
#import "Masonry.h"

#define GapBetweenLabel 10.0
#define LabelHeight (self.contentView.frame.size.height / 3)

@implementation BoardViewCell


- (UILabel*)deptLabel{
    
    if (!_deptLabel) {
        
        _deptLabel = [[UILabel alloc] init];
        _deptLabel.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:_deptLabel];
        
        [_deptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(GapBetweenLabel);
            make.top.equalTo(self.contentView.mas_top).with.offset(GapBetweenLabel - 5.0);
            make.size.mas_equalTo(CGSizeMake((self.contentView.frame.size.width * 0.2), LabelHeight));
            
        }];
    }
    
    return _deptLabel;
}

- (UILabel*)createTimeLabel{
    
    if (!_createTimeLabel) {
        
        _createTimeLabel = [[UILabel alloc] init];
        _createTimeLabel.textColor = [UIColor grayColor];
        
        UIDevice *device = [UIDevice currentDevice];
        
        if (![device.systemVersion floatValue] < 8.0) {
            _createTimeLabel.font = [UIFont systemFontOfSize:13.0];
        }
        
        [self.contentView addSubview:_createTimeLabel];
        
        [_createTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_deptLabel.mas_right).with.offset(GapBetweenLabel);
            make.top.equalTo(self.contentView.mas_top).with.offset(GapBetweenLabel - 5.0);
            make.height.equalTo(@(LabelHeight));
            make.right.equalTo(self.contentView.mas_right).with.offset(-120.0);
        }];
        
    }
    
    return _createTimeLabel;
}

- (UIImageView*)imageView{
    
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        _imageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView.mas_top);
            make.right.equalTo(self.contentView.mas_right).with.offset(5);
            make.width.equalTo(@(120.0));
            make.height.equalTo(@(LabelHeight * 0.8));
            
        }];
        
    }
    
    return _imageView;
}

- (UILabel*)typeLabel{
    
    if (!_typeLabel) {
        
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = [UIFont systemFontOfSize:15.0];
        _typeLabel.textColor = [UIColor whiteColor];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.clipsToBounds = YES;
        [self.imageView addSubview:_typeLabel];
        
        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.imageView);
        }];
        
    }
    
    return _typeLabel;
}




- (UILabel*)titleLabel{
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:20.0];
        _titleLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:_titleLabel];
        
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_deptLabel.mas_left);
            make.top.equalTo(_deptLabel.mas_bottom).with.offset(-5.0);
            make.height.equalTo(@(LabelHeight));
            make.right.equalTo(self.contentView.mas_right).with.offset(-GapBetweenLabel);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = BGColor;
        [self.contentView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom);
            make.right.equalTo(self.contentView.mas_right).with.offset(-GapBetweenLabel);
            make.left.equalTo(self.contentView.mas_left).with.offset(GapBetweenLabel);
            make.height.equalTo(@(1.0));
        }];
    }
    
    return _titleLabel;
}




- (UILabel*)contentLabel{
    
    if (!_contentLabel) {
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = [UIFont systemFontOfSize:15.0];
        _contentLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(GapBetweenLabel);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.right.equalTo(self.contentView.mas_right).with.offset(-50.0);
            make.height.equalTo(@(LabelHeight));
        }];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"enter"]];
//        [imageView sizeToFit];
        [self.contentView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.equalTo(_contentLabel.mas_top);
            make.bottom.equalTo(_contentLabel.mas_bottom);
            make.right.equalTo(self.contentView.mas_right);
            make.width.equalTo(@(LabelHeight));
            
            
        }];
        
        
    }
    
    return _contentLabel;
}

@end
