//
//  NDPersonalOrderVC.m
//  newdoc
//
//  Created by zzc on 15/11/2.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDPersonalOrderVC.h"
#import "NDPersonalOrderCell.h"
#import "NDRoomOrderVC.h"
#import "NDPersonalOrderCommentVC.h"

@interface NDPersonalOrderVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *orders;
@property (nonatomic, assign) int tempNumber;
@end

@implementation NDPersonalOrderVC

- (NSArray *)orders{
    if(_orders == nil){
        _orders = [NSArray array];
    }
    return _orders;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的预约";
    
    WEAK_SELF;
    
    [self startGetOrdersWithAndSuccess:^(NSArray *orders) {
        weakself.orders = orders;
        
        weakself.orders = [weakself.orders sortedArrayUsingComparator:^NSComparisonResult(NDOrder *obj1, NDOrder *obj2) {
            if([obj1.ID intValue] < [obj2.ID intValue]){
                return NSOrderedDescending;
            }
            return NSOrderedAscending;
        }];
        
        [weakself.tableView reloadData];
    } failure:^(NSString *error_message) {
        
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WEAK_SELF;
    
    static NSString *cellId = @"NDPersonalOrderCell";
    
    NDPersonalOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    NDOrder *order = self.orders[indexPath.row];
    
    if(cell == nil){
        cell = [NDPersonalOrderCell new];
    }
    
    if(indexPath.row == 0){
        cell.ivNew.image = [UIImage imageNamed:@"icon_order_new"];
    }
    
    cell.order = order;
    cell.btnComment.callback = ^(Button *btn){
        
        
        CreateVC(NDPersonalOrderCommentVC);
        vc.orderId = order.ID;
        PushVCWeak(vc);
        
    };
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 138;
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
