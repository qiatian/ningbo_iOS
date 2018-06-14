//
//  ApplyViewController.h
//  IM
//
//  Created by zuo guoqing on 14-9-11.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "GQBaseViewController.h"
#import "ApplyListViewController.h"

@interface ApplyViewController : GQBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView     *categoryTab;
    NSMutableArray  *categoryArr;
}
@end
