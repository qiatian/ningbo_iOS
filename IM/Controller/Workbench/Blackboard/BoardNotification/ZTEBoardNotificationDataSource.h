//
//  ZTEBoardNotificationController.h
//  IM
//
//  Created by 周永 on 15/11/21.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTEBoardNotificationDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, strong) NSMutableArray *boardDataArray;   //存放所有消息的数组
@property  (nonatomic, strong) UIViewController *vc;  //哪个控制器的tableview用这个类作为dataSource。 主要为了跳转界面的时候用
+(instancetype)sharedInstance;

@end
