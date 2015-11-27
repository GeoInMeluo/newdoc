//
//  NDAdvanceVC.m
//  newdoc
//
//  Created by zzc on 15/11/27.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDAdvanceVC.h"

@interface NDAdvanceVC ()
@property (weak, nonatomic) IBOutlet Button *btnSend;
@property (weak, nonatomic) IBOutlet UITextView *tv;

@end

@implementation NDAdvanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI{
    WEAK_SELF;
    
    self.showKeyboardViews = @[self.tv];
    
    self.title = @"意见反馈";
    
    self.btnSend.layer.cornerRadius = 5;
    self.btnSend.layer.masksToBounds = YES;
    
    self.btnSend.callback = ^(Button *btn){
        [weakself startSendCallbackWithContent:self.tv.text success:^{
            [MBProgressHUD showSuccess:@"反馈已发送"];
            
            [weakself.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString *error_message) {
            
        }];
    };
}

@end
