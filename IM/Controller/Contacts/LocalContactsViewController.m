//
//  ContactsViewController.m
//  IM
//
//  Created by zuo guoqing on 14-9-11.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "LocalContactsViewController.h"
#import "PinYin4Objc.h"
#import "NSString+PinYin4Cocoa.h"
#import "EnterpriseUserCardViewController.h"
#import "FPPopoverController.h"
#import "FPToolController.h"
#import "ChatViewController.h"

@interface LocalContactsViewController ()<ABNewPersonViewControllerDelegate,UISearchDisplayDelegate,UISearchBarDelegate>
{
    BOOL _hasRegister;
    UISearchDisplayController *searchDisplayController;
    UISearchBar *tmpSearchBar;
    NSMutableArray *resultArray;//搜索结果使用
    NSMutableArray *allContactArray;//所有联系人数组
}

@end

@implementation LocalContactsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=YES;
}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
//    appDelegate.centerButton.hidden=NO;
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    resultArray = [[NSMutableArray alloc] init];
    allContactArray = [[NSMutableArray alloc] init];

    [self setupViews];
    [self loadData];
}

#pragma mark 组装视图
-(void)setupViews{
    self.localTBView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, boundsWidth, viewWithNavNoTabbar-44)];
    self.localTBView.delegate = self;
    self.localTBView.dataSource = self;
    self.localTBView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.localTBView.sectionIndexColor = [UIColor hexChangeFloat:@"264e7f"];
    self.localTBView.sectionIndexColor = MainColor;
//    self.localTBView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.localTBView];
    [self handleNormalNavigationBarItem];
    self.nibLocalContacts =[UINib nibWithNibName:@"GQLocalContactsCell" bundle:[NSBundle mainBundle]];
    self.localTBView.tableFooterView =[[UIView alloc] init];
    
    tmpSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 44)];
    tmpSearchBar.placeholder =LOCALIZATION(@"ColleagueViewController_Search");
    tmpSearchBar.delegate = self;
    [self.view addSubview:tmpSearchBar];
    
    UIImage *img = [UIImage createImageWithColor:[UIColor hexChangeFloat:@"e2e2e2"] size:CGSizeMake(boundsWidth, 30)];
    [tmpSearchBar setBackgroundImage:img];
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:tmpSearchBar contentsController:
                               self];
    searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    searchDisplayController.delegate = self;
    // searchResultsDataSource 就是 UITableViewDataSource
    searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    searchDisplayController.searchResultsDelegate = self;
}

#pragma mark 导航条点击事件
-(void)clickLeftItem:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickRightItem:(id)sender{
    ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
    picker.newPersonViewDelegate = self;
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:picker];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(abPersonSelectLeftAction:)];
    picker.navigationItem.backBarButtonItem = leftBarButtonItem;
    [self presentViewController:navigation animated:YES completion:^{
    }];
}

#pragma mark 新增联系人系统回调
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person;
{
    [self loadLocalContactsData];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)abPersonSelectLeftAction:(UIButton *)button
{
    [self unregisterCallback];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark 加载数据
-(void)loadData{
    [self loadLocalContactsData];
}

#pragma mark 加载本地通讯录数据
-(void)loadLocalContactsData{
    clock_t start_time = 0;
    clock_t end_time = 0;
    start_time = clock();
    RHAddressBook *pab = [[RHAddressBook alloc] init];
    end_time = clock();
    
    start_time = clock();
    NSArray *allPeoples = [pab people];
    end_time = clock();
    
    if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusNotDetermined){
        [pab requestAuthorizationWithCompletion:^(bool granted, NSError *error) {
            
        }];
    }
    
    if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusDenied){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"RHAuthorizationStatusDenied" message:@"Access to the addressbook is currently denied." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusRestricted){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"RHAuthorizationStatusRestricted" message:@"Access to the addressbook is currently restricted." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    self.localContacts = [self getSortContactsByAlphabet:allPeoples];
    //如果有#，将#放到最后一个在进行排序
    NSMutableArray *allKeysArray = [NSMutableArray arrayWithArray:self.localContacts.allKeys];
    if([allKeysArray containsObject:@"#"]){
        [allKeysArray removeObject:@"#"];
        self.localContactKeys = [NSMutableArray arrayWithArray:[allKeysArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]];
        [self.localContactKeys addObject:@"#"];
    }
    else{
        self.localContactKeys = [NSMutableArray arrayWithArray:[allKeysArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]];
    }
    //end
    [self.localTBView reloadData];
}


#pragma mark 处理正常情况下的导航条
-(void)handleNormalNavigationBarItem{
    self.navigationItem.title = LOCALIZATION(@"ColleagueViewController_LocalAddress");
//    if(_forSelectUser)
//    {
        ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
        [self.navigationItem setLeftBarButtonItem:leftItem];
//    }
//    else
//    {
//        ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
//        [self.navigationItem setLeftBarButtonItem:leftItem];
//        
//        ILBarButtonItem *rightItem = [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_contact_add.png"] highlightedImage:nil target:self action:@selector(clickRightItem:)];
//        [self.navigationItem setRightBarButtonItem:rightItem];
//    }
}

#pragma mark 根据字母排序本地通讯录
-(NSMutableDictionary *)getSortContactsByAlphabet:(NSArray *)contacts{
    [allContactArray removeAllObjects];
    NSMutableDictionary *resultDic =[[NSMutableDictionary alloc] init];
    for (NSString * alpha in ALPHA_ARRAY) {
        NSMutableArray * temp = [[NSMutableArray alloc]  init];
        for (RHPerson * mc in contacts) {
            if ([mc.pinyin hasPrefix:[alpha lowercaseString]]||[mc.pinyin hasPrefix:[alpha uppercaseString]]) {
                [temp addObject:mc];
            }
        }
        if([temp count] > 0)
        {
            [resultDic setObject:temp forKey:alpha];
            [allContactArray addObjectsFromArray:temp];
        }
    }
    
    //所有名称开头不是‘A’~‘Z’的，都放入‘#’分类里面
    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithArray:contacts];
    for(RHPerson * model in allContactArray)
    {
        for(int i = 0 ; i < [tmpArray count] ; i ++)
        {
            RHPerson *mc = [tmpArray objectAtIndex:i];
            if([model.pinyin isEqualToString:mc.pinyin])
            {
                [tmpArray removeObject:mc];
            }
        }
    }
    if([tmpArray count])
    {
        [resultDic setObject:tmpArray forKey:@"#"];
        [allContactArray addObjectsFromArray:tmpArray];
    }
    //end
    return resultDic;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(tableView == self.localTBView)
    {
        return 22;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(tableView == self.localTBView)
    {
        UIView *customHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, 22)];
        customHeaderView.backgroundColor = [UIColor hexChangeFloat:@"f3f3f3"];
        
        UILabel *headerLabel = [[UILabel alloc]initWithFrame: CGRectMake(15.0f, 0, boundsWidth, 22)];
        headerLabel.text =[self.localContactKeys objectAtIndex:section];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        headerLabel.textColor = [UIColor hexChangeFloat:@"8b8b8b"];
        [customHeaderView addSubview:headerLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 0.5)];
        line.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
        [customHeaderView addSubview:line];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, customHeaderView.frame.size.height-0.5, boundsWidth, 0.5)];
        line1.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
        [customHeaderView addSubview:line1];
        
        return customHeaderView;
    }
    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RHPerson *person = nil;
    if(tableView == self.localTBView)
    {
        NSString *sectionKey= [self.localContactKeys objectAtIndex:indexPath.section];
        NSArray * sectionArray = [self.localContacts objectForKey:sectionKey];
        person = [sectionArray objectAtIndex:indexPath.row];
    }
    else
    {
        person = [resultArray objectAtIndex:indexPath.row];
    }
    if(_forSelectUser)
    {
        if(_selectBlock)
        {
            _selectBlock (person);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
        personViewController.navigationItem.title = @"";
        [person.addressBook performAddressBookAction:^(ABAddressBookRef addressBookRef) {
            personViewController.addressBook =addressBookRef;
        } waitUntilDone:YES];
        personViewController.displayedPerson = person.recordRef;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
        personViewController.allowsActions = YES;
#endif
        personViewController.allowsEditing = YES;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:personViewController];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonSystemItemCancel target:self action:@selector(abPersonSelectLeftAction:)];
        personViewController.navigationItem.backBarButtonItem = leftBarButtonItem;
        
        [self presentViewController:nav animated:YES completion:^{
            [self registerCallback];
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 42;
}

#pragma mark UITableViewDataSource
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(tableView == self.localTBView)
    {
        NSMutableArray *rightAlphas=[[NSMutableArray alloc]initWithCapacity:0];
        [rightAlphas addObject:@"|"];
        [rightAlphas addObject:@"☆"];
        [rightAlphas addObjectsFromArray:self.localContactKeys];
        [rightAlphas addObject:@"|"];
//        for (int i=1; i<self.localContactKeys.count * 2; i++)
//        {
//            if (i % 2 == 1) {
//                [rightAlphas addObject:self.localContactKeys[i/2]];
//            }else{
//                [rightAlphas addObject:@"."];            }
//        }
        return rightAlphas;
    }
    return nil;
    // 字母索引列表
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView == self.localTBView)
    {
        return [self.localContacts count];
    }
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.localTBView)
    {
        NSString *sectionKey= [self.localContactKeys objectAtIndex:section];
        NSArray * sectionArray = [self.localContacts objectForKey:sectionKey];
        return [sectionArray count];
    }
    else
    {
        return [resultArray count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.localTBView)
    {
        GQLocalContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GQLocalContactsCell"];
        if(!cell){
            cell=(GQLocalContactsCell*)[[self.nibLocalContacts instantiateWithOwner:self options:nil] objectAtIndex:0];
        }
        NSString *sectionKey= [self.localContactKeys objectAtIndex:indexPath.section];
        NSArray * sectionArray = [self.localContacts objectForKey:sectionKey];
        if([sectionArray count] == indexPath.row + 1)
        {
            cell.lineView.hidden = YES;
        }
        else
        {
            cell.lineView.hidden = NO;
        }
        cell.user= [sectionArray objectAtIndex:indexPath.row];
        return cell;
    }
    else
    {
        GQLocalContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GQLocalContactsCell"];
        if(!cell){
            cell=(GQLocalContactsCell*)[[self.nibLocalContacts instantiateWithOwner:self options:nil] objectAtIndex:0];
        }
        cell.user= [resultArray objectAtIndex:indexPath.row];
        return cell;
    }
}

#pragma mark - 通讯录修改监听事件
- (void)registerCallback {
    if (!_addressBook) {
        _addressBook = (__bridge RHAddressBook *)(ABAddressBookCreate());
    }
    
    ABAddressBookRegisterExternalChangeCallback((__bridge ABAddressBookRef)(_addressBook), addressCallback, (__bridge void *)(self));
    NSLog(@"注册监听");

}

- (void)unregisterCallback {
    NSLog(@"注销监听");
    ABAddressBookUnregisterExternalChangeCallback((__bridge ABAddressBookRef)(_addressBook), addressCallback, (__bridge void *)(self));
}

void addressCallback(ABAddressBookRef addressBook, CFDictionaryRef info, void *context) {
    //更新通讯录
    LocalContactsViewController *viewController = objc_unretainedObject(context);
    [viewController loadLocalContactsData];
}

#pragma mark - UISearchDisplayController delegate
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString];
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", searchText];
    [resultArray setArray:[allContactArray filteredArrayUsingPredicate:predicate]];
    if([resultArray count] == 0)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pinyin contains[cd] %@", searchText];
        [resultArray setArray:[allContactArray filteredArrayUsingPredicate:predicate]];
    }
    if([resultArray count] == 0)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"phoneNumberString contains[cd] %@", searchText];
        [resultArray setArray:[allContactArray filteredArrayUsingPredicate:predicate]];
    }
}

@end
