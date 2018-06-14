//
//  CycleScrollView.m
//  TyLoo
//
//  Created by 刘广仁 on 13-1-14.
//  Copyright (c) 2013年 徐 传勇. All rights reserved.
//

#import "CycleScrollView.h"

@implementation CycleScrollView
@synthesize delegate,imagesArray;

- (id)initWithFrame:(CGRect)frame pictures:(NSArray *)pictureArray
{
    self = [super initWithFrame:frame];
    if(self)
    {
        totalPage = pictureArray.count;
        imagesArray = [[NSMutableArray alloc] initWithArray:pictureArray];
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.contentSize = CGSizeMake(boundsWidth * totalPage, 0);
        [self addSubview:scrollView];
                
        CGRect rect = self.bounds;
        rect.origin.y = rect.size.height - 20;
        
        hotBG = [[UIImageView alloc] initWithFrame:rect];
        hotBG.image = [UIImage imageNamed:@"wb_hotBG.png"];
        [self addSubview:hotBG];
        
        hotLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, boundsWidth-10, 20)];
        hotLab.backgroundColor = [UIColor clearColor];
        hotLab.textColor = [UIColor whiteColor];
        hotLab.text = @"StarMeeting视频会议的革新之作1";
        hotLab.font = [UIFont systemFontOfSize:15];
        [hotBG addSubview:hotLab];
        
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(boundsWidth-80, 0, 80, 20)];
        pageControl.userInteractionEnabled = NO;
        pageControl.numberOfPages = totalPage;
        pageControl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[self scaleImage:[UIImage imageNamed:@"wb_active.png"] toScale:CURRENT_SYS_VERSION>=7?0.8:0.6]];
        pageControl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[self scaleImage:[UIImage imageNamed:@"wb_inactive.png"] toScale:CURRENT_SYS_VERSION>=7?0.8:0.6]];

        [hotBG addSubview:pageControl];
        
        [self refreshScrollView];
    }
    
    return self;
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
                                
    return scaledImage;
}
                                
- (void)setControlHidden:(BOOL)isShow
{
    hotBG.hidden = isShow;
}

- (void)refreshScrollView
{
    totalPage = imagesArray.count;
    pageControl.numberOfPages = totalPage;
    scrollView.contentSize = CGSizeMake(boundsWidth * totalPage, 0);
    pageControl.currentPage = 0;
    curPage = 0;
    if(totalPage > 0)
    {
        for (int i = 0; i < totalPage; i++)
        {
            CGFloat orgin_y = 0;
            if(CURRENT_SYS_VERSION < 7.0999999)
            {
                orgin_y = -64;
            }
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*boundsWidth, orgin_y, boundsWidth, scrollView.frame.size.height)];
            imageView.backgroundColor = [UIColor grayColor];
            imageView.image = [UIImage imageNamed:[imagesArray objectAtIndex:i]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.userInteractionEnabled = YES;
//            ConsultModel *data = [imagesArray objectAtIndex:i];
//            [imageView setUrl:data.headLineImg];
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleTap:)];
            [imageView addGestureRecognizer:singleTap];
            
            [scrollView addSubview:imageView];
        }

    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
//    if ([delegate respondsToSelector:@selector(cycleScrollViewDelegate:didScrollImageView:)])
    if (!hotBG.hidden)
    {
        curPage = aScrollView.contentOffset.x / boundsWidth;
//        [delegate cycleScrollViewDelegate:self didScrollImageView:curPage];
        pageControl.currentPage = curPage;
        hotLab.text = [NSString stringWithFormat:@"StarMeeting视频会议的革新之作%d", curPage+1];
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
//{    
//    if ([delegate respondsToSelector:@selector(cycleScrollViewDelegate:didScrollImageView:)]) {
//        curPage = aScrollView.contentOffset.x / boundsWidth;
//        [delegate cycleScrollViewDelegate:self didScrollImageView:curPage];
//        pageControl.currentPage = curPage;
//    }
//}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if ([delegate respondsToSelector:@selector(cycleScrollViewDelegate:didSelectImageView:)]) {
        [delegate cycleScrollViewDelegate:self didSelectImageView:curPage];
    }
}


- (void)dealloc
{

}

@end
