
    //
//  AlbumModel.m
//  CollectionView
//
//  Created by 郭江伟 on 14-5-9.
//
//

#import "AlbumModel.h"

@implementation AlbumModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            if (![obj isKindOfClass:[NSNull class]]) {
                if ([key isEqualToString:@"id"]) {
                    [self setValue:obj forKey:@"album_id"];
                }else if ([key isEqualToString:@"description"]) {
                    [self setValue:obj forKey:@"album_description"];
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
