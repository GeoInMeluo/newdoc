//
//  NDRoomVC.m
//  newdoc
//
//  Created by zzc on 15/10/11.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDRoomVC.h"
#import "NDRoomCell.h"
#import "NDRoomMapVC.h"
#import "NDQAOnlineVC.h"
#import "NDRoomTempCellTableViewCell.h"
#import "NDDocSelfVC.h"
#import "NDRoomTempDetailVC.h"


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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"NDRoomTempCellTableViewCell";
    
    NDRoomTempCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil){
        cell = [NDRoomTempCellTableViewCell new];
    }
   
    return cell;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 94;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    todo();
    NDRoomTempDetailVC *vc = [NDRoomTempDetailVC new];
    vc.urlStr = @"http://www.xinyijk.com/meducation.html";
    PushVC(vc);
}

- (IBAction)btnHeader1Click:(id)sender {
    ShowVC(NDDocSelfVC);
}

- (IBAction)btnHeader2Click:(id)sender {
    if([self checkLoginWithNav:self.navigationController]){
        ShowVC(NDQAOnlineVC);
    }
}

- (IBAction)btnHeader3Click:(id)sender {
    ShowVC(NDRoomMapVC);
}

- (IBAction)btnBigClicked:(id)sender {
    NDRoomTempDetailVC *vc = [NDRoomTempDetailVC new];
    vc.urlStr = @"http://www.xinyijk.com/mpublicactivity.html";
    PushVC(vc);
}

@end
