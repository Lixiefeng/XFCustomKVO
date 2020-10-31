//
//  XFCustomKVOViewController.m
//  XFCustomKVO_Example
//
//  Created by Aron.li on 2020/10/31.
//  Copyright © 2020 Aron1987@126.com. All rights reserved.
//

#import "XFCustomKVOViewController.h"
#import "XFPerson.h"
#import "NSObject+XFKVO.h"

@interface XFCustomKVOViewController ()

@property (nonatomic, strong) XFPerson *person;

@end

@implementation XFCustomKVOViewController

- (void)dealloc {
    NSLog(@"=-=-=- %s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自定义KVO";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.person = [[XFPerson alloc] init];
        
    [self.person xf_addObserver:self forKeyPath:@"name" block:^(id observer, NSString *keyPath, id oldValue, id newValue) {
        NSLog(@"=-=-=-观察到属性是%@，值为%@", keyPath, newValue);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.person.name = @"custom KVO";
}

@end
