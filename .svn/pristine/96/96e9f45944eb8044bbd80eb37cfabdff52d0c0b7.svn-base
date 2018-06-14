//
//  NotiListTableViewCell.m
//  IM
//
//  Created by 陆浩 on 15/5/20.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "NotiListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NotiModel.h"

@implementation NotiListTableViewCell
{
    UIView  *contentBgView;
    UILabel *titleLabel;
    UILabel *hostNameLabel;
    UILabel *statusLabel;
    UILabel *timeLabel;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        contentBgView = [[UIView alloc] initWithFrame:CGRectMake(10, 15, boundsWidth-20, 95)];
        contentBgView.backgroundColor = [UIColor whiteColor];
        contentBgView.layer.borderColor = [UIColor grayColor].CGColor;
        contentBgView.layer.borderWidth = 0.5;
        contentBgView.layer.masksToBounds = YES;
        contentBgView.layer.cornerRadius = 8;
        [self.contentView addSubview:contentBgView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, contentBgView.frame.size.width-20, 17)];
        titleLabel.font = [UIFont systemFontOfSize:15.0f];
        titleLabel.backgroundColor = [UIColor clearColor];
        [contentBgView addSubview:titleLabel];
        
        hostNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, titleLabel.frame.size.height+titleLabel.frame.origin.y+8, contentBgView.frame.size.width-100, 15)];
        hostNameLabel.font = [UIFont systemFontOfSize:13.0f];
        hostNameLabel.backgroundColor = [UIColor clearColor];
        [contentBgView addSubview:hostNameLabel];
        
        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentBgView.frame.size.width-150-10, hostNameLabel.frame.origin.y, 150, 15)];
        statusLabel.font = [UIFont systemFontOfSize:13.0f];
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.textAlignment = NSTextAlignmentRight;
        [contentBgView addSubview:statusLabel];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, contentBgView.frame.size.height-35, contentBgView.frame.size.width-20, 0.5)];
        line.backgroundColor = [UIColor grayColor];
        [contentBgView addSubview:line];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, line.frame.origin.y, contentBgView.frame.size.width-120, contentBgView.frame.size.height-line.frame.origin.y)];
        timeLabel.font = [UIFont systemFontOfSize:13.0f];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textColor = [UIColor grayColor];
        [contentBgView addSubview:timeLabel];
        
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentBgView.frame.size.width-140-10, line.frame.origin.y, 120, contentBgView.frame.size.height-line.frame.origin.y)];
        tipLabel.font = [UIFont systemFontOfSize:13.0f];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.textColor = [UIColor grayColor];
        tipLabel.textAlignment = NSTextAlignmentRight;
        tipLabel.text = LOCALIZATION(@"Message_View_details");
        [contentBgView addSubview:tipLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(contentBgView.frame.size.width-9-10, line.frame.origin.y + 9, 9, 16)];
        arrowImageView.image = [UIImage imageNamed:@"arrow.png"];
        [contentBgView addSubview:arrowImageView];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

-(void)loadCellWithDic:(NotiListModel *)model withHostName:(NSString *)name
{
    BOOL isMineNoti = NO;//当前账号就是创建者
    if([model.creator longLongValue] == [[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"] longLongValue])
    {
        isMineNoti = YES;
    }

    if( [model.status intValue] == 0)
    {
        //通知已过期了

        NSString *str = [NSString stringWithString:LOCALIZATION(@"Message_Promoter")];
        NSString *textLabelStr = [str stringByAppendingFormat:@"%@",name];
        contentBgView.backgroundColor = [UIColor hexChangeFloat:@"ececec"];
        titleLabel.text = model.title;
        titleLabel.textColor = [UIColor grayColor];
        hostNameLabel.text = textLabelStr;
        hostNameLabel.textColor = [UIColor grayColor];
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.startTime longLongValue]/1000];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        timeLabel.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
        NSString *statusStr = @"";
        if(isMineNoti)
        {
            statusStr = [self normalMineStatusStringWithStatus:model.status];
        }
        else
        {
            statusStr = [self normalStatusStringWithStatus:model.dealStatus];
        }
       
        NSString *statusString = [NSString stringWithFormat:@"%@",statusStr];
        statusLabel.text = statusString;
        statusLabel.textColor = [UIColor grayColor];
    }
    else
    {
         //通知未过期
 
        NSString *str1 = [NSString stringWithString:LOCALIZATION(@"Message_Promoter")];
        NSString *textLabelStr = [str1 stringByAppendingFormat:@"%@",name];
        contentBgView.backgroundColor = [UIColor whiteColor];
        titleLabel.text = model.title;
        titleLabel.textColor = [UIColor blackColor];
        hostNameLabel.text = textLabelStr;
        hostNameLabel.textColor = [UIColor grayColor];
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.startTime longLongValue]/1000];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        timeLabel.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
        NSString *statusString = nil;
        if(isMineNoti)
        {
            statusString = [self statusMineStringWithStatus:model.status];
            statusLabel.text = statusString;
            statusLabel.textColor = [UIColor grayColor];
        }
        
        else
        {
            if ([model.status intValue] == 2){
                NSString *statusStr = @"";
                statusStr = LOCALIZATION(@"Message_Canceled");
                NSString *statusString = [NSString stringWithFormat:@"%@",statusStr];
                statusLabel.text = statusString;
                statusLabel.textColor = [UIColor grayColor];
            }else {
            
            statusString = [self statusStringWithStatus:model.dealStatus];
                if([statusString isEqualToString:@"未处理"] || [statusString isEqualToString:@"unprocessed"]){
                    statusLabel.textColor = [UIColor redColor];
                    statusLabel.text = statusString;
                }else{
                     statusLabel.text = statusString;
                    statusLabel.textColor = [UIColor grayColor];
                    
                }
         }
            
        }
        
    }
}

-(NSString *)normalMineStatusStringWithStatus:(NSString *)status
{
    NSString *statusStr = @"";
    switch ([status intValue]) {
        case 0:
            statusStr = LOCALIZATION(@"Message_Expired");
            break;
        case 1:
            statusStr = LOCALIZATION(@"Message_Created");
            break;
        case 2:
            statusStr = LOCALIZATION(@"Message_Canceled");
            break;
            
        default:
            break;
    }
    return statusStr;
}

-(NSString *)statusMineStringWithStatus:(NSString *)status
{
    NSString *statusStr = @"";
    NSString *statusString = nil;
    switch ([status intValue]) {
        case 0:
            statusStr = LOCALIZATION(@"Message_Expired");
            statusString =[NSString stringWithFormat:@"%@",statusStr];
            //[statusString setAttributes:@{NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"ee6261"]} range:NSMakeRange(3, [statusStr length])];
            break;
        case 1:
            statusStr = LOCALIZATION(@"Message_Created");
            statusString = [NSString stringWithFormat:@"%@",statusStr];
            //[statusString setAttributes:@{NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"000000"]} range:NSMakeRange(3, [statusStr length])];
            break;
        case 2:
            statusStr = LOCALIZATION(@"Message_Canceled");
            statusString =[NSString stringWithFormat:@"%@",statusStr];
           // [statusString setAttributes:@{NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"ee6261"]} range:NSMakeRange(3, [statusStr length])];
            break;
            
        default:
            statusStr = LOCALIZATION(@"Message_Untreated");
            statusString = [NSString stringWithFormat:@"%@",statusStr];
            
           // [statusString setAttributes:@{NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"959595"]} range:NSMakeRange(3, [statusStr length])];
            break;
    }
    return statusString;
}


-(NSString *)normalStatusStringWithStatus:(NSString *)status
{
    NSString *statusStr = @"";
    if([status isEqualToString:@"a"])
    {
        statusStr = LOCALIZATION(@"Message_Agreed");
    }
    else if([status isEqualToString:@"r"])
    {
        statusStr = LOCALIZATION(@"Message_Refuse");
    }
    else
    {     //已取消 改为 已过期
        statusStr = LOCALIZATION(@"Message_Expired");
    }
    return statusStr;
}

-(NSString *)statusStringWithStatus:(NSString *)status
{
    NSString *statusString = nil;
    NSString *statusStr = @"";
    if([status isEqualToString:@"a"])
    {
        statusStr = LOCALIZATION(@"Message_Agreed");
        statusString = [NSString stringWithFormat:@"%@",statusStr];
        //[statusString setAttributes:@{NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"76d659"]} range:NSMakeRange(3, [statusStr length])];
    }
    else if([status isEqualToString:@"r"])
    {
        statusStr = LOCALIZATION(@"Message_Refuse");
        statusString = [NSString stringWithFormat:@"%@",statusStr];
        //[statusString setAttributes:@{NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"ee6261"]} range:NSMakeRange(3, [statusStr length])];
    }
    else
    {
        statusStr = LOCALIZATION(@"Message_Untreated");
        statusString = [NSString stringWithFormat:@"%@",statusStr];
        //[statusString setAttributes:@{NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"959595"]} range:NSMakeRange(3, [statusStr length])];
    }
    return statusString;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation NotiDetailTableViewCell
{
    UILabel *titleLabel;
    UILabel *subTitleLabel;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        UIView *contentBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 44)];
        contentBgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:contentBgView];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, contentBgView.frame.size.height-0.5, boundsWidth-10, 0.5)];
        line.backgroundColor = [UIColor grayColor];
        [contentBgView addSubview:line];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 70, 44)];
        titleLabel.font = [UIFont systemFontOfSize:15.0f];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor grayColor];
        [contentBgView addSubview:titleLabel];
        
        subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 0, boundsWidth-85-10, 44)];
        subTitleLabel.font = [UIFont systemFontOfSize:15.0f];
        subTitleLabel.backgroundColor = [UIColor clearColor];
        subTitleLabel.textAlignment = NSTextAlignmentRight;
        [contentBgView addSubview:subTitleLabel];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

-(void)loadCellWithTitle:(NSString *)title subTitle:(NSString *)subTitle
{
    titleLabel.text = title;
    subTitleLabel.attributedText = nil;
    subTitleLabel.text = subTitle;
}

-(void)loadCellWithModel:(NotiDetailModel *)model isMine:(BOOL)isMine
{
   titleLabel.text = LOCALIZATION(@"Message_State:");
    subTitleLabel.text = nil;
    if(isMine)
    {
        subTitleLabel.text = [self statusMineStringWithStatus:model.status];
    }
    else
    {
        if ([model.status intValue] == 2){
        subTitleLabel.text = [self cancelStringWithStatus:model.status];
            
        }
        else {
        subTitleLabel.text = [self statusStringWithStatus:model.dealStatus];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(NSString *)statusMineStringWithStatus:(NSString *)status
{
    NSString *statusStr = @"";
    NSString *statusString = nil;
    
    if ([status isEqualToString:@"0"]) {
        statusStr =  LOCALIZATION(@"Message_Expired");
        statusString = [NSString stringWithFormat:@"%@",statusStr];
       // [statusString setAttributes:@{NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"ee6261"]} range:NSMakeRange(0, [statusStr length])];
        
    }else if([status isEqualToString:@"1"]){
        statusStr = LOCALIZATION(@"Message_Created");
        statusString = [NSString stringWithFormat:@"%@",statusStr];
       // [statusString setAttributes:@{NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"000000"]} range:NSMakeRange(0, [statusStr length])];
    }else if ([status isEqualToString:@"2"]){
        statusStr = LOCALIZATION(@"Message_Canceled");
        statusString = [NSString stringWithFormat:@"%@",statusStr];
        //[statusString setAttributes:@{NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"ee6261"]} range:NSMakeRange(0, [statusStr length])];
        
    }else {
        statusStr = LOCALIZATION(@"Message_Untreated");
        statusString = [NSString stringWithFormat:@"%@",statusStr];
       // [statusString setAttributes:@{NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"959595"]} range:NSMakeRange(0, [statusStr length])];
        
    }

    return statusString;
}


-(NSString *)statusStringWithStatus:(NSString *)status
{
    NSString *statusString = nil;
    NSString *statusStr = @"";
    if([status isEqualToString:@"a"])
    {
        statusStr =  LOCALIZATION(@"Message_Agreed");
        statusString = [ NSString stringWithFormat:@"%@",statusStr];
       // [statusString setAttributes:@{NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"76d659"]} range:NSMakeRange(0, [statusStr length])];
    }
    else if([status isEqualToString:@"r"])
    {
        statusStr = LOCALIZATION(@"Message_Refuse");
        statusString = [NSString stringWithFormat:@"%@",statusStr];
      //  [statusString setAttributes:@{NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"ee6261"]} range:NSMakeRange(0, [statusStr length])];
    }
    else
    {
        statusStr =  LOCALIZATION(@"Message_Untreated");
        statusString = [NSString stringWithFormat:@"%@",statusStr];
       // [statusString setAttributes:@{NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"959595"]} range:NSMakeRange(0, [statusStr length])];
    }
    return statusString;
    
}


-(NSString *)cancelStringWithStatus:(NSString *)status
{
    NSString *statusString = nil;
    NSString *statusStr = @"";
    if([status isEqualToString:@"2"])
    {
        statusStr =  LOCALIZATION(@"Message_Canceled");
        statusString = [NSString stringWithFormat:@"%@",statusStr];
       // [statusString setAttributes:@{NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"ee6261"]} range:NSMakeRange(0, [statusStr length])];
    }
  
    return statusString;
    
}






@end


@implementation NotiDetailUserTableViewCell
{
    UILabel *titleLabel;
    UILabel *userNumLabel;
    UILabel *agreeNumLabel;
    UILabel *refuseNumLabel;
    UILabel *waiteNumLabel;
    
    UIView *lineView;
    UIView *contentBgView;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        contentBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 44)];
        contentBgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:contentBgView];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(10, contentBgView.frame.size.height-0.5, boundsWidth-10, 0.5)];
        lineView.backgroundColor = [UIColor grayColor];
        [contentBgView addSubview:lineView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 44)];
        titleLabel.font = [UIFont systemFontOfSize:15.0f];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor grayColor];
       titleLabel.text =  LOCALIZATION(@"Message_Participants");
        [contentBgView addSubview:titleLabel];
        
        userNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(boundsWidth-120-30, 0, 120, 44)];
        userNumLabel.font = [UIFont systemFontOfSize:15.0f];
        userNumLabel.backgroundColor = [UIColor clearColor];
        userNumLabel.textAlignment = NSTextAlignmentRight;
        [contentBgView addSubview:userNumLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(boundsWidth-9-10, 14, 9, 16)];
        arrowImageView.image = [UIImage imageNamed:@"arrow.png"];
        [contentBgView addSubview:arrowImageView];
        
        agreeNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 44, boundsWidth-20, 44)];
        agreeNumLabel.font = [UIFont systemFontOfSize:15.0f];
        agreeNumLabel.backgroundColor = [UIColor clearColor];
        [contentBgView addSubview:agreeNumLabel];

        refuseNumLabel = [[UILabel alloc] initWithFrame:agreeNumLabel.frame];
        refuseNumLabel.font = [UIFont systemFontOfSize:15.0f];
        refuseNumLabel.backgroundColor = [UIColor clearColor];
        refuseNumLabel.textAlignment = NSTextAlignmentCenter;
        [contentBgView addSubview:refuseNumLabel];

        waiteNumLabel = [[UILabel alloc] initWithFrame:agreeNumLabel.frame];
        waiteNumLabel.font = [UIFont systemFontOfSize:15.0f];
        waiteNumLabel.backgroundColor = [UIColor clearColor];
        waiteNumLabel.textAlignment = NSTextAlignmentRight;
        [contentBgView addSubview:waiteNumLabel];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

-(void)loadCellWithAgreeNum:(int)agreeNum refuseNum:(int)refuseNum waitNum:(int)waitNum totalNum:(int)totalNum isMine:(BOOL)isMine
{
    if(isMine)
    {
        contentBgView.frame = CGRectMake(0, 0, boundsWidth, 88);
        lineView.frame = CGRectMake(10, contentBgView.frame.size.height-0.5, boundsWidth-10, 0.5);
        agreeNumLabel.hidden = NO;
        refuseNumLabel.hidden = NO;
        waiteNumLabel.hidden = NO;
    }
    else
    {
        contentBgView.frame = CGRectMake(0, 0, boundsWidth, 44);
        lineView.frame = CGRectMake(10, contentBgView.frame.size.height-0.5, boundsWidth-10, 0.5);
        agreeNumLabel.hidden = YES;
        refuseNumLabel.hidden = YES;
        waiteNumLabel.hidden = YES;

    }
    NSString *str = [LOCALIZATION(@"Message_Agreed:") stringByAppendingFormat:@"%d",agreeNum];
    NSMutableAttributedString *textLabelStr1 = [[NSMutableAttributedString alloc] initWithString:str];
   // [textLabelStr1 setAttributes:@{NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"76d659"]} range:NSMakeRange(0, 3)];
    
    NSString *str2 = [LOCALIZATION(@"Message_Refuse:") stringByAppendingFormat:@"%d",refuseNum];
    NSMutableAttributedString *textLabelStr2 = [[NSMutableAttributedString alloc] initWithString:str2];
   // [textLabelStr2 setAttributes:@{NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"ee6261"]} range:NSMakeRange(0, 3)];
    
    NSString *str4 = [LOCALIZATION(@"Message_WaitNum:") stringByAppendingFormat:@"%d",waitNum];
    NSMutableAttributedString *textLabelStr3 = [[NSMutableAttributedString alloc] initWithString:str4];
   // [textLabelStr3 setAttributes:@{NSForegroundColorAttributeName:[UIColor hexChangeFloat:@"959595"]} range:NSMakeRange(0, 3)];

    agreeNumLabel.attributedText = textLabelStr1;
    refuseNumLabel.attributedText = textLabelStr2;
    waiteNumLabel.attributedText = textLabelStr3;
    NSString *str6 = [[NSString alloc]initWithFormat:@"%d",totalNum];
    NSString *str7 = [str6 stringByAppendingString:LOCALIZATION(@"Message_peopler")];
    userNumLabel.text = str7;
    
}


+(CGFloat)heightCellForRow:(BOOL)isMine
{
    if(isMine)
    {
        return 88;
    }
    else
    {
        return 44;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end


@implementation NotiUserListTableViewCell
{
    GQLoadImageView *avatarImageView;
    UILabel *avatarNameLabel;
    UILabel *nameLabel;
    UILabel *statusLabel;
    UILabel *statusTime;
    UIButton *styleSelectButton;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        avatarImageView = [[GQLoadImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
        avatarImageView.layer.masksToBounds = YES;
        avatarImageView.layer.cornerRadius = 20;
        [self.contentView addSubview:avatarImageView];
        
        avatarNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, avatarImageView.frame.size.width, avatarImageView.frame.size.height)];
        avatarNameLabel.textAlignment = NSTextAlignmentCenter;
        avatarNameLabel.textColor = [UIColor whiteColor];
        avatarNameLabel.font = [UIFont systemFontOfSize:20.0];
        avatarNameLabel.backgroundColor = [UIColor clearColor];
        [avatarImageView addSubview:avatarNameLabel];
        
        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(boundsWidth-55-15, 18, 55, 24)];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.textColor = [UIColor whiteColor];
        statusLabel.font = [UIFont systemFontOfSize:14.0];
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.layer.masksToBounds = YES;
        statusLabel.layer.cornerRadius = 12;
        [self.contentView addSubview:statusLabel];

        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 5, 200, 30)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.contentView addSubview:nameLabel];
        
        statusTime = [[UILabel alloc] initWithFrame:CGRectMake(75, 40, 200, 16)];
        statusTime.textColor = [UIColor grayColor];
        statusTime.font = [UIFont systemFontOfSize:12.0];
        statusTime.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:statusTime];
        
        _styleSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _styleSelectButton.frame = CGRectMake(boundsWidth-30-10, 15, 30, 30);
        [self.contentView addSubview:_styleSelectButton];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 59.5, boundsWidth-15, 0.5)];
        line.backgroundColor = [UIColor hexChangeFloat:@"dddddd"];
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

-(void)loadCellWithDic:(id)tuserDic
{
    if([tuserDic isKindOfClass:[NotiUserModel class]])
    {
        NotiUserModel *userDic = (NotiUserModel *)tuserDic;
        //通知详情进入的界面
        if (userDic.minipicurl && [userDic.minipicurl length]>0){
            [avatarImageView setImageWithUrl:userDic.minipicurl placeHolder:nil];
            avatarNameLabel.text = nil;
        }
        else
        {
            if (userDic.name && [userDic.name length] > 0){
                avatarNameLabel.text = [userDic.name substringToIndex:1];
                [avatarImageView setImage:[Common getImageFromColor:[UIColor colorWithRGBHex:((NSString *)userDic.name).hash % 0xffffff]]];
            }
            else{
                avatarNameLabel.text = nil;
                [avatarImageView setImage:[Common getImageFromColor:[UIColor grayColor]]];
            }
        }
        nameLabel.text = userDic.name;
        
        if(userDic.dealTime)
        {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[userDic.dealTime longLongValue]/1000];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM月dd日 HH:mm"];
            statusTime.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
        }
        
        if(!_isMine)
        {
            statusLabel.hidden = YES;
        }
        else
        {
                statusLabel.hidden = NO;
                if([userDic.status isEqualToString:@"a"])
                {
                    statusLabel.backgroundColor = [UIColor clearColor];
                    statusLabel.text = LOCALIZATION(@"Message_Agreed");
                    statusLabel.textColor = [UIColor hexChangeFloat:@"7dc45c"];
                }
                else if([userDic.status isEqualToString:@"r"])
                {
                    statusLabel.backgroundColor = [UIColor hexChangeFloat:@"ee6261"];
                    statusLabel.text =LOCALIZATION(@"Message_Refuse");
                    statusLabel.textColor = [UIColor whiteColor];
                }
                else
                {
                    statusLabel.backgroundColor = [UIColor clearColor];
                    statusLabel.text =  LOCALIZATION(@"Message_Wait");
                    statusLabel.textColor = [UIColor hexChangeFloat:@"959595"];
                }
        }
    }
    else if([tuserDic isKindOfClass:[MEnterpriseUser class]])
    {
        //创建通知进入的界面
        statusTime.hidden = YES;
        statusLabel.hidden = YES;
        MEnterpriseUser *userModel = (MEnterpriseUser *)tuserDic;
        nameLabel.frame = CGRectMake(75, 5, 200, 50);
        if (userModel.minipicurl && [userModel.minipicurl length]>0){
            [avatarImageView setImageWithUrl:userModel.minipicurl placeHolder:nil];
            avatarNameLabel.text = nil;
        }
        else
        {
            if (userModel.uname && [userModel.uname length]>0){
                avatarNameLabel.text = [userModel.uname substringToIndex:1];
                [avatarImageView setImage:[Common getImageFromColor:[UIColor colorWithRGBHex:((NSString *)userModel.uname).hash % 0xffffff]]];
            }
            else{
                avatarNameLabel.text = nil;
                [avatarImageView setImage:[Common getImageFromColor:[UIColor grayColor]]];
            }
        }
        nameLabel.text = userModel.uname;
//        [styleSelectButton setImage:[UIImage imageNamed:@"CellBlueSelected.png"] forState:UIControlStateSelected];
//        [styleSelectButton setImage:[UIImage imageNamed:@"CellNotSelected.png"] forState:UIControlStateNormal];

    }
    else if([tuserDic isKindOfClass:[MeetingUserModel class]])
    {
        //电话会议查看成员
        statusTime.hidden = YES;
        statusLabel.hidden = YES;
        MeetingUserModel *userModel = (MeetingUserModel *)tuserDic;
        nameLabel.frame = CGRectMake(75, 5, 200, 50);
        if (userModel.userAvatar && [userModel.userAvatar length]>0){
            [avatarImageView setImageWithUrl:userModel.userAvatar placeHolder:nil];
            avatarNameLabel.text = nil;
        }
        else
        {
            if (userModel.userName && [userModel.userName length]>0){
                avatarNameLabel.text = [userModel.userName substringToIndex:1];
                [avatarImageView setImage:[Common getImageFromColor:[UIColor colorWithRGBHex:((NSString *)userModel.userName).hash % 0xffffff]]];
            }
            else{
                avatarNameLabel.text = nil;
                [avatarImageView setImage:[Common getImageFromColor:[UIColor grayColor]]];
            }
        }
        nameLabel.text = userModel.userName;
//        [styleSelectButton setImage:[UIImage imageNamed:@"CellBlueSelected.png"] forState:UIControlStateSelected];
//        [styleSelectButton setImage:[UIImage imageNamed:@"CellNotSelected.png"] forState:UIControlStateNormal];
    }
}

-(NSString *)statusStringWithStatus:(NSString *)status
{
    if([status isEqualToString:@"a"])
    {
        return  LOCALIZATION(@"Message_Agreed");
    }
    else if([status isEqualToString:@"r"])
    {
        return LOCALIZATION(@"Message_Refuse");
    }
    else
    {
        return  LOCALIZATION(@"Message_Untreated");
    }
}


@end

@implementation NotiExternTableViewCell
{
    UILabel *externBriefLabel;
    UIView *contentBgView;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        contentBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 0)];
        contentBgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:contentBgView];

        externBriefLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, boundsWidth-20, 0)];
        externBriefLabel.font = [UIFont systemFontOfSize:15.0f];
        externBriefLabel.backgroundColor = [UIColor clearColor];
        externBriefLabel.textColor = [UIColor grayColor];
        externBriefLabel.lineBreakMode = NSLineBreakByWordWrapping;
        externBriefLabel.numberOfLines = 0;
        [contentBgView addSubview:externBriefLabel];

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

-(void)loadCellWithString:(NSString *)string
{
    externBriefLabel.frame = CGRectMake(10, 5, boundsWidth-20, 0);
    if(!string || string.length == 0)
    {
        string =  LOCALIZATION(@"Message_No_note");
    }
    externBriefLabel.text = string;
    [externBriefLabel sizeToFit];
    
    contentBgView.frame = CGRectMake(0, 0, boundsWidth, externBriefLabel.frame.size.height+externBriefLabel.frame.origin.y+8);
}

+(CGFloat)heightCellForRow:(NSString *)string
{
    UILabel *externBriefLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, boundsWidth-20, 0)];
    externBriefLabel.font = [UIFont systemFontOfSize:15.0f];
    externBriefLabel.lineBreakMode = NSLineBreakByWordWrapping;
    externBriefLabel.numberOfLines = 0;
    if(string || string.length == 0)
    {
        string =  LOCALIZATION(@"Message_No_note");
    }
    externBriefLabel.text = string;
    [externBriefLabel sizeToFit];
    return externBriefLabel.frame.size.height+externBriefLabel.frame.origin.y+8;
}






@end