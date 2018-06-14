//
//  ContactsMainViewController.m
//  IM
//
//  Created by 陆浩 on 15/4/21.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "ContactsMainViewController.h"
#import "ContactsTableViewCell.h"
#import "ContactsViewController.h"
#import "EnterpriseContactsViewController.h"
#import "GroupContactsViewController.h"
#import "LocalContactsViewController.h"

@interface ContactsMainViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    UITableView *contactsTableView;
    NSArray *titleArray;
    NSArray *imageArray;
    UIView *headerView1;
    UIView *headerView2;
    
    UISearchDisplayController *searchDisplayController;
    UISearchBar *tmpSearchBar;
    
    NSMutableArray *allContactArray;//企业组织架构中所有的联系人
    NSMutableArray *collectContactArray;//常用联系人数组
    NSMutableArray *resultArray;//搜索结果使用
}

@end

@implementation ContactsMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    allContactArray = [[NSMutableArray alloc] init];
    collectContactArray = [[NSMutableArray alloc] init];
    resultArray = [[NSMutableArray alloc] init];
    
    [self configureView];
    [self refreshCollectContacts];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshCollectContacts" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCollectContacts) name:@"refreshCollectContacts" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_ENTERPRISECONTACT_FINISHED_LOAD object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationEnterpriseContactFinishedLoad:) name:NOTIFICATION_ENTERPRISECONTACT_FINISHED_LOAD object:nil];

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.drawerController removGestureRecognizers];
    appDelegate.centerButton.hidden=NO;
    [appDelegate tabbarController].navigationItem.title = self.tabBarItem.title;
    [[appDelegate tabbarController].navigationItem setRightBarButtonItem:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
//    appDelegate.centerButton.hidden=YES;
    //解决出现上半部分白屏的问题，操蛋
    [searchDisplayController setActive:YES animated:NO];
    [searchDisplayController setActive:NO animated:NO];
    //end
}

#pragma mark -
#pragma mark - Configure View
-(void)configureView
{
    titleArray = @[LOCALIZATION(@"Message_LocalAddressBook"),LOCALIZATION(@"Message_Enterprise_organizational"),LOCALIZATION(@"Message_zhuqun")];
    imageArray = @[@"Contact_local.png",@"Contact_comp.png",@"Contact_group.png"];
    self.view.backgroundColor = [UIColor hexChangeFloat:@"ffffff"];

    self.nibEnterpriseContacts =[UINib nibWithNibName:@"GQEnterpriseContactsCell" bundle:[NSBundle mainBundle]];
    CGFloat orgin_y = 0;
    if(CURRENT_SYS_VERSION < 7.0999999)
    {
        orgin_y = 64;
    }
    contactsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, orgin_y, self.view.frame.size.width, viewWithNavAndTabbar)];
    contactsTableView.backgroundColor = [UIColor clearColor];
    contactsTableView.dataSource = self;
    contactsTableView.delegate = self;
    contactsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:contactsTableView];
    [self configureTableViewHeaderView];
}

-(void)configureTableViewHeaderView
{
    tmpSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 44)];
    tmpSearchBar.placeholder = LOCALIZATION(@"Message_tmpSearchBar_placeholder");
    // 添加 searchbar 到 headerview
    contactsTableView.tableHeaderView = tmpSearchBar;
    UIImage *img = [UIImage createImageWithColor:[UIColor hexChangeFloat:@"f2f2f2"] size:CGSizeMake(boundsWidth, 30)];
    [tmpSearchBar setBackgroundImage:img];    
    
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;

    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:tmpSearchBar contentsController:appDelegate.tabbarController];
    searchDisplayController.delegate = self;
    // searchResultsDataSource 就是 UITableViewDataSource
    searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    headerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 20)];
    headerView2.backgroundColor = [UIColor hexChangeFloat:@"f2f2f2"];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 200, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor hexChangeFloat:@"929292"];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.text = LOCALIZATION(@"ColleagueViewController_CommonContact");
    [headerView2 addSubview:label];
}

-(void)notificationEnterpriseContactFinishedLoad:(NSNotification*)notification{
    NSString *myGId = [[ConfigManager sharedInstance].userDictionary objectForKey:@"gid"];
    NSArray *allUserArr =[[[SQLiteManager sharedInstance] getAllUserByGid:myGId] allValues];
    
    [allContactArray setArray:allUserArr];
    [self refreshCollectContacts];
}

-(void)refreshCollectContacts
{
    NSString *myGId = [[ConfigManager sharedInstance].userDictionary objectForKey:@"gid"];
    NSArray *allUserArr =[[[SQLiteManager sharedInstance] getAllUserByGid:myGId] allValues];
    
    [allContactArray setArray:allUserArr];
    [collectContactArray removeAllObjects];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([userDefault objectForKey:@"contact_collect_user_id"])
    {
        if([[userDefault objectForKey:@"contact_collect_user_id"] objectForKey:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]]])
        {
            NSArray *array = [[userDefault objectForKey:@"contact_collect_user_id"] objectForKey:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]]];
            for(NSString *uid in array)
            {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@", uid];
                [collectContactArray addObjectsFromArray:[allContactArray filteredArrayUsingPredicate:predicate]];
            }
        }
    }
    [contactsTableView reloadData];
}

#pragma mark -
#pragma mark - UITableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == contactsTableView)
    {
        if(section == 0)
        {
            return [imageArray count];
        }
        else
        {
            return [collectContactArray count];
        }
    }
    return [resultArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == contactsTableView)
    {
        return 2;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == contactsTableView)
    {
        if(section == 0)
        {
            return 0;
        }
        else
        {
            return 20;
        }
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == contactsTableView)
    {
        if(indexPath.section == 0)
        {
            return 42;
        }
        else
        {
            return 50;
        }
    }
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == contactsTableView)
    {
        if(section == 0)
        {
            return [[UIView alloc] initWithFrame:CGRectZero];
        }
        else
        {
            return headerView2;
        }
    }
    return [[UIView alloc] initWithFrame:CGRectZero];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == contactsTableView)
    {
        if(indexPath.section == 0)
        {
            static NSString *CellIdentifier = @"ContactsTableViewCell";
            ContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[ContactsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.backgroundColor=[UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.titleLabel.text = [titleArray objectAtIndex:indexPath.row];
            cell.logoImageView.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
            return cell;
        }
        else
        {
            GQEnterpriseContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GQEnterpriseContactsCell"];
            if(!cell){
                cell=(GQEnterpriseContactsCell*)[[self.nibEnterpriseContacts instantiateWithOwner:self options:nil] objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            MEnterpriseUser *model = [collectContactArray objectAtIndex:indexPath.row];
            model.normal = YES;
            cell.enterprise = model;
            return cell;
        }
    }
    else
    {
        GQEnterpriseContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GQEnterpriseContactsCell"];
        if(!cell){
            cell=(GQEnterpriseContactsCell*)[[self.nibEnterpriseContacts instantiateWithOwner:self options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.enterprise= [resultArray objectAtIndex:indexPath.row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == contactsTableView)
    {
        if(indexPath.section == 0)
        {
            if(indexPath.row == 0)
            {
                LocalContactsViewController *contacts = [[LocalContactsViewController alloc] init];
                [self.navigationController pushViewController:contacts animated:YES];
            }
            else if(indexPath.row == 1)
            {
                EnterpriseContactsViewController *contacts = [[EnterpriseContactsViewController alloc] init];
                [self.navigationController pushViewController:contacts animated:YES];
            }
            
            else if(indexPath.row == 2)
            {
                GroupContactsViewController *contacts = [[GroupContactsViewController alloc] init];
                [self.navigationController pushViewController:contacts animated:YES];
            }
        }
        else
        {
            MEnterpriseUser *enterprise = [collectContactArray objectAtIndex:indexPath.row];
            EnterpriseUserCardViewController *userCardViewController =[[EnterpriseUserCardViewController alloc] initWithNibName:@"EnterpriseUserCardViewController" bundle:[NSBundle mainBundle]];
            userCardViewController.user = enterprise;
            [self.navigationController pushViewController:userCardViewController animated:YES];
        }
    }
    else
    {
        MEnterpriseUser *enterprise = [resultArray objectAtIndex:indexPath.row];
        EnterpriseUserCardViewController *userCardViewController =[[EnterpriseUserCardViewController alloc] initWithNibName:@"EnterpriseUserCardViewController" bundle:[NSBundle mainBundle]];
        userCardViewController.user = enterprise;
        [self.navigationController pushViewController:userCardViewController animated:YES];
    }
}



#pragma mark - UISearchDisplayController delegate
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString];
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uname contains[cd] %@", searchText];
    [resultArray setArray:[collectContactArray filteredArrayUsingPredicate:predicate]];
    if([resultArray count] == 0)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pinyin contains[cd] %@", searchText];
        [resultArray setArray:[collectContactArray filteredArrayUsingPredicate:predicate]];
    }
    if([resultArray count] == 0)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mobile contains[cd] %@", searchText];
        [resultArray setArray:[collectContactArray filteredArrayUsingPredicate:predicate]];
    }
    if([resultArray count] == 0)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"jid contains[cd] %@", searchText];
        [resultArray setArray:[collectContactArray filteredArrayUsingPredicate:predicate]];
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

@end
