//
//  RefuseReasonViewController.h
//  IM
//
//  Created by  pipapai_tengjun on 15/7/1.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefuseReasonViewController : GQBaseViewController<UIAlertViewDelegate,UITextViewDelegate>

@property (nonatomic,copy) NSString * noticId;

@property (nonatomic,assign) BOOL isCancelNoti;//是否是取消通知会议

//-(void)textViewDidChange:(UITextView *)textView;

@end
