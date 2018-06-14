//
//  TableViewCell_approve.h
//  IM
//
//  Created by ZteCloud on 15/10/21.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell_approve : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;

@end
