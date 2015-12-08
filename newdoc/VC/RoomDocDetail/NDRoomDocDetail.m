//
//  NDRoomDocDetail.m
//  newdoc
//
//  Created by zzc on 15/10/18.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDRoomDocDetail.h"
#import "NDRoomDocDetailCell.h"

@interface NDRoomDocDetail ()
@property (weak, nonatomic) IBOutlet UILabel *lblDocName;
@property (weak, nonatomic) IBOutlet UILabel *lblDocTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblGoodat;
@property (weak, nonatomic) IBOutlet UILabel *lblEducation;
@property (weak, nonatomic) IBOutlet UILabel *lblRoomName;
@property (weak, nonatomic) IBOutlet UILabel *lblSubroom;
@property (weak, nonatomic) IBOutlet UIButton *btnHeader;

@end

@implementation NDRoomDocDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];

}

- (void)setupUI{
    WEAK_SELF;
    
    self.title = @"医生简介";
    
    
    
    [self startGetDoctorIntroWithDocId:self.doctor.ID success:^(NDDoctorIntro *intro) {
        weakself.docIntro = intro;
        
        [weakself.btnHeader sd_setImageWithURL:[NSURL URLWithString:weakself.doctor.picture_url] forState:UIControlStateNormal];
        weakself.lblDocName.text = weakself.doctor.name;
        weakself.lblDocTitle.text = weakself.doctor.title;
        weakself.lblGoodat.text = [NSString stringWithFormat:@"擅长：%@", weakself.doctor.goodat];
        NDSubroom *subroom = weakself.doctor.catalog[0];
        weakself.lblSubroom.text = [NSString stringWithFormat:@"科室：%@",subroom.name];
        weakself.lblEducation.text = [NSString stringWithFormat:@"学历：%@",intro.graduate_college];
        
        [weakself.tableView reloadData];
    } failure:^(NSString *error_message) {
        
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"NDRoomDocDetailCell";
    
    NDRoomDocDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil){
        cell = [NDRoomDocDetailCell new];
    }
    
    if(indexPath.row == 0){
        cell.lblTitle.text = @"教育背景";
        cell.lblDetail.text = self.docIntro.graduate_college;
    }
    if (indexPath.row == 1){
        cell.lblTitle.text = @"从医经验";
        cell.lblDetail.text = self.docIntro.detail;
//                cell.lblDetail.text = @"sadfalksjdfljsadljfljasdlkjfljasdkjflkjsaljdflkjasldjflkajsdljfjasdjfjaslkjdfaslkdjfaslkdjfjalskjdfjalsjdfljalsjdflk";
    }
    if(indexPath.row == 2){
        cell.lblTitle.text = @"科研成果";
        cell.lblDetail.text = self.docIntro.research;
    }
    
    [cell layoutIfNeeded];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NDRoomDocDetailCell *cell = (NDRoomDocDetailCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];

    
    return cell.cellHeight;//    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

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
