//
//  NotiModel.m
//  IM
//
//  Created by 陆浩 on 15/7/4.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "NotiModel.h"

@implementation NotiListModel

@end

@implementation NotiUserModel

@end


@implementation NotiDetailModel

@synthesize users_array;

-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    self = [super initWithDictionary:dict error:err];
    users_array = [[NSMutableArray alloc] init];
    return self;
}

@end
