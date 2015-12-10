//
//  NDRoomSelectVC.m
//  newdoc
//
//  Created by zzc on 15/10/16.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDRoomSelectVC.h"
#import "NDRoomSelectCell.h"
#import "NDRoomDetailVC.h"

@interface NDRoomSelectVC ()

@end

@implementation NDRoomSelectVC
- (NSArray *)rooms{
    if(_rooms == nil){
        _rooms = [NSArray array];
    }
    return _rooms;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rooms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF;
    
    
    static NSString *cellId = @"NDRoomSelectCell";
    
    __block NDRoomSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil){
        cell = [[NDRoomSelectCell alloc] init];
    }
    
    NDRoom *room = self.rooms[indexPath.row];
    cell.room = room;
    cell.btnGo2RoomDetail.callback = ^(Button *btn){
        NDRoomDetailVC *vc =[NDRoomDetailVC new];
//        vc.room = self.rooms[indexPath.row];
        NDRoom *room = self.rooms[indexPath.row];
        vc.roomId = room.ID;
        [weakself.parentVC.navigationController pushViewController:vc animated:YES];
    };
    cell.btnIsBond.callback = ^(Button *btn){
        if(btn.selected){
            [weakself startCancelBindRoomWithRoomId:room.ID success:^{
                cell.btnIsBond.selected = !cell.btnIsBond.selected;
            } failure:^(NSString *error_message) {
                
            }];
        }else{
            [weakself startBindRoomWithRoomId:room.ID success:^{
                cell.btnIsBond.selected = !cell.btnIsBond.selected;
            } failure:^(NSString *error_message) {
                
            }];
        }
    };
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 132;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    ShowVC(NDRoomDetailVC);
    
    
}

- (void)onRefreshHeader{
    self.headerCallBack();
}

- (void)onRefreshFooter{
    self.footerCallBack();
}
@end
