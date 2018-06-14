//
//  ZTEUserProfileTools.m
//  IM
//
//  Created by 周永 on 15/11/9.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "ZTEUserProfileTools.h"
#import "RegexKitLite.h"
#import "ChatViewController.h"

@interface ZTEUserProfileTools()<UITextViewDelegate>
@end

@implementation ZTEUserProfileTools


+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    BOOL isMatch = [mobileNum isMatchedByRegex:phoneRegex];
    return isMatch;
}

+ (BOOL)isEmailAddress:(NSString *)string
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

+ (BOOL)isHomeNumber:(NSString *)mobileNum
{
    //判断是否是座机号码的正则
    NSString * regexp = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    NSString * regexp= @"^(0[0-9]{2,3}\\-)?([2-9][0-9]{6,7})+(\\-[0-9]{1,4})?$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexp];
    
    if ([regextestmobile evaluateWithObject:mobileNum])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//无区号
+ (BOOL)isHomeNumberWithoutPrefix:(NSString *)mobileNum{
    
    //判断是否是座机号码的正则
    NSString * regexp= @"^(0[0-9]{2,3}\\-)?([2-9][0-9]{6,7})+(\\-[0-9]{1,4})?$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexp];
    
    if ([regextestmobile evaluateWithObject:mobileNum])
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}


- (void)updateUserInfo:(id)newInfo withInfoType:(ZTEProfileDetailType)infoType userInfoDict:(NSMutableDictionary *)userInfoDict viewcontroller:(UIViewController*)vc{
    
    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"info_saving") isDismissLater:YES];
    
    NSString *infoTypeKey;
    NSString *otherTypeKey;
    
    switch (infoType) {
        case ZTEProfileDetailTypeHeader: {
            
            break;
        }
        case ZTEProfileDetailTypeName: {
            
            break;
        }
        case ZTEProfileDetailTypeQRcode: {
            
            break;
        }
        case ZTEProfileDetailTypeGender: {
            infoTypeKey = (NSString*)kZTEPersonalProfileSex;
            break;
        }
        case ZTEProfileDetailTypeSignature: {
            infoTypeKey = (NSString*)kZTEPersonalProfileSignature;
            break;
        }
        case ZTEProfileDetailTypeLocation: {
            infoTypeKey = (NSString*)kZTEPersonalProfileAddress;
            break;
        }
        case ZTEProfileDetailTypeEmail: {
            infoTypeKey = (NSString*)kZTEPersonalProfileEmail;
            otherTypeKey = (NSString*)kZTEPersonalProfileOtherEmail;
            break;
        }
        case ZTEProfileDetailTypeTelephone: {
            infoTypeKey = (NSString*)kZTEPersonalProfileTelephone;
            otherTypeKey = (NSString*)kZTEPersonalProfileOtherTelephone;
            break;
        }
        case ZTEProfileDetailTypeMobile: {
            infoTypeKey = (NSString*)kZTEPersonalProfileMobile;
            otherTypeKey = (NSString*)kZTEPersonalProfileOtherMobile;
            break;
        }
        default: {
            break;
        }
    }
    NSString *defaults;
    NSString *others;
    NSDictionary *pDic;
    
    if (infoType == ZTEProfileDetailTypeTelephone || infoType == ZTEProfileDetailTypeEmail || infoType == ZTEProfileDetailTypeMobile) {
        NSString *commitString = (NSString*)newInfo;
        NSMutableArray *mobileArray = [NSMutableArray arrayWithArray:[commitString componentsSeparatedByString:@","]];
        defaults = mobileArray[0];
        [mobileArray removeObjectAtIndex:0];
        others = [mobileArray componentsJoinedByString:@","];
        
        pDic = @{
                 infoTypeKey:defaults,
                 otherTypeKey:others,
                 @"token":[userInfoDict objectForKey:@"token"]
                 };
    }else{
        pDic = [NSDictionary dictionaryWithObjectsAndKeys:newInfo,infoTypeKey,[userInfoDict objectForKey:@"token"],@"token", nil];
    }
    
    
    [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodUpdateUser] parameters:pDic successBlock:^(BOOL success, id data, NSString *msg) {
        
        
        
        if (data) {
            
            
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dic = (NSDictionary *)data;
                NSDictionary * resDic = [dic objectForKey:@"res"];
                //reCode返回1 表示成功
                if ([resDic objectForKey:@"reCode"] && [[resDic objectForKey:@"reCode"]intValue]==1 ) {
                    //改变用户信息字典
                    if (infoType == ZTEProfileDetailTypeTelephone || infoType == ZTEProfileDetailTypeEmail || infoType == ZTEProfileDetailTypeMobile) {
                        
                        [userInfoDict setValue:defaults forKey:infoTypeKey];
                        [userInfoDict setValue:others forKey:otherTypeKey];
                        
                    }else{
                        [userInfoDict setValue:newInfo forKey:infoTypeKey];
                    }
                    //重新赋值用户字典--提交修改
                    [ConfigManager sharedInstance].userDictionary = userInfoDict;
                    
                    [MMProgressHUD showHUDWithTitle:[NSString stringWithFormat:@"%@",LOCALIZATION(@"info_updated")] isDismissLater:YES];
                    
                    //发送一个信息改变消息 reload数据
                    
                    [vc.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:ZTEUserInfoUpdatedNotification object:nil];
                }
            }
            else{
                
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"formatter_error") isDismissLater:YES];
            }
        }
        else{
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"info_exsited") isDismissLater:YES];
        }
    } failureBlock:^(NSString *description) {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"network_failed") isDismissLater:YES];
        return;
    }];
    
    
}

+ (instancetype)sharedTools{
    
    static ZTEUserProfileTools *sharedTools = nil;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        sharedTools = [[self alloc] init];
        
    });
    
    return sharedTools;
}


static NSString * const FORM_FLE_INPUT = @"file";

+ (void)postRequestWithURL: (NSString *)url  // IN
                      postParems: (NSMutableDictionary *)postParems // IN
                     picFilePath: (NSString *)picFilePath  // IN
                     picFileName: (NSString *)picFileName;  // IN
{
    
    
    NSString *TWITTERFON_FORM_BOUNDARY = @"0xKhTmLbOuNdArY";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data
    NSData* data;
    if(picFilePath){
        
        UIImage *image=[UIImage imageWithContentsOfFile:picFilePath];
        //判断图片是不是png格式的文件
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            data = UIImagePNGRepresentation(image);
        }else {
            //返回为JPEG图像。
            data = UIImageJPEGRepresentation(image, 1.0);
        }
    }
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [postParems allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[postParems objectForKey:key]];
        
    }
    
    if(picFilePath){
        ////添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        
        //声明pic字段，文件名为boris.png
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",FORM_FLE_INPUT,picFileName];
        //声明上传文件的格式
        [body appendFormat:@"Content-Type: image/jpge,image/gif, image/jpeg, image/pjpeg, image/pjpeg\r\n\r\n"];
    }
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    if(picFilePath){
        //将image的data加入
        [myRequestData appendData:data];
        
    }
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];

    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    __block NSString *fielURL;
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseData =[operation.responseString objectFromJSONString];
        if ([responseData isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *res =[responseData objectForKey:@"res"];
            if (res){
                //
                if ([res objectForKey:@"reCode"] && [[res objectForKey:@"reCode"]intValue]==1 ) {
                    
                    fielURL = [responseData objectForKey:@"fileUrl"];
                    //刷新ui
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"EnterpriseUserCardViewController_AmendHeaderPicSuccess") isDismissLater:YES];
                        
                        NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionaryWithDictionary:[ConfigManager sharedInstance].userDictionary];
                        [userInfoDict setObject:fielURL forKey:kZTEPersonalProfileHeadImageURL];
                        
                        [ConfigManager sharedInstance].userDictionary =userInfoDict;
                        
                        
                        //刷新工作台头像
                        [[NSNotificationCenter defaultCenter] postNotificationName:ZTEUserHeaderImageUpdatedNotification object:nil];
                        
                    });
                    
                }else if([res objectForKey:@"resCode"] && [[res objectForKey:@"resCode"]intValue]==1 ) {
                    
                }
                else if ([res objectForKey:@"reCode"] && [[res objectForKey:@"reCode"]intValue]==-6)
                {
                }
                else{
                    if ([res objectForKey:@"resMessage"]) {
                        
                    }else{
                        
                    }
                    
                }
            }else{
                
                
            }
            
        }
        
        [operation cancel];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"upload_failed") isDismissLater:YES];
        
    }];
    
    [operation start];
}
+(void)postRequestWithURL:(NSString *)url postParems:(NSMutableDictionary *)postParems picFilePath:(NSString *)picFilePath picFileName:(NSString *)picFileName withComplete:(void (^)(NSDictionary *))block failureBlock:(void (^)(NSString* description))failureBlock
{
    NSString *TWITTERFON_FORM_BOUNDARY = @"0xKhTmLbOuNdArY";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data
    NSData* data;
    if(picFilePath&&[picFileName hasSuffix:@"png"]){
        
        UIImage *image = [UIImage imageWithContentsOfFile:picFilePath];
        //判断图片是不是png格式的文件
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            data = UIImagePNGRepresentation(image);
        }else {
            //返回为JPEG图像。
            data = UIImageJPEGRepresentation(image, 1.0);
        }
    }
    else
    {
        data=[NSData dataWithContentsOfFile:picFilePath];
    }
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [postParems allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[postParems objectForKey:key]];
        
    }
    
    if(picFilePath){
        ////添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //声明pic字段，文件名为boris.png
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",FORM_FLE_INPUT,picFileName];
        if([picFileName hasSuffix:@"png"])
        {
            //声明上传文件的格式
            [body appendFormat:@"Content-Type: image/jpge,image/gif, image/jpeg, image/pjpeg, image/pjpeg\r\n\r\n"];
        }
        else
        {
            //声明上传文件的格式
            [body appendFormat:@"Content-Type: video/wave\r\n\r\n"];
        }
        
    }
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    if(picFilePath){
        //将image的data加入
        [myRequestData appendData:data];
        
    }
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];

    AFHTTPRequestOperation *opertaion = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [opertaion setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *requestTmp = [NSString stringWithString:operation.responseString];
        NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
        //系统自带JSON解析
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
        block(resultDic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [operation cancel];
        failureBlock(error.localizedDescription);
    }];
    [opertaion start];
}

/**
 * 修发图片大小
 */
+ (UIImage *) imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize) newSize{
    newSize.height = image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}

/**
 * 保存图片
 */
+ (NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName{
    NSData* imageData;
    
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(tempImage)) {
        //返回为png图像。
        imageData = UIImagePNGRepresentation(tempImage);
    }else {
        //返回为JPEG图像。
        imageData = UIImageJPEGRepresentation(tempImage, 1.0);
    }
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    //NSArray *nameAry=[fullPathToFile componentsSeparatedByString:@"/"];

    [imageData writeToFile:fullPathToFile atomically:NO];
    return fullPathToFile;
}

/**
 * 生成GUID
 */
+ (NSString *)generateUuidString{
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    
    // transfer ownership of the string
    // to the autorelease pool
//    [uuidString autorelease];
    
    // release the UUID
    CFRelease(uuid);
    
    return uuidString;
}





+ (void)postRuquestWithURL:(NSString*)url postParems:(NSMutableDictionary*)postParems requestMethod:(NSString*)method{
    
    
    [HTTPClient asynchronousPostRequest:url method:method parameters:postParems successBlock:^(BOOL success, id data, NSString *msg) {
        
        if (data) {
            
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dic = (NSDictionary *)data;
                NSDictionary * resDic = [dic objectForKey:@"res"];
                //reCode返回1 表示成功
                if ([resDic objectForKey:@"reCode"] && [[resDic objectForKey:@"reCode"]intValue]==1 ) {
                    
                    [MMProgressHUD showHUDWithTitle:[NSString stringWithFormat:@"信息获取成功"] isDismissLater:YES];

                    
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
        
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"salary_data_failed") isDismissLater:YES];
        
        
    }];
    
}


/**
 上传文件
 */
+ (void)uploadFileWithURL: (NSString *)url  // IN
               postParems: (NSMutableDictionary *)postParems // IN
                 FilePath: (NSString *)filePath  // IN
                 FileName: (NSString *)fileName  // IN
                    Asset: (ALAsset*)asset
                  message: (MMessage*)message
{
    
    NSString *TWITTERFON_FORM_BOUNDARY = @"0xKhTmLbOuNdArY";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data
    NSData* data;
    
    if(filePath&&[fileName hasSuffix:@"jpg"]){
        UIImage *image;
        UIImage *newImg;
        //系统相册路径获取image
        if ([filePath hasPrefix:@"assets-library"]) {
            if (message.image) {
                 newImg = message.image;
            }
        }else{
            newImg = [UIImage imageWithContentsOfFile:filePath];
        }
        
        //压缩图片
        NSData *imgData = UIImageJPEGRepresentation(newImg, 0.4);
        image = [[UIImage imageWithData:imgData] fixOrientation];
        
        
        //判断图片是不是png格式的文件
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            data = UIImagePNGRepresentation(image);
        }else {
            //返回为JPEG图像。
            data = UIImageJPEGRepresentation(image, 1.0);
        }
    }
    else
    {//视频
    
        data=[NSData dataWithContentsOfFile:filePath];
        
    }
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [postParems allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[postParems objectForKey:key]];
        
//        NSLog(@"添加字段的值==%@",[postParems objectForKey:key]);
    }
    
    if(filePath){
        ////添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        
        //声明pic字段，文件名为boris.png
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",FORM_FLE_INPUT,fileName];
        //声明上传文件的格式
        [body appendFormat:@"Content-Type: video/quicktime,video/x-sgi-movie,image/jpge,image/gif, image/jpeg, image/pjpeg, image/pjpeg\r\n\r\n"];
    }
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    if(fileName){
        //将image的data加入
        [myRequestData appendData:data];
        
    }
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    request.timeoutInterval = 10.0;
    
    __block NSString *fielURL;
    __block MMessage *blockMsg = message;
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseData =[operation.responseString objectFromJSONString];
        if ([responseData isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *res =[responseData objectForKey:@"res"];
            if (res){
                //
                if ([res objectForKey:@"reCode"] && [[res objectForKey:@"reCode"]intValue]==1 ) {
                    
                    fielURL = [responseData objectForKey:@"fileUrl"];
//                    blockMsg.image = nil;
                    [[NSNotificationCenter defaultCenter] postNotificationName:ZTEFileUplodedNotification object:blockMsg userInfo:responseData];
                    
                }else if([res objectForKey:@"resCode"] && [[res objectForKey:@"resCode"]intValue]==1 ) {
                    
//                    NSLog(@"%@",responseData);
                }
                else if ([res objectForKey:@"reCode"] && [[res objectForKey:@"reCode"]intValue]==-6)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MMProgressHUD showHUDWithTitle:[res objectForKey:@"resMessage"] isDismissLater:YES];
                    });
                }
                else if ([res objectForKey:@"reCode"] && [[res objectForKey:@"reCode"] intValue] == -5){//token过期
                    [[ZTEUserProfileTools sharedTools] logOut];
                    [MMProgressHUD showHUDWithTitle:@"Token失效，请重新登陆!" isDismissLater:YES];
                }
                else{
                    if ([res objectForKey:@"resMessage"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MMProgressHUD showHUDWithTitle:[res objectForKey:@"resMessage"] isDismissLater:YES];
                        });
                    }else{

                    }
                    
                }
            }else{
                
                
            }
            
        }
        [operation cancel];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        //如果没有上传更改 更新数据库发送状态
        [[SQLiteManager sharedInstance] updateMessageSendStateByMsgId:blockMsg.msgId sendState:MMessageSRStateSendFailed  notificationName:NOTIFICATION_U_SQL_MESSAGE_SENDSTATE];
        
    }];
    
    [operation start];
}


+ (NSString*)getUploadFileApiUrl{
    
    NSString *apiPrefix = [NSString stringWithFormat:@"%@",ApiPrefix];
    NSRange suffixRange = [apiPrefix rangeOfString:@"zteim4ios"];
    NSString *apiUse = [apiPrefix substringWithRange:NSMakeRange(0, suffixRange.location)];
    NSString *newURL = [NSString stringWithFormat:@"%@interface/genericUploadFile.aspx",apiUse];
    return newURL;
}

/**
 *  上传带图片的内容，允许多张图片上传（URL）POST
 *
 *  @param url                 网络请求地址
 *  @param images              要上传的图片数组（注意数组内容需是图片）
 *  @param parameter           图片数组对应的参数
 *  @param parameters          其他参数字典
 *  @param ratio               图片的压缩比例（0.0~1.0之间）
 *  @param succeedBlock        成功的回调
 *  @param failedBlock         失败的回调
 *  @param uploadProgressBlock 上传进度的回调
 */

//实现：
+(void)startMultiPartUploadTaskWithURL:(NSString *)url
                           imagesArray:(NSArray *)images
                     parameterOfimages:(NSString *)parameter
                        parametersDict:(NSDictionary *)parameters
                      compressionRatio:(float)ratio
                          succeedBlock:(void(^)(id operation, id responseObject))succeedBlock
                           failedBlock:(void(^)(id operation, NSError *error))failedBlock
                   uploadProgressBlock:(void(^)(float uploadPercent,long long totalBytesWritten,long long totalBytesExpectedToWrite))uploadProgressBlock{
    
    
    if (images.count == 0) {
        NSLog(@"上传内容没有包含图片");
        return;
    }
    for (int i = 0; i < images.count; i++) {
        if (![images isKindOfClass:[UIImage class]]) {
            NSLog(@"images中第%d个元素不是UIImage对象",i+1);
            return;
        }
    }
    AFHTTPRequestOperationManager *manager =  [[AFHTTPRequestOperationManager alloc] init];
    AFHTTPRequestOperation *operation = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        int i = 0;
        //根据当前系统时间生成图片名称
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [formatter stringFromDate:date];
        
        for (UIImage *image in images) {
            NSString *fileName = [NSString stringWithFormat:@"%@%d.png",dateString,i];
            NSData *imageData;
            if (ratio > 0.0f && ratio < 1.0f) {
                imageData = UIImageJPEGRepresentation(image, ratio);
            }else{
                imageData = UIImageJPEGRepresentation(image, 1.0f);
            }
            
            [formData appendPartWithFileData:imageData name:parameter fileName:fileName mimeType:@"image/jpg/png/jpeg"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        succeedBlock(operation,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        failedBlock(operation,error);
        
    }];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        CGFloat percent = totalBytesWritten * 1.0 / totalBytesExpectedToWrite;
        uploadProgressBlock(percent,totalBytesWritten,totalBytesExpectedToWrite);
    }];
    
}
//退出登录
- (void)logOut{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"test" object:nil];
    [NotiCenter postNotificationName:@"LogOut" object:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SQLiteManager sharedInstance] clearTableWithNames:[NSArray arrayWithObjects:@"tbl_company",@"tbl_dept",@"tbl_user",@"tbl_group", @"tbl_groupuser",nil]];
        NSMutableDictionary *loginDictionary =[NSMutableDictionary dictionaryWithDictionary:[ConfigManager sharedInstance].loginDictionary];
        if (loginDictionary && loginDictionary.count>0) {
            [loginDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"isAutoLogin"];
            [ConfigManager sharedInstance].loginDictionary =loginDictionary;
        }else{
            [ConfigManager sharedInstance].loginDictionary =[NSDictionary dictionary];
        }
        
        [[ConfigManager sharedInstance] clearALLConfig];
        [UserDefault removeObjectForKey:@"LPsw"];
        [UserDefault removeObjectForKey:@"TOKEN"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[MQTTManager sharedInstance].mqttClient stopNetworkEventLoop];
            [[MQTTManager sharedInstance].mqttClient disconnect];
            [MQTTManager sharedInstance].mqttClient = nil;
            [[DeviceDelegateHelper ShareInstance] disConnectVoip];
            
            
            
            [((AppDelegate *)[UIApplication sharedApplication].delegate) gotoLoginController];
        });
    });
    
}

//检查更新
- (void)checkUpdateWithSatus:(UpdateStatus)status
{
    if (status == UpdateStatusSetting) {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"checking") isDismissLater:NO];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
        [parameters setObject:@"ios" forKey:@"client_type"];
        [parameters setObject:[NSString stringWithFormat:@"%d",[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]integerValue]]  forKey:@"version"];
        [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodSoftUpdate] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
            NSLog(@"%@",msg);
            if(success && [data isKindOfClass:[NSDictionary class]]){
                
                NSString *tipMsg = @"";
                if(data[@"software"])
                {
                    
                    NSInteger version = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]integerValue];
                    
                    
                    NSDictionary *dic = data[@"software"];
                    
                    if (version == [dic[@"version"] integerValue] && status == UpdateStatusSetting) {
                        
                        [MMProgressHUD showHUDWithTitle:@"您已经是最新版本!" isDismissLater:YES];
                        
                        return ;
                        
                    }
                    
                    [UserDefault setObject:@(1) forKey:@"newVersion"];
                    
                    BOOL forceUpdate = [dic[@"forceUpdate"] intValue] == 1?YES:NO;
                    
                    NSString *downloadUrl = dic[@"update_url"];
                    NSString *updateLog = dic[@"updateLog"];
                    
                    CGFloat height = [updateLog boundingRectWithSize:CGSizeMake(280, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil].size.height;
                    
                    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 280, height + 20)];
                    textView.font = [UIFont systemFontOfSize:15.0];
                    textView.editable = NO;
                    textView.text = updateLog;
                    textView.dataDetectorTypes = UIDataDetectorTypeLink;
                    textView.delegate = self;
                    CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"检测到版本更新" contentView:textView cancelButtonTitle:@"取消"];
                    [alertView addButtonWithTitle:@"立即更新" type:CXAlertViewButtonTypeDefault handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                        
                         [[DeviceDelegateHelper ShareInstance] disConnectVoip];
                        NSURL *url = [NSURL URLWithString:downloadUrl];
                        [[UIApplication sharedApplication] openURL:url];
                        
                    }];
                    
                    [alertView show];
                    
                    if(forceUpdate)
                    {
                        alertView.tag = ForceUpdateTag;
                    }
                    [MMProgressHUD dismiss];
                }
                else
                {
                    if (status == UpdateStatusSetting) {
                        [UserDefault setObject:@(0) forKey:@"newVersion"];
                        tipMsg = @"no_update";
                        [MMProgressHUD showHUDWithTitle:LOCALIZATION(tipMsg) isDismissLater:YES];
                    }
                }
            }else{
                

                if ([data isKindOfClass:[NSDictionary class] ]) {
                    
                    if ([data objectForKey:@"reCode"] && [[data objectForKey:@"reCode"] intValue] == -5){//token过期
                        [[ZTEUserProfileTools sharedTools] logOut];
                        [MMProgressHUD showHUDWithTitle:@"Token失效，请重新登陆!" isDismissLater:YES];
                        [UserDefault setObject:@(0) forKey:@"newVersion"];
                        return;
                    }
                }
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == UpdateStatusSetting) {
                        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"failed_checkout") isDismissLater:YES];
                    }
                    
                });
            }
        } failureBlock:^(NSString *description) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == UpdateStatusSetting) {
                    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"network_failed") isDismissLater:YES];
                }
                
            });
        }];
    });
}


- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    
    return YES;
    
}



@end















