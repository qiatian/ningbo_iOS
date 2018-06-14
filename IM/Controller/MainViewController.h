//
//  MainViewController.h
//  IM
//
//  Created by zuo guoqing on 14-9-11.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GQNavigationController.h"
#import "GQNavigationController.h"
#import "GQTarBarItem.h"
#import "UIImage+Blur.h"
#import "DeskViewController.h"
#import "JobViewController.h"
#import "ContactsViewController.h"
#import "ApplyViewController.h"
#import "DiscoverViewController.h"
#import "MessageListViewController.h"
#import "ContactsMainViewController.h"

typedef NS_ENUM(NSInteger, FunctionItem) {
    FunctionItemDesk = 0,
    FunctionItemChat = 1,
    FunctionItemMessage = 2,
    FunctionItemDiscover = 3,
};




@interface MainViewController : UITabBarController<UITabBarControllerDelegate,UIAlertViewDelegate>

@end
