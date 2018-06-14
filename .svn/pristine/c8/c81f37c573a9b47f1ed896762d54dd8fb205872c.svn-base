//
//  ColleagueViewController.m
//  IM
//
//  Created by ZteCloud on 15/10/20.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "ColleagueViewController.h"
#import "EnterpriseMangerViewController.h"
#import "EnterpriseContactsViewController.h"
#import "GroupContactsViewController.h"
#import "LocalContactsViewController.h"
@interface ColleagueViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    UITableView *mainTable;
    NSMutableArray *collectContactArray;
    NSMutableArray *allContactArray;//企业通讯录中所有的联系人
    
    UISearchDisplayController *searchDisplayController;
    UISearchBar *tmpSearchBar;
    NSMutableArray *resultArray;//搜索结果使用
    
    UIView *headerView1;
    UIView *headerView2;
    
    
    NSArray *sesionTitles0,*sesionTitles1;
    UIButton *mBtn;
    UILabel *contactlabel;
}

@end

@implementation ColleagueViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.drawerController removGestureRecognizers];
    appDelegate.centerButton.hidden=NO;
    [appDelegate tabbarController].navigationItem.title = self.tabBarItem.title;
    [[appDelegate tabbarController].navigationItem setRightBarButtonItem:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    allContactArray = [[NSMutableArray alloc] init];
    collectContactArray = [[NSMutableArray alloc] init];
    resultArray=[[NSMutableArray alloc]initWithCapacity:0];
    [self setTable];
    [self refreshCollectContacts];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshCollectContacts" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCollectContacts) name:@"refreshCollectContacts" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLanguageChangedNotification:)
                                                 name:kNotificationLanguageChanged
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_ENTERPRISECONTACT_FINISHED_LOAD object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationEnterpriseContactFinishedLoad:) name:NOTIFICATION_ENTERPRISECONTACT_FINISHED_LOAD object:nil];
    [self switchLanguage];
}
-(void)switchLanguage
{
    self.navigationItem.title =LOCALIZATION(@"ColleagueViewController_NavTitle");
    tmpSearchBar.placeholder =LOCALIZATION(@"ColleagueViewController_Search");
    sesionTitles0=[NSArray arrayWithObjects:LOCALIZATION(@"ColleagueViewController_Enterprise"),@"品牌设计运营", nil];
    sesionTitles1=[NSArray arrayWithObjects:LOCALIZATION(@"ColleagueViewController_LocalAddress"),LOCALIZATION(@"ColleagueViewController_GroupChat"),LOCALIZATION(@"ColleagueViewController_PublicNum"), nil];
    [mBtn setTitle:LOCALIZATION(@"ColleagueViewController_Manager") forState:UIControlStateNormal];
    contactlabel.text=LOCALIZATION(@"ColleagueViewController_CommonContact");
}
- (void)configureLocalizationString{
    
    
    
}
#pragma mark------setTable
-(void)setTable
{
//    CGFloat orgin_y = 0;
//    if(CURRENT_SYS_VERSION < 7.0999999)
//    {
//        orgin_y = 64;
//    }
    self.nibEnterpriseContacts =[UINib nibWithNibName:@"GQEnterpriseContactsCell" bundle:[NSBundle mainBundle]];
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, viewWithNavAndTabbar) style:UITableViewStylePlain];
    mainTable.backgroundColor=BGColor;
    mainTable.delegate=self;
    mainTable.dataSource=self;
    mainTable.showsVerticalScrollIndicator=NO;
    [self.view addSubview:mainTable];
    [Common setExtraCellLineHidden:mainTable];
    [self configureTableViewHeaderView];
}
-(void)configureTableViewHeaderView
{
    tmpSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 44)];
    tmpSearchBar.placeholder = @"找人";
    tmpSearchBar.delegate=self;
    // 添加 searchbar 到 headerview
    mainTable.tableHeaderView = tmpSearchBar;
    UIImage *img = [UIImage createImageWithColor:[UIColor hexChangeFloat:@"f2f2f2"] size:CGSizeMake(boundsWidth, 30)];
    [tmpSearchBar setBackgroundImage:img];
    
    //AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:tmpSearchBar contentsController:self];
    searchDisplayController.delegate = self;
    // searchResultsDataSource 就是 UITableViewDataSource
    searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //[searchDisplayController.searchBar bringSubviewToFront:appDelegate.centerButton];
    headerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, EdgeDis)];
    headerView1.backgroundColor = [UIColor hexChangeFloat:@"f2f2f2"];
    
    headerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 20)];
    headerView2.backgroundColor = [UIColor hexChangeFloat:@"f2f2f2"];
    
    contactlabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 200, 20)];
    contactlabel.backgroundColor = [UIColor clearColor];
    contactlabel.textColor = [UIColor hexChangeFloat:@"929292"];
    contactlabel.font = [UIFont systemFontOfSize:14.0f];
    contactlabel.text = @"常用联系人";
    [headerView2 addSubview:contactlabel];
}
-(void)notificationEnterpriseContactFinishedLoad:(NSNotification*)notification{
//    NSString *myGId = [[ConfigManager sharedInstance].userDictionary objectForKey:@"gid"];
//    NSArray *allUserArr =[[[SQLiteManager sharedInstance] getAllUserByGid:myGId] allValues];
//    
//    [allContactArray setArray:allUserArr];
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
    [mainTable reloadData];
}
#pragma mark------tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==mainTable)
    {
        if (section==0) {
            return 2;
        }
        if (section==1) {
            return 2;
        }
        if (section==2) {
            return collectContactArray.count;
        }
        return 1;
    }
    else
    {
        return resultArray.count;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==mainTable)
    {
        return 3;
    }
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==mainTable)
    {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell%d%d",indexPath.section,indexPath.row]];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"Cell%d%d",indexPath.section,indexPath.row]];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }
        else
        {
            for (UIView *subviews in cell.contentView.subviews) {
                if (subviews.tag>10000) {
                    [subviews removeFromSuperview];
                }
            }
        }
        switch (indexPath.section) {
            case 0:
            {
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//                NSArray *titles=[NSArray arrayWithObjects:@"企业通讯录",@"品牌设计运营", nil];
                NSArray *imgs=[NSArray arrayWithObjects:@"colleague_ea",@"in_dept", nil];
                cell.textLabel.text=[sesionTitles0 objectAtIndex:indexPath.row];
                cell.imageView.image=[UIImage imageNamed:imgs[indexPath.row]];
                if (indexPath.row==0&&[[[ConfigManager sharedInstance].userDictionary  objectForKey:@"userType"] isEqualToString:@"admin"]) {
                    mBtn=[UIButton buttonWithType:UIButtonTypeCustom];
                    mBtn.frame=CGRectMake(boundsWidth-50-EdgeDis*4, EdgeDis, 50, 28);
                    [mBtn setTitle:LOCALIZATION(@"ColleagueViewController_Manager") forState:UIControlStateNormal];
                    [mBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    mBtn.titleLabel.font=[UIFont systemFontOfSize:13];
                    mBtn.backgroundColor=MainColor;
                    mBtn.tag=10001+indexPath.row;
                    [mBtn addTarget:self action:@selector(mangerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:mBtn];
                    mBtn.layer.cornerRadius=5;
                    mBtn.layer.masksToBounds=YES;
                    
                    
                }
                if (indexPath.row==1)
                {
                    cell.textLabel.textColor=[UIColor grayColor];
                    cell.textLabel.text=[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary  objectForKey:@"cname"]];
                }
                
            }
                break;
            case 1:
            {
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

//                NSArray *titles=[NSArray arrayWithObjects:@"手机通讯录",@"我的群聊",@"公众号", nil];
                NSArray *imgs=[NSArray arrayWithObjects:@"colleague_pa",@"colleague_ac", nil];

                cell.textLabel.text=[sesionTitles1 objectAtIndex:indexPath.row];
                cell.imageView.image=[UIImage imageNamed:imgs[indexPath.row]];
                
            }
                break;
            case 2:
            {
                WEAKSELF
                _ivAvatar=[[GQLoadImageView alloc]initWithFrame:CGRectMake(EdgeDis, 2, 40, 40)];
                _ivAvatar.tag=10001+indexPath.row;
                [cell.contentView addSubview:_ivAvatar];
                _labAvatar=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _ivAvatar.frame.size.width, _ivAvatar.frame.size.height)];
                _labAvatar.textColor=[UIColor whiteColor];
                _labAvatar.textAlignment=NSTextAlignmentCenter;
                [_ivAvatar addSubview:_labAvatar];
                UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(_ivAvatar.frame.size.width+EdgeDis*2, 0, 100, 44)];
                nameLabel.tag=indexPath.row+10001;
                [cell.contentView addSubview:nameLabel];
                
                
                MEnterpriseUser *model = [collectContactArray objectAtIndex:indexPath.row];
                model.normal = YES;
                nameLabel.text=[NSString stringWithFormat:@"%@",model.uname];
                if (model.bigpicurl && model.bigpicurl.length>0) {
                    [_ivAvatar setImageWithUrl:model.bigpicurl placeHolder:[Common getImageFromColor:[UIColor colorWithRGBHex:model.uname.hash % 0xffffff]] progress:nil completed:^(UIImage *image) {
                        [weakSelf.ivAvatar setImage:image];
                    } failureBlock:^(NSError *error) {
                        if (model.uname && model.uname.length>0) {
                            weakSelf.labAvatar.text =[model.uname substringToIndex:1];
                        }
                    }];
                }else{
                    [_ivAvatar setImage:[Common getImageFromColor:[UIColor colorWithRGBHex:model.uname.hash % 0xffffff]]];
                    if (model.uname && model.uname.length>0){
                        _labAvatar.text =[model.uname substringToIndex:1];
                        
                    }
                }
                _ivAvatar.clipsToBounds =YES;
                _ivAvatar.layer.cornerRadius =20;
                
            }
                break;
            default:
                break;
        }
        return cell;
    }
    else
    {
        GQEnterpriseContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GQEnterpriseContactsCell"];
        if(!cell){
            cell=(GQEnterpriseContactsCell*)[[self.nibEnterpriseContacts instantiateWithOwner:self options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        MEnterpriseUser *model = [resultArray objectAtIndex:indexPath.row];
        model.normal = YES;
        cell.enterprise= model;
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==mainTable)
    {
        if (indexPath.section==0)
        {
            EnterpriseContactsViewController *evc=[[EnterpriseContactsViewController alloc]init];
            evc.isUserDept =(indexPath.row==0)?NO:YES;
            [self.navigationController pushViewController:evc animated:YES];
        }
        else if (indexPath.section==1)
        {
            if (indexPath.row==0)
            {
                LocalContactsViewController *contacts = [[LocalContactsViewController alloc] init];
                [self.navigationController pushViewController:contacts animated:YES];
            }
            if (indexPath.row==1)
            {
                GroupContactsViewController *contacts = [[GroupContactsViewController alloc] init];
                [self.navigationController pushViewController:contacts animated:YES];
            }
        }
        else if (indexPath.section==2)
        {
            EnterpriseUserCardViewController *userCard =[[EnterpriseUserCardViewController alloc] initWithNibName:@"EnterpriseUserCardViewController" bundle:[NSBundle mainBundle]];
            userCard.user = [collectContactArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:userCard animated:YES];
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
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section==0) {
//        return 41;
//    }
//    if (section==2) {
//        return 20;
//    }
//    return EdgeDis;
//}
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *myView=[[UIView alloc]init];
//    myView.backgroundColor=BGColor;
//    if (section==0) {
//        
//        tmpSearchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 25)];
//        tmpSearchBar.placeholder=@"找人";
//        UIImage *img = [UIImage createImageWithColor:BGColor size:CGSizeMake(boundsWidth, 25)];
//        [tmpSearchBar setBackgroundImage:img];
//        tmpSearchBar.delegate=self;
//        [myView addSubview:tmpSearchBar];
//        AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
//        
//        searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:tmpSearchBar contentsController:appDelegate.tabbarController];
//        searchDisplayController.delegate = self;
//        // searchResultsDataSource 就是 UITableViewDataSource
//        searchDisplayController.searchResultsDataSource = self;
//        // searchResultsDelegate 就是 UITableViewDelegate
//        searchDisplayController.searchResultsDelegate = self;
//        searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        
//    }
//    if (section==2) {
//        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(EdgeDis, 0, boundsWidth-EdgeDis*2, 20)];
//        titleLabel.textColor=[UIColor grayColor];
//        titleLabel.text=@"常用联系人";
//        titleLabel.font=[UIFont systemFontOfSize:13];
//        [myView addSubview:titleLabel];
//    }
//    return myView;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == mainTable)
    {
        if(section == 0)
        {
            return 0;
        }
        else if (section==1)
        {
            return EdgeDis;
        }
        else
        {
            return 20;
        }
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == mainTable)
    {
        if(section == 0)
        {
            return [[UIView alloc] initWithFrame:CGRectZero];
        }
        else if (section==1)
        {
            return headerView1;
        }
        else
        {
            return headerView2;
        }
    }
    return [[UIView alloc] initWithFrame:CGRectZero];
}
#pragma mark--------mangerBtnClick
-(void)mangerBtnClick:(UIButton*)btn
{
    EnterpriseMangerViewController *evc=[[EnterpriseMangerViewController alloc]init];
    [self.navigationController pushViewController:evc animated:YES];
}
#pragma mark 处理导航条
-(void)handleNavigationBarItem{
    self.navigationItem.title = @"同事";
    
}
#pragma mark----searchBarDeledate
//-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
//    appDelegate.centerButton.backgroundColor=[UIColor grayColor];
//    NSLog(@"search");
//}
//-(void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar
//{
//    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
//    appDelegate.centerButton.hidden=NO;
//    NSLog(@"search");
//}
//-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
//{
//    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
//    appDelegate.centerButton.hidden=NO;
//    NSLog(@"search");
//}
#pragma mark - UISearchDisplayController delegate
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString];
    return YES;
}
- (void)filterContentForSearchText:(NSString*)searchText{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uname contains[cd] %@", searchText];
    [resultArray setArray:[allContactArray filteredArrayUsingPredicate:predicate]];
    if([resultArray count] == 0)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pinyin contains[cd] %@", searchText];
        [resultArray setArray:[allContactArray filteredArrayUsingPredicate:predicate]];
    }
    if([resultArray count] == 0)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mobile contains[cd] %@", searchText];
        [resultArray setArray:[allContactArray filteredArrayUsingPredicate:predicate]];
    }
    if([resultArray count] == 0)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"jid contains[cd] %@", searchText];
        [resultArray setArray:[allContactArray filteredArrayUsingPredicate:predicate]];
    }
}
#pragma mark-------接收改变语言监听
- (void)receiveLanguageChangedNotification:(NSNotification*)notif{
    
    [Localisator sharedInstance].saveInUserDefaults = YES;
    
    if ([notif.name isEqualToString:kNotificationLanguageChanged])
    {
        [self switchLanguage];
        [mainTable reloadData];
    }
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
