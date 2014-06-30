//
//  DtSDK.m
//  DtSDK
//
//  Created by 郭江伟 on 14-5-20.
//  Copyright (c) 2014年 guojiangwei. All rights reserved.
//

#import "DtSDK.h"
#import "MMHead.h"

@implementation DtSDK

+ (DtSDK *)sharedManager
{
    static DtSDK *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

+(UIViewController *)rootViewController
{
    AlbumViewController *albumVC = [[AlbumViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:albumVC];
    return nav;
}

+(UIViewController *)pushViewController
{
    AlbumViewController *albumVC = [[AlbumViewController alloc]init];
    albumVC.hidesBottomBarWhenPushed = YES;
    return albumVC;
}

-(void)lockScreenInfo
{
    _PlayingInfoCenter = [[NSMutableDictionary alloc]init];
}

@end
