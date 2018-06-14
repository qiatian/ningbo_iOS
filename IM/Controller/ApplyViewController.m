//
//  ApplyViewController.m
//  IM
//
//  Created by zuo guoqing on 14-9-11.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "ApplyViewController.h"
#import "HTTPAddress.h"
#import "HTTPClient.h"

@interface ApplyViewController ()

@end

@implementation ApplyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)requestCategory
{
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
    [params setObject:[[ConfigManager sharedInstance].userDictionary  objectForKey:@"token"] forKey:@"token"];
    
    [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodListAppCate] parameters:params successBlock:^(BOOL success, id data, NSString *msg) {
        if(success)
        {
//                NSLog(@"%@",data);
            
                if([data isKindOfClass:[NSDictionary class]])
                {
                    [categoryArr removeAllObjects];
                    [categoryArr addObjectsFromArray:[data objectForKey:@"item"]];
                    if(categoryArr.count > 0)
                        [categoryTab reloadData];
                    else
                        categoryTab.separatorStyle = UITableViewCellSeparatorStyleNone;
                }
        }
        else
        {
//                NSLog(@"%@",msg);
        }
    } failureBlock:^(NSString *description) {
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    categoryArr = [[NSMutableArray alloc] init];
    
    categoryTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, viewWithNavAndTabbar) style:UITableViewStylePlain];
    categoryTab.backgroundColor = [UIColor whiteColor];
    categoryTab.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    categoryTab.delegate = self;
    categoryTab.dataSource = self;
    [self.view addSubview:categoryTab];
    
    if ([categoryTab respondsToSelector:@selector(setSeparatorInset:)]) {
        [categoryTab setSeparatorInset:UIEdgeInsetsZero];
    }
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [categoryTab setTableFooterView:view];
    
    [self requestCategory];
}

#pragma mark -TableView
#pragma TableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return categoryArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier=@"categoryCellIdentifier";
    
    ApplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if(!cell)
    {
        cell = [[ApplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
    }
    NSDictionary *dic = [categoryArr objectAtIndex:indexPath.row];
    [cell.imageView setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"img"]]];
    [cell.imageView setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"img"]] placeholderImage:[UIImage imageNamed:@"8_03_14.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
    }];
    cell.textLabel.text = [dic objectForKey:@"name"];
    
    return  cell;
    
}

#pragma tableview delegate methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ApplyListViewController *nextVC = [[ApplyListViewController alloc] init];
    nextVC.categoryDic = [NSDictionary dictionaryWithDictionary:[categoryArr objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
