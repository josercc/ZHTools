//
//  ZHNetworkDataManger.h
//  HuiXin
//
//  Created by 张行 on 16/1/4.
//  Copyright © 2016年 惠卡世纪. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,ZHNetworkDataStatus){
    ZHNetworkDataStatusNoNetwork=0,//无网络 如果有2G 3G 4G 或者WIFI图标 依然无法打开百度依然是没网
    ZHNetworkDataStatus2G=1,//2G
    ZHNetworkDataStatus3G=2,//3G
    ZHNetworkDataStatus4G=3,//4G
    ZHNetworkDataStatusWifi=5//Wifi
};
/*!
 *  查询网络状态的回调
 *
 *  @param status 状态
 */
typedef void(^SearchDataTypeDidComplete)(ZHNetworkDataStatus status);

///查询网络的状态 必须存在状态栏 不然无法获取到
@interface ZHNetworkDataManger : NSObject
//单利
+(instancetype)shareManger;
/*!
 *  输出状态
 *
 *  @param status 状态
 *
 *  @return 状态格式化
 */
+(NSString *)ZHNetworkDataStatusString:(ZHNetworkDataStatus)status;
/*!
 *  查询单次网络状态
 *
 *  @param complete 回调
 */
-(void)seachDataNetworkStatusComplete:(SearchDataTypeDidComplete)complete;
/*!
 *  采用轮询查询
 *
 *  @param complete 回调
 */
-(void)runloopSearchDataNetworkStatusComplete:(SearchDataTypeDidComplete)complete;

/*!
 *  停止轮询
 */
-(void)stopRunloop;

@end
