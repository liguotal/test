//
//  TrackModel.h
//  CollectionView
//
//  Created by 郭江伟 on 14-5-9.
//
//


//displayorder: 1,
//id: 41063,
//title: "01",
//play_mp3_url_32: "http://c1.duotin.com/static/uploads/attached/00/00/00/41/41063/32_aa2caf27afcbc25388b615070aed1d85.mp3",
//play_mp3_url_16: "http://c1.duotin.com/static/uploads/attached/00/00/00/41/41063/16_a1e2ccfd584d6e12edad6dfcc8b44a37.mp3",
//file_size_32: "5095949",
//file_size_16: "2547965",
//duration: "00:21:13",
//play_count: 124,
//comment_count: 0,
//data_order: 1,
//is_like: 0

#import <Foundation/Foundation.h>
#import "AlbumModel.h"

@interface TrackModel : NSObject

@property (nonatomic, strong) NSNumber *data_order;
@property (nonatomic, strong) NSNumber *play_times;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *mp3_url;
@property (nonatomic, strong) NSNumber *track_id;
@property (nonatomic, strong) NSString *duration;

@property (nonatomic, strong) AlbumModel *album;

    //本地标识选中行
@property BOOL trackStatus;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
