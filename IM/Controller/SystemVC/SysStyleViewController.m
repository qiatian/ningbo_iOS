//
//  SysStyleViewController.m
//  IM
//
//  Created by 陆浩 on 15/5/4.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "SysStyleViewController.h"

@implementation SysStyleCell

@synthesize styleTitleLabel,styleSelectButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        styleTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6.5, 200, 30)];
        styleTitleLabel.backgroundColor = [UIColor clearColor];
        styleTitleLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.contentView addSubview:styleTitleLabel];
        
        styleSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        styleSelectButton.frame = CGRectMake(boundsWidth-30-10, 6.5, 30, 30);
        [styleSelectButton setImage:[UIImage imageNamed:@"CellBlueSelected.png"] forState:UIControlStateSelected];
        [styleSelectButton setImage:[UIImage imageNamed:@"CellNotSelected.png"] forState:UIControlStateNormal];
        styleSelectButton.userInteractionEnabled = NO;
        [self.contentView addSubview:styleSelectButton];
        
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


@interface SysStyleViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *titleArray;
    NSInteger currentSelectIndex;
}
@end

@implementation SysStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentSelectIndex = 0;
    
    self.view.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
    self.navigationItem.title = @"更换主题";
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, viewWithNavNoTabbar)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.scrollEnabled = NO;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    
    titleArray = @[@"蓝色经典",@"红色玫瑰",@"高贵罗兰",@"经典雅黑"];
    // Do any additional setup after loading the view.
}

-(void)clickLeftItem:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

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

#pragma mark -
#pragma mark - UITableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [titleArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 43;
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
    static NSString *CellIdentifier = @"SysStyleCell";
    SysStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[SysStyleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor=[UIColor hexChangeFloat:@"ffffff"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.styleTitleLabel.text = [titleArray objectAtIndex:indexPath.row];
    cell.styleSelectButton.selected = NO;
    if(indexPath.row == currentSelectIndex)
    {
        cell.styleSelectButton.selected = YES;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentSelectIndex = indexPath.row;
    [tableView reloadData];
}


@end
