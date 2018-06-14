//
//  ChatUserContainer.m
//  IM
//
//  Created by syj on 15/4/26.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "ChatUserContainer.h"

@implementation ChatUserContainer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialSettings];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if(self){
        [self initialSettings];
        
    }
    return self;
}

-(void) initialSettings{
    UILabel *labUserName =[[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 20)];
    labUserName.textAlignment = NSTextAlignmentLeft;
    labUserName.font =[UIFont systemFontOfSize:16.0f];
    labUserName.textColor =[UIColor blackColor];
    self.labUserName =labUserName;
    [self addSubview:self.labUserName];
    
    UILabel *labIdNumber =[[UILabel alloc] initWithFrame:CGRectMake(60, 35, 100, 20)];
    labIdNumber.textAlignment = NSTextAlignmentLeft;
    labIdNumber.font =[UIFont systemFontOfSize:12.0f];
    labIdNumber.textColor =[UIColor grayColor];
    self.labIdNumber =labIdNumber;
    [self addSubview:self.labIdNumber];
    
    GQLoadImageView *ivAvatar =[[GQLoadImageView alloc] initWithFrame:CGRectMake(7.5, 7.5, 45, 45)];
    ivAvatar.userInteractionEnabled =YES;
    ivAvatar.layer.cornerRadius = 45 * 0.5;
    ivAvatar.layer.masksToBounds = YES;
    self.ivAvatar =ivAvatar;
    [self addSubview:self.ivAvatar];
    
    UILabel *labAvatar =[[UILabel alloc] initWithFrame:CGRectMake(7.5, 7.5, 45, 45)];
    labAvatar.textColor =[UIColor whiteColor];
    labAvatar.textAlignment =NSTextAlignmentCenter;
    labAvatar.font =[UIFont boldSystemFontOfSize:18.0f];
    self.labAvatar =labAvatar;
    [self addSubview:self.labAvatar];
    
    
    userItems =[[NSMutableArray alloc] init];
    
    addBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(boundsWidth - 75, 0, 75, 60)];
    [addBtn setImage:[UIImage imageNamed:@"chat_add_user.png"] forState:UIControlStateNormal];
    [addBtn setImageEdgeInsets:UIEdgeInsetsMake(7, 17, 7, 12)];
    [addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addBtn];
}

-(void)addUserItems:(MEnterpriseUser*)enterpriseUser{
    _user = (MEnterpriseUser *)enterpriseUser;
    [self setUser:_user];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userItemTaped:)];
    [self.ivAvatar addGestureRecognizer:tap];
}


-(void)setUser:(MEnterpriseUser *)user{
    _user =user;
    self.labUserName.text =user.uname;
    self.labIdNumber.text = user.mobile;
    
    if (user.bigpicurl && user.bigpicurl.length>0) {
        WEAKSELF
        [self.ivAvatar setImageWithUrl:user.bigpicurl placeHolder:[Common getImageFromColor:[UIColor colorWithRGBHex:user.uname.hash % 0xffffff]] progress:nil completed:^(UIImage *image) {
            [weakSelf.ivAvatar setImage:image];
        } failureBlock:^(NSError *error) {
            if (user.uname && user.uname.length>0) {
                weakSelf.labAvatar.text =[user.uname substringToIndex:1];
            }
        }];
    }else{
        [self.ivAvatar setImage:[Common getImageFromColor:[UIColor colorWithRGBHex:user.uname.hash % 0xffffff]]];
        if (user.uname && user.uname.length>0){
            self.labAvatar.text =[user.uname substringToIndex:1];
        }
    }
    
    self.ivAvatar.clipsToBounds =YES;
    self.ivAvatar.layer.cornerRadius =22;
}

-(void)userItemTaped:(UITapGestureRecognizer *)tap{
//    GQGroupUserItem *userItem =(GQGroupUserItem *)tap.view;
    if (self.delegate &&[self.delegate respondsToSelector:@selector(userItemTapedInGroupUserContainer:)]) {
        [self.delegate userItemTapedInGroupUserContainer:_user];
    }
    
}



-(void)addBtnClicked:(UIButton*)sender{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(addBtnClickedInGroupUserContainer)]) {
        [self.delegate addBtnClickedInGroupUserContainer];
    }
}



@end
