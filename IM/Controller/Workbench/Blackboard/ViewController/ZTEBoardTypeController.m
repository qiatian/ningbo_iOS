//
//  ZTEBoardTypeController.m
//  IM
//
//  Created by 周永 on 15/11/17.
//  Copyright © 2015年 zuo guoqing. All rights reserved.
//

#import "ZTEBoardTypeController.h"
#import "ZTENewBoardTypeController.h"
#import "SettingDetailCell.h"

typedef void (^addTypeBlock)(NSString *newTyepName,NSDictionary *dict);

@interface ZTEBoardTypeController ()

@property (nonatomic, strong) NSMutableArray *systemBoardType;      //存放内置公告 不可删除
@property (nonatomic, strong) NSMutableArray *customBoardType;      //自定义公告

@property (nonatomic, strong) NSIndexPath *deleteIndexPath;

@end

@implementation ZTEBoardTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LOCALIZATION(@"board_type");
    [self processTypeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - type data process

//处理传过来的数据
- (void)processTypeData{
    
    _systemBoardType = [NSMutableArray array];
    _customBoardType = [NSMutableArray array];
    
    for (int i=0; i<_boardTypeArray.count; i++) {
        
        if ([_boardTypeArray[i][@"default"] isEqualToString:@"true"] || [_boardTypeArray[i][@"isDefault"] isEqualToString:@"true"]) {
            
            [_systemBoardType addObject:_boardTypeArray[i][@"boardName"]];
            
        }else{
            
            [_customBoardType addObject:_boardTypeArray[i][@"boardName"]];
            
        }
        
    }

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _customBoardType.count + _systemBoardType.count;
    }else{
        
        return 1;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *sysReuseId = @"SystemBoardCell";
    static NSString *customReuseId = @"CustomBoardCell";
    static NSString *addBoardReuseId = @"AddBoardCell";
    
    if (indexPath.section == 0) {
        
        if (indexPath.row < _systemBoardType.count) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sysReuseId];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sysReuseId];
            }
            
            cell.textLabel.text = _systemBoardType[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
            
        }else{
            
            SettingDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:customReuseId];
            
            if (!cell) {
                cell = [[SettingDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customReuseId];
            }
            
            cell.textLabel.text = _customBoardType[indexPath.row - _systemBoardType.count];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteBoardType:)];
            cell.CheckImageView.image = [UIImage imageNamed:@"delete.png"];
            //扩展一下删除按钮的点击范围
            [cell.btnExtensionView addGestureRecognizer:tap];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        
    }else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addBoardReuseId];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addBoardReuseId];
        }
        
        cell.textLabel.text = LOCALIZATION(@"board_create_type");
        cell.imageView.image = [UIImage imageNamed:@"add"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        //回调选中的公告类型名称
        NSString *selectedBoardType = selectedBoardType = _boardTypeArray[indexPath.row][@"boardName"];
        
        NSNumber *typeId = _boardTypeArray[indexPath.row][@"boardTypeId"];
        
        self.boardTypeNBlock(selectedBoardType,typeId);
        
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }else{
        
        ZTENewBoardTypeController *newBoardTypeVC = [[ZTENewBoardTypeController alloc] initWithStyle:UITableViewStyleGrouped];
        
        newBoardTypeVC.addTypeBlock = ^(NSString *newTypeName,NSDictionary *dict){
            
            [_customBoardType addObject:newTypeName];
            
            [_boardTypeArray addObject:dict];
            
            [self.tableView reloadData];
            
        };
        
        newBoardTypeVC.typeExistedArray = [self existedArray];
        
        [self.navigationController pushViewController:newBoardTypeVC animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

#pragma mark - private method

//获取已经存在的公告名称
- (NSArray*)existedArray{
    
    NSMutableArray *existedTypeArray = [NSMutableArray array];
    
    for (int i = 0; i < _systemBoardType.count; i++) {
        
        [existedTypeArray addObject:_systemBoardType[i]];
        
    }
    
    for (int i = 0; i< _customBoardType.count; i++) {
        
        [existedTypeArray addObject:_customBoardType[i]];
        
    }
    
    return existedTypeArray;
    
}

- (void)deleteBoardType:(UITapGestureRecognizer*)tap{
    
    NSLog(@"删除");
    
    CGPoint point = [tap locationInView:self.tableView];
    //点击的cell是哪一个
    _deleteIndexPath = [self.tableView indexPathForRowAtPoint:point];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOCALIZATION(@"notice") message:LOCALIZATION(@"type_delete") delegate:self cancelButtonTitle:LOCALIZATION(@"discover_cancel") otherButtonTitles:LOCALIZATION(@"Message_Sure_Del"), nil];

    
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        //删除数据
        [_customBoardType removeObjectAtIndex:(_deleteIndexPath.row - _systemBoardType.count)];

//        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
        //从服务器删除
        [self deleteBoardTypeFromServer:_deleteIndexPath];
        
    }
    
}

/**
 *  从服务器删除 类型
 */
- (void)deleteBoardTypeFromServer:(NSIndexPath*)indexPath{
    
    NSNumber *boardTypeId = _boardTypeArray[indexPath.row][@"boardTypeId"];
    
    
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *token = [ConfigManager sharedInstance].userDictionary[@"token"];
    //设置参数
    [parameters setValue:token forKey:@"token"];
    [parameters setValue:boardTypeId forKey:@"boardTypeId"];
    
    [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodDeleteBoardType] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
        if (data) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dic = (NSDictionary *)data;
                NSDictionary * resDic = [dic objectForKey:@"res"];
                if ([resDic objectForKey:@"reCode"] && [[resDic objectForKey:@"reCode"]intValue]==1 ) {
                    //发送删除通知 如果已选择公告是这个类型 相应的要删除
                    NSString *boardName = _boardTypeArray[indexPath.row][@"boardName"];
                    NSDictionary *boardTypeDict = [NSDictionary dictionaryWithObject:boardName forKey:@"boardName"];
                    
                    [_boardTypeArray removeObjectAtIndex:indexPath.row];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"boardTypeDeleted" object:nil userInfo:boardTypeDict];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.tableView reloadData];
                        
                    });
                    
                }
            }
            else{
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"formatter_error") isDismissLater:YES];
            }
        }
        else{
            [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"data_failed_delete") isDismissLater:YES];
        }
        
    } failureBlock:^(NSString *description) {
        
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"network_failed") isDismissLater:YES];
        return;
        
    }];
    
}

@end












