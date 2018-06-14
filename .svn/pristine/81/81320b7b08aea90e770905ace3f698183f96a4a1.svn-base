//
//  ZTEBlackboardViewController.m
//  IM
//
//  Created by 周永 on 15/11/16.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "ZTEBoardViewController.h"
#import "ZTECreateBoardController.h"
#import "ZTEBoardDetailViewController.h"
#import "BoardViewFlowLayout.h"
#import "BoardViewCell.h"
#import "NSString+Helpers.h"


@interface ZTEBoardViewController ()

@property (nonatomic, strong) NSMutableArray *boardArray;       //所有小黑板数组
@property (nonatomic, assign) NSInteger       currentPage;      //公告分页显示 当前页数

@property (nonatomic, assign) BOOL  refreshing;

@end

@implementation ZTEBoardViewController

static NSString * const reuseIdentifier = @"BoardViewCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = LOCALIZATION(@"board_title");
    _boardArray = [NSMutableArray array];
    _currentPage = 1;
    _refreshing = NO;
    
    [self getAllBoardInfoFromServerWithFlag:0];
    [self configureUI];
    
    // Register cell classes
    [self.collectionView registerClass:[BoardViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.alwaysBounceVertical = YES;
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBoardList) name:ZTEBoardSuccessCreatedNotfication object:nil];
    
    [super viewWillAppear:animated];

}


#pragma mark - self method
/**
 *  接收新新创建公告通知 刷新列表
 */
- (void)refreshBoardList{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZTEBoardSuccessCreatedNotfication object:nil];

    [self getAllBoardInfoFromServerWithFlag:0];
    
}


- (void)configureUI{
    
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    self.collectionView.backgroundColor = BGColor;
//    CGFloat contentSizeHeight = (_boardArray.count + 1)*GapBetweenCell + _boardArray.count * CellHeight;
    
    //添加小黑板信息按钮
    
    NSDictionary *dict = [ConfigManager sharedInstance].userDictionary;
    
    
    if ([dict[@"isManager"] intValue] || [dict[@"userType"] isEqualToString:@"admin"]) {
        
        UIButton *checkButton = [[UIButton alloc] init];
        checkButton.frame = CGRectMake(0, 0, 30.0, 30.0);
        [checkButton setBackgroundImage:[UIImage imageNamed:@"nav_add"] forState:UIControlStateNormal];
        [checkButton addTarget:self action:@selector(createBoard) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:checkButton];
    }
    
    
    
    ZTEBoardViewController *blockSelf = self;
    //下拉刷新
    [self.collectionView addPullToRefreshWithActionHandler:^{
        
        if (!blockSelf.refreshing) {
            
            _currentPage = 1;
            [blockSelf getAllBoardInfoFromServerWithFlag:0];
            
        }
        
    }];
    
    //上拉刷新  分页显示
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        
        if (!blockSelf.refreshing) {
            
            NSLog(@"上拉刷新小黑板");
            blockSelf.currentPage++;
            
            [blockSelf getAllBoardInfoFromServerWithFlag:1];
        }
        
    }];
    
    
    [self.collectionView.pullToRefreshView setTitle:LOCALIZATION(@"drag_refresh") forState:SVPullToRefreshStateAll];

}

- (void)clickLeftItem:(ILBarButtonItem*)item{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _boardArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BoardViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 10.0;
    cell.layer.borderWidth = 1.0;
    cell.layer.borderColor = [UIColor grayColor].CGColor;
    
    NSDictionary *boardDict = _boardArray[indexPath.item];
    //提取数据
    NSString *dept = boardDict[@"deptName"];
    NSNumber *dateInterverl = boardDict[@"createTime"];
    NSString *createTime = [NSString timeStringForTimeGettedFromServer:dateInterverl timeFormatter:@"MM-dd HH:mm"];
    NSString *type = boardDict[@"typeName"];
    NSString *title = boardDict[@"title"];
    NSString *content = boardDict[@"content"];
    
    //显示
    cell.deptLabel.text = dept;
    cell.createTimeLabel.text = createTime;
    cell.imageView.image = [self imageWithBoardTypeName:type];
    cell.typeLabel.text = type;
    cell.titleLabel.text = title;
    cell.contentLabel.text = content;
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSDictionary *dict = _boardArray[indexPath.item];
    
    ZTEBoardDetailViewController *boardDetailVC = [[ZTEBoardDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    boardDetailVC.boardDetailDict = dict;
    
    [self.navigationController pushViewController:boardDetailVC animated:YES];
    
}


#pragma mark - private method
/**
 *  从服务器获取小黑板列表 flag表示是下拉刷新0 还是上推刷新1
 */
- (void)getAllBoardInfoFromServerWithFlag:(NSInteger)flag{
    
    self.refreshing = YES;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *token = [ConfigManager sharedInstance].userDictionary[@"token"];
    NSNumber *page = [NSNumber numberWithInteger:_currentPage];
    //设置参数
    [parameters setValue:token forKey:@"token"];
    [parameters setValue:page forKey:@"page"];
    
    [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodGetBoard] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
        if (data) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dic = (NSDictionary *)data;
                NSDictionary * resDic = [dic objectForKey:@"res"];
                if ([resDic objectForKey:@"reCode"] && [[resDic objectForKey:@"reCode"]intValue]==1 ) {//数据返回成功
                    
                    
                    if (flag == 0) {//下拉刷新
                        
                        _boardArray = [NSMutableArray arrayWithArray:dic[@"board"]];
                        
                    }else{//上推刷新

                        if ([dic[@"board"] count] == 0) {
                            
                            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"data_loaded") isDismissLater:YES];
                            
                        }else{
                            [_boardArray addObjectsFromArray:dic[@"board"]];
                            
                        }
                        
                    }
                    
                    if (flag == 0) {
                        
                        [self.collectionView reloadData];
                        
                    }
                    self.refreshing = NO;
                    BoardViewFlowLayout *flowLayout = (BoardViewFlowLayout*)self.collectionView.collectionViewLayout;
                    flowLayout.boardCount = _boardArray.count;
                    [self.collectionView.collectionViewLayout invalidateLayout];
                    [self.collectionView reloadData];
                    [self.collectionView.pullToRefreshView stopAnimating];
                    [self.collectionView.infiniteScrollingView stopAnimating];
                }
            }
            else{
                
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"formatter_error") isDismissLater:YES];
            }
        }
        else{
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"data_nil") isDismissLater:YES];
        }
        
    } failureBlock:^(NSString *description) {
        
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"network_failed") isDismissLater:YES];
        return;
        
    }]; 
    
    
}


/**
 *  添加小黑板信息
 */
- (void)createBoard{
    
    ZTECreateBoardController *createBoardVC = [[ZTECreateBoardController alloc] initWithStyle:UITableViewStyleGrouped];
    
    [self.navigationController pushViewController:createBoardVC animated:YES];
    
}


- (UIImage*)imageWithBoardTypeName:(NSString*)boardTypeName{
    
    
    if ([boardTypeName isEqualToString:@"行政通知"]) {
        return [UIImage imageNamed:@"red_frame"];
    }else if ([boardTypeName isEqualToString:@"财务通知"]){
        return [UIImage imageNamed:@"orange_frame"];
    }else{
        return [UIImage imageNamed:@"blue_frame"];
    }
    
}


@end







