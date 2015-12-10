 //
//  NDPersonalReferVC.m
//  newdoc
//
//  Created by zzc on 15/10/21.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDPersonalReferVC.h"
#import "NDPersonalReferCell.h"
#import "NDPersonalReferFooter.h"
#import "NDPersonalReferFooterCell.h"
#import "NDPersonalReferDetail.h"
#import "NDChatVC.h"

@interface NDPersonalReferVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *sectionsID;
@property (nonatomic, assign) NSInteger lastSelectedIndex;

@property (nonatomic, strong) NSArray *qaMesaages;

@property (nonatomic, strong) NSMutableArray *currentTalks;

@property (nonatomic, strong) NSMutableArray *dateQAMessages;

@property (nonatomic, weak) UITableView *currentSubTable;

@property (nonatomic, assign) int page;
@end

@implementation NDPersonalReferVC

- (NSMutableArray *)sectionsID{
    if(_sectionsID == nil){
        _sectionsID = [NSMutableArray array];
    }
    return _sectionsID;
}

- (NSMutableArray *)currentTalks{
    if(_currentTalks == nil){
        _currentTalks = [NSMutableArray array];
    }
    return _currentTalks;
}

- (NSMutableArray *)dateQAMessages{
    if(_dateQAMessages == nil){
        _dateQAMessages = [NSMutableArray array];
    }
    return _dateQAMessages;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的咨询";
    
    [self setup];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setup{
    
    
    [self addHeader];
    [self addFooter];
 
    [self startGet];
}

- (void)startGet{
    WEAK_SELF;
    
    [self startGetQAListAndPage:self.page success:^(NSArray *qaMessages) {
        
        if(self.page){
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:weakself.qaMesaages];
            [tempArr addObjectsFromArray:qaMessages];
            weakself.qaMesaages = tempArr;
        }else{
            weakself.qaMesaages = qaMessages;
        }
        
//        weakself.qaMesaages = qaMessages;
        
        @autoreleasepool {
            
            if(!qaMessages){
                return ;
            }
            
            for(int i = 0; i < qaMessages.count ; i++){
                NDQAMessage *iQA = qaMessages[i];
                
                for(int j = 0; j < i  ; j++){
                    
                    NDQAMessage *jQA = qaMessages[j];
                    
                    NSArray *tempI = [iQA.start_date componentsSeparatedByString:@" "];
                    
                    NSArray *tempJ = [jQA.start_date componentsSeparatedByString:@" "];
                    
                    if([tempI[0] isEqualToString:tempJ[0]]){
                        [self.dateQAMessages removeObject:tempJ[0]];
                    }
                }
                
                [self.dateQAMessages addObject:[iQA.start_date componentsSeparatedByString:@" "][0]];
            }
            
            for(int i = 0; i < self.dateQAMessages.count; i++){
                [weakself.sectionsID addObject:@"0"];
            }
            
        }
        
        FLog(@"%@", self.dateQAMessages);
        
        [weakself.tableView reloadData];
    } failure:^(NSString *error_message) {
        
    }];

}

- (void)onRefreshHeader{
    self.page = 0;
    
    [self startGet];
}

- (void)onRefreshFooter{
    self.page++;
    
    [self startGet];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([tableView isKindOfClass:[NDPersonalReferFooter class]]){
        return 1;
    }
    
    return self.dateQAMessages.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([tableView isKindOfClass:[NDPersonalReferFooter class]]){
        
        return self.currentTalks.count;
        
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([tableView isKindOfClass:[NDPersonalReferFooter class]]){
        static NSString *cellId = @"NDPersonalReferFooterCell";
        
        NDPersonalReferFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if(cell == nil){
            cell = [NDPersonalReferFooterCell new];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NDQAMessage *qaMessage = self.currentTalks[indexPath.row];
        
        cell.lblTime.text = [qaMessage.start_date componentsSeparatedByString:@" "][1];
        
        return cell;
    }else{
        static NSString *cellId = @"NDPersonalReferCell";
        
        NDPersonalReferCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if(cell == nil){
            cell = [NDPersonalReferCell new];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.lblDate.text = self.dateQAMessages[indexPath.section];
        
//        if([self.sectionsID[indexPath.section] isEqualToString: @"1"]){
            //        CABasicAnimation *anim = [[CABasicAnimation alloc] init];
            //        anim.keyPath = @"transform.rotation";
            //        anim.toValue = [NSNumber numberWithDouble:(M_PI * 0.5)];
            //        [cell.imgArrow.layer addAnimation:anim forKey:@"imgArrow"];
            
//        }
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([tableView isKindOfClass:[NDPersonalReferFooter class]]){
        return 50;
    }else{
       return 50;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([tableView isKindOfClass:[NDPersonalReferFooter class]]){
        CreateVC(NDChatVC);
        
        vc.qaMesaage = self.currentTalks[indexPath.row];
        
        PushVC(vc);
        
    }else{
        self.sectionsID = [NSMutableArray array];
        
        for(int i = 0; i < self.dateQAMessages.count ; i++){
            [self.sectionsID addObject:@"0"];
        }
        
        self.sectionsID[indexPath.section] = @"1";
        self.lastSelectedIndex = indexPath.section;
   
        self.currentTalks = [NSMutableArray array];
        for(int i = 0; i < self.qaMesaages.count; i++){
            NDQAMessage *qaMessage =self.qaMesaages[i];
            
            if([[qaMessage.start_date componentsSeparatedByString:@" "][0] isEqualToString:self.dateQAMessages[indexPath.section]]){
                [self.currentTalks addObject:qaMessage];
            }
        }
        
        self.currentSubTable = tableView;
        
        [tableView reloadData];
    }
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(![tableView isKindOfClass:[NDPersonalReferFooter class]]){
        if([self.sectionsID[section] isEqualToString:@"1"]){
            NDPersonalReferFooter *view = [NDPersonalReferFooter new];
            
            view.delegate = self;
            view.dataSource = self;
            self.currentSubTable = view;
            return view;
        }

    }
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(![tableView isKindOfClass:[NDPersonalReferFooter class]]){
        if(self.sectionsID.count == 0){
            return 0;
        }
        
        if([self.sectionsID[section] isEqualToString:@"1"]){
            return 50 * self.currentTalks.count;
        }
    }
    return 0;
}

@end
