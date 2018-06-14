//
//  SettingModel.m
//  IM
//
//  Created by ZteCloud on 16/4/8.
//  Copyright © 2016年 zuo guoqing. All rights reserved.
//

#import "SettingModel.h"
#import "JSMessageSoundEffect.h"
@implementation SettingModel
+(void)getMessageSoundShock
{
    NSString * shockStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"shock"];
    NSString * soundStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"sound"];
    JSMessageSoundEffect * effect = [[JSMessageSoundEffect alloc]init];
    if (!shockStr && !soundStr) {
        //默认开启 震动 和 声音
        [effect playMessageReceivedAlert];
    }
    if (shockStr) {
        if ([shockStr isEqualToString:@"1"]) {
            //震动
            effect.closeShock = NO;
        }
        else{
            effect.closeShock = YES;
        }
        [effect playMessagesentShock];
    }
    else if (!shockStr){
        effect.closeShock = NO;
        [effect playMessagesentShock];
    }

    if (soundStr) {
        if ([soundStr isEqualToString:@"1"]) {
            //声音
            effect.closeSound = NO;
        }
        else{
            effect.closeSound = YES;
        }
        [effect playMessageSentSound];
    }
    else if (!soundStr){
        effect.closeSound = NO;
        [effect playMessageSentSound];
    }
}
@end
