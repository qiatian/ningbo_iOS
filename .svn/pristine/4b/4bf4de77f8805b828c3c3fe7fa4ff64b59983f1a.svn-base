//
//  MyAlertView.h
//  CustomAlertView
//
//  Created by ll on 15-12-12.
//  Copyright (c) 2015年 3G. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAlertView : UIView<UITextViewDelegate>
{
    id delegate;
}
-(id)initWithFrame:(CGRect)frame title:(NSString *)titleStr message:(NSString *)messageStr cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles delegate:(id)myDelegate isDelay:(BOOL)isDelay;
-(void)showInView:(UIView*)superView;
-(void)removeView;
@property(nonatomic,retain)id delegate;
@property(nonatomic,retain)UILabel *nameLabel;
@property(nonatomic,retain)UILabel *timeLabel;
@property(nonatomic,retain)UILabel *contentLabel;
@property(nonatomic,retain)UITextView *resonTV;
@property(nonatomic,retain)UILabel *holderLabel;
@property(nonatomic,retain)UIView *fatherView;
@property(nonatomic,retain)UILabel *promptLabel;
@property(nonatomic,assign)int bgViewTag;

@end

@protocol id <NSObject>

@required;
-(void)doSomething:(MyAlertView *)hehe indexInt:(NSInteger)indexInt;

@end
