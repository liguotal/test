//
//  TrackController.h
//  DuotinSDK
//
//  Created by 郭江伟 on 14-5-14.
//  Copyright (c) 2014年 guojiangwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCMusicEngine.h"

@interface TrackController : UIViewController<UITableViewDataSource,UITableViewDelegate,NCMusicEngineDelegate,UIAlertViewDelegate>
{
    UILabel *titleLabel;
}

@property (strong, nonatomic) IBOutlet UILabel *rightLabel;
@property (strong, nonatomic) IBOutlet UILabel *leftLabel;
@property (strong, nonatomic) IBOutlet UITableView *trackTbView;
@property (strong, nonatomic) IBOutlet UIButton *playBtn;
@property (strong, nonatomic) IBOutlet UIImageView *albumImageView;
@property (strong, nonatomic) IBOutlet UIImageView *backImageView;
@property (strong, nonatomic) IBOutlet UISlider *playSlider;
@property (strong, nonatomic) NSMutableArray *trackMuArray;
@property (nonatomic, strong) AlbumModel *album;
@property (nonatomic, assign) NSInteger playIndex;
@property (nonatomic, strong) MJRefreshFooterView *footer;
@property (strong, nonatomic) IBOutlet UIImageView *tipWindow;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;
@property (strong, nonatomic) IBOutlet UIButton *tipClose;
@property (strong, nonatomic) TrackModel *trackModel;
@property (weak, nonatomic) IBOutlet UIProgressView *cashProgressView;
@property (strong, nonatomic) NCMusicEngine *player;

- (IBAction)sliderChange;

- (IBAction)playPauseAction;

//- (IBAction)sendAppStore;
-(void)playMusic;
- (IBAction)closeAction;
- (IBAction)toAppStore;
-(void) updateControls;
-(void)nextAction;
-(void)lastAction;

+ (TrackController *)sharedManager;

-(void)getAlbumTrackData:(NSInteger)last_data_order andAlbumID:(NSInteger)album_id;

@end
