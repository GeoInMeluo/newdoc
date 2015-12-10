//
//  NCBaseNavVC.h
//  newdoc
//
//  Created by zzc on 15/10/9.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NDBaseNavVC : UINavigationController<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, strong) UIButton *rightBtn;

@end
