//
//  ApproveListViewController1.m
//  IM
//
//  Created by ZteCloud on 15/11/25.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "ApproveListViewController1.h"
#import "BoardViewFlowLayout.h"
#import "BoardViewCell.h"
@interface ApproveListViewController1 ()
{
    NSMutableArray *dataArr;
    NSInteger currentPage;
}

@end

@implementation ApproveListViewController1

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的审批";
    dataArr=[[NSMutableArray alloc]initWithCapacity:0];
    currentPage=0;
    [self getApplicationListReq];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[BoardViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.alwaysBounceVertical = YES;
    // Do any additional setup after loading the view.
    [self configureUI];
}
- (void)configureUI{
    
    self.collectionView.backgroundColor = BGColor;
    //    CGFloat contentSizeHeight = (_boardArray.count + 1)*GapBetweenCell + _boardArray.count * CellHeight;
    
    
    ApproveListViewController1 *blockSelf=self;
    
    //下拉刷新
    [self.collectionView addPullToRefreshWithActionHandler:^{
        NSLog(@"0000");
        currentPage=0;
        [blockSelf getApplicationListReq];
    }];
    //上拉加载
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        NSLog(@"1111");
        currentPage=currentPage+2;
        [blockSelf getApplicationListReq];
        
    }];
    
    
    [self.collectionView.pullToRefreshView setTitle:@"正在刷新..." forState:SVPullToRefreshStateAll];
    
}
-(void)getApplicationListReq
{
    //    [MMProgressHUD showHUDWithTitle:@"正在获取用户加入企业列表..." isDismissLater:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"]] forKey:@"token"];
        [parameters setObject:[NSString stringWithFormat:@"%d",currentPage] forKey:@"page"];
        
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodGetApplication] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
//            NSLog(@"%@",msg);
            if(success && [data isKindOfClass:[NSDictionary class]]){
//                NSLog(@"%@",data);
                //                [MMProgressHUD showHUDWithTitle:data[@"res"][@"resMessage"] isDismissLater:YES];
                NSMutableArray *arr=[[NSMutableArray alloc]initWithCapacity:0];
                for (NSDictionary*dic in data[@"item"])
                {
                    Consumer *cm=[[Consumer alloc]initWithDictionary:dic];
                    [arr addObject:cm];
                }
                if (currentPage==0)
                {
                    [dataArr removeAllObjects];
                }
                [dataArr addObjectsFromArray:arr];
                [self.collectionView reloadData];
//                [self resetLayoutForCollectionView];
                
                [self.collectionView.pullToRefreshView stopAnimating];
                [self.collectionView.infiniteScrollingView stopAnimating];
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD showHUDWithTitle:msg isDismissLater:YES];
                });
            }
        } failureBlock:^(NSString *description) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MMProgressHUD showHUDWithTitle:@"网络请求失败" isDismissLater:YES];
            });
            
        }];
    });
}
//- (void)resetLayoutForCollectionView{
//    //重新设置布局
//    BoardViewFlowLayout *flowLayout = [[BoardViewFlowLayout alloc] initWithBoardCount:dataArr.count];
//    [self.collectionView setCollectionViewLayout:flowLayout];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BoardViewCell *cell;
    @try{
       cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    }
    @catch(NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }
    
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 10.0;
    cell.layer.borderWidth = 1.0;
    cell.layer.borderColor = [UIColor grayColor].CGColor;
    cell.deptLabel.textColor=MainColor;
    cell.titleLabel.textColor=[UIColor blackColor];
    
    Consumer *tm=[dataArr objectAtIndex:indexPath.row];
    
    cell.deptLabel.text = tm.name;
    cell.createTimeLabel.text = [NSString stringWithFormat:@"%@",[Common getChineseTimeFrom:[tm.createTime longLongValue]]];
    cell.imageView.image = [self imageWithBoardTypeName:tm.status];
    cell.typeLabel.text = @"dddd";
    cell.titleLabel.text = [NSString stringWithFormat:@"手机号%@申请加入%@",tm.mobile,[[ConfigManager sharedInstance].userDictionary objectForKey:@"cname"]];
    cell.contentLabel.text = [NSString stringWithFormat:@"加入申请"];
    
    
    return cell;
}
- (UIImage*)imageWithBoardTypeName:(NSString*)typeName{
    
    
    if ([typeName isEqualToString:@"APPROVED"])
    {
        return [UIImage imageNamed:@"bg_white"];
    }
    if ([typeName isEqualToString:@"INVALID"])
    {
        return [UIImage imageNamed:@"bg_gray"];
    }
    if ([typeName isEqualToString:@"REJECTED"])
    {
        return [UIImage imageNamed:@"bg_white"];
    }
    if ([typeName isEqualToString:@"CANCELLED"])
    {
        return [UIImage imageNamed:@"bg_gray"];
    }
    if ([typeName isEqualToString:@"CREATED"])
    {
        return [UIImage imageNamed:@"bg_red"];
    }
    return nil;
    
}
-(UILabel*)typeWithName:(NSString*)typeName
{
    UILabel *typeLabel;
    if ([typeName isEqualToString:@"APPROVED"])
    {
        typeLabel.textColor=[UIColor greenColor];
        typeLabel.text=@"已同意";
        return typeLabel;
    }
    if ([typeName isEqualToString:@"INVALID"])
    {
        typeLabel.textColor=[UIColor whiteColor];
        typeLabel.text=@"状态无效";
        return typeLabel;
    }
    if ([typeName isEqualToString:@"REJECTED"])
    {
        typeLabel.textColor=[UIColor redColor];
        typeLabel.text=@"已拒绝";
        return typeLabel;
    }
    if ([typeName isEqualToString:@"CANCELLED"])
    {
        typeLabel.textColor=[UIColor whiteColor];
        typeLabel.text=@"已取消";
        return typeLabel;
    }
    if ([typeName isEqualToString:@"CREATED"])
    {
        typeLabel.textColor=[UIColor whiteColor];
        typeLabel.text=@"待处理";
        return typeLabel;
    }
    return nil;
}
#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
