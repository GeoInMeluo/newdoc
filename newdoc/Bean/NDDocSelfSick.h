//
//  NDDocSelfSick.h
//  newdoc
//
//  Created by zzc on 15/11/26.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NDDocSelfSick : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *pathology;
@property (nonatomic, strong) NSArray *like;
@end
