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
#import "NDHomeActive.h"


@interface NDRoomVC ()
@property (strong, nonatomic) IBOutlet UITableViewCell *tempCell1;
@property (strong, nonatomic) IBOutlet UITableViewCell *tempCell2;
@property (weak, nonatomic) IBOutlet Button *btnNewActiveIv;
@property (weak, nonatomic) IBOutlet UILabel *lblNewTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblNewLocation;

@property (nonatomic, strong) NSArray *actives;
@end

@implementation NDRoomVC

- (NSArray *)actives{
    if(_actives == nil){
        _actives = [NSArray array];
    }
    return _actives;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupUI{
    self.title = @"新医诊室";
    
    [self startGet];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupUI];
}

- (void)startGet{
    WEAK_SELF;
    
    [self startGetAppHomeInfoWithDate:[NSDate date] success:^(NSArray *actives) {
        weakself.actives = actives;
        
        NDHomeActive *newActive = self.actives.lastObject;
        
        weakself.lblNewLocation.text = newActive.abstract;
        weakself.lblNewTitle.text = newActive.abstract;
        [weakself.btnNewActiveIv sd_setBackgroundImageWithURL:[NSURL URLWithString:newActive.img] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_placeHolder"]];
        
        NDRoomTempDetailVC *vc = [NDRoomTempDetailVC new];
        vc.urlStr = newActive.url;
        
        weakself.btnNewActiveIv.callback = ^(Button *btn){
            [weakself.navigationController pushViewController:vc animated:YES];
        };
        
        [weakself.tableView reloadData];
    } failure:^(NSString *error_message) {
        weakself.actives = [NSArray array];
        
        [weakself.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.actives.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"NDRoomTempCellTableViewCell";
    
    NDRoomTempCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil){
        cell = [NDRoomTempCellTableViewCell new];
    }
    
    NDHomeActive *active = self.actives[indexPath.row];
   
    [cell.iv sd_setImageWithURL:[NSURL URLWithString:active.img] placeholderImage:[UIImage imageNamed:@"icon_placeHolder"]];
    cell.lblIntro.text = active.abstract;
    cell.lblTitle.text = active.abstract;
    
    return cell;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 94;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    todo();
    
    NDHomeActive *active = self.actives[indexPath.row];
    
    NDRoomTempDetailVC *vc = [NDRoomTempDetailVC new];
//    vc.urlStr = @"http://www.xinyijk.com/meducation.html";
    vc.urlStr = active.url;
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

//- (IBAction)btnBigClicked:(id)sender {
//    NDRoomTempDetailVC *vc = [NDRoomTempDetailVC new];
//    vc.urlStr = @"http://www.xinyijk.com/mpublicactivity.html";
//    PushVC(vc);
//}

@end
