//
//  EditUserTableViewCell.m
//  IM
//
//  Created by  pipapai_tengjun on 15/6/28.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "EditUserTableViewCell.h"
#import "Common.h"
#define ScreenWidth    [UIScreen mainScreen].bounds.size.width

@implementation EditUserTableViewCell
@synthesize nameLabel,headView,lineView,rightView,headLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        nameLabel = [[UILabel alloc]init];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:nameLabel];
        
        headView = [[GQLoadImageView alloc]init];
        [self.contentView addSubview:headView];
        
        headLabel = [[UILabel alloc] init];
        headLabel.textAlignment = NSTextAlignmentCenter;
        headLabel.textColor = [UIColor whiteColor];
        headLabel.font = [UIFont systemFontOfSize:24.0];
        headLabel.backgroundColor = [UIColor clearColor];
        [headView addSubview:headLabel];
        
        rightView = [[UIImageView alloc]init];
        rightView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:rightView];

        lineView = [[UIImageView alloc]init];
        lineView.backgroundColor = [UIColor hexChangeFloat:@"e7e7e7"];
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)loadDataForCellWithCellName:(NSString *)cellName UserName:(NSString *)name ImageString:(NSString *)imageString{
    nameLabel.frame = CGRectMake(10, 0, 40, 85);
    nameLabel.text = cellName;
    
    rightView.frame = CGRectMake(ScreenWidth - 10-9, 35, 9, 16);
    rightView.image = [UIImage imageNamed:@"arrow.png"];

    headView.frame = CGRectMake(ScreenWidth - 10-10-10-62, 12, 62, 62);
    headView.layer.masksToBounds = YES;
    headView.layer.borderColor = [UIColor hexChangeFloat:@"414C88"].CGColor;
    headView.layer.borderWidth = 1;
    headView.layer.cornerRadius = 31;
    
    headLabel.frame = CGRectMake(0, 0, headLabel.frame.size.width, headView.frame.size.height);
    
    lineView.frame = CGRectMake(10, 84.5, ScreenWidth-10, 0.5);
    
    WEAKSELF
    [weakSelf.headView setImageWithUrl:imageString placeHolder:[Common getImageFromColor:[UIColor colorWithRGBHex:name.hash % 0xffffff]] progress:nil completed:^(UIImage *image) {
        [weakSelf.headView setImage:image];
    } failureBlock:^(NSError *error) {
        if (name && name.length>0) {
            weakSelf.headLabel.text =[name substringToIndex:1];
        }
    }];
}

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end





@implementation EditUserInfoTableViewCell
@synthesize nameLabel,infoLabel,lineView,rightView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        nameLabel = [[UILabel alloc]init];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:nameLabel];
        
        infoLabel = [[UILabel alloc]init];
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.font = [UIFont systemFontOfSize:16];
        infoLabel.textAlignment = NSTextAlignmentRight;
        infoLabel.textColor = [UIColor hexChangeFloat:@"818181"];
        [self.contentView addSubview:infoLabel];

        rightView = [[UIImageView alloc]init];
        rightView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:rightView];
        
        lineView = [[UIImageView alloc]init];
        lineView.backgroundColor = [UIColor hexChangeFloat:@"e7e7e7"];
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)loadDataForCellWithUserName:(NSString *)name InfoString:(NSString *)infoString isScreenWidth:(BOOL)value{
    nameLabel.frame = CGRectMake(10, 14, 40, 16);
    nameLabel.text = name;
    [nameLabel sizeToFit];
    
    rightView.frame = CGRectMake(ScreenWidth - 10-10, 14.5, 9, 16);
    rightView.image = [UIImage imageNamed:@"arrow.png"];
    
    infoLabel.frame = CGRectMake(rightView.frame.origin.x - 10 -100, 14, 100, 16);
    infoLabel.text = infoString;
    [infoLabel sizeToFit];
    CGRect frame = infoLabel.frame;
    if (infoLabel.frame.size.width > rightView.frame.origin.x - 20 - nameLabel.frame.size.width - nameLabel.frame.origin.x) {
        frame.size.width = rightView.frame.origin.x - 20 - nameLabel.frame.size.width - nameLabel.frame.origin.x;
        infoLabel.frame = CGRectMake(nameLabel.frame.size.width + nameLabel.frame.origin.x +10, 14, frame.size.width, 16);
    }
    else{
        infoLabel.frame = CGRectMake(rightView.frame.origin.x - 10-infoLabel.frame.size.width, 14.5, infoLabel.frame.size.width, 16);
    }
    
    if (value) {
        //顶边
        lineView.frame = CGRectMake(0, 43.5, ScreenWidth, 0.5);
    }
    else{
        lineView.frame = CGRectMake(10, 43.5, ScreenWidth-10, 0.5);
    }
}

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}


@end




