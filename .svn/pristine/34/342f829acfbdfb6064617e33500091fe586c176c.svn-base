//
//  ZTEPersonalProfileController.m
//  IM
//
//  Created by 周永 on 15/11/7.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "ZTEPersonalProfileController.h"
#import "QBImagePickerController.h"
#import "ZTEProfileCell.h"
#import "IBActionSheet.h"
#import "ZTEProfileDetailController.h"
#import "ZTEUserProfileTools.h"
#import "ZTESalaryViewController.h"
#define ORIGINAL_MAX_WIDTH 640.0f

@interface ZTEPersonalProfileController ()<IBActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,QBImagePickerControllerDelegate>

@property (nonatomic, strong) NSDictionary *dataDict;       //存放每组每行标题的字典

@property (nonatomic, strong) NSMutableDictionary *userInfoDict;   //用户信息

@end

@implementation ZTEPersonalProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.scrollEnabled = NO;
    
    self.title = LOCALIZATION(@"discover_profile");
    //,@"dis_pro_code"
    _dataDict = @{@"0":@[@"dis_pro_header",@"dis_pro_name"],
                  @"1":@[@"dis_pro_gender",@"dis_pro_auto",@"dis_pro_region"],
                  @"2":@[@"dis_pro_enterinfo"]
                  };
    
    //监听用户信息更新 刷新数据
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoUpdated) name:ZTEUserInfoUpdatedNotification object:nil];
    
    //头像更新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerImageUpdated) name:ZTEUserHeaderImageUpdatedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
     _userInfoDict = [NSMutableDictionary dictionaryWithDictionary:[ConfigManager sharedInstance].userDictionary];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Update UserInfo

- (void)userInfoUpdated{
    
    _userInfoDict = [NSMutableDictionary dictionaryWithDictionary:[ConfigManager sharedInstance].userDictionary];

    [self.tableView reloadData];
}
/**
 *  头像更新
 */
- (void)headerImageUpdated{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *token = [ConfigManager sharedInstance].userDictionary[@"token"];
    NSString *bigPicUrl = [ConfigManager sharedInstance].userDictionary[@"bigpicurl"];
    //设置参数
    [parameters setValue:token forKey:@"token"];
    [parameters setValue:bigPicUrl forKey:@"bigpicurl"];

    
    [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodUpdateUser] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
        if (data) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dic = (NSDictionary *)data;
                NSDictionary * resDic = [dic objectForKey:@"res"];
                //reCode返回1 表示成功
                if ([resDic objectForKey:@"reCode"] && [[resDic objectForKey:@"reCode"]intValue]==1 ) {
                    
                    _userInfoDict = [NSMutableDictionary dictionaryWithDictionary:[ConfigManager sharedInstance].userDictionary];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
//                        ZTEProfileCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0 ]];
//                        [cell.leftHeaderImageView sd_setImageWithURL:[NSURL URLWithString:_userInfoDict[kZTEPersonalProfileHeadImageURL]] placeholderImage:[UIImage imageNamed:@"default_head"]];
                        
                        
                    });
                    
                }
            }
            else{
                
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"formatter_error") isDismissLater:YES];
            }
        }
        else{
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"data_nil") isDismissLater:YES];
        }
    } failureBlock:^(NSString *description) {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"network_failed") isDismissLater:YES];
        return;
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataDict.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = [NSString stringWithFormat:@"%d",(int)section];
    return [_dataDict[key] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuseId = @"infoCell";
    static NSString *headReuseId = @"headCell";
    
    ZTEProfileCell *profileCell;
    //头像的cell 和其余的cell 不一样 所以要分开
    if (indexPath.section == 0 && indexPath.row == 0) {
        profileCell = [tableView dequeueReusableCellWithIdentifier:headReuseId];
    }else{
        profileCell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    }
    
    if (!profileCell) {
        
        if (indexPath.section == 0 && indexPath.row == 0) {
            profileCell = [[ZTEProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headReuseId];
            
        }else{
            /**
             *  后期要修改数据
             */
            profileCell = [[ZTEProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            
        }
        
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSURL *imageURL = [NSURL URLWithString:_userInfoDict[kZTEPersonalProfileHeadImageURL]];
        [profileCell.leftHeaderImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"default_head"]];
    }
    
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 1) {//姓名
                profileCell.leftInfoLabel.text = _userInfoDict[kZTEPersonalProfileNickName];
                profileCell.leftInfoLabel.textColor = [UIColor grayColor];
            }
        }
            break;
        case 1:{
            if (indexPath.row == 0) {
                profileCell.leftInfoLabel.text = ([_userInfoDict[kZTEPersonalProfileSex] intValue] == 1) ? LOCALIZATION(@"dis_gender_male"):LOCALIZATION(@"dis_gender_female");
            }else if (indexPath.row == 1){
                profileCell.leftInfoLabel.text = _userInfoDict[kZTEPersonalProfileSignature];
            }else{
                //后期修改
                profileCell.leftInfoLabel.text = _userInfoDict[kZTEPersonalProfileAddress];
            }
            profileCell.leftInfoLabel.textColor = [UIColor grayColor];
        }
            
            break;
        case 2:{
            
        }
            
            break;
        default:
            break;
    }
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        profileCell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        profileCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *key = [NSString stringWithFormat:@"%d",(int)indexPath.section];
    NSString *title = LOCALIZATION(_dataDict[key][indexPath.row]);
    profileCell.textLabel.text = title;
    
    profileCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return profileCell;
    
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 10.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
//        //根据图片高度来控制cell高度
//        UIImage *headImage = [UIImage imageNamed:@"headBG"];
//        return  headImage.size.height + 20.0;
        return 80.0;
    }
    
    return 44.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZTEProfileDetailController *profileDetailVC = [[ZTEProfileDetailController alloc] initWithStyle:UITableViewStyleGrouped];
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0://点击头像cell进入照片选择或拍照
                {
                    //更换头像
                    IBActionSheet *asAvatar = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LOCALIZATION(@"discover_cancel") destructiveButtonTitle:LOCALIZATION(@"dis_header_takepic") otherButtonTitles:LOCALIZATION(@"dis_header_picker"), nil];
                    [asAvatar showInWindow:self.view.window];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:{
            
            switch (indexPath.row) {
                case 0: //性别
                    profileDetailVC.detailType = ZTEProfileDetailTypeGender;
                    break;
                case 1: //个性签名
                    profileDetailVC.detailType = ZTEProfileDetailTypeSignature;
                    break;
                case 2: //地区
                    profileDetailVC.detailType = ZTEProfileDetailTypeLocation;
                    break;
                default:
                    break;
            }
            
        }
            break;
        case 2://企业信息
            profileDetailVC.detailType = ZTEProfileDetailTypeEnterpriseInfo;
            break;
        default:
            break;
    }
    
    if (profileDetailVC.detailType) {
        
        [self.navigationController pushViewController:profileDetailVC animated:YES];
        
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
            camera.showsCameraControls = YES;
            [self presentViewController:camera animated:YES completion:^{
            }];
        }
        
    }else if (buttonIndex==1){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){

            QBImagePickerController * imagePickerController = [[QBImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsMultipleSelection = NO;
            imagePickerController.filterType = QBImagePickerControllerFilterTypePhotos;
            UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
            [self presentViewController:navigationController animated:YES completion:NULL];
        }else{
            CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:LOCALIZATION(@"header_not_support") message:@"" cancelButtonTitle:LOCALIZATION(@"confirm")];
            alertView.showBlurBackground = YES;
            [alertView show];
        }
    }
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    [imagePickerController dismissViewControllerAnimated:YES completion:^{
        UIImage *originalImage=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        UIImage *neworiginalImage = [originalImage fixOrientation];
       //裁剪
        NJImageCropperViewController * imgEditorVC = [[NJImageCropperViewController alloc]initWithImage:neworiginalImage cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            
        }];
    }];
}
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage
{
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}
- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;

        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;

        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;

    [sourceImage drawInRect:thumbnailRect];

    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");

    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;

}
#pragma mark  裁剪图片代理方法
-(void)imageCropper:(NJImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        [self updateUserImageToServerWithImage:editedImage];
    }];
}

- (void)imageCropperDidCancel:(NJImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *neworiginalImage = [originalImage fixOrientation];
        //裁剪
        NJImageCropperViewController * imgEditorVC = [[NJImageCropperViewController alloc]initWithImage:neworiginalImage cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{

        }];
    }];
}

/**
 *  上传图片
 *
 *  @param originalImage 原始图片
 */
- (void)updateUserImageToServerWithImage:(UIImage *)originalImage{

    UIImage *newImage = [ZTEUserProfileTools imageWithImageSimple:originalImage scaledToSize:CGSizeMake(150, 150)];
    
    NSString *fileName = [NSString stringWithFormat:@"%@%@",[ZTEUserProfileTools generateUuidString],@".che"];
    
    NSString *imageFilePath  = [ZTEUserProfileTools saveImage:newImage WithName:fileName];
    
    NSMutableDictionary * dir=[NSMutableDictionary dictionary];
    
    [dir setValue:[[ConfigManager sharedInstance].userDictionary objectForKey:@"token"] forKey:@"token"];
    NSString *apiPrefix = [NSString stringWithFormat:@"%@",ApiPrefix];
    NSRange suffixRange = [apiPrefix rangeOfString:@"zteim4ios"];
    NSString *apiUse = [apiPrefix substringWithRange:NSMakeRange(0, suffixRange.location)];
    NSString *newURL = [NSString stringWithFormat:@"%@interface/genericUploadFile.aspx",apiUse];
//    NSString *newURL = @"http://123.58.34.116:9000/interface/genericUploadFile.aspx";

    [ZTEUserProfileTools postRequestWithURL:newURL postParems:dir picFilePath:imageFilePath picFileName:fileName];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //[picker dismissViewControllerAnimated:YES completion:NULL];
    [picker popViewControllerAnimated:YES];
}



@end
