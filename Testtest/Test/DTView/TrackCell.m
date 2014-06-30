//
//  TrackCell.m
//  DuotinSDK
//
//  Created by 郭江伟 on 14-5-14.
//  Copyright (c) 2014年 guojiangwei. All rights reserved.
//

#import "TrackCell.h"

@implementation TrackCell

- (void)awakeFromNib
{
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    UIImageView *sepImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-0.5, 320, 0.5)];
    sepImage.image = [UIImage imageNamed:@"seprater"];
    [self addSubview:sepImage];
    self.play_ingImage.image = [UIImage imageNamed:@"playing_dark_blue"];
}


-(void)setTrackCell:(TrackModel *)model
{
    self.play_durtion.textColor = DESCOLOR;
    self.play_times.textColor = DESCOLOR;
    self.timeLabel.textColor = DESCOLOR;
    self.playLabel.textColor = DESCOLOR;
    
    self.play_durtion.text = model.duration;
    self.play_times.text = [NSString stringWithFormat:@"%@",model.play_times];
    self.track_title.text = model.title;
    
    self.play_ingImage.hidden = YES;
    if (model.trackStatus) {
        self.play_ingImage.hidden = NO;
        self.track_title.textColor = SELCOLOR;
    }else{
        self.play_ingImage.hidden = YES;
        self.track_title.textColor = UNSELCOLOR;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
//    if (selected) {
//        self.play_ingImage.hidden = NO;
//        self.track_title.textColor = SELCOLOR;
//    }else{
//        self.play_ingImage.hidden = YES;
//        self.track_title.textColor = UNSELCOLOR;
//    }
}

@end
