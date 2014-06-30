//
//  AppDelegate.m
//  Test
//
//  Created by 郭江伟 on 14-5-21.
//  Copyright (c) 2014年 guojiangwei. All rights reserved.
//

#import "AppDelegate.h"
#import "DtSDK.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //友盟统计
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    [MobClick startWithAppkey:UMKEY reportPolicy:SEND_INTERVAL   channelId:nil];
        //锁屏播放设置
    [[DtSDK sharedManager] lockScreenInfo];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    //后台播放
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setDelegate: self];
    
    //耳机以及电话方法
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, audioRouteChangeCallback, (__bridge void *)(self));
    
    self.window.rootViewController = [DtSDK rootViewController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark -
#pragma mark - AVAudioSessionDelege

-(void) beginInterruption {
    
    if ([TrackController sharedManager].player.playState == NCMusicEnginePlayStatePlaying) {
        interruptedWhilePlaying = YES;
        [[TrackController sharedManager].player pause];
    }
}

- (void) endInterruption {
    
    NSError *activationError = nil;
    
    if (interruptedWhilePlaying) {
        [[AVAudioSession sharedInstance] setActive: YES error: &activationError];
        interruptedWhilePlaying = NO;
        [[TrackController sharedManager].player resume];
    }
}

#pragma mark -
#pragma mark - 监听耳机插入和拔出

- (BOOL)isHeadphone
{
    UInt32 propertySize = sizeof(CFStringRef);
    CFStringRef state   = nil;
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute ,&propertySize,&state);
    
    //根据状态判断是否为耳机状态
    if ([(__bridge NSString *)state isEqualToString:@"Headphone"] ||[(__bridge NSString *)state isEqualToString:@"HeadsetInOut"])
        return YES;
    else
        return NO;
}

void audioRouteChangeCallback(void *inClientData, AudioSessionPropertyID inID, UInt32 inDataSize, const void *inData)
{
    
    SInt32 routeChangeReason;
    CFDictionaryRef routeChangeDictionary = inData;
    CFNumberRef routeChangeReasonRef      = CFDictionaryGetValue(routeChangeDictionary, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
    
    CFNumberGetValue(routeChangeReasonRef, kCFNumberSInt32Type, &routeChangeReason);
    
    NSLog(@"%@",@(routeChangeReason));
    if (routeChangeReason      == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {  //拔掉
        [[TrackController sharedManager].player pause];
    }
}


#pragma mark -
#pragma mark - 锁屏
    //锁屏播放需要实现
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

/**
 * @函数名称：remoteControlReceivedWithEvent:
 * @修改:yinlinlin@duotin.com
 * @函数描述：处理锁屏播放按钮点击事件
 * @输入参数：(UIEvent *)event，点击的具体信息
 * @输出参数：根据点击的按钮，处理上一首，下一首，播放，暂停方法
 * @返回值：void
 */
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay://100
            {
                [[TrackController sharedManager] playPauseAction];
                [[TrackController sharedManager] updateControls];
                break;
            }
            case UIEventSubtypeRemoteControlPause://101
            {
                [[TrackController sharedManager] playPauseAction];
                [[TrackController sharedManager] updateControls];
                break;
            }
            case UIEventSubtypeRemoteControlTogglePlayPause://103
            {
                [[TrackController sharedManager] playPauseAction];
                [[TrackController sharedManager] updateControls];
                break;
            }
            case UIEventSubtypeRemoteControlPreviousTrack:
            {
                    //播放上一首
                [[TrackController sharedManager] lastAction];
                break;
            }
            case UIEventSubtypeRemoteControlNextTrack:
            {
                
                    //播放下一首
                [[TrackController sharedManager] nextAction];
                break;
            }
            default:
            {
                break;
            }
        }
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
