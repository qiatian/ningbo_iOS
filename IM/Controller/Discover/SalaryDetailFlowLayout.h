//
//  SalaryDetailFlowLayout.h
//  IM
//
//  Created by 周永 on 15/11/12.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalaryDetailFlowLayout : UICollectionViewFlowLayout

/**
 *
 *
 *  @param flag      通过flag判断是上部分的布局 还是下部分的布局
 *  @param cellCount 总共有多少cell 通过cellCount来控制cell位置
 *
 */
- (instancetype)initWithFlag:(NSInteger)flag dataCount:(NSInteger)cellCount;

@end
