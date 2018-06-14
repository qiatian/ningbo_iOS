//
//  ZTESalaryViewController.m
//  IM
//
//  Created by 周永 on 15/11/12.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "ZTESalaryViewController.h"
#import "SalaryDetailViewDatasource.h"
#import "SalaryDetailFlowLayout.h"
#import "SalaryBottomViewCell.h"
#import "SalaryTopViewCell.h"
#import "UnfoldViewCell.h"
#import "SalaryDetailCell.h"
#import "Masonry.h"

//60
#define TopCollectionCellHeight 60.0
#define TopCollectionCellPerRow 4
//40
#define BottomCollectionCellHeight 40.0
#define BottomCollectionCellPerRow 2

@interface ZTESalaryViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    BOOL salaryDetailHidden;
    int  currentSalaryPage;                 //分页显示工资信息 当前的显示页数
}

/**
 *  界面改动过。。。本来是两个独立的tableview 后来改了 成了一个tableview
 */

@property (nonatomic, strong) UITableView                *topTableView;                     //顶部的tableview 只有一个cell
@property (nonatomic, strong) NSMutableArray             *monthArray;                       //工资月份数组                         @[@"1",@"2".....]
@property (nonatomic, strong) NSMutableArray             *salaryArray;                      //每个月对应的工资                      @[@"1234",@"2341"....]
@property (nonatomic, strong) NSMutableArray             *colorArray;                       //底部cell 颜色数组
@property (nonatomic, strong) NSMutableDictionary        *currentMonthDetailSalaryDict;     //详情工资字典               @{@"项目1":@"6300",..}
@property (nonatomic, strong) SalaryDetailViewDatasource *salaryDetailDatasource;           //详情工资
@property (nonatomic, strong) SalaryDetailViewDatasource *salaryUnfoldDatasource;           //底部展开工资
@property (nonatomic, strong) NSMutableArray             *unfoldSections;                   //当前展开的数组
@property (nonatomic, strong) NSMutableArray             *UnfoldViewdataSourceArray;        //当前展开数组的datasource存放数组
@property (nonatomic, assign) NSInteger                  salaryItemCount;                   //工资总条数
@property (nonatomic, strong) NSMutableArray             *allSalaryDetailArray;             //工资详情数组
@property (nonatomic, strong) NSMutableArray             *allSalaryDictArray;               //存放所有工资详情字典的数组  @[@{@"项目1":@"6300",..},@{@"项目2":@"6300",..}]
@property (nonatomic, strong) NSString                   *totalSalaryInCurrentMonth;        //当前月总工资
@property (nonatomic, strong) UITableView                *nullDataTableView;              //没有获取到工资数据时候显示的tableview


@end

@implementation ZTESalaryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    self.automaticallyAdjustsScrollViewInsets = NO;
    salaryDetailHidden = [[[NSUserDefaults standardUserDefaults] valueForKey:@"salaryHidden"] boolValue];
    UIButton *hideButton = [[UIButton alloc] init];
    if (salaryDetailHidden) {
        [hideButton setBackgroundImage:[UIImage imageNamed:@"eye_close"] forState:UIControlStateNormal];
    }else{
        [hideButton setBackgroundImage:[UIImage imageNamed:@"eye_open"] forState:UIControlStateNormal];
    }
    
    [hideButton addTarget:self action:@selector(hideSalaryDetail:) forControlEvents:UIControlEventTouchUpInside];
    [hideButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:hideButton];
    
//    _salaryInfoArray = [NSMutableArray array];
    
    self.view.backgroundColor = BGColor;
    
    self.title = LOCALIZATION(@"discover_salary");
    
    [self requestSalaryFromServerWithFlag:0];
    
    _unfoldSections = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - getter && setter


- (void)setSalaryInfoArray:(NSMutableArray *)salaryInfoArray{
    
    _salaryInfoArray = salaryInfoArray;
    
    [self getAllSalaryInfoValues];
    
   
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

#pragma mark - congfigureUI
- (void)configureUI{
    
   
    
    if (_nullDataTableView) {
        
        [self.nullDataTableView.pullToRefreshView stopAnimating];
        [self.nullDataTableView.infiniteScrollingView stopAnimating];
        [_nullDataTableView removeFromSuperview];
        
    }
    
//    currentSalaryPage = 1;
    
    if (!_topTableView) {
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _topTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        _topTableView.backgroundColor = BGColor;
        _topTableView.tag = 1;
        _topTableView.scrollEnabled = YES;
        _topTableView.dataSource = self;
        _topTableView.delegate = self;
        _topTableView.translatesAutoresizingMaskIntoConstraints = YES;
        
        //添加刷新的footerview
        UILabel *footerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50.0)];
        footerView.text = LOCALIZATION(@"more");
        footerView.textAlignment = kTextAlignmentCenter;
        footerView.textColor = [UIColor grayColor];
        footerView.backgroundColor = BGColor;
        _topTableView.tableFooterView = footerView;
        
        
        __block ZTESalaryViewController *blockSelf = self;
        
        [_topTableView addPullToRefreshWithActionHandler:^{
            [blockSelf requestSalaryFromServerWithFlag:0];
        }];
        
        
        
        [_topTableView addInfiniteScrollingWithActionHandler:^{
            [blockSelf requestSalaryFromServerWithFlag:1];
            
        }];
        
        [_topTableView.pullToRefreshView setTitle:LOCALIZATION(@"refreshing") forState:SVPullToRefreshStateLoading];
        [_topTableView.pullToRefreshView setTitle:LOCALIZATION(@"drag_refresh") forState:SVPullToRefreshStateTriggered];
        
        [self.view addSubview:_topTableView];
        
    }else{
        [self.topTableView.pullToRefreshView stopAnimating];
        [self.topTableView.infiniteScrollingView stopAnimating];
        [_topTableView reloadData];
    }
    
    
    
}

- (void)clickLeftItem:(ILBarButtonItem*)item{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView.tag == 1) {
        return _monthArray.count;
    }else{
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 3) {
        
        return 0;
        
    }else{
        
        return 1;
        
    }
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *topReuseId = @"topCell";
    static NSString *bottomReuseId = @"bottomCell";
    
    if (tableView.tag == 1) {//上部分
        
        if (indexPath.section == 0) {
            
            SalaryTopViewCell *topCell = [tableView dequeueReusableCellWithIdentifier:topReuseId];
            
            if (!topCell) {
                
                topCell = [[SalaryTopViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topReuseId];
                
            }
            
            NSString *detailString = _allSalaryDetailArray[0];
            NSData   *data = [detailString dataUsingEncoding:NSUTF8StringEncoding];
            NSArray  *detailArray  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            
            topCell.salaryLabel.text = _totalSalaryInCurrentMonth;
            topCell.titleLabel.text = [NSString stringWithFormat:@"%@",_monthArray[indexPath.section]];
            
            
      
            //布局
            SalaryDetailFlowLayout *flowLayout = [[SalaryDetailFlowLayout alloc] initWithFlag:0 dataCount:detailArray.count];
            [topCell.detailView setCollectionViewLayout:flowLayout];
            //代理 通过获得的数据初始化
            _salaryDetailDatasource = [[SalaryDetailViewDatasource alloc]initWithArrayData:detailArray flag:0];
            _salaryDetailDatasource.salaryInfoHidden = salaryDetailHidden;
            topCell.detailView.scrollEnabled = NO;
            topCell.detailView.backgroundColor = BGColor;
            topCell.detailView.bounces = NO;
            [topCell.detailView registerClass:[SalaryDetailCell class] forCellWithReuseIdentifier:@"cell"];
            topCell.detailView.dataSource = _salaryDetailDatasource;
            topCell.detailView.delegate = _salaryDetailDatasource;
            topCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        
            return topCell;
            
        }
        else{//下部分
            
            SalaryBottomViewCell *bottomCell = [tableView dequeueReusableCellWithIdentifier:bottomReuseId];
            
            if (!bottomCell) {
                
                bottomCell = [[SalaryBottomViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bottomReuseId];
                
            }
            
            bottomCell.textLabel.text = [NSString stringWithFormat:@"%@",_monthArray[indexPath.section]];
            bottomCell.salaryLabel.text = _salaryArray[indexPath.section];
            bottomCell.colorImage.backgroundColor = _colorArray[indexPath.section];
            bottomCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            bottomCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [UIView animateWithDuration:1 animations:^{
            }];
            
            return bottomCell;
            
        }
    }else{
        return nil;
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1) {
        
        if (indexPath.section == 0) {
            
            //collectionview高度
            CGFloat topHeight = ( _currentMonthDetailSalaryDict.count / TopCollectionCellPerRow  + 1) * TopCollectionCellHeight;
            return topHeight + 200.0;
            
        }
        else{
            
            return 44.0;
        }
        
        
    }else{
        return 0.1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    if (tableView.tag == 1) {
        
        if (section == 0) {
            return 0.1;
        }else{
            
//            section = section - 1;
            
            //展开之后的footerview高度
            for (NSNumber *unfoldSection in _unfoldSections) {
                
                if (section == unfoldSection.integerValue) {
                    
                    NSInteger cellCount =  [_allSalaryDictArray[section] count];
                    
                    CGFloat height = (cellCount/BottomCollectionCellPerRow + 1) * BottomCollectionCellHeight;
                    
                    return height;
                    
                }
                
            }
            return 0.1;
        }
        
    }else{
        return 0.1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView.tag == 1) {
        
        if (section == 0) {
            return 10.0;
        }else{
            return 0.1;
        }
        
        
    }else{
        
        return 50.0;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = BGColor;
    
    if (tableView.tag == 1 && section) {//上部分
        
//        section = section - 1;
        
        NSNumber *inSection = [NSNumber numberWithInteger:section];
        
        if ([_unfoldSections containsObject:inSection]) {
            
            //布局
            
            NSString *detailString = _allSalaryDetailArray[section];
            NSData   *data = [detailString dataUsingEncoding:NSUTF8StringEncoding];
            NSArray  *detailArray  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            SalaryDetailFlowLayout *flowLayout = [[SalaryDetailFlowLayout alloc] initWithFlag:1 dataCount:[detailArray count]];
            UICollectionView *unfoldView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
            unfoldView.bounces = NO;
            //代理 通过获得的数据初始化
            SalaryDetailViewDatasource *dataSource = [[SalaryDetailViewDatasource alloc]initWithArrayData:detailArray flag:1];
            dataSource.salaryInfoHidden = salaryDetailHidden;
            NSInteger index = [_unfoldSections indexOfObject:inSection];
            //每个展开的视图都要用不同的dataSource而不是同一个！ 所以要把dataSource保存在一个数组里面
            [_UnfoldViewdataSourceArray replaceObjectAtIndex:index withObject:dataSource];
            unfoldView.scrollEnabled = NO;
            unfoldView.userInteractionEnabled = NO;
            unfoldView.backgroundColor = BGColor;
            unfoldView.dataSource = _UnfoldViewdataSourceArray[index];
            unfoldView.delegate = _UnfoldViewdataSourceArray[index];
            
            [unfoldView registerClass:[UnfoldViewCell class] forCellWithReuseIdentifier:@"unfoldcell"];
            
            [footerView  addSubview:unfoldView];
            
            return unfoldView;
        }
        
    }
    
    return footerView;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]init];
    if (tableView.tag == 3) {
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor grayColor].CGColor;
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.text = LOCALIZATION(@"more");
        textLabel.textAlignment = kTextAlignmentCenter;
        textLabel.textColor = [UIColor grayColor];
        [view addSubview:textLabel];
        
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view.mas_centerX);
            make.top.equalTo(view.mas_top);
            make.bottom.equalTo(view.mas_bottom);
        }];
        
    }else{
        view.backgroundColor = BGColor;
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1 && indexPath.section) {
        
        NSNumber *section = [NSNumber numberWithInteger:indexPath.section];
        
        if ([_unfoldSections containsObject:section]) {//如果点击已经展开的footerview 移除对应的数据源
            NSInteger index = [_unfoldSections indexOfObject:section];
            [_UnfoldViewdataSourceArray replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%d",indexPath.section]];
            [_unfoldSections removeObject:section];
        }else{
            [_unfoldSections addObject:section];
        }
        
        [self.topTableView reloadData];
    }
    
}

#pragma mark - private method


/**
 *  初始化所有数据
 */

- (void)getAllSalaryInfoValues{
    
    _salaryItemCount = _salaryInfoArray.count;

    _colorArray = [NSMutableArray array];
    _allSalaryDetailArray = [NSMutableArray array];
    _monthArray = [NSMutableArray array];
    _UnfoldViewdataSourceArray = [NSMutableArray array];
    _salaryArray = [NSMutableArray array];
    _currentMonthDetailSalaryDict = [NSMutableDictionary dictionary];
    _allSalaryDictArray = [NSMutableArray array];

    //工资详情
    for (int i = 0; i<_salaryItemCount; i++) {
        
        
        UIColor *color;
        switch (i%4) {
            case 0:
                color = [UIColor redColor];
                break;
            case 1:
                color = [UIColor yellowColor];
                break;
            case 2:
                color = [UIColor blueColor];
                break;
            case 3:
                color = [UIColor greenColor];
                break;
        }
        
        [_colorArray addObject:color];
        
        [_allSalaryDetailArray addObject:_salaryInfoArray[i][@"details"]];
        
        NSString *monthCode = _salaryInfoArray[i][@"monthCode"];
        
        [_monthArray addObject:monthCode];
        
        NSString *jsonArray = _allSalaryDetailArray[i];
        NSData *jsonData = [jsonArray dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *monthDetailArray  = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        NSString *hiddenString = @"******";
        
        NSMutableDictionary *detailDict = [NSMutableDictionary dictionary];
        
        for (int j =0; j<monthDetailArray.count; j++) {
            
            NSDictionary *dict = monthDetailArray[j];
            NSString *key = dict[@"name"];
            NSNumber *salaryFen = dict[@"value"];
            float salaryYuan = salaryFen.floatValue / 100;
            
            NSString *value = [NSString stringWithFormat:@"%.2f",salaryYuan];
            
            
            if (salaryDetailHidden) {
                
                if (i == 0) {//如果月份为当前月
                    
                    [_currentMonthDetailSalaryDict setValue:hiddenString forKey:key];
                    
                }
                else{
                    
                    [detailDict setValue:hiddenString forKey:key];
                    
                }
                
            }else{
                if (i == 0) {//如果月份为当前月
                    
                    [_currentMonthDetailSalaryDict setValue:value forKey:key];
                    
                }else{
                    
                    [detailDict setValue:value forKey:key];
                    
                }
            }
            
        }
        
        if (i != 0) {
            [_allSalaryDictArray addObject:detailDict];
        }
        
        //展开数据源
        [_UnfoldViewdataSourceArray addObject:[NSString stringWithFormat:@"%d",i]];
        
        NSNumber *totalSalaryFen = _salaryInfoArray[i][@"totalAmount"];
        float totalSalaryYuan = totalSalaryFen.floatValue / 100;
        
        if (i == 0) {
            if (!salaryDetailHidden) {
                _totalSalaryInCurrentMonth = [NSString stringWithFormat:@"%.2f",totalSalaryYuan];
            }else{
                _totalSalaryInCurrentMonth = hiddenString;
            }
        }
        //每个月总工资
        if (!salaryDetailHidden) {
            [_salaryArray addObject:[NSString stringWithFormat:@"%.2f",totalSalaryYuan]];
        }else{
            [_salaryArray addObject:hiddenString];
        }
    }
    
    [_allSalaryDictArray insertObject:_currentMonthDetailSalaryDict atIndex:0];
    
    [_topTableView reloadData];
    
    
}

/**
 *  隐藏工资具体信息
 */
- (void)hideSalaryDetail:(UIButton*)sender{
    
    if (salaryDetailHidden) {
        [sender setBackgroundImage:[UIImage imageNamed:@"eye_open"] forState:UIControlStateNormal];
        salaryDetailHidden = NO;
        
    }else{
        [sender setBackgroundImage:[UIImage imageNamed:@"eye_close"] forState:UIControlStateNormal];
        salaryDetailHidden = YES;
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:salaryDetailHidden] forKey:@"salaryHidden"];
    
    [self getAllSalaryInfoValues];
    
    
    [_topTableView reloadData];
    
    
}


//从服务器请求工资数据  通过flag判断是下拉刷新(0) 还是上拉刷新(1)
- (void)requestSalaryFromServerWithFlag:(int)flag{
    
    if (flag == 1) {
        
        currentSalaryPage++;
        
    }else{
        
        currentSalaryPage = 1;
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[ConfigManager sharedInstance].userDictionary[@"token"] forKey:@"token"];
    [dict setValue:[NSNumber numberWithInt:currentSalaryPage] forKey:@"page"];
    
    [self postRuquestWithURL:ApiPrefix postParems:dict requestMethod:[HTTPAddress MethodGetSalary] flag:flag];
    
}

- (void)postRuquestWithURL:(NSString*)url postParems:(NSMutableDictionary*)postParems requestMethod:(NSString*)method flag:(int)flag{
    
    
    [HTTPClient asynchronousPostRequest:url method:method parameters:postParems successBlock:^(BOOL success, id data, NSString *msg) {
        
        if (data) {
            
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dic = (NSDictionary *)data;
                NSDictionary * resDic = [dic objectForKey:@"res"];
                //reCode返回1 表示成功
                if ([resDic objectForKey:@"reCode"] && [[resDic objectForKey:@"reCode"]intValue]==1 ) {
                    //跳转到工资界面
                    
                    if (flag == 0) {//下拉刷新
                        
                        self.salaryInfoArray = [NSMutableArray arrayWithArray:dic[@"salary"]];
                        
                        if (self.salaryInfoArray.count != 0) {
//                            
//                            [MMProgressHUD showHUDWithTitle:[NSString stringWithFormat:@"信息获取成功"] isDismissLater:YES];
                            
                            [self configureUI];
                            
                        }else{
                            
                            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"no_more_data") isDismissLater:YES];
                            
                            if (!_nullDataTableView) {
                                
                                [self configureNoDataUI];
                                
                            }else{
                                [self.nullDataTableView.pullToRefreshView stopAnimating];
                                [self.nullDataTableView.infiniteScrollingView stopAnimating];
                            }
                            
                        }
                        
                        
                    }else{
                        
                        if ([dic[@"salary"] count]) {//如果下拉刷新还有数据
                            //数据加入数组中
                            [self.salaryInfoArray addObjectsFromArray:dic[@"salary"]];
                            //重新刷新数据
                            [self getAllSalaryInfoValues];
                        }else{
                            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"no_more_data") isDismissLater:YES];
                        }
                        
                        
                        [self.topTableView.pullToRefreshView stopAnimating];
                        [self.topTableView.infiniteScrollingView stopAnimating];
                        
                    }
                    
                }
            }
            else{
                
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"formatter_error") isDismissLater:YES];
            }
        }
        else{
            
            
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"no_more_data") isDismissLater:YES];
        }
        
        
        
        
    } failureBlock:^(NSString *description) {
        
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"salary_data_failed") isDismissLater:YES];
        
        [self.nullDataTableView.pullToRefreshView stopAnimating];
        [self.nullDataTableView.infiniteScrollingView stopAnimating];
        
        
    }];
    
}

#pragma mark - no data ui
//设置没有获取到工资数据的界面
- (void)configureNoDataUI{
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _nullDataTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _nullDataTableView.tag = 3;
    _nullDataTableView.dataSource = self;
    _nullDataTableView.delegate = self;
    __block ZTESalaryViewController *blockSelf = self;
    
    [_nullDataTableView addPullToRefreshWithActionHandler:^{
        
        [blockSelf requestSalaryFromServerWithFlag:0];
        
    }];
    
    [self.view addSubview:_nullDataTableView];
    
    [_nullDataTableView.pullToRefreshView setTitle:LOCALIZATION(@"refreshing") forState:SVPullToRefreshStateLoading];
    [_nullDataTableView.pullToRefreshView setTitle:LOCALIZATION(@"drag_refresh") forState:SVPullToRefreshStateTriggered];

}


@end





























