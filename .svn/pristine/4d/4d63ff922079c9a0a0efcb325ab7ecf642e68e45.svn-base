//
//  LKStoreTableViewCell.h
//  IM
//
//  Created by  pipapai_tengjun on 15/7/6.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewsLeaderTableViewCellDelegate <NSObject>

- (void)didButtonClicked:(NSIndexPath*)path;

@end

@interface NewsLeaderTableViewCell : UITableViewCell<NewsLeaderTableViewCellDelegate>

@property (nonatomic,strong)UILabel * titleLabel1;
@property (nonatomic,strong)UIImageView * logoImageView1;
@property (nonatomic,strong)UIImageView * lineImageView1;
@property (nonatomic,assign)UIButton * button1;

@property (nonatomic,strong)UILabel * titleLabel2;
@property (nonatomic,strong)UIImageView * logoImageView2;
@property (nonatomic,strong)UIImageView * lineImageView2;
@property (nonatomic,assign)UIButton * button2;

@property (nonatomic,strong)UILabel * titleLabel3;
@property (nonatomic,strong)UIImageView * logoImageView3;
@property (nonatomic,assign)UIButton * button3;

@property (nonatomic,assign)id <NewsLeaderTableViewCellDelegate>delegate;

- (void)loadDataWithTitleName:(NSArray *)titleArray ImageName:(NSArray *)imageArray IndexPath:(NSIndexPath *)path;

@end
