//
//  NDRoomDetailVC.m
//  newdoc
//
//  Created by zzc on 15/10/17.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDRoomDetailVC.h"
#import "NDRoomDetailDocCell.h"
#import "NDRoomOrderVC.h"

@interface NDRoomDetailVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *pickClass;
@property (weak, nonatomic) IBOutlet UIView *moreView;
@property (weak, nonatomic) IBOutlet UIPickerView *pkSubroom;
@property (nonatomic, copy) NSString *selectSubroom;
@property (nonatomic, strong) NSArray *docs;



@end

@implementation NDRoomDetailVC

- (NSArray *)docs{
    if(_docs == nil){
        _docs = [NSArray array];
    }
    return _docs;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"真是详情";
    
    [self startGet];
}

- (void)startGet{
    WEAK_SELF;
    
    [self startGetRoomWithRoomId:self.roomId success:^(NDRoom *room) {
        weakself.room = room;
        
        [weakself setupUI];
    } failure:^(NSString *error_message) {
        
    }];
}

- (void)startGetDocsListWithSelectSubroom{
    NSMutableArray *temp = [NSMutableArray array];
    
    for(NDDoctor *doctor in self.room.doctors){
        for(NDSubroom *subroom in doctor.catalog){
            if([subroom.name isEqualToString:self.selectSubroom]){
                [temp addObject:doctor];
            }
        }
    }
    
    self.docs = temp;
    [self.tableView reloadData];
}

- (void)setupUI{
    self.lblRoomName.text = self.room.name;
    self.lblRoomAddress.text = self.room.address;
    self.lblRoomGoodat.text = self.room.detail;
    
    self.docs = self.room.doctors;
    [self.tableView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.pickClass.left = self.moreView.left;
    self.pickClass.top = self.moreView.bottom;
    self.pickClass.width = self.moreView.width;
    self.pickClass.hidden = YES;
    
    [self.view addSubview:self.pickClass];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.docs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WEAK_SELF;
    
    static NSString *cellId = @"NDRoomDetailDocCell";
    
    NDRoomDetailDocCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil){
        cell = [NDRoomDetailDocCell new];
    }
    
    __block NDDoctor *doctor = self.docs[indexPath.row];
    cell.doctor = doctor;
    cell.btnAttention.callback = ^(Button *btn){
        if(btn.selected){
            [weakself startCancelAttentionDoctorWithDocId:doctor.ID success:^{
                btn.selected = !btn.selected;
            } failure:^(NSString *error_message) {
                
            }];
        }
        
        [weakself startAttentionDoctorWithDocId:doctor.ID success:^{
            btn.selected = !btn.selected;
        } failure:^(NSString *error_message) {
            
        }];
    };
    cell.btnGo2Order.callback = ^(Button *btn){
        NDRoomOrderVC *vc = [NDRoomOrderVC new];
        vc.doc = weakself.docs[indexPath.row];
        vc.roomId = weakself.room.ID;
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 139;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//}

//- (void)push2RoomOrder{
//    NDRoomOrderVC *vc = [NDRoomOrderVC new];
//    
//    PushVC(vc);
//}

- (IBAction)showMore:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    self.pickClass.hidden = !sender.selected;
}

- (IBAction)btnPickDoneClicked:(id)sender {
    self.pickClass.hidden = YES;
    
    NSInteger currentSelectRow = [self.pkSubroom selectedRowInComponent:0];
    
    NDSubroom *subroom = self.room.catalogs[currentSelectRow];
    
    self.selectSubroom = subroom.name;
    
    [self startGetDocsListWithSelectSubroom];
}

#pragma pickerViewDatasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.room.catalogs.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NDSubroom *subroom = self.room.catalogs[component];
    return subroom.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
