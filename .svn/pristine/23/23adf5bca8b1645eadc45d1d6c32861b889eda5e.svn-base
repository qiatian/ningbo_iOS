//
//  NoticeTableViewCell.m
//  IM
//
//  Created by  pipapai_tengjun on 15/7/14.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "NoticeTableViewCell.h"

#define ScreenWidth     [UIScreen mainScreen].bounds.size.width

@implementation NoticeTableViewCell
@synthesize imageView,titleLabel,infoLabel,dipView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        dipView = [[UIView alloc]init];
        dipView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:dipView];
        
        imageView = [[UIImageView alloc]init];
        imageView.backgroundColor = [UIColor clearColor];
        [dipView addSubview:imageView];
        
        titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor hexChangeFloat:@"333333"];
        [dipView addSubview:titleLabel];
        
        infoLabel = [[UILabel alloc]init];
        infoLabel.font = [UIFont systemFontOfSize:12];
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.textAlignment = NSTextAlignmentLeft;
        infoLabel.textColor = [UIColor hexChangeFloat:@"848484"];
        [dipView addSubview:infoLabel];
    }
    return self;
}


- (void)loadDataForCellWithModel:(NoticeCellModel *)model{
    
    dipView.frame = CGRectMake(10, 0, ScreenWidth - 20, 70);
    
    imageView.frame = CGRectMake(10, 10, 50, 50);
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 5;
    if ([model.contentType isEqualToString:@"notice"]) {
        imageView.image = [UIImage imageNamed:@"noticeList.png"];
    }
    
    titleLabel.frame = CGRectMake(imageView.frame.size.width + imageView.frame.origin.x + 10, 10, dipView.frame.size.width - 20-imageView.frame.size.width-imageView.frame.origin.x, 32);
    titleLabel.numberOfLines = 2;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.text = model.title;
    [titleLabel sizeToFit];
    if (titleLabel.frame.size.height < 26) {
        titleLabel.frame = CGRectMake(imageView.frame.size.width + imageView.frame.origin.x + 10, 17.5, dipView.frame.size.width - 20-imageView.frame.size.width-imageView.frame.origin.x, 13);
        infoLabel.frame = CGRectMake(titleLabel.frame.origin.x, 38.5, ScreenWidth-80, 12);
    }
    else{
        titleLabel.frame = CGRectMake(imageView.frame.size.width + imageView.frame.origin.x + 10, 10, dipView.frame.size.width - 20-imageView.frame.size.width-imageView.frame.origin.x, 32);
        infoLabel.frame = CGRectMake(titleLabel.frame.origin.x, 48, ScreenWidth-80, 12);
    }
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY年MM月dd日"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[model.createTime longLongValue]/1000];
    NSString * dateString = [formatter stringFromDate:date];
    infoLabel.text = [NSString stringWithFormat:@"%@ 发表于 %@",model.senderName,dateString];
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
