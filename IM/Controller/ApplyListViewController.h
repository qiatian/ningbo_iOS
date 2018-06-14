//
//  ApplyListViewController.h
//  IM
//
//  Created by liuguangren on 14-9-11.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "GQBaseViewController.h"
#import "ApplyTableViewCell.h"

@interface ApplyListViewController : GQBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView     *listTab;
    NSMutableArray  *listArr;
}

@property (nonatomic, strong) NSDictionary *categoryDic;
@end
