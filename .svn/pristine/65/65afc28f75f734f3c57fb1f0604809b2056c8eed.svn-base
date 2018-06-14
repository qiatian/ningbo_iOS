//
//  MQTTManager.h
//  IM
//
//  Created by syj on 14-9-25.
//  Copyright (c) 2014年 zuo guoqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MosquittoClient.h"
#import "MEnterpriseUser.h"
#import "MGroup.h"
#import "MMessage.h"
#import "MGroup.h"
#import "OpenCoreAmrManager.h"
#import "SQLiteManager.h"
#import "NSString+DTUtilities.h"

@interface MQTTManager : NSObject
{
}

@property(nonatomic, strong)MosquittoClient *mqttClient;
@property(nonatomic, readonly) MosquittoConnectionResponse responseStatus;

+(MQTTManager *)sharedInstance;

- (void)connect;
-(void)disconnect;
//发送消息
- (void)sendMMessage:(MMessage *)msg voiceData:(NSData *)voiceData notificationName:(NSString *)notificationName;

/*     各字段的含义

JSON里各Key值的代表含义：
"type" ：//0普通点对点，1普通群聊，2 修改群群名，3添加成员消息，4退群消息，5删除成员消息，6删除群  7系统创建群消息
“headpicurl” ：发送者的头像url
"msg" ： 发送信息的内容，表情和文字 都包含
“face” : 发送信息里是否包含头像。true ：包含。false：不包含。
“username” ： 发送者的名字
“keyid” ：发送者的UID
“bigpicurl” ： 传输过程中的大图片url
“minipicurl” ：传输过程中的小图片url
”voicelength“  传输语音的长度
“operatorid” ：被操作者的uid。在群组操作里 被添加的人 被删除的人等需要此字段。
”adminid“   ： 该群组的创建者（群主） 在退出该群组的时候 会指定列表的下一个人为群主，拥有删除该群组内其他人的权限。
”adminname“ ：相对应 adminid这个人的 姓名
”contenttype“ ：接收到的信息内容类型。0：文字内容；1：文件；2：图片；3：语音；5：视频  7：用户更改头像，通知其他用户更新。
”sessionid“ 会话ID
”sessionname“ 会话名称。

*/





@end
