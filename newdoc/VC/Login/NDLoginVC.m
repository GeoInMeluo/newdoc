 //
//  NDLoginVC.m
//  newdoc
//
//  Created by zzc on 15/10/21.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDLoginVC.h"
#import "NDPersonalRegistVC.h"
#import "NDPersonalCenterHomeVC.h"
#import "NDPersonalForgetPwdVC.h"
#import "NDBaseTabVC.h"
#import "NDBaseNavVC.h"
#import "NDPersonalRegistBindVC.h"

#import "UMComLoginManager.h"
#import "UMComUserAccount.h"

#import "UMSocialDataService.h"
#import "UMSocial.h"

#import "UMComFeed.h"
#import "UMComImageModel.h"
#import "UMComSession.h"
#import "UMComFeed+UMComManagedObject.h"

@interface NDLoginVC ()
@property (strong, nonatomic) IBOutlet FormCell *cellAccount;
@property (strong, nonatomic) IBOutlet FormCell *cellPwd;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UITextField *tfUsername;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (nonatomic, weak) Button *btnRegist;
@property (weak, nonatomic) IBOutlet Button *btnForgetPwd;

@end

@implementation NDLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

- (void)pop{
    if(self.isPresent){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    Button *btnRegist = [[Button alloc] initWithFrame:CGRectMake(0, 0, 73, 30)];
    [btnRegist setTitle:@"注册" forState:UIControlStateNormal];
    [btnRegist setTitleColor:Blue forState:UIControlStateNormal];
    btnRegist.layer.cornerRadius = 5;
    btnRegist.layer.masksToBounds = YES;
    btnRegist.layer.borderColor = Blue.CGColor;
    btnRegist.layer.borderWidth = 1;
    btnRegist.bottom = kScreenSize.height - 200;
    btnRegist.centerX = kScreenSize.width * 0.5;
    [btnRegist addTarget:self action:@selector(btnRegistClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnRegist];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)setupUI{
    WEAK_SELF;
    
    self.title = @"登录";
    
    [self appendSection:@[self.cellAccount,self.cellPwd] withHeader:nil];
    
    self.btnLogin.layer.cornerRadius = 5;
    self.btnLogin.layer.masksToBounds = YES;
    
    self.btnForgetPwd.callback = ^(Button *btn){
        [weakself.navigationController pushViewController:[NDPersonalForgetPwdVC new] animated:YES];
    };
}

- (IBAction)btnLoginClick:(UIButton *)sender {
    
    WEAK_SELF;
    
    if(self.tfUsername.text.length == 0){
        ShowAlert(@"请输入用户名");
        
        return;
    }
    
    if(self.tfPassword.text.length == 0){
        ShowAlert(@"请输入密码");
        
        return;
    }
    
    if(![self isPhoneText:self.tfUsername.text]){
        
        ShowAlert(@"请输入正确手机号");
        
        return;
    }
    
    [self startLoginWithUsername:self.tfUsername.text andPassWord:self.tfPassword.text success:^(NDUser *user){

        [weakself loginUMWithUsername:[NDCoreSession coreSession].user.name andID:[NDCoreSession coreSession].nduid andIconUrl:[NDCoreSession coreSession].user.picture_url];
        
        [weakself pop];

    } failure:^(NSString *error_message) {
        
    }];
}



- (IBAction)btnWechat:(id)sender {
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init ];
    
//    if([NDCoreSession coreSession].openId.length){
//        req.scope = @"snsapi_base" ;
//    }else{
        req.scope = @"snsapi_userinfo" ;
//    }
    
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
//    [WXApi sendAuthReq:req viewController:self delegate:self];
}

/*********实现和微信终端交互的具体请求与回应***********/
-(void) onReq:(BaseReq*)req{
    
}

//授权后回调 WXApiDelegate
-(void)onResp:(BaseReq *)resp
{
    WEAK_SELF;
    
    
    if(![resp isKindOfClass:[SendAuthResp class]]){//这种回调为分享
        
//        [MBProgressHUD showSuccess:@"分享成功"];
        
        return;
    }
    
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    SendAuthResp *aresp = (SendAuthResp *)resp;
    if (aresp.errCode== 0) {
        NSString *code = aresp.code;
        
        FLog(@"%@", code);
        FLog(@"%@", self);
        
        [self startRegistWithWXCode:code success:^(NSObject *resultDic) {
            
            __block NSDictionary * result = (NSDictionary *)resultDic;
            
            FLog(@"%@", resultDic);
            
            for(NSHTTPCookie *cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies){
                
                if([cookie.name isEqualToString:@"AUTHKEY"] ){
                    [[NSUserDefaults standardUserDefaults] setObject:cookie.value forKey:@"authkey"];
                }
                
                if([cookie.name isEqualToString:@"OPENID"] ){
                    [[NSUserDefaults standardUserDefaults] setObject:cookie.value forKey:@"openid"];
                }
                
            }
        
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"iswxlogin"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [NDCoreSession coreSession].openId = result[@"openid"];
            [NDCoreSession coreSession].authKey = result[@"authkey"];
            [NDCoreSession coreSession].isWxLogin = @"1";
            
            FLog(@"%@", self);
            
            [self startGetUserInfoAndSuccess:^(NDUser *user) {
                if(user != nil){
                    
                    [NDCoreSession coreSession].user = user;
                    
                    FLog(@"%@", [NDCoreSession coreSession].user.name);
                    
                    [self loginUMWithUsername:[NDCoreSession coreSession].user.name andID:[NDCoreSession coreSession].openId andIconUrl:[NDCoreSession coreSession].user.picture_url];
                    
                    NSString *tempPath =  NSTemporaryDirectory();
                    
                    NSString *filePath =  [tempPath stringByAppendingPathComponent:@"user.data"];
                    
                    [NSKeyedArchiver archiveRootObject:user toFile:filePath];
                    
                    FLog(@"%@", weakself);
                    FLog(@"%@", weakself.navigationController);
                    
                    if(user.mobile.length == 0){
                        NDBaseNavVC *nav = [[NDBaseNavVC alloc] initWithRootViewController:[NDPersonalRegistBindVC new]];
                        
                        [[UIApplication sharedApplication].keyWindow setRootViewController:nav];
                        
                    }else{
                        NDBaseTabVC *tabVC = [NDBaseTabVC new];
                        tabVC.selectedIndex = 2;
                        [[UIApplication sharedApplication].keyWindow setRootViewController:tabVC];
                    }
                    
                    
                }
            } failure:^(NSString *error_message) {
                
            }];
            
        } failure:^(NSString *error_message) {
            
        }];
    }
}
/********************/

- (IBAction)btnQQ:(id)sender {
    ShowAlert(@"敬请期待~");
}

-(BOOL)isPhoneText:(NSString *)str
{
    NSString * regex        = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch            = [pred evaluateWithObject:str];
    if (isMatch) {
        return YES;
    }else{
        return NO;
    }
}

- (void)btnRegistClick{
    ShowVC(NDPersonalRegistVC);
}

- (void)loginUMWithUsername:(NSString *)username andID:(NSString *)ID andIconUrl:(NSString *)url{
//    //把用户资料上传到友盟
    UMComUserAccount *userAccount = [[UMComUserAccount alloc] initWithSnsType:UMComSnsTypeSelfAccount];     //使用UMComSnsTypeSelfAccount代表自定义登录，该枚举类型必须和安卓SDK保持一致，否则会出现不能对应同一用户的问题
    
    
    ID = [ID stringByReplacingOccurrencesOfString:@" " withString:@""];
    userAccount.usid = ID;
    username = [username stringByReplacingOccurrencesOfString:@" " withString:@""];
    userAccount.name = username;
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@""];
    userAccount.icon_url = url; //登录用户头像
    // 将数据传递给友盟微社区SDK
    [UMComLoginManager finishLoginWithAccount:userAccount completion:^(NSArray *data, NSError *error) {
//        [UMComLoginManager finishDismissViewController:self data:data error:error];
    }];
}

- (void)presentLoginViewController:(UIViewController *)viewController finishResponse:(LoadDataCompletion)loginCompletion{
    
    CreateVC(NDLoginVC);
    vc.isPresent = YES;
    NDBaseNavVC *nav = [[NDBaseNavVC alloc] initWithRootViewController:vc];
    [viewController presentViewController:nav animated:YES completion:nil];
}

/**
 点击某个分享平台之后的回调方法
 
 @param platformName 分享平台名
 @param feed 分享的当条Feed
 @param viewController 当前ViewController
 
 */
- (void)didSelectPlatform:(NSString *)platformName
                     feed:(UMComFeed *)feed
           viewController:(UIViewController *)viewControlller{
    
    UMComFeed *shareFeed = nil;
    if (feed.origin_feed) {
        shareFeed = feed.origin_feed;
    } else{
        shareFeed = feed;
    }
//    self.feed = feed;
    NSArray *imageModels = [feed imageModels];
    UMComImageModel *imageModel = nil;
    if (imageModels.count > 0) {
        imageModel = [[shareFeed imageModels] firstObject];
    }
    NSString *imageUrl = imageModel.smallImageUrlString;//[[shareFeed.images firstObject] valueForKey:@"360"];
    
    //取转发的feed才有链接
    NSString *urlString = feed.share_link;
    urlString = [NSString stringWithFormat:@"%@?ak=%@&platform=%@",urlString,[UMComSession sharedInstance].appkey,platformName];
    [UMSocialData defaultData].extConfig.qqData.url = urlString;
    [UMSocialData defaultData].extConfig.qzoneData.url = urlString;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = urlString;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = urlString;
    
    NSString *shareText = [NSString stringWithFormat:@"%@ %@",shareFeed.text,urlString];
//    NSString *feedString = [shareFeed.text substringToIndex:MaxShareLength - MaxLinkLength];
    [UMSocialData defaultData].extConfig.sinaData.shareText = shareText;
    
    [UMSocialData defaultData].title = shareFeed.text;
    
    UIImage *shareImage = nil;
    if (imageUrl) {
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:imageUrl];
    } else{
        shareImage = UMComImageWithImageName(@"icon");
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeDefault];
    }

    
    [UMSocialData defaultData].extConfig.sinaData.shareText = shareText;
    
    [UMSocialData defaultData].title = shareFeed.text;
    
    [[UMSocialControllerService defaultControllerService] setShareText:shareFeed.text shareImage:shareImage socialUIDelegate:self];
    
    UMSocialSnsPlatform *socialPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
    socialPlatform.snsClickHandler(viewControlller,[UMSocialControllerService defaultControllerService],YES);
    
//        NSString *platformName = [self.platformArray objectAtIndex:indexPath.row] ;
//        [[UMComLoginManager getLoginHandler] didSelectPlatform:platformName feed:self.feed viewController:self.shareViewController];
//        [self dismiss];
//        if (self.didSelectedIndex) {
//            self.didSelectedIndex(indexPath);
//        }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tfPassword resignFirstResponder];
    [self.tfUsername resignFirstResponder];
}
@end
