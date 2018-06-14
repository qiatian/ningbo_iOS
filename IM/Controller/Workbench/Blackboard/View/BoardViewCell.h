//
//  BoardViewCell.h
//  IM
//
//  Created by 周永 on 15/11/16.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoardViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel     *deptLabel;               //部门
@property (nonatomic, strong) UILabel     *createTimeLabel;         //创建时间
@property (nonatomic, strong) UILabel     *typeLabel;               //活动类型
@property (nonatomic, strong) UILabel     *titleLabel;              //活动主题
@property (nonatomic, strong) UILabel     *contentLabel;            //具体内容
@property (nonatomic, strong) UIImageView *imageView;               //活动类型背景图片

@end
