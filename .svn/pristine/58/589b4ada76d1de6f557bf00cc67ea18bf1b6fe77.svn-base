//
//  ChatUserContainer.h
//  IM
//
//  Created by syj on 15/4/26.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GQLoadImageView.h"
#import "MEnterpriseUser.h"
#import "Common.h"
@protocol ChatUserContainerDelegate <NSObject>

-(void)userItemTapedInGroupUserContainer:(MEnterpriseUser*)userItem;
-(void)addBtnClickedInGroupUserContainer;
-(void)btnDeleteClickedInGroupUserItemWithUsers:(NSMutableArray*)users isReload:(BOOL)isReload deleteUserId:(NSString*)deleteUserId;
@end

@interface ChatUserContainer : UIView
{
    UIButton *addBtn;
    NSMutableArray *userItems;
}

@property(nonatomic,strong)UILabel *labUserName;
@property(nonatomic,strong)GQLoadImageView *ivAvatar;
@property(nonatomic,strong)UILabel *labAvatar;
@property(nonatomic,strong)UILabel *labIdNumber;
@property(nonatomic,strong)UIButton *btnDelete;

@property(nonatomic,strong)MEnterpriseUser *user;
@property(nonatomic,assign) id<ChatUserContainerDelegate>delegate;
-(void)addUserItems:(MEnterpriseUser*)enterpriseUser;
@end
