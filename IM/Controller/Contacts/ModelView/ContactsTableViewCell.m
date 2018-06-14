//
//  ContactsTableViewCell.m
//  IM
//
//  Created by 陆浩 on 15/4/21.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "ContactsTableViewCell.h"

@implementation ContactsTableViewCell

@synthesize logoImageView,titleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 30, 30)];
        [self.contentView addSubview:logoImageView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 6, 200, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:titleLabel];

        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(boundsWidth-15-9, 13, 9, 16)];
        arrowImageView.image = [UIImage imageNamed:@"arrow.png"];
        [self.contentView addSubview:arrowImageView];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 41.5, boundsWidth, 0.5)];
        line.backgroundColor = [UIColor hexChangeFloat:@"ececec"];
        [self.contentView addSubview:line];
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

@implementation GroupTableViewCell
{
    UIImageView *logoImageView;
    UILabel *titleLabel;
    UILabel *userNumLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3.5, 35, 35)];
        logoImageView.layer.masksToBounds = YES;
        logoImageView.layer.cornerRadius = 17.5;
        logoImageView.image = [UIImage imageNamed:@"group_chat.png"];
        [self.contentView addSubview:logoImageView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 6, 200, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:titleLabel];
        
        userNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(boundsWidth-120-26, 6, 120, 30)];
        userNumLabel.backgroundColor = [UIColor clearColor];
        userNumLabel.font = [UIFont systemFontOfSize:15.0f];
        userNumLabel.textAlignment = NSTextAlignmentRight;
        userNumLabel.textColor = [UIColor hexChangeFloat:@"898989"];
        [self.contentView addSubview:userNumLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(boundsWidth-10-9, 13, 9, 16)];
        arrowImageView.image = [UIImage imageNamed:@"arrow.png"];
        [self.contentView addSubview:arrowImageView];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(55, 41.5, boundsWidth-55, 0.5)];
        line.backgroundColor = [UIColor hexChangeFloat:@"ececec"];
        [self.contentView addSubview:line];
    }
    return self;
}

-(void)loadCellWithModel:(id)groupModel;
{
    MGroup *user = (MGroup *)groupModel;
    titleLabel.text = user.groupName;
    userNumLabel.text = [NSString stringWithFormat:@"%@人",user.len];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

