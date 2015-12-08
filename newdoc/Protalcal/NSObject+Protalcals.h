//
//  NSObject+Protalcals.h
//  newdoc
//
//  Created by zzc on 15/10/22.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "NDRoom.h"
#import "NDDoctor.h"
#import "NDSubroom.h"
#import "NDDoctorIntro.h"
#import "NDDoctorComment.h"
#import "NDDoctorMorePreserveWindow.h"
#import "NDSlot.h"
#import "NDUser.h"
#import "NDRealNameAuth.h"
#import "NDOrder.h"
#import "NDEhr.h"
#import "NDQAMessage.h"
#import "NDTalkMessage.h"
#import "NDCommonQA.h"

@interface NSObject (Protalcals)
//获取验证码
- (void)startSendVerifyCodeWithPhoneNumber:(NSString *)phoneNumber success:(void(^)(NSObject *resultDic))success failure:(void(^)(NSString *error_message))failure;

//得到附近的诊室
- (void)startGetRoomListWithLocation:(CLLocationCoordinate2D)coordinate andCityName:(NSString *)city andAreaName:(NSString *)area success:(void(^)(NSArray *rooms))success failure:(void(^)(NSString *error_message))failure;

//得到省份列表
- (void)startGetProvinceListAndSuccess:(void(^)(NSArray *provinces))success failure:(void(^)(NSString *error_message))failure;

//得到城市列表
- (void)startGetCityListWithProvince:(NSString *)provinceName success:(void(^)(NSArray *citys))success failure:(void(^)(NSString *error_message))failure;

//得到区县列表
- (void)startGetCountyListWithCity:(NSString *)cityName success:(void(^)(NSArray *countys))success failure:(void(^)(NSString *error_message))failure;

//得到诊室详情
- (void)startGetRoomWithRoomId:(NSString *)roomId success:(void(^)(NDRoom *room))success failure:(void(^)(NSString *error_message))failure;

//关注医生
- (void)startAttentionDoctorWithDocId:(NSString *)docId success:(void(^)())success failure:(void(^)(NSString *error_message))failure;

//取消关注医生
- (void)startCancelAttentionDoctorWithDocId:(NSString *)docId success:(void(^)())success failure:(void(^)(NSString *error_message))failure;

//得到医生简介
- (void)startGetDoctorIntroWithDocId:(NSString *)docId success:(void(^)( NDDoctorIntro *intro))success failure:(void(^)(NSString *error_message))failure;

//得到医生的所有评论
- (void)startGetDoctorCommentsWithDocId:(NSString *)docId success:(void(^)( NSArray *docComments))success failure:(void(^)(NSString *error_message))failure;

//回复用户评论
- (void)startReplyUserCommentWithComment:(NSString *)commentId andContent:(NSString *)content success:(void(^)())success failure:(void(^)(NSString *error_message))failure;

//得到医生详情(预约内使用的医生数据模型)
- (void)startGetDoctorDetailWithDocId:(NSString *)docId andRoomId:(NSString *)roomId success:(void(^)( NDDoctorMorePreserveWindow *doctorMorePreserveWindow))success failure:(void(^)(NSString *error_message))failure;

//用户预约挂号
- (void)startOrderWithSlot:(NDSlot *)slot success:(void(^)())success failure:(void(^)(NSString *error_message))failure;

//主动注册
- (void)startRegistWithUsername:(NSString *)username andPassWord:(NSString *)pwd andVerifyCode:(NSString *)verifyCode andPhoneNumber:(NSString *)phoneNumber success:(void(^)())success failure:(void(^)(NSString *error_message))failure;

//主动登陆
- (void)startLoginWithUsername:(NSString *)username andPassWord:(NSString *)pwd success:(void(^)(NDUser *user))success failure:(void(^)(NSString *error_message))failure;

//绑定诊室
- (void)startBindRoomWithRoomId:(NSString *)roomId success:(void(^)())success failure:(void(^)(NSString *error_message))failure;

//取消绑定诊室
- (void)startCancelBindRoomWithRoomId:(NSString *)roomId success:(void(^)())success failure:(void(^)(NSString *error_message))failure;

//用户信息
- (void)startGetUserInfoAndSuccess:(void(^)(NDUser *user))success failure:(void(^)(NSString *error_message))failure;

//编辑用户信息
- (void)startEditUserInfo:(NDUser *)user success:(void(^)())success failure:(void(^)(NSString *error_message))failure;

//发送信息更新密码
- (void)startSendVerifyCodeForUpdatePasswordWithPhoneNumber:(NSString *)phoneNumber success:(void(^)(NSObject *resultDic))success failure:(void(^)(NSString *error_message))failure;

//更新密码
- (void)startUpdatePwdWithUserId:(NSString *)userId andOldPwd:(NSString *)oldPwd andNewPwd:(NSString *)newPwd andVerifyCode:(NSString *)verifyCode success:(void(^)())success failure:(void(^)(NSString *error_message))failure;

//发送信息绑定手机
- (void)startSendVerifyCodeForBindWithPhoneNumber:(NSString *)phoneNumber success:(void(^)(NSObject *resultDic))success failure:(void(^)(NSString *error_message))failure;

//忘记密码，用手机号找回更新密码
- (void)startResetPasswordWithPhoneNumber:(NSString *)phoneNumber andVerifyCode:(NSString *)verifyCode andNewPassword:(NSString *)newPwd success:(void(^)(NSObject *resultDic))success failure:(void(^)(NSString *error_message))failure;

//微信注册接口
- (void)startRegistWithWXCode:(NSString *)code success:(void(^)(NSObject *resultDic))success failure:(void(^)(NSString *error_message))failure;

//实名认证
- (void)startRealNameAuthenticationWithName:(NSString *)name andIdCard:(NSString *)idCard andCitizenNumber:(NSString *)citizenNumber success:(void(^)(NSObject *resultDic))success failure:(void(^)(NSString *error_message))failure;

//得到实名认证信息
//- (void)startGetRealNameAuthenticationWithNameAndSuccess:(void(^)(NDRealNameAuth *realNameAuth))success failure:(void(^)(NSString *error_message))failure;

//得到用户关注的医生
- (void)startGetAttetionDocsWithAndSuccess:(void(^)(NSArray *doc))success failure:(void(^)(NSString *error_message))failure;

//得到咨询列表
- (void)startGetRefersWithAndSuccess:(void(^)(NSArray *refers))success failure:(void(^)(NSString *error_message))failure;

// 得到用户的预约
- (void)startGetOrdersWithAndSuccess:(void(^)(NSArray *orders))success failure:(void(^)(NSString *error_message))failure;

//得到用户的病历列表
- (void)startGetEhrsWithAndSuccess:(void(^)(NSArray *ehrs))success failure:(void(^)(NSString *error_message))failure;

//得到用户的绑定的诊室
- (void)startGetBindRoomsWithAndSuccess:(void(^)(NSArray *roomNames))success failure:(void(^)(NSString *error_message))failure;

//绑定手机
- (void)startBindPhoneNumber:(NSString *)phoneNumber andVerifyCode:(NSString *)verifyCode  success:(void(^)())success failure:(void(^)(NSString *error_message))failure;

//解绑手机
- (void)startCancelBindPhoneNumber:(NSString *)phoneNumber andVerifyCode:(NSString *)verifyCode  success:(void(^)())success failure:(void(^)(NSString *error_message))failure;

//上传图片
- (void)startUploadImageWithImages:(NSArray *)images  success:(void(^)(NSArray *imgUrls))success failure:(void(^)(NSString *error_message))failure;

//用户提交咨询
- (void)startSubmitQAWithContent:(NSString *)content andSubroomId:(NSString *)subroomId andSex:(NSString *)sex andAge:(NSString *)age andImgs:(NSArray *)imgs success:(void(^)())success failure:(void(^)(NSString *error_message))failure;

//浏览咨询列表
- (void)startGetQAListAndSuccess:(void(^)(NSArray *qaMessages))success failure:(void(^)(NSString *error_message))failure;

//浏览咨询
- (void)startGetQAWithQAId:(NSString *)qAId success:(void(^)(NSArray *talkMessages))success failure:(void(^)(NSString *error_message))failure;

//用户追加咨询
- (void)startSendTalkMessage:(NSString *)message andQAID:(NSString *)qAId success:(void(^)(NSArray *talkMessages))success failure:(void(^)(NSString *error_message))failure;

//浏览常见问题列表
- (void)startGetCommonQAListAndSuccess:(void(^)(NSArray *qAs))success failure:(void(^)(NSString *error_message))failure;

//搜索常见问题
- (void)startGetQueryCommonQAListWithQuestion:(NSString *)question success:(void(^)(NSArray *qAs))success failure:(void(^)(NSString *error_message))failure;

//发送反馈
- (void)startSendCallbackWithContent:(NSString *)content success:(void(^)())success failure:(void(^)(NSString *error_message))failure;

//用户发表评价
- (void)startCommentDocWithOrderId:(NSString *)docId andRating:(NSString *)rating andContent:(NSString *)content success:(void(^)())success failure:(void(^)(NSString *error_message))failure;

//得到全部科室
- (void)startAllSubroomAndSuccess:(void(^)(NSArray *subrooms))success failure:(void(^)(NSString *error_message))failure;


@end
