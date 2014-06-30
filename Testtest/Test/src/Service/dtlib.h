//
//  dtlib.h
//  test
//
//  Created by 郭江伟 on 14-5-21.
//  Copyright (c) 2014年 guojiangwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dtlib : NSObject

+(void)getAlbumDataLastData:(NSInteger)last_data_order andDic:(void (^)(NSDictionary *))completeblock;

+(void)getTrackDataLastData:(NSInteger)last_data_order andAlbumId:(NSInteger)album_id andDic:(void (^)(NSDictionary *))completeblock;

@end
