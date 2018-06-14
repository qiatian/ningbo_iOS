//
//  InMeetingUserItem.m
//  IM
//
//  Created by 陆浩 on 15/7/7.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//
#import "InMeetingUserItem.h"

@implementation InMeetingUserItem
{
    MeetingUserModel *userModel;
    UIImageView *alphaView;
    UIImageView *reConnectImageView;
    NSTimer *timer;
    int timeSeconds;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialSettings];
    }
    return self;
}

-(void) initialSettings{
    
    GQLoadImageView *ivAvatar =[[GQLoadImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-60)/2, 12, 60, 60)];
    ivAvatar.userInteractionEnabled =YES;
    ivAvatar.clipsToBounds =YES;
    ivAvatar.layer.cornerRadius =30;
    self.ivAvatar =ivAvatar;
    [self addSubview:self.ivAvatar];
    
    alphaView = [[UIImageView alloc] initWithFrame:ivAvatar.bounds];
    alphaView.clipsToBounds = YES;
    alphaView.layer.cornerRadius = 30;
    alphaView.backgroundColor = [UIColor grayColor];
    alphaView.alpha = 0.6;
    [self.ivAvatar addSubview:alphaView];
    alphaView.hidden = YES;
    
    UILabel *labAvatar = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    labAvatar.textColor = [UIColor whiteColor];
    labAvatar.textAlignment = NSTextAlignmentCenter;
    labAvatar.font = [UIFont boldSystemFontOfSize:24.0f];
    self.labAvatar = labAvatar;
    [self.ivAvatar addSubview:self.labAvatar];
    
    reConnectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 30, 30)];
    reConnectImageView.clipsToBounds = YES;
    reConnectImageView.layer.cornerRadius = 30;
    reConnectImageView.image = [UIImage imageNamed:@"meeting_reconnect.png"];
    [self.ivAvatar addSubview:reConnectImageView];
    reConnectImageView.hidden = YES;
    
    UILabel *labUserName = [[UILabel alloc] initWithFrame:CGRectMake(0, self.ivAvatar.frame.size.height+self.ivAvatar.frame.origin.y+10, self.frame.size.width, 20)];
    labUserName.textAlignment = NSTextAlignmentCenter;
    labUserName.font = [UIFont systemFontOfSize:12.0f];
    labUserName.textColor = [UIColor hexChangeFloat:@"909090"];
    self.labUserName = labUserName;
    [self addSubview:self.labUserName];
}

-(void)setUser:(MeetingUserModel *)user{
    _user = user;
    self.labUserName.text =user.userName;
    if (user.userAvatar && user.userAvatar.length>0) {
        WEAKSELF
        [self.ivAvatar setImageWithUrl:user.userAvatar placeHolder:[Common getImageFromColor:[UIColor colorWithRGBHex:user.userName.hash % 0xffffff]] progress:nil completed:^(UIImage *image) {
            [weakSelf.ivAvatar setImage:image];
        } failureBlock:^(NSError *error) {
            if (user.userName && user.userName.length>0) {
                weakSelf.labAvatar.text =[user.userName substringToIndex:1];
            }
        }];
    }else{
        [self.ivAvatar setImage:[Common getImageFromColor:[UIColor colorWithRGBHex:user.userName.hash % 0xffffff]]];
        if (user.userName && user.userName.length>0){
            self.labAvatar.text =[user.userName substringToIndex:1];
        }
    }
}

-(void)setType:(MeetingType)typeValue
{
    _type = typeValue;
    switch (_type) {
        case waiteconnect:
            alphaView.hidden = NO;
            reConnectImageView.hidden = YES;
            self.labUserName.text = LOCALIZATION(@"Message_dengdaijieru");
            self.labUserName.textColor = [UIColor hexChangeFloat:@"909090"];
            [self startTimer];
            break;
        case hasconnect:
            alphaView.hidden = YES;
            reConnectImageView.hidden = YES;
            self.labUserName.text = _user.userName;
            self.labUserName.textColor = [UIColor hexChangeFloat:@"000000"];
            break;
        case reconnect:
            alphaView.hidden = NO;
            reConnectImageView.hidden = NO;
            self.labUserName.text = LOCALIZATION(@"Message_dianji");
            self.labUserName.textColor = [UIColor hexChangeFloat:@"909090"];
            break;
        case hangUp:
            alphaView.hidden = NO;
            reConnectImageView.hidden = YES;
            self.labUserName.text = LOCALIZATION(@"Message_guaduan");
            self.labUserName.textColor = [UIColor hexChangeFloat:@"909090"];
            break;
        default:
            break;
    }
}

-(void)onTimer
{
    timeSeconds ++;
    if(timeSeconds >= 70)
    {
        //70秒之后如果还是未接通，则本地直接出现重新连接
        [self stopTimer];
        self.type = reconnect;
    }
}

-(void)stopTimer
{
    if(timer)
    {
        timeSeconds = 0;
        [timer invalidate];
        timer = nil;
    }
}

-(void)startTimer
{
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
    timeSeconds = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

@end
