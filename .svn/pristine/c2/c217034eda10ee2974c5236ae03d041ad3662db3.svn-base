//
//  MeetintListTableViewCell.m
//  IM
//
//  Created by 陆浩 on 15/6/30.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "MeetintListTableViewCell.h"

@implementation CommonMeetintListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(-0.5, 0, boundsWidth+1, 60)];
        view.layer.borderColor = [UIColor hexChangeFloat:@"d4d4d4"].CGColor;
        view.layer.borderWidth = 0.5;
        [self.contentView addSubview:view];

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = [UIImage imageNamed:@"meeting_common"];
        [view addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width+imageView.frame.origin.x+20, 0, 200, 60)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.text = LOCALIZATION(@"con_use");
        [view addSubview:titleLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(boundsWidth-15-9, 22, 9, 16)];
        arrowImageView.image = [UIImage imageNamed:@"arrow.png"];
        [self.contentView addSubview:arrowImageView];
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



@implementation MeetintListTableViewCell
{
    UILabel *titleLabel;
    UILabel *subTitleLabel;
    UIImageView *typeImageView;//接入，呼出，拒接的状态logo
    UILabel *timeLabel;
    UILabel *userNumLabel;//参会人数
    BOOL isMainView;//是否是主页列表
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withType:(BOOL)mainView
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        isMainView = mainView;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(-0.5, 0, boundsWidth+1, 55)];
        view.layer.borderColor = [UIColor hexChangeFloat:@"d4d4d4"].CGColor;
        view.layer.borderWidth = 0.5;
        [self.contentView addSubview:view];
        
        CGFloat leftMarging = 10 ;
        if(mainView)
        {
            CGFloat imageSize = 20;
            typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (55-imageSize)/2, imageSize, imageSize)];
            [view addSubview:typeImageView];
            leftMarging = 35;
        }
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMarging, 9, boundsWidth-60-leftMarging, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:16];
        [view addSubview:titleLabel];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(boundsWidth-100-10, 9, 100, 13)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.textAlignment = NSTextAlignmentRight;
        [view addSubview:timeLabel];
        
        subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMarging, 30, boundsWidth-60-leftMarging, 20)];
        subTitleLabel.backgroundColor = [UIColor clearColor];
        subTitleLabel.font = [UIFont systemFontOfSize:13];
        subTitleLabel.textColor = [UIColor grayColor];
        [view addSubview:subTitleLabel];
        
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(boundsWidth-45-10, 28, 45, 20)];
        bgView.image = [UIImage imageNamed:@"meet_user_num"];
        [view addSubview:bgView];
        
        userNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView.frame.size.width-5-25, 0, 25, bgView.frame.size.height)];
        userNumLabel.backgroundColor = [UIColor clearColor];
        userNumLabel.font = [UIFont systemFontOfSize:11];
        userNumLabel.textColor = [UIColor whiteColor];
        userNumLabel.textAlignment = NSTextAlignmentRight;
        [bgView addSubview:userNumLabel];

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

-(void)loadCellWithModel:(MeetingModel *)model
{
    NSString *userNameString = @"";
    for(int i = 0 ; i < model.meetingUserArray.count ; i ++)
    {
        MeetingUserModel *userModel = model.meetingUserArray[i];
        if(i == 0)
        {
            userNameString = userModel.userName;
        }
        else
        {
            userNameString = [NSString stringWithFormat:@"%@、%@",userNameString,userModel.userName];
        }
    }
    
    if(isMainView)
    {
        NSDateFormatter *formmatter = [[NSDateFormatter alloc] init];
        [formmatter setDateFormat:@"MM-dd HH:mm"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.meetingLastConnectTime longLongValue]];
        NSString *Date = [formmatter stringFromDate:date];
        timeLabel.text = Date;
        typeImageView.image = [UIImage imageNamed:@"meet_callout"];
        titleLabel.textColor = [UIColor redColor];
        NSString *str = [LOCALIZATION(@"Message_CallOn") stringByAppendingFormat:@"%@",userNameString];
        
        subTitleLabel.text = str;
    }
    else
    {
        timeLabel.text = LOCALIZATION(@"Message_View_details");
        subTitleLabel.text = userNameString;
    }
    titleLabel.text = [model.meetingTitle length]?model.meetingTitle:LOCALIZATION(@"Message_NO_Metting_zhuti");
    userNumLabel.text = [NSString stringWithFormat:@"%d",model.meetingUserArray.count];

}

+(CGFloat)cellHeightWithModel:(id)model
{
    return 55;
}



@end
