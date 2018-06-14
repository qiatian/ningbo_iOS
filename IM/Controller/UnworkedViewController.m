//
//  UnworkedViewController.m
//  IM
//
//  Created by zuo guoqing on 15-1-21.
//  Copyright (c) 2015年 zuo guoqing. All rights reserved.
//

#import "UnworkedViewController.h"

@interface UnworkedViewController ()

@end

@implementation UnworkedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.centerButton.hidden=NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if([UIScreen mainScreen].bounds.size.height > 480)
    {
        [self.ivMain setImage:[UIImage imageNamed:@"default_developing"]];
    }
    else
    {
        [self.ivMain setImage:[UIImage imageNamed:@"default_developing_480"]];
    }
    self.ivMain.contentMode =UIViewContentModeScaleToFill;
//    self.labMain.text =@"此模块正在努力开发测试中，敬请期待";
    ILBarButtonItem *leftItem =[ILBarButtonItem barItemWithBackItem:@"返回" target:self action:@selector(clickedLeftItem:)];
    self.navigationItem.leftBarButtonItem =leftItem;
}

-(void)clickedLeftItem:(id)sender{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
