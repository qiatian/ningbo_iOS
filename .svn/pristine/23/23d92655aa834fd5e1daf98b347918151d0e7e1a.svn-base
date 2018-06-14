//
//  EditUserInfoViewController.m
//  IM
//
//  Created by  pipapai_tengjun on 15/6/28.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "EditUserInfoViewController.h"
#import "EditUserTableViewCell.h"
#import "EditUserInfoType.h"
#import "EditDetailViewController.h"
#import "QBImagePickerController.h"

@interface EditUserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,IBActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,QBImagePickerControllerDelegate>
{
    NSMutableArray * dataArray;
    NSMutableDictionary * userDictionary;
    UITableView * editInfoTableView;
}

@end

@implementation EditUserInfoViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataArray = [[NSMutableArray alloc]initWithObjects:@"头像",@"姓名",@"性别",@"个性签名",@"我的名片",@"工作电话",@"家庭电话",@"邮箱地址", nil];
    userDictionary = [NSMutableDictionary dictionaryWithDictionary:[ConfigManager sharedInstance].userDictionary];
    
    self.view.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
    self.navigationItem.title = @"个人信息";
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];

    [self configUserInfoView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=YES;
    //数据已经在后台刷新  重新reloadtableView
    userDictionary = [NSMutableDictionary dictionaryWithDictionary:[ConfigManager sharedInstance].userDictionary];
    [editInfoTableView reloadData];
}

-(void)clickLeftItem:(id)sender{
//    if (_successBlock) {
//        _successBlock();
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configUserInfoView{
    editInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, viewWithNavNoTabbar)];
    editInfoTableView.delegate = self;
    editInfoTableView.dataSource = self;
    editInfoTableView.backgroundColor = [UIColor clearColor];
    editInfoTableView.scrollEnabled = NO;
    [editInfoTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:editInfoTableView];
}



#pragma mark -
#pragma mark - tableview delegate datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    else{
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    else{
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        if (indexPath.row ==0) {
            return 85;
        }
        else{
            return 44;
        }
    }
    else{
        return 44;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"infoCell";
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //头像
            static NSString * headCellId = @"headCell";
            EditUserTableViewCell * cell = (EditUserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:headCellId];
            if (!cell) {
                cell = [[EditUserTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:headCellId];
            }
            NSString * nameStr = [userDictionary objectForKey:@"name"];
            NSString * imageStr = [userDictionary objectForKey:@"bigpicurl"];
            [cell loadDataForCellWithCellName:dataArray[indexPath.row] UserName:nameStr ImageString:imageStr];
            return cell;
        }
        else{
            EditUserInfoTableViewCell * cell = (EditUserInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[EditUserInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
            }
            NSString * infoStr = @"";
            BOOL       value = NO;
            switch (indexPath.row) {
                case 1:
                {
                    //姓名
                    infoStr = [userDictionary objectForKey:@"name"];
                }
                    break;
                case 2:
                {
                    //性别
                    if ([[userDictionary objectForKey:@"sex"] boolValue]) {
                        infoStr = @"男";
                    }
                    else{
                        infoStr = @"女";
                    }
                }
                    break;
                case 3:
                {
                    //个性签名
                    value = YES;
                    infoStr = [userDictionary objectForKey:@"autograph"];
                }
                    break;
                case 4:
                {
                    //我的名片
                    value = YES;
                }
                    break;
   
                default:
                    break;
            }
            [cell loadDataForCellWithUserName:dataArray[indexPath.row] InfoString:infoStr isScreenWidth:value];
            return cell;
        }
    }
    else{
        EditUserInfoTableViewCell * cell = (EditUserInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[EditUserInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        }
        NSString * infoStr = @"";
        BOOL       value = NO;
        switch (indexPath.row) {
            case 0:
            {
                //工作电话
                infoStr = [userDictionary objectForKey:@"mob"];
            }
                break;
            case 1:
            {
                //家庭电话
                infoStr = [userDictionary objectForKey:@"telephone"];
            }
                break;
            case 2:
            {
                //邮箱地址
                value = YES;
                infoStr = [userDictionary objectForKey:@"email"];
            }
                break;
                
            default:
                break;
        }
        [cell loadDataForCellWithUserName:dataArray[indexPath.row+5] InfoString:infoStr isScreenWidth:value];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row ==0) {
        //更换头像
        IBActionSheet *asAvatar = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:NSLocalizedString(@"拍照", nil) otherButtonTitles:NSLocalizedString(@"从相册选择", nil), nil];
        [asAvatar showInWindow:self.view.window];
    }
    else{
        EditDetailViewController * edv = [[EditDetailViewController alloc]init];
        ValueType eType;
        NSString * title =@"";
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 1:
                    eType = EditUserNameType;
                    title = @"编辑姓名";
                    break;
                case 2:
                    eType = EditUserSexType;
                    title = @"编辑性别";
                    break;
                case 3:
                    eType = EditUserAutographType;
                    title = @"编辑个性签名";
                    break;
                case 4:
                    eType = EditUserCardType;
                    title = @"编辑我的名片";
                    break;
                default:
                    break;
            }
        }
        else{
            switch (indexPath.row) {
                case 0:
                    eType = EditUserMobType;
                    title = @"编辑工作电话";
                    break;
                case 1:
                    eType = EditUserTelType;
                    title = @"编辑家庭电话";
                    break;
                case 2:
                    eType = EditUserEmailType;
                    title = @"编辑邮箱地址";
                    break;
                default:
                    break;
            }
        }
        edv.type = eType;
        edv.navTitle = title;
        [self.navigationController pushViewController:edv animated:YES];
    }
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
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
            QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsMultipleSelection = NO;
            imagePickerController.filterType = QBImagePickerControllerFilterTypePhotos;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
            [self presentViewController:navigationController animated:YES completion:NULL];
        }else{
            CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"当前设备不支持浏览照片" message:@"" cancelButtonTitle:@"确认"];
            alertView.showBlurBackground = YES;
            [alertView show];
        }
    }
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    [MMProgressHUD showHUDWithTitle:@"正在上传头像" isDismissLater:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *originalImage=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        UIImage *neworiginalImage =[originalImage fixOrientation];
        [self updateUserImageToServerWithImage:neworiginalImage];
    });
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [MMProgressHUD showHUDWithTitle:@"正在上传头像" isDismissLater:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *originalImage =[[info objectForKey:UIImagePickerControllerOriginalImage] fixOrientation] ;
        [self updateUserImageToServerWithImage:originalImage];
    });
    
    [picker dismissViewControllerAnimated:YES completion:nil];

}
/**
 *  更新头像图片
 */
- (void)updateUserImageToServerWithImage:(UIImage *)originalImage{
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
                                
                                [MMProgressHUD showHUDWithTitle:@"修改头像成功" isDismissLater:YES];
                                
                                [userDictionary setObject:bigpicurl forKey:@"bigpicurl"];
                                [ConfigManager sharedInstance].userDictionary =userDictionary;
                                //刷新头像那一行数据
                                [editInfoTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                                //刷新工作台头像
                                [[NSNotificationCenter defaultCenter] postNotificationName:UserAvatarChange object:nil];
                                [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoChange object:nil];
                            });
                        } failureBlock:^(NSString *description) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [MMProgressHUD showHUDWithTitle:@"修改头像失败" isDismissLater:YES];
                            });
                            
                        }];
                    }
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MMProgressHUD showHUDWithTitle:@"上传头像失败" isDismissLater:YES];
                    });
                }
            }
        }
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
