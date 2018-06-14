//
//  DetailNewsViewController.m
//  IM
//
//  Created by liuguangren on 14-9-18.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "DetailNewsViewController.h"

@interface DetailNewsViewController ()

@end

@implementation DetailNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)clickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickRightItem
{
    if(shareBG.frameY == 0)
    {
        [self hideShareView];
        return;
    }
    CGRect rect = shareBG.frame;
    rect.origin.y = 0;
    
    NSTimeInterval animationDuration = 0.10f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    shareBG.frame = rect;
    
    [UIView commitAnimations];
}

- (void)hideShareView
{
    CGRect rect = shareBG.frame;
    rect.origin.y = shareBG.frameHeight;
    
    NSTimeInterval animationDuration = 0.10f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    shareBG.frame = rect;
    
    [UIView commitAnimations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setImage:[UIImage imageNamed:@"wb_newsBack.png"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 35)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 50, 30);
    [btn addTarget:self action:@selector(clickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    ILBarButtonItem *rightItem =[ILBarButtonItem barItemWithImage:[[UIImage imageNamed:@"wb_share.png"] imageResizedToSize:CGSizeMake(19, 21)] highlightedImage:[[UIImage imageNamed:@"wb_share.png"] imageResizedToSize:CGSizeMake(19, 21)] target:self action:@selector(clickRightItem)];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    [self setupView];
    
    shareBG = [[UIControl alloc] initWithFrame:CGRectMake(0, viewWithNavNoTabbar, boundsWidth, viewWithNavNoTabbar)];
    shareBG.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wb_shareBGC.png"]];
    shareBG.userInteractionEnabled = YES;
    [shareBG addTarget:self action:@selector(hideShareView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBG];
    
    UIImageView *shareView = [[UIImageView alloc] initWithFrame:CGRectMake(0, shareBG.frameHeight-180, boundsWidth, 180)];
    shareView.userInteractionEnabled = YES;
    shareView.image = [UIImage imageNamed:@"wb_shareBG.png"];
    [shareBG addSubview:shareView];
    
    NSArray *nameArr = [NSArray arrayWithObjects:@"wb_work.png",@"wb_weixin.png",@"wb_weixin2.png",@"wb_qq.png",@"wb_sina.png",@"wb_mails.png", nil];
    NSArray *titleArr = [NSArray arrayWithObjects:@"工作圈",@"微信好友",@"微信朋友圈",@"QQ好友",@"新浪微博",@"邮件", nil];
    UILabel *lab;
    for(int i = 0; i < 6; i++)
    {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(30+(i%3)*105, 5+(i/3)*70, 50, 50);
        btn.tag = 3000+i;
        [btn setImage:[UIImage imageNamed:[nameArr objectAtIndex:i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:btn];
        
        lab = [[UILabel alloc] initWithFrame:CGRectMake(10+(i%3)*105, 55+(i/3)*70, 90, 20)];
        lab.text = [titleArr objectAtIndex:i];
        lab.backgroundColor = [UIColor clearColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor blackColor];
        lab.font = FONT12;
        [shareView addSubview:lab];
    }
    
    lab = [[UILabel alloc] initWithFrame:CGRectMake(0, shareView.frameHeight-36, boundsWidth, 1)];
    lab.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wb_newsLine.png"]];
    [shareView addSubview:lab];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, shareView.frameHeight-35, boundsWidth, 35);
    [btn setBackgroundImage:[UIImage imageNamed:@"wb_cancelBtn.png"] forState:UIControlStateNormal];
    [btn setTitle:@"取 消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:btn];
}

- (void)btnClick:(UIButton *)btn
{
//    [self hideShareView];
}

- (void)cancelBtnClick
{
    [self hideShareView];
}

- (void)setupView
{
    UIScrollView *scView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, viewWithNavNoTabbar)];
    scView.backgroundColor = [UIColor whiteColor];
    scView.contentSize = CGSizeMake(0, 0);
    [self.view addSubview:scView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, boundsWidth-20, 20)];
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor blackColor];
    lab.font = [UIFont systemFontOfSize:18];
    lab.text = @"StarMeeting视频会议的革新之作!";
    [scView addSubview:lab];
    
    lab = [[UILabel alloc] initWithFrame:CGRectMake(10, lab.frameBottom+5, boundsWidth-20, 15)];
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor lightGrayColor];
    lab.font = [UIFont systemFontOfSize:11];
    lab.text = @"会议云 08-15 16:25";
    [scView addSubview:lab];
    
    lab = [[UILabel alloc] initWithFrame:CGRectMake(10, lab.frameBottom+5, boundsWidth-20, 1)];
    lab.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wb_newsLine.png"]];
    [scView addSubview:lab];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, lab.frameBottom+9, boundsWidth-20, 198)];
    img.image = [UIImage imageNamed:@"wb_detaiPic.png"];
    img.contentMode = UIViewContentModeScaleAspectFit;
    [scView addSubview:img];
    
    lab = [[UILabel alloc] initWithFrame:CGRectMake(10, img.frameBottom+9, boundsWidth-20, 13)];
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor lightGrayColor];
    lab.font = [UIFont systemFontOfSize:13];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"深圳市中兴云服务有限公司总经理王东鸣先生";
    [scView addSubview:lab];
    
    lab = [[UILabel alloc] initWithFrame:CGRectMake(10, lab.frameBottom, boundsWidth-20, 10)];
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor blackColor];
    lab.numberOfLines = 0;
    lab.font = [UIFont systemFontOfSize:13];
    lab.text = @"       会议云方案由会议管理系统、视频会议系统、统一通信系统三个模块构成，实现语音、视频、数据等信息的无界限传递和交互。作为统一通讯和协同办公的重要组件，会议云能够与企业OA流进一步集成，形成企业协同办公云.会议云方案由会议管理系统、视频会议系统、统一通信系统三个模块构成，实现语音、视频、数据等信息的无界限传递和交互。作为统一通讯和协同办公的重要组件，会议云能够与企业OA流进一步集成，形成企业协同办公云.会议云方案由会议管理系统、视频会议系统、统一通信系统三个模块构成，实现语音、视频、数据等信息的无界限传递和交互。作为统一通讯和协同办公的重要组件，会议云能够与企业OA流进一步集成，形成企业协同办公云.会议云方案由会议管理系统、视频会议系统、统一通信系统三个模块构成，实现语音、视频、数据等信息的无界限传递和交互。作为统一通讯和协同办公的重要组件，会议云能够与企业OA流进一步集成，形成企业协同办公云.";
    CGSize labelsize = [lab.text sizeWithFont:lab.font constrainedToSize:CGSizeMake(boundsWidth-20, boundsHeight*5) lineBreakMode:NSLineBreakByWordWrapping];
    lab.frame = CGRectMake(10, lab.frameBottom, boundsWidth-20, labelsize.height);
    [scView addSubview:lab];
    
    scView.contentSize = CGSizeMake(0, lab.frameBottom);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
