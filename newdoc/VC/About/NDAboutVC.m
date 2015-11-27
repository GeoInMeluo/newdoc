//
//  NDAboutVC.m
//  newdoc
//
//  Created by zzc on 15/11/27.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDAboutVC.h"
#import "NDAdvanceVC.h"
#import "NDUserProtalcalVC.h"
#import "NDShengmingVC.h"

@interface NDAboutVC ()
@property (strong, nonatomic) IBOutlet FormCell *cellAdvance;
@property (strong, nonatomic) IBOutlet FormCell *cellKefu;
@property (strong, nonatomic) IBOutlet FormCell *cellProtalcal;
@property (strong, nonatomic) IBOutlet FormCell *cellShengming;
@property (weak, nonatomic) IBOutlet UIButton *btnPhoneNum;
@property (weak, nonatomic) IBOutlet UIImageView *ivIcon;

@end

@implementation NDAboutVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

- (void)setupUI{
    WEAK_SELF;
    
    self.title = @"关于我们";
    
    self.ivIcon.layer.cornerRadius = self.ivIcon.height / 2;
    self.ivIcon.layer.masksToBounds = YES;
    
    [self appendSection:@[self.cellAdvance, self.cellKefu, self.cellProtalcal, self.cellShengming] withHeader:nil];

    self.cellAdvance.callback = ^(FormCell* sender,NSIndexPath * indexPath){
        ShowVCWeak(NDAdvanceVC);
    };
    
    self.cellProtalcal.callback = ^(FormCell* sender,NSIndexPath * indexPath){
        ShowVCWeak(NDUserProtalcalVC);
    };
    
    self.cellShengming.callback = ^(FormCell* sender,NSIndexPath * indexPath){
        ShowVCWeak(NDShengmingVC);
    };
}

- (IBAction)onPhoneNumClick:(id)sender {
    NSString *num = [[NSString alloc] initWithFormat:@"telprompt://400800000000"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
}


@end
