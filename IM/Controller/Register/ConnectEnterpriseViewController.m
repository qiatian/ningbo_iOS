//
//  ConnectEnterpriseViewController.m
//  IM
//
//  Created by ZteCloud on 15/10/12.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "ConnectEnterpriseViewController.h"
#import "TableViewCell1_enterprise.h"
#import "JoinEnterpriseViewController.h"
#import "CompanyInfoViewController.h"
#import "TenantModel.h"
@interface ConnectEnterpriseViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate>
{
    UITableView *mainTable;
    UITextField *searchTF;
    NSMutableArray *tArr;
}

@end

@implementation ConnectEnterpriseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self handleNavigationBarItem];
    [self setTable];
}
-(void)setTable
{
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, boundsWidth, boundsHeight-NavBarHeight-50) style:UITableViewStylePlain];
    mainTable.backgroundColor=BGColor;
    mainTable.delegate=self;
    mainTable.dataSource=self;
    mainTable.showsVerticalScrollIndicator=NO;
    mainTable.rowHeight=66;
    [self.view addSubview:mainTable];
    [self setExtraCellLineHidden:mainTable];
    [mainTable registerNib:[UINib nibWithNibName:@"TableViewCell1_enterprise" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    UIButton *enrollBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    enrollBtn.frame=CGRectMake(0, boundsHeight-NavBarHeight-50, boundsWidth, 50);
    [enrollBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [enrollBtn setTitle:LOCALIZATION(@"ConnectEnterpriseViewController_EnrollEnterprise") forState:UIControlStateNormal];
    [enrollBtn setBackgroundColor:MainColor];
    [enrollBtn addTarget:self action:@selector(enrollBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enrollBtn];
}
-(void)searchTenantReq
{
    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"ConnectEnterpriseViewController_SearchLoading") isDismissLater:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
//        NSString *encodedString = (NSString *)
//        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                                  (CFStringRef)searchTF.text,
//                                                                  NULL,
//                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
//                                                                  kCFStringEncodingUTF8));
        NSString *keyStr=[searchTF.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:[keyStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"keyword"];
        
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodSearchTenant] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
//            NSLog(@"%@",msg);
            if(success && [data isKindOfClass:[NSDictionary class]]){
//                NSLog(@"%@",data);
                NSArray *arrList=[NSArray arrayWithArray:data[@"item"]];
                if (arrList.count==0)
                {
                    [tArr removeAllObjects];
                    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"ConnectEnterpriseViewController_SearchNO") isDismissLater:YES];
                }
                else
                {
                    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"ConnectEnterpriseViewController_SearchFinish") isDismissLater:YES];
                    tArr=[[NSMutableArray alloc]initWithCapacity:0];
                    for (NSDictionary *dic in arrList)
                    {
                        TenantModel *tm=[[TenantModel alloc]initWithDictionary:dic];
                        [tArr addObject:tm];
                    }
                }
                [mainTable reloadData];
                
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"ConnectEnterpriseViewController_SearchFail") isDismissLater:YES];
                });
            }
        } failureBlock:^(NSString *description) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"RequestFail") isDismissLater:YES];
            });
        }];
    });
}
#pragma mark--------tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell1_enterprise *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    TenantModel *tm=[tArr objectAtIndex:indexPath.row];
    cell.cNameLabel.text=tm.tenantName;
    cell.eNameLabel.text=[NSString stringWithFormat:@"%@：%@",LOCALIZATION(@"ConnectEnterpriseViewController_RegisterPerson"),tm.linkman];
    [cell.joinBtn addTarget:self action:@selector(joinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.joinBtn.tag=indexPath.row;
    cell.joinBtn.layer.borderColor=MainColor.CGColor;
    cell.joinBtn.layer.borderWidth=1;
    cell.joinBtn.layer.cornerRadius=3;
    cell.joinBtn.layer.masksToBounds=YES;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *myView=[[UIView alloc]init];
    myView.backgroundColor=BGColor;
//    UISearchBar *sb=[[UISearchBar alloc]initWithFrame:CGRectMake(EdgeDis, EdgeDis, boundsWidth-EdgeDis*2, 30)];
//    sb.placeholder=@"请输入您的企业全称";
//    UIImage *img = [UIImage createImageWithColor:BGColor size:CGSizeMake(boundsWidth, 30)];
//    [sb setBackgroundImage:img];
//    sb.delegate=self;
//    [myView addSubview:sb];
    searchTF=[[UITextField alloc]initWithFrame:CGRectMake(EdgeDis, EdgeDis, boundsWidth-EdgeDis*2, 30)];
    searchTF.placeholder=LOCALIZATION(@"ConnectEnterpriseViewController_SearchHolder");
    searchTF.backgroundColor=[UIColor whiteColor];
    searchTF.font=[UIFont systemFontOfSize:13];
    searchTF.delegate=self;
    [myView addSubview:searchTF];
    searchTF.layer.cornerRadius=3;
    searchTF.layer.masksToBounds=YES;
    UIButton *searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame=CGRectMake(boundsWidth-40-EdgeDis, EdgeDis, 40, 30);
//    searchBtn.backgroundColor=MainColor;
//    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"contact_search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:searchBtn];
//    searchBtn.imageEdgeInsets=UIEdgeInsetsMake(7, 12, 7, 12);
//    searchBtn.layer.cornerRadius=3;
//    searchBtn.layer.masksToBounds=YES;
    
    return myView;
}
//去除表中多余分割线
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
}
#pragma mark - UISearchDisplayController delegate
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString];
    return YES;
}
- (void)filterContentForSearchText:(NSString*)searchText{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uname contains[cd] %@", searchText];
//    [resultArray setArray:[collectContactArray filteredArrayUsingPredicate:predicate]];
//    if([resultArray count] == 0)
//    {
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pinyin contains[cd] %@", searchText];
//        [resultArray setArray:[collectContactArray filteredArrayUsingPredicate:predicate]];
//    }
//    if([resultArray count] == 0)
//    {
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mobile contains[cd] %@", searchText];
//        [resultArray setArray:[collectContactArray filteredArrayUsingPredicate:predicate]];
//    }
//    if([resultArray count] == 0)
//    {
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"jid contains[cd] %@", searchText];
//        [resultArray setArray:[collectContactArray filteredArrayUsingPredicate:predicate]];
//    }
}
#pragma mark------------searchBtnClick
-(void)searchBtnClick:(UIButton*)btn
{
    [self.view endEditing:YES];
    [self searchTenantReq];
}
#pragma mark--------------enrollBtnClick
-(void)enrollBtnClick:(UIButton*)btn
{
    CompanyInfoViewController *cvc=[[CompanyInfoViewController alloc]init];
    [self.navigationController pushViewController:cvc animated:YES];
}
#pragma mark---------joinBtnClick
-(void)joinBtnClick:(UIButton*)btn
{
    JoinEnterpriseViewController *jvc=[[JoinEnterpriseViewController alloc]init];
    jvc.tModel=[tArr objectAtIndex:btn.tag];
    [self.navigationController pushViewController:jvc animated:YES];
}
#pragma mark 处理导航条
-(void)handleNavigationBarItem{
    self.navigationItem.title =LOCALIZATION(@"ConnectEnterpriseViewController_NavTitle");
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
