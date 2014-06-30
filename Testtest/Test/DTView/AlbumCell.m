//
//  AlbumCell.m
//  DuotinSDK
//
//  Created by 郭江伟 on 14-5-13.
//  Copyright (c) 2014年 guojiangwei. All rights reserved.
//

#import "AlbumCell.h"

@implementation AlbumCell

- (void)awakeFromNib
{
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    UIImageView *sepImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-0.5, 320, 0.5)];
    sepImage.image = [UIImage imageNamed:@"seprater"];
    [self addSubview:sepImage];
    
    self.play_image.image = [UIImage imageNamed:@"playing_dark_blue"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
//    if (selected) {
//        self.play_image.hidden = NO;
//        self.album_title.textColor = SELCOLOR;
//    }else{
//        self.play_image.hidden = YES;
//        self.album_title.textColor = UNSELCOLOR;
//    }
}

-(void)setAlbumCell:(AlbumModel *)model
{
    self.album_info.textColor = DESCOLOR;
    self.album_rank.textColor = DESCOLOR;
    self.album_title.text = model.title;
   
    [self.album_image setImageWithURL:[NSURL URLWithString:model.image_url] placeholderImage:[UIImage imageNamed:@"album_default"]];
    
//    NSString *description = [model.album_description stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.album_info.text = model.title;
    
    if (model.albumStatus) {
        self.play_image.hidden = NO;
        self.album_title.textColor = SELCOLOR;
    }else{
        self.play_image.hidden = YES;
        self.album_title.textColor = UNSELCOLOR;
    }
}

@end
