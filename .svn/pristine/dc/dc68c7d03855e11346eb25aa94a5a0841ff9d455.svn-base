//
//  AllUserViewController.h
//  IM
//
//  Created by 陆浩 on 15/5/10.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllUserCell : UITableViewCell

@property(nonatomic,strong)UIImageView *avatarImageView;

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UIButton *styleSelectButton;

@end

typedef void(^GroupSelectUserBlock)(MGroupUser *groupUser);

@interface AllUserViewController : GQBaseViewController

@property(nonatomic,strong) MGroup *groupUser;

@property(nonatomic,assign) BOOL forSelectUser;//用于群组成员@选择使用

@property(nonatomic,copy)GroupSelectUserBlock selectBlock;

@property (nonatomic, assign) BOOL canDeleteUser;

@end
