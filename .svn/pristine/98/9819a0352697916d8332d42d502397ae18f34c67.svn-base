//
//  FeedBackViewController.m
//  IM
//
//  Created by 陆浩 on 15/5/5.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "FeedBackViewController.h"

@implementation FeedBackChoiceCell

@synthesize choiceTitleLabel,choiceSelectButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        choiceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6.5, 200, 30)];
        choiceTitleLabel.backgroundColor = [UIColor clearColor];
        choiceTitleLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.contentView addSubview:choiceTitleLabel];
        
        choiceSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        choiceSelectButton.frame = CGRectMake(boundsWidth-30-10, 6.5, 30, 30);
        [choiceSelectButton setImage:[UIImage imageNamed:@"CellBlueSelected.png"] forState:UIControlStateSelected];
        [choiceSelectButton setImage:[UIImage imageNamed:@"CellNotSelected.png"] forState:UIControlStateNormal];
        choiceSelectButton.userInteractionEnabled = NO;
        [self.contentView addSubview:choiceSelectButton];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 42.5, boundsWidth, 0.5)];
        line.backgroundColor = [UIColor hexChangeFloat:@"dddddd"];
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end


@interface FeedBackViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    NSInteger currentSelectIndex;
    NSArray *titleArray;
    UITextView *inputView;
    UITableView *feedTableView;
}

@end

@implementation FeedBackViewController
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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
    self.navigationItem.title = @"意见反馈";
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    ILBarButtonItem *rightItem = [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_save.png"] highlightedImage:nil target:self action:@selector(clickRightItem:)];
    [self.navigationItem setRightBarButtonItem:rightItem];

    currentSelectIndex = -1;
    feedTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, viewWithNavNoTabbar)];
    feedTableView.delegate = self;
    feedTableView.dataSource = self;
    feedTableView.backgroundColor = [UIColor clearColor];
    feedTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:feedTableView];
    
    titleArray = @[@"有BUG",@"功能不好用",@"用户体验不好",@"响应慢、卡"];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickLeftItem:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickRightItem:(id)sender{
    //发送意见反馈
    if([inputView.text length] == 0)
    {
        [MMProgressHUD showHUDWithTitle:@"请输入内容" isDismissLater:YES];
        return;
    }
    [MMProgressHUD showHUDWithTitle:@"正在提交..." isDismissLater:NO];
    
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //判断是否已登录
        CGRect rect_screen = [[UIScreen mainScreen]bounds];
        CGSize size_screen = rect_screen.size;
        CGFloat scale_screen = [UIScreen mainScreen].scale;
        
        int width = size_screen.width*scale_screen;
        int height = size_screen.height*scale_screen;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *timeStr = [formatter stringFromDate:[NSDate date]];
    
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:[[ConfigManager sharedInstance].userDictionary objectForKey:@"name"] forKey:@"name"];
        [parameters setObject:[[ConfigManager sharedInstance].userDictionary objectForKey:@"telephone"] forKey:@"mobile"];
        [parameters setObject:@"user" forKey:@"type"];
        [parameters setObject:[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"] forKey:@"token"];
        [parameters setObject:timeStr forKey:@"time"];
        [parameters setObject:[NSString stringWithFormat:@"%d*%d",width,height] forKey:@"resolution"];
        [parameters setObject:[UIDevice currentDevice].model forKey:@"device"];
        
        NSString *tmpString = @"";
        if(currentSelectIndex >= 0)
        {
            tmpString = [NSString stringWithFormat:@"(%@)   ",titleArray[currentSelectIndex]];
        }
        [parameters setObject:[NSString stringWithFormat:@"%@%@",tmpString,inputView.text] forKey:@"content"];
        
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodSaveFeedback] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
            if(success && [data isKindOfClass:[NSDictionary class]]){

                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD showHUDWithTitle:@"提交成功！" isDismissLater:YES];
                    inputView.text = nil;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD showHUDWithTitle:@"提交失败！" isDismissLater:YES];
                });
            }
        } failureBlock:^(NSString *description) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MMProgressHUD showHUDWithTitle:@"提交失败！" isDismissLater:YES];
            });
        }];
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark - UITableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0)
    {
        return [titleArray count];
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0)
    {
        return 43;
    }
    return 200;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 9.5, boundsWidth, 0.5)];
    line.backgroundColor = [UIColor hexChangeFloat:@"dddddd"];
    [view addSubview:line];
    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"FeedBackChoiceCell";
        FeedBackChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[FeedBackChoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor=[UIColor hexChangeFloat:@"ffffff"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.choiceTitleLabel.text = [titleArray objectAtIndex:indexPath.row];
        cell.choiceSelectButton.selected = NO;
        if(indexPath.row == currentSelectIndex)
        {
            cell.choiceSelectButton.selected = YES;
        }
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"InputUITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor=[UIColor hexChangeFloat:@"ffffff"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        inputView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 180)];
        inputView.font = [UIFont systemFontOfSize:16];
        inputView.delegate = self;
        [cell.contentView addSubview:inputView];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array = [NSMutableArray array];
    for(int i = 0 ; i < [titleArray count] ; i++)
    {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        [array addObject:path];
    }
    currentSelectIndex = indexPath.row;
    [tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(boundsHeight < 667)
    {
        //小于爱疯6
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = feedTableView.frame;
            frame.origin.y = - 60;
            feedTableView.frame = frame;
        }];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = feedTableView.frame;
        frame.origin.y = 0;
        feedTableView.frame = frame;
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [inputView resignFirstResponder];
}

@end
