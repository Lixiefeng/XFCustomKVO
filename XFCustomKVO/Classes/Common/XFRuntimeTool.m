//
//  XFRuntimeTool.m
//  Pods-XFCustomKVO_Example
//
//  Created by Aron.li on 2020/10/31.
//

#import "XFRuntimeTool.h"


static NSString *const kXFKVOPrefix = @"XFKVONotifying_";

@implementation XFRuntimeTool

+ (NSString *)xf_setterForGetter:(NSString *)getterName {
    if (getterName.length <= 0 || ![getterName hasPrefix:@"get"]) return nil;
    NSString *firstString = [[getterName substringToIndex:1] uppercaseString];
    NSString *leaveString = [getterName substringFromIndex:1];
    
    return [NSString stringWithFormat:@"set%@%@:",firstString,leaveString];
}

+ (NSString *)xf_getterForSetter:(NSString *)setterName {
    if (setterName.length <= 0 || ![setterName hasPrefix:@"set"] || ![setterName hasSuffix:@":"])
        return nil;
    
    NSRange range = NSMakeRange(3, setterName.length-4);
    NSString *getterName = [setterName substringWithRange:range];
    NSString *firstString = [[getterName substringToIndex:1] lowercaseString];
    return  [getterName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstString];
}

+ (void)judgeSetterMethodFromClass:(Class)classObj keyPath:(NSString *)keyPath {
    assert(classObj && keyPath);
    NSString *setterName = [self xf_setterForGetter:keyPath];
    SEL setterSelector = NSSelectorFromString(setterName);
    Method setterMethod = class_getInstanceMethod(classObj, setterSelector);
    if (!setterMethod) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"当前类中没有%@的setter方法",keyPath] userInfo:nil];
    }
}

+ (Class)createNotifyingClass:(Class)parent
                  withKeyPath:(NSString *)keyPath
                     classSel:(IMP)classImp
                    setterSel:(IMP)setterImp
                   deallocSel:(IMP)deallocImp {
    // 1.根据父类名称，生成中间类Class名称
    NSString *parentClassName = NSStringFromClass(parent);
    NSString *childClassName = [NSString stringWithFormat:@"%@%@", kXFKVOPrefix, parentClassName];
    
    // 2.防止重复的中间类
    Class childClass = NSClassFromString(childClassName);
    if (childClass) {
        return childClass;
    }
    
    // 3.开辟内存空间，注册中间类
    childClass = objc_allocateClassPair(parent, childClassName.UTF8String, 0);
    objc_registerClassPair(childClass);
    
    // 3.1 中间类的class方法应该指向父类
    /**
     * 根据KVO官方文档描述，KVO是基于isa-swizzling
     * 所以添加观察之后，父类的class是中间类，即isa指向中间类
     * 中间类的isa指向父类的话，正好它俩的isa做了一个swizzling
     */
    SEL classSEL = NSSelectorFromString(@"class");
    Method classMethod = class_getInstanceMethod(parent, classSEL);
    const char *classMethodType = method_getTypeEncoding(classMethod);
    class_addMethod(childClass, classSEL, classImp, classMethodType);
    
    // 3.2 添加setter方法
    SEL setterSEL = NSSelectorFromString([self xf_setterForGetter:keyPath]);
    Method setterMethod = class_getInstanceMethod(parent, setterSEL);
    const char *setterTypes = method_getTypeEncoding(setterMethod);
    class_addMethod(childClass, setterSEL, setterImp, setterTypes);
    
    // 3.3 override dealloc方法。
    /**
     * 因为中间类的class方法指向的是父类，即中间类的isa指向父类，
     * 根据KVO底层原理，我们知道在移除监听removeObserver之后，被观察者的isa应该指回父类class，
     * 所以，覆写父类的dealloc方法，让isa指回父类，
     * 同时也可以巧妙的在这个覆写的方法里面移除监听，就不用在调用观察的地方显式的调用removeObserver，完成一个自动销毁监听的功能
     */
    SEL deallocSEL = NSSelectorFromString(@"dealloc");
    Method deallocMethod = class_getInstanceMethod(parent, deallocSEL);
    const char *deallocTypes = method_getTypeEncoding(deallocMethod);
    class_addMethod(childClass, deallocSEL, deallocImp, deallocTypes);
    
    return childClass;
}

@end
