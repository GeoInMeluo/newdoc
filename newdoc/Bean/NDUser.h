//
//  NDUser.h
//  newdoc
//
//  Created by zzc on 15/11/4.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NDUser : NSObject

/*
 newdocid": "newdocid00weixin000000001",
 "name": "weixin001",
 "picture_url": null,
 "weixin": null,
 "mobile": null,
 "sex": "0",
 "city": null,
 "country": null,
 "province": null,
 "citizenid": null,
 "insuranceid": null,
 "update_date": "2015-10-16 08:09:41",
 "reg_date": "2015-10-16 08:09:41",
 "commit_date": "0000-00-00 00:00:00"
 */

//@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *picture_url;
@property (nonatomic, copy) NSString *weixin;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, assign) int user_status;
@property (nonatomic, copy) NSString *real_name;
@end
