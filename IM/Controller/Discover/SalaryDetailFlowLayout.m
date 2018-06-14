//
//  SalaryDetailFlowLayout.m
//  IM
//
//  Created by 周永 on 15/11/12.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "SalaryDetailFlowLayout.h"
#define GapBetweenCell 0.5
#define CellCountInLine 4

#define TopCollectionCellHeight 60.0
#define TopCollectionCellPerRow 4
#define BottomCollectionCellHeight 40.0
#define BottomCollectionCellPerRow 2

@interface SalaryDetailFlowLayout()

@property (nonatomic, assign) NSInteger cellCount;

@property (nonatomic, assign) NSInteger flag;

@end

@implementation SalaryDetailFlowLayout

- (instancetype)initWithFlag:(NSInteger)flag dataCount:(NSInteger)cellCount{
    
    if (self = [super init]) {
        
        _flag = flag;
        
        _cellCount = cellCount;
    }
    
    return self;
}

- (void)prepareLayout{
    
    [super prepareLayout];
    
}

- (CGSize)collectionViewContentSize{
    //如果给的是self.collectionView.contentsize 为（0，0）cellForItemAtIndexPath不会调用
    return CGSizeMake(0.1, 0.1);
    
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect{
    
    
    NSMutableArray *attributes = [NSMutableArray array];
    NSIndexPath *indexPath;
    
    for (int i = 0; i < _cellCount; i++) {
        
        indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [attributes addObject:attr];
    }
    
    return attributes;
    
}


- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    if (_flag == 0) {//上部分工资细节布局
        
        CGFloat width = (self.collectionView.frame.size.width - GapBetweenCell*(CellCountInLine+1)) / CellCountInLine;
        //每个cell 高60
        CGFloat height = 60.0;
        attr.size = CGSizeMake(width, height);
        
        CGPoint orig = CGPointMake(GapBetweenCell,GapBetweenCell);
        
        CGPoint point = CGPointMake(orig.x + (indexPath.item%(CellCountInLine) * (width + GapBetweenCell)), (orig.y + indexPath.item/ CellCountInLine * (height + GapBetweenCell)));
        
        attr.frame = CGRectMake(point.x, point.y, width,height);
        
        
    }else{//cell展开之后的工资细节
        
        
        CGFloat width = self.collectionView.frame.size.width * 0.5;
        CGFloat height = BottomCollectionCellHeight;
        attr.size = CGSizeMake(width, height);
        
        CGPoint orig = CGPointMake(0,0);
        
        CGPoint point = CGPointMake(orig.x + (indexPath.item%2)*width, orig.y + (indexPath.item/2)*height);
        
        attr.frame = CGRectMake(point.x, point.y, width,height);
        
    }
    
    
    
    return attr;
}



@end
