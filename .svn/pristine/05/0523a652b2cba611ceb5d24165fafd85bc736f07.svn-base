//
//  AllMettingUserViewController.h
//  IM
//
//  Created by 陆浩 on 15/5/27.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshViewBlock)(void);

typedef void(^GroupSelectUserBlock)(MGroupUser *groupUser);

typedef void (^DeletedUsersBlock)(NSArray *users);

@interface AllMettingUserViewController : GQBaseViewController

@property(nonatomic,strong)NSMutableArray *mettingUserArray;

@property(nonatomic,assign)BOOL isMineMetting;//是否是当前用户创建的会议,只用于会议通知模块

@property(nonatomic,assign)BOOL canDeleteUser;//是否可以删除成员，用于电话会议详情页删除成员

@property (nonatomic, assign) BOOL canDeleteFirstUser; //如果是会议通知，第一个成员不是创建者，可以删除，如果是电话会议，第一个成员是创建者，不能删除。

@property(nonatomic,assign)BOOL fromHistoryMeeting;

@property(nonatomic,copy)RefreshViewBlock refresheBlock;



@property(nonatomic,assign) BOOL forSelectUser;//用于群组成员@选择使用

@property(nonatomic,copy)GroupSelectUserBlock selectBlock;

@property (nonatomic, copy) DeletedUsersBlock deletedUsersBlock;


@end
