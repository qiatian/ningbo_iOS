//
//  EditUserTableViewCell.h
//  IM
//
//  Created by  pipapai_tengjun on 15/6/28.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditUserTableViewCell : UITableViewCell
//头像cell

@property(nonatomic,strong)UILabel          * nameLabel;
@property(nonatomic,strong)GQLoadImageView  * headView;
@property(nonatomic,strong)UILabel          * headLabel;
@property(nonatomic,strong)UIImageView      * lineView;
@property(nonatomic,strong)UIImageView      * rightView;

- (void)loadDataForCellWithCellName:(NSString *)cellName UserName:(NSString *)name ImageString:(NSString *)imageString;

@end


@interface EditUserInfoTableViewCell : UITableViewCell
//基本信息cell
@property(nonatomic,strong)UILabel      * nameLabel;
@property(nonatomic,strong)UILabel      * infoLabel;
@property(nonatomic,strong)UIImageView  * lineView;
@property(nonatomic,strong)UIImageView  * rightView;

- (void)loadDataForCellWithUserName:(NSString *)name InfoString:(NSString *)infoString isScreenWidth:(BOOL)value;

@end
