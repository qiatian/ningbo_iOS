//
//  SalaryDetailViewDatasource.m
//  IM
//
//  Created by 周永 on 15/11/12.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "SalaryDetailViewDatasource.h"
#import "SalaryDetailCell.h"
#import "UnfoldViewCell.h"

@interface SalaryDetailViewDatasource()

@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, strong) NSArray *details;

@end


@implementation SalaryDetailViewDatasource

- (instancetype)initWithArrayData:(NSArray*)data flag:(NSInteger)flag{
    
    if (self = [super init]) {
        
        _details  = [NSArray arrayWithArray:data];
        
        _flag = flag;
    }
    
    return self;
}

#pragma mark - Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _details.count;
    
}


- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_flag == 0) {
        static NSString *reuseId = @"cell";
        
        SalaryDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
        
        NSString *salary;
        
        if (_salaryInfoHidden) {
            
            salary = @"******";
        }else{
            salary = [NSString stringWithFormat:@"%.2f",[_details[indexPath.item][@"value"] floatValue] / 100];
        }
        
        NSString *detail = _details[indexPath.item][@"name"];
        
        cell.detailSalayLabel.text = salary;
        cell.detailTitleLabel.text = detail;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }else{
        
        static NSString *reuseId = @"unfoldcell";
        UnfoldViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
        
        NSString *salary;
        
        if (_salaryInfoHidden) {
            salary = @"******";
        }else{
            salary = [NSString stringWithFormat:@"%.2f",[_details[indexPath.item][@"value"] floatValue] / 100];
        }
        
        
        NSString *detail = _details[indexPath.item][@"name"];
        if (detail.length > 5) {
            cell.detailTitleLabel.text = [detail substringToIndex:4];
        }else{
           cell.detailTitleLabel.text = detail;
        }
        
        cell.detailSalayLabel.text = salary;

        cell.backgroundColor = BGColor;
        return cell;
    }
    
}

@end
























