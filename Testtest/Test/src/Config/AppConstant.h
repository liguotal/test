//
//  AppConstant.h
//  duotin2.0
//
//  Created by Vienta on 4/16/14.
//  Copyright (c) 2014 Duotin Network Technology Co.,LTD. All rights reserved.
//

#ifndef duotin2_0_AppConstant_h
#define duotin2_0_AppConstant_h

//#define API_HOST @"http://a2m.danxinben.com/partnerapi/"                  //正式服务器

#define kNotReachableValue           -1
#define kReachableViaWWANValue       0
#define kReachableViaWiFiValue       1
#define kReachableUnkonwnValue       2

#define globalURL(str) [NSString stringWithFormat:@"http://a2m.danxinben.com/partnerapi/%@",str]

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#define kRequestSuccess 0
//mini多听接口
#define kRecommend               @"miniduotin/recommend"                  //专辑列表数据
#define kAlbumTrack              @"album/track"            //获取节目列表

//UserDefaultKey
#define kRecommendUpdate        @"kRecommendUpdate"             //首页update时间


//本地文件路径
#define kLocalUser      @"appuser.dat"                  //user信息
#define kLocalRecommend @"apprecommend.dat"             //首页推荐信息
#define kLocalChannel   @"appchannel.dat"               //频道页面信息

//渠道信息
#define SRC @"miniduotin_mayi"
#define SECKEY @"o2in53902nawci2onit"

//友盟key
#define UMKEY @"53aaad6956240bdd82004c16"


#define IS_IOS_7 ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)?YES:NO                                       //ios7判断宏定义

#define CREAT_XIB(__IBNAME__)  {[[[NSBundle mainBundle] loadNibNamed:__IBNAME__ owner:nil options:nil] objectAtIndex:0]}    //从xib加载方法
#define StatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)                                    //statusBar高度
#define NaviBarHeight 44                                                                                                    //NavigtionBar高度
#define TabBarHeight  49                                                                                                    //TabBar高度

#define mainscreen [UIScreen mainScreen].bounds

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height                                                           //屏幕高度
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width    

    //屏幕宽度
#define OriginY ((IS_IOS_7) ? (StatusBarHeight + NaviBarHeight) : 0)                                                        //Add视图的origin.Y值
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568 ) < DBL_EPSILON)                 //iPhone5的判断
#define VenderBackgroundColor UIColorToRGB(0xf4f4f4)                                                                        //全局的背景色
#define UIColorToRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]                                                                                                              //将16进制颜色转换为uicolor

#define systemFont(size) [UIFont systemFontOfSize:(float)size]
#define viewBackColor UIColorToRGB(0xf4f4f4)
#define appDelegate  (AppDelegate *)[[UIApplication sharedApplication]delegate]

    //判断url字符串是否有效
#define ISVALIDURLSTRING(urlstr) ((urlstr) && [(urlstr) length]>0 && ![(urlstr) isEqualToString:@"null"] && ![(urlstr) isEqualToString:@"(null)"]) ? urlstr : nil


#if __IPHONE_6_0 // iOS6 and later

#   define kTextAlignmentCenter    NSTextAlignmentCenter
#   define kTextAlignmentLeft      NSTextAlignmentLeft
#   define kTextAlignmentRight     NSTextAlignmentRight

#else // older versions

#   define kTextAlignmentCenter    UITextAlignmentCenter
#   define kTextAlignmentLeft      UITextAlignmentLeft
#   define kTextAlignmentRight     UITextAlignmentRight

#endif

#define StateBarHeight ((IS_IOS_7)?20:0)

#define NavBarHeight ((IS_IOS_7)?64:44)

#define SuitHeightForIos ((IS_IOS_7)?64:0)

#define BottomHeight ((IS_IOS_7)?49:0)

#endif
