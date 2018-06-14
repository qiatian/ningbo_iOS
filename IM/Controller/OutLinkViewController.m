//
//  NewsLeaderDetailViewController.m
//  IM
//
//  Created by  pipapai_tengjun on 15/7/7.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "OutLinkViewController.h"



@interface OutLinkViewController ()<UIWebViewDelegate>
{
    UIWebView * webView;
     NSString *_curRequestStr;
    
    UIActivityIndicatorView *activityIndicator;
    
    UIImageView *failImgView;
    UIButton *refreshBtn;
}

@property (nonatomic, assign) BOOL hasSystemNavigationBar;  //有没有系统导航栏，没有的话表示HTML页面自带导航栏
@property (nonatomic, assign) BOOL hasBackButton;           //有没有返回按钮（有的HTML页面没有返回按钮，但是也没有系统的导航栏，所以要加一个返回按钮）

@property (nonatomic, copy) NSString *urlOfCurrentPage;
@property (nonatomic, copy) NSString *identity;

@end

@implementation OutLinkViewController
-(void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (self.hasSystemNavigationBar){
        self.navigationController.navigationBar.hidden = NO;
        
    }else{
        self.navigationController.navigationBar.hidden = YES;
    
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor hexChangeFloat:@"f3f3f3"];
    self.navigationItem.title = self.titleString;
    
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    CGFloat originalY;
    CGFloat height;
    
    if (CURRENT_SYS_VERSION >= 7.0) {
        originalY = 20;
        height = self.view.frame.size.height - 20;
    }else{
        originalY = 0;
        height = self.view.frame.size.height;
    }
    
    if (self.hasSystemNavigationBar) {
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, originalY + 44, self.view.frame.size.width,height)];
    }else{
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, originalY, self.view.frame.size.width,height)];
    }
    webView.backgroundColor = [UIColor whiteColor];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    webView.delegate = self;
    [self.view addSubview:webView];

    
    
    if (self.hasBackButton) {
        [self configureBackButton];
    }
    
    [self createLoading];
    
}

- (instancetype)initWithSystemNavigationBar:(BOOL)hasSystemNavigationBar backButton:(BOOL)hasBackButton identity:(NSString*)identity{
    
    if (self = [super init]) {
        
        self.hasSystemNavigationBar = hasSystemNavigationBar;
        self.hasBackButton = hasBackButton;
        self.identity = identity;
    }
    
    return self;
}

- (void)configureBackButton{
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.frame = CGRectMake(0, 10, 35,35);
    [backButton setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [webView addSubview:backButton];
    
}

- (void)back:(UIButton*)btn{
    
    if (self.identity && [self.identity isEqualToString:@"news"]) {
        [self gotoDesk];
        return;
    }
    
    if ([self.urlOfCurrentPage hasSuffix:@"index.htm"]) {//进去第一页
        [self gotoDesk];
    }else{
        [webView goBack];
    }
    
}

-(void)createLoading
{
    //创建UIActivityIndicatorView背底半透明View
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, boundsWidth, viewWithNavNoTabbar)];
    [view setTag:103];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view setAlpha:0.5];
    [self.view addSubview:view];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [activityIndicator setCenter:view.center];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [view addSubview:activityIndicator];
    
}
-(void)refreshView
{
    if (!failImgView) {
        failImgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"network_no"]];
        failImgView.bounds=CGRectMake(0, 0, 170, 145);
        failImgView.center=CGPointMake(boundsWidth/2, boundsHeight/2-NavBarHeight*2);
        [self.view addSubview:failImgView];
        refreshBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        refreshBtn.frame=CGRectMake(NavBarHeight, failImgView.frame.origin.y+failImgView.frame.size.height+EdgeDis, boundsWidth-NavBarHeight*2, 40);
        [refreshBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        [refreshBtn setTitleColor:MainColor forState:UIControlStateNormal];
        [refreshBtn addTarget:self action:@selector(reloadWeb:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:refreshBtn];
        refreshBtn.layer.borderColor=MainColor.CGColor;
        refreshBtn.layer.borderWidth=1.0f;
        refreshBtn.layer.cornerRadius=3;
    }
    if (self.navigationController.navigationBar.hidden) {
        self.navigationController.navigationBar.hidden=NO;
    }
    
    failImgView.hidden=NO;
    refreshBtn.hidden=NO;
    webView.hidden = YES;
}
-(void)hiddenRefreshView
{
    if (!self.hasSystemNavigationBar){
        
        self.navigationController.navigationBar.hidden = YES;
        
    }
    failImgView.hidden=YES;
    refreshBtn.hidden=YES;
}
-(void)reloadWeb:(UIButton*)btn
{
    [self hiddenRefreshView];
    [self createLoading];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}
#pragma mark--------webViewDelegate
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activityIndicator stopAnimating];
    UIView *view = (UIView *)[self.view viewWithTag:103];
    [view removeFromSuperview];
    [self refreshView];
}
- (void)webViewDidFinishLoad:(UIWebView *)myWebView
{
    webView.hidden = NO;
    [activityIndicator stopAnimating];
    UIView *view = (UIView *)[self.view viewWithTag:103];
    [view removeFromSuperview];
    [self hiddenRefreshView];
    
    
    myWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 25, 0);
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityIndicator startAnimating];
}


#pragma mark------交互
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *protocol = @"close";
    NSString *urlString = [[request URL] absoluteString];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.urlOfCurrentPage = urlString;
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"objc"])
    {
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps objectAtIndex:1] componentsSeparatedByString:@":/"];
        NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
        if (1 == [arrFucnameAndParameter count])
        {
            // 没有参数
            if([funcStr isEqualToString:protocol])
            {
                [self gotoDesk];
                return NO;
            }
        }
        else
        {
            //有参数的
            if([funcStr isEqualToString:@"gotoLogin:"])
            {
                [self gotoLogin:[arrFucnameAndParameter objectAtIndex:1]];
            }
        }
        return NO;
        
    }

    return TRUE;
}

//获取参数 退出登录
- (void)gotoLogin:(NSString*)str1{
    
    if (![str1 isEqualToString:@"undefined"]) {
        [UserDefault setObject:str1 forKey:@"LPhone"];
    }
    [[ZTEUserProfileTools sharedTools] logOut];
    
}


- (void)gotoDesk{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)clickLeftItem:(id)sender{
    
    if([webView canGoBack] && self.tag != 1003)
    {
        [webView goBack];
        return;
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
