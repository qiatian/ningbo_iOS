//
//  PersonalInfoViewController.m
//  IM
//
//  Created by liuguangren on 14-9-13.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "PersonalInfoViewController.h"

@interface PersonalInfoViewController ()

@end

@implementation PersonalInfoViewController

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
    if(!isEdit)
        [self.navigationController popViewControllerAnimated:YES];
    else
    {
        isEdit = NO;
        [self setupBar];
        [personInfoTab reloadData];
    }
}

-(void)clickRightItem
{
    if(isEdit)
    {
        //提交修改
        isEdit = NO;
        [self setupBar];
    }
    else
    {
        isEdit = YES;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 40, 30);
        [btn addTarget:self action:@selector(clickLeftItem) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 40, 30);
        [btn addTarget:self action:@selector(clickRightItem) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    [personInfoTab reloadData];
}

- (void)setupBar
{
    ILBarButtonItem *leftItem =[ILBarButtonItem barItemWithImage:[[UIImage imageNamed:@"back.png"] imageResizedToSize:CGSizeMake(40, 30)] highlightedImage:[[UIImage imageNamed:@"back.png"] imageResizedToSize:CGSizeMake(40, 30)] target:self action:@selector(clickLeftItem)];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    ILBarButtonItem *rightItem =[ILBarButtonItem barItemWithImage:[[UIImage imageNamed:@"wb_edit.png"] imageResizedToSize:CGSizeMake(22, 22)] highlightedImage:[[UIImage imageNamed:@"wb_edit.png"] imageResizedToSize:CGSizeMake(22, 22)] target:self action:@selector(clickRightItem)];
    self.navigationItem.rightBarButtonItem=rightItem;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BGColor;
    [self setupBar];
    
    nameArr = [NSMutableArray arrayWithObjects:@"深圳市中兴云服务有限公司",@"性别",@"部门",@"职位",@"工作电话",@"家庭电话",@"传真电话",@"邮箱", nil];
    valueArr = [NSMutableArray arrayWithObjects:@" ",@" ",@"技术部",@"设计总监",@"18688684528",@"18688684528",@"0575-87777777",@"chenyixu@sina.cn", nil];
    
    personInfoTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, viewWithNavNoTabbar)];
    personInfoTab.backgroundColor = [UIColor clearColor];
    personInfoTab.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    personInfoTab.sectionFooterHeight = 10;
    personInfoTab.sectionHeaderHeight = 10;
    personInfoTab.delegate = self;
    personInfoTab.dataSource = self;
    [self.view addSubview:personInfoTab];
    
    if ([personInfoTab respondsToSelector:@selector(setSeparatorInset:)]) {
        [personInfoTab setSeparatorInset:UIEdgeInsetsZero];
    }
    
    [self setExtraCellLineHidden];
    
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 130)];
    headView.image = [UIImage imageNamed:@"wb_personBG.png"];
    headView.contentMode = UIViewContentModeScaleAspectFill;
    headView.clipsToBounds = YES;

    UIButton *hpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    hpBtn.frame = CGRectMake((boundsWidth-70)/2.0, 5, 70, 70);
    [hpBtn setBackgroundImage:[UIImage imageNamed:@"headBG.png"] forState:UIControlStateNormal];
    [headView addSubview:hpBtn];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, hpBtn.frameBottom+5, boundsWidth, 20)];
    lab.backgroundColor = [UIColor clearColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    lab.text = [[ConfigManager sharedInstance].userDictionary  objectForKey:@"name"];
    lab.font = [UIFont systemFontOfSize:18];
    [headView addSubview:lab];
    
    lab = [[UILabel alloc] initWithFrame:CGRectMake(0, lab.frameBottom, boundsWidth, 10)];
    lab.backgroundColor = [UIColor clearColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    lab.text = [[ConfigManager sharedInstance].userDictionary  objectForKey:@"jid"];
    lab.font = [UIFont systemFontOfSize:10];
    [headView addSubview:lab];
    
    lab = [[UILabel alloc] initWithFrame:CGRectMake(0, lab.frameBottom, boundsWidth, 20)];
    lab.backgroundColor = [UIColor clearColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    lab.text = [[ConfigManager sharedInstance].userDictionary  objectForKey:@"autograph"];
    lab.font = [UIFont systemFontOfSize:14];
    [headView addSubview:lab];
    
    personInfoTab.tableHeaderView = headView;
}

- (void)setExtraCellLineHidden
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [personInfoTab setTableFooterView:view];
}

#pragma mark -TableView
#pragma TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return isShowDetail?4:1;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section==0?0:10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier=@"PersonalInfoTableViewCellIdentifier";
    
    PersonalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if(!cell)
    {
        cell = [[PersonalInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    int index = indexPath.section*4+indexPath.row;
    if(index < 4)
    {
        cell.telBtn.hidden = YES;
        cell.messBtn.hidden = YES;
        cell.mailBtn.hidden = YES;
        cell.arrowImg.hidden = YES;
    }
    
    cell.arrowImg.hidden = index != 0;
    [cell.arrowImg setTransform:CGAffineTransformMakeRotation(M_PI*(isShowDetail?0.5:0))];
    
    cell.inputTF.hidden = index == 0;
    cell.textLabel.text = [nameArr objectAtIndex:index];
    cell.inputTF.text = [valueArr objectAtIndex:index];
    
    if(index == 4 || index == 5 || index == 6)
    {
        cell.telBtn.hidden = NO;
        cell.messBtn.hidden = index==6;
    }
    else
        cell.telBtn.hidden = YES;
    cell.mailBtn.hidden = index!=7;
    
    
    if(index == 0)
    {
        cell.telBtn.hidden = NO;
        cell.messBtn.hidden = NO;
        cell.mailBtn.hidden = NO;
        cell.arrowImg.hidden = NO;
        cell.line.hidden = NO;
        if(isShowDetail)
        {
            [cell.mailBtn setBackgroundImage:[UIImage imageNamed:@"wb_contact.png"] forState:UIControlStateNormal];
            cell.mailBtn.frame = CGRectMake(boundsWidth-30, 13.5, 25, 17);
        }
        else
        {
            [cell.mailBtn setBackgroundImage:[UIImage imageNamed:@"wb_more.png"] forState:UIControlStateNormal];
            cell.mailBtn.frame = CGRectMake(boundsWidth-30, 13.5, 17, 17);
        }
        
        [cell.messBtn setBackgroundImage:[UIImage imageNamed:@"wb_zhiwei.png"] forState:UIControlStateNormal];
        cell.messBtn.frame = CGRectMake(boundsWidth-30-25, 13.5, 17, 17);
        [cell.messBtn setTitle:@"设" forState:UIControlStateNormal];
        [cell.telBtn setBackgroundImage:[UIImage imageNamed:@"wb_bumen.png"] forState:UIControlStateNormal];
        cell.telBtn.frame = CGRectMake(boundsWidth-30-25-22, 13.5, 17, 17);
        [cell.telBtn setTitle:@"技" forState:UIControlStateNormal];
    }
    else
    {
        cell.line.hidden = YES;
        [cell.messBtn setTitle:@"" forState:UIControlStateNormal];
        [cell.telBtn setTitle:@"" forState:UIControlStateNormal];
    }
    cell.inputTF.userInteractionEnabled = isEdit;
    
    UIView *backgrdView = [[UIView alloc] initWithFrame:cell.frame];
    backgrdView.backgroundColor = [UIColor whiteColor];
    cell.backgroundView = backgrdView;
    
    return  cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 10)];
    view.backgroundColor = BGColor;
    return view;
}

#pragma tableview delegate methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = indexPath.section*4+indexPath.row;
    if(index == 0)
    {
        isShowDetail = !isShowDetail;
        [personInfoTab reloadData];
    }
//    int index = indexPath.section*2+indexPath.row;
//    switch (index) {
//        case 0:
//        {
//            SetViewController *nextVC = [[SetViewController alloc] init];
//            nextVC.flag = 0;
//            nextVC.title = [nameArr objectAtIndex:nextVC.flag];
//            [self.navigationController pushViewController:nextVC animated:YES];
//        }
//            break;
//        case 1:
//        {
//            SetViewController *nextVC = [[SetViewController alloc] init];
//            nextVC.flag = 1;
//            nextVC.title = [nameArr objectAtIndex:nextVC.flag];
//            [self.navigationController pushViewController:nextVC animated:YES];
//        }
//            break;
//        case 2:
//        {
//            alertMessage(@"当前已是最新版本，无需更新！");
//        }
//            break;
//        case 3:
//        {
//            SetViewController *nextVC = [[SetViewController alloc] init];
//            nextVC.flag = 3;
//            nextVC.title = [nameArr objectAtIndex:nextVC.flag];
//            [self.navigationController pushViewController:nextVC animated:YES];
//        }
//            break;
//        case 4:
//        {
//            SetViewController *nextVC = [[SetViewController alloc] init];
//            nextVC.flag = 4;
//            nextVC.title = [nameArr objectAtIndex:nextVC.flag];
//            [self.navigationController pushViewController:nextVC animated:YES];
//        }
//            break;
//        case 5:
//        {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://10086"]];
//        }
//            break;
//        default:
//            break;
//    }
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
