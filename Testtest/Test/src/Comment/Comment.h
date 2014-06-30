//
//  Comment.h
//  DuotinSDK
//
//  Created by 郭江伟 on 14-5-13.
//  Copyright (c) 2014年 guojiangwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface Comment : NSObject
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString;
+ (NSString *)currentTime;
+(NSString *)progressValue:(double)value;
+ (UIButton *)navigationBackButtonItem;
+ (void)commentApp;
+ (UIButton *)navigationPlayButtonItem;
+ (UIButton *)navigationClearButtonItem;

//清除缓存数据
+ (void)removeFolderContent:(NSString *)folderPath;
+ (UIButton *)navigationSendItem;

//检测网络
+(NSInteger)checkNetworkStatus;
@end
