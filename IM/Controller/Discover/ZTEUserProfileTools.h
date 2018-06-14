//
//  ZTEUserProfileTools.h
//  IM
//
//  Created by 周永 on 15/11/9.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomDefine.h"
typedef NS_ENUM(NSInteger,UpdateStatus) {

    UpdateStatusLogin = 1,//登陆的时候检测更新
    UpdateStatusSetting = 2//设置里面点击检测更新
};

@interface ZTEUserProfileTools : NSObject
/**
 *  更新用户信息
 *
 *  @param newInfo      新信息
 *  @param infoType     信息类型
 *  @param userInfoDict 用户字典  -- userdefault存储的用户信息
 *  @param vc           控制器 -- 哪个控制器提交的当前信息
 */
- (void)updateUserInfo:(id)newInfo
                  withInfoType:(ZTEProfileDetailType)infoType
                  userInfoDict:(NSMutableDictionary *)userInfoDict
                  viewcontroller:(UIViewController*)vc;



+ (instancetype)sharedTools;

+ (void)postRuquestWithURL:(NSString*)url postParems:(NSMutableDictionary*)postParems requestMethod:(NSString*)method;

/**
 *POST 提交 并可以上传图片目前只支持单张
 */
+ (void)postRequestWithURL: (NSString *)url  // IN
                      postParems: (NSMutableDictionary *)postParems // IN 提交参数据集合
                     picFilePath: (NSString *)picFilePath  // IN 上传图片路径
                     picFileName: (NSString *)picFileName;  // IN 上传图片名称


+(void)postRequestWithURL:(NSString*)url postParems:(NSMutableDictionary*)postParems picFilePath:(NSString*)picFilePath picFileName:(NSString*)picFileName withComplete:(void(^)(NSDictionary *dic))block failureBlock:(void (^)(NSString* description))failureBlock;

//上传文件
+ (void)uploadFileWithURL: (NSString *)url  // IN
               postParems: (NSMutableDictionary *)postParems // IN
                 FilePath: (NSString *)filePath  // IN
                 FileName: (NSString *)fileName  // IN
                    Asset: (ALAsset*)asset
                  message: (MMessage*)message;


+(void)startMultiPartUploadTaskWithURL:(NSString *)url
                           imagesArray:(NSArray *)images
                     parameterOfimages:(NSString *)parameter
                        parametersDict:(NSDictionary *)parameters
                      compressionRatio:(float)ratio
                          succeedBlock:(void(^)(id operation, id responseObject))succeedBlock
                           failedBlock:(void(^)(id operation, NSError *error))failedBlock
                   uploadProgressBlock:(void(^)(float uploadPercent,long long totalBytesWritten,long long totalBytesExpectedToWrite))uploadProgressBlock;

/**
 * 修发图片大小
 
 */
+ (UIImage *) imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize) newSize;
/**
 * 保存图片
 */
+ (NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;
/**
 * 生成GUID
 */
+ (NSString *)generateUuidString;

+(NSString*)getUploadFileApiUrl;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (BOOL)isEmailAddress:(NSString *)string;
+ (BOOL)isHomeNumber:(NSString *)mobileNum;
+ (BOOL)isHomeNumberWithoutPrefix:(NSString *)mobileNum;

- (void)logOut;

@end
