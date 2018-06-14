//
//  SGAlertController.m
//  Discover
//
//  Created by 周永 on 15/11/6.
//  Copyright © 2015年 shuige. All rights reserved.
//

#import "SGAlertController.h"
#import "Masonry.h"

@interface SGAlertController (){
    
    mailShareHandlerBlock _maileShareHandler;
    messageShareHandlerBlock _messageShareHandler;
    
    UIImage *_mailShareImage;
    UIImage *_messageShareImage;
    
}

@property (nonatomic, copy  ) NSString *alertTitle;

@property (nonatomic, copy  ) NSString *cancelTitle;

@property (nonatomic, strong) UIView   *shareView;


@end

@implementation SGAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //生成一个半透明视图
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
}



- (instancetype)initWithTitle:(NSString *)title CancelTitle:(NSString *)cancelTtile{
    
    if (self = [super init]) {
        
        _alertTitle = title;
        
        _cancelTitle = cancelTtile;
        
        [self setupCancelButton];
        
    }
    
    return self;
}

- (void)setupCancelButton{
    
    //取消按钮
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = 5.0;
    [cancelBtn setTitle:_cancelTitle forState:UIControlStateNormal];
    [self.view addSubview:cancelBtn];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-15);
        make.height.equalTo(@(44.0));
    }];
    
    //
    _shareView = [[UIView alloc] init];
    _shareView.backgroundColor = [UIColor whiteColor];
    _shareView.layer.masksToBounds = YES;
    _shareView.layer.cornerRadius = 5.0;
    [self.view addSubview:_shareView];
    
    [_shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.bottom.equalTo(cancelBtn.mas_top).with.offset(-5);
        make.height.equalTo(@(100.0));
    }];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:13.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = _alertTitle;
    [_shareView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.equalTo(_shareView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.height.equalTo(@(30.00));
        
    }];
    
    //分享按钮排列视图
    UIButton *mailBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    mailBtn.layer.masksToBounds = YES;
    mailBtn.layer.cornerRadius = 5.0;
    [mailBtn setBackgroundImage:[UIImage imageNamed:@"email.png"] forState:UIControlStateNormal];
//    [mailBtn setBackgroundImage:_mailShareImage forState:UIControlStateNormal];
    [mailBtn addTarget:self action:@selector(mailShare) forControlEvents:UIControlEventTouchUpInside];
    [_shareView addSubview:mailBtn];
    
    [mailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat x = ([UIScreen mainScreen].bounds.size.width - 20) * 0.5 * 0.5;
        make.left.equalTo(@(x));
        make.centerY.equalTo(_shareView.mas_centerY).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(40.0, 40.0));
    }];
    
    UILabel *mailLabel = [[UILabel alloc] init];
    mailLabel.font = [UIFont systemFontOfSize:13.0];
    mailLabel.text = LOCALIZATION(@"dis_rec_email");
    mailLabel.textAlignment = NSTextAlignmentCenter;
    [_shareView addSubview:mailLabel];
    
    [mailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mailBtn.mas_bottom);
        make.bottom.equalTo(_shareView.mas_bottom);
        make.left.equalTo(mailBtn.mas_left);
        make.right.equalTo(mailBtn.mas_right);
    }];
    
    
    
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [messageBtn setBackgroundImage:[UIImage imageNamed:@"message.png"] forState:UIControlStateNormal];
    messageBtn.layer.masksToBounds = YES;
    messageBtn.layer.cornerRadius = 5.0;
//    [messageBtn setBackgroundImage:_messageShareImage forState:UIControlStateNormal];
    [messageBtn addTarget:self action:@selector(messageShare) forControlEvents:UIControlEventTouchUpInside];
    [_shareView addSubview:messageBtn];
    
    [messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat x = ([UIScreen mainScreen].bounds.size.width - 20) * 0.5 * 0.5;
        make.right.equalTo(@(-x));
        make.centerY.equalTo(_shareView.mas_centerY).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(40.0, 40.0));
    }];
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = LOCALIZATION(@"dis_rec_msg");
    messageLabel.font = [UIFont systemFontOfSize:13.0];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [_shareView addSubview:messageLabel];
    
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(messageBtn.mas_bottom);
        make.bottom.equalTo(_shareView.mas_bottom);
        make.left.equalTo(messageBtn.mas_left);
        make.right.equalTo(messageBtn.mas_right);
    }];
    
}

- (void)setMailShareImage:(UIImage*)mailShareImage messsageShareImage:(UIImage*)messageShareImage{
    
    _mailShareImage = mailShareImage;
    
    _messageShareImage = messageShareImage;
    
}

- (void)cancelButtonClicked{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    //如果点在分享视图之外 就dismis
    if (!CGRectContainsPoint(_shareView.frame, touchPoint)) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setMailShareHandler:(mailShareHandlerBlock)mailShareHandler messageShareHandler:(messageShareHandlerBlock)messageShareHandler{
    
    _maileShareHandler = mailShareHandler;
    _messageShareHandler = messageShareHandler;
    
}

- (void)mailShare{
    
    _maileShareHandler();
    
}

- (void)messageShare{
    
    _messageShareHandler();
    
}

@end










