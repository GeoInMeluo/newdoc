//
//  NDPersonalForgetPwdVC.m
//  newdoc
//
//  Created by zzc on 15/11/6.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDPersonalForgetPwdVC.h"
#import "NDPersonalResetPwd.h"

@interface NDPersonalForgetPwdVC ()
@property (strong, nonatomic) IBOutlet FormCell *cellPhoneNumber;
@property (strong, nonatomic) IBOutlet FormCell *cellVerifyCode;

@property (weak, nonatomic) IBOutlet UITextField *tfPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *tfVerifyCode;
@property (weak, nonatomic) IBOutlet UIButton *btnVerifyCode;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;


@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger startTime;

@end

@implementation NDPersonalForgetPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI{
    self.title = @"找回密码";
    
    self.startTime = 60;
    
    [self appendSection:@[self.cellPhoneNumber] withHeader:nil];
    [self appendSection:@[self.cellVerifyCode] withHeader:self.tempSectionHeader];
    
    self.btnVerifyCode.layer.cornerRadius = self.btnVerifyCode.height / 2;
    self.btnVerifyCode.layer.masksToBounds = YES;
    
    self.btnConfirm.layer.cornerRadius = 5;
    self.btnConfirm.layer.masksToBounds = YES;
}

- (IBAction)btnVerifyCodeClicked:(id)sender {
    
    [self timeStart];
    
    [self startSendVerifyCodeForUpdatePasswordWithPhoneNumber:self.tfPhoneNumber.text success:^(NSObject *resultDic) {
        
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
    
    [self.btnVerifyCode setTitle:[NSString stringWithFormat:@"%zd  s",_startTime] forState:UIControlStateNormal];
    
    if(_startTime == 0){
        self.btnVerifyCode.enabled = YES;
        [self timeStop];
        _startTime = 60;
        [self.btnVerifyCode setTitle:@"重新发送" forState:UIControlStateNormal];
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.timer = nil;
}

- (IBAction)btnConfirmClicked:(id)sender {
    CreateVC(NDPersonalResetPwd);
    vc.phoneNumber = self.tfPhoneNumber.text;
    vc.verifyCode = self.tfVerifyCode.text;
    PushVC(vc);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
