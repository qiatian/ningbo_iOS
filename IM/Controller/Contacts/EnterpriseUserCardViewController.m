//
//  EnterpriseUserCardViewController.m
//  IM
//
//  Created by zuo guoqing on 14-10-11.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import "EnterpriseUserCardViewController.h"
#import "VoipViewController.h"
#import "RegexKitLite.h"

@interface EnterpriseUserCardViewController ()
{
    NSString *nowClickMobileNumber;
    UILabel *labUserName;
    UILabel *labUserNumber;//工号
   // UILabel *labUserCompany;//公司  部门  职位
    UILabel *labUserBrief;//签名
//    UIButton *setLabUserBrief;//签名按钮
    UIView *headerView;
    UIView *headerViewBottomLine;
    UIButton *collectButton;//常用联系人按钮
}

@property(nonatomic,strong)UILabel *avatarLabel;

@end

@implementation EnterpriseUserCardViewController

@synthesize viewWidth,userIdStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        viewWidth = boundsWidth;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ILBarButtonItem *leftItem =[ILBarButtonItem barItemWithBackItem:LOCALIZATION(@"EnterpriseUserCardViewController_Contact") target:self action:@selector(clickedLeftItem:)];
    self.navigationItem.leftBarButtonItem =leftItem;
    self.navigationItem.title =LOCALIZATION(@"EnterpriseUserCardViewController_NavTitle");
    
    if(userIdStr)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *myGId=[[ConfigManager sharedInstance].userDictionary objectForKey:@"gid"];
            self.user = [[[SQLiteManager sharedInstance] getAllUserByGid:myGId] objectForKey:userIdStr];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self configureUserInfoHeaderView];
                [self setUpViewConfigures];
            });
        });
        
    }
    else
    {
        [self configureUserInfoHeaderView];
        [self setUpViewConfigures];
    }
    
}

-(void)setUpViewConfigures
{
    self.tbView.tableFooterView =[[UIView alloc] init];
    self.nibEnterpriseUserCard =[UINib nibWithNibName:@"GQEnterpriseUserCardCell" bundle:[NSBundle mainBundle]];
    
    NSMutableArray *userData =[[NSMutableArray alloc] init];
    
    if (self.user.mobile && self.user.mobile.length>0) {
        [userData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"user_telephone.png",@"title",self.user.mobile,@"subtitle", nil]];
    }
    
    if (self.user.telephone && self.user.telephone.length>0) {
        [userData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"user_home.png",@"title",self.user.telephone,@"subtitle", nil]];
    }
    
    if (self.user.fax && self.user.fax.length>0) {
        [userData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"user_fax.png",@"title",self.user.fax,@"subtitle", nil]];
    }
    if (self.user.email && self.user.email.length>0) {
        [userData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"user_email.png",@"title",self.user.email,@"subtitle", nil]];
    }
    
    self.userData =[NSMutableArray arrayWithArray:userData];
    
    
    
    
    [self reloadUserInfoView];
}

-(void)configureUserInfoHeaderView
{
    headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 150)];
    headerView.backgroundColor = [UIColor whiteColor];
//    UIImageView *avatar_bg =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 150)];
//    [avatar_bg setImage:[UIImage imageWithFileName:@"user_avatar_bg.png"]];
//    [headerView addSubview:avatar_bg];
    
    self.ivAvatar =[[GQLoadImageView alloc] initWithFrame:CGRectMake(10, 8, 60, 60)];
    self.ivAvatar.backgroundColor = [UIColor lightGrayColor];
    self.ivAvatar.layer.cornerRadius = self.ivAvatar.frame.size.width/2;
    self.ivAvatar.layer.masksToBounds = YES;
    self.ivAvatar.layer.borderColor = [UIColor hexChangeFloat:@"4869b6"].CGColor;
    self.ivAvatar.layer.borderWidth = 1.0f;
    [headerView addSubview:self.ivAvatar];
    
    self.avatarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.ivAvatar.frame.size.width, self.ivAvatar.frame.size.height)];
    self.avatarLabel.textAlignment = NSTextAlignmentCenter;
    self.avatarLabel.textColor = [UIColor whiteColor];
    self.avatarLabel.font = [UIFont systemFontOfSize:24.0];
    self.avatarLabel.backgroundColor = [UIColor clearColor];
    [self.ivAvatar addSubview:self.avatarLabel];
    
    if (self.user.bigpicurl && self.user.bigpicurl.length>0){
        [self.ivAvatar setImageWithUrl:self.user.bigpicurl placeHolder:nil];
        self.avatarLabel.text = nil;
    }
    else
    {
        if (self.user.uname && self.user.uname.length>0){
            self.avatarLabel.text = [self.user.uname substringToIndex:1];
            [self.ivAvatar setImage:[Common getImageFromColor:[UIColor colorWithRGBHex:self.user.uname.hash % 0xffffff]]];
        }
        else{
            self.avatarLabel.text = nil;
            [self.ivAvatar setImage:[Common getImageFromColor:[UIColor grayColor]]];
        }
    }
    
    UIButton *avatar_btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [avatar_btn setFrame:self.ivAvatar.frame];
    [avatar_btn addTarget:self action:@selector(clickedAvatarBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:avatar_btn];
    
    labUserName =[[UILabel alloc] initWithFrame:CGRectMake(78, 15, viewWidth-75-78-40, 20)];
    labUserName.font =[UIFont systemFontOfSize:18.0f];
    labUserName.backgroundColor = [UIColor clearColor];
    [headerView addSubview:labUserName];
    [labUserName sizeToFit];
    if(labUserName.frame.size.width>viewWidth-75-78-40)
    {
        labUserName.frame = CGRectMake(78, 15, viewWidth-75-78-40, 20);
    }
    
    NSString *identity =[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"];
    if ([identity longLongValue]!=[_user.uid longLongValue]) {
        //自己不能加自己为常用联系人
        collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        collectButton.frame = CGRectMake(viewWidth-30-20, labUserName.frame.origin.y-10, 40, 40);
        [collectButton setImage:[UIImage imageNamed:@"contact_start.png"] forState:UIControlStateNormal];
        [collectButton setImage:[UIImage imageNamed:@"contact_start_on.png"] forState:UIControlStateSelected];
        [collectButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [collectButton addTarget:self action:@selector(collectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:collectButton];
    }
    
    labUserNumber = [[UILabel alloc] initWithFrame:CGRectMake(labUserName.frame.size.width+labUserName.frame.origin.x+5, labUserName.frame.size.height+labUserName.frame.origin.y-12, 75, 12)];
    labUserNumber.font =[UIFont boldSystemFontOfSize:10.0f];
    labUserNumber.textColor =[UIColor hexChangeFloat:@"9b9b9b"];
    labUserNumber.backgroundColor = [UIColor clearColor];
    [headerView addSubview:labUserNumber];

//    labUserCompany =[[UILabel alloc] initWithFrame:CGRectMake(labUserName.frame.origin.x, labUserName.frame.size.height+labUserName.frame.origin.y+12, viewWidth-labUserName.frame.origin.x-10, 16)];
//    labUserCompany.font = [UIFont boldSystemFontOfSize:14.0f];
//    labUserCompany.backgroundColor = [UIColor clearColor];
//    labUserCompany.textColor =[UIColor hexChangeFloat:@"9b9b9b"];
//    [headerView addSubview:labUserCompany];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.ivAvatar.frame.origin.x, self.ivAvatar.frame.origin.y+self.ivAvatar.frame.size.height+8, viewWidth-self.ivAvatar.frame.origin.x, 0.5)];
    lineView.backgroundColor = [UIColor hexChangeFloat:@"dddddd"];
    [headerView addSubview:lineView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.ivAvatar.frame.origin.x, lineView.frame.origin.y+lineView.frame.size.height+6, 20, 20)];
    view.backgroundColor = [UIColor hexChangeFloat:@"c6c6c6"];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 10;
    [headerView addSubview:view];
    
    labUserBrief =[[UILabel alloc] initWithFrame:CGRectMake(self.ivAvatar.frame.origin.x, lineView.frame.origin.y+8, viewWidth-2*self.ivAvatar.frame.origin.x, 20)];
    labUserBrief.font =[UIFont systemFontOfSize:14.0f];
    labUserBrief.backgroundColor = [UIColor clearColor];
    labUserBrief.lineBreakMode = NSLineBreakByWordWrapping;
    labUserBrief.numberOfLines = 2;
    [headerView addSubview:labUserBrief];
    
//    setLabUserBrief = [UIButton buttonWithType:UIButtonTypeCustom];
//    setLabUserBrief.frame = labUserBrief.frame;
//    [setLabUserBrief addTarget:self action:@selector(setUserBrief:) forControlEvents:UIControlEventTouchUpInside];
//    [headerView addSubview:setLabUserBrief];

    headerView.frame = CGRectMake(0, 0, viewWidth, labUserBrief.frame.size.height+labUserBrief.frame.origin.y+8);
    headerViewBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0,headerView.frame.size.height-0.5 ,boundsWidth,0.5)];
    headerViewBottomLine.backgroundColor = [UIColor hexChangeFloat:@"dddddd"];
    [headerView addSubview:headerViewBottomLine];
}

-(void)clickedLeftItem:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUserWithUserId
{
    
}

#pragma mark OCUCMailCellDelegate
-(void)sendEmailWithEmails:(NSArray*)emails
{
    if ([MFMailComposeViewController canSendMail]) {
        self.mailComposeViewController =[[MFMailComposeViewController alloc] init];
        self.mailComposeViewController.mailComposeDelegate=self;
        [self.mailComposeViewController setSubject:@""];                                               //邮件主题
        [self.mailComposeViewController setToRecipients:emails];                                        //收件人
        [self.mailComposeViewController setCcRecipients:[NSArray array]];                              //抄送
        [self.mailComposeViewController setBccRecipients:[NSArray array]];                             //密送
        [self.mailComposeViewController setMessageBody:@"" isHTML:NO];                                 //邮件内容
        //self.mailCompose =self.mailComposeViewController;
        [self presentViewController:self.mailComposeViewController animated:YES completion:nil];
    }
    else
    {
        CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"" message:LOCALIZATION(@"EnterpriseUserCardViewController_NOMail") cancelButtonTitle:LOCALIZATION(@"EnterpriseUserCardViewController_Confirm")];
        alertView.showBlurBackground = YES;
        [alertView show];
        
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
        {
            
        }
            break;
        case MFMailComposeResultFailed:
        {
            CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"" message:LOCALIZATION(@"EnterpriseUserCardViewController_NOSuportMail") cancelButtonTitle:LOCALIZATION(@"EnterpriseUserCardViewController_Confirm")];
            alertView.showBlurBackground = YES;
            [alertView show];
        }
            break;
        case MFMailComposeResultSent:
        {
            
        }
            break;
            
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark OCUCPhoneCellDelegate
-(void)sendSmsWithPhones:(NSArray*)phoneNumbers{
    
    if([MFMessageComposeViewController canSendText]){
        self.messageComposeViewController = [[MFMessageComposeViewController alloc] init];
        self.messageComposeViewController.messageComposeDelegate = self;
        [self.messageComposeViewController setRecipients:phoneNumbers];
        [self.messageComposeViewController setBody:@""];
        //self.messageCompose =self.messageComposeViewController;
        [self presentViewController:self.messageComposeViewController animated:YES completion:nil];
        
        
    }else{
        CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"" message:LOCALIZATION(@"EnterpriseUserCardViewController_NOSuportMessage") cancelButtonTitle:LOCALIZATION(@"EnterpriseUserCardViewController_Confirm")];
        alertView.showBlurBackground = YES;
        [alertView show];
    }
}


-(void)makeCallWithPhone:(NSString*)phoneNumber{
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneNumber]];
    [[UIApplication sharedApplication] openURL:url];
}



#pragma mark MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
        {
            
        }
            break;
        case MessageComposeResultFailed:
        {
            CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"sendSMSFailed", nil) cancelButtonTitle:NSLocalizedString(@"comfirm", nil)];
            alertView.showBlurBackground = YES;
            [alertView show];
        }
            break;
        case MessageComposeResultSent:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.userData count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GQEnterpriseUserCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GQEnterpriseUserCardCell"];
    if(!cell){
        cell=(GQEnterpriseUserCardCell*)[[self.nibEnterpriseUserCard instantiateWithOwner:self options:nil] objectAtIndex:0];
    }
    
    cell.data =[self.userData objectAtIndex:indexPath.row];
    return cell;

}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GQEnterpriseUserCardCell *cell = (GQEnterpriseUserCardCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *string = cell.labSubtitle.text;
    NSString *titleString = cell.labTitle.text;
    
    if ([titleString isEqualToString:LOCALIZATION(@"EnterpriseUserCardViewController_Mail")]) {
        
        if([self isEmailAddress:string])
        {
            [self sendEmailWithEmails:[NSArray arrayWithObject:string]];
        }else{
           UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:LOCALIZATION(@"EnterpriseUserCardViewController_Prompt") message:LOCALIZATION(@"EnterpriseUserCardViewController_MailFormatNO") delegate:self cancelButtonTitle:LOCALIZATION(@"EnterpriseUserCardViewController_Confirm") otherButtonTitles:nil, nil];
            [alertview show];
        }
    }
    
    if ([titleString isEqualToString:LOCALIZATION(@"EnterpriseUserCardViewController_Phone")]) {
        
//        if([self isMobileNumber:string])
//        {
            nowClickMobileNumber = string;
            self.asMobile = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:NSLocalizedString(@"呼叫联系人", nil) otherButtonTitles:NSLocalizedString(@"发送短信", nil), nil];
            [self.asMobile showInWindow:self.view.window];
//        }else{
//            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:LOCALIZATION(@"EnterpriseUserCardViewController_Prompt") message:LOCALIZATION(@"EnterpriseUserCardViewController_PhoneFormatNO") delegate:self cancelButtonTitle:LOCALIZATION(@"EnterpriseUserCardViewController_Confirm") otherButtonTitles:nil, nil];
//            [alertview show];
//        }
//
    }
    
    
    if ([titleString isEqualToString:LOCALIZATION(@"EnterpriseUserCardViewController_Mobile")]) {
        
        if([ZTEUserProfileTools isHomeNumber:string] || [ZTEUserProfileTools isHomeNumberWithoutPrefix:string])
        {
            nowClickMobileNumber = string;
            self.asHomeMobile = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:NSLocalizedString(@"呼叫联系人", nil) otherButtonTitles:nil, nil];
            [self.asHomeMobile showInWindow:self.view.window];
        }else{
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:LOCALIZATION(@"EnterpriseUserCardViewController_Prompt") message:LOCALIZATION(@"EnterpriseUserCardViewController_MobileFormatNO") delegate:self cancelButtonTitle:LOCALIZATION(@"EnterpriseUserCardViewController_Confirm") otherButtonTitles:nil, nil];
            [alertview show];
        }
        
    }
    
    
    
//    switch (indexPath.row) {
//        case 0:{
//            self.asMobile = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:NSLocalizedString(@"呼叫联系人", nil) otherButtonTitles:NSLocalizedString(@"发送短信", nil), nil];
//            [self.asMobile showInWindow:self.view.window];
//        }
//            break;
//        case 1:{
////            self.asTelephone = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:NSLocalizedString(@"呼叫联系人", nil) otherButtonTitles:NSLocalizedString(@"发送短信", nil), nil];
////            [self.asTelephone showInWindow:self.view.window];
//            [self sendEmailWithEmails:[NSArray arrayWithObject:self.user.email]];
//        }
//            break;
//        case 2:{
//            [self sendEmailWithEmails:[NSArray arrayWithObject:self.user.email]];
//            
//        }
//            break;
//        case 3:{
//            
//        }
//            break;
//            
//        default:
//            break;
//    }
}


//- (BOOL)isHomeNumber:(NSString *)mobileNum
//{
//    //判断是否是座机号码的正则
//    NSString * regexp= @"^(0[0-9]{2,3}\\-)?([2-9][0-9]{6,7})+(\\-[0-9]{1,4})?$";
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexp];
//    
//    if ([regextestmobile evaluateWithObject:mobileNum])
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//}

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * phoneRegex = @"[0-9]{8,15}";
    BOOL isMatch = [mobileNum isMatchedByRegex:phoneRegex];
    return isMatch;
}

-(BOOL)isEmailAddress:(NSString *)string
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if([emailTest evaluateWithObject:string])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark IBActionSheetDelegate
-(void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (actionSheet ==self.asTelephone) {
//        if (buttonIndex==0) {
//            [self makeCallWithPhone:nowClickMobileNumber];
////            [self makeCallWithPhone:self.user.telephone];
//        }else if (buttonIndex==1){
////            [self sendSmsWithPhones:[NSArray arrayWithObject:self.user.telephone]];
//            [self sendSmsWithPhones:[NSArray arrayWithObject:nowClickMobileNumber]];
//        }
//    }else if (actionSheet ==self.asMobile){
//        if (buttonIndex==0) {
//            [self makeCallWithPhone:self.user.mobile];
//        }else if (buttonIndex==1){
//            [self sendSmsWithPhones:[NSArray arrayWithObject:self.user.mobile]];
//        }
//        
//    }
    if (actionSheet ==self.asMobile){
        if (buttonIndex==0) {
            [self makeCallWithPhone:nowClickMobileNumber];
//            [self makeCallWithPhone:self.user.mobile];
        }else if (buttonIndex==1){
            [self sendSmsWithPhones:[NSArray arrayWithObject:nowClickMobileNumber]];
//            [self sendSmsWithPhones:[NSArray arrayWithObject:self.user.mobile]];
        }
    }
    else if(actionSheet ==self.asHomeMobile){
        [self makeCallWithPhone:nowClickMobileNumber];
    }
    else if(actionSheet ==self.asAvatar){
        if (buttonIndex==0) {
            NSLog(@"拍照按钮点击");
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
                CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:LOCALIZATION(@"EnterpriseUserCardViewController_DeviceNOSuportLookPic") message:@"" cancelButtonTitle:LOCALIZATION(@"EnterpriseUserCardViewController_Confirm")];
                alertView.showBlurBackground = YES;
                [alertView show];
            }
        }
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
     [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"EnterpriseUserCardViewController_UploadHeaderPic") isDismissLater:NO];
    
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
                                weakSelf.user.bigpicurl =bigpicurl;
                                
                                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"EnterpriseUserCardViewController_UploadHeaderPicSuccess") isDismissLater:YES];
                                [[SQLiteManager sharedInstance] insertUsersToSQLite:[NSArray arrayWithObject:weakSelf.user] notificationName:NOTIFICATION_R_SQL_USER];
                                
                                NSMutableDictionary *userDictionary =[NSMutableDictionary dictionaryWithDictionary:[ConfigManager sharedInstance].userDictionary];
                                [userDictionary setObject:bigpicurl forKey:@"bigpicurl"];
                                [ConfigManager sharedInstance].userDictionary =userDictionary;
                                
                                [weakSelf.ivAvatar setImage:thumbImage];
                                [picker dismissViewControllerAnimated:YES completion:NULL];
                            
                            });
                        } failureBlock:^(NSString *description) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"EnterpriseUserCardViewController_AmendHeaderPicFail") isDismissLater:YES];
                                [picker dismissViewControllerAnimated:YES completion:NULL];
                                
                            });
                            
                        }];
                    }
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"EnterpriseUserCardViewController_AmendHeaderPicFail") isDismissLater:YES];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 按钮事件
-(void)setUserBrief:(UIButton *)sender
{
    NSString *uid =[NSString stringWithFormat:@"%lld",[[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"] longLongValue]];
    if ([self.user.uid isEqualToString:uid]) {
        NSLog(@"yourself brief setting");
    }
    else{
        NSLog(@"other brief setting");
    }
}

-(void)clickedAvatarBtn:(id)sender {
    NSString *uid =[NSString stringWithFormat:@"%lld",[[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"] longLongValue]];
    if ([[NSString stringWithFormat:@"%@",self.user.uid] isEqualToString:uid]) {
        self.asAvatar = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:NSLocalizedString(@"拍照", nil) otherButtonTitles:NSLocalizedString(@"从相册选择", nil), nil];
        [self.asAvatar showInWindow:self.view.window];
    }
    
}

- (IBAction)clickedVoiceBtn:(id)sender {
    VoipViewController *vc = [[VoipViewController alloc] init];
    vc.callType = 0;
    vc.voipType = VOICE;
    vc.callUser = self.user;
    vc.view.alpha = 0.1;
    GQNavigationController *audioCallNav =[[GQNavigationController alloc] initWithRootViewController:vc];
    audioCallNav.view.backgroundColor = [UIColor clearColor];
    [self presentViewController:audioCallNav animated:NO completion:^{
        [UIView animateWithDuration:0.6 animations:^{
            vc.view.alpha = 1;
        }];
    }];
}

- (IBAction)clickedVideoBtn:(id)sender {
    NSLog(@"视频聊天按钮点击");
    VoipViewController *vc = [[VoipViewController alloc] init];
    vc.callType = 0;
    vc.voipType = VIDEO;
    vc.callUser = self.user;
    vc.view.alpha = 0.1;
    GQNavigationController *audioCallNav =[[GQNavigationController alloc] initWithRootViewController:vc];
    audioCallNav.view.backgroundColor = [UIColor clearColor];
    [self presentViewController:audioCallNav animated:NO completion:^{
        [UIView animateWithDuration:0.6 animations:^{
            vc.view.alpha = 1;
        }];
    }];

}

- (IBAction)clickedChatBtn:(id)sender {
    NSLog(@"消息聊天按钮点击");
    ChatViewController *chatVC =[[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:[NSBundle mainBundle]];
//    chatVC.hidesBottomBarWhenPushed = YES;
    chatVC.chatUser =self.user;
    chatVC.isGroup =NO;
    [self.navigationController pushViewController:chatVC animated:YES];
}

-(void)reloadUserInfoView
{
    NSString *identity =[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"];
    if ([identity longLongValue]!=[_user.uid longLongValue]&&self.btnChat==nil) {
        //自己不能跟自己操作
        self.btnVoice = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnVideo = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnChat = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.btnVoice.layer.masksToBounds = YES;
        self.btnVoice.layer.cornerRadius = 8;
        self.btnVideo.layer.masksToBounds = YES;
        self.btnVideo.layer.cornerRadius = 8;
        self.btnChat.layer.masksToBounds = YES;
        self.btnChat.layer.cornerRadius = 8;
        
        [self.btnVoice setBackgroundImage:[Common getImageFromColor:[UIColor colorWithRGBHex:0xffffff]] forState:UIControlStateNormal];
        [self.btnVoice setTitle:LOCALIZATION(@"EnterpriseUserCardViewController_SendVoice") forState:UIControlStateNormal];
        [self.btnVoice setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.btnVoice addTarget:self action:@selector(clickedVoiceBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btnVideo setBackgroundImage:[Common getImageFromColor:[UIColor colorWithRGBHex:0xeccd35]] forState:UIControlStateNormal];
        [self.btnVideo setTitle:@"视频聊天" forState:UIControlStateNormal];
        [self.btnVideo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnVideo addTarget:self action:@selector(clickedVideoBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btnChat setBackgroundImage:[Common getImageFromColor:[UIColor colorWithRGBHex:0x4a97df]] forState:UIControlStateNormal];
        [self.btnChat setTitle:LOCALIZATION(@"EnterpriseUserCardViewController_SendMessage") forState:UIControlStateNormal];
        [self.btnChat setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnChat addTarget:self action:@selector(clickedChatBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.btnVoice];
        //        [self.view addSubview:self.btnVideo];
        [self.view addSubview:self.btnChat];
        self.btnVoice.layer.borderWidth=0.5f;
        self.btnVoice.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    }
//    if(viewWidth < boundsWidth)
//    {
//        self.btnVoice.frame = CGRectMake(15, self.view.frame.size.height-110, (viewWidth-30-15)/2, 40);
//    }
//    else
//    {
//        self.btnVoice.frame = CGRectMake(15, viewWithNavNoTabbar-110, (viewWidth-30-15)/2, 40);
//    }
//    self.btnVideo.frame = CGRectMake(self.btnVoice.frame.size.width+self.btnVoice.frame.origin.x+15, self.btnVoice.frame.origin.y, self.btnVoice.frame.size.width, self.btnVoice.frame.size.height);
//    self.btnChat.frame = CGRectMake(15, self.btnVoice.frame.size.height+self.btnVoice.frame.origin.y+15, viewWidth-30, 40);
    if(viewWidth < boundsWidth)
    {
        self.btnChat.frame = CGRectMake(15, self.view.frame.size.height-110, viewWidth-30, 40);
    }
    else
    {
        self.btnChat.frame = CGRectMake(15, viewWithNavNoTabbar-110, viewWidth-30, 40);
    }
    self.btnVoice.frame = CGRectMake(15, self.btnChat.frame.size.height+self.btnChat.frame.origin.y+10, viewWidth-30, 40);

    labUserName.text =self.user.uname ;
//    labUserNumber.text =self.user.jid ;
//    labUserCompany.text = [NSString stringWithFormat:@"%@  %@  %@",self.user.gname,self.user.cname?self.user.cname:@"",self.user.post?self.user.post:@""];
   // labUserCompany.text=[NSString stringWithFormat:@"%@:%@",LOCALIZATION(@"EnterpriseUserCardViewController_IMNum"),self.user.jid];
    
    
    [labUserName sizeToFit];
    if(labUserName.frame.size.width>viewWidth-75-78-40)
    {
        labUserName.frame = CGRectMake(78, 15, viewWidth-75-78-50, 20);
    }
    collectButton.frame = CGRectMake(viewWidth-30-20, labUserName.frame.origin.y-10, 40, 40);
    labUserNumber.frame = CGRectMake(labUserName.frame.size.width+labUserName.frame.origin.x+5, labUserName.frame.size.height+labUserName.frame.origin.y-12, 75, 12);
//    labUserCompany.frame = CGRectMake(labUserName.frame.origin.x, labUserName.frame.size.height+labUserName.frame.origin.y+12, viewWidth-labUserName.frame.origin.x-10, 16);
    
    CGRect frame = labUserBrief.frame;
    frame.size.width = viewWidth-2*self.ivAvatar.frame.origin.x;
    labUserBrief.frame = frame;
    labUserBrief.text = [NSString stringWithFormat:@"  “   %@",self.user.autograph?([self.user.autograph length]?self.user.autograph:LOCALIZATION(@"EnterpriseUserCardViewController_Sign")):LOCALIZATION(@"EnterpriseUserCardViewController_Sign")];
    [labUserBrief sizeToFit];
//    setLabUserBrief.frame = labUserBrief.frame;
    
    headerView.frame = CGRectMake(0, 0, viewWidth, labUserBrief.frame.size.height+labUserBrief.frame.origin.y+8);
    headerViewBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0,headerView.frame.size.height-0.5 ,boundsWidth,0.5)];
    self.tbView.tableHeaderView = headerView;
    
    if (self.user.bigpicurl && self.user.bigpicurl.length>0){
        self.avatarLabel.text = nil;
        WEAKSELF
        [weakSelf.ivAvatar setImageWithUrl:weakSelf.user.bigpicurl placeHolder:[Common getImageFromColor:[UIColor colorWithRGBHex:weakSelf.user.uname.hash % 0xffffff]] progress:nil completed:^(UIImage *image) {
            [weakSelf.ivAvatar setImage:image];
        } failureBlock:^(NSError *error) {
            if (weakSelf.user.uname && weakSelf.user.uname.length>0) {
                weakSelf.avatarLabel.text =[weakSelf.user.uname substringToIndex:1];
            }
        }];
    }
    else
    {
        if (self.user.uname && self.user.uname.length>0){
            self.avatarLabel.text = [self.user.uname substringToIndex:1];
            [self.ivAvatar setImage:[Common getImageFromColor:[UIColor colorWithRGBHex:self.user.uname.hash % 0xffffff]]];
        }
        else{
            self.avatarLabel.text = nil;
            [self.ivAvatar setImage:[Common getImageFromColor:[UIColor grayColor]]];
        }
    }

    NSMutableArray *userData = [[NSMutableArray alloc] init];
//    if (self.user.area && self.user.area.length>0) {
        [userData addObject:[NSDictionary dictionaryWithObjectsAndKeys:LOCALIZATION(@"EnterpriseUserCardViewController_Adress"),@"title",self.user.area,@"subtitle", nil]];
//    }
    if (self.user.gname && self.user.gname.length>0) {
        [userData addObject:[NSDictionary dictionaryWithObjectsAndKeys:LOCALIZATION(@"EnterpriseUserCardViewController_Company"),@"title",self.user.gname,@"subtitle", nil]];
    }
    if (self.user.cname && self.user.cname.length>0) {
        [userData addObject:[NSDictionary dictionaryWithObjectsAndKeys:LOCALIZATION(@"EnterpriseUserCardViewController_Dept"),@"title",self.user.cname,@"subtitle", nil]];
    }
    
    if (self.user.post && self.user.post.length>0) {
        [userData addObject:[NSDictionary dictionaryWithObjectsAndKeys:LOCALIZATION(@"EnterpriseUserCardViewController_Position"),@"title",self.user.post,@"subtitle", nil]];
    }
    
    if (self.user.mobile && self.user.mobile.length>0) {
        [userData addObject:[NSDictionary dictionaryWithObjectsAndKeys:LOCALIZATION(@"EnterpriseUserCardViewController_Phone"),@"title",self.user.mobile,@"subtitle",@"user_telephone.png",@"img", nil]];
    }
    
    if (self.user.telephone && self.user.telephone.length>0) {
        [userData addObject:[NSDictionary dictionaryWithObjectsAndKeys:LOCALIZATION(@"EnterpriseUserCardViewController_Mobile"),@"title",self.user.telephone,@"subtitle",@"user_home.png",@"img", nil]];
    }
    
    if (self.user.fax && self.user.fax.length>0) {
        [userData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"user_fax.png",@"title",self.user.fax,@"subtitle",@"user_fax.png",@"img", nil]];
    }
    if (self.user.email && self.user.email.length>0) {
        [userData addObject:[NSDictionary dictionaryWithObjectsAndKeys:LOCALIZATION(@"EnterpriseUserCardViewController_Mail"),@"title",self.user.email,@"subtitle",@"user_email.png",@"img", nil]];
    }
    
    
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDefault objectForKey:@"contact_collect_user_id"];
    if(dic)
    {
        NSArray *array = [dic objectForKey:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]]];
        if(array&&[array containsObject:self.user.uid])
        {
            collectButton.selected = YES;
        }
        else
        {
            collectButton.selected = NO;
        }
    }
    else
    {
        collectButton.selected = NO;
    }
    
    self.userData =[NSMutableArray arrayWithArray:userData];
    [self.tbView reloadData];
    self.tbView.frame = CGRectMake(0, 0, viewWidth, viewWithNavNoTabbar-110);
}

-(void)collectButtonClick:(UIButton *)sender
{
//    userDefault 结构，防止登录不同的账号添加常用联系人混淆的问题
//    {
//    "1401":["111038","112844"],
//    "1402":["121048","2844"],
//    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *collectDic = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if([userDefault objectForKey:@"contact_collect_user_id"])
    {
        [collectDic setDictionary:[userDefault objectForKey:@"contact_collect_user_id"]];
        if([[userDefault objectForKey:@"contact_collect_user_id"] objectForKey:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]]])
        {
            [array setArray:[[userDefault objectForKey:@"contact_collect_user_id"] objectForKey:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]]]];
        }
    }
    sender.selected = !sender.selected;
    if(sender.selected)
    {
        [array insertObject:self.user.uid atIndex:0];
    }
    else
    {
        [array removeObject:self.user.uid];
    }
    
    [collectDic setObject:array forKey:[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]]];
    [userDefault setObject:collectDic forKey:@"contact_collect_user_id"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCollectContacts" object:nil];
    [userDefault synchronize];
}

@end
