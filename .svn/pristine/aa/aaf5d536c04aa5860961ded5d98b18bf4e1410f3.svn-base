//
//  FPToolController.m
//  IM
//
//  Created by zuo guoqing on 14-11-10.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "FPToolController.h"

@interface FPToolController ()

@end

@implementation FPToolController
@synthesize delegate=_delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)handleBtn:(UIButton *)btn title:(NSString*)title normalImage:(NSString*)normalImage selectedImage:(NSString*)selectedImage normalColor:(UIColor*)normalColor selectedColor:(UIColor*)selectedColor{
    
    [btn setTitleColor:normalColor forState:UIControlStateNormal];
    [btn setTitleColor:selectedColor forState:UIControlStateHighlighted];
    btn.titleLabel.font =[UIFont systemFontOfSize:12.0f];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[[UIImage imageWithFileName:normalImage] imageResizedToSize:CGSizeMake(47, 33)] forState:UIControlStateNormal];
    [btn setImage:[[UIImage imageWithFileName:selectedImage] imageResizedToSize:CGSizeMake(47, 33)] forState:UIControlStateHighlighted];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-15, 45, 0, 0)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(40, -48, 0, 0)];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self handleBtn:self.btnVoice title:@"电话会议" normalImage:@"c_voice.png" selectedImage:@"c_voice_hl.png" normalColor:[UIColor grayColor] selectedColor:[UIColor blackColor]];
    [self handleBtn:self.btnVideo title:@"视频会议" normalImage:@"c_video.png" selectedImage:@"c_video_hl.png" normalColor:[UIColor grayColor] selectedColor:[UIColor blackColor]];
    [self handleBtn:self.btnGroupChat title:@"发起群聊" normalImage:@"c_groupchat.png" selectedImage:@"c_groupchat.png" normalColor:[UIColor blackColor] selectedColor:[UIColor blackColor]];
    [self handleBtn:self.btnSMS title:@"发送短信" normalImage:@"c_sms.png" selectedImage:@"c_sms.png" normalColor:[UIColor blackColor] selectedColor:[UIColor blackColor]];
     [self handleBtn:self.btnEmail title:@"发送邮件" normalImage:@"c_email.png" selectedImage:@"c_email.png" normalColor:[UIColor blackColor] selectedColor:[UIColor blackColor]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickedVoiceBtn:(id)sender {
}
- (IBAction)clickedVideoBtn:(id)sender {
}
- (IBAction)clickedGroupChatBtn:(id)sender {
}
- (IBAction)clickedSMSBtn:(id)sender {
}
- (IBAction)clickedEmailBtn:(id)sender {
}
@end
