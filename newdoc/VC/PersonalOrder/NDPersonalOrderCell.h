//
//  NDPersonalOrderCell.h
//  newdoc
//
//  Created by zzc on 15/11/2.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NDPersonalOrderCell : UITableViewCell
@property (nonatomic, strong) NDOrder *order;

@property (weak, nonatomic) IBOutlet UILabel *lblIndex;
@property (weak, nonatomic) IBOutlet UILabel *lblRoomName;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblSubRoom;
@property (weak, nonatomic) IBOutlet UILabel *lblDoc;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderTime;
@property (weak, nonatomic) IBOutlet UIImageView *ivNew;
@property (weak, nonatomic) IBOutlet Button *btnComment;

@end
