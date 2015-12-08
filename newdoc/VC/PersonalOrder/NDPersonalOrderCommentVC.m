//
//  NDPersonalOrderCommentVC.m
//  newdoc
//
//  Created by zzc on 15/11/30.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDPersonalOrderCommentVC.h"
#import "CWStarRateView.h"

@interface NDPersonalOrderCommentVC ()
@property (weak, nonatomic) IBOutlet UIView *vStar;

@property (nonatomic, weak) CWStarRateView *starRateView;
@property (weak, nonatomic) IBOutlet UITextView *tfContent;

@end

@implementation NDPersonalOrderCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setupUI];
}

- (void)setupUI{
    self.title = @"评价";
    
    CWStarRateView *starRateView = [[CWStarRateView alloc] initWithFrame:self.vStar.bounds numberOfStars:5];
    self.starRateView.scorePercent = 0;
    self.starRateView.scorePercent = 4;
    self.starRateView.hasAnimation = YES;
    self.starRateView = starRateView;
    [self.vStar addSubview:starRateView];

}

- (IBAction)btnCommentClicked:(id)sender {
    WEAK_SELF;
    
    FLog(@"%lf", self.starRateView.scorePercent );
    
    [self startCommentDocWithOrderId:self.orderId andRating:[NSString stringWithFormat:@"%lf",self.starRateView.scorePercent * 5] andContent:self.tfContent.text success:^{
        [MBProgressHUD showSuccess:@"评价成功"];
        
        [weakself.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSString *error_message) {
        
    }];
}

@end
