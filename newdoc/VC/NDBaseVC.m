//
//  NCBaseVC.m
//  newdoc
//
//  Created by zzc on 15/10/3.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDBaseVC.h"
#import "NDBaseNavVC.h"

@interface NDBaseVC ()
@property (nonatomic, weak) UIButton *doneButton;
@end

@implementation NDBaseVC

- (NSMutableArray *)showKeyboardViews{
    if(_showKeyboardViews == nil){
        _showKeyboardViews = [NSMutableArray array];
    }
    
    return _showKeyboardViews;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1){
        return NO;
    }
　　 else{
        return YES;
    }
}

- (void)setup{
    self . navigationController .interactivePopGestureRecognizer.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (doneButtonshow:) name: UIKeyboardDidShowNotification object:nil];
    
    // 设置CGRectZero从导航栏下开始计算
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    if([self rightView]){
        self.navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self rightView]];
    }
    
    self.view.height -= 44;
    
    UIButton *leftNavBtn = [[UIButton alloc] init];
    [leftNavBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftNavBtn setImage:[UIImage imageNamed:@"back"]
                forState:UIControlStateHighlighted];
    [leftNavBtn setTitle:@"返回" forState:UIControlStateNormal];
    [leftNavBtn setTitle:@"返回" forState:UIControlStateHighlighted];
    [leftNavBtn sizeToFit];
    [leftNavBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavBtn];
}

- (void)pop{
    
    if(self.isPresent){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UIButton *)rightView{
    return nil;
}

-(void) doneButtonshow: (NSNotification *)notification {
    if(self.doneButton){
        return;
    }
    
    UIButton *doneButton = [UIButton buttonWithType: UIButtonTypeCustom];
    _doneButton = doneButton;
    _doneButton.frame = [UIScreen mainScreen].bounds;
    //    [_doneButton setTitle:@"完成编辑" forState: UIControlStateNormal];
    [_doneButton addTarget: self action:@selector(hideKeyboard) forControlEvents: UIControlEventTouchUpInside];
    
    [self.view addSubview:_doneButton];
}

-(void) hideKeyboard {
    [_doneButton removeFromSuperview];
    
    for(UIView *view in self.showKeyboardViews){
        [view resignFirstResponder];
    }
    
}

@end
