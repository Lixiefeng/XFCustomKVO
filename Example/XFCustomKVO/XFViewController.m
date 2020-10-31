//
//  XFViewController.m
//  XFCustomKVO
//
//  Created by Aron1987@126.com on 10/30/2020.
//  Copyright (c) 2020 Aron1987@126.com. All rights reserved.
//

#import "XFViewController.h"
#import "XFKVOViewController.h"
#import "XFCustomKVOViewController.h"

@interface XFViewController ()

@end

@implementation XFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Home";
    
    UIButton *sysKVO = [UIButton buttonWithType:UIButtonTypeSystem];
    sysKVO.frame = CGRectMake(100, 200, 80, 40);
    [sysKVO setTitle:@"系统KVO" forState:UIControlStateNormal];
    [sysKVO addTarget:self action:@selector(onSysKVOAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sysKVO];
    
    UIButton *cusKVO = [UIButton buttonWithType:UIButtonTypeSystem];
    cusKVO.frame = CGRectMake(self.view.frame.size.width - 180, 200, 80, 40);
    [cusKVO setTitle:@"自定义KVO" forState:UIControlStateNormal];
    [cusKVO addTarget:self action:@selector(onCusKVOAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cusKVO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onSysKVOAction:(id)sender {
    XFKVOViewController *vc = [[XFKVOViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onCusKVOAction:(id)sender {
    XFCustomKVOViewController *vc = [[XFCustomKVOViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
