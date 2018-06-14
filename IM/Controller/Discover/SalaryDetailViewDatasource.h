//
//  SalaryDetailViewDatasource.h
//  IM
//
//  Created by 周永 on 15/11/12.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalaryDetailViewDatasource : NSObject <UICollectionViewDataSource,UICollectionViewDelegate>

/**
 *
 *  @param data 数据源
 *  @param flag 通过flag判断是上部分的数据 还是下部分的数据
 *
 */
- (instancetype)initWithArrayData:(NSArray*)data flag:(NSInteger)flag;

@property (nonatomic, assign) BOOL salaryInfoHidden;

@end
