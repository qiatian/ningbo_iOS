//
//  RefuseReasonViewController.m
//  IM
//
//  Created by  pipapai_tengjun on 15/7/1.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "RefuseReasonViewController.h"
#import "UITextView+Placeholder.h"
@implementation RefuseReasonViewController
{
    UITextView * textView;
    //UILabel *label;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
    if(_isCancelNoti)
    {
        self.navigationItem.title = LOCALIZATION(@"Message_cancelMeeting");
    }
    else
    {
        self.navigationItem.title = LOCALIZATION(@"Message_RefueMet");
    }
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    ILBarButtonItem *rigthItem=[ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_save.png"] highlightedImage:[UIImage imageNamed:@"nav_save.png"] target:self action:@selector(comformSaveInfo)];
    [self.navigationItem setRightBarButtonItem:rigthItem];
    
    if (_isCancelNoti){
    textView = [[UITextView alloc] initWithPlaceholder:LOCALIZATION(@"Message_PleaseDownUp_reson")];
    textView.frame = CGRectMake(20 , 20 , self.view.frame.size.width - 40, 100);
    textView.backgroundColor = [UIColor whiteColor];
    textView.textColor = [UIColor hexChangeFloat:@"333333"];
    textView.textAlignment = NSTextAlignmentLeft;
    textView.font = [UIFont systemFontOfSize:16];
    textView.layer.masksToBounds = YES;
    textView.layer.borderColor = [UIColor hexChangeFloat:@"cecece"].CGColor;
    textView.layer.borderWidth = 1;
    textView.layer.cornerRadius = 5;
    [self.view addSubview:textView];
        
    }else {
        textView = [[UITextView alloc] initWithPlaceholder:LOCALIZATION(@"Message_PleaseDownUp_Refsu")];
        textView.frame = CGRectMake(20 , 20 , self.view.frame.size.width - 40, 100);
        textView.backgroundColor = [UIColor whiteColor];
        textView.textColor = [UIColor hexChangeFloat:@"333333"];
        textView.textAlignment = NSTextAlignmentLeft;
        textView.font = [UIFont systemFontOfSize:16];
        textView.layer.masksToBounds = YES;
        textView.layer.borderColor = [UIColor hexChangeFloat:@"cecece"].CGColor;
        textView.layer.borderWidth = 1;
        textView.layer.cornerRadius = 5;
        [self.view addSubview:textView];
        
    }
    
}



- (void)clickLeftItem:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)comformSaveInfo{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:LOCALIZATION(@"Message_AreYouSure") delegate:self cancelButtonTitle:LOCALIZATION(@"Message_cancel") otherButtonTitles:LOCALIZATION(@"Message_Submit"), nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (_isCancelNoti) {
            [self cancelNoti];
        }
        else{
            [self rejectNoti];
        }
    }
}


-(void)cancelNoti
{
    //取消
    NSString *string =  [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([string length] != 0) {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_Cancel_Notification") isDismissLater:NO];
        NSMutableDictionary * datadic = [NSMutableDictionary dictionary];
        [datadic setObject:[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"] forKey:@"token"];
        [datadic setObject:self.noticId forKey:@"informId"];
        [datadic setObject:textView.text forKey:@"cancelpurpose"];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodCancelInform] parameters:datadic successBlock:^(BOOL success, id data, NSString *msg) {
            if(success)
            {
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_Canceled_notification") isDismissLater:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotiStatusChangeNotification" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [MMProgressHUD showHUDWithTitle:msg isDismissLater:YES];
            }
        } failureBlock:^(NSString *description) {
            [MMProgressHUD showHUDWithTitle:description isDismissLater:YES];
        }];
    }
    else{
        [self.view makeToast:LOCALIZATION(@"Message_PleaseSubReson")];
    }
}

-(void)rejectNoti
{
    //拒绝
    NSString *string =  [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([string length] != 0) {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_Refuing_Notification") isDismissLater:NO];
        NSMutableDictionary * datadic = [NSMutableDictionary dictionary];
        [datadic setObject:[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"] forKey:@"token"];
        [datadic setObject:self.noticId forKey:@"informId"];
        [datadic setObject:textView.text forKey:@"remark"];

        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodRefuseInform] parameters:datadic successBlock:^(BOOL success, id data, NSString *msg) {
            if(success)
            {
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_NotificationRefued") isDismissLater:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotiStatusChangeNotification" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [MMProgressHUD showHUDWithTitle:msg isDismissLater:YES];
            }
        } failureBlock:^(NSString *description) {
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"network_failed") isDismissLater:YES];
        }];
    }
    else{
        [self.view makeToast:LOCALIZATION(@"Message_PleaseSubReson")];
    }
}

@end
