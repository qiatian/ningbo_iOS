//
//  SetViewController.m
//  IM
//
//  Created by liuguangren on 14-9-14.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "SetViewController.h"

@interface SetViewController ()

@end

@implementation SetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)clickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BGColor;
    
    ILBarButtonItem *leftItem =[ILBarButtonItem barItemWithImage:[[UIImage imageNamed:@"back.png"] imageResizedToSize:CGSizeMake(40, 30)] highlightedImage:[[UIImage imageNamed:@"back.png"] imageResizedToSize:CGSizeMake(40, 30)] target:self action:@selector(clickLeftItem)];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    nameArr = [NSMutableArray array];
    
    tab = [[UITableView alloc] initWithFrame:CGRectZero];
    tab.backgroundColor = [UIColor whiteColor];
    tab.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tab.delegate = self;
    tab.dataSource = self;
    tab.scrollEnabled = NO;
    tab.layer.borderWidth = 1;
    tab.layer.borderColor = [BGColor CGColor];
    [self.view addSubview:tab];
    
    if ([tab respondsToSelector:@selector(setSeparatorInset:)]) {
        [tab setSeparatorInset:UIEdgeInsetsZero];
    }
    
    [self setupView];
}

- (void)setupView
{
    switch (_flag) {
        case 0:
        {
            [nameArr removeAllObjects];
            [nameArr addObjectsFromArray:[NSArray arrayWithObjects:@"接收新消息提示",@"震动",@"声音",@"震动",@"声音", nil]];
            tab.frame = CGRectMake(10, 20, boundsWidth-20, 44*7);
            [tab reloadData];
        }
            break;
        case 1:
        {
            [nameArr removeAllObjects];
            [nameArr addObjectsFromArray:[NSArray arrayWithObjects:@"当前密码：",@"新 密 码  ：",@"确认密码：", nil]];
            tab.frame = CGRectMake(10, 20, boundsWidth-20, 44*3);
            [tab reloadData];
            
            UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            sendBtn.frame = CGRectMake(10, tab.frameBottom+20, boundsWidth-20, 35);
            [sendBtn setBackgroundImage:[UIImage imageNamed:@"more_submit.png"] forState:UIControlStateNormal];
            [sendBtn setTitle:@"完成" forState:UIControlStateNormal];
            [sendBtn addTarget:self action:@selector(modifyPass) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:sendBtn];
        }
            break;
        case 3:
        {
            adviceTV = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, boundsWidth-20, 180)];
            adviceTV.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:adviceTV];
            
            UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            sendBtn.frame = CGRectMake(10, adviceTV.frameBottom+20, boundsWidth-20, 35);
            [sendBtn setBackgroundImage:[UIImage imageNamed:@"more_submit.png"] forState:UIControlStateNormal];
            [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
            [sendBtn addTarget:self action:@selector(sendAdvice) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:sendBtn];
        }
            break;
        case 4:
        {
            UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((boundsWidth-79)/2.0, 20, 79, 93)];
            logo.image = [UIImage imageNamed:@"more_logo.png"];
            [self.view addSubview:logo];
            
            [nameArr removeAllObjects];
            [nameArr addObjectsFromArray:[NSArray arrayWithObjects:@"关于我们：",@"名       称：企业微信",@"版权所有：深圳市中兴云服务有限公司",@"官方网址：www.zte.com.cn",@"客服电话：40082587788", nil]];
            tab.frame = CGRectMake(10, logo.frameBottom+20, boundsWidth-20, 44*5);
            [tab reloadData];
            
        }
            break;
        default:
            break;
    }
}

- (void)sendAdvice
{
    
}

- (void)modifyPass
{
    
}

#pragma mark -TableView
#pragma TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _flag==0?2:1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_flag == 0)
    {
        return section==0?3:2;
    }
    return nameArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier=@"setviewCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    int index = _flag==0?indexPath.row+indexPath.section*3:indexPath.row;
    cell.textLabel.text = [nameArr objectAtIndex:index];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    if(_flag == 0)
    {
//        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(CURRENT_SYS_VERSION>=7.0?210+30:210, 8.0f, 100.0f, 29.0f)];
//        [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
//        [cell.contentView addSubview:switchView];
//        switchView.tag = 1000+index;
        
        UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        switchBtn.frame = CGRectMake(boundsWidth-20-50, 13, 42, 18);
        [switchBtn setBackgroundImage:[UIImage imageNamed:@"wb_off.png"] forState:UIControlStateNormal];
        [switchBtn setBackgroundImage:[UIImage imageNamed:@"wb_on.png"] forState:UIControlStateSelected];
        [switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:switchBtn];
        switchBtn.tag = 1000+index;
    }
    else if(_flag == 1)
    {
        switch (indexPath.row) {
            case 0:
            {
                oldTF = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, boundsWidth-80, 44)];
                oldTF.backgroundColor = [UIColor clearColor];
                oldTF.secureTextEntry = YES;
                oldTF.placeholder = @"请输入原密码";
                oldTF.font = [UIFont systemFontOfSize:14];
                oldTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [cell.contentView addSubview:oldTF];
            }
                break;
            case 1:
            {
                newTF = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, boundsWidth-80, 44)];
                newTF.backgroundColor = [UIColor clearColor];
                newTF.secureTextEntry = YES;
                newTF.placeholder = @"请输入6位以上的密码";
                newTF.font = [UIFont systemFontOfSize:14];
                newTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [cell.contentView addSubview:newTF];
            }
                break;
            case 2:
            {
                againTF = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, boundsWidth-80, 44)];
                againTF.backgroundColor = [UIColor clearColor];
                againTF.secureTextEntry = YES;
                againTF.placeholder = @"请再次输入新密码";
                againTF.font = [UIFont systemFontOfSize:14];
                againTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [cell.contentView addSubview:againTF];
            }
                break;
            default:
                break;
        }
    }
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _flag==0?44:0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(_flag != 0)
        return nil;
    else
    {
        NSArray *tmpArr = [NSArray arrayWithObjects:@"    新消息提示",@"    网络来电提示", nil];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(-1, 0, boundsWidth+2, 44)];
        lab.backgroundColor = [UIColor clearColor];
        lab.text = [tmpArr objectAtIndex:section];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = [UIColor lightGrayColor];
        lab.layer.borderWidth = 1;
        lab.layer.borderColor = [BGColor CGColor];
        
        return lab;
    }
}

- (void)switchAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
