//
//  NoticeCellModel.h
//  IM
//
//  Created by  pipapai_tengjun on 15/7/14.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "JSONModel.h"

@interface NoticeCellModel : JSONModel

@property (copy, nonatomic) NSString<Optional> *contentType;

@property (copy, nonatomic) NSString<Optional> *receiverType;

@property (copy, nonatomic) NSString<Optional> *senderId;

@property (copy, nonatomic) NSString<Optional> *receiverId;

@property (copy, nonatomic) NSString<Optional> *senderUid;

@property (copy, nonatomic) NSString<Optional> *title;

@property (copy, nonatomic) NSString<Optional> *senderName;

@property (copy, nonatomic) NSString<Optional> *content;

@property (copy, nonatomic) NSString<Optional> *createTime;

@property (strong, nonatomic) id<Optional> data;

@end
