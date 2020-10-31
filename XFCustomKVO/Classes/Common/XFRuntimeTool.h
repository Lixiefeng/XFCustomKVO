//
//  XFRuntimeTool.h
//  Pods-XFCustomKVO_Example
//
//  Created by Aron.li on 2020/10/31.
//

#import <Foundation/Foundation.h>
#import <objc/message.h>


NS_ASSUME_NONNULL_BEGIN

@interface XFRuntimeTool : NSObject

/// 根据getter方法名称生成setter方法名称，例如 key --> setKey:
/// @param getterName getter方法名称
+ (NSString *)xf_setterForGetter:(NSString *)getterName;

/// 根据setter方法名称生成getter方法名称，例如 set<Key>: --> key
/// @param setterName setter方法名称
+ (NSString *)xf_getterForSetter:(NSString *)setterName;

/// 校验setter方法是否存在，不存在直接抛出错误
/// @param classObj 被校验者
/// @param keyPath 被观察的路径名称
+ (void)judgeSetterMethodFromClass:(Class)classObj keyPath:(NSString *)keyPath;

/// 创建KVO的中间类
/// @param parent 父类Class
/// @param keyPath 被观察的路径名称
/// @param classImp 中间类的class方法实现
/// @param setterImp 中间类的setter方法实现
/// @param deallocImp 中间类的dealloc方法实现
+ (Class)createNotifyingClass:(Class)parent
                  withKeyPath:(NSString *)keyPath
                     classSel:(IMP)classImp
                    setterSel:(IMP)setterImp
                   deallocSel:(IMP)deallocImp;

@end

NS_ASSUME_NONNULL_END
