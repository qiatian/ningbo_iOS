//
//  UMEventDefines.h
//  PPP
//
//  Created by Jianwen Sun on 15/5/5.
//  Copyright (c) 2015年 LX. All rights reserved.
//

#ifndef PPP_UMEventDefines_h
#define PPP_UMEventDefines_h

#import "MobClick.h"

/*
 在对应的业务部分使用这个方法宏，传入下面定义的事件ID宏
 */
#define UMEventWite(eventId) [MobClick event:eventId]

#define pipa_bind_company @"pipa_bind_company"//,绑定公司,0
#define pipa_bind_company_success @"pipa_bind_company_success"//,绑定公司成功,0
#define pipa_hr_add_newhuman @"pipa_hr_add_newhuman"//,hr添加新朋友,0
#define pipa_hr_for_seeker_details @"pipa_hr_for_seeker_details"//,查看求职者详情
#define pipa_hr_human @"pipa_hr_human"//,查看求职者详情
#define pipa_hr_message  @"pipa_hr_message"//,hr查看消息
#define pipa_hr_refresh_from_bottom  @"pipa_hr_refresh_from_bottom"//,从底部刷新
#define pipa_hr_refresh_from_top  @"pipa_hr_refresh_from_top"//,从顶部刷新
#define pipa_hr_send_message @"pipa_hr_send_message"//,hr发送消息
#define pipa_hr_system_message @"pipa_hr_system_message"//,hr查看小秘书
#define pipa_invite @"pipa_invite"//,输入邀请码
#define pipa_login @"pipa_login"//,登录
#define pipa_login_error_companyname @"pipa_login_error_companyname"//,登录使用公司账号
#define pipa_login_success @"pipa_login_success"//,成功登录
#define pipa_regist_choice_hr @"pipa_regist_choice_hr"//,注册hr账号
#define pipa_regist_choice_seeker @"pipa_regist_choice_seeker"//,注册求职者账号
#define pipa_register @"pipa_register"//,注册
#define pipa_scan @"pipa_scan"//,扫描二维码
#define pipa_seeker_add_newhuman @"pipa_seeker_add_newhuman"//,求职者添加新朋友
#define pipa_seeker_apply @"pipa_seeker_apply"//,求职者点击应聘
#define pipa_seeker_apply_from_bottom @"pipa_seeker_apply_from_bottom"//,求职信息从底部刷新
#define pipa_seeker_apply_from_top @"pipa_seeker_apply_from_top"//,求职信息从顶部刷新
#define pipa_seeker_human @"pipa_seeker_human"//,求职者查看人脉
#define pipa_seeker_job_details @"pipa_seeker_job_details"//,求职者查看职位详情
#define pipa_seeker_message @"pipa_seeker_message"//,求职者查看消息
#define pipa_seeker_rec_jumpto_update @"pipa_seeker_rec_jumpto_update"//,从推荐跳入完善信息
#define pipa_seeker_recommand_jobdetails_jobsnumber @"pipa_seeker_recommand_jobdetails_jobsnumber"//,查看公司其他招聘的职位
#define pipa_seeker_recommand_jobtails_updateinfo @"pipa_seeker_recommand_jobtails_updateinfo"//,推荐职位详细信息中的完善信息
#define pipa_seeker_recommend @"pipa_seeker_recommend"//,求职者点击推荐
#define pipa_seeker_recommend_job_details @"pipa_seeker_recommend_job_details"//,推荐进入职位详情
#define pipa_seeker_recommend_refresh_from_bottom @"pipa_seeker_recommend_refresh_from_bottom"//,推荐从底部刷新
#define pipa_seeker_recommend_refresh_from_top @"pipa_seeker_recommend_refresh_from_top"//,推荐从顶部刷新
#define pipa_seeker_save_basic_success @"pipa_seeker_save_basic_success"//,成功保存基本信息
#define pipa_seeker_save_edu_success @"pipa_seeker_save_edu_success"//,成功保存教育经历
#define pipa_seeker_save_expect_success @"pipa_seeker_save_expect_success"//,成功保存求职意向
#define pipa_seeker_save_skill_success @"pipa_seeker_save_skill_success"//,成功保存职业技能
#define pipa_seeker_save_updateinfo @"pipa_seeker_save_updateinfo"//,完善信息点击保存
#define pipa_seeker_save_work_success @"pipa_seeker_save_work_success"//,成功保存工作经历
#define pipa_seeker_send_message @"pipa_seeker_send_message"//,求职者发送消息
#define pipa_seeker_system_message @"pipa_seeker_system_message"//,求职者查看小秘书
#define pipa_seeker_update_head_success @"pipa_seeker_update_head_success"//,求职者成功上传头像
#define pipa_seeker_update_selfinfo @"pipa_seeker_update_selfinfo"//,完善信息

#endif
