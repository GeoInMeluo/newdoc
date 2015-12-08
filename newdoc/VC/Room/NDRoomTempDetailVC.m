//
//  NDRoomTempDetailVC.m
//  newdoc4d
//
//  Created by zzc on 15/12/4.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDRoomTempDetailVC.h"

@interface NDRoomTempDetailVC ()
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@end

@implementation NDRoomTempDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"详情";
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
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
