//
//  DeskViewController.m
//  IM
//
//  Created by zuo guoqing on 14-9-11.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "DeskViewController.h"
#import "MeetingMainListViewController.h"
#import "NotiListViewController.h"
#import "OutLinkViewController.h"
#import "ApproveListViewController.h"
#define BUTTONDEFAULTTAG    2000

@interface DeskViewController ()
{
    CycleScrollView *scView;
    ILBarButtonItem *leftItem;
    int todayMeetCount;
    int notCompletCount;
    UILabel * numLabel;//会议数
    UILabel * notCompletLabel;//未完成会议
    UILabel * completLabel;//已完成会议
    UIImageView * bigRoundImageView1;//扇形
}

@end

@implementation DeskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRSQLUser) name:NOTIFICATION_R_SQL_USER object:nil];
    }
    return self;
}


-(void)notificationRSQLUser{
    
    NSString *uname =[[ConfigManager sharedInstance].userDictionary  objectForKey:@"name"];
    [ivAvatar setImageWithUrl:[[ConfigManager sharedInstance].userDictionary  objectForKey:@"bigpicurl"] placeHolder:[Common getImageFromColor:[UIColor colorWithRGBHex:uname.hash % 0xffffff]]];
}

//- (void)clickedUserBtn
//{
//    MEnterpriseUser *user =[[MEnterpriseUser alloc] init];
//    user.autograph =[[ConfigManager sharedInstance].userDictionary objectForKey:@"autograph"];
//    user.cid =[[ConfigManager sharedInstance].userDictionary objectForKey:@"cid"];
//    user.cname =[[ConfigManager sharedInstance].userDictionary objectForKey:@"cname"];
//    user.email =[[ConfigManager sharedInstance].userDictionary objectForKey:@"email"];
//    user.extNumber =[[ConfigManager sharedInstance].userDictionary objectForKey:@"extNumber"];
//    user.fax =[[ConfigManager sharedInstance].userDictionary objectForKey:@"fax"];
//    user.gid =[[ConfigManager sharedInstance].userDictionary objectForKey:@"gid"];
//    user.gname =[[ConfigManager sharedInstance].userDictionary objectForKey:@"gname"];
//    user.jid =[[ConfigManager sharedInstance].userDictionary objectForKey:@"jid"];
//    user.mobile =[[ConfigManager sharedInstance].userDictionary objectForKey:@"mob"];
//    user.uname =[[ConfigManager sharedInstance].userDictionary objectForKey:@"name"];
//    user.uid =[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
//    user.telephone =[[ConfigManager sharedInstance].userDictionary objectForKey:@"telephone"];
//    user.remark =[[ConfigManager sharedInstance].userDictionary objectForKey:@"remark"];
//    user.post =[[ConfigManager sharedInstance].userDictionary objectForKey:@"post"];
//    user.viopId =[[ConfigManager sharedInstance].userDictionary objectForKey:@"viopId"];
//    user.viopPwd =[[ConfigManager sharedInstance].userDictionary objectForKey:@"viopPwd"];
//    user.viopSid =[[ConfigManager sharedInstance].userDictionary objectForKey:@"viopSid"];
//    user.viopSidPwd =[[ConfigManager sharedInstance].userDictionary objectForKey:@"viopSidPwd"];
//    user.bigpicurl =[[ConfigManager sharedInstance].userDictionary objectForKey:@"bigpicurl"];
//    user.minipicurl =[[ConfigManager sharedInstance].userDictionary objectForKey:@"minipicurl"];
//    
//    
//    EnterpriseUserCardViewController *userCard =[[EnterpriseUserCardViewController alloc] initWithNibName:@"EnterpriseUserCardViewController" bundle:[NSBundle mainBundle]];
//    userCard.user =user;
////    userCard.hidesBottomBarWhenPushed =YES;
//    [self.navigationController pushViewController:userCard animated:YES];
//
//}

- (void)showMoreVC
{
    MoreViewController *nextVC = [[MoreViewController alloc] init];
    nextVC.title = @"更多";
//    nextVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.drawerController setupGestureRecognizers];
    appDelegate.centerButton.hidden=NO;
    [[appDelegate tabbarController].navigationItem setLeftBarButtonItem:leftItem];
    
    [appDelegate tabbarController].navigationItem.title = self.tabBarItem.title;
    [[appDelegate tabbarController].navigationItem setRightBarButtonItem:nil];
    
    [self getServerDataForTopView];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.drawerController removGestureRecognizers];
//    appDelegate.centerButton.hidden=YES;
    [[appDelegate tabbarController].navigationItem setLeftBarButtonItem:nil];

}

-(void)setupViews{
    self.navigationItem.title =@"工作台";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNotification];
    [self setupBtnsView];
    [self getServerDataForTopView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ivAvatar = [[GQLoadImageView alloc] initWithFrame:CGRectMake(10, 7, 30, 30)];
    NSString *uname =[[ConfigManager sharedInstance].userDictionary  objectForKey:@"name"];
    [ivAvatar setImageWithUrl:[[ConfigManager sharedInstance].userDictionary  objectForKey:@"bigpicurl"] placeHolder:[Common getImageFromColor:[UIColor colorWithRGBHex:uname.hash % 0xffffff]]];
    ivAvatar.layer.cornerRadius = 15;
    ivAvatar.clipsToBounds =YES;
    ivAvatar.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showLeftDrawView)];
    [ivAvatar addGestureRecognizer:tapGes];
    
    leftItem=[ILBarButtonItem barItemWithImage:nil highlightedImage:nil target:self action:nil];
    leftItem.customView = ivAvatar;

    [self setupViews];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UserAvatarChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeadView) name:UserAvatarChange object:nil];
}

- (void)showLeftDrawView{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (leftItem.isSelected) {
        [delegate.drawerController closeDrawerAnimated:YES completion:nil];
    }
    else{
        [delegate.drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
}

- (void)refreshHeadView{
    NSString *uname =[[ConfigManager sharedInstance].userDictionary  objectForKey:@"name"];
    [ivAvatar setImageWithUrl:[[ConfigManager sharedInstance].userDictionary  objectForKey:@"bigpicurl"] placeHolder:[Common getImageFromColor:[UIColor colorWithRGBHex:uname.hash % 0xffffff]]];
}

- (void)setupNotification
{
    CGFloat orgin_y = 0;
    if(CURRENT_SYS_VERSION < 7.0999999)
    {
        orgin_y = 64;
    }
    
//    scView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, orgin_y, boundsWidth, 180) pictures:[NSArray arrayWithObjects:@"ad1.png",@"ad2.png",@"ad3.png", nil]];
    scView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, orgin_y, boundsWidth, 210) pictures:nil];
    scView.delegate = self;
    [scView setControlHidden:YES];
    [self.view addSubview:scView];
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, scView.frame.size.width, scView.frame.size.height)];
    topView.backgroundColor = [UIColor hexChangeFloat:@"f3f3f3"];
    [scView addSubview:topView];
    
    UIImageView * bigRoundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 170 , 170)];
    bigRoundImageView.image = [UIImage imageNamed:@"desk_round_bg"];
    bigRoundImageView.center = CGPointMake(boundsWidth/2, scView.frame.size.height/2);
    [topView addSubview:bigRoundImageView];
    
    bigRoundImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, 180 , 180)];
    bigRoundImageView1.backgroundColor = [UIColor clearColor];
    bigRoundImageView1.center = CGPointMake(boundsWidth/2, scView.frame.size.height/2);

//    CGPoint arcCenter=CGPointMake(bigRoundImageView1.frame.size.width/2, bigRoundImageView1.frame.size.height/2);
//    UIBezierPath *_bezierpath=[UIBezierPath bezierPathWithArcCenter:arcCenter
//                                                             radius:90
//                                                         startAngle:-M_PI_2
//                                                           endAngle:2*M_PI*0.25 -M_PI_2
//                                                          clockwise:YES];
//    [_bezierpath addLineToPoint:arcCenter];
//    [_bezierpath closePath];
//    
//    CAShapeLayer *_shapeLayer=[CAShapeLayer layer];
//    _shapeLayer.fillColor=[UIColor hexChangeFloat:@"0181ca"].CGColor;
//    _shapeLayer.path = _bezierpath.CGPath;
//    _shapeLayer.position =CGPointMake(-arcCenter.x+bigRoundImageView1.frame.size.width/2,-arcCenter.y+bigRoundImageView1.frame.size.height/2);
//    [bigRoundImageView1.layer addSublayer:_shapeLayer];
    [topView addSubview:bigRoundImageView1];
    
    UIImageView * roundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 154 , 154)];
    roundImageView.backgroundColor = [UIColor whiteColor];
    roundImageView.layer.masksToBounds = YES;
    roundImageView.layer.cornerRadius = 154/2;
    roundImageView.layer.borderColor = [UIColor hexChangeFloat:@"f3f3f3"].CGColor;
    roundImageView.layer.borderWidth = 8;
    roundImageView.center = CGPointMake(boundsWidth/2, scView.frame.size.height/2);
    [topView addSubview:roundImageView];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, roundImageView.frame.size.width, 14)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = [UIColor hexChangeFloat:@"C9C9C9"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"今日总会议数";
    [roundImageView addSubview:titleLabel];
    
    numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, titleLabel.frame.size.height + titleLabel.frame.origin.y + 4, roundImageView.frame.size.width, 41)];
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.font = [UIFont systemFontOfSize:40];
    numLabel.textColor = [UIColor hexChangeFloat:@"1E6CC6"];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.text = @"0";
    [roundImageView addSubview:numLabel];

    notCompletLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, numLabel.frame.size.height + numLabel.frame.origin.y + 6, roundImageView.frame.size.width, 15)];
    notCompletLabel.backgroundColor = [UIColor clearColor];
    notCompletLabel.font = [UIFont systemFontOfSize:14];
    notCompletLabel.textColor = [UIColor hexChangeFloat:@"848484"];
    notCompletLabel.textAlignment = NSTextAlignmentCenter;
    notCompletLabel.text = @"未完成:0";
    [roundImageView addSubview:notCompletLabel];

    completLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, notCompletLabel.frame.size.height + notCompletLabel.frame.origin.y + 3, roundImageView.frame.size.width, 15)];
    completLabel.backgroundColor = [UIColor clearColor];
    completLabel.font = [UIFont systemFontOfSize:14];
    completLabel.textColor = [UIColor hexChangeFloat:@"848484"];
    completLabel.textAlignment = NSTextAlignmentCenter;
    completLabel.text = @"已完成:0";
    [roundImageView addSubview:completLabel];

}


- (void)setupBtnsView
{
    NSArray *arr = [NSArray arrayWithObjects:@"电话会议",@"会议通知",@"领客网盘",@"企查查",@"申请审批",@"添加应用", nil];
    NSArray *imgArr = [NSArray arrayWithObjects:@"desk_voipmeeting",@"desk_noti",@"desk_disk",@"desk_company",@"apply_approve",@"wb_add.png",nil];

//    NSArray *arr = [NSArray arrayWithObjects:@"我的邮件",@"我的文档",@"团队协作",@"日程管理",@"业务申请",@"我的审批",@"企业微博",@"添加应用", nil];
//    NSArray *imgArr = [NSArray arrayWithObjects:@"wb_mail.png",@"wb_document.png",@"wb_team.png",@"wb_daily.png",@"wb_ business.png",@"wb_ approval.png",@"wb_weibo.png",@"wb_add.png", nil];
    UIButton *btn;
    int top = boundsHeight>480?37:15;
    CGFloat buttonHeight = boundsHeight>480?114:70;
    CGFloat buttonWidth = (boundsWidth / 4);
    
    for (int i = 0; i < [arr count]; i ++) {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        int index = i%4;
        int row = i/4;
        btn.frame = CGRectMake(index * buttonWidth, scView.frame.size.height+scView.frame.origin.y + row * buttonHeight,buttonWidth+0.5, buttonHeight+0.5);
        [btn setImage:[UIImage imageNamed:[imgArr objectAtIndex:i]] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(top-10, (buttonWidth-40)/2, top+10, (buttonWidth-40)/2)];
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = [BGColor CGColor];
        btn.tag = BUTTONDEFAULTTAG+i;
        [btn addTarget:self action:@selector(btnsClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, buttonHeight*0.68, buttonWidth, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor hexChangeFloat:@"909090"];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = arr[i];
        [btn addSubview:label];
        [self.view addSubview:btn];
    }
}

- (void)btnsClick:(UIButton *)btn
{
    int index = btn.tag - BUTTONDEFAULTTAG;
    switch (index) {
//        case -1:
//        {
//            NSLog(@"添加应用");
//        }
//            break;
        case 0:
        {
            MeetingMainListViewController *vc = [[MeetingMainListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            NotiListViewController *vc = [[NotiListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 3:
        {
            OutLinkViewController *vc = [[OutLinkViewController alloc] init];
            vc.urlString = @"http://pub.weiche.co/eciui/SiteMap";
            vc.titleString = @"企查查";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            ApproveListViewController *vc = [[ApproveListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
        {
            UnworkedViewController *unworked =[[UnworkedViewController alloc] initWithNibName:@"UnworkedViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:unworked animated:YES];
        }
            break;
    }
}

- (void)getServerDataForTopView{
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"],@"token", nil];
    
    [HTTPClient asynchronousGetRequest:ApiPrefix method:[HTTPAddress MethodGetInformNum] parameters:dic successBlock:^(BOOL success, id data, NSString *msg) {
        if (data) {
            NSDictionary * dataDic = (NSDictionary *)data;
            if([dataDic isKindOfClass:[NSDictionary class]])
            {
                todayMeetCount = [[dataDic objectForKey:@"todayNum"] integerValue]?[[dataDic objectForKey:@"todayNum"] integerValue]:0;
                notCompletCount = [[dataDic objectForKey:@"unexpiredNum"] integerValue]?[[dataDic objectForKey:@"unexpiredNum"] integerValue]:0;
                numLabel.text = [NSString stringWithFormat:@"%d",todayMeetCount];
                notCompletLabel.text = [NSString stringWithFormat:@"未完成:%d",notCompletCount];
                completLabel.text = [NSString stringWithFormat:@"已完成:%d",todayMeetCount-notCompletCount];
                [self refreshNotiNumView];
            }
        }
        else{
//            [MMProgressHUD showHUDWithTitle:@"返回空数据" isDismissLater:YES];
            return;
        }
    } failureBlock:^(NSString *description) {
//        [MMProgressHUD showHUDWithTitle:description isDismissLater:YES];
        return;
    }];
}

-(void)refreshNotiNumView
{
    for(CAShapeLayer *layer in bigRoundImageView1.layer.sublayers)
    {
        [layer removeFromSuperlayer];
    }
    
    if(todayMeetCount == 0 || (todayMeetCount-notCompletCount) == 0)
    {
        return;
    }
    
    CGFloat allCount = todayMeetCount;
    CGFloat completCount = todayMeetCount-notCompletCount;
    CGFloat tmp = completCount/allCount;
    
    CGPoint arcCenter=CGPointMake(bigRoundImageView1.frame.size.width/2, bigRoundImageView1.frame.size.height/2);
    UIBezierPath *_bezierpath=[UIBezierPath bezierPathWithArcCenter:arcCenter
                                                             radius:90
                                                         startAngle:- M_PI_2
                                                           endAngle:2 * M_PI * tmp - M_PI_2
                                                          clockwise:YES];
    [_bezierpath addLineToPoint:arcCenter];
    [_bezierpath closePath];
    
    CAShapeLayer *_shapeLayer=[CAShapeLayer layer];
    _shapeLayer.fillColor=[UIColor hexChangeFloat:@"0181ca"].CGColor;
    _shapeLayer.path = _bezierpath.CGPath;
    _shapeLayer.position =CGPointMake(-arcCenter.x+bigRoundImageView1.frame.size.width/2,-arcCenter.y+bigRoundImageView1.frame.size.height/2);
    [bigRoundImageView1.layer addSublayer:_shapeLayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
