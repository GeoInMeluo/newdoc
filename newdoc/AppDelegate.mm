//
//  AppDelegate.m
//  newdoc
//
//  Created by zzc on 15/10/9.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "AppDelegate.h"
#import "NDBaseNavVC.h"
#import "NDBaseTabVC.h"
#import "UMCommunity.h"
#import "UMCommunity.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "APService.h"
#import "NDLoginVC.h"
#import "NDGuideVC.h"
#import "UMComLoginManager.h"
#import "UMSocialWechatHandler.h"

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>


//新浪微博SDK头文件
//#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

#import "AFNetworking.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     
    
//    [[NCNetManager sharedNetManager] GET:@"/app/1/catalog?action=detail" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *responseObj = responseObject;
//        NSLog(@"%@", responseObj);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];

    [self setupUMShare];
    
    [self setupWechatLogin];
    
    [self setupBaiduMap];
//
//    [self setupShareSdk3rd];
    
    [self setupJPush:launchOptions];
    
    [self setupUmengCommunity];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    NSString *versionStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    
    if(versionStr.length == 0 || [versionStr intValue] < kVersion){
        //启动引导页
        
        self.window.rootViewController = [NDGuideVC new];
        
        
        
    }else{
        NDBaseTabVC *tabVC = [[NDBaseTabVC alloc] init];
        
        self.window.rootViewController = tabVC;
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setupUMShare{
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx4868b35061f87885" appSecret:@"64020361b8ec4c99936c0e3999a9f249" url:@"http://www.umeng.com/social"];

}

- (void)setupWechatLogin{
    //向微信注册
//    [WXApi registerApp:@"wx79dcda258b479eeb" withDescription:@"weixin"];
    [WXApi registerApp:@"wxe5684b360ca8305b" withDescription:@"weixin"];
}


- (void)setupUmengCommunity{
    //社区
    [UMCommunity setWithAppKey:@"5617f55b67e58ee20a002fa8"];  //需要修改微社区的Appkey
    
    //设置社区登录界面为自定义界面
    NDLoginVC *loginViewController = [NDLoginVC new];
    [UMComLoginManager setLoginHandler:loginViewController];
}

- (void)setupJPush:(NSDictionary *)launchOptions{
    // Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    
    // Required
    [APService setupWithOption:launchOptions];
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    FLog(@"%@", userInfo);
    
    // Required
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    FLog(@"%@", userInfo);
    
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)setupBaiduMap{
//    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
//    
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        
//        [locationManager requestWhenInUseAuthorization];
//        
//    }
    
    // 要使用百度地图，请先启动
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"GrclsmilW2yIY4Q75Q7VCgZx"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

/*和QQ,新浪并列回调句柄*********/

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    return [WXApi handleOpenURL:url delegate:[NDLoginVC new]];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    
    return [TencentOAuth HandleOpenURL:url]  ||
    [WXApi handleOpenURL:url delegate:[NDLoginVC new]];
//    return [WXApi handleOpenURL:url delegate:[NDLoginVC new]];
}
/*******************/


- (void)applicationWillResignActive:(UIApplication *)application {
    [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [BMKMapView didForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
}

- (void)setupShareSdk3rd{
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"b0ffff49fe58"
     
          activePlatforms:@[
//                            @(SSDKPlatformTypeSinaWeibo),
//                            @(SSDKPlatformTypeMail),
//                            @(SSDKPlatformTypeSMS),
//                            @(SSDKPlatformTypeCopy),
                            @(SSDKPlatformTypeWechat)
//                            @(SSDKPlatformTypeQQ),
//                            @(SSDKPlatformTypeRenren),
//                            @(SSDKPlatformTypeGooglePlus)
                            ]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
//             case SSDKPlatformTypeQQ:
//                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
//                 break;
//             case SSDKPlatformTypeSinaWeibo:
//                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
//                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
//             case SSDKPlatformTypeSinaWeibo:
//                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
//                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
//                                         redirectUri:@"http://www.sharesdk.cn"
//                                            authType:SSDKAuthTypeBoth];
//                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                       appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                 break;
//             case SSDKPlatformTypeQQ:
//                 [appInfo SSDKSetupQQByAppId:@"100371282"
//                                      appKey:@"aed9b0303e3ed1e27bae87c33761161d"
//                                    authType:SSDKAuthTypeBoth];
//                 break;
//             case SSDKPlatformTypeRenren:
//                 [appInfo        SSDKSetupRenRenByAppId:@"226427"
//                                                 appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
//                                              secretKey:@"f29df781abdd4f49beca5a2194676ca4"
//                                               authType:SSDKAuthTypeBoth];
//                 break;
//             case SSDKPlatformTypeGooglePlus:
//                 [appInfo SSDKSetupGooglePlusByClientID:@"232554794995.apps.googleusercontent.com"
//                                           clientSecret:@"PEdFgtrMw97aCvf0joQj7EMk"
//                                            redirectUri:@"http://localhost"
//                                               authType:SSDKAuthTypeBoth];
//                 break;
             default:
                 break;
         }
     }];

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
