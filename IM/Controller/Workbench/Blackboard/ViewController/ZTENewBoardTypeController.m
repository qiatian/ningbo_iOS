//
//  ZTENewBoardTypeController.m
//  IM
//
//  Created by 周永 on 15/11/17.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "ZTENewBoardTypeController.h"

#import "NewBoardTypeCell.h"

@interface ZTENewBoardTypeController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *typeTextField;

@property (nonatomic, copy) NSString *typeName;

@property (nonatomic, assign) BOOL commitClikced;

@end

@implementation ZTENewBoardTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _commitClikced = NO;
    
    UIButton *checkButton = [[UIButton alloc] init];
    [checkButton setBackgroundImage:[UIImage imageNamed:@"nav_save"] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(commitData) forControlEvents:UIControlEventTouchUpInside];
    [checkButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:checkButton];
    
    self.title = LOCALIZATION(@"board_create_type");
    

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChangedValue:) name:UITextFieldTextDidChangeNotification object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuseId = @"Cell";
    
    NewBoardTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    
    if (!cell) {
        cell = [[NewBoardTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    cell.textLabel.text = LOCALIZATION(@"board_type_name");
    cell.textField.placeholder = LOCALIZATION(@"board_type_placeholder");
    
    _typeTextField = cell.textField;
    _typeTextField.delegate = self;
    [_typeTextField addTarget:self action:@selector(textFieldChangedValue:) forControlEvents:UIControlEventEditingChanged];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

//提交新类型
- (void)commitData{
    
    if (!_commitClikced) {
        
        
        if (_typeTextField.text.length > 4) {
            
            _typeName = [_typeTextField.text substringToIndex:4];
            
        }else{
            
            _typeName = _typeTextField.text;
        }
        
        if ([self isBoardTypeNameValid:_typeName]) {//新类型有效
            
            [self updateNewBoardTypeToServer];
            
            
        }
        
    }
    
    
    
}
//判断公告类型是否有效
- (BOOL)isBoardTypeNameValid:(NSString*)typeName{
    
    if (typeName.length == 0 ){//长度不符合
        
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"type_nil") isDismissLater:YES];
        
         _commitClikced = NO;
        
        return NO;
        
    }
    
    for (int i = 0; i<_typeExistedArray.count; i++) {//已经存在
        
        if ([_typeExistedArray[i] isEqualToString:typeName]) {
            
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"type_existed") isDismissLater:YES];
            
             _commitClikced = NO;
            
            return NO;
        }
        
    }
    
     _commitClikced = YES;
    
    return YES;
}

#pragma mark - textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    _typeName = textField.text;
    
    if (_typeName.length > 4) {
        
        _typeName = [_typeName substringToIndex:4];
        
        textField.text = _typeName;
    }
    
    return YES;
    
}



- (void)textFieldChangedValue:(UITextField*)textfield{
    UITextRange *selectedRange = [textfield markedTextRange];
    NSString * newText = [textfield textInRange:selectedRange];
    //获取高亮部分
    if(newText.length>0)
        return;
    if (_typeTextField.text.length >=5) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            _typeTextField.text = [_typeTextField.text substringToIndex:4];
            
            
            if ([_typeTextField isFirstResponder]) {
                [_typeTextField resignFirstResponder];
            }
            
        });
        
        
    }

}

/**
 *  创建新公告类型到服务器
 */
- (void)updateNewBoardTypeToServer{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *token = [ConfigManager sharedInstance].userDictionary[@"token"];
    NSString *boardTypeName = _typeName;
    //设置参数
    [parameters setValue:token forKey:@"token"];
    [parameters setValue:boardTypeName forKey:@"boardTypeName"];
    
    [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodCreateBoardType] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
        if (data) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dic = (NSDictionary *)data;
                NSDictionary * resDic = [dic objectForKey:@"res"];
                if ([resDic objectForKey:@"reCode"] && [[resDic objectForKey:@"reCode"]intValue]==1 ) {
                    
                    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"type_success_created") isDismissLater:YES];
                    //新建类型时返回的是boardTypeName 获取类型时返回的是boardName 所以要转换一下
                    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:dic[@"boardTpye"]];
                    NSString *boardType = newDict[@"boardTypeName"];
                    [newDict setValue:boardType forKey:@"boardName"];
                    //回调
                    self.addTypeBlock(_typeName,newDict);
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
            }
            else{
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"formatter_error") isDismissLater:YES];
            }
        }
        else{
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"no_permission_create_type") isDismissLater:YES];
        }
        
    } failureBlock:^(NSString *description) {
        
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"network_failed") isDismissLater:YES];
        return;
        
    }];

    
    
    
    
}

@end
