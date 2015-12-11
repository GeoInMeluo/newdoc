//
//  NSObject+Protalcals.m
//  newdoc
//
//  Created by zzc on 15/10/22.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NSObject+Protalcals.h"

@implementation NSObject (Protalcals)

//获取验证码
- (void)startSendVerifyCodeWithPhoneNumber:(NSString *)phoneNumber success:(void(^)(NSObject *resultDic))success failure:(void(^)(NSString *error_message))failure{

    NSDictionary *param = @{@"mobile":SafeString(phoneNumber),
                            @"f":@"reg"};
    

    [[NDNetManager sharedNetManager] post:@"/Common/1/sms" parameters:param success:^(NSDictionary *result) {
        success(result);
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];
}

//得到附近的诊室
- (void)startGetRoomListWithLocation:(CLLocationCoordinate2D)coordinate andCityName:(NSString *)city andAreaName:(NSString *)area andPage:(int)page success:(void(^)(NSArray *rooms))success failure:(void(^)(NSString *error_message))failure{
    FLog(@"%@",city);
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if(coordinate.longitude && coordinate.latitude){
        [param setObject:SafeNumber([NSNumber numberWithDouble:coordinate.longitude]) forKey:@"longitude"];
        [param setObject:SafeNumber([NSNumber numberWithDouble:coordinate.latitude]) forKey:@"latitude"];
    }
    if(area){
        [param setObject:SafeString(area) forKey:@"area"];
    }
    if (city){
//        [param setObject:SafeString(city) forKey:@"city"];
    }
    
    [param setObject:SafeString(@"5000") forKey:@"scope"];
    
    [param setObject:[NSString stringWithFormat:@"%d", page] forKey:@"pageNum"];
    
    [param setObject:@"10" forKey:@"pageCnt"];
    
    FLog(@"%@",param);
    
    
    [[NDNetManager sharedNetManager] get:@"/app/1/Rooms?action=near" parameters:param success:^(NSDictionary *result) {
        NSMutableArray *rooms = [NSMutableArray array];
        
        if([[result allKeys] containsObject:@"data"]){
            if([[result[@"data"] allKeys] containsObject:@"subs"]){
                NSArray *dics = result[@"data"][@"subs"];
                for(id obj in dics){
                    NDRoom *room = [NDRoom mj_objectWithKeyValues:obj];
                    [rooms addObject:room];
                }
            }
        }
        
        success(rooms);

    } failure:^(NSString *error_message) {
        failure(error_message);
    }];
}

//得到省份列表
- (void)startGetProvinceListAndSuccess:(void(^)(NSArray *provinces))success failure:(void(^)(NSString *error_message))failure{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [[NDNetManager sharedNetManager] get:@"/app/1/loctree?action=index" parameters:param success:^(NSDictionary *result) {
        NSMutableArray *provinces = [NSMutableArray array];
        
        if([[result allKeys] containsObject:@"data"]){
            if([[result[@"data"] allKeys] containsObject:@"subs"]){
                NSArray *dics = result[@"data"][@"subs"];
                for(id obj in dics){
                    NSString *provinceName = obj;
                    [provinces addObject:provinceName];
                }
            }
        }
        
        success(provinces);
        
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];

}

//得到城市列表
- (void)startGetCityListWithProvince:(NSString *)provinceName success:(void(^)(NSArray *citys))success failure:(void(^)(NSString *error_message))failure{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:SafeString(provinceName) forKey:@"province"];
    
    [[NDNetManager sharedNetManager] get:@"/app/1/loctree?action=index" parameters:param success:^(NSDictionary *result) {
        NSMutableArray *provinces = [NSMutableArray array];
        
        if([[result allKeys] containsObject:@"data"]){
            if([[result[@"data"] allKeys] containsObject:@"subs"]){
                NSArray *dics = result[@"data"][@"subs"];
                for(id obj in dics){
                    NSString *provinceName = obj;
                    [provinces addObject:provinceName];
                }
            }
        }
        
        success(provinces);
        
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];
;

}

//得到区县列表
- (void)startGetCountyListWithCity:(NSString *)cityName success:(void(^)(NSArray *countys))success failure:(void(^)(NSString *error_message))failure{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:SafeString(cityName) forKey:@"city"];
    
    [[NDNetManager sharedNetManager] get:@"/app/1/loctree?action=index" parameters:param success:^(NSDictionary *result) {
        NSMutableArray *provinces = [NSMutableArray array];
        
        if([[result allKeys] containsObject:@"data"]){
            if([[result[@"data"] allKeys] containsObject:@"subs"]){
                NSArray *dics = result[@"data"][@"subs"];
                for(id obj in dics){
                    NSString *provinceName = obj;
                    [provinces addObject:provinceName];
                }
            }
        }
        
        success(provinces);
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];

}

//得到诊室详情
- (void)startGetRoomWithRoomId:(NSString *)roomId success:(void(^)(NDRoom *room))success failure:(void(^)(NSString *error_message))failure{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [[NDNetManager sharedNetManager] get:[NSString stringWithFormat:@"/app/1/Rooms/%@?action=index",SafeString(roomId)] parameters:param success:^(NSDictionary *result) {
    
//        NSMutableArray *subRooms = [NSMutableArray array];
        
        FLog(@"%@", result);
        
        if([[result allKeys] containsObject:@"data"]){
            NDRoom *room = [NDRoom mj_objectWithKeyValues:result[@"data"]];

            success(room);

//            if([[result[@"data"] allKeys] containsObject:@"catalogs"]){
//                NSArray *dics = result[@"data"][@"catalogs"];
//
//                for(id obj in dics){
//                    NDSubroom *subroom = [NDSubroom mj_mj_objectWithKeyValues:obj];
//                    [subRooms addObject:subroom];
//                }
//            }
        }
        
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];

}

//关注医生
- (void)startAttentionDoctorWithDocId:(NSString *)docId success:(void(^)())success failure:(void(^)(NSString *error_message))failure{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:SafeString(docId) forKey:@"doctorid"];
    
    [[NDNetManager sharedNetManager] post:@"app/1/Focus" parameters:param success:^(NSDictionary *result) {
        success();
        
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];


}

//取消关注医生
- (void)startCancelAttentionDoctorWithDocId:(NSString *)docId success:(void(^)())success failure:(void(^)(NSString *error_message))failure{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:SafeString(docId) forKey:@"doctorid"];
    [param setObject:@"del" forKey:@"action"];
    
    [[NDNetManager sharedNetManager] post:@"app/1/Focus" parameters:param success:^(NSDictionary *result) {
        success();
        
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];

}

//得到医生简介
- (void)startGetDoctorIntroWithDocId:(NSString *)docId success:(void(^)( NDDoctorIntro *intro))success failure:(void(^)(NSString *error_message))failure{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [[NDNetManager sharedNetManager] get:[NSString stringWithFormat:@"/app/1/Doctors/%@?action=intro",SafeString(docId)] parameters:param success:^(NSDictionary *result) {
        //        NSMutableArray *subRooms = [NSMutableArray array];
        
        FLog(@"%@", result);
        
        if([[result allKeys] containsObject:@"data"]){
            NDDoctorIntro *intro = [NDDoctorIntro mj_objectWithKeyValues:result[@"data"]];
            success(intro);
        }
        
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];

}


//得到医生的所有评论
- (void)startGetDoctorCommentsWithDocId:(NSString *)docId andPage:(int)page success:(void(^)( NSArray *docComments))success  failure:(void(^)(NSString *error_message))failure{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:[NSString stringWithFormat:@"%d", page] forKey:@"pageNum"];
    
    [param setObject:@"10" forKey:@"pageCnt"];

    
    [[NDNetManager sharedNetManager] get:[NSString stringWithFormat:@"/app/1/Doctors/%@?action=comments",SafeString(docId)] parameters:param success:^(NSDictionary *result) {
        NSMutableArray *comments = [NSMutableArray array];
        
        if([[result allKeys] containsObject:@"data"]){
            if([[result[@"data"] allKeys] containsObject:@"subs"]){
                NSArray *dics = result[@"data"][@"subs"];
                for(id obj in dics){
                    NDDoctorComment *comment = [NDDoctorComment mj_objectWithKeyValues:obj];
                    [comments addObject:comment];
                }
            }
        }
        
        success(comments);
        
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];

}



//得到医生详情(预约内使用的医生数据模型)
- (void)startGetDoctorDetailWithDocId:(NSString *)docId andRoomId:(NSString *)roomId success:(void(^)( NDDoctorMorePreserveWindow *doctorMorePreserveWindow))success failure:(void(^)(NSString *error_message))failure{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:SafeString(roomId) forKey:@"roomid"];
    
    [[NDNetManager sharedNetManager] get:[NSString stringWithFormat:@"/app/1/Doctors/%@?action=index",SafeString(docId)] parameters:param success:^(NSDictionary *result) {
        
        FLog(@"%@", result);
        
        if([[result allKeys] containsObject:@"data"]){
            NDDoctorMorePreserveWindow *doctor =[NDDoctorMorePreserveWindow mj_objectWithKeyValues:result[@"data"]];
            
            success(doctor);
        }
        
        
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];

}

//用户预约挂号
- (void)startOrderWithSlot:(NDSlot *)slot success:(void(^)())success failure:(void(^)(NSString *error_message))failure{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:SafeString(slot.ID) forKey:@"timeslotid"];
    [param setObject:SafeString(slot.actual_date) forKey:@"actual_date"];
    
    [[NDNetManager sharedNetManager] post:@"/app/1/Appointments" parameters:param success:^(NSDictionary *result) {
        
        FLog(@"%@", result);
        
//        if([[result allKeys] containsObject:@"data"]){
//            NDDoctorMorePreserveWindow *doctor =[NDDoctorMorePreserveWindow mj_mj_objectWithKeyValues:result[@"data"]];
//            
            success();
//        }
        
        
        
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];
    
}

//主动注册
- (void)startRegistWithUsername:(NSString *)username andPassWord:(NSString *)pwd andVerifyCode:(NSString *)verifyCode andPhoneNumber:(NSString *)phoneNumber success:(void(^)())success failure:(void(^)(NSString *error_message))failure{
    WEAK_SELF;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:SafeString(username) forKey:@"newdocid"];
    [param setObject:MD5_NSString(pwd) forKey:@"passwdMd5"];
    [param setObject:SafeString(phoneNumber) forKey:@"mobile"];
    [param setObject:SafeString(verifyCode) forKey:@"smstoken"];
    
    [[NDNetManager sharedNetManager] post:@"/Common/1/reg" parameters:param success:^(NSDictionary *result) {
        
        FLog(@"%@", result);
        //注册成功后直接登陆
        if([[result allKeys] containsObject:@"retcode"]){
            if([result[@"retcode"] isEqualToString:@"0"]){
                [weakself startLoginWithUsername:username andPassWord:pwd success:^(NDUser *user){
                    
                    success();
                    
                } failure:^(NSString *error_message) {
                    failure(error_message);
                }];
            }
        }
        
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];

}


//主动登陆
- (void)startLoginWithUsername:(NSString *)username andPassWord:(NSString *)pwd success:(void(^)(NDUser *user))success failure:(void(^)(NSString *error_message))failure{
    WEAK_SELF;
    
    [[NDCoreSession coreSession] logout];
    
    [NDCoreSession coreSession].isWxLogin = @"0";
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"iswxlogin"];

    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:SafeString(username) forKey:@"newdocid"];
//    NSString *md5String = ([NSString stringWithFormat:@"%@:%@",username,pwd]);
    
    NSString *base64Str = [NSString base64StringFromData:[[NSString stringWithFormat:@"%@:%@",username,pwd] dataUsingEncoding:NSUTF8StringEncoding] length:0];
    
    FLog(@"%@", base64Str);
    NSString *finalString = [NSString stringWithFormat:@"Basic %@",base64Str];
    
    [[NDNetManager sharedNetManager].requestSerializer setValue:finalString forHTTPHeaderField:@"Authorization"];
    
    [[NDNetManager sharedNetManager] post:@"/Common/1/login" parameters:param success:^(NSDictionary *result) {
        
        [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:@"pwd"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        for(NSHTTPCookie *cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies){
            
            //        if([cookie.name isEqualToString:@"AUTHKEY"] ){
            //            [[NSUserDefaults standardUserDefaults] setObject:cookie.value forKey:@"authkey"];
            //        }
            //
            //        if([cookie.name isEqualToString:@"OPENID"] ){
            //            [[NSUserDefaults standardUserDefaults] setObject:cookie.value forKey:@"openid"];
            //        }
            
            if([cookie.name isEqualToString:@"NDUID"] ){
                
                FLog(@"%@", cookie.value);
                
                [[NSUserDefaults standardUserDefaults] setObject:cookie.value forKey:@"nduid"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [NDCoreSession coreSession].nduid = cookie.value;
            }
            
        }
        
        FLog(@"%@", result);
        
        //使用完cookie之后禁用cookie
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies]) {
            [storage deleteCookie:cookie];
        }
        
        [weakself startGetUserInfoAndSuccess:^(NDUser *user) {
            success(user);
        } failure:^(NSString *error_message) {
            failure(error_message);
        }];
        
        FLog(@"%@", result);
        
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];
}

//绑定诊室
- (void)startBindRoomWithRoomId:(NSString *)roomId success:(void(^)())success failure:(void(^)(NSString *error_message))failure{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:SafeString(roomId) forKey:@"roomid"];
    
    [[NDNetManager sharedNetManager] post:@"/app/1/Binding" parameters:param success:^(NSDictionary *result) {
        
        FLog(@"%@", result);
        
        
        
        success();
        
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];
}

//取消绑定诊室
- (void)startCancelBindRoomWithRoomId:(NSString *)roomId success:(void(^)())success failure:(void(^)(NSString *error_message))failure{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:SafeString(roomId) forKey:@"roomid"];
    [param setObject:@"del" forKey:@"action"];
    
    [[NDNetManager sharedNetManager] post:@"/app/1/Binding?action=del" parameters:param success:^(NSDictionary *result) {
        
        FLog(@"%@", result);
        
        
        
        success();
        
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];
}

//用户信息
- (void)startGetUserInfoAndSuccess:(void(^)(NDUser *user))success failure:(void(^)(NSString *error_message))failure{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [[NDNetManager sharedNetManager] get:@"/app/1/Clients?action=index" parameters:param success:^(NSDictionary *result) {
        
        FLog(@"%@", result);
        
        if([[result allKeys] containsObject:@"data"]){
            
            NDUser *user = [NDUser mj_objectWithKeyValues:result[@"data"]];
            
            FLog(@"%@", user);
            FLog(@"%@", result[@"data"]);
            
            [NDCoreSession coreSession].user = user;
            
            NSString *tempPath =  NSTemporaryDirectory();
            
            NSString *filePath =  [tempPath stringByAppendingPathComponent:@"user.data"];
            
            [NSKeyedArchiver archiveRootObject:user toFile:filePath];

            
            success(user);
        }
        
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];
}

//编辑用户信息
- (void)startEditUserInfo:(NDUser *)user success:(void(^)())success failure:(void(^)(NSString *error_message))failure{
    NSDictionary *item = @{@"picture_url":SafeString(user.picture_url),
//                           @"name":SafeString(user.name),
                           @"sex":SafeString(user.sex),
//                           @"weixin":SafeString(user.weixin),
                           @"os":@"0"};
    
    NSArray *items = @[item];
    
    FLog(@"%@", items);
    
    if(items == nil){
        return;
    }
    
    NSString *jsonStr = [items jsonString];
    
    FLog(@"%@", jsonStr);
    
    NSDictionary *param = @{@"items":jsonStr};
    
    
    
    [[NDNetManager sharedNetManager] post:@"/app/1/Clients" parameters:param success:^(NSDictionary *result) {
        
        FLog(@"%@", result);
        
//        if([[result allKeys] containsObject:@"data"]){
//            NDUser *user = [NDUser mj_objectWithKeyValues:result[@"data"]];
//            
//            FLog(@"%@", user);
//            FLog(@"%@", result[@"data"]);
//            
            success();
//        }
        
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];

}

//发送信息更新密码
- (void)startSendVerifyCodeForUpdatePasswordWithPhoneNumber:(NSString *)phoneNumber success:(void(^)(NSObject *resultDic))success failure:(void(^)(NSString *error_message))failure{
    NSDictionary *param = @{@"mobile":SafeString(phoneNumber),
                            @"f":@"secure"};
    
    
    [[NDNetManager sharedNetManager] post:@"/Common/1/sms" parameters:param success:^(NSDictionary *result) {
        success(result);
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];
}

//更新密码
- (void)startUpdatePwdWithUserId:(NSString *)userId andOldPwd:(NSString *)oldPwd andNewPwd:(NSString *)newPwd andVerifyCode:(NSString *)verifyCode success:(void(^)())success failure:(void(^)(NSString *error_message))failure{
    
    WEAK_SELF;
    
    NSString *base64Str = [NSString base64StringFromData:[[NSString stringWithFormat:@"%@:%@",SafeString(userId),SafeString(oldPwd)] dataUsingEncoding:NSUTF8StringEncoding] length:0];
    
    NSString *finalString = [NSString stringWithFormat:@"Basic %@",base64Str];
    
   
    
    NSDictionary *param = @{@"newdocid":SafeString(userId),
                            @"baseauth":SafeString(finalString),
                            @"newMd5":MD5_NSString(SafeString(newPwd)),
                            @"smstoken":SafeString(verifyCode)};
    
    
     FLog(@"%@", param);
    
    [[NDNetManager sharedNetManager] post:@"/Common/1/passwd" parameters:param success:^(NSDictionary *result) {
        [[NSUserDefaults standardUserDefaults] setObject:newPwd forKey:@"pwd"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        success();
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];

}

//发送信息绑定手机
- (void)startSendVerifyCodeForBindWithPhoneNumber:(NSString *)phoneNumber success:(void(^)(NSObject *resultDic))success failure:(void(^)(NSString *error_message))failure{
    NSDictionary *param = @{@"mobile":SafeString(phoneNumber),
                            @"f":@"bind"};
    
    
    [[NDNetManager sharedNetManager] post:@"/Common/1/sms" parameters:param success:^(NSDictionary *result) {
        success(result);
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];
}


//忘记密码，用手机号找回更新密码
- (void)startResetPasswordWithPhoneNumber:(NSString *)phoneNumber andVerifyCode:(NSString *)verifyCode andNewPassword:(NSString *)newPwd success:(void(^)(NSObject *resultDic))success failure:(void(^)(NSString *error_message))failure{
    NSDictionary *param = @{ @"mobile":SafeString(phoneNumber),
                             @"smstoken":SafeString(verifyCode),
                            @"newMd5":MD5_NSString(newPwd)};
    
    
    [[NDNetManager sharedNetManager] post:@"/Common/1/forget" parameters:param success:^(NSDictionary *result) {
        [MBProgressHUD showSuccess:@"修改成功"];
        
        success(result);
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];

}

//微信注册接口
- (void)startRegistWithWXCode:(NSString *)code success:(void(^)(NSObject *resultDic))success failure:(void(^)(NSString *error_message))failure{
    NSDictionary *param = @{ @"type":@"app",
                             @"code":SafeString(code)};
    
    FLog(@"%@", param);
    
    [[NDNetManager sharedNetManager] post:@"/Common/1/wxlogin" parameters:param success:^(NSDictionary *result) {
        FLog(@"%@", result);
        
        [[NSUserDefaults standardUserDefaults] setObject:result[@"authkey"] forKey:@"authkey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        success(result);
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];
}

//实名认证
- (void)startRealNameAuthenticationWithName:(NSString *)name andIdCard:(NSString *)idCard andCitizenNumber:(NSString *)citizenNumber success:(void(^)(NSObject *resultDic))success failure:(void(^)(NSString *error_message))failure{
    
    NSDictionary *item = @{@"real_name":SafeString(name),
                            @"citizenid":SafeString(idCard),
                            @"insuranceid":SafeString(citizenNumber)};
    
    NSArray *items = @[item];
    
    FLog(@"%@", items);
    
    if(items == nil){
        return;
    }
    
    NSString *jsonStr = [items jsonString];
    
    FLog(@"%@", jsonStr);
    
    NSDictionary *param = @{ @"action":@"realname",
                             @"items":jsonStr};
    
    [[NDNetManager sharedNetManager] post:@"/app/1/Clients" parameters:param success:^(NSDictionary *result) {
        success(result);
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];
}

//得到实名认证信息
//- (void)startGetRealNameAuthenticationWithNameAndSuccess:(void(^)(NDRealNameAuth *realNameAuth))success failure:(void(^)(NSString *error_message))failure{
//    NSDictionary *param = [NSDictionary dictionary];
//    
//    [[NDNetManager sharedNetManager] get:@"/Common/1/wxlogin" parameters:param success:^(NSDictionary *result) {
//        if([[result allKeys] containsObject:@"data"]){
//            NDRealNameAuth *auth = [NDRealNameAuth mj_mj_objectWithKeyValues:result[@"data"]];
//            
//            success(auth);
//        }
//    } failure:^(NSString *error_message) {
//        failure(error_message);
//    }];
//}

//得到用户关注的医生
- (void)startGetAttetionDocsWithAndPage:(int)page success:(void(^)(NSArray *doc))success failure:(void(^)(NSString *error_message))failure{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:[NSString stringWithFormat:@"%d", page] forKey:@"pageNum"];
    
    [param setObject:@"10" forKey:@"pageCnt"];
    
    [[NDNetManager sharedNetManager] get:@"/app/1/Focus?action=index" parameters:param success:^(NSDictionary *result) {
        FLog(@"%@",result);
        
        if([[result allKeys] containsObject:@"data"]){
            if([[result[@"data"] allKeys] containsObject:@"subs"]){
                success(result[@"data"][@"subs"]);
            }
            
#pragma 返回数据少参数
/*
 data =     {
 cnt = 1;
 hasNext = 0;
 pageCnt = 10;
 pageNum = 0;
 subs =         (
 {
 id = 1;
 name = "jone smith";
 "picture_url" = "";
 }
 );
 };
 */
        }
        
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];
}

//得到咨询列表
- (void)startGetRefersWithAndSuccess:(void(^)(NSArray *refers))success failure:(void(^)(NSString *error_message))failure{
    NSDictionary *param = @{ @"pageNum":@"0"};
    
    
    [[NDNetManager sharedNetManager] get:@"/app/1/Consults?action=index" parameters:param success:^(NSDictionary *result) {
        FLog(@"%@",result);
        
        if([[result allKeys] containsObject:@"data"]){
#pragma 返回数据少参数
            /*
             
             */
        }
        
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];
}

// 得到用户的预约
- (void)startGetOrdersWithAndPage:(int)page success:(void(^)(NSArray *orders))success failure:(void(^)(NSString *error_message))failure{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:[NSString stringWithFormat:@"%d", page] forKey:@"pageNum"];
    
    [param setObject:@"10" forKey:@"pageCnt"];
    
    [[NDNetManager sharedNetManager] get:@"/app/1/Appointments" parameters:param success:^(NSDictionary *result) {
        FLog(@"%@",result);
        
        NSMutableArray *orders = [NSMutableArray array];
        
        if([[result allKeys] containsObject:@"data"]){
            if([[result[@"data"] allKeys] containsObject:@"subs"]){
                for(id obj in result[@"data"][@"subs"]){
                    NDOrder *order = [NDOrder mj_objectWithKeyValues:obj];
                    [orders addObject:order];
                }
                
                success(orders);
            }
        }
        
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];
};

//得到用户的病历列表
- (void)startGetEhrsWithAndPage:(int)page success:(void(^)(NSArray *ehrs))success failure:(void(^)(NSString *error_message))failure{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSString stringWithFormat:@"%d", page] forKey:@"pageNum"];
    
    [param setObject:@"10" forKey:@"pageCnt"];
    
    [[NDNetManager sharedNetManager] get:@"/app/1/Medhistorys?action=index" parameters:param success:^(NSDictionary *result) {
        FLog(@"%@",result);
        
        NSMutableArray *ehrs = [NSMutableArray array];
        
        if([[result allKeys] containsObject:@"data"]){
            if([[result[@"data"] allKeys] containsObject:@"subs"]){
                for(id obj in result[@"data"][@"subs"]){
                    NDEhr *ehr = [NDEhr mj_objectWithKeyValues:obj];
                    [ehrs addObject:ehr];
                }
                
                success(ehrs);
            }
        }
        
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];

}


//得到用户的绑定的诊室
- (void)startGetBindRoomsWithPage:(int)page andSuccess:(void(^)(NSArray *roomNames))success failure:(void(^)(NSString *error_message))failure{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:[NSString stringWithFormat:@"%d", page] forKey:@"pageNum"];
    
    [param setObject:@"10" forKey:@"pageCnt"];
     

    
    NSMutableArray *roomNames = [NSMutableArray array];
    
    [[NDNetManager sharedNetManager] get:@"/app/1/Binding?action=index" parameters:param success:^(NSDictionary *result) {
        FLog(@"%@",result);
        
        if([[result allKeys] containsObject:@"data"]){
            if([[result[@"data"] allKeys] containsObject:@"subs"]){
                for(id obj in result[@"data"][@"subs"]){
                    NSDictionary *temp = obj;
                    [roomNames addObject: temp];
                }
//                NSArray *roomNames = result[@"data"][@"subs"];
                success(roomNames);
            }
        }
        
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];
}

//绑定手机
- (void)startBindPhoneNumber:(NSString *)phoneNumber andVerifyCode:(NSString *)verifyCode  success:(void(^)())success failure:(void(^)(NSString *error_message))failure{
    NSDictionary *param = @{ @"mobile":phoneNumber,
                             @"smstoken":verifyCode};
    
    [[NDNetManager sharedNetManager] post:@"/Common/1/mobile?" parameters:param success:^(NSDictionary *result) {
        FLog(@"%@",result);
        
        success();
        
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];
}

//解绑手机
- (void)startCancelBindPhoneNumber:(NSString *)phoneNumber andVerifyCode:(NSString *)verifyCode  success:(void(^)())success failure:(void(^)(NSString *error_message))failure{
    NSDictionary *param = @{ @"action":@"del",
                             @"smstoken":verifyCode};
    
    [[NDNetManager sharedNetManager] post:@"/Common/1/mobile?" parameters:param success:^(NSDictionary *result) {
        FLog(@"%@",result);
        
        success();
        
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];
}

//上传图片
- (void)startUploadImageWithImages:(NSArray *)images  success:(void(^)(NSArray *imgUrls))success failure:(void(^)(NSString *error_message))failure{
    
    NSMutableArray *temp = [NSMutableArray arrayWithArray:images];
    
    if(images.count > 1){
        [temp removeLastObject];
    }
    
    
    [MBProgressHUD showMessage:@""];
    
    NSMutableArray *items = [NSMutableArray array];
    
    for(id obj in temp){
        if([obj isKindOfClass:[UIImage class]]){
            UIImage *image = obj;
            
            NSData *imageData = UIImageJPEGRepresentation(image, 0.05);
            //    NSString *dataStr = [[NSString alloc] initWithData:imageData encoding:NSUTF8StringEncoding];
            
            NSString *base64Str = [imageData base64EncodedStringWithOptions:0];
            
            NSString *fileName = [NSString stringWithFormat:@"%zd.png", datetime2Timestamp([NSDate date])];
            
            NSDictionary *item = @{@"pic_data":SafeString(base64Str),
                                   @"pic_name":fileName};
            
            [items addObject:item];
        }
    }
    
    
    
    
    
    FLog(@"%@", items);
    
    if(items == nil){
        return;
    }
    
    NSString *jsonStr = [items jsonString];
    
    NSDictionary *param = @{@"items":jsonStr};

    
    [[NDNetManager sharedNetManager] post:@"/app/1/Images" parameters:param success:^(NSDictionary *result) {
        
        [MBProgressHUD hideHUD];
        
        FLog(@"%@",result);
        
        NSMutableArray *imgUrls = [NSMutableArray array];
        
        if([[result allKeys] containsObject:@"data"]){
            for(int i = 0; i < items.count; i++){
                if([[result[@"data"] allKeys] containsObject:items[i][@"pic_name"]]){
                    NSString *imageUrl = result[@"data"][items[i][@"pic_name"]];
                    [imgUrls addObject:imageUrl];
                }
            }
            
            success(imgUrls);
        }
        
        failure([NSString stringWithFormat:@"retcode = %@", result[@"retcode"]]);
        
    } failure:^(NSString *error_message) {
        [MBProgressHUD hideHUD];
        
        failure(error_message);
    }];
}

//用户提交咨询
- (void)startSubmitQAWithContent:(NSString *)content andSubroomId:(NSString *)subroomId andSex:(NSString *)sex andAge:(NSString *)age andImgs:(NSArray *)imgs success:(void(^)())success failure:(void(^)(NSString *error_message))failure{
    
    NSDictionary *item = @{@"catalogid":SafeString(subroomId),
                           @"sex":SafeString(sex),
                           @"age":SafeString(age),
                           @"content":SafeString(content),
                           @"imgs":SafeArray(imgs),
                           @"doctorid":SafeString(@"")};
    
    NSArray *items = @[item];
    
    FLog(@"%@", items);
    
    if(items == nil){
        return;
    }
    
    NSString *jsonStr = [items jsonString];
    
    NSDictionary *param = @{@"items":jsonStr};
    
    FLog(@"param == %@", param);
    
    [[NDNetManager sharedNetManager] post:@"/app/1/Consults" parameters:param success:^(NSDictionary *result) {
        FLog(@"%@",result);
        success();
    } failure:^(NSString *error_message) {
        failure(error_message);
    }];
}

//浏览咨询列表
- (void)startGetQAListAndPage:(int)page success:(void(^)(NSArray *qaMessages))success failure:(void(^)(NSString *error_message))failure{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:[NSString stringWithFormat:@"%d", page] forKey:@"pageNum"];
    
    [param setObject:@"10" forKey:@"pageCnt"];
    
    
    [[NDNetManager sharedNetManager] get:@"/app/1/Consults?action=index" parameters:param success:^(NSDictionary *result) {
        FLog(@"%@",result);
        
        NSMutableArray *messages = [NSMutableArray array];
        
        if([[result allKeys] containsObject:@"data"]){
            if([[result[@"data"] allKeys] containsObject:@"subs"]){
                for(id obj in result[@"data"][@"subs"]){
                    
                    NDQAMessage *message = [NDQAMessage mj_objectWithKeyValues:obj];
                    
                    [messages addObject:message];
                }
                
                success(messages);
            }
        }
        
    } failure:^(NSString *error_message) {
        
        failure(error_message);
        
        
    }];
}

//浏览咨询
- (void)startGetQAWithQAId:(NSString *)qAId andPage:(int)page success:(void(^)(NSArray *talkMessages))success failure:(void(^)(NSString *error_message))failure{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSString stringWithFormat:@"%d", page] forKey:@"pageNum"];
    
    [param setObject:@"10" forKey:@"pageCnt"];
    
    [[NDNetManager sharedNetManager] get:[NSString stringWithFormat:@"/app/1/Consults/%@",qAId] parameters:param success:^(NSDictionary *result) {
        FLog(@"%@",result);
        
        
        NSMutableArray *talkMessages = [NSMutableArray array];
        
        if([[result allKeys] containsObject:@"data"]){
            if([[result[@"data"] allKeys] containsObject:@"talks"]){
                for(id obj in result[@"data"][@"talks"]){
                    NDTalkMessage *message = [NDTalkMessage mj_objectWithKeyValues:obj];
                    
                    [talkMessages addObject:message];
                }
                
                success(talkMessages);
            }
        }

        
        
    } failure:^(NSString *error_message) {
        
        failure(error_message);
        
        
    }];
}

//用户追加咨询
- (void)startSendTalkMessage:(NSString *)message andQAID:(NSString *)qAId success:(void(^)(NSArray *talkMessages))success failure:(void(^)(NSString *error_message))failure{
    NSDictionary *item = @{@"content":SafeString(message)};
    
    NSArray *items = @[item];
    
    FLog(@"%@", items);
    
    if(items == nil){
        return;
    }
    
    NSString *jsonStr = [items jsonString];
    
    FLog(@"%@", jsonStr);
    
    NSDictionary *param = @{@"items":jsonStr};
    
    [[NDNetManager sharedNetManager] post:[NSString stringWithFormat:@"/app/1/Consults/%@",qAId] parameters:param success:^(NSDictionary *result) {
        FLog(@"%@",result);
        
        
        
    } failure:^(NSString *error_message) {
        
        failure(error_message);
        
        
    }];
}

//浏览常见问题列表
- (void)startGetCommonQAListAndSuccess:(void(^)(NSArray *qAs))success failure:(void(^)(NSString *error_message))failure{
    NSDictionary *param = @{
                            @"pageNum":@"0",
                            @"catalogid":@"0"};
    
    [[NDNetManager sharedNetManager] get:@"/app/1/Faqs?action=index" parameters:param success:^(NSDictionary *result) {
        FLog(@"%@",result);
        
        
        NSMutableArray *commonQAs = [NSMutableArray array];
        
        if([[result allKeys] containsObject:@"data"]){
            if([[result[@"data"] allKeys] containsObject:@"subs"]){
                for(id obj in result[@"data"][@"subs"]){
                    NDCommonQA *qa = [NDCommonQA mj_objectWithKeyValues:obj];
                    
                    [commonQAs addObject:qa];
                }
                
                success(commonQAs);
            }
        }
        
        
        
    } failure:^(NSString *error_message) {
        
        failure(error_message);
        
        
    }];

}


//搜索常见问题
- (void)startGetQueryCommonQAListWithQuestion:(NSString *)question success:(void(^)(NSArray *qAs))success failure:(void(^)(NSString *error_message))failure{
    NSDictionary *param = @{};
    
    FLog(@"%@", question);
    
    [[NDNetManager sharedNetManager] get:[NSString stringWithFormat:@"/app/1/Faqs?query=%@", [SafeString(question) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] parameters:param success:^(NSDictionary *result) {
        FLog(@"%@",result);
        
        
        NSMutableArray *commonQAs = [NSMutableArray array];
        
        if([[result allKeys] containsObject:@"data"]){
            if([[result[@"data"] allKeys] containsObject:@"subs"]){
                for(id obj in result[@"data"][@"subs"]){
                    NDCommonQA *qa = [NDCommonQA mj_objectWithKeyValues:obj];
                    
                    [commonQAs addObject:qa];
                }
                
                success(commonQAs);
            }
        }
        
        
        
    } failure:^(NSString *error_message) {
        
        failure(error_message);
        
        
    }];

}

//发送反馈
- (void)startSendCallbackWithContent:(NSString *)content success:(void(^)())success failure:(void(^)(NSString *error_message))failure{
    NSDictionary *param = @{@"content":SafeString(content)};
    
    [[NDNetManager sharedNetManager] post:@"/app/1/Feedbacks" parameters:param success:^(NSDictionary *result) {
        FLog(@"%@",result);
        
        success();
        
    } failure:^(NSString *error_message) {
        
        failure(error_message);
        
        
    }];

}


//用户发表评价
- (void)startCommentDocWithOrderId:(NSString *)docId andRating:(NSString *)rating andContent:(NSString *)content success:(void(^)())success failure:(void(^)(NSString *error_message))failure{
    
    NSDictionary *param = @{@"id":SafeString(docId),
                            @"doctor_rating":@"1",
                            @"doctor_comment":SafeString(content)};
    
    [[NDNetManager sharedNetManager] post:[NSString stringWithFormat:@"/app/1/Appointments/%d", [docId intValue]] parameters:param success:^(NSDictionary *result) {
        FLog(@"%@",result);
        
        success();
        
    } failure:^(NSString *error_message) {
        
        failure(error_message);
        
        
    }];
}

//得到全部科室
- (void)startAllSubroomAndSuccess:(void(^)(NSArray *subrooms))success failure:(void(^)(NSString *error_message))failure{
    NSDictionary *param = @{};
    
    [[NDNetManager sharedNetManager] get:@"/app/1/catalog" parameters:param success:^(NSDictionary *result) {
        FLog(@"%@",result);
        
        NSMutableArray *subrooms = [NSMutableArray array];
        
        if([[result allKeys] containsObject:@"data"]){
            if([[result[@"data"] allKeys] containsObject:@"subs"]){
                for(id obj in result[@"data"][@"subs"]){
                    [subrooms addObject:obj[@"name"]];
                }
                
                success(subrooms);
            }
        }

        
        
    } failure:^(NSString *error_message) {
        
        failure(error_message);
        
        
    }];
}
@end
