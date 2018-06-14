//
//  DiscoverTableViewCell.m
//  IM
//
//  Created by 陆浩 on 15/4/14.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "DiscoverTableViewCell.h"

@implementation DiscoverTableViewCell

@synthesize titleLabel,logoImageView,rightImageView,lineImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [self.contentView addSubview:titleLabel];
        
        logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 30, 30)];
        logoImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:logoImageView];
                
        rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-15-9, 17, 9, 16)];
        rightImageView.backgroundColor = [UIColor clearColor];
        rightImageView.image = [UIImage imageNamed:@"arrow.png"];
        [self.contentView addSubview:rightImageView];

        lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 49.5, [UIScreen mainScreen].bounds.size.width-15, 0.5)];
        lineImageView.backgroundColor = [UIColor hexChangeFloat:@"DBDDDD"];
        [self.contentView addSubview:lineImageView];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
