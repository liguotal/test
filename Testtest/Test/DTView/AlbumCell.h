//
//  AlbumCell.h
//  DuotinSDK
//
//  Created by 郭江伟 on 14-5-13.
//  Copyright (c) 2014年 guojiangwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *album_rank;
@property (strong, nonatomic) IBOutlet UIImageView *album_image;
@property (strong, nonatomic) IBOutlet UILabel *album_title;
@property (strong, nonatomic) IBOutlet UILabel *album_info;
@property (strong, nonatomic) IBOutlet UIImageView *play_image;

-(void)setAlbumCell:(AlbumModel *)model;

@end
