//
//  CreatNotiViewController.m
//  IM
//
//  Created by 陆浩 on 15/5/13.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "CreatNotiViewController.h"
#import "SelectEnterpriseUserViewController.h"
#import "UIButton+WebCache.h"
#import "AllUserViewController.h"
#import "AllMettingUserViewController.h"

#define DefaultTag   10000
#define UserButtonDefine   20000

@interface CreatNotiViewController ()<UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate>
{
    UIScrollView *bgScrollerView;
    
    UITextField *titleTextField;
    //UITextView *titleTextField;
    UITextField *hostTextField;
    UITextField *addressTextField;
    UITextView *extraInfoTextView;//备注信息
    UILabel *startTimeLabel;
    UILabel *endTimeLabel;
    
    UILabel *groupNumLabel;
    
    UIDatePicker *startDatePicker;
    UIDatePicker *endDatePicker;
    UIView *userBgView;
    
    UIDatePicker *startPicker;
    UIDatePicker *endPicker;
    UIButton *dateBgAlphaView;
    
    UIScrollView *userScrollView;
}

@end

@implementation CreatNotiViewController

@synthesize userArray;

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        userArray = [[NSMutableArray alloc] init];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor hexChangeFloat:@"f1f1f1"];
    self.navigationItem.title = LOCALIZATION(@"Message_BulkNotification");
    ILBarButtonItem *leftItem=[ILBarButtonItem barItemWithBackItem:nil target:self action:@selector(clickLeftItem:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    ILBarButtonItem *rightItem=[ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_save.png"] selectedImage:[UIImage imageNamed:@"nav_save.png"] target:self action:@selector(clickRightItem:)];
    [self.navigationItem setRightBarButtonItem:rightItem];

    [self configureInfoView];
    [self configureDatePickerView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickLeftItem:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)clickRightItem:(id)sender{
    [self allTextFinishEdit];
    [self sureCreadNoti];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark - Configure View
-(void)configureInfoView
{
    bgScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, viewWithNavNoTabbar)];
    bgScrollerView.backgroundColor = [UIColor clearColor];
    bgScrollerView.delegate = self;
    [self.view addSubview:bgScrollerView];
    
    UIView *view1 = [self configureInputViewWithTitle:LOCALIZATION(@"Message_subject") placeholder:LOCALIZATION(@"Message_please_subjectName")];
    view1.frame = CGRectMake(0, 0, boundsWidth, 43);
    [bgScrollerView addSubview:view1];
    titleTextField = (UITextField *)[view1 viewWithTag:DefaultTag];
    titleTextField.delegate = self;
    //titleTextField.scrollEnabled = YES;  //设置可以拖动
    //titleTextField.autoresizingMask = UIViewAutoresizingFlexibleHeight; //设置自适应高度
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(10, view1.frame.size.height-0.5, boundsWidth-10, 0.5)];
    line1.backgroundColor = [UIColor hexChangeFloat:@"bbbbbb"];
    [view1 addSubview:line1];
    
    UIView *view2 = [self configureInputViewWithTitle:LOCALIZATION(@"Message_compere") placeholder:LOCALIZATION(@"Message_please_subject_comper")];
    view2.frame = CGRectMake(0, view1.frame.size.height+view1.frame.origin.y, boundsWidth, 43);
    [bgScrollerView addSubview:view2];
    hostTextField = (UITextField *)[view2 viewWithTag:DefaultTag];
    hostTextField.text = [[ConfigManager sharedInstance].userDictionary  objectForKey:@"name"];
    hostTextField.userInteractionEnabled = NO;
    
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.frame.size.height-0.5, boundsWidth, 0.5)];
    line2.backgroundColor = [UIColor hexChangeFloat:@"bbbbbb"];
    [view2 addSubview:line2];
    
    UIView *view3 = [self configureDatePickViewWithTitle:LOCALIZATION(@"Message_start") action:@selector(selectStartTime)];
    view3.frame = CGRectMake(0, view2.frame.size.height+view2.frame.origin.y+20, boundsWidth, 43);
    [bgScrollerView addSubview:view3];
    startTimeLabel = (UILabel *)[view3 viewWithTag:DefaultTag];

    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(10, view3.frame.size.height-0.5, boundsWidth-10, 0.5)];
    line3.backgroundColor = [UIColor hexChangeFloat:@"bbbbbb"];
    [view3 addSubview:line3];

    UIView *line3_0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 0.5)];
    line3_0.backgroundColor = [UIColor hexChangeFloat:@"bbbbbb"];
    [view3 addSubview:line3_0];
    
    UIView *view4 = [self configureDatePickViewWithTitle:LOCALIZATION(@"Message_Ending") action:@selector(selectEndTime)];
    view4.frame = CGRectMake(0, view3.frame.size.height+view3.frame.origin.y, boundsWidth, 43);
    [bgScrollerView addSubview:view4];
    endTimeLabel = (UILabel *)[view4 viewWithTag:DefaultTag];

    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, view4.frame.size.height-0.5, boundsWidth, 0.5)];
    line4.backgroundColor = [UIColor hexChangeFloat:@"bbbbbb"];
    [view4 addSubview:line4];
    
    UIView *view5 = [self configureInputViewWithTitle:LOCALIZATION(@"Message_adress") placeholder:LOCALIZATION(@"Message_please_adress")];
    view5.frame = CGRectMake(0, view4.frame.size.height+view4.frame.origin.y+20, boundsWidth, 43);
    [bgScrollerView addSubview:view5];
    addressTextField = (UITextField *)[view5 viewWithTag:DefaultTag];
    
    UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.frame.size.height-0.5, boundsWidth, 0.5)];
    line5.backgroundColor = [UIColor hexChangeFloat:@"bbbbbb"];
    [view5 addSubview:line5];
    
    UIView *line5_0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 0.5)];
    line5_0.backgroundColor = [UIColor hexChangeFloat:@"bbbbbb"];
    [view5 addSubview:line5_0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    startTimeLabel.text = [formatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:5*60]];
    endTimeLabel.text = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:65*60]];
    
    [self configureAndRefreshUserView];
    
    UILabel *extarLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 365, 100, 20)];
    extarLabel.text = LOCALIZATION(@"Message_note");
    extarLabel.textColor = [UIColor darkGrayColor];
    extarLabel.font = [UIFont systemFontOfSize:15.0];
    extarLabel.backgroundColor = [UIColor clearColor];
    [bgScrollerView addSubview:extarLabel];
    
    UIView *view7 = [[UIView alloc] initWithFrame:CGRectMake(0, 365+20, boundsWidth, 500)];
    view7.backgroundColor = [UIColor whiteColor];
    [bgScrollerView addSubview:view7];
    
    extraInfoTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, view7.frame.size.width-20, 100)];
    extraInfoTextView.font = [UIFont systemFontOfSize:15];
    extraInfoTextView.delegate = self;
    [view7 addSubview:extraInfoTextView];

    bgScrollerView.contentSize = CGSizeMake(boundsWidth, boundsHeight+100);
}



//如果输入超过规定的字数30，就不再让输入 (代理方法)
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == titleTextField) {
        if (string.length == 0){
            return YES;
        }
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 30) {
            return NO;
        }
    }
    
    return YES;
}




-(void)configureAndRefreshUserView
{
    if(!userBgView)
    {
        UIButton *view6 = [UIButton buttonWithType:UIButtonTypeCustom];
        view6.frame = CGRectMake(0, 255, boundsWidth, 110);
        view6.backgroundColor = [UIColor whiteColor];
        [view6 addTarget:self action:@selector(seeAllNotiUser:) forControlEvents:UIControlEventTouchUpInside];
        [bgScrollerView addSubview:view6];
        
        UIView *line6 = [[UIView alloc] initWithFrame:CGRectMake(0, view6.frame.size.height-0.5, boundsWidth, 0.5)];
        line6.backgroundColor = [UIColor hexChangeFloat:@"bbbbbb"];
        [view6 addSubview:line6];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 100, 16)];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text =LOCALIZATION(@"Message_Participants");
        [view6 addSubview:titleLabel];
        
        groupNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(boundsWidth-100-30, 6, 100, 16)];
        groupNumLabel.font = [UIFont systemFontOfSize:15];
        groupNumLabel.backgroundColor = [UIColor clearColor];
        groupNumLabel.textColor = [UIColor grayColor];
        groupNumLabel.textAlignment = NSTextAlignmentRight;
        [view6 addSubview:groupNumLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(boundsWidth-10-9, 6, 9, 16)];
        arrowImageView.image = [UIImage imageNamed:@"arrow.png"];
        [view6 addSubview:arrowImageView];
        
        userBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 35, boundsWidth, 75)];
        userBgView.backgroundColor = [UIColor clearColor];
        [view6 addSubview:userBgView];
        
        userScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35, boundsWidth, 75)];
        userScrollView.backgroundColor = [UIColor clearColor];
        userScrollView.showsHorizontalScrollIndicator = NO;
        [view6 addSubview:userScrollView];
        
    }
    
    for(UIView *view in [userBgView subviews])
    {
        [view removeFromSuperview];
    }
    
    NSString *str1 = [NSString stringWithFormat:@"%ld",(unsigned long)self.userArray.count];
    groupNumLabel.text = [str1 stringByAppendingString:LOCALIZATION(@"Message_peopler")];

    
    [self configureUserScrollView];
    
}

- (void)configureUserScrollView{
    
    
    if (userScrollView) {
        [userScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    int userNumber = userArray.count + 1;
    
    userScrollView.contentSize = CGSizeMake(10 + 59 * userNumber, 57);
    
    for (int i = 0; i<=userArray.count; i++) {
        
        {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(10+59*i, 0, 52, 52);
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 26;
            button.tag = UserButtonDefine+i;
            [userScrollView addSubview:button];
            
            if(i == [userArray count])
            {
                [button setImage:[UIImage imageNamed:@"chat_add_user.png"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.origin.x, button.frame.size.height+button.frame.origin.y, button.frame.size.width, userScrollView.frame.size.height-button.frame.size.height-button.frame.origin.y)];
                label.textColor = [UIColor grayColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:13.0f];
                label.backgroundColor = [UIColor clearColor];
                
                MGroupUser *groupUser = [self.userArray objectAtIndex:i];
                
                [button sd_setBackgroundImageWithURL:[NSURL URLWithString:groupUser.bigpicurl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"chat_settingHead.png"]];
                
                label.text = groupUser.uname;
                [userScrollView addSubview:label];
                [button addTarget:self action:@selector(userButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
    }
    
}

-(UIView *)configureInputViewWithTitle:(NSString *)title placeholder:(NSString *)placeholder{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, boundsWidth, 43)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 80, 20)];
    titleLabel.font = [UIFont systemFontOfSize:15.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    [view addSubview:titleLabel];
    
    UITextField *tempTextField = [[UITextField alloc] initWithFrame:CGRectMake(70, 2, boundsWidth-10-70, 40)];
    tempTextField.placeholder = placeholder;
    tempTextField.textColor = [UIColor grayColor];
    tempTextField.textAlignment = NSTextAlignmentRight;
    tempTextField.font = [UIFont systemFontOfSize:15.0f];
    tempTextField.tag = DefaultTag;
    tempTextField.delegate = self;
    [view addSubview:tempTextField];
    
    return view;
}


-(UIView *)configureDatePickViewWithTitle:(NSString *)title action:(SEL)action
{
    UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
    view.frame = CGRectMake(0, 0, boundsWidth, 43);
    view.backgroundColor = [UIColor whiteColor];
    [view addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 50, 20)];
    titleLabel.font = [UIFont systemFontOfSize:15.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    [view addSubview:titleLabel];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 6, boundsWidth-10-70, 30)];
    dateLabel.textColor = [UIColor grayColor];
    dateLabel.textAlignment = NSTextAlignmentRight;
    dateLabel.font = [UIFont systemFontOfSize:15.0f];
    dateLabel.tag = DefaultTag;
    [view addSubview:dateLabel];

    return view;
}

#pragma mark -
#pragma mark - Button Events
-(void)selectStartTime
{
    NSLog(@"selectStartTime");
    [self showStartDatePicker];
}

-(void)selectEndTime
{
    NSLog(@"selectEndTime");
    [self showEndDatePicker];
}

-(void)userButtonClick:(UIButton *)sender
{
    NSInteger index = sender.tag - UserButtonDefine;
    MGroupUser *groupUser = [self.userArray objectAtIndex:index];
    EnterpriseUserCardViewController *userCard =[[EnterpriseUserCardViewController alloc] initWithNibName:@"EnterpriseUserCardViewController" bundle:[NSBundle mainBundle]];
    userCard.user = groupUser;
    [self.navigationController pushViewController:userCard animated:YES];
}

-(void)addButtonClick:(UIButton *)sender
{
    SelectEnterpriseUserViewController *selectUserVC =[[SelectEnterpriseUserViewController alloc] init];
    NSMutableArray *userIds =[[NSMutableArray alloc] init];
    for (MGroupUser *gu in self.userArray) {
        if (gu && gu.uid && [NSString stringWithFormat:@"%@",gu.uid].length>0) {
            [userIds addObject:gu.uid];
        }
    }
    selectUserVC.disabledContactIds =[NSMutableArray arrayWithArray:userIds];
    [selectUserVC setSelectBlock:^(NSArray *array){
        [self.userArray addObjectsFromArray:array];
        [self configureAndRefreshUserView];
    }];
    selectUserVC.selectGroupUsers = YES;
    GQNavigationController *selectUserVCNav =[[GQNavigationController alloc] initWithRootViewController:selectUserVC];
    [self presentViewController:selectUserVCNav animated:YES completion:^{
    }];
}

-(void)seeAllNotiUser:(UIButton *)sender
{
    [self allTextFinishEdit];
    //查看所有参会人员
    AllMettingUserViewController *vc = [[AllMettingUserViewController alloc] init];
    vc.mettingUserArray = self.userArray;
    vc.isMineMetting = NO;
    vc.canDeleteFirstUser = YES;
    vc.deletedUsersBlock = ^(NSArray *users){
        
        [self.userArray removeObjectsInArray:users];
        
        [self configureAndRefreshUserView];
    };
    
    [vc setRefresheBlock:^(void){
        [self configureAndRefreshUserView];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:NO];
}

#pragma mark -
#pragma mark - Configure DatePickerView
-(void)configureDatePickerView
{
    dateBgAlphaView = [UIButton buttonWithType:UIButtonTypeCustom];
    dateBgAlphaView.frame = self.view.bounds;
    dateBgAlphaView.backgroundColor = [UIColor hexChangeFloat:@"000000" alpha:0.5];
    dateBgAlphaView.alpha = 0;
    [dateBgAlphaView addTarget:self action:@selector(hiddenDatePicker) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:dateBgAlphaView];
    
    startPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, boundsWidth, 200)];
    startPicker.datePickerMode = UIDatePickerModeDateAndTime;
    startPicker.backgroundColor = [UIColor whiteColor];
    startPicker.minimumDate = [[NSDate date] dateByAddingTimeInterval:5*60];//创建会议时间添加5分钟操作时间
    startPicker.date = [[NSDate date] dateByAddingTimeInterval:5*60];
    [startPicker addTarget:self action:@selector(startDatePickerChange:) forControlEvents:UIControlEventValueChanged];
    [dateBgAlphaView addSubview:startPicker];
    
    endPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, boundsWidth, 200)];
    endPicker.backgroundColor = [UIColor whiteColor];
    endPicker.datePickerMode = UIDatePickerModeDateAndTime;
    endPicker.minimumDate = [[NSDate date] dateByAddingTimeInterval:5*60];
    endPicker.date = [NSDate dateWithTimeIntervalSinceNow:65*60];
    [endPicker addTarget:self action:@selector(endDatePickerChange:) forControlEvents:UIControlEventValueChanged];
    [dateBgAlphaView addSubview:endPicker];
}

-(void)showStartDatePicker
{
    [self allTextFinishEdit];
    [self.navigationController.view bringSubviewToFront:dateBgAlphaView];
    [UIView animateWithDuration:0.4 animations:^{
        dateBgAlphaView.alpha = 1;
        startPicker.frame = CGRectMake(0, boundsHeight-200, boundsWidth, 300);
    }];
}

-(void)showEndDatePicker
{
    [self allTextFinishEdit];
    [self.navigationController.view bringSubviewToFront:dateBgAlphaView];
    [UIView animateWithDuration:0.3 animations:^{
        dateBgAlphaView.alpha = 1;
        endPicker.frame = CGRectMake(0, boundsHeight-200, boundsWidth, 300);
    }];
}

-(void)hiddenDatePicker
{
    [UIView animateWithDuration:0.3 animations:^{
        dateBgAlphaView.alpha = 0;
        startPicker.frame = CGRectMake(0, boundsHeight, boundsWidth, 300);
        endPicker.frame = CGRectMake(0, boundsHeight, boundsWidth, 300);
    }];
}

-(void)startDatePickerChange:(UIDatePicker *)picker
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    startTimeLabel.text = [formatter stringFromDate:picker.date];
    endPicker.minimumDate = picker.date;
    if([endPicker.date timeIntervalSince1970]<[endPicker.minimumDate timeIntervalSince1970])
    {
        endPicker.date = endPicker.minimumDate;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        endTimeLabel.text = [formatter stringFromDate:endPicker.minimumDate];
    }
}

-(void)endDatePickerChange:(UIDatePicker *)picker
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    endTimeLabel.text = [formatter stringFromDate:picker.date];
}


#pragma mark -
#pragma mark - UITextField Delegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if(textView == extraInfoTextView)
    {
        bgScrollerView.contentSize = CGSizeMake(boundsWidth, boundsHeight+220);
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == addressTextField)
    {
        if(boundsHeight == 480)
        {
            bgScrollerView.contentSize = CGSizeMake(boundsWidth, boundsHeight+150);
//            [bgScrollerView scrollRectToVisible:CGRectMake(0, bgScrollerView.contentSize.height, boundsWidth, bgScrollerView.contentSize.height) animated:YES];
        }
    }
    else
    {
        bgScrollerView.contentSize = CGSizeMake(boundsWidth, boundsHeight+100);
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)allTextFinishEdit
{
    [titleTextField resignFirstResponder];
    [addressTextField resignFirstResponder];
    [hostTextField resignFirstResponder];
    [extraInfoTextView resignFirstResponder];
}

#pragma mark -
#pragma mark - Cread New Noti Request
-(void)sureCreadNoti
{
//    UITextField *hostTextField;
    
    if([self.userArray count] == 0)
    {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_select_subjectmember") isDismissLater:YES];
        return;
    }
    if(![titleTextField.text length])
    {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_please_subjectName") isDismissLater:YES];
        return;
    }
    if(![addressTextField.text length])
    {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_please_adress") isDismissLater:YES];
        return;
    }
    if(![hostTextField.text length])
    {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_please_subject_comper") isDismissLater:YES];
        return;
    }
    [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_chuangjian_Notification") isDismissLater:NO];

    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(MEnterpriseUser *model in self.userArray)
    {
        [array addObject:[NSString stringWithFormat:@"%@",model.uid]];
    }
    
    
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
    [parameters setObject:[[ConfigManager sharedInstance].userDictionary  objectForKey:@"token"] forKey:@"token"];
    [parameters setObject:titleTextField.text forKey:@"title"];
    [parameters setObject:addressTextField.text forKey:@"address"];
    [parameters setObject:extraInfoTextView.text forKey:@"remark"];
    long long startTime = [[startPicker date] timeIntervalSince1970] * 1000;
    long long endTime = [[endPicker date] timeIntervalSince1970] * 1000;
    
    NSString * startString = [NSString stringWithFormat:@"%@",[startPicker date]];
    NSString * endString = [NSString stringWithFormat:@"%@",[endPicker date]];
    if (startTime/1000 < [[NSDate date] timeIntervalSince1970]) {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_haoduohaoduo") isDismissLater:YES];
        return;
    }
    if ([startString isEqualToString:endString]) {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_time_diffent") isDismissLater:YES];
        return;
    }
    else{
        [parameters setObject:[NSString stringWithFormat:@"%lld",startTime] forKey:@"startTime"];
        [parameters setObject:[NSString stringWithFormat:@"%lld",endTime] forKey:@"endTime"];
    }
    [parameters setObject:array forKey:@"users"];
    
    [HTTPClient asynchronousPostRequest:ApiPrefix method:[HTTPAddress MethodCreateInform] parameters:parameters successBlock:^(BOOL success, id data, NSString *msg) {
//        NSLog(@"%@",data);
        if(data[@"res"])
        {
            NSDictionary *dic = data[@"res"];
            if([dic[@"reCode"] intValue] == 1)
            {
                [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_xinjian_Success") isDismissLater:YES];
                [self.navigationController popViewControllerAnimated:YES];
                [self successCreatNoti];
                if(_successBlock)
                {
                    _successBlock();
                }
            }
            else
            {
                [MMProgressHUD showHUDWithTitle:dic[@"resMessage"] isDismissLater:YES];
            }
        }
    } failureBlock:^(NSString *description) {
        [MMProgressHUD showHUDWithTitle:LOCALIZATION(@"Message_ping_fil") isDismissLater:YES];
    }];
}


-(void)successCreatNoti
{
    MMessage *mm=[[MMessage alloc]init];
    mm.identity =[NSString stringWithFormat:@"%@",[[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"]];
    mm.msgId =[NSString stringWithUUID];
    
    mm.modeltype = @"3";
    mm.contenttype = @"0";
    mm.sendTime =[NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970]*1000];
    NSString *str = LOCALIZATION(@"Message_xinjian_zhuti");
    mm.msg = [str stringByAppendingFormat:@"%@",titleTextField.text];
    mm.keyid = [[ConfigManager sharedInstance].userDictionary objectForKey:@"uid"];
    mm.username = [[ConfigManager sharedInstance].userDictionary objectForKey:@"uname"];
    mm.type = @"1";
    mm.msgOtherName = LOCALIZATION(@"Message_myNotification");
    mm.msgOtherId = NotiOhterId;//瞎鸡巴写一个标记，哈哈
    [[SQLiteManager sharedInstance] insertMessagesToSQLite:[NSArray arrayWithObject:mm] notificationName:NOTIFICATION_R_SQL_MESSAGE];
}

@end
