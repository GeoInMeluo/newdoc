//
//  NDQAMessageCenter.m
//  newdoc
//
//  Created by zzc on 15/11/13.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDQAMessageCenter.h"
#import "NDQAMessageCenterCell.h"
#import "NDChatVC.h"

@interface NDQAMessageCenter ()
@property (nonatomic, strong) NSArray *qaMessages;
@end

@implementation NDQAMessageCenter

- (NSArray *)qaMessages{
    if(_qaMessages == nil){
        _qaMessages = [NSArray array];
    }
    return _qaMessages;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息中心";

    [self setupUI];
}

- (void)setupUI{
    WEAK_SELF;
    
    [self startGetQAListAndPage:0 success:^(NSArray *qaMessages) {
        weakself.qaMessages = qaMessages;
        
        [weakself.tableView reloadData];
    } failure:^(NSString *error_message) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.qaMessages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"NDQAMessageCenterCell";
    
    NDQAMessageCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil){
        cell = [NDQAMessageCenterCell new];
    }
    
    cell.message = self.qaMessages[indexPath.row];

    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NDQAMessage *qaMessage = self.qaMessages[indexPath.row];
    
    CreateVC(NDChatVC);
    vc.qaMesaage = qaMessage;
    PushVC(vc);
}

@end
