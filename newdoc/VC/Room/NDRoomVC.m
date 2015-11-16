//
//  NDRoomVC.m
//  newdoc
//
//  Created by zzc on 15/10/11.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDRoomVC.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "NDRoomCell.h"
#import "NDRoomMapVC.h"
#import "NDQAOnlineVC.h"
#import "NDRoomTempCellTableViewCell.h"

@interface NDRoomVC ()
@property (strong, nonatomic) IBOutlet UITableViewCell *tempCell1;
@property (strong, nonatomic) IBOutlet UITableViewCell *tempCell2;

@end

@implementation NDRoomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI{
    self.title = @"新医诊室";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    static NSString *cellId = @"NDRoomCell";
//    
//    NDRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//
//    if(cell == nil){
//        cell = [[NDRoomCell alloc] init];
//    }
//    
//    return cell;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"NDRoomTempCellTableViewCell";
    
    NDRoomTempCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil){
        cell = [NDRoomTempCellTableViewCell new];
    }
    
    if(indexPath.row == 0){
        cell.image.image = [UIImage imageNamed:@"temp_home_1"];
    }else{
         cell.image.image = [UIImage imageNamed:@"temp_home_2"];
    }
    
    return cell;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 295;
    
    if(indexPath.row == 0){
        return 200;
    }else{
        return 100;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    todo();
//    ShowVC(NDRoomMapVC);
}

- (IBAction)btnHeader1Click:(id)sender {
//    todo();
}

- (IBAction)btnHeader2Click:(id)sender {
    ShowVC(NDQAOnlineVC);
}

- (IBAction)btnHeader3Click:(id)sender {
    ShowVC(NDRoomMapVC);
}


- (void)share{
    //创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"##+x@2x.png"]];
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                       
                   }];
    }

}

@end
