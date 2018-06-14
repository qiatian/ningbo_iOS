//
//  UserDetailViewController.m
//  IM
//
//  Created by ZteCloud on 15/11/19.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "UserDetailViewController.h"

@interface UserDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate>
{
    UITableView *mainTable;
}

@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self handleNavigationBarItem];
    [self setTable];
}
-(void)setTable
{
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight-NavBarHeight) style:UITableViewStylePlain];
    mainTable.backgroundColor=BGColor;
    mainTable.delegate=self;
    mainTable.dataSource=self;
    mainTable.showsVerticalScrollIndicator=NO;
    [self.view addSubview:mainTable];
    [Common setExtraCellLineHidden:mainTable];
    
}
#pragma mark--------tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return self.userUnConfirm.count;
    }
    if (section==1) {
        return self.userConfirm.count;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"AboutUITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor=[UIColor hexChangeFloat:@"ffffff"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.imageView.image=[UIImage imageNamed:@"default_head"];
    UserTaskModel *um=(indexPath.section==0)?[self.userUnConfirm objectAtIndex:indexPath.row]:[self.userConfirm objectAtIndex:indexPath.row];
    cell.textLabel.text=um.name;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *myView=[[UIView alloc]init];
    myView.backgroundColor=BGColor;
    if (section==0) {
        
        UILabel *finishLabel=[[UILabel alloc]initWithFrame:CGRectMake(EdgeDis, 0, 100, 25)];
        finishLabel.textColor=[UIColor grayColor];
        finishLabel.text=[NSString stringWithFormat:@"%@(%d%@)",LOCALIZATION(@"task_not_confirm"),self.userUnConfirm.count,LOCALIZATION(@"Message_peopler")];
        finishLabel.font=[UIFont systemFontOfSize:13];
        [myView addSubview:finishLabel];
    }
    if (section==1) {
        UILabel *unfinishLabel=[[UILabel alloc]initWithFrame:CGRectMake(EdgeDis, 0, 100, 25)];
        unfinishLabel.textColor=[UIColor grayColor];
        unfinishLabel.text=[NSString stringWithFormat:@"%@(%d%@)",LOCALIZATION(@"task_confirm"),self.userConfirm.count,LOCALIZATION(@"Message_peopler")];
        unfinishLabel.font=[UIFont systemFontOfSize:13];
        [myView addSubview:unfinishLabel];
    }
    return myView;
}
#pragma mark 处理导航条
-(void)handleNavigationBarItem{
    self.navigationItem.title = LOCALIZATION(@"staff_detail");
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
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

@end
