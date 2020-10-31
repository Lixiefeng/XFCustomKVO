//
//  NSObject+XFKVO.h
//  Pods-XFCustomKVO_Example
//
//  Created by Aron.li on 2020/10/31.
//

#import <Foundation/Foundation.h>
#import "XFKVOInfo.h"

/**
 - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
     
 }
 */

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (XFKVO)

- (void)xf_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath block:(XFCustomKVOBlock)block;

@end

NS_ASSUME_NONNULL_END

