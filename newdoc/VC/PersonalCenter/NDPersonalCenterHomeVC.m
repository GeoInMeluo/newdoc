//
//  NDPersonalCenterHomeVC.m
//  newdoc
//
//  Created by zzc on 15/10/19.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDPersonalCenterHomeVC.h"
#import "NDPersonalInfo.h"
#import "NDLoginVC.h"
#import "NDPersonalEhrVC.h"
#import "NDSettingTableViewController.h"
#import "NDPersonalBindingRoomVC.h"
#import "NDPersonalReferVC.h"
//#import "NDRoomOrderVC.h"
#import "NDPersonalAttentionDocVC.h"
#import "NDPersonalOrderVC.h"

@interface NDPersonalCenterHomeVC ()<UITableViewDataSource,UITabBarDelegate>
@property (strong, nonatomic) IBOutlet FormCell *cellInfomation;
@property (strong, nonatomic) IBOutlet FormCell *cellRefer;
@property (strong, nonatomic) IBOutlet FormCell *cellSetting;
@property (strong, nonatomic) IBOutlet FormCell *cellMineRoom;
@property (strong, nonatomic) IBOutlet FormCell *cellMineDoc;
@property (strong, nonatomic) IBOutlet FormCell *cellOrder;
@property (strong, nonatomic) IBOutlet FormCell *cellEhr;
@property (weak, nonatomic) IBOutlet UIButton *headImg;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIView *vAccountAndPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblAccount;
@property (weak, nonatomic) IBOutlet UILabel *lblPhoneNumber;

@end

@implementation NDPersonalCenterHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI{
    [self initCells];
    
    self.headImg.layer.cornerRadius = self.headImg.width * 0.5;
    self.headImg.layer.masksToBounds = YES;
    self.headImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headImg.layer.borderWidth = 2;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if([NDCoreSession coreSession].openId.length != 0){
        self.vAccountAndPhone.hidden = NO;
        
        UIImage *tempImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NDCoreSession coreSession].user.picture_url]]];
        tempImage = [tempImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [self.headImg setImage:tempImage forState:UIControlStateNormal];
        
        self.lblAccount.text = [NDCoreSession coreSession].user.name;
        self.lblPhoneNumber.text = [NDCoreSession coreSession].user.mobile;
        self.btnLogin.hidden = YES;
    }else{
        self.vAccountAndPhone.hidden = YES;
        self.btnLogin.hidden = NO;
    }
}

- (void)initCells{
    WEAK_SELF;
    
    [self appendSection:@[self.cellInfomation,self.cellMineDoc,self.cellRefer,self.cellOrder,self.cellEhr,self.cellMineRoom,self.cellSetting] withHeader:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.001, 0.001)]];
 
    self.cellInfomation.callback = ^(FormCell *cell, NSIndexPath *indexPath){
        
        if([weakself checkLoginWithNav:weakself.navigationController]){
            CreateVC(NDPersonalInfo);
            
            PushVCWeak(vc);
        }
    
    };
    
    self.cellEhr.callback = ^(FormCell *cell, NSIndexPath *indexPath){
        if([weakself checkLoginWithNav:weakself.navigationController]){
            ShowVCWeak(NDPersonalEhrVC);
        }
    };
    
    self.cellMineDoc.callback = ^(FormCell *cell, NSIndexPath *indexPath){
        if([weakself checkLoginWithNav:weakself.navigationController]){
            ShowVCWeak(NDPersonalAttentionDocVC);
        }
    };
    
    self.cellMineRoom.callback = ^(FormCell *cell, NSIndexPath *indexPath){
        if([weakself checkLoginWithNav:weakself.navigationController]){
            ShowVCWeak(NDPersonalBindingRoomVC);
        }
    };
    
    self.cellOrder.callback = ^(FormCell *cell, NSIndexPath *indexPath){
        if([weakself checkLoginWithNav:weakself.navigationController]){
        
            ShowVCWeak(NDPersonalOrderVC);
        }
    };
    
    self.cellRefer.callback = ^(FormCell *cell, NSIndexPath *indexPath){
        if([weakself checkLoginWithNav:weakself.navigationController]){
            ShowVCWeak(NDPersonalReferVC);
        }
    };
    
    self.cellSetting.callback = ^(FormCell *cell, NSIndexPath *indexPath){
        if([weakself checkLoginWithNav:weakself.navigationController]){
            ShowVCWeak(NDSettingTableViewController);
        }
    };
    
}

- (IBAction)btnLoginClick:(id)sender {
    ShowVC(NDLoginVC);
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
