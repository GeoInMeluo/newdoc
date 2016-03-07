//
//  NCNetManager.m
//  newdoc
//
//  Created by zzc on 15/10/9.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDNetManager.h"
#import "NDLoginVC.h"
#import "NDBaseNavVC.h"

@implementation NDNetManager

+ (instancetype)sharedNetManager {
    static NDNetManager *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kHostStr]];

        NSMutableSet *set = [NSMutableSet setWithSet:instance.responseSerializer.acceptableContentTypes];
        [set addObject:@"text/html"];
        [set addObject:@"text/plain"];
        [set addObject:@"text/xml"];
        instance.responseSerializer.acceptableContentTypes = set;
        
    });
    return instance;
}

- (void)post:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSDictionary *result))success failure:(void (^)(NSString *error_message))failure{
    
    
    
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] isEqualToString:@""]){
        
        
        NSString *base64Str = [NSString base64StringFromData:[[NSString stringWithFormat:@"%@:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],[[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"]] dataUsingEncoding:NSUTF8StringEncoding] length:0];
        
        FLog(@"%@", base64Str);
        NSString *finalString = [NSString stringWithFormat:@"Basic %@",base64Str];
        
        [[NDNetManager sharedNetManager].requestSerializer setValue:finalString forHTTPHeaderField:@"Authorization"];
    }
    
    NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    FLog(@"iswxlogin == %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"iswxlogin"]);
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"iswxlogin"] isEqualToString:@"1"]){
        [parm setObject:SafeString([NDCoreSession coreSession].openId) forKey:@"openid"];
        [parm setObject:SafeString([NDCoreSession coreSession].authKey) forKey:@"authkey"];
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"iswxlogin"] isEqualToString:@"0"]){
        [parm setObject:SafeString([NDCoreSession coreSession].nduid) forKey:@"nduid"];
    }
    
    FLog(@"parm == %@", parm);
    
    //使用完cookie之后禁用cookie
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    
    
    FLog(@"currentThread %@", [NSThread currentThread]);
        
    [self POST:URLString parameters:parm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        FLog(@"%@",responseObject);
        
        [MBProgressHUD hideHUD];
        
        if(![responseObject isKindOfClass:[NSDictionary class]]){
            
            [MBProgressHUD showError:@"response格式错误"];
            
            return ;
        }
        
        NSDictionary *result = responseObject;
        
        if([[result allKeys] containsObject:@"authkey"]){
            [NDCoreSession coreSession].authKey = result[@"authkey"];
            [[NSUserDefaults standardUserDefaults] setObject:result[@"authkey"] forKey:@"authkey"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        if([[result allKeys] containsObject:@"retcode"]){
            if([result[@"retcode"] isEqualToString:@"0"]){
                success(result);
            }else if([[result allKeys] containsObject:@"errmsg"]){
                [MBProgressHUD showError:result[@"errmsg"]];
                failure(result[@"errmsg"]);
            }else if([result[@"retcode"] isEqualToString:@"1"]){
                [MBProgressHUD showError:@"GET 参数错误"];
                failure(@"GET 参数错误");
            }else if([result[@"retcode"] isEqualToString:@"2"]){
                [MBProgressHUD showError:@"POST参数错误"];
                failure(@"POST参数错误");
            }else if([result[@"retcode"] isEqualToString:@"5"]){
                [MBProgressHUD showError:@"空结果"];
                failure(@"空结果");
            }else if([result[@"retcode"] isEqualToString:@"6"]){
                [MBProgressHUD showError:@"授权问题"];
                failure(@"授权问题");
            }else if([result[@"retcode"] isEqualToString:@"7"]){
//                [MBProgressHUD showError:@"列表为空"];
//                failure(@"列表为空");
                success(result);
            }else if([result[@"retcode"] isEqualToString:@"8"]){
                
                NDLoginVC *loginVC = [NDLoginVC new];
                loginVC.isPresent = YES;
                
                NDBaseNavVC *nav = [[NDBaseNavVC alloc] initWithRootViewController:loginVC];
                
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
                
                [MBProgressHUD showError:@"登陆失败"];
                failure(@"登陆失败");
            }else if([result[@"retcode"] isEqualToString:@"9"]){
                
                //                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[NDLoginVC new] animated:YES completion:nil];
                
                                    [MBProgressHUD showError:@"用户未注册"];
                                    failure(@"用户未注册");
                
                //构造SendAuthReq结构体
                //                    SendAuthReq* req =[[SendAuthReq alloc ] init ];
                
                //                    req.scope = @"snsapi_userinfo";
                //
                //                    req.state = @"123" ;
                //第三方向微信终端发送一个SendAuthReq消息结构
                //                    [WXApi sendReq:req];
            }
            else if([result[@"retcode"] isEqualToString:@"10"]){
                [MBProgressHUD showError:@"用户权限不够"];
                failure(@"用户权限不够");
            }
            else if([result[@"retcode"] isEqualToString:@"11"]){
                [MBProgressHUD showError:@"非法请求"];
                failure(@"非法请求");
            }
            else if([result[@"retcode"] isEqualToString:@"12"]){
                [MBProgressHUD showError:@"请求失败"];
                failure(@"请求失败");
            }
        }else if([[result allKeys] containsObject:@"errmsg"]){
            [MBProgressHUD showError:result[@"errmsg"]];
            failure(result[@"errmsg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FLog(@"%@", operation.response);
        
        NSInteger erroCode = operation.response.statusCode;
        
        [MBProgressHUD showError:[NSString stringWithFormat:@"网络请求失败 erroCode = %zd", erroCode]];
        failure([NSString stringWithFormat:@"网络请求失败 erroCode = %zd", erroCode]);
    }];
    
    
//    return operation;
}

- (AFHTTPRequestOperation *)get:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSDictionary *result))success failure:(void (^)(NSString *error_message))failure{
    
    FLog(@"%@",URLString);
    
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] isEqualToString:@""]){
        
        
        NSString *base64Str = [NSString base64StringFromData:[[NSString stringWithFormat:@"%@:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"username"],[[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"]] dataUsingEncoding:NSUTF8StringEncoding] length:0];
        
        FLog(@"%@", base64Str);
        NSString *finalString = [NSString stringWithFormat:@"Basic %@",base64Str];
        
        [[NDNetManager sharedNetManager].requestSerializer setValue:finalString forHTTPHeaderField:@"Authorization"];
    }

    
    NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    FLog(@"iswxlogin == %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"iswxlogin"]);
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"iswxlogin"] isEqualToString:@"1"]){
        [parm setObject:SafeString([NDCoreSession coreSession].openId) forKey:@"openid"];
        [parm setObject:SafeString([NDCoreSession coreSession].authKey) forKey:@"authkey"];
    }else{
        [parm setObject:SafeString([NDCoreSession coreSession].nduid) forKey:@"nduid"];
    }
    
    FLog(@"parm == %@", parm);
    
    
    //使用完cookie之后禁用cookie
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    
    AFHTTPRequestOperation *operation = [self GET:URLString parameters:parm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        WEAK_SELF;
        
        FLog(@"%@", responseObject);
        
        [MBProgressHUD hideHUD];

        if(![responseObject isKindOfClass:[NSDictionary class]]){
            
            [MBProgressHUD showError:@"response格式错误"];
            
            return ;
        }
        
        NSDictionary *result = responseObject;
        
        if([[result allKeys] containsObject:@"authkey"]){
            [NDCoreSession coreSession].authKey = result[@"authkey"];
            [[NSUserDefaults standardUserDefaults] setObject:result[@"authkey"] forKey:@"authkey"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        if([[result allKeys] containsObject:@"retcode"]){
                if([result[@"retcode"] isEqualToString:@"0"]){
                    success(result);
                }else if([[result allKeys] containsObject:@"errmsg"]){
                    [MBProgressHUD showError:result[@"errmsg"]];
                    failure(result[@"errmsg"]);
                }else if([result[@"retcode"] isEqualToString:@"1"]){
                    [MBProgressHUD showError:@"GET 参数错误"];
                    failure(@"GET 参数错误");
                }else if([result[@"retcode"] isEqualToString:@"2"]){
                    [MBProgressHUD showError:@"POST参数错误"];
                    failure(@"POST参数错误");
                }else if([result[@"retcode"] isEqualToString:@"5"]){
                    [MBProgressHUD showError:@"空结果"];
                    failure(@"空结果");
                }else if([result[@"retcode"] isEqualToString:@"6"]){
                    [MBProgressHUD showError:@"授权问题"];
                    failure(@"授权问题");
                }else if([result[@"retcode"] isEqualToString:@"7"]){
//                    [MBProgressHUD showError:@"列表为空"];
//                    failure(@"列表为空");
                    success(result);
                }else if([result[@"retcode"] isEqualToString:@"8"]){
                    
                    NDLoginVC *loginVC = [NDLoginVC new];
                    loginVC.isPresent = YES;
                    
                    NDBaseNavVC *nav = [[NDBaseNavVC alloc] initWithRootViewController:loginVC];
                    
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
                    
                    [MBProgressHUD showError:@"登陆失败"];
                    failure(@"登陆失败");
                    
                    //构造SendAuthReq结构体
                    //                    SendAuthReq* req =[[SendAuthReq alloc ] init ];
                    
                    //                    req.scope = @"snsapi_base" ;
                    //
                    //                    req.state = @"123" ;
                    //第三方向微信终端发送一个SendAuthReq消息结构
                    //                    [WXApi sendReq:req];
                    
                    //                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[NDLoginVC new] animated:YES completion:nil];
                }else if([result[@"retcode"] isEqualToString:@"9"]){
                    
                    //                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[NDLoginVC new] animated:YES completion:nil];
                    
                    [MBProgressHUD showError:@"用户未注册"];
                    failure(@"用户未注册");
                    
                    //构造SendAuthReq结构体
                    //                    SendAuthReq* req =[[SendAuthReq alloc ] init ];
                    
                    //                    req.scope = @"snsapi_userinfo";
                    //
                    //                    req.state = @"123" ;
                    //第三方向微信终端发送一个SendAuthReq消息结构
                    //                    [WXApi sendReq:req];
                }
                else if([result[@"retcode"] isEqualToString:@"10"]){
                    [MBProgressHUD showError:@"用户权限不够"];
                    failure(@"用户权限不够");
                }
                else if([result[@"retcode"] isEqualToString:@"11"]){
                    [MBProgressHUD showError:@"非法请求"];
                    failure(@"非法请求");
                }
                else if([result[@"retcode"] isEqualToString:@"12"]){
                    [MBProgressHUD showError:@"请求失败"];
                    failure(@"请求失败");
                }
        }else if([[result allKeys] containsObject:@"errmsg"]){
            [MBProgressHUD showError:result[@"errmsg"]];
            failure(result[@"errmsg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        FLog(@"%@", operation.response);
        
        NSInteger erroCode = operation.response.statusCode;
        
        [MBProgressHUD showError:[NSString stringWithFormat:@"网络请求失败 erroCode = %zd", erroCode]];
        failure([NSString stringWithFormat:@"网络请求失败 erroCode = %zd", erroCode]);
    }];
    
    return operation;
}

///*********实现和微信终端交互的具体请求与回应***********/
//-(void) onReq:(BaseReq*)req{
//    
//}

////授权后回调 WXApiDelegate
//-(void)onResp:(BaseReq *)resp
//{
//    WEAK_SELF;
//    
//    /*
//     ErrCode ERR_OK = 0(用户同意)
//     ERR_AUTH_DENIED = -4（用户拒绝授权）
//     ERR_USER_CANCEL = -2（用户取消）
//     code    用户换取access_token的code，仅在ErrCode为0时有效
//     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
//     lang    微信客户端当前语言
//     country 微信用户当前国家信息
//     */
//    SendAuthResp *aresp = (SendAuthResp *)resp;
//    if (aresp.errCode== 0) {
//        NSString *code = aresp.code;
//        
//        [self startRegistWithWXCode:code success:^(NSObject *resultDic) {
//            
//            __block NSDictionary * result = (NSDictionary *)resultDic;
//            
//            [weakself startGetUserInfoAndSuccess:^(NDUser *user) {
//                if(user != nil){
//                    [[NSUserDefaults standardUserDefaults] setObject:result[@"openid"] forKey:@"openid"];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//                    [NDCoreSession coreSession].openId = result[@"openid"];
//                    [NDCoreSession coreSession].user = user;
//                    
//                    
//                    NSString *tempPath =  NSTemporaryDirectory();
//                    
//                    NSString *filePath =  [tempPath stringByAppendingPathComponent:@"user.data"];
//                    
//                    [NSKeyedArchiver archiveRootObject:user toFile:filePath];
//                    
//                }
//            } failure:^(NSString *error_message) {
//                
//            }];
//            
//        } failure:^(NSString *error_message) {
//            
//        }];
//    }
//}
///********************/
@end
