//
//  NDBaseTableVC.h
//  newdoc
//
//  Created by zzc on 15/10/13.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormCell.h"
#import "FormSection.h"

@interface NDBaseTableVC : UITableViewController
@property (nonatomic, strong) UIView *tempSectionHeader;

@property(nonatomic,retain) IBOutlet UIView * defaultHeader;
@property(nonatomic,retain) IBOutlet UIView * defaultFooter;

//@property (nonatomic, strong)  NSMutableArray *cells;
@property (nonatomic, strong)  NSMutableArray *sections;

-(FormSection*)appendSection:(NSArray*)cells withHeader:(UIView*)headerView;
-(FormSection*)appendSection:(NSArray*)cells withHeader:(UIView*)headerView andFooter:(UIView*)footerView;

- (void)pop;
@end
