//
//  XFPerson.m
//  XFCustomKVO_Example
//
//  Created by Aron.li on 2020/10/31.
//  Copyright © 2020 Aron1987@126.com. All rights reserved.
//

#import "XFPerson.h"

@implementation XFPerson

- (void)setName:(NSString *)name {
    NSLog(@"=-=-来到 XFPerson 的setter方法 :%@", name);
    _name = name;
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

@end
