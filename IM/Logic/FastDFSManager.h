//
//  FastDFSManager.h
//  IM
//
//  Created by zuo guoqing on 14-10-13.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include "fdfs_client.h"
#include "sockopt.h"
#include "logger.h"

@interface FastDFSManager : NSObject
+(FastDFSManager *)sharedInstance;

//actionName:@"upload",@"delete"
-(NSDictionary *)handleWithActionName:(NSString*)actionName localFileName:(NSString*)local_filenameStr  remoteFilename:(NSString*)remote_filenameStr groupName:(NSString*)group_nameStr;
@end
