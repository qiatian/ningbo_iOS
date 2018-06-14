
//
//  BoardViewFlowLayout.m
//  IM
//
//  Created by 周永 on 15/11/16.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "BoardViewFlowLayout.h"

#define GapBetweenCell 10.0
#define CellHeight 130.0

@interface BoardViewFlowLayout()

//@property (nonatomic, assign) int boardCount;

@end

@implementation BoardViewFlowLayout

- (void)setBoardCount:(int)boardCount{
    
    _boardCount = boardCount;

}

- (instancetype)initWithBoardCount:(int)boardCount{
    
    if (self = [super init]) {
        
        _boardCount = boardCount;
        
    }
    
    return self;
}

- (void)prepareLayout{
    
    
    
}

- (CGSize)collectionViewContentSize{
    
    CGFloat contentSizeHeight = (_boardCount + 1)*GapBetweenCell + _boardCount * CellHeight ;
    CGFloat contentSizeWidth =  self.collectionView.frame.size.width;
    
    return CGSizeMake(contentSizeWidth, contentSizeHeight);
}


- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray *attrs = [NSMutableArray array];
    
    NSIndexPath *indexPath;
    
    for (int i = 0; i < _boardCount; i++) {
        
        indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [attrs addObject:attr];
        
    }
    
    return attrs;
    
}


- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGRect frame = CGRectMake(GapBetweenCell, (GapBetweenCell * (indexPath.item + 1))+ (CellHeight * indexPath.item) , self.collectionView.frame.size.width - GapBetweenCell* 2, CellHeight);
    
    attr.frame = frame;
    
//    attr.zIndex = attr.indexPath.item + 1;
    
    return attr;
    
}

@end







