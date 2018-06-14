//
//  UserFinishViewController.m
//  IM
//
//  Created by ZteCloud on 15/12/8.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "UserFinishViewController.h"
#import "TableViewCell_TaskFinish.h"
@interface UserFinishViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate>
{
    UITableView *mainTable;
}

@end

@implementation UserFinishViewController

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
    mainTable.rowHeight=50;
    [self.view addSubview:mainTable];
    [mainTable registerNib:[UINib nibWithNibName:@"TableViewCell_TaskFinish" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [Common setExtraCellLineHidden:mainTable];
    
}
#pragma mark--------tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return self.userUnFinish.count;
    }
    if (section==1) {
        return self.userFinish.count;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TableViewCell_TaskFinish *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UserTaskModel *um=(indexPath.section==0)?[self.userUnFinish objectAtIndex:indexPath.row]:[self.userFinish objectAtIndex:indexPath.row];
    cell.nameLabel.text=um.name;
    cell.progressView.progress=[um.progress floatValue]/100;
    
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
        finishLabel.text=[NSString stringWithFormat:@"%@(%d人)",LOCALIZATION(@"task_not_finished"),self.userUnFinish.count];
        finishLabel.font=[UIFont systemFontOfSize:13];
        [myView addSubview:finishLabel];
    }
    if (section==1) {
        UILabel *unfinishLabel=[[UILabel alloc]initWithFrame:CGRectMake(EdgeDis, 0, 100, 25)];
        unfinishLabel.textColor=[UIColor grayColor];
        unfinishLabel.text=[NSString stringWithFormat:@"%@(%d人)",LOCALIZATION(@"task_finised"),self.userFinish.count];
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
