//
//  AlbumModel.h
//  CollectionView
//
//  Created by 郭江伟 on 14-5-9.
//
//

#import <Foundation/Foundation.h>

@interface AlbumModel : NSObject

//@property (nonatomic, copy) NSNumber *album_id;
//@property (nonatomic, copy) NSString *album_image_url;
//@property (nonatomic, copy) NSString *album_name;
//@property (nonatomic, copy) NSNumber *track_id;
//@property (nonatomic, copy) NSNumber *data_order;
//@property (nonatomic, copy) NSString *type;
//@property (nonatomic, copy) NSString *album_description;
//@property (nonatomic, copy) NSString *tags;

@property (nonatomic, copy) NSNumber *album_id;
@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSNumber *data_order;
@property (nonatomic, copy) NSString *album_description;

    //本地标识
@property BOOL albumStatus;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
