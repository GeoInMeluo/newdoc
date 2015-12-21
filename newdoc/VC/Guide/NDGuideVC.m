//
//  NDGuideVC.m
//  newdoc
//
//  Created by zzc on 15/12/14.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDGuideVC.h"
#import "NDBaseTabVC.h"

#define kGuideCount 3

@interface NDGuideVC ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *imgs;
@property (nonatomic, weak) UIButton *confirmBtn;
@end

@implementation NDGuideVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

- (void)setupUI{
    self.scrollView.contentSize = CGSizeMake(kScreenSize.width * kGuideCount, kScreenSize.height);
    self.scrollView.alwaysBounceHorizontal = YES;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    NSString *imageName = nil;
    for(int i = 0; i< kGuideCount; i++){
        switch ([UIDevice getCurrentDeviceType]) {
            case iphone4:
            case iphone4s:
                imageName = [NSString stringWithFormat:@"guide_4S_%d",i + 1];
                break;
                
            case iphone5:
            case iphone5c:
            case iphone5s:
                imageName = [NSString stringWithFormat:@"guide_5S_%d",i + 1];
                break;
            
            case iphone6s:
            case iphone6:
                imageName = [NSString stringWithFormat:@"guide_6_%d",i + 1];
                break;
                
            case iphone6splus:
            case iphone6plus:
                imageName = [NSString stringWithFormat:@"guide_6p_%d",i + 1];
                break;
                
            default:
                imageName = [NSString stringWithFormat:@"guide_6S_%d",i + 1];
                break;
        }
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setImage:[UIImage imageNamed:imageName]];
        imageView.size = kScreenSize;
        imageView.top = 0;
        imageView.left = kScreenSize.width * i;
        [self.scrollView addSubview:imageView];
    }
    
    CGFloat tempBtnBottomMargin = 100;
    
//    switch ([UIDevice getCurrentDeviceType]) {
//        case iphone4:
//        case iphone4s:
//            tempBtnBottomMargin = 20;
//            break;
//            
//        case iphone5:
//        case iphone5c:
//        case iphone5s:
//            tempBtnBottomMargin = 70;
//            break;
//            
//        case iphone6s:
//        case iphone6:
//            tempBtnBottomMargin = 97;
//            break;
//            
//        case iphone6splus:
//        case iphone6plus:
//            tempBtnBottomMargin = 144;
//            break;
//            
//        default:
//            tempBtnBottomMargin = 70;
//            break;
//    }
    
    
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenSize.height - tempBtnBottomMargin, 150, 40)];
    [confirmBtn setTitle:@"立即体验" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor colorWithHex:@"#00AAFF"] forState:UIControlStateNormal];
    confirmBtn.backgroundColor = [UIColor whiteColor];
    confirmBtn.layer.cornerRadius = confirmBtn.height / 2;
    confirmBtn.layer.masksToBounds = YES;
    confirmBtn.layer.borderColor = [UIColor colorWithHex:@"#00AAFF"].CGColor;
    confirmBtn.layer.borderWidth = 1;
    confirmBtn.centerX = kScreenSize.width * 0.5;
    self.confirmBtn = confirmBtn;
    confirmBtn.hidden = YES;
    [confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == self.scrollView.width * (kGuideCount - 1))
    {
        self.confirmBtn.hidden = NO;
    }else{
        self.confirmBtn.hidden = YES;
    }
}

- (void)confirmBtnClicked:(UIButton *)btn{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lf",kVersion] forKey:@"version"];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = [NDBaseTabVC new];
}

@end
