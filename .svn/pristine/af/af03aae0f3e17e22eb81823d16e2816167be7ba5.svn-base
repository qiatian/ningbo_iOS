//
//  ChatMoreFooterView.m
//  IM
//
//  Created by syj on 15/4/28.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "ChatMoreFooterView.h"

@implementation ChatMoreFooterView
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialSettings];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if(self){
        [self initialSettings];
        
    }
    return self;
}

-(void) initialSettings{
    self.backgroundColor = [UIColor whiteColor];
    NSArray *imgArr = [NSArray arrayWithObjects:@"chat_copy",@"chat_zhuan",@"chat_delete",@"chat_mail", nil];
    for (int i = 0; i < 4; i ++) {
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(((boundsWidth - 30*4)/5 + 30) *(i%4)+(boundsWidth - 30*4)/5, 9, 30, 30)];
        [btn setImage:[[UIImage imageNamed:[imgArr objectAtIndex:i]] imageResizedToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

-(void) btnClicked:(id)sender
{
    int tag = ((UIButton *)sender).tag;
    switch (tag) {
        case 0:
            //复制
            [delegate copyText];
            break;
        case 1:
            //转发
            [delegate sendToOther];
            break;
        case 2:
            //删除
            [delegate deleteSelectMessage];
            break;
        case 3:
            //邮件
            [delegate emailMessage];
            break;
        default:
            break;
    }
}

@end

