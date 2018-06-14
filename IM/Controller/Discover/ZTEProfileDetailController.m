//
//  ZTEProfileDetailController.m
//  IM
//
//  Created by 周永 on 15/11/9.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "ZTEProfileDetailController.h"
#import "UITextView+Placeholder.h"
#import "ZTEProfileCardUpdateController.h"
#import "Masonry.h"
#import "SettingDetailCell.h"
#import "NSString+Helpers.h"
#import "ZTEProfileCell.h"
#import "ZTEUserProfileTools.h"
#import "ProfileCardUpdateController.h"

@interface ZTEProfileDetailController()

@property (nonatomic, strong) NSArray             *dataArray;               //显示数据数组
@property (nonatomic, copy  ) NSString            *locationDataType;        //位置类型 省 市
@property (nonatomic, copy  ) NSMutableString     *address;                 //地址 -- 用来拼接省市
@property (nonatomic, strong) NSMutableDictionary *userInfoDict;            //用户信息
@property (nonatomic, strong) UITextView          *autographTextView;       //个性签名textview


@end

@implementation ZTEProfileDetailController


#pragma mark - life circle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configureTitle];
    
    if (_detailType != ZTEProfileDetailTypeLocation) {
        
        self.tableView.scrollEnabled = NO;
        
    }
    
    _dataArray = [self getData];
    
    _address = [NSMutableString string];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoUpdated) name:ZTEUserInfoUpdatedNotification object:nil];
    
}

- (void)userInfoUpdated{
    
    [self.tableView reloadData];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    _userInfoDict = [NSMutableDictionary dictionaryWithDictionary:[ConfigManager sharedInstance].userDictionary];
    
}


#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    switch (_detailType) {
            
        case ZTEProfileDetailTypeHeader: {

            return 0;
        }
        case ZTEProfileDetailTypeName: {
    
            return 0;
        }
        case ZTEProfileDetailTypeQRcode: {
        
            return 0;
        }
        case ZTEProfileDetailTypeGender: {
            
            return 1;
        }
        case ZTEProfileDetailTypeSignature: {
            return 1;
        }
        case ZTEProfileDetailTypeLocation: {
            
            return 1;
        }
        case ZTEProfileDetailTypeEnterpriseInfo: {
            
            return 2;
        }
        default: {
            
            return 0;
        }
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    switch (_detailType) {
            
        case ZTEProfileDetailTypeHeader: {
            
            return 0;
        }
        case ZTEProfileDetailTypeName: {
            
            return 0;
        }
        case ZTEProfileDetailTypeQRcode: {
            
            return 0;
        }
        case ZTEProfileDetailTypeGender: {
            
            return 2;
        }
        case ZTEProfileDetailTypeSignature: {
            return 0;
        }
        case ZTEProfileDetailTypeLocation: {
            
            return _dataArray.count;
        }
        case ZTEProfileDetailTypeEnterpriseInfo: {
            NSString *key = [NSString stringWithFormat:@"%d",(int)section];
            return [_dataArray[0][key] count];
        }
        default: {
            
            return 0;
        }
    }
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    switch (_detailType) {
        case ZTEProfileDetailTypeHeader: {
            
            break;
        }
        case ZTEProfileDetailTypeName: {
            
            break;
        }
        case ZTEProfileDetailTypeQRcode: {
            
            break;
        }
        case ZTEProfileDetailTypeGender: {
            //////////////性别/////////////////////
            static NSString *genderReuseId = @"genderCell";
            SettingDetailCell *genderCell = [tableView dequeueReusableCellWithIdentifier:genderReuseId];
            if (!genderCell) {
                genderCell = [[SettingDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:genderReuseId];
            }
            genderCell.CheckImageView.image = nil;
            NSNumber *sex = _userInfoDict[kZTEPersonalProfileSex];
            //sex == 1 为男 == 0的时候为 女
            if (sex.intValue != indexPath.row) {
                genderCell.CheckImageView.image = [UIImage imageNamed:@"selected"];
            }else{
                genderCell.CheckImageView.image = [UIImage imageNamed:@"select_no"];
            }
            genderCell.selectionStyle = UITableViewCellSelectionStyleNone;
            genderCell.textLabel.text = LOCALIZATION(_dataArray[indexPath.row]);
            return genderCell;
            break;
        }
        case ZTEProfileDetailTypeSignature: {
            //////////////个性签名/////////////////////
            
            
            break;
        }
        case ZTEProfileDetailTypeLocation: {
            /////////////////地区//////////////////
            static NSString *locationReuseId = @"locationCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:locationReuseId];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:locationReuseId];
            }

            if ([_locationDataType isEqualToString:@"province"]) {
                cell.textLabel.text = [_dataArray[indexPath.row] valueForKey:@"ProvinceName"];
            }else{
                cell.textLabel.text = [_dataArray[indexPath.row] valueForKey:@"CityName"];
            }
            return cell;
            break;
            
        }
        case ZTEProfileDetailTypeEnterpriseInfo: {
            //////////////企业信息//////////////////
            static NSString *infoReuseId = @"infoCell";
            
            ZTEProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:infoReuseId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!cell) {
                cell = [[ZTEProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:infoReuseId];
            }
            NSString *key = [NSString stringWithFormat:@"%d",(int)indexPath.section];
            cell.textLabel.text = LOCALIZATION(_dataArray[0][key][indexPath.row]);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (indexPath.section == 0) {
                NSString *content;
                switch (indexPath.row) {
                    case 0:
                        content = _userInfoDict[kZTEPersonalProfileCompany];
                        break;
                    case 1:
                        content = _userInfoDict[kZTEPersonalProfileDepartment];
                        break;
                    case 2:
                        content = _userInfoDict[kZTEPersonalProfilePosition];
                        break;
                    default:
                        break;
                }
                
                cell.leftInfoLabel.text = content;
                cell.leftInfoLabel.textColor = [UIColor grayColor];
            }
            
            if (indexPath.section == 1) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                if (indexPath.row == 0) {
                    cell.leftInfoLabel.text = _userInfoDict[kZTEPersonalProfileMobile];
                    
                }else if (indexPath.row == 1){
                    cell.leftInfoLabel.text = _userInfoDict[kZTEPersonalProfileTelephone];
                }else{
                    cell.leftInfoLabel.text = _userInfoDict[kZTEPersonalProfileEmail];
                }
                
                cell.leftInfoLabel.textColor = [UIColor grayColor];
            }
            return cell;
            break;
        }
        default: {
            break;
        }
    }

}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_detailType == ZTEProfileDetailTypeLocation) {
        
        if ([_locationDataType isEqualToString:@"province"]) {//选中省  更新data 到市的数据
            
            _locationDataType = @"city";
            //地址字符串
            [_address appendString:[_dataArray[indexPath.row] valueForKey:@"ProvinceName"]];
            [_address appendString:@" "];
            _dataArray = [_dataArray[indexPath.row] objectForKey:@"cities"];
            [self.tableView reloadData];
        }else{//选中市
            
            [_address  appendString:[_dataArray[indexPath.row] valueForKey:@"CityName"]];
            
            [self updateUserInfo:_address];
            
        }

    }
    
    if (_detailType == ZTEProfileDetailTypeGender) {
        
        [_userInfoDict setValue:[NSNumber numberWithInt:abs(indexPath.row - 1)] forKey:(NSString*)kZTEPersonalProfileSex];
        
        [self.tableView reloadData];
        
    }
    
    
    if (_detailType == ZTEProfileDetailTypeEnterpriseInfo) {//进入编辑手机， 固话，邮箱的界面
        
        ProfileCardUpdateController *cardUpdateController = [[ProfileCardUpdateController alloc] initWithStyle:UITableViewStyleGrouped];
        
        if (indexPath.section == 1) {
            
            if (indexPath.row == 0) {
                cardUpdateController.infoType = ZTEProfileCardInfoTypeMobile;
            }else if (indexPath.row == 1){
                cardUpdateController.infoType = ZTEProfileCardInfoTypeTelephone;
            }else{
                cardUpdateController.infoType = ZTEProfileCardInfoTypeEmail;
            }
            
            [self.navigationController pushViewController:cardUpdateController animated:YES];
        }
        
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    switch (_detailType) {
            
        case ZTEProfileDetailTypeHeader: {
            break;
        }
        case ZTEProfileDetailTypeName: {
            break;
        }
        case ZTEProfileDetailTypeQRcode: {
            break;
        }
        case ZTEProfileDetailTypeGender: {
            break;
        }
        case ZTEProfileDetailTypeSignature: {
            return 200.0;
        }
        case ZTEProfileDetailTypeLocation: {
            return 20.0;
            break;
        }
        case ZTEProfileDetailTypeEnterpriseInfo: {
            if (section == 0) {
                return 20.0;
            }
            break;
        }
        default: {
            break;
        }
    }
    
    return 0.1;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //更新信息提交按钮
    UIButton *checkButton = [[UIButton alloc] init];
    [checkButton setBackgroundImage:[UIImage imageNamed:@"nav_save"] forState:UIControlStateNormal];
    [checkButton sizeToFit];
    [checkButton addTarget:self action:@selector(commitNewUserInfo) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *headerView = [[UIView alloc] init];
    
    
    switch (_detailType) {
            
        case ZTEProfileDetailTypeHeader: {
            break;

        }
        case ZTEProfileDetailTypeName: {
            break;

        }
        case ZTEProfileDetailTypeQRcode: {
            
            break;
        }
        case ZTEProfileDetailTypeGender: {
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:checkButton];
            
            break;
        }
        case ZTEProfileDetailTypeSignature: {
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:checkButton];
            
            NSString *autograph = [ConfigManager sharedInstance].userDictionary[kZTEPersonalProfileSignature];
            
            _autographTextView = [[UITextView alloc] init];
            _autographTextView.font = [UIFont systemFontOfSize:20];
            
            if (autograph) {
                
                _autographTextView.text = autograph;
                
            }else{
                _autographTextView = [[UITextView alloc] initWithPlaceholder:LOCALIZATION(@"dis_auto_placeholder")];
            }
            
            [headerView addSubview:_autographTextView];
            
            [_autographTextView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(headerView.mas_top).with.offset(10);
                make.left.bottom.right.equalTo(headerView);
            }];
            
            break;
        }
        case ZTEProfileDetailTypeLocation: { 
            
            break;
        }
                        case ZTEProfileDetailTypeEnterpriseInfo: {
            
            break;
        }
        default: {
            
            
            break;
        }
    }
    
    
    
    return headerView;
    
    
    
    
}

#pragma mark - private method

- (NSArray*)getData{
    
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    switch (_detailType) {
        case ZTEProfileDetailTypeHeader: {
            
            break;
        }
        case ZTEProfileDetailTypeName: {
            
            break;
        }
        case ZTEProfileDetailTypeQRcode: {
            
            break;
        }
        case ZTEProfileDetailTypeGender: {
            
            [dataArray addObjectsFromArray:@[@"dis_gender_male",@"dis_gender_female"]];
            
            break;
        }
        case ZTEProfileDetailTypeSignature: {
            
            break;
        }
        case ZTEProfileDetailTypeLocation: {
            _locationDataType = @"province";
            NSString *filePath = [NSString resourcePathOfFile:@"area" type:@"plist"];
            NSArray *area = [NSArray arrayWithContentsOfFile:filePath];
            [dataArray addObjectsFromArray:area];
            break;
        }
        case ZTEProfileDetailTypeEnterpriseInfo: {
            
            [dataArray addObjectsFromArray:@[@{
                                                 @"0":@[@"dis_enter_company",@"dis_enter_dept",@"dis_enter_post"],
                                                 @"1":@[@"dis_enter_mobile",@"dis_enter_tel",@"dis_enter_email"]
                                                           }
                                                       ]];
            
            break;
        }
        default: {
            break;
        }
    }
    
    return dataArray;
    
}

#pragma mark - private method  & button clicked

/**
 *  提交新信息
 */
- (void)commitNewUserInfo{
    
    
    switch (_detailType) {
        case ZTEProfileDetailTypeHeader: {
            
            break;
        }
        case ZTEProfileDetailTypeName: {
            
            break;
        }
        case ZTEProfileDetailTypeQRcode: {
            
            break;
        }
        case ZTEProfileDetailTypeGender: {//更新性别
            NSNumber *sex = _userInfoDict[kZTEPersonalProfileSex];
            [self updateUserInfo:[NSString stringWithFormat:@"%d",sex.intValue]];
            break;
        }
        case ZTEProfileDetailTypeSignature: {//更新个性签名
            
            NSString *autograph = _autographTextView.text;
            
            if (autograph.length == 0) {
                
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"dis_auto_nil") isDismissLater:YES];
                
            }else if (autograph.length > 30 ){
                
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"dis_auto_length") isDismissLater:YES];
                
            }else{
                
                [self updateUserInfo:autograph];
                
            }

            break;
        }
        case ZTEProfileDetailTypeLocation: {
            
            break;
        }
        case ZTEProfileDetailTypeEnterpriseInfo: {
            
            break;
        }
        default: {
            break;
        }
    }
    
}

/**
 *  更新用户信息
 *
 *  @param newInfo 新信息
 */
- (void)updateUserInfo:(id)newInfo{
    
    [[ZTEUserProfileTools sharedTools] updateUserInfo:newInfo withInfoType:_detailType userInfoDict:_userInfoDict viewcontroller:self];
}


- (void)configureTitle{
    
    switch (_detailType) {
        case ZTEProfileDetailTypeName: {
            self.title = LOCALIZATION(@"dis_pro_name");
            break;
        }
        case ZTEProfileDetailTypeQRcode: {
            self.title = LOCALIZATION(@"dis_pro_code");
            break;
        }
        case ZTEProfileDetailTypeGender: {
            self.title = LOCALIZATION(@"dis_pro_gender");
            break;
        }
        case ZTEProfileDetailTypeSignature: {
            self.title = LOCALIZATION(@"dis_pro_auto");
            break;
        }
        case ZTEProfileDetailTypeLocation: {
            self.title = LOCALIZATION(@"dis_pro_region");
            break;
        }
        case ZTEProfileDetailTypeEnterpriseInfo: {
            self.title = LOCALIZATION(@"dis_pro_enterinfo");
            break;
        }
        default: {
            break;
        }
    }
}






@end
