//
//  NCBaseNavVC.m
//  newdoc
//
//  Created by zzc on 15/10/9.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDBaseNavVC.h"

@interface NDBaseNavVC ()

@end

@implementation NDBaseNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup{

}

+ (void)initialize
{
    [self setupNavigationBarTheme];
    
    [self setupBarButtonItemTheme];
}

/**
 *  设置UINavigationBarTheme的主题
 */
+ (void)setupNavigationBarTheme
{
    
    UINavigationBar *appearance = [UINavigationBar appearance];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[UITextAttributeTextColor] = [UIColor blackColor];

    textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];

    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    textAttrs[UITextAttributeTextColor] = [UIColor whiteColor];
    [appearance setTitleTextAttributes:textAttrs];
    
}

/**
 *  设置UIBarButtonItem的主题
 */
+ (void)setupBarButtonItemTheme
{
//    UIBarButtonItem *appearance = [UIBarButtonItem appearance];

//    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
//    textAttrs[UITextAttributeTextColor] = [UIColor orangeColor];
//    textAttrs[UITextAttributeFont] = [UIFont systemFontOfSize:15];
//    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
//    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//    
//    NSMutableDictionary *highTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
//    highTextAttrs[UITextAttributeTextColor] = [UIColor redColor];
//    [appearance setTitleTextAttributes:highTextAttrs forState:UIControlStateHighlighted];
    
//    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
//    disableTextAttrs[UITextAttributeTextColor] = [UIColor lightGrayColor];
//    [appearance setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
}

/**
 *  能拦截所有push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count > 0) {

        if(!self.leftBtn){
            UIButton *button = [[UIButton alloc] init];
            self.leftBtn = button;
            [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"back"]
                forState:UIControlStateHighlighted];
            [button setTitle:@"返回" forState:UIControlStateNormal];
            [button setTitle:@"返回" forState:UIControlStateHighlighted];
            [button sizeToFit];
            [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        }
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn]
        ;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
#warning 这里用的是self, 因为self就是当前正在使用的导航控制器

    [self popViewControllerAnimated:YES];
}

- (void)more
{
    [self popToRootViewControllerAnimated:YES];
}

- (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    
    button.size = button.currentBackgroundImage.size;
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}


@end
