//
//  AddNoticeViewController.m
//  IM
//
//  Created by  pipapai_tengjun on 15/7/14.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "AddNoticeViewController.h"

@interface AddNoticeViewController ()<UITextViewDelegate>
{
    UITextField *titleTextField;
    UITextView *contentTextView;
    UIView      *addImageFileView;
    UILabel * dlabel;
}
@end

@implementation AddNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
    self.navigationItem.title = @"编辑公告";
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    ILBarButtonItem *rigthItem=[ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_save.png"] highlightedImage:[UIImage imageNamed:@"nav_save.png"] target:self action:@selector(conformsSaveNotice)];
    [self.navigationItem setRightBarButtonItem:rigthItem];
    
    [self configureAddNoticeView];

}

- (void)configureAddNoticeView{
    titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 45)];
    titleTextField.backgroundColor = [UIColor whiteColor];
    titleTextField.textColor = [UIColor hexChangeFloat:@"848484"];
    titleTextField.textAlignment = NSTextAlignmentLeft;
    titleTextField.font = [UIFont systemFontOfSize:16];
    titleTextField.layer.borderColor = [UIColor hexChangeFloat:@"D9D9D9"].CGColor;
    titleTextField.layer.borderWidth = 0.5;
    titleTextField.clearButtonMode = UITextFieldViewModeNever;
    titleTextField.placeholder = @"标题(必填)10-25字";
    [self.view addSubview:titleTextField];
    
    CGRect frame = [titleTextField frame];
    frame.size.width = 10;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    titleTextField.leftViewMode = UITextFieldViewModeAlways;
    titleTextField.leftView = leftview;
    
    UIView *textViewBg = [[UIView alloc]initWithFrame:CGRectMake(0, titleTextField.frame.size.height + titleTextField.frame.origin.y + 10, self.view.frame.size.width, 85)];
    textViewBg.backgroundColor = [UIColor whiteColor];
    textViewBg.layer.borderColor = [UIColor hexChangeFloat:@"D9D9D9"].CGColor;
    textViewBg.layer.borderWidth = 0.5;
    [self.view addSubview:textViewBg];
    
    contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(5, 0, textViewBg.frame.size.width-10, textViewBg.frame.size.height)];
    contentTextView.backgroundColor = [UIColor clearColor];
    contentTextView.textColor = [UIColor hexChangeFloat:@"848484"];
    contentTextView.font = [UIFont systemFontOfSize:16];
    contentTextView.delegate = self;
    [textViewBg addSubview:contentTextView];
    
    dlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 18)];
    dlabel.backgroundColor = [UIColor clearColor];
    dlabel.text = @"正文(必填)15-500字";
    dlabel.font = [UIFont systemFontOfSize:16];
    dlabel.textColor = [UIColor hexChangeFloat:@"D9D9D9"];
    dlabel.textAlignment = NSTextAlignmentLeft;
    [textViewBg addSubview:dlabel];

    addImageFileView = [[UIView alloc]initWithFrame:CGRectMake(0, contentTextView.frame.size.height + contentTextView.frame.origin.y + 10, self.view.frame.size.width, 65)];
    addImageFileView.backgroundColor = [UIColor whiteColor];
    addImageFileView.layer.borderColor = [UIColor hexChangeFloat:@"D9D9D9"].CGColor;
    addImageFileView.layer.borderWidth = 0.5;
    [self.view addSubview:addImageFileView];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 45, 45)];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 45/2;
    imageView.image = [UIImage imageNamed:@"chat_add_user.png"];
    [addImageFileView addSubview:imageView];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.size.width + imageView.frame.origin.x + 15, 0, 100, addImageFileView.frame.size.height)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"添加照片";
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor hexChangeFloat:@"848484"];
    label.textAlignment = NSTextAlignmentLeft;
    [addImageFileView addSubview:label];
    
    addImageFileView.hidden = YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        dlabel.hidden = NO;
    }else{
        dlabel.hidden = YES;
    }
}


- (void)clickLeftItem:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)conformsSaveNotice{
    
    [titleTextField resignFirstResponder];
    [contentTextView resignFirstResponder];
    
    NSString *titleString = [titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *contentString = [contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([titleString length]>=10&&[titleString length]<=25) {
        if ([contentString length] >=15 && [contentString length] <=500) {
            [MMProgressHUD showHUDWithTitle:@"正在提交..." isDismissLater:NO];
            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [[ConfigManager sharedInstance].userDictionary objectForKey:@"token"],@"token",
                                  [NSNumber numberWithLongLong:[self.group.groupid longLongValue]],@"groupId",
                                  @"notice",@"type",
                                  titleString,@"title",
                                  contentString,@"content",
                                  NULL,@"data",
                                  NULL,@"uid",
                                  nil];
            [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodChatContentPublish] parameters:dic successBlock:^(BOOL success, id data, NSString *msg) {
                if (success) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refrshNoticeListView" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                    [MMProgressHUD showHUDWithTitle:@"提交成功..." isDismissLater:YES];
                }
                else{
                    [MMProgressHUD showHUDWithTitle:msg isDismissLater:YES];
                }
            } failureBlock:^(NSString *description) {
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"network_failed") isDismissLater:YES];
                return;
            }];
        }
        else{
            [self.view makeToast:@"您输入的正文长度不对"];
        }
    }
    else{
        [self.view makeToast:@"您输入的标题长度不对"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
