//
//  MMHead.h
//  CollectionView
//
//  Created by 郭江伟 on 14-5-9.
//
//

#ifndef MMHead_h
#define MMHead_h

#import "AlbumModel.h"
#import "TrackModel.h"
#import "AppConstant.h"
#import "UIImageView+WebCache.h"
#import "Comment.h"
#import "AudioPlayer.h"
#import "MJRefresh.h"
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import "AlbumViewController.h"
#import "TrackController.h"
#import "dtlib.h"
#import "NCMusicEngine.h"
#import "MobClick.h"

    //********************************************************************
    //**************************颜色设置************************************
#define NAVCOLOR UIColorToRGB(0xb6b6b6)
#define BGCOLOR UIColorToRGB(0xe7e7e7)
#define SELCOLOR UIColorToRGB(0x006eff)
#define UNSELCOLOR [UIColor blackColor]
#define DESCOLOR UIColorToRGB(0x858585)
#define LINECOLOR [UIColor colorWithRed:101/255.0 green:101/255.0 blue:101/255.0 alpha:1.0]

    //**************************颜色设置 end************************************
    //********************************************************************

#endif

