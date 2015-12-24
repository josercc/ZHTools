//
//  ZHTools.h
//  ZHTools
//
//  Created by 张行 on 15/12/23.
//  Copyright © 2015年 张行. All rights reserved.
//
/**
 
 张行的工具集(求大家扩展方法壮大类)
 现功能包括
 1.取类私有变量(对象类型和基本类型)
 2.从GIF里面获取到图片数组
 3.对数组和字典扩展  安全的输入和输出
 4.方法交换宏
 */
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
@interface ZHTools : NSObject
/*!
 *  从GIF里面获取里面的图片组
 *
 *  @param data 数据
 *
 *  @return 
 */
+(NSArray *)arrayImagesWithGifData:(NSData *)data;
@end

@interface NSMutableArray (ZHSafeSave)

@end

@interface NSArray (ZHSafeSave)

@end

@interface NSMutableDictionary (ZHSafeSave)

@end

/*!
 *  获取类的私有的基本类型变量(公有的不建议这样获取)
 *
 *  @param id        类的实例->NSObject
 *  @param name      私有变量或者公有变量名字->cont char *
 *  @param type      类型->int/BOOL.....
 *  @param valueName 新的变量名称
 *
 *  @return 私有变量的数值
 */
#define ZH_get_private_value(id,name,type,valueName)\
({\
Ivar var =class_getInstanceVariable([id class], name);\
ptrdiff_t offSize=ivar_getOffset(var);\
unsigned char *_name=(unsigned char *)(__bridge void *)[id class];\
valueName=*((type *)(offSize+_name));\
valueName;\
});
/*!
 *  设置变量的值
 *
 *  @param id    类的实例
 *  @param name  变量的名字
 *  @param value 新的值 对象类型
 *
 *  @return
 */

#define ZH_set_value(id,name,value)\
Ivar var =class_getInstanceVariable([id class], name);\
object_setIvar(id, var, value);

/*!
 *  获取变量的值
 *
 *  @param id        类的实例
 *  @param name      变量的名称
 *  @param valueName 值的名称
 *
 *  @return 值
 */
#define ZH_get_value(id,name,valueName)\
({\
Ivar var =class_getInstanceVariable([id class], name);\
valueName=object_getIvar(id, var);\
valueName;\
});
/*!
 *  交换两个方法
 *
 *  @param methodName1 第一个方法
 *  @param methodName2 第二个方法
 *
 *  @return 
 */
#define ZH_method_exchange(methodName1,methodName2)\
{\
Method m1=class_getInstanceMethod([self class], NSSelectorFromString(methodName1));\
Method m2=class_getInstanceMethod([self class], NSSelectorFromString(methodName2));\
method_exchangeImplementations(m1, m2);\
}
