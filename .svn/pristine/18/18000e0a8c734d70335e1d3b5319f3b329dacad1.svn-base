//
//  CycleScrollView.h
//  TyLoo
//
//  Created by 刘广仁 on 13-1-14.
//  Copyright (c) 2013年 刘广仁. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CycleScrollViewDelegate;

@interface CycleScrollView : UIView<UIScrollViewDelegate>
{
    UIScrollView *scrollView;    
    UIPageControl *pageControl;
    
    int curPage;
    int totalPage;
    
    NSMutableArray *imagesArray;        // 存放所有需要滚动的图片
    
    __unsafe_unretained id delegate;
    
    UIImageView *hotBG;
    UILabel     *hotLab;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) NSMutableArray *imagesArray;

- (id)initWithFrame:(CGRect)frame pictures:(NSArray *)pictureArray;
- (void)refreshScrollView;
- (void)setControlHidden:(BOOL)isShow;

@end

@protocol CycleScrollViewDelegate <NSObject>
@optional
- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didSelectImageView:(int)index;
- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didScrollImageView:(int)index;

@end
