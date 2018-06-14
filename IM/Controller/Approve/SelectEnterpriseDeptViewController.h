//
//  SelectEnterpriseDeptViewController.h
//  IM
//
//  Created by ZteCloud on 15/10/22.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "GQBaseViewController.h"
typedef void(^SelectDeptBlock)(MEnterpriseDept *sDept);
typedef void(^AllSelectDeptBlock)(NSDictionary* allSelectedDepts);

@interface SelectEnterpriseDeptViewController : GQBaseViewController
@property(nonatomic,strong)MEnterpriseDept *enterpriseCurrentDept;
@property(nonatomic,strong) NSMutableArray *enterpriseContacts;
@property(nonatomic,strong)NSMutableArray *enterpriseUsers;
@property(nonatomic,strong)NSMutableArray *stepBarData;
@property(nonatomic,strong) RMStepsBar *stepBar;
@property(nonatomic,strong) UINib *nibEnterpriseContacts;
@property(nonatomic,copy)SelectDeptBlock selectBlock;

//多选
@property (nonatomic, copy) AllSelectDeptBlock allSelectBlock;
@property (nonatomic, assign) BOOL canMultiselect;
@property (nonatomic, strong) NSMutableArray *allSelectedRows;
@end
