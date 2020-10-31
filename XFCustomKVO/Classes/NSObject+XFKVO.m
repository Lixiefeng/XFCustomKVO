//
//  NSObject+XFKVO.m
//  Pods-XFCustomKVO_Example
//
//  Created by Aron.li on 2020/10/31.
//

#import "NSObject+XFKVO.h"
#import "XFRuntimeTool.h"
#import "XFKVOInfo.h"


static NSString *const kXFKVOAssiociateKey = @"kXFKVO_AssiociateKey";


@implementation NSObject (XFKVO)

- (void)xf_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath block:(XFCustomKVOBlock)block {
    // 1. 校验是否存在setter方法，没有则直接抛出错误
    [XFRuntimeTool judgeSetterMethodFromClass:[self class] keyPath:keyPath];
    
    // 2. 动态生成【中间类】--> 即被观察对象类的子类
    Class notifyingClass = [XFRuntimeTool createNotifyingClass:[self class] withKeyPath:keyPath classSel:(IMP)xf_class setterSel:(IMP)xf_setter deallocSel:(IMP)xf_dealloc];
    
    // 3. isa指向 --> 让父类的isa指向中间类class
    object_setClass(self, notifyingClass);
    
    // 4.保存观察的相关信息
    /**
     * 因为是分类，利用关联属性保存,
     * 可能存在同时观察多个属性的情况，所以用集合来保存。
     */
    XFKVOInfo *info = [[XFKVOInfo alloc] initWitObserver:observer forKeyPath:keyPath customKVOBlock:block];
    
//    // 4.1 数组保存
//    NSMutableArray *mArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kXFKVOAssiociateKey));
//    if (!mArray) {
//        mArray = [NSMutableArray arrayWithCapacity:1];
//        objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kXFKVOAssiociateKey), mArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//    [mArray addObject:info];
    
    // 4.2 set保存
    NSMutableSet *set = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kXFKVOAssiociateKey));
    if (!set) {
        set = [NSMutableSet set];
        objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kXFKVOAssiociateKey), set, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [set addObject:info];
}

Class xf_class(id self, SEL _cmd) {
    return class_getSuperclass(object_getClass(self));
}

// 根据kvo官方文档，setter方法中需要改变父类的属性值，同时，还需通知观察者，告知值的变化
void xf_setter(id self, SEL _cmd, id newValue) {
    // 1.改变父类的属性值
    // 1.1 根据cmd获取父类的setter方法名称
    NSString *setterName = NSStringFromSelector(_cmd);
    // 1.2获取被观察的属性路径名称
    NSString *keyPath = [XFRuntimeTool xf_getterForSetter:setterName];
    // 1.3 向父类发送setter消息
    void (*xf_msgSendSuper)(void *, SEL , id) = (void *)objc_msgSendSuper;
    struct objc_super superStruct = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self)),
    };
    xf_msgSendSuper(&superStruct, _cmd, newValue);
    
    // 2.回调给观察者
    // 获取旧值
    id oldValue = [self valueForKey:keyPath];
    
//    // 数组
//    NSMutableArray *mArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kXFKVOAssiociateKey));
//    for (XFKVOInfo *info in mArray) {
//        if ([info.keyPath isEqualToString:keyPath] && info.customKVOBlock) {
//            info.customKVOBlock(info.observer, keyPath, oldValue, newValue);
//        }
//    }
    
    // set
    NSMutableSet *set = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kXFKVOAssiociateKey));
    XFKVOInfo *tempInfo = [[XFKVOInfo alloc] initWitObserver:nil forKeyPath:keyPath customKVOBlock:nil];
    XFKVOInfo *targetInfo = [set member:tempInfo];
    if (targetInfo) {
        targetInfo.customKVOBlock(targetInfo.observer, keyPath, oldValue, newValue);
    }
}

void xf_dealloc(id self, SEL _cmd) {
    Class superClass = [self class];
    object_setClass(self, superClass);
}

@end
