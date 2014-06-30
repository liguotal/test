//
//  ViewController.h
//  DuotinSDK
//
//  Created by 郭江伟 on 14-5-13.
//  Copyright (c) 2014年 guojiangwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *albumTbView;
@property (strong, nonatomic) NSMutableArray *albumMuArray;
@property (strong, nonatomic) MJRefreshFooterView *footer;

@end
