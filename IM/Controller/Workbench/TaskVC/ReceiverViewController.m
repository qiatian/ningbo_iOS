//
//  ReceiverViewController.m
//  IM
//
//  Created by ZteCloud on 15/12/3.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "ReceiverViewController.h"

@interface ReceiverViewController ()<UITableViewDataSource,UITableViewDelegate,GQEnterpriseContactsCellDelegate>
{
    UITableView *mainTable;
    BOOL isDeleteStatus;
    NSMutableArray *prepareDeleteArr;
}

@end

@implementation ReceiverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self handleNavigationBarItem];
    prepareDeleteArr=[[NSMutableArray alloc]initWithCapacity:0];
    [self setTable];
}
-(void)setTable
{
    self.nibEnterpriseContacts =[UINib nibWithNibName:@"GQEnterpriseContactsCell" bundle:[NSBundle mainBundle]];
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight-NavBarHeight) style:UITableViewStylePlain];
    mainTable.backgroundColor=BGColor;
    mainTable.delegate=self;
    mainTable.dataSource=self;
    mainTable.showsVerticalScrollIndicator=NO;
    mainTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    mainTable.rowHeight=50;
    mainTable.sectionHeaderHeight=EdgeDis;
    [self.view addSubview:mainTable];
}
#pragma mark--------tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.receiverArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GQEnterpriseContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GQEnterpriseContactsCell"];
    if(!cell){
        cell=(GQEnterpriseContactsCell*)[[self.nibEnterpriseContacts instantiateWithOwner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    MEnterpriseUser *model = [self.receiverArr objectAtIndex:indexPath.row];
    model.normal=YES;
    if (isDeleteStatus) {
        model.normal=NO;
    }
    cell.enterprise=model;
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *myView=[[UIView alloc]init];
    myView.backgroundColor=BGColor;
    return myView;
}
#pragma mark GQEnterpriseContactsCellDelegate 选择框点击事件

-(void)clickedAccessoryBtnInEnterpriseContactsCell:(GQEnterpriseContactsCell*)cell isSelected:(BOOL)isSelected{
    id enterprise =cell.enterprise;
    if ([enterprise isKindOfClass:[MEnterpriseUser class]]) {
        [self handleSelectedUser:enterprise isSelect:isSelected];
    }
    
    [cell updateState];
    
    
}
#pragma mark 处理选中某个人员
-(void) handleSelectedUser:(MEnterpriseUser*)user isSelect:(BOOL)isSelect{
    NSLog(@"deal with");
    if(isSelect){//增加选中的人
        if ([user.selected intValue]!=2) {
            
            user.selected =[NSNumber numberWithInt:1];
            [prepareDeleteArr addObject:user];
        }
        
    }else{//删除选中的人
        if ([user.selected intValue]!=2) {
            user.selected =[NSNumber numberWithInt:0];
            [prepareDeleteArr removeObject:user];
        }
    }
}
#pragma mark 处理导航条
-(void)handleNavigationBarItem{
    self.navigationItem.title = LOCALIZATION(@"ReceiverViewController_NavTitle");
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
//    ILBarButtonItem *rigthItem=[ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_save.png"] highlightedImage:[UIImage imageNamed:@"nav_save.png"] target:self action:@selector(clickRightItem:)];
    
    ILBarButtonItem *rigthItem=[ILBarButtonItem barItemWithTitle:LOCALIZATION(@"ReceiverViewController_RightBtnTitle1") themeColor:[UIColor blackColor] target:self action:@selector(clickRigthItem:)];
    [self.navigationItem setRightBarButtonItem:rigthItem];
}
-(void)clickLeftItem:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)clickRigthItem:(id)sender
{
    NSLog(@"dddd");
    UIButton *btn=sender;
    if ([btn.titleLabel.text isEqualToString:LOCALIZATION(@"ReceiverViewController_RightBtnTitle2")]) {
        isDeleteStatus=NO;
        [btn setTitle:LOCALIZATION(@"ReceiverViewController_RightBtnTitle1") forState:UIControlStateNormal];
        NSMutableArray *tmpArr=[NSMutableArray arrayWithArray:self.receiverArr];
        if (prepareDeleteArr.count>0) {
            for (MEnterpriseUser *user in tmpArr) {
                if ([user.selected integerValue]==1) {
                    [self.receiverArr removeObject:user];
                }
            }
            [NotiCenter postNotificationName:@"RefreshNewTaskTable" object:nil];
        }
        
        
    }
    else
    {
        isDeleteStatus=YES;
        [btn setTitle:LOCALIZATION(@"ReceiverViewController_RightBtnTitle2") forState:UIControlStateNormal];
        
    }
    [mainTable reloadData];
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
