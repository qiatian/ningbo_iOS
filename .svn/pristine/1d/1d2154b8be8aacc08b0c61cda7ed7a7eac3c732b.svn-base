//
//  ZTECreateBoardController.m
//  IM
//
//  Created by 周永 on 15/11/16.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "ZTECreateBoardController.h"
#import "BoardContentEditCell.h"
#import "BoardSettigCell.h"
#import "ZTEBoardTypeController.h"
#import "SelectEnterpriseDeptViewController.h"
#import "CustomDefine.h"
#import "Masonry.h"

@interface ZTECreateBoardController ()<UITextFieldDelegate,UITextViewDelegate>{
    
    BOOL boardCreateBtnClicked;
    
}

@property (nonatomic, copy  ) NSMutableString       *boardScope;               //公告发送范围
@property (nonatomic, copy  ) NSString       *department;               //落款部门
@property (nonatomic, copy  ) NSString       *boardTypeName;            //公告类型
/**
 *  发公告需要的字段
 */
@property (nonatomic, copy  ) NSString       *boardTitle; ;             //小黑板标题
@property (nonatomic, copy  ) NSString       *boardContent;             //小黑板内容
@property (nonatomic, strong) NSNumber       *boardTypeID;              //公告类型ID
@property (nonatomic, strong) NSNumber       *deptCid;                  //落款部门cid
@property (nonatomic, strong) NSMutableArray *deptList;                 //小黑板部门范围列表(部门cid)
@property (nonatomic, strong) UITextView     *contentTextView;
//发送范围
@property (nonatomic, strong) NSMutableArray        *allDeptsRange;   //发送范围
@property (nonatomic, strong) NSArray  *allSelectedRows;  //发送范围界面已经选择的行 如果再次进入选择范围 已经被选中

@end

@implementation ZTECreateBoardController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.scrollEnabled = NO;
    self.title = LOCALIZATION(@"board_create");
    
    boardCreateBtnClicked = NO;
    _allDeptsRange = [NSMutableArray array];
    _deptList = [NSMutableArray array];
    _boardScope = [NSMutableString string];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boardTypeDeleted:) name:@"boardTypeDeleted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChangeValue:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated{
    
    
    
}

/**
 *  删除了某一公告类型
 */
- (void)boardTypeDeleted:(NSNotification*)notif{
    
    NSString *boardName = notif.userInfo[@"boardName"];
    
    //如果删除的类型是之前选择的类型
    if ([_boardTypeName isEqualToString:boardName]) {
        
        _boardTypeName = @"";
        
        [self.tableView reloadData];
    }
    
}

- (void)handleKeyboardShow:(NSNotification*)notif{
    
    //获取键盘高度
    NSValue *keyboardRectAsObject=[[notif userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    
    [keyboardRectAsObject getValue:&keyboardRect];
    
    if ([self.contentTextView isFirstResponder]) {
        self.tableView.contentOffset = CGPointMake(0, 150.0);
    }else{
        self.tableView.contentOffset = CGPointMake(0, 100.0);
    }
    
}

- (void)handleKeyboardHide:(NSNotification*)noti{
    
    self.tableView.contentOffset = CGPointMake(0, 0);
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    }else {
        return 1;
    }
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (indexPath.section != 1) {
        
        static NSString *reuseId = @"Cell";
        BoardSettigCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        
        if (!cell) {
            cell = [[BoardSettigCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        }
        
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.textLabel.text = LOCALIZATION(@"board_type");
                
                if (_boardTypeName) {
                    
                    cell.detailLabel.text = _boardTypeName;
                    
                }
                
            }else{
                cell.textLabel.text = LOCALIZATION(@"board_range");
                
                if (_boardScope) {
                    cell.detailLabel.text = _boardScope;
                }
            }
        }
        
        if (indexPath.section == 2) {
            cell.textLabel.text = LOCALIZATION(@"board_dept");
            
            if (_department) {
                cell.detailLabel.text = _department;
            }
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        
        
        static NSString *reuseId = @"boardCell";
        
        BoardContentEditCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        
        if (!cell) {
            cell = [[BoardContentEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleField.delegate = self;
        [cell.titleField addTarget:self action:@selector(textFieldChangedValue:) forControlEvents:UIControlEventEditingChanged];
        
        _contentTextView = cell.boardTextView;
        
        [self addKeyboardExtension];
        
        return cell;
    }
    
    
}

- (void)addKeyboardExtension{
    
    UIView *keyBoardTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
    keyBoardTopView.backgroundColor = [UIColor lightGrayColor];
    //initWithFrame:CGRectMake(keyBoardTopView.bounds.size.width - 100 - 12, 4, 100, 36)
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
//    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    
    [btn setTitle:LOCALIZATION(@"Finished") forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(onKeyBoardDown:) forControlEvents:UIControlEventTouchUpInside];
    
    [keyBoardTopView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(keyBoardTopView.mas_top);
        make.right.equalTo(keyBoardTopView.mas_right).with.offset(-10);
        make.bottom.equalTo(keyBoardTopView.mas_bottom);
    }];
    
    _contentTextView.inputAccessoryView = keyBoardTopView;
    
}

- (void)onKeyBoardDown:(UIButton*)btn{
    
    [_contentTextView resignFirstResponder];
    
}

#pragma mark - UITableViewDelegate 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        return 200.0;
        
    }else{
        
        return 44.0;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 200.0;
    }else{
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}


- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    
    if (section == 2) {
        
        UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        publishBtn.layer.masksToBounds = YES;
        publishBtn.layer.cornerRadius = 5.0;
        publishBtn.backgroundColor = MainColor;
        [publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        publishBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [publishBtn setTitle:LOCALIZATION(@"board_send") forState:UIControlStateNormal];
        [publishBtn addTarget:self action:@selector(createBoardButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        publishBtn.frame = CGRectMake(10, 20, self.view.frame.size.width - 10 * 2, 40.0);
        
        [view addSubview:publishBtn];
        
    }
    
    return view;
}

#pragma mark -  UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        
        
        if (indexPath.row == 0) {//公告类型
            
            [self getBoardTyepFromServer];
            
        }
        
    }
    
    if (indexPath.section == 2 || indexPath.row == 1) {//落款部门 发送范围
        
        SelectEnterpriseDeptViewController *selectEnterpriseDeptVC = [[SelectEnterpriseDeptViewController alloc] init];
        
        if (indexPath.row == 1) {
            
            selectEnterpriseDeptVC.canMultiselect = YES;
            selectEnterpriseDeptVC.allSelectedRows = [NSMutableArray arrayWithArray:_allSelectedRows];
            selectEnterpriseDeptVC.allSelectBlock = ^(NSDictionary *allSelectedDepts){

                [self getDataFromAllSelectedDepts:allSelectedDepts];
                [self.tableView reloadData];
        
            };
            
        }else{
            selectEnterpriseDeptVC.canMultiselect = NO;
        }
        
        GQNavigationController *selectDeptVCNav =[[GQNavigationController alloc] initWithRootViewController:selectEnterpriseDeptVC];
        [self presentViewController:selectDeptVCNav animated:YES completion:nil];
        
        if (indexPath.section == 2) {
            
            selectEnterpriseDeptVC.selectBlock=^(MEnterpriseDept *sDept){
                
                //落款部门
                _department = sDept.cname;
                _deptCid = [NSNumber numberWithInt:sDept.cid.intValue];
                
                
                [self.tableView reloadData];
                
            };
            
        }

    }
    
    
}

- (void)getDataFromAllSelectedDepts:(NSDictionary*)allSelectedDepts{
    
    _deptList = [NSMutableArray array];
    
    _boardScope = [NSMutableString string];
    
    NSArray *allKeys = [allSelectedDepts allKeys];
    
    for (int i=0; i<allKeys.count; i++) {
        
        NSDictionary *dict = allSelectedDepts[allKeys[i]];
        
        
        if ([dict[@"deptSelected"] boolValue]) {
            
            if ([dict[@"cid"] isEqualToString:@"0"]) {//管理员
                
                [_deptList addObject:@"-1"];
            }else{
                
                [_deptList addObject:dict[@"cid"]];
            }
            
            [_boardScope appendFormat:@"%@ ",dict[@"cname"]];
        }
        
    }
    
    NSLog(@"%@\n%@",_deptList,_boardScope);
    
}

#pragma mark - get board type
/**
 *  从服务器获取公告类型数据
 */
- (void)getBoardTyepFromServer{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *token = [ConfigManager sharedInstance].userDictionary[@"token"];
    NSNumber *page = [NSNumber numberWithInt:1];
    //设置参数
    [parameters setValue:token forKey:@"token"];
    [parameters setValue:page forKey:@"page"];
    
    [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodGetBoardType] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
        if (data) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dic = (NSDictionary *)data;
                NSDictionary * resDic = [dic objectForKey:@"res"];
                if ([resDic objectForKey:@"reCode"] && [[resDic objectForKey:@"reCode"]intValue]==1 ) {//请求成功
                    
                    NSArray *boardTypeArray = dic[@"boradTpye"];
                    
                    ZTEBoardTypeController *boardTypeVC = [[ZTEBoardTypeController alloc] initWithStyle:UITableViewStyleGrouped];
                    
                    boardTypeVC.boardTypeNBlock = ^(NSString *boardTypeName, NSNumber *boardTyepId){
                      
                        _boardTypeName = boardTypeName;
                        
                        _boardTypeID = boardTyepId;
                        
                        [self.tableView reloadData];
                        
                    };
                    
                    boardTypeVC.boardTypeArray = [NSMutableArray arrayWithArray:boardTypeArray];
                    
                    [self.navigationController pushViewController:boardTypeVC animated:YES];
                    
                }
            }
            else{
                
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"formatter_error") isDismissLater:YES];
                
            }
        }
        else{
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"data_nil") isDismissLater:YES];
        }
        
    } failureBlock:^(NSString *description) {
        
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"network_failed") isDismissLater:YES];
        return;
        
    }];
    
    
    
}


#pragma mark - button clicked
/**
 *  创建小黑板按钮点击
 */
- (void)createBoardButtonClicked{
    
    if (boardCreateBtnClicked) {
        
        NSLog(@"点击无效");
        
        return;
        
    }
    
    boardCreateBtnClicked = YES;
    
    _boardContent = _contentTextView.text;
    
    if ([self boardInfoIsValid]) {
        
        [self createBoard];
        
    }
}
/**
 *  判断要发布的公告是否有效
 */
- (BOOL)boardInfoIsValid{
    
    if (_boardTitle != nil && _boardContent != nil && _boardTypeID != nil && _deptCid != nil &&  _deptList != nil) {
        
        if (_boardTitle.length == 0) {
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"board_invalid") isDismissLater:YES];
            boardCreateBtnClicked = NO;
            return NO;
        }
        
        
        if (_boardTitle.length > 20) {
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"board_title_shot") isDismissLater:YES];
            boardCreateBtnClicked = NO;
            return NO;
        }
        
        if (_boardContent.length > 200) {
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"board_title_long") isDismissLater:YES];
            boardCreateBtnClicked = NO;
            return NO;
        }
        
        if (_boardContent.length == 0) {
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"board_invalid") isDismissLater:YES];
            boardCreateBtnClicked = NO;
            return NO;
        }
        
        if (_deptList.count == 0) {
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"board_invalid") isDismissLater:YES];
        }
        
        return YES;

    }
    
    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"board_invalid") isDismissLater:YES];
    boardCreateBtnClicked = NO;
    return NO;
}
/**
 *  创建公告
 */
- (void)createBoard{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *token = [ConfigManager sharedInstance].userDictionary[@"token"];
    //设置参数
    [parameters setValue:token forKey:@"token"];
    [parameters setValue:_boardTypeID forKey:@"boardTypeId"];
    [parameters setValue:_boardTitle forKey:@"title"];
    [parameters setValue:_boardContent forKey:@"content"];
    [parameters setValue:_deptCid forKey:@"deptCid"];
    [parameters setValue:_deptList forKey:@"deptList"];
    
    
//    NSLog(@"创建小黑板参数: %@",parameters);
    
    [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodCreateBoard] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
        
        if (data) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dic = (NSDictionary *)data;
                NSDictionary * resDic = [dic objectForKey:@"res"];
                if ([resDic objectForKey:@"reCode"] && [[resDic objectForKey:@"reCode"]intValue]==1 ) {
                    
                    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"board_publish_success") isDismissLater:YES];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:ZTEBoardSuccessCreatedNotfication object:nil];
                    
                    [self.navigationController popViewControllerAnimated:YES]; 
                }
            }
            else{
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"formatter_error") isDismissLater:YES];
            }
        }
        else{
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"data_nil") isDismissLater:YES];
        }
        
    } failureBlock:^(NSString *description) {
        
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"network_failed") isDismissLater:YES];
        
        boardCreateBtnClicked = NO;
        
        return;
        
    }];
    
    
}


#pragma mark - uitextfield & uitextview delegate


- (void)textFieldDidEndEditing:(UITextField *)textField{
    //标题
    _boardTitle = textField.text;
    
}

- (void)textFieldChangedValue:(UITextField*)textfield{
    UITextRange *selectedRange = [textfield markedTextRange];
    NSString * newText = [textfield textInRange:selectedRange];
    //获取高亮部分
    if(newText.length>0)
        return;
    if (textfield.text.length > 20) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            textfield.text = [textfield.text substringToIndex:20];
            
            [textfield resignFirstResponder];
        });
        
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    
    return YES;
}

- (NSArray*)allSelectedRows{
    
    if (!_allSelectedRows) {
        _allSelectedRows = [[NSArray alloc] init];
    }
    return _allSelectedRows;
}

- (void)textViewDidChangeValue:(NSNotification*)noti{
    
    if (_contentTextView.text.length > 200) {
        
        NSString *text = _contentTextView.text;
        
        _contentTextView.text = [text substringToIndex:200];
        
        [_contentTextView resignFirstResponder];
        
    }
    
    
}




@end







