//
//  NDPersonalReferFooterCell.m
//  newdoc
//
//  Created by zzc on 15/10/22.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDPersonalReferFooterCell.h"

@implementation NDPersonalReferFooterCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self = [[NSBundle mainBundle] loadNibNamed:@"NDPersonalReferFooterCell" owner:nil options:nil][0];
    }
    return self;
}

- (void)setQaMessage:(NDQAMessage *)qaMessage{
    _qaMessage = qaMessage;
    
    _lblTime.text = qaMessage.start_date;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
