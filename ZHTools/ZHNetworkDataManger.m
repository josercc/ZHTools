//
//  ZHNetworkDataManger.m
//  HuiXin
//
//  Created by 张行 on 16/1/4.
//  Copyright © 2016年 惠卡世纪. All rights reserved.
//

#import "ZHNetworkDataManger.h"
NSString *const ZHNSStringBaidu=@"http://www.baidu.com";
NSString *const ZHNSStringStatusBar=@"_statusBar";
NSString *const ZHNSStringForegroundView=@"_foregroundView";
NSString *const ZHNSStringUIStatusBarDataNetworkItemView=@"UIStatusBarDataNetworkItemView";
NSString *const ZHNSStringDataNetworkType=@"_dataNetworkType";
NSUInteger const ZHNetworkTimerCount=1;
static NSTimer *ZHNetworkTimer;
static ZHNetworkDataManger *manger;
static NSMutableArray *oneBlockSets;
static NSMutableArray *RunloopBlocksSets;
typedef void(^ZHNSTimerComplete)(void);

#define KWeakSelf __weak typeof(self) weakSelf=self;
#define KStrongSelf __strong typeof(weakSelf) strongSelf=weakSelf;

@implementation ZHNetworkDataManger{
    ZHNetworkDataStatus _status;
    int _dataType;
    BOOL _checkNetworkSuccess;
    BOOL _isFirst;
    ZHNSTimerComplete _complete;
}
+(instancetype)shareManger{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger=[[ZHNetworkDataManger alloc]init];
        oneBlockSets=[NSMutableArray array];
        RunloopBlocksSets=[NSMutableArray array];
    });
    
    return manger;
}

+(NSString *)ZHNetworkDataStatusString:(ZHNetworkDataStatus)status{
    NSString *statusString;
    if (status==ZHNetworkDataStatusNoNetwork) {
        statusString=@"ZHNetworkDataStatusNoNetwork";
    }else if (status==ZHNetworkDataStatus2G){
        statusString=@"ZHNetworkDataStatus2G";
    }else if (status==ZHNetworkDataStatus3G){
        statusString=@"ZHNetworkDataStatus3G";
    }else if (status==ZHNetworkDataStatus4G){
        statusString=@"ZHNetworkDataStatus4G";
    }else if (status==ZHNetworkDataStatusWifi){
        statusString=@"ZHNetworkDataStatusWifi";
    }
    return statusString;
}
-(void)seachDataNetworkStatusComplete:(SearchDataTypeDidComplete)complete{
    [oneBlockSets addObject:complete];
    _checkNetworkSuccess=YES;
    _isFirst=YES;
    [self searchNetworkDataStatus];
}
-(void)runloopSearchDataNetworkStatusComplete:(SearchDataTypeDidComplete)complete{
    [RunloopBlocksSets addObject:complete];
    _checkNetworkSuccess=YES;
    _isFirst=YES;
    ZHNetworkTimer=[NSTimer scheduledTimerWithTimeInterval:ZHNetworkTimerCount target:self selector:@selector(runloopSearch) userInfo:nil repeats:YES];
    
}
-(void)runloopSearch{
    [self searchNetworkDataStatus];
}
-(void)stopRunloop{
    [ZHNetworkTimer invalidate];
}
-(void)searchNetworkDataStatus{
    if (!_checkNetworkSuccess) {
        return;
    }
    _checkNetworkSuccess=NO;
    UIApplication *app=[UIApplication sharedApplication];
    id statusBarWindow=[app valueForKeyPath:ZHNSStringStatusBar];
    id foregroundView=[statusBarWindow valueForKeyPath:ZHNSStringForegroundView];
    BOOL isFindDataNetworkItemView=NO;
    for (UIView *view in [foregroundView subviews]) {
        if ([view isKindOfClass:NSClassFromString(ZHNSStringUIStatusBarDataNetworkItemView)]) {
            isFindDataNetworkItemView=YES;
            int dataType=[[view valueForKeyPath:ZHNSStringDataNetworkType]intValue];
            if (_isFirst) {
                _dataType=dataType;
                [self TestNetworkWithType:dataType];
                _isFirst=NO;
            }else if (dataType!=_dataType){
                _dataType=dataType;
                [self TestNetworkWithType:dataType];
            }else{
                _checkNetworkSuccess=YES;
            }
            
        }
    }
    if (!isFindDataNetworkItemView) {
        [self dataNetworkStatusFromDataType:0 isHaveNetWork:NO];
    }
}
- (void)TestNetworkWithType:(int)dataType{
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    NSURL* URL = [NSURL URLWithString:ZHNSStringBaidu];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";
    KWeakSelf;
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        KStrongSelf;
        if (error == nil) {
            [strongSelf dataNetworkStatusFromDataType:dataType isHaveNetWork:YES];
        }
        else {
            [strongSelf dataNetworkStatusFromDataType:dataType isHaveNetWork:NO];
        }
    }];
    [task resume];

}
- (void)dataNetworkStatusFromDataType:(NSUInteger)dateType isHaveNetWork:(BOOL)isHaveNetWork{
    _checkNetworkSuccess=YES;
    ZHNetworkDataStatus status=_status;
    if (!isHaveNetWork) {
        _status= ZHNetworkDataStatusNoNetwork;
    }
    if (dateType==1) {
        _status= ZHNetworkDataStatus2G;
    }else if (dateType==2){
        _status= ZHNetworkDataStatus3G;
    }else if (dateType==3){
        _status= ZHNetworkDataStatus4G;
    }else if (dateType==5){
        _status= ZHNetworkDataStatusWifi;
    }
    if (_status==status) {
        return;
    }
    if (RunloopBlocksSets) {
        for (int i=0; i<RunloopBlocksSets.count; i++) {
            SearchDataTypeDidComplete complete=RunloopBlocksSets[i];
            complete(_status);
        }
    }
    if (oneBlockSets) {
        for (int i=0; i<oneBlockSets.count; i++) {
            SearchDataTypeDidComplete complete=oneBlockSets[i];
            complete(_status);
        }
    }
    
    
}

@end
