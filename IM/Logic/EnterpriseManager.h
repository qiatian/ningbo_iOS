//
//  EnterpriseManager.h
//  IM
//
//  Created by 周永 on 16/1/23.
//  Copyright © 2016年 zuo guoqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnterpriseManager : NSObject
+(EnterpriseManager *)sharedInstance;
-(void)loadGroupContacts;
-(void)loadEnterpriseContacts:(void (^)(void))allCompletionBlock;
@end
