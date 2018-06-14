//
//  ApplyListViewController.m
//  IM
//
//  Created by liuguangren on 14-9-11.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "ApplyListViewController.h"
#import "ConfigManager.h"
#import "HTTPAddress.h"


@interface ApplyListViewController ()

@end

@implementation ApplyListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=NO;
}
- (void)requestApplyList
{
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
    [params setObject:[[ConfigManager sharedInstance].userDictionary  objectForKey:@"token"] forKey:@"token"];
    [params setObject:[self.categoryDic objectForKey:@"id"] forKey:@"cateId"];
    [params setObject:@"1" forKey:@"page"];
    
    [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodListApp] parameters:params successBlock:^(BOOL success, id data, NSString *msg) {
        if(success)
        {
//            NSLog(@"%@",data);
            
            if([data isKindOfClass:[NSDictionary class]])
            {
                [listArr removeAllObjects];
                [listArr addObjectsFromArray:[data objectForKey:@"item"]];
                if(listArr.count > 0)
                    [listTab reloadData];
                else
                    listTab.separatorStyle = UITableViewCellSeparatorStyleNone;
            }
        }
        else
        {
//            NSLog(@"%@",msg);
        }
    } failureBlock:^(NSString *description) {
    }];
    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Success: %@", operation.responseString);
//        
//        NSString *requestTmp = [NSString stringWithString:operation.responseString];
//        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
//        //系统自带JSON解析
//        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
//        [listArr removeAllObjects];
//        [listArr addObjectsFromArray:[resultDic objectForKey:@"item"]];
//        if(listArr.count > 0)
//            [listTab reloadData];
//        else
//            listTab.separatorStyle = UITableViewCellSeparatorStyleNone;
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Failure: %@", error);
//        UIAlertView*alertView = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                           message:[NSString stringWithFormat:@"%@",error]
//                                                          delegate:self
//                                                 cancelButtonTitle:@"OK"
//                                                 otherButtonTitles: nil];
//        [alertView show];
//    }];
//    [operation start];
}

-(void)clickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    {
        [super viewDidLoad];
        // Do any additional setup after loading the view from its nib.
        ILBarButtonItem *leftItem =[ILBarButtonItem barItemWithImage:[[UIImage imageNamed:@"back.png"] imageResizedToSize:CGSizeMake(40, 30)] highlightedImage:[[UIImage imageNamed:@"back.png"] imageResizedToSize:CGSizeMake(40, 30)] target:self action:@selector(clickLeftItem)];
        self.navigationItem.leftBarButtonItem=leftItem;
        
        listArr = [[NSMutableArray alloc] init];
        
        listTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, viewWithNavAndTabbar) style:UITableViewStylePlain];
        listTab.backgroundColor = [UIColor whiteColor];
        listTab.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        listTab.delegate = self;
        listTab.dataSource = self;
        [self.view addSubview:listTab];
        
        if ([listTab respondsToSelector:@selector(setSeparatorInset:)]) {
            [listTab setSeparatorInset:UIEdgeInsetsZero];
        }
        
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        [listTab setTableFooterView:view];
        
        [self requestApplyList];
        
        self.title = [self.categoryDic objectForKey:@"name"];
    }
}

#pragma mark -TableView
#pragma TableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier=@"categoryCellIdentifier";
    
    ApplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if(!cell)
    {
        cell = [[ApplyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    NSDictionary *dic = [listArr objectAtIndex:indexPath.row];
    [cell.imageView setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"img"]] placeholderImage:[UIImage imageNamed:@"8_03_14.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType){
    }];
    cell.textLabel.text = [dic objectForKey:@"name"];
    cell.detailTextLabel.text = [dic objectForKey:@"cateName"];
    
    return  cell;
    
}

#pragma tableview delegate methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *storeString = @"http://itunes.apple.com/cn/app/qq/id451108668?mt=12";
    NSURL *iTunesURL = [NSURL URLWithString:storeString];
    [[UIApplication sharedApplication] openURL:iTunesURL];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
