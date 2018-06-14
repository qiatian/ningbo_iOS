//
//  MyAlertView.m
//  CustomAlertView
//
//  Created by ll on 15-12-12.
//  Copyright (c) 2015年 3G. All rights reserved.
//

#import "MyAlertView.h"
#import "AppDelegate.h"
#define Edges 8
@implementation MyAlertView
@synthesize delegate;

-(id)initWithFrame:(CGRect)frame title:(NSString *)titleStr message:(NSString *)messageStr cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles delegate:(id)myDelegate isDelay:(BOOL)isDelay
{
    if (self = [super initWithFrame:frame])
    {
        self.delegate = myDelegate;
        self.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0 , frame.size.width, 50)];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 1;
//        label.textColor = [UIColor greenColor];
        label.backgroundColor=[UIColor whiteColor];
        [self addSubview:label];
        if (titleStr)
        {
            label.text = titleStr;
        }
        UILabel *hLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, label.frame.size.height+label.frame.origin.y+1, frame.size.width, 1)];
        hLabel.backgroundColor=[UIColor lightGrayColor];
        [self addSubview:hLabel];
        
        self.nameLabel=[self createLabelWithFrame:CGRectMake(Edges, 50+1, self.frame.size.width/3, 30)];
        self.nameLabel.backgroundColor=[UIColor clearColor];
        self.nameLabel.textColor=MainColor;
        [self addSubview:self.nameLabel];
        
        self.timeLabel=[self createLabelWithFrame:CGRectMake(self.nameLabel.frame.origin.x+self.nameLabel.frame.size.width, 50+1, self.frame.size.width/3*2, 30)];
        self.timeLabel.backgroundColor=[UIColor clearColor];
        self.timeLabel.textColor=[UIColor grayColor];
        self.timeLabel.font=[UIFont systemFontOfSize:14];
        [self addSubview:self.timeLabel];
        
        self.contentLabel=[self createLabelWithFrame:CGRectMake(Edges, self.nameLabel.frame.origin.y+self.nameLabel.frame.size.height, self.frame.size.width-Edges*2, 30)];
        self.contentLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:self.contentLabel];
        
        if (isDelay) {
            UILabel *hLabel0=[[UILabel alloc]initWithFrame:CGRectMake(0, _contentLabel.frame.size.height+_contentLabel.frame.origin.y+1, frame.size.width, 1)];
            hLabel0.backgroundColor=[UIColor lightGrayColor];
            [self addSubview:hLabel0];
            
            self.resonTV=[self createTextViewWithFrame:CGRectMake(Edges, self.contentLabel.frame.size.height+self.contentLabel.frame.origin.y+2, self.contentLabel.frame.size.width, 100)];
            self.resonTV.backgroundColor=[UIColor clearColor];
            [self addSubview:self.resonTV];
            
            self.holderLabel=[self createLabelWithFrame:CGRectMake(0, 0, 200, 30)];
            self.holderLabel.backgroundColor=[UIColor clearColor];
            self.holderLabel.textColor=[UIColor grayColor];
            self.holderLabel.text=LOCALIZATION(@"task_delay_reson");
            [self.resonTV addSubview:self.holderLabel];
        }
        else
        {
            self.promptLabel=[[UILabel alloc]initWithFrame:CGRectMake(EdgeDis, _contentLabel.frame.origin.y+_contentLabel.frame.size.height, _contentLabel.frame.size.width, 25)];
            _promptLabel.backgroundColor=[UIColor clearColor];
            _promptLabel.textColor=[UIColor grayColor];
            [self addSubview:_promptLabel];
        }
        
        UILabel *hLabel1=[[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height-45, frame.size.width, 1)];
        hLabel1.backgroundColor=[UIColor lightGrayColor];
        [self addSubview:hLabel1];
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.backgroundColor=[UIColor whiteColor];
        btn1.frame = CGRectMake(0, frame.size.height-44, frame.size.width/2, 44);
        btn1.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btn1 setBackgroundImage:[UIImage imageNamed:@"cancle"] forState:UIControlStateNormal];
        [btn1 setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(onRemove:) forControlEvents:UIControlEventTouchUpInside];
        btn1.tag = 10;
        [self addSubview:btn1];
        
        UILabel *vLabel=[[UILabel alloc]initWithFrame:CGRectMake(btn1.frame.size.width-1, 0, 0.5, btn1.frame.size.height)];
        vLabel.backgroundColor=[UIColor lightGrayColor];
        [btn1 addSubview:vLabel];
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.backgroundColor=[UIColor whiteColor];
        btn2.frame = CGRectMake(frame.size.width/2, frame.size.height-44, frame.size.width/2, 44);
        btn2.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn2 setTitleColor:MainColor forState:UIControlStateNormal];
//        [btn2 setBackgroundImage:[UIImage imageNamed:@"ok"] forState:UIControlStateNormal];
        [btn2 setTitle:otherButtonTitles forState:UIControlStateNormal];

        [btn2 addTarget:self action:@selector(onRemove:) forControlEvents:UIControlEventTouchUpInside];
        btn2.tag = 20;
        [self addSubview:btn2];
    }
    return self;
}
-(void)showInView:(UIView*)superView
{
    self.bgViewTag = arc4random()%100+111;
    self.fatherView=superView;
//    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.4;
    view.tag = self.bgViewTag;
//    [app.window addSubview:view];
//    [app.window addSubview:self];
    [superView addSubview:view];
    [superView addSubview:self];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [view addGestureRecognizer:tap];
    
}
#pragma mark - Gesture
-(void)tapClick:(UITapGestureRecognizer *)sender{
    [self endEditing:YES];
}
-(void)onRemove:(UIButton *)button
{
    UIButton *btn = (UIButton *)button;
    switch (btn.tag) {
        case 10:
        {
            if ([delegate respondsToSelector:@selector(doSomething:indexInt:)])
            {
                [delegate doSomething:self indexInt:0];
            }
            [self removeView];
        }
            break;
            
        case 20:
        {
            if ([delegate respondsToSelector:@selector(doSomething:indexInt:)])
            {
                [delegate doSomething:self indexInt:1];
            }
            
        }
            break;
    }
}
-(void)removeView
{
//    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    UIView *view = (UIView *)[app.window viewWithTag:100];
//    for (UIView *view in self.fatherView.subviews) {
//        if (view.tag==111) {
//            [view removeFromSuperview];
//        }
//    }
    UIView *view = (UIView *)[self.fatherView viewWithTag:self.bgViewTag];
    [view removeFromSuperview];
    [self removeFromSuperview];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length==0)
    {
        _holderLabel.text= @"请填写任务延迟原因";
    }
    else
    {
        _holderLabel.text=@"";
        if (textView.text.length > 100)
        {
            textView.text = [textView.text substringToIndex:100];
        }
    }
}
-(UITextView*)createTextViewWithFrame:(CGRect)frame
{
    UITextView *textView=[[UITextView alloc]initWithFrame:frame];
    textView.delegate=self;
    textView.backgroundColor=[UIColor whiteColor];
    return textView;
}
-(UILabel*)createLabelWithFrame:(CGRect)frame
{
    UILabel *label=[[UILabel alloc]initWithFrame:frame];
    return label;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
