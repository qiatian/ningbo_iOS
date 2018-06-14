//
//  LocalContactsViewController.h
//  IM
//
//  Created by 陆浩 on 15/4/26.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectLocalUserBlock)(RHPerson *model);

@interface LocalContactsViewController : GQBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(strong, nonatomic) UITableView *localTBView;

@property(nonatomic,strong) UINib *nibLocalContacts;

@property(strong, nonatomic) NSMutableDictionary *localContacts;
@property(nonatomic,strong)   NSMutableArray *localContactKeys;



@property (nonatomic) RHAddressBook* addressBook;

@property (nonatomic,assign)BOOL forSelectUser;//用来选择人的
@property(nonatomic,copy)SelectLocalUserBlock selectBlock;



@end
