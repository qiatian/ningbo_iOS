//
//  TaskDetailViewController.h
//  IM
//
//  Created by ZteCloud on 15/11/13.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "GQBaseViewController.h"

@interface TaskDetailViewController : GQBaseViewController
@property(nonatomic,strong) UINib *nibMessage;
@property(nonatomic,strong) NSString *taskId;
@property(nonatomic,strong) TaskModel *tModel;
@property(nonatomic,strong) TaskQuery *taskDetail;
@end
