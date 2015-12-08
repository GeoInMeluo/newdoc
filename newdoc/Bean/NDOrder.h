//
//  NDOrder.h
//  newdoc
//
//  Created by zzc on 15/11/10.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>
//预约

/*
 id			预约号，int
	timeslotid		预约窗口号，int
	actual_date		预约日期，xxxx－xx－xx
	status			状态，
 0-预约中
 1－完成
 2 －用户取消
 3- 废弃，超时未出现的预约
 4－不可抗力取消
 5－关闭
	doctor_comment	给医生的评论，string，100字符内
	doctor_rating		给医生的评价，int
	doctor_name		医生姓名，string
	catalog_name		科室名，string
	room_name		诊室名，string
 
 */
@interface NDOrder : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *timeslotid;
@property (nonatomic, copy) NSString *actual_date;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *doctor_comment;
@property (nonatomic, copy) NSString *doctor_rating;
@property (nonatomic, copy) NSString *doctor_name;
@property (nonatomic, copy) NSString *catalog_name;
@property (nonatomic, copy) NSString *room_name;
@property (nonatomic, copy) NSString *room_address;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *end_time;
@end
