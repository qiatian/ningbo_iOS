//
//  SGAlertController.h
//  Discover
//
//  Created by 周永 on 15/11/6.
//  Copyright © 2015年 shuige. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^mailShareHandlerBlock)();
typedef void(^messageShareHandlerBlock)();


@interface SGAlertController : UIViewController


- (instancetype)initWithTitle:(NSString*)title CancelTitle:(NSString*)cancelTtile;

- (void)setMailShareImage:(UIImage*)mailShareImage messsageShareImage:(UIImage*)messageShareImage;

- (void)setMailShareHandler:(mailShareHandlerBlock)mailShareHandler messageShareHandler:(messageShareHandlerBlock)messageShareHandler;

@end
