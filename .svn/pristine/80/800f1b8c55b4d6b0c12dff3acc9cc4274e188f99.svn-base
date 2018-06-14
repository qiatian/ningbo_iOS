//
//  NotiModel.h
//  IM
//
//  Created by 陆浩 on 15/7/4.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface NotiListModel : JSONModel

@property (copy, nonatomic) NSString<Optional> *id;

@property (copy, nonatomic) NSString<Optional> *address;

@property (copy, nonatomic) NSString<Optional> *startTime;

@property (copy, nonatomic) NSString<Optional> *endTime;

@property (copy, nonatomic) NSString<Optional> *title;

@property (copy, nonatomic) NSString<Optional> *creator;//创建者的id

@property (copy, nonatomic) NSString<Optional> *dealStatus;//当前登陆的接受者的处理状态

@property (copy, nonatomic) NSString<Optional> *status;//当前创建者对于通知的状态



@end

@interface NotiUserModel : JSONModel

@property (copy, nonatomic) NSString<Optional> *id;

@property (copy, nonatomic) NSString<Optional> *minipicurl;

@property (copy, nonatomic) NSString<Optional> *name;

@property (copy, nonatomic) NSString<Optional> *participantId;

@property (copy, nonatomic) NSString<Optional> *dealTime;

@property (copy, nonatomic) NSString<Optional> *status;

@property (copy, nonatomic) NSString<Optional> *remark;

@end

@interface NotiDetailModel : NotiListModel

@property (copy, nonatomic) NSString<Optional> *endTime;//详情页使用：结束日期

@property (copy, nonatomic) NSString<Optional> *remark;//详情页使用：备注

@property (copy, nonatomic) NSString<Optional> *accepted;//详情页使用：接受者数量

@property (copy, nonatomic) NSString<Optional> *refused;//详情页使用：拒绝者数量

@property (copy, nonatomic) NSString<Optional> *waitted;//详情页使用：等待处理者数量

@property (copy, nonatomic) NSMutableArray<Optional> *users_array;//详情页使用：通知成员

@property (copy, nonatomic) NSString <Optional> *status;        //状态
           
@property (copy, nonatomic) NSString <Optional> *cancelpurpose;     //取消原因
@end
