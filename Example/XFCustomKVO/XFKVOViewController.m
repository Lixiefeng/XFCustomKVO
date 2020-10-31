//
//  XFKVOViewController.m
//  XFCustomKVO_Example
//
//  Created by Aron.li on 2020/10/31.
//  Copyright © 2020 Aron1987@126.com. All rights reserved.
//

#import "XFKVOViewController.h"
#import "XFPerson.h"

@interface XFKVOViewController ()

@property (nonatomic, strong) XFPerson *person;

@end

@implementation XFKVOViewController

- (void)dealloc {
    [self.person removeObserver:self forKeyPath:@"name"];
    NSLog(@"=-=-=- %s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统KVO";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.person = [[XFPerson alloc] init];
    [self.person addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew) context:NULL];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.person.name = @"system KVO";
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"=-=-=-观察到属性是%@，值为%@", keyPath, change);
}

@end
