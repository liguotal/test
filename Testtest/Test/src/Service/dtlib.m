//
//  dtlib.m
//  test
//
//  Created by 郭江伟 on 14-5-21.
//  Copyright (c) 2014年 guojiangwei. All rights reserved.
//

#import "dtlib.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"

#define ALBUMDIC @"albumDic"
#define TRACKSDIC @"tracksDic"

@implementation dtlib

+(void)getAlbumDataLastData:(NSInteger)last_data_order andDic:(void (^)(NSDictionary *))completeblock
{
    if ([Comment checkNetworkStatus] != kReachableViaWiFiValue) {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:ALBUMDIC];
        dispatch_async(dispatch_get_main_queue(), ^{
            completeblock(dic);
        });
    }
    
    NSString *stringUrl = @"http://a2m.duotin.com/category/album";
    NSURL* url=[NSURL URLWithString:stringUrl];
    ASIFormDataRequest* request=[ASIFormDataRequest requestWithURL:url];

    [request setPostValue:@(last_data_order) forKey:@"last_data_id"];
    [request setPostValue:@(415) forKey:@"category_id"];
    [request setPostValue:@"000000e0-KZPw5Fu6N97oHPisTTtrTQ" forKey:@"mobile_key"];
    [request setPostValue:@"IOS" forKey:@"platform"];
    [request setPostValue:@(-1) forKey:@"sub_category_id"];
    [request setPostValue:@(0) forKey:@"type"];

//    [request setPostValue:SRC forKey:@"src"];
//    [request setPostValue:[Comment getMd5_32Bit_String:[NSString stringWithFormat:@"%@%@",timeStr,SECKEY]] forKey:@"token"];
//    [request setPostValue:@(last_data_order) forKey:@"last_data_order"];
//    [request setPostValue:timeStr forKey:@"timestamp"];
    
    [dtlib requestForm:request dataHandleBlock:^(ASIFormDataRequest * requestBlock){
        if ( nil != requestBlock.error )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completeblock(nil);
            });
        }
        
        NSDictionary *dict = [requestBlock.responseString objectFromJSONString];
        
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:ALBUMDIC];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            completeblock(dict);
            
        });
    }];
}

+(void)getTrackDataLastData:(NSInteger)last_data_order andAlbumId:(NSInteger)album_id andDic:(void (^)(NSDictionary *))completeblock
{
    if ([Comment checkNetworkStatus] != kReachableViaWiFiValue) {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:TRACKSDIC];
        dispatch_async(dispatch_get_main_queue(), ^{
            completeblock(dic);
        });
    }
//    NSString *timeStr = [Comment currentTime];
//    NSString *stringUrl=globalURL(kAlbumTrack);
    NSString *stringUrl = @"http://a2m.duotin.com/album/track";
    NSURL* url=[NSURL URLWithString:stringUrl];
    ASIFormDataRequest* request=[ASIFormDataRequest requestWithURL:url];
    [request setPostValue:@(last_data_order) forKey:@"last_data_order"];
    [request setPostValue:@"000000e0-KZPw5Fu6N97oHPisTTtrTQ" forKey:@"mobile_key"];
    [request setPostValue:@"IOS" forKey:@"platform"];
    [request setPostValue:@(0) forKey:@"sort"];
    [request setPostValue:@(album_id) forKey:@"album_id"];

    [dtlib requestForm:request dataHandleBlock:^(ASIFormDataRequest * requestBlock){
        if ( nil != requestBlock.error )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completeblock(nil);
            });
        }
        
        NSDictionary *dict = [requestBlock.responseString objectFromJSONString];
        
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:TRACKSDIC];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            completeblock(dict);
            
        });
    }];

}

/**
* @函数名称：asy_request
* @函数描述：异步执行HttpRequest
* @输入参数：(ASIFormDataRequest *)request  需要执行的request
*          (void(^)(ASIFormDataRequest *))dataHandleBlock 请求返回后处理数据的block
* @输出参数：N/A
* @返回值：NSString 返回字符串
*/

+ (void)requestForm:(ASIFormDataRequest *)request dataHandleBlock:(void(^)(ASIFormDataRequest *))dataHandleBlock
{
    __weak ASIFormDataRequest *bRequest = request;
    dispatch_async(kBgQueue, ^{
        [bRequest startSynchronous];
        dataHandleBlock(request);
    });
}

@end
