//
//  NDRoomDetailDocCell.m
//  newdoc
//
//  Created by zzc on 15/10/17.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDRoomDetailDocCell.h"
#import "NDPreserveWindow.h"
#import "NDSlot.h"

@implementation NDRoomDetailDocCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self = [[NSBundle mainBundle] loadNibNamed:@"NDRoomDetailDocCell" owner:nil options: nil][0];
    }
    return self;
}

- (void)setDoctor:(NDDoctor *)doctor{
    _doctor = doctor;
    
    [self.btnHeadImg sd_setImageWithURL:[NSURL URLWithString:doctor.picture_url] forState:UIControlStateNormal];
    self.btnAttention.selected = doctor.isFocus;
//    self.btnGo2Order
    self.lblDocName.text = SafeString(doctor.name);
    self.lblDocDetail.text = SafeString([NSString stringWithFormat:@"(%@)",doctor.title]);
    self.lblGoodat.text = SafeString([NSString stringWithFormat:@"擅长：%@",doctor.goodat]);
    

    
    NDSlot *slot = [doctor.slots lastObject];
    
    NSDate *nearlyDate = timestamp2Datetime([slot.ts integerValue] * 1000);
    
    FLog(@"%@ \n", slot.ts);
    FLog(@"%@", nearlyDate);
    
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    self.lblCanOrder.text = SafeString([NSString stringWithFormat:@"最近可预约时间：%@",[dateFormat stringFromDate:nearlyDate]]);
    
//    NSMutableString *subrooms = [NSMutableString string];
//    for(NDSubroom *subroom in doctor.catalog){
//        [NSString stringWithFormat:@"%@、",subroom.name];
//    }
    
    NDSubroom *subroom = doctor.catalog[0];
    
    self.lblSubroom.text = SafeString([NSString stringWithFormat:@"科室：%@",subroom.name]);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
