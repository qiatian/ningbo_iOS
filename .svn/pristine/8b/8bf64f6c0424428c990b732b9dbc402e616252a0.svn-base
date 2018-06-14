//
//  SettingMessageCell.m
//  Discover
//
//  Created by 周永 on 15/11/6.
//  Copyright © 2015年 shuige. All rights reserved.
//

#import "SettingDetailCell.h"
#import "Masonry.h"


@implementation SettingDetailCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    
    return self;
    
}



- (UISwitch*)setSwitch{
    
    if (!_setSwitch) {
        
        _setSwitch = [[UISwitch alloc] init];
        [_setSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_setSwitch];
        
        [_setSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        }];
   
    }
    
    return _setSwitch;
}
-(void)switchAction:(UISwitch*)setSwitch
{
    BOOL temp = setSwitch.on;
    switch (setSwitch.tag) {
        case 2:
            
            break;
            
        case 0:
        {
            [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%d",temp] forKey:@"shock"];
        }
            break;
            
        case 1:
        {
            [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%d",temp] forKey:@"sound"];
        }
            
            break;
            
        default:
            break;
    }
}

- (UITextField*)passwordTxt{
    
    
    if (!_passwordTxt) {
        
        //要先给titleString赋值!
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = _titleString;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            if (self.indexBtn == 1) {
                make.width.equalTo(@(140.0));  //英文
            }
            else if (self.indexBtn == 2){
                make.width.equalTo(@(95.0));    //中文
            }
            make.left.equalTo (self.contentView).and.offset (10);
        }];
        
        //文本输入框
        _passwordTxt = [[UITextField alloc] init];
        [self.contentView addSubview:_passwordTxt];
        [_passwordTxt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self.contentView);
            self.indexBtn == 1? make.left.equalTo(titleLabel.mas_right).with.offset(5):make.left.equalTo(titleLabel.mas_right).with.offset(15);
        }];
    }
    return _passwordTxt;
    
}


- (UIImageView*)CheckImageView{
    
    if (!_CheckImageView) {
        
        _btnExtensionView = [[UIView alloc] init];
        _btnExtensionView.userInteractionEnabled = YES;
//        _btnExtensionView.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:_btnExtensionView];
        
        [_btnExtensionView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView.mas_top);
            make.right.equalTo(self.contentView.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.width.equalTo(@(self.contentView.frame.size.height + 20));
            
        }];
        
        
        _CheckImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_CheckImageView];
        
        [_CheckImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView.mas_top).with.offset(10.0);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10.0);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10.0);
            make.width.equalTo(@(self.contentView.frame.size.height - 20.0));
            
        }];
        
    }
    
    return _CheckImageView;
}







@end











