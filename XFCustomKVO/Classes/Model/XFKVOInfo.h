//
//  XFKVOInfo.h
//  XFCustomKVO
//
//  Created by Aron.li on 2020/10/31.
//

#import <Foundation/Foundation.h>

typedef void(^XFCustomKVOBlock)(id observer, NSString *keyPath, id oldValue, id newValue);


@interface XFKVOInfo : NSObject

@property (nonatomic, weak) NSObject *observer;
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, copy) XFCustomKVOBlock  customKVOBlock;

- (instancetype)initWitObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath customKVOBlock:(XFCustomKVOBlock)block;

@end
