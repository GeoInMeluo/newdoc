//
//  NMBaseVC.h
//  NewMedical
//
//  Created by zzc on 15/10/3.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NDBaseVC : UIViewController<UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray *showKeyboardViews;

@property (nonatomic, assign) BOOL isPresent;

- (UIButton *)rightView;

- (void)pop;
@end
