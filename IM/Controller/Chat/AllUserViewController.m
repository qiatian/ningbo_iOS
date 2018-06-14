//
//  AllUserViewController.m
//  IM
//
//  Created by 陆浩 on 15/5/10.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "AllUserViewController.h"
#import "UIImageView+WebCache.h"
#import "SelectEnterpriseUserViewController.h"

#define UserButtonDefine 40000

@implementation AllUserCell

@synthesize avatarImageView,styleSelectButton,nameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
        avatarImageView.layer.masksToBounds = YES;
        avatarImageView.layer.cornerRadius = 20;
        [self.contentView addSubview:avatarImageView];
        
        styleSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        styleSelectButton.frame = CGRectMake(boundsWidth-30-10, 15, 30, 30);
        [styleSelectButton setImage:[UIImage imageNamed:@"CellBlueSelected.png"] forState:UIControlStateSelected];
        [styleSelectButton setImage:[UIImage imageNamed:@"CellNotSelected.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:styleSelectButton];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 200, 40)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.contentView addSubview:nameLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 59.5, boundsWidth, 0.5)];
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


@interface AllUserViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView *userScrollerView;
    UITableView *userTableView;
    NSMutableArray *nowSelectIndexRow;
    UIButton *rightButton;
}

@end

@implementation AllUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRSQLGroupUser:) name:NOTIFICATION_R_SQL_GROUPUSER object:nil];
    
    nowSelectIndexRow = [[NSMutableArray alloc] init];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = LOCALIZATION(@"Message_Group_Members");
    
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 60, 44);
    NSString *identity1 =[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"];
    if ([identity1 longLongValue]==[((MGroup*)self.groupUser).uid longLongValue]) {
        
        [rightButton setTitle:LOCALIZATION(@"Message_Del_Member") forState:UIControlStateNormal];
        [rightButton setTitle:LOCALIZATION(@"Message_CXAlertView_title3") forState:UIControlStateSelected];
    }else {
        rightButton.hidden = YES;
    
    }
    
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    NSString *identity =[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"];
    if (([identity longLongValue]==[((MGroup*)self.groupUser).uid longLongValue]&&!_forSelectUser) || _canDeleteUser) {
        ILBarButtonItem *rightItem =[ILBarButtonItem barItemWithCustomView:rightButton target:self action:@selector(clickDeleteItem:)];
        [self.navigationItem setRightBarButtonItem:rightItem];
    }
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setTitle:@"添加群组成员" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    button.frame = CGRectMake(0, 0, boundsWidth, 44);
//    [button addTarget:self action:@selector(addGroupUserButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
//    
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, boundsWidth, 0.5)];
//    line.backgroundColor = [UIColor lightGrayColor];
//    [button addSubview:line];
    
    userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, viewWithNavNoTabbar)];
    userTableView.delegate = self;
    userTableView.dataSource = self;
    userTableView.backgroundColor = [UIColor clearColor];
    userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    userTableView.tableHeaderView = button;
    [self.view addSubview:userTableView];

    if(_forSelectUser)
    {
        //如果是选择群组成员，由于聊天界面没有成员信息，这里需要加载一下
        [self loadData];
    }
    
//    [self configureUserView];
    // Do any additional setup after loading the view.
}

-(void)loadData{
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        weakSelf.groupUser =[[[SQLiteManager sharedInstance] getAllOnlyGroups] objectForKey:weakSelf.groupUser.groupid];
        [[SQLiteManager sharedInstance] setUserArrayByGroupModel:weakSelf.groupUser];
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:weakSelf.groupUser.users];
        int isMine = -1;
        for(int i = 0 ; i < array.count ; i ++)
        {
            MGroupUser *user = array[i];
            NSString *identity =[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"];
            if ([identity longLongValue] == [user.uid longLongValue]) {
                isMine = i;
            }
        }
        if(isMine >= 0)
        {
            [array removeObjectAtIndex:isMine];//去掉自己不能被@
        }
        weakSelf.groupUser.users = [NSMutableArray arrayWithArray:array];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [userTableView reloadData];
        });
    });
}



-(void)clickLeftItem:(id)sender{
    if(_forSelectUser)
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickDeleteItem:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.isSelected)
    {
        //删除
        NSLog(@"删除");
    }
    else
    {
        //选择
        NSLog(@"选择");
        if([nowSelectIndexRow count])
        {
            [self deleteUserFromGroup];
            [nowSelectIndexRow removeAllObjects];
        }
    }
    [userTableView reloadData];
}

-(void)deleteUserFromGroup
{
    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_Deling") isDismissLater:NO];

    NSMutableArray *uidArray = [[NSMutableArray alloc] init];
    for(int i = 0 ; i<[nowSelectIndexRow count]; i++)
    {
        MGroupUser *groupUser = [self.groupUser.users objectAtIndex:[nowSelectIndexRow[i] intValue]];
        [uidArray addObject:[NSNumber numberWithLongLong:[groupUser.uid longLongValue]]];
    }
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *myToken =[[ConfigManager sharedInstance].userDictionary  objectForKey:@"token"];
        NSMutableDictionary *params =[[NSMutableDictionary alloc] init];
        [params setObject:myToken forKey:@"token"];
        [params setObject:weakSelf.groupUser.groupid forKey:@"groupid"];
        [params setObject:uidArray forKey:@"users"];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodRemoveGroupMember] parameters:params successBlock:^(BOOL success, id data, NSString *msg) {
            
                for(NSNumber *deleteUserId in uidArray)
                {
                    [[SQLiteManager sharedInstance] deleteGroupUserId:[NSString stringWithFormat:@"%@",deleteUserId] groupId:weakSelf.groupUser.groupid notificationName:nil];
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"AmendDepartmentViewController_DeleFinish!") isDismissLater:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_D_SQL_GROUPUSER_RELOAD object:nil];
                    [weakSelf notificationRSQLGroupUser:nil];
                });
            }
            failureBlock:^(NSString *description) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_Dele_fil") isDismissLater:YES];
                });
        }];
    });
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.groupUser.users count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SysStyleCell";
    AllUserCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[AllUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor=[UIColor hexChangeFloat:@"ffffff"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MGroupUser *groupUser = [self.groupUser.users objectAtIndex:indexPath.row];
    cell.nameLabel.text = groupUser.uname;
    cell.styleSelectButton.selected = NO;
    if(rightButton.selected)
    {
        cell.styleSelectButton.hidden = NO;
    }
    else
    {
        cell.styleSelectButton.hidden = YES;
    }
    NSString *identity =[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"];
    if ([identity longLongValue]==[groupUser.uid longLongValue]) {
        //自己不能被删除
        cell.styleSelectButton.hidden = YES;
    }
    
    cell.styleSelectButton.tag = indexPath.row;
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:groupUser.bigpicurl] placeholderImage:[UIImage imageNamed:@"chat_settingHead.png"]];
    [cell.styleSelectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_forSelectUser)
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            if(_selectBlock)
            {
                _selectBlock([self.groupUser.users objectAtIndex:indexPath.row]);
            }
        }];
    }
    else
    {
        EnterpriseUserCardViewController *userCard =[[EnterpriseUserCardViewController alloc] initWithNibName:@"EnterpriseUserCardViewController" bundle:[NSBundle mainBundle]];
        userCard.user = [self.groupUser.users objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:userCard animated:YES];
    }
}

-(void)selectButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if(sender.selected)
    {
        [nowSelectIndexRow addObject:[NSString stringWithFormat:@"%d",sender.tag]];
    }
    else
    {
        [nowSelectIndexRow removeObject:[NSString stringWithFormat:@"%d",sender.tag]];
    }
}


-(void)notificationRSQLGroupUser:(NSNotification*)notification
{
    self.groupUser =[[[SQLiteManager sharedInstance] getAllOnlyGroups] objectForKey:self.groupUser.groupid];
    [[SQLiteManager sharedInstance] setUserArrayByGroupModel:self.groupUser];
    [userTableView reloadData];

    
//    self.groupUser =[[[SQLiteManager sharedInstance] getAllGroups] objectForKey:self.groupUser.groupid];
//    [userTableView reloadData];
}


-(void)addGroupUserButtonClick:(UIButton *)sender
{
    SelectEnterpriseUserViewController *selectUserVC =[[SelectEnterpriseUserViewController alloc] init];
    selectUserVC.groupName =self.groupUser.groupName;
    selectUserVC.groupId =self.groupUser.groupid;
    NSMutableArray *userIds =[[NSMutableArray alloc] init];
    for (MGroupUser *gu in self.groupUser.users) {
        if (gu && gu.uid && [NSString stringWithFormat:@"%@",gu.uid].length>0) {
            [userIds addObject:gu.uid];
        }
    }
    selectUserVC.disabledContactIds =[NSMutableArray arrayWithArray:userIds];
    GQNavigationController *selectUserVCNav =[[GQNavigationController alloc] initWithRootViewController:selectUserVC];
    [self presentViewController:selectUserVCNav animated:YES completion:^{
    }];
}

@end
