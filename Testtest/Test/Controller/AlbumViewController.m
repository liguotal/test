//
//  AlbumViewController.m
//  DuotinSDK
//
//  Created by 郭江伟 on 14-5-13.
//  Copyright (c) 2014年 guojiangwei. All rights reserved.
//

#import "AlbumViewController.h"
#import "AlbumCell.h"
#import "TrackController.h"
#import <AVFoundation/AVFoundation.h>

@interface AlbumViewController ()

@end

@implementation AlbumViewController

-(void)dealloc
{
    _albumTbView = nil;
    _albumMuArray = nil;
    [_footer free];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
//    [self.albumTbView reloadData];
    if ([TrackController sharedManager].trackModel) {
        UIButton *rightBtn = [Comment navigationPlayButtonItem];
        
        UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = rightBar;
        
        [rightBtn addTarget:self action:@selector(pushPlay) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)viewDidLoad
{
    // Do any additional setup after loading the view, typically from a nib.

        //后台播放
    [super viewDidLoad];
    if (IS_IOS_7) {
        self.navigationController.navigationBar.barTintColor = NAVCOLOR;
    }else{
        self.navigationController.navigationBar.tintColor = NAVCOLOR;
    }
    _albumMuArray = [NSMutableArray arrayWithCapacity:100];

    [self initTableView];
    [self addFooter];

    [self getRecomentData:0];
}

#pragma mark - 
#pragma mark - 正在播放

-(void)pushPlay
{
    TrackController *trackVC = [TrackController sharedManager];
    trackVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:trackVC animated:YES];
}

- (void)addFooter
{
    __unsafe_unretained AlbumViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.albumTbView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [vc refreshMore];
    };
    _footer = footer;
}

-(void)initTableView
{
    self.navigationItem.title = @"音乐电台";
//    _albumTbView = [[UITableView alloc]initWithFrame:CGRectMake(0, SuitHeightForIos, MainScreenWidth, MainScreenHeight-SuitHeightForIos) style:UITableViewStylePlain];
    _albumTbView = [[UITableView alloc]initWithFrame:mainscreen style:UITableViewStylePlain];
    _albumTbView.delegate = self;
    _albumTbView.dataSource = self;
    _albumTbView.backgroundColor = BGCOLOR;
    _albumTbView.separatorStyle = NO;
    [self.view addSubview:_albumTbView];
    
    UIButton *clearBtn = [Comment navigationSendItem];
    
    UIBarButtonItem *clearBtnItem = [[UIBarButtonItem alloc]initWithCustomView:clearBtn];
    self.navigationItem.leftBarButtonItem = clearBtnItem;
    
    [clearBtn addTarget:self action:@selector(sendToAppStore) forControlEvents:UIControlEventTouchUpInside];
}

-(void)sendToAppStore
{
    [Comment commentApp];
}

-(void)getRecomentData:(NSInteger)last_data_order
{
    __weak AlbumViewController *bSelf = self;
    [dtlib getAlbumDataLastData:last_data_order andDic:^(NSDictionary *dic){
        if ([dic[@"error_code"] integerValue]== 0) {
            NSDictionary *sucDic = dic[@"data"];
            if([sucDic[@"has_next"] integerValue] == 0){
                [_footer removeFromSuperview];
            }
            NSArray *sucArray = [sucDic objectForKey:@"album_list"];
            for (int i=0 ; i<sucArray.count; i++) {
                NSDictionary *sucDic = [sucArray objectAtIndex:i];
                AlbumModel *albumModel = [[AlbumModel alloc]initWithDict:sucDic];
                [bSelf.albumMuArray addObject:albumModel];
            }
            [bSelf.albumTbView reloadData];
            
            [bSelf.footer endRefreshing];
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.albumMuArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumCell *cell;
    static NSString *identifier = @"albumCell";
    cell = (AlbumCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AlbumCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    AlbumModel *model = [self.albumMuArray objectAtIndex:indexPath.row];
    cell.album_rank.text = [NSString stringWithFormat:@"%@",@(indexPath.row+1)];
    [cell setAlbumCell:model];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrackController *trackVC = [TrackController sharedManager];
    trackVC.hidesBottomBarWhenPushed = YES;
    AlbumModel *album = [self.albumMuArray objectAtIndex:indexPath.row];
    trackVC.album = album;
    [self.navigationController pushViewController:trackVC animated:YES];
    
    for (int i=0; i<self.albumMuArray.count; i++) {
        AlbumModel *model = self.albumMuArray[i];
        if (i == indexPath.row) {
            model.albumStatus = YES;
        }else{
            model.albumStatus = NO;
        }
    }
    [self.albumTbView reloadData];
}

-(void)refreshMore
{
    AlbumModel *album = [self.albumMuArray lastObject];
    [self getRecomentData:album.data_order.intValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
