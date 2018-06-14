//
//  AudioConferenceViewController.h
//  IM
//
//  Created by syj on 14-8-28.
//  Copyright (c) 2014年 rongfzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GQBaseViewController.h"
#import "MEnterpriseUser.h"
@interface AudioConferenceViewController : GQBaseViewController
{
    UIScrollView    *peopleHPBG;
    UILabel         *statusLab;
    UILabel         *timeLab;
    UIButton        *cancleBtn;
    
    UIButton        *volumeBtn;
    UIButton        *muteBtn;//静音,扬声器
    UIImageView     *huatongBG;
    
    UIButton        *refuseBtn;
    UIButton        *accrptBtn;
    
    UILabel *nameLabel;
    
    int callType;  // 0是call 1 是接听
    
    NSTimer *timer; //计时器
    
    int timeSeconds;
}

@property(nonatomic, strong)NSString *callID;
@property(nonatomic, assign)int callType;
@property(nonatomic,strong)MEnterpriseUser *callUser;
@property(nonatomic,strong)NSString *callerAccount;
@end
