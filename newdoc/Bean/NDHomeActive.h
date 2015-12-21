//
//  NDHomeActive.h
//  newdoc
//
//  Created by zzc on 15/12/16.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 id			item id
 img			效果图
 abstract		简述
 url			url链接
 start_date		开始推广的时间，
 end_date		结束时间
 publish_date		发布时间
 pos			相对位置

 */

@interface NDHomeActive : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *abstract;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *start_date;
@property (nonatomic, copy) NSString *end_date;
@property (nonatomic, copy) NSString *publish_date;
@property (nonatomic, copy) NSString *pos;
@end
