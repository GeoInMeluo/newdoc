//
//  NDPersonalRegistVC.m
//  newdoc
//
//  Created by zzc on 15/10/22.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDPersonalRegistVC.h"
#import "NDPersonalCenterHomeVC.h"
#import "NDUser.h"

@interface NDPersonalRegistVC ()
@property (strong, nonatomic) IBOutlet FormCell *cellPhoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnRegist;
@property (strong, nonatomic) IBOutlet FormCell *cellPwd;
@property (strong, nonatomic) IBOutlet FormCell *cellConfirmPwd;
@property (strong, nonatomic) IBOutlet FormCell *cellVerifyCode;

@property (weak, nonatomic) IBOutlet UITextField *tfPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *tfPwd;
@property (weak, nonatomic) IBOutlet UITextField *tfPwdConfirm;
@property (weak, nonatomic) IBOutlet UITextField *tfVerifyCode;
@property (weak, nonatomic) IBOutlet UIButton *btnVerifyCode;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger startTime;

@property (weak, nonatomic) IBOutlet Button *btnAgree;

@end

@implementation NDPersonalRegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI{
    self.startTime = 60;
    
    self.title = @"注册";
    
    self.btnVerifyCode.layer.masksToBounds = YES;
    self.btnVerifyCode.layer.cornerRadius = self.btnVerifyCode.height / 2;
    
    self.btnRegist.layer.cornerRadius = 5;
    self.btnRegist.layer.masksToBounds = YES;
    
    self.btnAgree.callback = ^(Button *btn){
        btn.selected = !btn.selected;
    };
    
    [self appendSection:@[self.cellPhoneNumber,self.cellPwd,self.cellConfirmPwd] withHeader:nil];
    
    [self appendSection:@[self.cellVerifyCode] withHeader:self.tempSectionHeader];
}

- (IBAction)btnVerifyCodeClick:(id)sender {
    if(![self isPhoneText:self.tfPhoneNumber.text]){
        
        ShowAlert(@"请输入正确手机号");
        
        return;
    }
    
    [self timeStart];
    
    [self startSendVerifyCodeWithPhoneNumber:self.tfPhoneNumber.text success:^(NSObject *resultDic) {

    }  failure:^(NSString *error_message) {
        
    }];
}

- (void)timeStart{
    self.btnVerifyCode.enabled = NO;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeBtnVerifyTitle) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    [self.timer fire];
    
}

- (void)timeStop{
    [self.timer invalidate];
    
    self.timer = nil;
}

- (void)changeBtnVerifyTitle{

    _startTime--;
    
//    self.btnVerifyCode.enabled = NO;
    
    [self.btnVerifyCode setTitle:[NSString stringWithFormat:@"%zd  s",_startTime] forState:UIControlStateNormal];
    
    if(_startTime == 0){
        self.btnVerifyCode.enabled = YES;
        [self timeStop];
        _startTime = 60;
        [self.btnVerifyCode setTitle:@"重新发送" forState:UIControlStateNormal];
    }
    
    
}

- (IBAction)btnRegistClick:(id)sender {
    WEAK_SELF;
    
    if(![self isPhoneText:self.tfPhoneNumber.text]){
        
        ShowAlert(@"请输入正确手机号");
        
        return;
    }
    
    if(self.tfVerifyCode.text.length == 0 ){
        ShowAlert(@"请输入验证码");
        
        return;
    }
    
    if(self.tfPhoneNumber.text.length == 0 ){
        ShowAlert(@"请输入手机号");
        
        return;
    }
    
    if(self.tfPwd.text.length == 0 ){
        ShowAlert(@"请输入密码");
        
        return;
    }
    
    if(self.tfPwdConfirm.text.length == 0 ){
        ShowAlert(@"请再次输入密码");
        
        return;
    }
    
    if(![self.tfPwd.text isEqualToString:self.tfPwdConfirm.text]){
        ShowAlert(@"两次输入的密码不一致");
        
        return;
    }
    
    if(!self.btnAgree.selected){
        ShowAlert(@"请阅读新医协议，同意打钩");
        
        return;
    }
    
//    NDUser *user = [[NDUser alloc] init];
//    user.name = @"test";
//    user.picture_url = [[NSBundle mainBundle] pathForResource:@"testUserIcon" ofType:nil];
//    user.mobile = self.tfPhoneNumber.text;
//    [NDCoreSession coreSession].user = user;
//    
//    for (UIViewController *controller in self.navigationController.viewControllers) {
//        if ([controller isKindOfClass:[NDPersonalCenterHomeVC class]]) {
//            
//            [weakself.navigationController popToViewController:controller animated:YES];
//        }
//    }
    
    [[NDCoreSession coreSession] logout];
    
    [self startRegistWithUsername:self.tfPhoneNumber.text andPassWord:self.tfPwd.text andVerifyCode:self.tfVerifyCode.text andPhoneNumber:self.tfPhoneNumber.text success:^{
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[NDPersonalCenterHomeVC class]]) {
                [weakself.navigationController popToViewController:controller animated:YES];
            }
        }
    } failure:^(NSString *error_message) {
        
    }];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.timer = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tfPhoneNumber resignFirstResponder];
    [self.tfPwd resignFirstResponder];
    [self.tfPwdConfirm resignFirstResponder];
    [self.tfVerifyCode resignFirstResponder];
}

@end
