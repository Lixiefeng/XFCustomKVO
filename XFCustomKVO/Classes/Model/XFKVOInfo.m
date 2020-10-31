//
//  XFKVOInfo.m
//  XFCustomKVO
//
//  Created by Aron.li on 2020/10/31.
//

#import "XFKVOInfo.h"

@implementation XFKVOInfo

- (instancetype)initWitObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath customKVOBlock:(XFCustomKVOBlock)block {
    if (self = [super init]) {
        self.observer = observer;
        self.keyPath = keyPath;
        self.customKVOBlock = block;
    }
    return self;
}

@end
