//
//  LeftMainViewController.m
//  IM
//
//  Created by 陆浩 on 15/4/29.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "LeftMainViewController.h"
#import "SettingViewController.h"
#import "FeedBackViewController.h"
#import "EditUserInfoViewController.h"

@interface LeftMainViewController ()<UITableViewDataSource,UITableViewDelegate,IBActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITableView *leftTableView;
    UIView *headerView;
}

@property(nonatomic,strong)GQLoadImageView *ivAvatar;

@property(nonatomic,strong)UILabel *avatarLabel;

@end

@implementation LeftMainViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor hexChangeFloat:@"1e344b"];
    leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 200, self.view.frame.size.height)];
    leftTableView.backgroundColor = [UIColor clearColor];
    leftTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    leftTableView.dataSource = self;
    leftTableView.delegate = self;
    [self.view addSubview:leftTableView];
    
    [self configureBottomEventsView];
    [self configureAndRefreshTableViewHeaderView];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:UserInfoChange object:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Configure View
-(void)reloadTableView
{
    [self configureAndRefreshTableViewHeaderView];
    [leftTableView reloadData];
}


-(void)configureAndRefreshTableViewHeaderView
{
    headerView = [[UIView alloc] init];
    self.ivAvatar =[[GQLoadImageView alloc] initWithFrame:CGRectMake(10, 48, 60, 60)];
    self.ivAvatar.backgroundColor = [UIColor lightGrayColor];
    self.ivAvatar.layer.cornerRadius = self.ivAvatar.frame.size.width/2;
    self.ivAvatar.layer.masksToBounds = YES;
    self.ivAvatar.layer.borderColor = [UIColor hexChangeFloat:@"4869b6"].CGColor;
    self.ivAvatar.layer.borderWidth = 1.0f;
//    [self.ivAvatar setImageWithUrl:[[ConfigManager sharedInstance].userDictionary objectForKey:@"bigpicurl"] placeHolder:nil];
    [headerView addSubview:self.ivAvatar];
    
    self.avatarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.ivAvatar.frame.size.width, self.ivAvatar.frame.size.height)];
    self.avatarLabel.textAlignment = NSTextAlignmentCenter;
    self.avatarLabel.textColor = [UIColor whiteColor];
    self.avatarLabel.font = [UIFont systemFontOfSize:24.0];
    self.avatarLabel.backgroundColor = [UIColor clearColor];
    [self.ivAvatar addSubview:self.avatarLabel];

    WEAKSELF
    NSString *nameStr = [[ConfigManager sharedInstance].userDictionary objectForKey:@"name"];
    [weakSelf.ivAvatar setImageWithUrl:[[ConfigManager sharedInstance].userDictionary objectForKey:@"bigpicurl"] placeHolder:[Common getImageFromColor:[UIColor colorWithRGBHex:((NSString *)[[ConfigManager sharedInstance].userDictionary objectForKey:@"name"]).hash % 0xffffff]] progress:nil completed:^(UIImage *image) {
        [weakSelf.ivAvatar setImage:image];
    } failureBlock:^(NSError *error) {
        if (nameStr && nameStr.length>0) {
            weakSelf.avatarLabel.text =[nameStr substringToIndex:1];
        }
    }];
    
    UIButton *avatar_btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [avatar_btn setFrame:weakSelf.ivAvatar.frame];
    [avatar_btn addTarget:self action:@selector(clickedAvatarBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:avatar_btn];

    
    UILabel *labUserName =[[UILabel alloc] initWithFrame:CGRectMake(78, self.ivAvatar.frame.origin.y+9, 120, 20)];
    labUserName.font =[UIFont systemFontOfSize:18.0f];
    labUserName.backgroundColor = [UIColor clearColor];
    labUserName.textColor = [UIColor whiteColor];
    labUserName.text = [[ConfigManager sharedInstance].userDictionary objectForKey:@"name"];
    [headerView addSubview:labUserName];
    
    UILabel *labUserNumber = [[UILabel alloc] initWithFrame:CGRectMake(labUserName.frame.origin.x, labUserName.frame.size.height+labUserName.frame.origin.y+10, 75, 14)];
    labUserNumber.font =[UIFont boldSystemFontOfSize:12.0f];
    labUserNumber.textColor =[UIColor hexChangeFloat:@"9b9b9b"];
    labUserNumber.backgroundColor = [UIColor clearColor];
    labUserNumber.text = [[ConfigManager sharedInstance].userDictionary objectForKey:@"jid"];
    [headerView addSubview:labUserNumber];
    
    UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bgButton.frame = CGRectMake(0, self.ivAvatar.frame.size.height+self.ivAvatar.frame.origin.y+10, leftTableView.frame.size.width, 28);
    [bgButton setBackgroundColor:[UIColor hexChangeFloat:@"ffffff" alpha:0.2]];
    [headerView addSubview:bgButton];
    
    UILabel *view = [[UILabel alloc] initWithFrame:CGRectMake(self.ivAvatar.frame.origin.x, 4, 20, 20)];
    view.backgroundColor = [UIColor hexChangeFloat:@"c6c6c6"];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 10;
    view.text = @"“";
    view.textColor = [UIColor whiteColor];
    view.font = [UIFont boldSystemFontOfSize:18.0f];
    view.textAlignment = NSTextAlignmentCenter;
    [bgButton addSubview:view];
    
    UILabel *labUserBrief =[[UILabel alloc] initWithFrame:CGRectMake(view.frame.origin.x+view.frame.size.width+15, 0, bgButton.frame.size.width-(view.frame.origin.x+view.frame.size.width+20), 28)];
    labUserBrief.font =[UIFont systemFontOfSize:14.0f];
    labUserBrief.textColor = [UIColor hexChangeFloat:@"c6c6c6"];
    labUserBrief.backgroundColor = [UIColor clearColor];
    NSString *string = [[ConfigManager sharedInstance].userDictionary objectForKey:@"autograph"];
    labUserBrief.text = string?([string length]?string:@"编辑个性签名"):@"编辑个性签名";
    [bgButton addSubview:labUserBrief];
    
    headerView.frame = CGRectMake(0, 0, leftTableView.frame.size.width, bgButton.frame.size.height+bgButton.frame.origin.y);
    
    leftTableView.tableHeaderView = headerView;
    leftTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)configureBottomEventsView
{
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingButton.frame = CGRectMake(0, self.view.frame.size.height-40, 65, 40);
    [settingButton addTarget:self action:@selector(settingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingButton];
    
    UIImageView *setImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    setImage.image = [UIImage imageNamed:@"meun_set.png"];
    [settingButton addSubview:setImage];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(setImage.frame.size.width+setImage.frame.origin.x+5, 5, 35, 30)];
    label.text = @"设置";
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    [settingButton addSubview:label];
    
    UIButton *feedBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    feedBackButton.frame = CGRectMake(settingButton.frame.size.width+settingButton.frame.origin.x+20, self.view.frame.size.height-40, 80, 40);
    [feedBackButton addTarget:self action:@selector(feedBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:feedBackButton];
    
    UIImageView *setImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    setImage1.image = [UIImage imageNamed:@"meun_msg.png"];
    [feedBackButton addSubview:setImage1];

    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(setImage1.frame.size.width+setImage1.frame.origin.x+5, 5, 50, 30)];
    label1.text = @"意见反馈";
    label1.backgroundColor = [UIColor clearColor];
    label1.font = [UIFont systemFontOfSize:12];
    label1.textColor = [UIColor whiteColor];
    [feedBackButton addSubview:label1];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(82, self.view.frame.size.height-30, 0.5, 22)];
    line.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line];
    
}

-(void)settingButtonClick:(UIButton *)sender
{
    NSLog(@"settingButtonClick");
    SettingViewController *vc = [[SettingViewController alloc] init];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.mainNav pushViewController:vc animated:NO];
    [delegate.drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
    }];
}

-(void)feedBackButtonClick:(UIButton *)sender
{
    NSLog(@"feedBackButtonClick");
    FeedBackViewController *vc = [[FeedBackViewController alloc] init];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.mainNav pushViewController:vc animated:NO];
    [delegate.drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)clickedAvatarBtn:(id)sender {
//    IBActionSheet *asAvatar = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:NSLocalizedString(@"拍照", nil) otherButtonTitles:NSLocalizedString(@"从相册选择", nil), nil];
//    [asAvatar showInWindow:self.view.window];
    
    EditUserInfoViewController * uv = [[EditUserInfoViewController alloc]init];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [uv setSuccessBlock:^(){
//        [self configureAndRefreshTableViewHeaderView];
//    }];
    [delegate.mainNav pushViewController:uv animated:NO];
    [delegate.drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
    }];
}

#pragma mark IBActionSheetDelegate
-(void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex==0) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *camera = [[UIImagePickerController alloc] init];
            camera.sourceType = UIImagePickerControllerSourceTypeCamera;
            camera.showsCameraControls =YES;
            camera.allowsEditing = YES;
            camera.delegate = self;
            //self.imagePicker=camera;
            [self presentViewController:camera animated:YES completion:^{
            }];
        }
        
    }else if (buttonIndex==1){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
            ipc.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
            ipc.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:ipc.sourceType];
            ipc.delegate = self;
            ipc.allowsEditing = NO;
            //self.imagePicker =ipc;
            [self presentViewController:ipc animated:YES completion:NULL];
        }else{
            CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"当前设备不支持浏览照片" message:@"" cancelButtonTitle:@"确认"];
            alertView.showBlurBackground = YES;
            [alertView show];
        }
    }
}

#pragma mark -
#pragma mark - UITableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0)
    {
        //屏蔽tag
        return 3;
        //end
//        return 4;

    }
    else if(section == 1)
    {
        //屏蔽tag
//        return 0;
        //end
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 38;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"UITableViewCellLeft";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor=[UIColor hexChangeFloat:@"ffffff" alpha:0.2];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    if(indexPath.section == 0)
    {
        //屏蔽tag
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = [NSString stringWithFormat:@"公司：%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"gname"]];
                break;
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"部门：%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"cname"]];
                break;
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"职位：%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"post"]];
                break;
                
            default:
                break;
        }
        //end

//        switch (indexPath.row) {
//            case 0:
//                cell.textLabel.text = [NSString stringWithFormat:@"公司：%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"gname"]];
//                break;
//            case 1:
//                cell.textLabel.text = [NSString stringWithFormat:@"部门：%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"cname"]];
//                break;
//            case 2:
//                cell.textLabel.text = [NSString stringWithFormat:@"科室：%@",@"接口没有"];
//                break;
//            case 3:
//                cell.textLabel.text = [NSString stringWithFormat:@"职位：%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"post"]];
//                break;
//
//            default:
//                break;
//        }
    }
    else{
        cell.textLabel.text = [NSString stringWithFormat:@"常驻地：%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"permAddress"]];
 
    }
    return cell;
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [MMProgressHUD showHUDWithTitle:@"正在上传头像" isDismissLater:NO];
    UIImage *originalImage =[[info objectForKey:UIImagePickerControllerOriginalImage] fixOrientation] ;
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",APPCachesDirectory,@"tmp/avatar/"];
        NSString *assetID =[NSString stringWithUUID];
        NSString* masterFileName = [NSString stringWithFormat:@"%@%@.che",filePath,assetID];
        UIImage* masterImage = [Common createThumbnilFromUIImage:originalImage max:1000];
        NSString *thumbFileName =[NSString stringWithFormat:@"%@%@thumb.che",filePath,assetID];
        UIImage *thumbImage=[Common cutCenterImage:originalImage size:CGSizeMake(150, 150)];
        if (masterImage && thumbImage) {
            NSData* thumbData=UIImageJPEGRepresentation(thumbImage, 1.0);
            [thumbData writeToFile:thumbFileName atomically:NO];
            NSData* masterData = UIImageJPEGRepresentation(masterImage,1.0);
            BOOL success =[masterData writeToFile:masterFileName atomically:NO];
            if (success) {
                NSDictionary *uploadResult=[[FastDFSManager sharedInstance] handleWithActionName:@"upload" localFileName:masterFileName remoteFilename:nil groupName:nil];
                if ([[uploadResult objectForKey:@"code"] intValue] ==0) {
                    NSString *bigpicurl =[uploadResult objectForKey:@"masterUrl"];
                    NSString *minipicurl=@"";
                    NSDictionary *userDict =[[ConfigManager sharedInstance] userDictionary];
                    NSMutableDictionary *parameters =[[NSMutableDictionary alloc] init];
                    NSString *myToken = [userDict objectForKey:@"token"];
                    NSString *autograph=[userDict objectForKey:@"autograph"]?[userDict objectForKey:@"autograph"]:@"";
                    if (myToken && myToken.length>0) {
                        [parameters setObject:autograph forKey:@"autograph"];
                        [parameters setObject:minipicurl forKey:@"minipicurl"];
                        [parameters setObject:bigpicurl forKey:@"bigpicurl"];
                        [parameters setObject:myToken forKey:@"token"];
                        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodUpdateUser] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
                            dispatch_async(dispatch_get_main_queue(), ^{
//                                weakSelf.user.bigpicurl =bigpicurl;
                                
                                [MMProgressHUD showHUDWithTitle:@"修改头像成功" isDismissLater:YES];
//                                [[SQLiteManager sharedInstance] insertUsersToSQLite:[NSArray arrayWithObject:weakSelf.user] notificationName:NOTIFICATION_R_SQL_USER];
                                
                                NSMutableDictionary *userDictionary =[NSMutableDictionary dictionaryWithDictionary:[ConfigManager sharedInstance].userDictionary];
                                [userDictionary setObject:bigpicurl forKey:@"bigpicurl"];
                                [ConfigManager sharedInstance].userDictionary =userDictionary;
                                
                                [self.ivAvatar setImage:thumbImage];
                                [picker dismissViewControllerAnimated:YES completion:NULL];
                                
                            });
                        } failureBlock:^(NSString *description) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [MMProgressHUD showHUDWithTitle:@"修改头像失败" isDismissLater:YES];
                                [picker dismissViewControllerAnimated:YES completion:NULL];
                                
                            });
                            
                        }];
                    }
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MMProgressHUD showHUDWithTitle:@"上传头像失败" isDismissLater:YES];
                        [picker dismissViewControllerAnimated:YES completion:NULL];
                        
                    });
                }
            }
        }
    });
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
