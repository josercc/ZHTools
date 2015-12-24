//
//  ZHTools.m
//  ZHTools
//
//  Created by 张行 on 15/12/23.
//  Copyright © 2015年 张行. All rights reserved.
//

#import "ZHTools.h"
#import <ImageIO/ImageIO.h>

@implementation ZHTools
+(NSArray *)arrayImagesWithGifData:(NSData *)data{
    if (!data) {
        return nil;
    }
    CGImageSourceRef ref=CGImageSourceCreateWithData((__bridge CFDataRef )data, NULL);
    NSUInteger count=CGImageSourceGetCount(ref);
    if (count==1 ) {
        UIImage *image=[UIImage imageWithData:data];
        if (!image) {
            return nil;
        }
        return @[image];
    }else{
        NSMutableArray *array=[NSMutableArray array];
        for (NSUInteger i=0; i<count; i++) {
            CGImageRef imageRef=CGImageSourceCreateImageAtIndex(ref, i, NULL);
            UIImage *image=[UIImage imageWithCGImage:imageRef];
            if (image) {
                [array addObject:image];
            }
        }
        return array;
        
    }
}
@end

@implementation NSMutableArray (ZHSafeSave)
+(void)load{
    ZH_method_exchange(@"addObject:", @"ZH_addObject:");
    ZH_method_exchange(@"setObject:atIndexedSubscript:", @"ZH_setObject:atIndexedSubscript:");

}
-(void)ZH_addObject:(id)anObject{//安全的输入
    if (anObject) {
        [self ZH_addObject:anObject];
    }
}
-(void)ZH_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx{//安全的字面量赋值
    if (obj) {
        [self ZH_setObject:obj atIndexedSubscript:idx];
    }
}

@end

@implementation NSArray (ZHSafeSave)
+(void)load{
    ZH_method_exchange(@"objectAtIndex:", @"ZH_objectAtIndex:");
    ZH_method_exchange(@"objectAtIndexedSubscript:", @"ZH_objectAtIndexedSubscript:");
    
}
-(id)ZH_objectAtIndexedSubscript:(NSUInteger)idx{
    if (self.count>idx) {
        return [self ZH_objectAtIndexedSubscript:idx];
    }
    return nil;
}
-(id)ZH_objectAtIndex:(NSUInteger)index{
    if (self.count>index) {
        return [self ZH_objectAtIndex:index];
    }
    return nil;
}

@end

@implementation NSMutableDictionary (ZHSafeSave)
+(void)load{
    ZH_method_exchange(@"setObject:forKey:", @"ZH_setObject:forKey:");
    ZH_method_exchange(@"setObject:forKeyedSubscript:", @"ZH_setObject:forKeyedSubscript:");
    
}
-(void)ZH_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key{
    if (obj) {
        [self ZH_setObject:obj forKeyedSubscript:key];
    }
}
-(void)ZH_setObject:(id)anObject forKey:(id<NSCopying>)aKey{
    if (anObject) {
        [self ZH_setObject:anObject forKeyedSubscript:aKey];
    }
}


@end
