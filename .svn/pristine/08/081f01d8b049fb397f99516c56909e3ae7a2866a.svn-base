//
//  ProfileCardUpdateController.m
//  IM
//
//  Created by 周永 on 16/1/9.
//  Copyright © 2016年 zuo guoqing. All rights reserved.
//

#import "ProfileCardUpdateController.h"
#import "ZTEProfileCell.h"
#import "ZTEUserProfileTools.h"


@interface ProfileCardUpdateController () <UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableDictionary *userInfoDict;
@property (nonatomic, strong) NSArray             *cardOthersDataArray;             //其他邮件，电话，手机号数据

@property (nonatomic, assign) BOOL isDeletedBtnClicked;

@property (nonatomic, copy) NSMutableString *commitDataString;

@property (nonatomic, assign) int currentFirstResponderTextField;

@end

@implementation ProfileCardUpdateController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isDeletedBtnClicked = NO;
    
    _currentFirstResponderTextField = 0;
    
    _userInfoDict = [NSMutableDictionary dictionaryWithDictionary:[ConfigManager sharedInstance].userDictionary];
    
    [self configureUI];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureUI{
    //更新信息提交按钮
    UIButton *checkButton = [[UIButton alloc] init];
    [checkButton setBackgroundImage:[UIImage imageNamed:@"nav_save"] forState:UIControlStateNormal];
    [checkButton sizeToFit];
    [checkButton addTarget:self action:@selector(commitNewUserInfo) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:checkButton];
    
    switch (_infoType) {
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZTEProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[ZTEProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    
    switch (_infoType) {
        case ZTEProfileCardInfoTypeMobile: {
            cell.textLabel.text = @"手机";
            cell.leftTextField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        }
        case ZTEProfileCardInfoTypeTelephone: {
            cell.textLabel.text = @"电话";
            cell.leftTextField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        }
        case ZTEProfileCardInfoTypeEmail: {
            cell.textLabel.text = @"邮箱";
            cell.leftTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            break;
        }
    }
    
    if (![_dataArray[indexPath.row] isEqualToString:@"new"]) {
        cell.leftTextField.text = _dataArray[indexPath.row];
    }else{
        cell.leftTextField.text = @"";
    }
    
    cell.leftTextField.tag = 100;
    cell.leftTextField.delegate = self;
    
    if (indexPath.row != 0) {
        cell.customAccessoryImage = [UIImage imageNamed:@"delHeadBtn"];
        [cell.deleteButton addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}





#pragma mark - private method

- (NSMutableArray*)dataArray{
    
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
        
        switch (_infoType) {
            case ZTEProfileCardInfoTypeMobile: {
                if (_userInfoDict[kZTEPersonalProfileMobile]) {
                    [_dataArray addObject:_userInfoDict[kZTEPersonalProfileMobile]];
                }
                
                break;
            }
            case ZTEProfileCardInfoTypeTelephone: {
                if (_userInfoDict[kZTEPersonalProfileTelephone]) {
                    [_dataArray addObject:_userInfoDict[kZTEPersonalProfileTelephone]];
                }
                break;
            }
            case ZTEProfileCardInfoTypeEmail: {
                if (_userInfoDict[kZTEPersonalProfileEmail]) {
                    [_dataArray addObject:_userInfoDict[kZTEPersonalProfileEmail]];
                }
                
                break;
            }
        }
        
        [self cardOthersDataInfo];
        
        if (_cardOthersDataArray.count > 0) {
            
            for ( int i = 0; i< _cardOthersDataArray.count; i++) {
                [_dataArray addObject:_cardOthersDataArray[i]];
            }
            
        }
        
        [_dataArray addObject:@"new"];
        
    }
    
    return _dataArray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0;
    
}

/**
 *  提交信息
 */
- (void)commitNewUserInfo{
    
    [self.view endEditing:YES];
    
    
    _commitDataString = [NSMutableString string];
    
    ZTEProfileDetailType detailType;
    NSString *keyString;
    
    switch (_infoType) {
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
    
    
    for ( int i = 0 ; i< _dataArray.count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        if (indexPath.row != 0) {
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            for (int i = 0 ; i < cell.contentView.subviews.count;  i++) {
                UIView *subView = cell.contentView.subviews[i];
                if (subView.tag == 100) {
                    
                    UITextField *textField = (UITextField*)subView;
                    
                    if (textField.text.length != 0 ) {
                        //判断是否有效
                        if ([self careInfoInputIsValid:keyString infoText:textField.text]) {
                            
                            NSString *appendString = [NSString stringWithFormat:@",%@",textField.text];
                            [_commitDataString appendString:appendString];
                            
                        }else{
                            return;
                        }
                    }
                    
                }
                
            }
            
        }else{
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            for (int i = 0 ; i < cell.contentView.subviews.count;  i++) {
                
                UIView *subView = cell.contentView.subviews[i];
                
                if (subView.tag == 100) {
                    UITextField *textField = (UITextField*)subView;
                    
                    if (textField.text.length == 0 ) {//
                        
                        if (_userInfoDict[keyString]) {//如果第一个文本框为空 但是有默认值
                            
                            [_commitDataString appendString:_userInfoDict[keyString]];
                            
                        }else{//无默认值
                            
                            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"pls_input") isDismissLater:YES];
                            
                            return;
                            
                        }
                        
                    }else{
                        
                        //如果第一个文本框不为空 判断输入是否有效
                        if ([self careInfoInputIsValid:keyString infoText:textField.text]) {
                            
                            [_commitDataString appendString:textField.text];
                            
                        }else{
                            return;
                        }
                        
                    }
                    
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
- (BOOL)careInfoInputIsValid:(NSString*)keyString infoText:(NSString*)text{
    
    //判断文本是否有效
    
    if ([keyString isEqualToString:(NSString*)kZTEPersonalProfileMobile]) {
        
        if (!text) {
            
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
    
    switch (_infoType) {
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

- (void)deleteCell:(UIButton*)sender{
    
    _isDeletedBtnClicked = YES;
    
    NSIndexPath *indexPath = [self getIndexPathForSubview:sender];
    
    [_dataArray removeObjectAtIndex:indexPath.row];
    
    [self.tableView reloadData];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    _isDeletedBtnClicked = NO;
    
    NSIndexPath *indexPath = [self getIndexPathForSubview:textField];
    
     _currentFirstResponderTextField = indexPath.row;
    
    if (indexPath.row == _dataArray.count -1 ) {
        
        [_dataArray addObject:@"new"];
        
        
        [self.tableView reloadData];
        
        //因为reloadData是在主线程，所以要判断reloadData是不是结束 可以再开一个主线程任务
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ZTEProfileCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentFirstResponderTextField inSection:0]];
            [cell.leftTextField becomeFirstResponder];
            
        });
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSIndexPath *indexPath = [self getIndexPathForSubview:textField];
    
    [_dataArray replaceObjectAtIndex:indexPath.row withObject:textField.text];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSIndexPath *indexPath = [self getIndexPathForSubview:textField];
    
    if (!_isDeletedBtnClicked) {
        
        [_dataArray replaceObjectAtIndex:indexPath.row withObject:textField.text];
        
        _isDeletedBtnClicked = NO; 
    }
    
    
}

- (NSIndexPath*)getIndexPathForSubview:(UIView*)subview{
    
    
    UIView *cell = subview.superview;
    
    while (![cell isKindOfClass:[ZTEProfileCell class]]) {
        
        cell = cell.superview;
        
    }
    
    return [self.tableView indexPathForCell:(ZTEProfileCell*)cell];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
}



@end
