//
//  AllMettingUserViewController.m
//  IM
//
//  Created by 陆浩 on 15/5/27.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "AllMettingUserViewController.h"
#import "NotiListTableViewCell.h"

@interface AllMettingUserViewController ()<UITableViewDataSource,UITableViewDelegate,IBActionSheetDelegate,UIAlertViewDelegate>
{
    NSInteger currentDeleteIndex;
    UITableView *userTableView;
    MEnterpriseUser * enterPriseUserModel;
    BOOL isDeleteModel;//创建会议时删除已选参会人员
    UIButton *rightButton; //右边的删除按钮
    NSMutableArray *nowSelectIndexRow; //选择要删除的人员的数组
    NSMutableArray *arry;
    
    NSArray *deletedUsers;
    
}

@end

@implementation AllMettingUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LOCALIZATION(@"Message_joinMetting_Detail");
    self.view.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
    
    isDeleteModel = NO;
    
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    arry = [[NSMutableArray alloc]init];
    nowSelectIndexRow = [[NSMutableArray alloc]init];
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 60, 44);
    [rightButton setTitle:LOCALIZATION(@"Message_Del_Member") forState:UIControlStateNormal];
    [rightButton setTitle:LOCALIZATION(@"Message_CXAlertView_title3") forState:UIControlStateSelected];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    
    
    if (!_forSelectUser){
        
    ILBarButtonItem *rightItem =[ILBarButtonItem barItemWithCustomView:rightButton target:self action:@selector(clickDeleteItem:)];
    [self.navigationItem setRightBarButtonItem:rightItem];
        
    }

    userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, viewWithNavNoTabbar)];
    userTableView.backgroundColor = [UIColor clearColor];
    userTableView.dataSource = self;
    userTableView.delegate = self;
    userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:userTableView];
    

    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"NotiStatusChangeNotification" object:nil];
    // Do any additional setup after loading the view.
}

-(void)clickLeftItem:(id)sender
{
    if (isDeleteModel) {
        
        if (_refresheBlock) {
            _refresheBlock();
        };
    }
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)clickDeleteItem:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.isSelected)
    {
        //删除
        NSLog(@"删除");
        [userTableView reloadData];
        return;
    }
    else
    {
        [self handleDeleteUser];
        
        self.deletedUsersBlock(deletedUsers);
        
        [userTableView reloadData];
        
    }

}

- (void)handleDeleteUser{
    
    NSMutableArray *shouldDeleteIndexArray = [NSMutableArray array];//把应该删除的数据放到一个数组中
    
    for (int i =0; i<nowSelectIndexRow.count; i++) {
        
        BOOL selected = [[[nowSelectIndexRow[i] allValues] lastObject] boolValue];
        
        if (selected) {
            
            int index = [[[nowSelectIndexRow[i] allKeys] lastObject] intValue];
            
            [shouldDeleteIndexArray addObject:@(index)];
            
        }
        
    }
    //删除所有应该删除的数据
    
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    
    for (int i = 0; i<shouldDeleteIndexArray.count; i++) {
        
        [indexSet addIndex:[shouldDeleteIndexArray[i] intValue]];
        
        NSNumber *key = shouldDeleteIndexArray[i];
        
        NSDictionary *tmp;
        //删除掉选中的数组
        for (int i = 0; i<nowSelectIndexRow.count; i++) {
            
            tmp = nowSelectIndexRow[i];
            
            if ([[tmp allKeys][0] intValue] == [key intValue]) {
                
                [nowSelectIndexRow removeObject:tmp];
                
            }
        }
        
    }
    
    deletedUsers = [_mettingUserArray objectsAtIndexes:indexSet];
    [_mettingUserArray removeObjectsAtIndexes:indexSet];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshTableView
{
    [userTableView reloadData];
}

#pragma mark -
#pragma mark - UITableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_mettingUserArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NotiUserListTableViewCell";
    NotiUserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[NotiUserListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.isMine =  _isMineMetting;
    [cell loadCellWithDic:_mettingUserArray[indexPath.row]];
    
    if(rightButton.selected)
    {
        if (indexPath.row != 0 || _canDeleteFirstUser) {
            
            cell.styleSelectButton.hidden = NO;
            if ([self isSelectedCellForIndexPath:indexPath]) {
                
                [cell.styleSelectButton setImage:[UIImage imageNamed:@"CellBlueSelected.png"] forState:UIControlStateNormal];
            }else{
                [cell.styleSelectButton setImage:[UIImage imageNamed:@"CellNotSelected.png"] forState:UIControlStateNormal];
            }
            
        }else{
            
            cell.styleSelectButton.hidden = YES;
            
        }
        
        
    }
    else
    {
        cell.styleSelectButton.hidden = YES;
    }
    
   cell.styleSelectButton.tag = indexPath.row;
   //[cell.styleSelectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //通知详情参会人员的同意和拒绝人人数和愿意
    if ([_mettingUserArray[indexPath.row] isKindOfClass:[NotiUserModel class]]) {
        NotiUserModel * model = _mettingUserArray[indexPath.row];
        if ([model.status isEqualToString:@"r"] && [model.remark length] != 0) {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:LOCALIZATION(@"Message_Refue_metting") message:model.remark delegate:self cancelButtonTitle:LOCALIZATION(@"Message_IKnow") otherButtonTitles: nil];
            alertView.delegate = self;
            [alertView show];
        }
    }
    
    if (indexPath.row == 0 && !_canDeleteFirstUser) {
        
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"MeetingCreateUser_delete") isDismissLater:YES];
        
        return;
    }
        
    if (rightButton.selected) {
        [self handleSelect:indexPath];
    }
   
}


//之前点击每一行删除的alert代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
        {
            [_mettingUserArray removeObject:enterPriseUserModel];
            [userTableView reloadData];
            isDeleteModel = YES;
        }
            break;
  
        default:
            break;
    }
}

-(void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0)
    {
        [_mettingUserArray removeObjectAtIndex:currentDeleteIndex];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadMeetingUser" object:nil];
        [userTableView reloadData];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (BOOL)isSelectedCellForIndexPath:(NSIndexPath*)indexPath{
    
    
    for (int i=0; i<nowSelectIndexRow.count; i++) {
        
        if ([[nowSelectIndexRow[i] allKeys][0] intValue] == indexPath.row) {
            
            return [nowSelectIndexRow[i][@(indexPath.row)] boolValue];
            
        }
        
    }
    
    return NO;
}

- (void)handleSelect:(NSIndexPath*)indexPath{
    
    for (int i =0 ; i<nowSelectIndexRow.count; i++) {
        
        NSDictionary *tmp = nowSelectIndexRow[i];
        NSNumber *key = [tmp allKeys][0];
        
        if ([key intValue] == indexPath.row) {
            
            if ([tmp[key] boolValue] == YES) {
                
                tmp = @{key:@(NO)};
                
                
            }else{
                tmp = @{key:@(YES)};
            }
            nowSelectIndexRow[i] = tmp;
            [userTableView reloadData];
            
            return;
        }
        
    }
    
    NSDictionary *tmp = @{@(indexPath.row):@(YES)};
    
    [nowSelectIndexRow addObject:tmp];
    
    [userTableView reloadData];
}

@end
