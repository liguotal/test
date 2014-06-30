//
//  TrackCell.h
//  DuotinSDK
//
//  Created by 郭江伟 on 14-5-14.
//  Copyright (c) 2014年 guojiangwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *track_title;
@property (strong, nonatomic) IBOutlet UILabel *play_times;
@property (strong, nonatomic) IBOutlet UILabel *play_durtion;
@property (strong, nonatomic) IBOutlet UIImageView *play_ingImage;
@property (strong, nonatomic) IBOutlet UILabel *playLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

-(void)setTrackCell:(TrackModel *)model;

@end
