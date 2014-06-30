//
//  DtSDK.h
//  DtSDK
//
//  Created by 郭江伟 on 14-5-20.
//  Copyright (c) 2014年 guojiangwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DtSDK : UIResponder
@property (strong, nonatomic) NSMutableDictionary* PlayingInfoCenter;
@property (strong, nonatomic) id delegate;

+(UIViewController *)rootViewController;
+(UIViewController *)pushViewController;
-(void)lockScreenInfo;
+ (DtSDK *)sharedManager;

@end
