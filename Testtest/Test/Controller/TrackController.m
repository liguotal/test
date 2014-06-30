//
//  TrackController.m
//  DuotinSDK
//
//  Created by 郭江伟 on 14-5-14.
//  Copyright (c) 2014年 guojiangwei. All rights reserved.
//

#import "TrackController.h"
#import "TrackCell.h"
#import "UICustomLineLabel.h"
#import "DtSDK.h"

@interface TrackController ()
{
        //播放添加
    NSTimer *timer;
    UICustomLineLabel *lineLabel;
}
@end

@implementation TrackController

-(void)dealloc
{
    [_footer free];
    _rightLabel = nil;
    _leftLabel = nil;
    _trackTbView = nil;
    _playBtn = nil;
    _albumImageView = nil;
    _playSlider = nil;
    _trackMuArray = nil;
    _album = nil;
    _tipClose = nil;
    _tipLabel = nil;
    _tipWindow = nil;
    _trackModel = nil;
}

    //播放单例
+ (TrackController *)sharedManager
{
    static TrackController *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initNavigation];
        
        _trackMuArray = [NSMutableArray arrayWithCapacity:100];
        self.backImageView.backgroundColor = NAVCOLOR;
        if (!IS_IOS_7) {
            self.backImageView.frame = CGRectMake(0, 0, 320, 314 + 90);
        }
        self.trackTbView.backgroundColor = BGCOLOR;
        self.tipClose.backgroundColor = [UIColor clearColor];
//        self.leftLabel.textColor = DESCOLOR;
//        self.rightLabel.textColor = DESCOLOR;
//        self.tipLabel.textColor = UNSELCOLOR;
        _player = [[NCMusicEngine alloc] init];
        _player.delegate = self;
        
        //缓存进度条设置
        self.cashProgressView.backgroundColor = [UIColor clearColor]; // 设置背景色
        self.cashProgressView.alpha = 1.0; // 设置透明度 范围在0.0-1.0之间 0.0为全透明
        
        self.cashProgressView.progressTintColor = [UIColor lightGrayColor]; // 设置已过进度部分的颜色
        self.cashProgressView.trackTintColor = [UIColor clearColor];
        
//        [self tipLineAction];
        [self closeAction];
        
        self.trackTbView.separatorStyle = NO;
        [self.playSlider setThumbImage:[UIImage imageNamed:@"play_point_blue"] forState:UIControlStateNormal];
        [self.playSlider setThumbImage:[UIImage imageNamed:@"play_point_blue"] forState:UIControlStateHighlighted];
        [self.playSlider setMinimumTrackImage:[UIImage imageNamed:@"play_slide_on_blue"] forState:UIControlStateNormal];
        [self.playSlider setMaximumTrackImage:[UIImage imageNamed:@"play_slide_clear"] forState:UIControlStateNormal];
        
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(nextAction) name: @"finishContinue" object: nil];
    }
    return self;
}



-(void)tipLineAction
{
    lineLabel = [[UICustomLineLabel alloc]initWithFrame:CGRectMake(188, 82, 100, 20)];
    lineLabel.text = @"多听FM客户端";
    lineLabel.textColor = [UIColor orangeColor];
    lineLabel.font = [UIFont systemFontOfSize:12];
    lineLabel.lineType = LineTypeDown;
    lineLabel.lineColor = [UIColor orangeColor];
    lineLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lineLabel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        //锁屏播放设置
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

-(void)setAlbum:(AlbumModel *)album
{
    if (album.album_id.integerValue == self.album.album_id.integerValue) {
        return;
    }
    self.playIndex = 0;
    if (![_footer superview]) {
        [self addFooter];
    }
    _album = album;
    [self getAlbumTrackData:0 andAlbumID:self.album.album_id.integerValue];
}


- (void)addFooter
{
    __unsafe_unretained TrackController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.trackTbView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [vc refreshMore];
    };
    _footer = footer;
}
#pragma mark- 
#pragma mark - 定制navigation

-(void)initNavigation
{
    UIButton * backBu = [Comment navigationBackButtonItem];
    [self.view addSubview:backBu];
    [backBu addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    
    titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(60, 20 , 200, 44);
    titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
    titleLabel.font = systemFont(17.0);  //设置文本字体与大小
//    titleLabel.textColor = UIColorToRGB(0xffffff);  //设置文本颜色
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = kTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    
    UIButton * sendBu = [Comment navigationClearButtonItem];
    [self.view addSubview:sendBu];
    [sendBu addTarget:self action:@selector(clearFile) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clearFile
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否清除已缓存完成的歌曲？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清理", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesDir = [paths objectAtIndex:0];
        NSString *path = [NSString stringWithFormat:@"%@/com.nickcheng.NCMusicEngine",cachesDir];
        [Comment removeFolderContent:path];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - 返回
- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 * @函数名称：nextAction
 * @函数描述：下一首（播完最后一首，从头播放）
 * @输入参数：N/A
 * @输出参数：N/A
 */
-(void)nextAction
{
    self.playIndex++;
    if (self.playIndex > self.trackMuArray.count-1) {
        self.playIndex = 0;
    }
    [self playMusic];
}

/**
 * @函数名称：lastAction
 * @函数描述：上一曲（播完最后一首，从头播放）
 * @输入参数：N/A
 * @输出参数：N/A
 */
-(void)lastAction
{
    self.playIndex--;
    if (self.playIndex < 0) {
        self.playIndex = 0;
    }
    [self playMusic];
}

#pragma mark - 
#pragma mark - 获取专辑内页数据

-(void)getAlbumTrackData:(NSInteger)last_data_order andAlbumID:(NSInteger)album_id
{
    if (last_data_order == 0) {
        [self.trackMuArray removeAllObjects];
    }
    __weak TrackController *bSelf = self;
    [dtlib getTrackDataLastData:last_data_order andAlbumId:album_id andDic:^(NSDictionary *dic){
        if ([dic[@"error_code"] integerValue]== 0) {
            NSDictionary *sucRes = dic[@"data"];
            if([sucRes[@"has_next"] integerValue] == 0){
                [_footer removeFromSuperview];
                [_footer free];
            }
            NSDictionary *albumDic = sucRes[@"album"];
            AlbumModel *album = [[AlbumModel alloc]initWithDict:albumDic];
            
            NSArray *sucArray = [sucRes objectForKey:@"list"];
            for (int i=0 ; i<sucArray.count; i++) {
                NSDictionary *sucDic = [sucArray objectAtIndex:i];
                TrackModel *trackModel = [[TrackModel alloc]initWithDict:sucDic];
                trackModel.album = album;
                [bSelf.trackMuArray addObject:trackModel];
            }
            [bSelf.trackTbView reloadData];
            if (last_data_order == 0) {
                [bSelf playMusic];
            }
            
            [bSelf.footer endRefreshing];
        }
    }];
}

#pragma mark - 
#pragma mark - 播放音乐
-(void)playMusic
{
    if (self.trackMuArray.count != 0) {
        
        [self.trackTbView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.playIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        
        self.trackModel = [self.trackMuArray objectAtIndex:self.playIndex];
        
        titleLabel.text = self.trackModel.title;

        NSString *current = (NSString *)[AudioPlayer sharedManager].currentlyPlayingQueueItemId;
        if (current.integerValue != self.trackModel.track_id.integerValue) {
            if (ISVALIDURLSTRING(self.trackModel.mp3_url)) {
//                [[AudioPlayer sharedManager] setDataSource:[[AudioPlayer sharedManager] dataSourceFromURL:[NSURL URLWithString:self.trackModel.mp3_url]] withQueueItemId:self.trackModel.track_id];
                [_player playUrl:[NSURL URLWithString:self.trackModel.mp3_url]];
                // Music link is temporarily searched from internet just for demo. Please replace it with your own's.
            }
        }
        if (ISVALIDURLSTRING(self.album.image_url)) {
            [self.albumImageView setImageWithURL:[NSURL URLWithString:self.album.image_url] placeholderImage:[UIImage imageNamed:@"album_default"]];
        }
        
            //设置为圆形图片
        self.albumImageView.layer.cornerRadius = 200/2.0;
        
        self.albumImageView.layer.masksToBounds = YES;
        
        [self.albumImageView.layer setBorderWidth:5];
        self.albumImageView.layer.borderColor = [LINECOLOR CGColor];
        
        [self setupTimer];
        
        for (int i=0; i<self.trackMuArray.count; i++) {
            TrackModel *model = self.trackMuArray[i];
            if (i == self.playIndex) {
                model.trackStatus = YES;
            }else{
                model.trackStatus = NO;
            }
        }
        
        [self.trackTbView reloadData];
        
        [self performSelector:@selector(setLockScreenInfo) withObject:nil afterDelay:2.0];
    }
}

- (IBAction)closeAction {
    //暂时添加
    
    
    [self.tipWindow removeFromSuperview];
    [self.tipLabel removeFromSuperview];
    [self.tipClose removeFromSuperview];
    [lineLabel removeFromSuperview];
}

- (IBAction)toAppStore {
    [Comment commentApp];
}

-(void) setupTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

-(void) tick
{
    if (![AudioPlayer sharedManager] || [AudioPlayer sharedManager].duration == 0)
	{
		return;
	}
    
    self.playSlider.minimumValue = 0;
    self.playSlider.maximumValue = [AudioPlayer sharedManager].duration;
    
    self.playSlider.value = [AudioPlayer sharedManager].progress;
    
    self.leftLabel.text = [Comment progressValue:[AudioPlayer sharedManager].progress];
     self.rightLabel.text = [Comment progressValue:[AudioPlayer sharedManager].duration];
    
        //修改锁屏播放进度-yinlinlin@duotin.com
    [[DtSDK sharedManager].PlayingInfoCenter setObject:[NSNumber numberWithDouble:[AudioPlayer sharedManager].progress] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [[DtSDK sharedManager].PlayingInfoCenter setObject:[NSNumber numberWithDouble:[AudioPlayer sharedManager].duration] forKey:MPMediaItemPropertyPlaybackDuration];
    
    [self updateControls];
}

-(void) updateControls
{
	if ([AudioPlayer sharedManager] == nil)
	{
        self.playBtn.selected = NO;
	}
	else if ([AudioPlayer sharedManager].state == AudioPlayerStatePaused)
	{
        self.playBtn.selected = NO;
	}
	else if ([AudioPlayer sharedManager].state == AudioPlayerStatePlaying)
	{
        self.playBtn.selected = YES;
	}
}

#pragma mark -
#pragma mark - uitableViewDelete
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.trackMuArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrackCell *cell;
    static NSString *identifier = @"trackCell";
    cell = (TrackCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TrackCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    if (self.trackMuArray.count!=0) {
        TrackModel *model = [self.trackMuArray objectAtIndex:indexPath.row];
        [cell setTrackCell:model];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.playIndex = indexPath.row;
    [self playMusic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sliderChange {
//    if (![AudioPlayer sharedManager])
//	{
//		return;
//	}
	
//	[[AudioPlayer sharedManager] seekToTime:self.playSlider.value];
//    [_player pause];
    [_player.player setCurrentTime:self.playSlider.value];
//    [_player resume];
}

- (IBAction)playPauseAction {
    if (self.playBtn.selected) {
//        [[AudioPlayer sharedManager] pause];
        [_player pause];
        self.playBtn.selected = NO;
    }else{
//        [[AudioPlayer sharedManager] resume];
        [_player resume];
        self.playBtn.selected = YES;
    }
}

-(void)refreshMore
{
    TrackModel *track = [self.trackMuArray lastObject];
    [self getAlbumTrackData:track.data_order.intValue andAlbumID:self.album.album_id.integerValue];
}

#pragma mark - 
#pragma mark - 锁屏
/**
 * @函数名称：setLockScreenInfo
 * @函数描述：当切换曲目时更新锁屏显示的图片和内容
 * @输入参数：(UIImage *) img andTitle : (NSString *) title andArtist : (NSString *) artist：专辑图片，节目名称和自定义显示
 * @输出参数：根据传进来的数据对界面进行重新调整显示
 * @返回值：void
 */
- (void) setLockScreenInfo
{
        //移除之前的
    [[DtSDK sharedManager].PlayingInfoCenter removeAllObjects];
    
    NSString *lockContent;
    if (IS_IPHONE_5) {
        lockContent = [NSString stringWithFormat:@"\n\n\n\n "];
    }
    else{
        lockContent = [NSString stringWithFormat:@"\n\n\n\n%@ - %@", self.self.album.title, self.trackModel.title];
    }
        //锁屏显示的节目名称
    [[DtSDK sharedManager].PlayingInfoCenter setObject:lockContent forKey:MPMediaItemPropertyTitle];
    
        //锁屏图片
    UIImageView *imageView = [[UIImageView alloc]init];
    
    if (ISVALIDURLSTRING(self.album.image_url))
    {
        [imageView setImageWithURL:[NSURL URLWithString:self.self.album.image_url] placeholderImage:[UIImage imageNamed:@"album_default"]];
        [[DtSDK sharedManager].PlayingInfoCenter setObject:[[MPMediaItemArtwork alloc] initWithImage:imageView.image] forKey:MPMediaItemPropertyArtwork];
    }
        //锁屏专辑名称
    if (IS_IPHONE_5) {
        lockContent = [NSString stringWithFormat:@"%@ - %@", self.album.title, self.trackModel.title];
        [[DtSDK sharedManager].PlayingInfoCenter setObject:lockContent forKey:MPMediaItemPropertyAlbumTitle];
    }
    else{
        if (IS_IOS_7) {
            lockContent = [NSString stringWithFormat:@"%@ -%@", self.trackModel.title, self.album.title];
            [[DtSDK sharedManager].PlayingInfoCenter setObject:lockContent forKey:MPMediaItemPropertyAlbumTitle];
        }
        else
        {
            [[DtSDK sharedManager].PlayingInfoCenter setObject:self.trackModel.title forKey:MPMediaItemPropertyAlbumTitle];
        }
    }
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = [DtSDK sharedManager].PlayingInfoCenter;

}

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
                [self playPauseAction];
                [self updateControls];
                break;
            }
            case UIEventSubtypeRemoteControlPause://101
            {
                [self playPauseAction];
                [self updateControls];
                break;
            }
            case UIEventSubtypeRemoteControlTogglePlayPause://103
            {
                [self playPauseAction];
                [self updateControls];
                break;
            }
            case UIEventSubtypeRemoteControlPreviousTrack:
            {
                
                    //播放上一首
                [self lastAction];
                break;
            }
            case UIEventSubtypeRemoteControlNextTrack:
            {
                    //播放下一首
                [self nextAction];
                break;
            }
            default:
            {
                break;
            }
        }
    }
}


#pragma mark - 
#pragma mark - 播放代理方法
- (void)engine:(NCMusicEngine *)engine didChangePlayState:(NCMusicEnginePlayState)playState
{
//    NSLog(@"playState = %u",playState);
    if (playState == NCMusicEnginePlayStateEnded) {
        [self nextAction];
    }else if (playState == NCMusicEnginePlayStatePlaying) {
        self.playBtn.selected = YES;
    }else{
        self.playBtn.selected = NO;
    }
}
- (void)engine:(NCMusicEngine *)engine didChangeDownloadState:(NCMusicEngineDownloadState)downloadState
{
//    NSLog(@"downloadState = %u",downloadState);
    if (downloadState == NCMusicEngineDownloadStateDownloaded) {
        ;
    }

}
- (void)engine:(NCMusicEngine *)engine downloadProgress:(CGFloat)progress
{
//    NSLog(@"progress = %f",progress);
    self.cashProgressView.progress = progress;
    
}
- (void)engine:(NCMusicEngine *)engine playProgress:(CGFloat)progress
{
    self.playSlider.minimumValue = 0;
    self.playSlider.maximumValue = engine.player.duration;
    
    self.playSlider.value = engine.player.currentTime;
    
    self.leftLabel.text = [Comment progressValue:engine.player.currentTime];
    self.rightLabel.text = [Comment progressValue:engine.player.duration];
    
    //修改锁屏播放进度-yinlinlin@duotin.com
    [[DtSDK sharedManager].PlayingInfoCenter setObject:[NSNumber numberWithDouble:[AudioPlayer sharedManager].progress] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [[DtSDK sharedManager].PlayingInfoCenter setObject:[NSNumber numberWithDouble:[AudioPlayer sharedManager].duration] forKey:MPMediaItemPropertyPlaybackDuration];
}

@end
