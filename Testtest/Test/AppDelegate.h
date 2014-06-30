//
//  AppDelegate.h
//  Test
//
//  Created by 郭江伟 on 14-5-21.
//  Copyright (c) 2014年 guojiangwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,AVAudioSessionDelegate>
{
    BOOL interruptedWhilePlaying;
}
@property (strong, nonatomic) UIWindow *window;

@end
