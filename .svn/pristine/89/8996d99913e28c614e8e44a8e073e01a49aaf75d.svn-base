//
//  MainViewController.m
//  IM
//
//  Created by zuo guoqing on 14-9-11.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "MainViewController.h"
#import "ColleagueViewController.h"
#import "ZTEDiscvoerViewController.h"
#import "ZTEMainTabBar.h"

@interface MainViewController ()<QuadCurveMenuItemDelegate>{
    BOOL centerBntClicked;
}

@property (nonatomic, strong) UIView *guardView;
@property (nonatomic, strong)     NSArray *menus;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isExpanding;
@property (nonatomic, assign) int flag;

@end

@implementation MainViewController
{
    NSString *update_url;
}


-(id) init{
    self=[super init];
    if(self){
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerChange:) name:NOTIFICATION_VIEWCONTROLLER_CHANGE object:nil];
        //[[CCPVoipManager sharedInstance] connectToCCP];
        [self initVoip];
        [self initialize];
    }
    return self;
    
}

-(void)initVoip
{
    [ECDevice sharedInstance].delegate=[DeviceDelegateHelper ShareInstance];
    [[DeviceDelegateHelper ShareInstance] connectVoip];
}

-(void)LogOutDeal:(NSNotification *)noti
{
    for (UIView *view in _guardView.subviews) {
        [view removeFromSuperview];
    }
    [_guardView removeFromSuperview];
    _guardView=nil;
}



-(void) viewControllerChange:(NSNotification*)notification{
    MEnterpriseUser *user =[[notification userInfo] objectForKey:@"user"];
    NSInteger index=[[[notification userInfo] objectForKey:@"index"] integerValue];
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (index) {
            case FunctionItemDesk:{//工作台
                [self.navigationController popToRootViewControllerAnimated:YES];
                self.selectedIndex =0;
            }
                break;
            case FunctionItemMessage:{//消息
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    self.selectedIndex =1;
                }
                break;
            case FunctionItemChat:{
                [self.navigationController popToRootViewControllerAnimated:YES];
                self.selectedIndex =1;
                
                ChatViewController *chatVC =[[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:[NSBundle mainBundle]];
//                chatVC.hidesBottomBarWhenPushed = YES;
                chatVC.chatUser =user;
                chatVC.isGroup =NO;
                
                GQNavigationController *messageListNav =[self.viewControllers objectAtIndex:1];
                [messageListNav pushViewController:chatVC animated:YES];
            }
                break;
            default:
                break;
        }
    });
}


-(void) initialize{
    [self setDelegate:self];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    [self.tabBar setShadowImage:[UIImage new]];
    [self.tabBar setSelectionIndicatorImage:[UIImage new]];
    [self.tabBar setBackgroundImage:[UIImage createImageWithColor:[UIColor hexChangeFloat:@"f8f8f8"] rect:CGRectMake(0, 0, 10.0f, 50.0f)]];
    
    NSMutableArray *viewControllers =[[NSMutableArray alloc] init];
    
    //工作台
//    DeskViewController *desk =[[DeskViewController alloc] init];
//    desk.tabBarItem=[[GQTarBarItem alloc] initWithTitle:@"工作台" image:[UIImage imageNamed:@"tab_desk.png"] selectedImage:[UIImage imageNamed:@"tab_desk_pre.png"] tag:1];
//    [viewControllers addObject:desk];
    JobViewController *job =[[JobViewController alloc] init];
    job.tabBarItem=[[GQTarBarItem alloc] initWithTitle:LOCALIZATION(@"work") image:[UIImage imageNamed:@"tab_task"] selectedImage:[UIImage imageNamed:@"tab_task_pre"] tag:1];
    [viewControllers addObject:job];
    

    //消息
    MessageListViewController *news =[[MessageListViewController alloc] init];
    
    news.tabBarItem=[[GQTarBarItem alloc] initWithTitle:LOCALIZATION(@"Message_tableBar_message") image:[UIImage imageNamed:@"tab_message_inactive"] selectedImage:[UIImage imageNamed:@"tab_message_active"]  tag:2];
    [viewControllers addObject:news];

    //联系人
    //    ContactsViewController *contacts =[[ContactsViewController alloc] initWithNibName:@"ContactsViewController" bundle:[NSBundle mainBundle]];
    //    contacts.segmentedControlIndex = 1;
    ////    contacts.title =@"联系人";
    ////    GQNavigationController *contactsNav =[[GQNavigationController alloc] initWithRootViewController:contacts];
    //    contacts.tabBarItem=[[GQTarBarItem alloc] initWithTitle:@"联系人" image:[[UIImage imageWithFileName:@"p3_nor.png"] imageResizedToSize:CGSizeMake(25, 25)] selectedImage:[[UIImage imageWithFileName:@"p3_pre.png"] imageResizedToSize:CGSizeMake(25, 25)]  tag:3];
    //    [viewControllers addObject:contacts];
    
//    UIViewController *vc=[[UIViewController alloc]init];
//    vc.tabBarItem=[[GQTarBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@""] selectedImage:[UIImage imageNamed:@""]  tag:3];
//    [viewControllers addObject:vc];
    
//    ContactsMainViewController *contacts =[[ContactsMainViewController alloc] init];
//    contacts.tabBarItem=[[GQTarBarItem alloc] initWithTitle:@"同事" image:[UIImage imageNamed:@"tab_colleague.png"] selectedImage:[UIImage imageNamed:@"tab_colleague_pre.png"]  tag:4];
//    [viewControllers addObject:contacts];
    
    ColleagueViewController *cvc=[[ColleagueViewController alloc]init];
    cvc.tabBarItem=[[GQTarBarItem alloc] initWithTitle:LOCALIZATION(@"ColleagueViewController_NavTitle") image:[UIImage imageNamed:@"tab_colleague.png"] selectedImage:[UIImage imageNamed:@"tab_colleague_pre.png"]  tag:4];
    [viewControllers addObject:cvc];

    
//    DiscoverViewController *discover =[[DiscoverViewController alloc] init];
//    discover.tabBarItem=[[GQTarBarItem alloc] initWithTitle:@"发现" image:[UIImage imageNamed:@"tab_discover.png"] selectedImage:[UIImage imageNamed:@"tab_discover_pre.png"] tag:5];
//    [viewControllers addObject:discover];
    
    
    //我的
    ZTEDiscvoerViewController *discover = [[ZTEDiscvoerViewController alloc] init];
    discover.tabBarItem=[[GQTarBarItem alloc] initWithTitle:LOCALIZATION(@"discover") image:[UIImage imageNamed:@"tab_profile_inactive"] selectedImage:[UIImage imageNamed:@"tab_profile_active"] tag:5];
    [viewControllers addObject:discover];
    
    
    //应用
//    ApplyViewController *apply =[[ApplyViewController alloc] init];
//    apply.title =@"应用";
//    GQNavigationController *applyNav=[[GQNavigationController alloc] initWithRootViewController:apply];
//    apply.tabBarItem=[[GQTarBarItem alloc] initWithTitle:@"应用" image:[[UIImage imageWithFileName:@"p4_nor.png"] imageResizedToSize:CGSizeMake(30, 30)] selectedImage:[[UIImage imageWithFileName:@"p4_pre.png"] imageResizedToSize:CGSizeMake(30, 30)]  tag:4];
    //[viewControllers addObject:applyNav];
    self.viewControllers=[NSArray arrayWithArray:viewControllers];
}

-(BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
    
}

-(void) tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLanguageChangedNotification:)
                                                 name:kNotificationLanguageChanged
                                               object:nil];
    
    centerBntClicked = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)centerBtnClick:(UIButton*)btn
{
    
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (centerBntClicked) {
        centerBntClicked = NO;

        [self touchTapClick:nil];
        
    }else{
        centerBntClicked = YES;
        
        _guardView.hidden=!_guardView.hidden;
        
        if (!_guardView)
        {
            _guardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight)];
            _guardView.backgroundColor=[UIColor blackColor];
            _guardView.alpha=0.5;
            [self.view insertSubview:_guardView belowSubview:self.tabBar];
            //        [appDelegate.window addSubview:appDelegate.guardView];
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTapClick:)];
            [_guardView addGestureRecognizer:tap];
            QuadCurveMenuItem *firstBtn=[[QuadCurveMenuItem alloc]initWithImage:[UIImage imageNamed:@""]
                                                               highlightedImage:[UIImage imageNamed:@""]
                                                                   ContentImage:[UIImage imageNamed:@""]
                                                        highlightedContentImage:nil
                                                                      NameLabel:@""];
            firstBtn.backgroundColor = [UIColor clearColor];
            QuadCurveMenuItem *policyBtn=[[QuadCurveMenuItem alloc]initWithImage:[UIImage imageNamed:@"conversation"]
                                                                highlightedImage:[UIImage imageNamed:@"conversation"]
                                                                    ContentImage:[UIImage imageNamed:@"conversation"]
                                                         highlightedContentImage:nil
                                                                       NameLabel:LOCALIZATION(@"conferenceCall")];
            QuadCurveMenuItem *consultBtn=[[QuadCurveMenuItem alloc]initWithImage:[UIImage imageNamed:@"distribution"]
                                                                 highlightedImage:[UIImage imageNamed:@"distribution"]
                                                                     ContentImage:[UIImage imageNamed:@"distribution"]
                                                          highlightedContentImage:nil
                                                                        NameLabel:LOCALIZATION(@"task")];
            QuadCurveMenuItem *taskBtn=[[QuadCurveMenuItem alloc]initWithImage:[UIImage imageNamed:@"consult"]
                                                              highlightedImage:[UIImage imageNamed:@"consult"]
                                                                  ContentImage:[UIImage imageNamed:@"consult"]
                                                       highlightedContentImage:nil
                                                                     NameLabel:LOCALIZATION(@"zhixunfuwu")];
            
            QuadCurveMenuItem *voipBtn=[[QuadCurveMenuItem alloc]initWithImage:[UIImage imageNamed:@"channel"]
                                                              highlightedImage:[UIImage imageNamed:@"channel"]
                                                                  ContentImage:[UIImage imageNamed:@"channel"]
                                                       highlightedContentImage:nil
                                                                     NameLabel:LOCALIZATION(@"government")];
            QuadCurveMenuItem *endBtn=[[QuadCurveMenuItem alloc]initWithImage:[UIImage imageNamed:@""]
                                                             highlightedImage:[UIImage imageNamed:@""]
                                                                 ContentImage:[UIImage imageNamed:@""]
                                                      highlightedContentImage:nil
                                                                    NameLabel:@""];
            endBtn.backgroundColor = [UIColor clearColor];
            _menus=[NSArray arrayWithObjects:firstBtn,policyBtn,consultBtn,taskBtn,voipBtn,endBtn, nil];
            for (int i=0; i<_menus.count; i++)
            {
                QuadCurveMenuItem *item=_menus[i];
                item.tag = 1000 + i;
                item.startPoint = STARTPOINT;
                item.startPoint =CGPointMake(STARTPOINT.x + STARTADIUS * cosf(i * M_PI / (_menus.count - 1)), STARTPOINT.y- STARTADIUS * sinf(i * M_PI / (_menus.count  - 1)) );
                
                item.endPoint = CGPointMake(STARTPOINT.x + ENDRADIUS * cosf(i * M_PI / (_menus.count - 1)), STARTPOINT.y - ENDRADIUS * sinf(i * M_PI / (_menus.count - 1)) );
                item.nearPoint = CGPointMake(STARTPOINT.x + NEARRADIUS * cosf(i * M_PI / (_menus.count - 1) ), STARTPOINT.y- NEARRADIUS * sinf(i * M_PI / (_menus.count - 1)));
                item.farPoint = CGPointMake(STARTPOINT.x + FARRADIUS * cosf(i * M_PI / (_menus.count - 1) ), STARTPOINT.y- FARRADIUS * sinf(i * M_PI / (_menus.count - 1)));
                item.center = item.startPoint;
                item.delegate=appDelegate;
                [appDelegate.window addSubview:item];
            }
        }
        
    }
    
    
    
    _isExpanding=YES;
    if (!_timer)
    {
        _flag = _isExpanding ? 0 : 5;
        SEL selector = _isExpanding ? @selector(_expand) : @selector(_close);
        _timer = [NSTimer scheduledTimerWithTimeInterval:TIMEOFFSET target:self selector:selector userInfo:nil repeats:YES];
    }
    
}


-(void)_close
{
    if (_flag == -1)
    {
        [_timer invalidate];
        _timer = nil;
        return;
    }
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    int tag = 1000 + _flag;
    QuadCurveMenuItem *item = (QuadCurveMenuItem *)[appDelegate.window viewWithTag:tag];
    
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:M_PI * 2],[NSNumber numberWithFloat:0.0f], nil];
    rotateAnimation.duration = 0.5f;
    rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:.0],
                                [NSNumber numberWithFloat:.4],
                                [NSNumber numberWithFloat:.5], nil];
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = 0.5f;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
    CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
    CGPathAddLineToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
    positionAnimation.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, rotateAnimation, nil];
    animationgroup.duration = 0.5f;
    animationgroup.fillMode = kCAFillModeForwards;
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [item.layer addAnimation:animationgroup forKey:@"Close"];
    item.center = item.startPoint;
    _flag --;
}
-(void)touchTapClick:(UITapGestureRecognizer*)tap
{
    if (!_timer)
    {
        _flag = _isExpanding ? 0 : 5;
        SEL selector = _isExpanding ? @selector(_expand) : @selector(_close);
        _timer = [NSTimer scheduledTimerWithTimeInterval:TIMEOFFSET target:self selector:selector userInfo:nil repeats:YES];
    }
    [self performSelector:@selector(hiddenGuardView) withObject:nil afterDelay:0.5];
    
}
-(void)hiddenGuardView
{
    _guardView.hidden=YES;
}
-(void)removeGuardView
{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [_guardView removeFromSuperview];
    _guardView=nil;
    [(QuadCurveMenuItem*)[appDelegate.window viewWithTag:1000] removeFromSuperview];
    [(QuadCurveMenuItem*)[appDelegate.window viewWithTag:1001] removeFromSuperview];
    [(QuadCurveMenuItem*)[appDelegate.window viewWithTag:1002] removeFromSuperview];
    [(QuadCurveMenuItem*)[appDelegate.window viewWithTag:1003] removeFromSuperview];
    [(QuadCurveMenuItem*)[appDelegate.window viewWithTag:1004] removeFromSuperview];
    [(QuadCurveMenuItem*)[appDelegate.window viewWithTag:1005] removeFromSuperview];
}
#pragma mark - QuadCurveMenuItem delegates
- (void)quadCurveMenuItemTouchesBegan:(QuadCurveMenuItem *)item
{
    
}
- (void)quadCurveMenuItemTouchesEnd:(QuadCurveMenuItem *)item
{
    // blowup the selected menu button
    CAAnimationGroup *blowup = [self _blowupAnimationAtPoint:item.center];
    [item.layer addAnimation:blowup forKey:@"blowup"];
    item.center = item.startPoint;
    
    // shrink other menu buttons
    for (int i = 0; i < [_menus count]; i ++)
    {
        QuadCurveMenuItem *otherItem = [_menus objectAtIndex:i];
        CAAnimationGroup *shrink = [self _shrinkAnimationAtPoint:otherItem.center];
        if (otherItem.tag == item.tag) {
            continue;
        }
        [otherItem.layer addAnimation:shrink forKey:@"shrink"];
        
        otherItem.center = otherItem.startPoint;
    }
    _isExpanding = NO;
    
    [self hiddenGuardView];
    [self _close];
    [self quadCurveDidSelectIndex:item.tag-1000];
    
}
- (void)quadCurveDidSelectIndex:(NSInteger)idx
{
    NSLog(@"Select the index : %d",idx);
}
- (CAAnimationGroup *)_blowupAnimationAtPoint:(CGPoint)p
{
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p], nil];
    positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 1)];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, opacityAnimation, nil];
    animationgroup.duration = 0.3f;
    animationgroup.fillMode = kCAFillModeForwards;
    
    return animationgroup;
}

- (CAAnimationGroup *)_shrinkAnimationAtPoint:(CGPoint)p
{
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p], nil];
    positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.01, .01, 1)];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, opacityAnimation, nil];
    animationgroup.duration = 0.3f;
    animationgroup.fillMode = kCAFillModeForwards;
    
    return animationgroup;
}

// Create a custom UIButton and add it to the center of our tab bar
//-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
//{
//    if (self.centerButton)
//    {
//        [self.centerButton removeFromSuperview];
//    }
//    self.centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _centerButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
//    _centerButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
//    [_centerButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [_centerButton setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
//    [_centerButton addTarget:self action:@selector(centerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    CGFloat heightDifference = buttonImage.size.height - self.tabbarController.tabBar.frame.size.height;
//    if (heightDifference < 0)
//        _centerButton.center = self.tabbarController.tabBar.center;
//    else
//    {
//        CGPoint center = self.tabbarController.tabBar.center;
//        center.y = center.y - heightDifference/2.0;
//        //        center.y = center.y - heightDifference;
//        _centerButton.center = center;
//    }
//    
//    [self.window addSubview:_centerButton];
//    AppDelegate *appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//    appDelegate.centerButton=self.centerButton;
//}

-(void)_expand
{
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    _isExpanding=!_isExpanding;
    if (_flag == 6)
    {
        [_timer invalidate];
        _timer = nil;
        return;
    }
    int tag = 1000 + _flag;
    QuadCurveMenuItem *item = (QuadCurveMenuItem *)[appDelegate.window viewWithTag:tag];
    
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:M_PI],[NSNumber numberWithFloat:0.0f], nil];
    rotateAnimation.duration = 0.5f;
    rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:.3],
                                [NSNumber numberWithFloat:.4], nil];
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = 0.5f;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
    CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
    CGPathAddLineToPoint(path, NULL, item.nearPoint.x, item.nearPoint.y);
    CGPathAddLineToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
    positionAnimation.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, rotateAnimation, nil];
    animationgroup.duration = 0.5f;
    animationgroup.fillMode = kCAFillModeForwards;
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [item.layer addAnimation:animationgroup forKey:@"Expand"];
    item.center = item.endPoint;
    
    _flag ++;
}

- (void)receiveLanguageChangedNotification:(NSNotification*)notif{
    
    [Localisator sharedInstance].saveInUserDefaults = YES;
    
    if ([notif.name isEqualToString:kNotificationLanguageChanged])
    {
        
        
        [self refreshTitleLanguage];
        
    }
}
//收到切换语言的通知后 刷新tabbar各界面title
- (void)refreshTitleLanguage{
    
    
    for (int i = 0; i< self.viewControllers.count; i++) {
        
        UIViewController *vc = self.viewControllers[i];
        
        if ([vc isKindOfClass:[JobViewController class]]) {
            
            vc.title = LOCALIZATION(@"work");
            
        }
        
        if ([vc isKindOfClass:[MessageListViewController class]]) {
            
            vc.title = LOCALIZATION(@"Message_tableBar_message");
            
        }
        
        if ([vc isKindOfClass:[ColleagueViewController class]]) {
            
            vc.title = LOCALIZATION(@"ColleagueViewController_NavTitle");
            
        }
        
        if ([vc isKindOfClass:[ZTEDiscvoerViewController class]]) {
            
            vc.title = LOCALIZATION(@"discover");
            
        }
        
    }
    
}

@end
