//
//  Comment.m
//  DuotinSDK
//
//  Created by 郭江伟 on 14-5-13.
//  Copyright (c) 2014年 guojiangwei. All rights reserved.
//

#import "Comment.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Comment

+(NSString *)currentTime
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    return timeString;
}

+ (UIButton *)navigationPlayButtonItem
{
    UIButton* playbutton=[UIButton  buttonWithType:UIButtonTypeCustom];
    [playbutton setFrame:CGRectMake(229, 4.5, 75, 35)];
    [playbutton setImage:[UIImage imageNamed:@"push_general"] forState:UIControlStateNormal];
    [playbutton setImageEdgeInsets:UIEdgeInsetsMake(7, 63, 7, 0)];
    [playbutton setTitle:@"播放中" forState:UIControlStateNormal];
    [playbutton setTitleColor:UIColorToRGB(0xffffff) forState:UIControlStateNormal];
    playbutton.titleLabel.font = systemFont(14.0);
    [playbutton setTitleEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 15)];
    
    return playbutton;
}

    //32位MD5加密方式
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

+ (void)removeFolderContent:(NSString *)folderPath
{
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    while (fileName = [filesEnumerator nextObject])
    {
        [[NSFileManager defaultManager] removeItemAtPath:[folderPath stringByAppendingPathComponent:fileName] error: nil];
    }
}

/**
 * @函数名称：navigationClearButtonItem
 * @函数描述：添加navigationBar左侧清除按钮
 * @输入参数：void 固定位置
 * @author: guojiangwei@duotin.com
 * @输出参数：UIButton
 * @返回值：UIButton
 */
+ (UIButton *)navigationClearButtonItem
{
    UIButton * clearBu = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearBu setTitle:@"清理" forState:UIControlStateNormal];
    [clearBu setTitleColor:UIColorToRGB(0xffffff) forState:UIControlStateNormal];
    clearBu.titleLabel.font = systemFont(14.0);
    [clearBu setFrame:CGRectMake(250, 20.5, 60, 43)];
//    [clearBu setTitleEdgeInsets:UIEdgeInsetsMake(3, 0, 3, 45)];
    return clearBu;
}

+ (UIButton *)navigationSendItem
{
    UIButton * clearBu = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearBu setTitle:@"反馈" forState:UIControlStateNormal];
//    [clearBu setTitleColor:UIColorToRGB(0xffffff) forState:UIControlStateNormal];
    [clearBu setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    clearBu.titleLabel.font = systemFont(14.0);
    [clearBu setFrame:CGRectMake(0, 20.5, 60, 43)];
    //    [clearBu setImageEdgeInsets:UIEdgeInsetsMake(3, 2, 3, 45)];
    return clearBu;
}


/**
 * @函数名称：navigationBackButtonItemWithOriginx:andOriginY:
 * @函数描述：添加navigationBar左侧通用的返回按钮
 * @输入参数：void 固定位置
 * @author: yinlinlin@duotin.com
 * @输出参数：UIButton
 * @返回值：UIButton
 */
+ (UIButton *)navigationBackButtonItem
{
    UIButton * searchBu = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBu setImage:[UIImage imageNamed:@"back_general"] forState:UIControlStateNormal];
    [searchBu setFrame:CGRectMake(10, 20.5, 60, 43)];
    [searchBu setImageEdgeInsets:UIEdgeInsetsMake(3, 2, 3, 45)];
    return searchBu;
}

/**
 * @函数名称：progressValue
 * @函数描述：转化进度条
 * @输入参数：double
 * @输出参数：N/A
 * @返回值：NSString 返回字符串
 */
+(NSString *)progressValue:(double)value
{
    NSString *resultStr=[NSString stringWithFormat:@"%02d:%02d",(int)value/60,(int)value%60];
    return resultStr;
}

    //评价app
+ (void)commentApp
{
    NSString * url;
    if (IS_IOS_7) {
        url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d", 893143644];
    }
    else{
        url=[NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",893143644];
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

/**
 * @函数名称：checkNetworkStatus
 * @函数描述：检测网络状态
 * @输入参数：N/A
 * @输出参数：N/A
 */
#pragma mark
#pragma mark 检查当前网络是属于哪一种
+(NSInteger)checkNetworkStatus
{
    Reachability *currentReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([currentReach currentReachabilityStatus])
    {
        case NotReachable:
        {
            //            NSLog(@"2.网络中断");
            return kNotReachableValue;
            break;
        }
        case ReachableViaWWAN:
        {
            //            NSLog(@"正在使用3G网络");
            return kReachableViaWWANValue;
            break;
        }
        case ReachableViaWiFi:
        {
            //            NSLog(@"正在使用wifi网络");
            return kReachableViaWiFiValue;
            break;
        }
        default:
        {
            //            NSLog(@"未知情况");
            return kReachableUnkonwnValue;
            break;
        }
    }
}


@end
