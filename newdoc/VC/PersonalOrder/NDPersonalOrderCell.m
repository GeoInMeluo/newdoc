//
//  NDPersonalOrderCell.m
//  newdoc
//
//  Created by zzc on 15/11/2.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDPersonalOrderCell.h"

@implementation NDPersonalOrderCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self = [[NSBundle mainBundle] loadNibNamed:@"NDPersonalOrderCell" owner:nil options: nil][0];
    }
    return self;
}

- (void)setOrder:(NDOrder *)order{
    _order = order;
    
    _lblIndex.text = order.ID;
    _lblLocation.text = order.room_address;
    _lblDoc.text = [NSString stringWithFormat:@"医生：%@",order.doctor_name];
    _lblOrderTime.text = [NSString stringWithFormat:@"预约时间：%@ %@-%@",order.actual_date, order.start_time, order.end_time];
    _lblSubRoom.text = [NSString stringWithFormat:@"科室：%@",order.catalog_name];
    _lblRoomName.text = [NSString stringWithFormat:@"医院：%@",order.room_name];
    
    if([order.status isEqualToString:@"1"]){
        self.btnComment.hidden = NO;
    }else{
        self.btnComment.hidden = YES;
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
