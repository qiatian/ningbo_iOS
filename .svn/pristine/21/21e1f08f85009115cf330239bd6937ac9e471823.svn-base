//
//  ZTEProfileCardUpdateController.m
//  IM
//
//  Created by 周永 on 15/11/10.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//
//这个控制器用来控制   企业信息中 点击 手机，固话，邮箱 进入的界面
//
//根据类型(cardInfoType) 来控制cell中的数据
//
//
////////////////////////////////////////

#import "ZTEProfileCardUpdateController.h"
#import "ZTEProfileCell.h"
#import "ZTEUserProfileTools.h"


@interface ZTEProfileCardUpdateController ()<UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray      *dataArray;
@property (nonatomic, strong) NSArray             *cardOthersDataArray;             //其他邮件，电话，手机号数据
@property (nonatomic, strong) NSMutableDictionary *userInfoDict;
@property (nonatomic, assign) int                 currentFirstResponderTextFieldIndex;
@property (nonatomic, copy  ) NSMutableString     *commitDataString;
@property (nonatomic, strong) NSMutableArray      *textFieldsArray;



@end

@implementation ZTEProfileCardUpdateController

- (void)viewDidLoad {
    
    [super viewDidLoad];
     _currentFirstResponderTextFieldIndex = 0;

    _commitDataString = [NSMutableString string];
    
    _textFieldsArray = [NSMutableArray array];
    
    
    [self configureUI];
    
}

- (void)userInfoUpdated{
    
    [self.tableView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    _userInfoDict = [NSMutableDictionary dictionaryWithDictionary:[ConfigManager sharedInstance].userDictionary];
   
    _dataArray = [self configureData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - configure UI

- (void)configureUI{
    //更新信息提交按钮
    UIButton *checkButton = [[UIButton alloc] init];
    [checkButton setBackgroundImage:[UIImage imageNamed:@"nav_save"] forState:UIControlStateNormal];
    [checkButton sizeToFit];
    [checkButton addTarget:self action:@selector(commitNewUserInfo) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:checkButton];
    
    
    switch (_cardInfoType) {
        case ZTEProfileCardInfoTypeMobile: {
            self.title = LOCALIZATION(@"dis_enter_mobile");
            break;
        }
        case ZTEProfileCardInfoTypeTelephone: {
            self.title = LOCALIZATION(@"dis_enter_tel");
            break;
        }
        case ZTEProfileCardInfoTypeEmail: {
            self.title = LOCALIZATION(@"dis_enter_email");
            break;
        }
        default: {
            break;
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuseId = @"Cell";
    
    ZTEProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (!cell) {
        cell = [[ZTEProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    if (indexPath.row == 0) {
        
        NSString *placeholder;
        
        switch (_cardInfoType) {
            case ZTEProfileCardInfoTypeMobile: {
                placeholder = _userInfoDict[kZTEPersonalProfileMobile];
                break;
            }
            case ZTEProfileCardInfoTypeTelephone: {
                placeholder = _userInfoDict[kZTEPersonalProfileTelephone];
                break;
            }
            case ZTEProfileCardInfoTypeEmail: {
                placeholder = _userInfoDict[kZTEPersonalProfileEmail];
                break;
            }
            default: {
                placeholder = @"";
                break;
            }
        }
        
        cell.leftTextField.text = placeholder;
        //标记第一个文本框
        cell.leftTextField.tag = 100;
    }else{
        
        //显示其他的手机号，邮箱，电话
        if (indexPath.row - 1 < _cardOthersDataArray.count) {
            cell.leftTextField.text = _cardOthersDataArray[indexPath.row - 1];
        }
    }
    
    if (indexPath.row != 0) {
        cell.customAccessoryImage = [UIImage imageNamed:@"delHeadBtn"];
        [cell.deleteButton addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = LOCALIZATION(_dataArray[indexPath.row]);
    cell.leftTextField.delegate = self;
    
    [_textFieldsArray addObject:cell.leftTextField];

    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZTEProfileCell  *disCell = (ZTEProfileCell*)cell;
    
    if (indexPath.row == _currentFirstResponderTextFieldIndex) {
        [disCell.leftTextField becomeFirstResponder];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}


#pragma mark - private method
//点击了cell上的删除按钮
- (void)deleteCell:(UIButton*)sender{
    
    UITableViewCell *cell;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        
       cell  = (UITableViewCell*)sender.superview;
        
    }else{
        
        cell = (UITableViewCell*)sender.superview.superview;
    }
    
    
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    [_dataArray removeObjectAtIndex:indexPath.row];
    [_textFieldsArray removeObjectAtIndex:indexPath.row];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (NSMutableArray*)configureData{
    
    NSMutableArray *array = [NSMutableArray array];
    NSString *type;
    
    switch (_cardInfoType) {
            
        case ZTEProfileCardInfoTypeMobile: {
            type = @"dis_enter_mobile";
            break;
        }
        case ZTEProfileCardInfoTypeTelephone: {
            type = @"dis_enter_tel";
            break;
        }
        case ZTEProfileCardInfoTypeEmail: {

            type = @"dis_enter_email";
            break;
        }
        default: {
            break;
        }
    }
    //最少有两个cell
    [array addObjectsFromArray:@[type,type]];
    
    
    //初始化  其他邮件，电话，手机号数据 数据
    [self cardOthersDataInfo];
    
    for (int i = 0; i < _cardOthersDataArray.count; i++) {
        
        [array addObject:type];
        
    }

    return array;
    
}

/**
 *  提交信息
 */
- (void)commitNewUserInfo{
    
    [self.view endEditing:YES];
    
    
    _commitDataString = [NSMutableString string];
    
    ZTEProfileDetailType detailType;
    NSString *keyString;
    
    switch (_cardInfoType) {
        case ZTEProfileCardInfoTypeMobile: {
            detailType = ZTEProfileDetailTypeMobile;
            keyString = (NSString*)kZTEPersonalProfileMobile;
            break;
        }
        case ZTEProfileCardInfoTypeTelephone: {
            detailType = ZTEProfileDetailTypeTelephone;
            keyString = (NSString*)kZTEPersonalProfileTelephone;
            break;
        }
        case ZTEProfileCardInfoTypeEmail: {
            detailType = ZTEProfileDetailTypeEmail;
            keyString = (NSString*)kZTEPersonalProfileEmail;
            break;
        }
        default: {
            break;
        }
    }
    

    for (UITextField *textField in _textFieldsArray) {
        //第一个文本框
        if (textField.tag == 100) {
            
            if (textField.text.length == 0 ) {//
                
                if (_userInfoDict[keyString]) {//如果第一个文本框为空 但是有默认值
                    
                    [_commitDataString appendString:_userInfoDict[keyString]];
                    
                }else{//无默认值
                    
                    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"pls_input") isDismissLater:YES];
                    
                    return;
                    
                }
                
            }else{
                
                //如果第一个文本框不为空 判断输入是否有效
                if ([self caredInfoInputIsValid:keyString infoText:textField.text]) {
                    
                    [_commitDataString appendString:textField.text];
                    
                }else{
                    return;
                }

            }
            
        }else{//如果其他文本框中有内容
            
             if (textField.text.length != 0 ) {
                 //判断是否有效
                 if ([self caredInfoInputIsValid:keyString infoText:textField.text]) {
                     
                     NSString *appendString = [NSString stringWithFormat:@",%@",textField.text];
                     [_commitDataString appendString:appendString];
                     
                 }else{
                     return;
                 }
            }
        }
        
    }
    
    
    //更新用户信息
    [[ZTEUserProfileTools sharedTools] updateUserInfo:_commitDataString withInfoType:detailType userInfoDict:_userInfoDict viewcontroller:self];
    
    
}
/**
 *  判断文本框输入是否有效
 */
- (BOOL)caredInfoInputIsValid:(NSString*)keyString infoText:(NSString*)text{
    
    //判断文本是否有效
    
    if ([keyString isEqualToString:(NSString*)kZTEPersonalProfileMobile]) {
        
        if (text) {
            
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"mob_failed") isDismissLater:YES];
            
            _commitDataString = [NSMutableString string];
            
            return NO;
        }
        
    }else if ([keyString isEqualToString:(NSString*)kZTEPersonalProfileEmail]){
        
        if (![ZTEUserProfileTools isEmailAddress:text]) {
            
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"email_failed") isDismissLater:YES];
            
            _commitDataString = [NSMutableString string];
            
            return NO;
        }
        
    }else{
        
        if (!([ZTEUserProfileTools isHomeNumber:text] || [ZTEUserProfileTools isHomeNumberWithoutPrefix:text] )) {
            
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"tel_failed") isDismissLater:YES];
            
            _commitDataString = [NSMutableString string];
            
            return NO;
        }
        
    }
    
    return YES;
    
}
/**
 *  获取其邮件，电话，手机号 的数据
 */
- (void)cardOthersDataInfo{
    
    NSString *others;
    
    switch (_cardInfoType) {
        case ZTEProfileCardInfoTypeMobile: {
            others = _userInfoDict[kZTEPersonalProfileOtherMobile];
            break;
        }
        case ZTEProfileCardInfoTypeTelephone: {
            others = _userInfoDict[kZTEPersonalProfileOtherTelephone];
            break;
        }
        case ZTEProfileCardInfoTypeEmail: {
            others = _userInfoDict[kZTEPersonalProfileOtherEmail];
            break;
        }
        default: {
            break;
        }
    }
    
    if (others.length > 0) {
        
        _cardOthersDataArray = [NSMutableArray arrayWithArray:[others componentsSeparatedByString:@","]];
        
    }
    
    
    
}

#pragma mark - UITextField Delegate


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //拿到当前cell
    UITableViewCell *cell = (UITableViewCell*)textField.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    _currentFirstResponderTextFieldIndex = indexPath.row;
    
    //如果编辑的时最后一行 就再添加一行数据
    if (indexPath.row == (_dataArray.count-1)) {
        
        
        
        switch (_cardInfoType) {
            case ZTEProfileCardInfoTypeMobile: {
                [_dataArray addObject:@"dis_enter_mobile"];
                break;
            }
            case ZTEProfileCardInfoTypeTelephone: {
                [_dataArray addObject:@"dis_enter_tel"];
                break;
            }
            case ZTEProfileCardInfoTypeEmail: {
                [_dataArray addObject:@"dis_enter_email"];
                break;
            }
            default: {
                break;
            }
        }
        
        [self.tableView reloadData];
        
        [_textFieldsArray removeAllObjects];
        
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
}

@end

















