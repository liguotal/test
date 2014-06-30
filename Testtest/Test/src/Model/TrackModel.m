//
//  TrackModel.m
//  CollectionView
//
//  Created by 郭江伟 on 14-5-9.
//
//

#import "TrackModel.h"

@implementation TrackModel


- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            if (![obj isKindOfClass:[NSNull class]]) {
                if ([key isEqualToString:@"play_count"]) {
                    [self setValue:obj forKey:@"play_times"];
                }else if ([key isEqualToString:@"play_mp3_url_32"]) {
                    [self setValue:obj forKey:@"mp3_url"];
                }else if ([key isEqualToString:@"id"]) {
                    [self setValue:obj forKey:@"track_id"];
                }else{
                    SEL se = NSSelectorFromString(key);
                    if ([self respondsToSelector:se]) {
                        [self setValue:obj forKey:key];
                    }
                }
            }
            
        }];
    }
    return self;
}

@end
