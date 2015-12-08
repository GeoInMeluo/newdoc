
//
//  NDRoomOrderVC.m
//  newdoc
//
//  Created by zzc on 15/10/17.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDRoomOrderVC.h"
#import "NDRoomOrderLabeCell.h"
#import "NDRoomDocDetail.h"
#import "NDRoomUserComment.h"
#import "NDSlot.h"
#import "NDPreserveWindow.h"

@interface NDRoomOrderVC ()<UICollectionViewDataSource, UIBarPositioningDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *roomCollectionView;
@property (weak, nonatomic) IBOutlet UIView *dateView;

@property (weak, nonatomic) IBOutlet UIView *vTimeScope;
@property (weak, nonatomic) IBOutlet UILabel *lblCountMoment;
@property (nonatomic, assign) NSInteger currentDate;
@property (nonatomic, strong) NDPreserveWindow *currentPreserveWindow;
@property (nonatomic, assign) NSInteger currentWindowIndex;
//@property (nonatomic, strong) NSMutableArray *selectedOrderDates;
@property (nonatomic, strong) NDSlot *selectedSlot;
@property (nonatomic, strong) NSMutableArray *currentDateScopeSlots;

@property (weak, nonatomic) IBOutlet UIButton *btnOrder;

#pragma 头部控件
@property (weak, nonatomic) IBOutlet UILabel *lblDocName;
@property (weak, nonatomic) IBOutlet UILabel *lblDocTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnAttention;
@property (weak, nonatomic) IBOutlet UILabel *lblSubroom;
@property (weak, nonatomic) IBOutlet UILabel *lblGoodat;
@property (weak, nonatomic) IBOutlet UIButton *btnDocIntro;
@property (weak, nonatomic) IBOutlet UILabel *btnUserComment;
@property (weak, nonatomic) IBOutlet UIButton *btnDocHeadImg;

@property (weak, nonatomic) IBOutlet UIView *vUserComment;

@property (nonatomic, strong) NSMutableArray *canOrderBtns;
@end

@implementation NDRoomOrderVC

- (NSMutableArray *)canOrderBtns{
    if(_canOrderBtns == nil){
        _canOrderBtns = [NSMutableArray array];
    }
    return _canOrderBtns;
}

//- (NSMutableArray *)selectedOrderDates{
//    if(_selectedOrderDates == nil){
//        _selectedOrderDates = [NSMutableArray array];
//    }
//    return _selectedOrderDates;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.canOrderBtns = [NSMutableArray array];
//    self.docMorePreserveWindow.ID = self.doc.ID;
    
}

- (void)setupUI{
    self.title = @"预约挂号";
    
    self.btnOrder.layer.masksToBounds = YES;
    self.btnOrder.layer.cornerRadius = 5;
    
    self.btnDocIntro.layer.masksToBounds = YES;
    self.btnDocIntro.layer.cornerRadius = 5;
    
    self.btnUserComment.layer.masksToBounds = YES;
    self.btnUserComment.layer.cornerRadius = 5;
    
    self.vUserComment.layer.masksToBounds = YES;
    self.vUserComment.layer.cornerRadius = 5;
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"back"]
            forState:UIControlStateHighlighted];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitle:@"返回" forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.currentPreserveWindow = self.docMorePreserveWindow.preserve_window[0];
    
    self.title = @"预约挂号";
    
    
    self.lblDocName.text = SafeString (self.docMorePreserveWindow.name);
    self.lblDocTitle.text = SafeString (self.docMorePreserveWindow.title);
    self.lblGoodat.text = SafeString ([NSString stringWithFormat:@"擅长：%@", self.docMorePreserveWindow.goodat]);
    NDSubroom *subroom = self.docMorePreserveWindow.catalog[0];
    self.lblSubroom.text = SafeString ([NSString stringWithFormat:@"科室：%@",subroom.name]);
    [self.btnDocHeadImg sd_setImageWithURL:[NSURL URLWithString:self.docMorePreserveWindow.picture_url] forState:UIControlStateNormal placeholderImage:[UIImage imageWithName:@"icon_placeHolder"]];
    
//    self.lblCountMoment.text = [NSString stringWithFormat:@"%@",self.doc];
    
    [self.roomCollectionView registerNib:[UINib nibWithNibName:@"NDRoomOrderLabeCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"NDRoomOrderLabeCell"];
    
    self.roomCollectionView.pagingEnabled = YES;
    
   
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeBtnStyle:(UIButton *)btn{
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageWithColor:Blue] forState:UIControlStateSelected];
    [btn setTitleColor:Blue forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:10];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds= YES;
    btn.layer.borderColor = Blue.CGColor;
    btn.layer.borderWidth = 1;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    self.selectedOrderDates = [NSMutableArray array];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.tableView.tableHeaderView.height = 528;
    
    WEAK_SELF;
    
    [self startGetDoctorDetailWithDocId:self.doc.ID andRoomId:self.roomId success:^(NDDoctorMorePreserveWindow *doctorMorePreserveWindow) {
        weakself.docMorePreserveWindow = doctorMorePreserveWindow;
        [weakself setupUI];
        [weakself.roomCollectionView reloadData];
        
        int temp = 0;
        for(NDPreserveWindow *preserveWindow in doctorMorePreserveWindow.preserve_window){
            if(preserveWindow.roomid == self.roomId){
                break;
            }
            temp ++ ;
        }
        
        if(temp == doctorMorePreserveWindow.preserve_window.count){
            temp = 0;
        }
        
        if(temp != 0){
            [weakself.roomCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:temp inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionRight];
        }
     
        
        
        weakself.currentPreserveWindow = doctorMorePreserveWindow.preserve_window[temp];
        weakself.currentWindowIndex = temp;
        
        [weakself initWithDatePicker];
        
        self.doc.isFocus = doctorMorePreserveWindow.isFocus;
        
        if(doctorMorePreserveWindow.isFocus){
            weakself.btnAttention.selected = YES;
        }else{
            weakself.btnAttention.selected = NO;
        }
    } failure:^(NSString *error_message) {
        
    }];
    
    
}

- (void)initWithDatePicker{
    [self.dateView clearSubviews];
    
    NSDate *currentDate = [NSDate date];
    
    //得到今天是周几
    NSUInteger weekNumber = [currentDate weeklyOrdinality];
//    NSUInteger weekNumber = 3;
    //得到今天是几号
    NSUInteger dateNumber = [currentDate day];
    
    //得到当前月份
    NSUInteger monthNumber = [currentDate month];
    
    int preMonthCountDay = [self howManyDaysInThisMonth:[currentDate year] month: monthNumber - 1];
    
    self.currentDate = dateNumber;
//    NSUInteger dateNumber = 21;
    //当前月份的总天数
    NSUInteger countMonthDay = [currentDate numberOfDaysInCurrentMonth];
    
    NSUInteger temp = 6 + weekNumber;
    
    NSArray *tempArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    
    int row = 4;
    int rowCount = 7;
    CGFloat itemW = 34;
    CGFloat itemH = 34;
    int marginW = (self.dateView.width - (itemW * rowCount)) / (rowCount + 1);
    int marginH = (self.dateView.height - (itemW * row)) / (row + 1);
    
    int tempNumber = 0;
    
    NSInteger tagNumber = 100;
    
    @autoreleasepool {
    
    for (int i = 0; i < row * rowCount; i++) {
        
        int itemRow = i / rowCount;
        int itemCol = i % rowCount;
        
        UIButton *btn = [[UIButton alloc] init];
        btn.enabled = NO;
        [self.dateView addSubview:btn];
        btn.frame = CGRectMake(                                                                                                      itemCol * (marginW + itemW) + marginW, itemRow * (marginH + itemH) + marginH , itemW, itemH);
//        btn.tag = i;
        
        if(i < 7){
            [btn setTitle:tempArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }else{
            
            btn.layer.cornerRadius = 5;
            btn.layer.masksToBounds = YES;
            btn.layer.borderWidth = 1;
            
            NSInteger btnTitleNumber = dateNumber - temp + i;
            
            if(btnTitleNumber <= 0){
                btnTitleNumber = preMonthCountDay - abs(btnTitleNumber);
            }
            
            if(btnTitleNumber > countMonthDay){
                btnTitleNumber = btnTitleNumber - countMonthDay;
            }
                
            //今天以后的有效日期
            if(i >= temp && btnTitleNumber <= dateNumber + 13){
//                btn.enabled = YES;
                btn.backgroundColor = [UIColor whiteColor];
                [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
//                [btn setBackgroundImage:[UIImage imageWithColor:[UIColor greenColor]] forState:UIControlStateSelected];
                
                if(btnTitleNumber == dateNumber){
                    btn.layer.borderColor = [UIColor orangeColor].CGColor;
                    
                    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                }else{
                    btn.layer.borderColor = [UIColor darkGrayColor].CGColor;
                    
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
                
                [btn setTitle:[NSString stringWithFormat:@"%zd", btnTitleNumber] forState:UIControlStateNormal];
                
            }else{
                
                btn.backgroundColor = [UIColor lightGrayColor];
                
                btn.layer.borderColor = [UIColor darkGrayColor].CGColor;
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                if(btnTitleNumber > countMonthDay){
                    [btn setTitle:[NSString stringWithFormat:@"%zd", ++tempNumber] forState:UIControlStateNormal];
                }else{
                    [btn setTitle:[NSString stringWithFormat:@"%zd", btnTitleNumber] forState:UIControlStateNormal];
                }
            
            }

            for(NDSlot *slot in self.currentPreserveWindow.slots){
                
                NSDate *orderDate = timestamp2Datetime([slot.ts integerValue ] * 1000);
                
//                [self.canOrderDates addObject:slot];
                
                NSInteger diffNumber = [NSDate dayDiffCountFrom:[NSDate date] to:orderDate];
                
                if(btnTitleNumber == (diffNumber + dateNumber) && btnTitleNumber <= dateNumber + 13 ){
                    [self.canOrderBtns addObject:btn];
                    
                    [btn addTarget:self action:@selector(btnDateGridClicked:) forControlEvents:UIControlEventTouchUpInside];
                    btn.enabled = YES;
                    btn.layer.borderWidth = 0;
//                    btn.backgroundColor = [UIColor redColor];
                    [btn setBackgroundImage:[UIImage imageNamed:@"btn_date_normal"] forState:UIControlStateNormal];
                    [btn setBackgroundImage:[UIImage imageNamed:@"btn_date_selected"] forState:UIControlStateSelected];
                    btn.tag = tagNumber;
                    tagNumber ++;
                }
            }
        }

    }
        
    }
}

#pragma 日期按钮点击事件
- (void)btnDateGridClicked:(UIButton *)btn{
    [self.vTimeScope clearSubviews];
    
    FLog(@"%@",btn);
    
//    self.selectedOrderDates = [NSMutableArray array];
    
    NDSlot *selectSlot = self.currentPreserveWindow.slots[btn.tag - 100];
    
    [self.vTimeScope clearSubviews];
    
    NSMutableArray *timeScopes = [NSMutableArray array];
    self.currentDateScopeSlots = timeScopes;
    for(NDSlot *slot in self.currentPreserveWindow.slots){
        FLog(@"%@", self.currentPreserveWindow.slots);
        
        if([slot.actual_date isEqualToString:selectSlot.actual_date]){
            
            FLog(@"%@",timeScopes);
            
            [timeScopes addObject:slot];
        }
    }
    
    for(int i = 0; i<timeScopes.count; i++){
        
        FLog(@"%@",timeScopes);
        
        NDSlot *slot = timeScopes[i];
        
        UIButton *timeScopeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [timeScopeBtn setTitle:slot.timescope forState:UIControlStateNormal];
        [self changeBtnStyle:timeScopeBtn];
        CGFloat btnW = 90;
        CGFloat btnH = self.vTimeScope.height;
        CGFloat margin = (self.vTimeScope.width - btnW * timeScopes.count) / (timeScopes.count + 1);
//        CGFloat margin = 150;
        timeScopeBtn.frame = CGRectMake( i * margin + i * btnW + margin, 0, btnW, btnH);
        FLog(@"%@", timeScopeBtn);
        timeScopeBtn.tag = 1000 + i;
        [timeScopeBtn addTarget:self action:@selector(scopeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.vTimeScope addSubview:timeScopeBtn];
    }
    
    for (UIButton *sub in self.canOrderBtns) {
        if(sub != btn){
            sub.selected = NO;
        }
    }
    
    btn.selected = !btn.selected;
    
    FLog(@"%@",selectSlot.ID);
    
    if(btn.selected){
        self.selectedSlot = selectSlot;
    }
////        btn.layer.borderColor = [UIColor whiteColor].CGColor;
//        [self.selectedOrderDates addObject:selectSlot];
//    }else{
//        [self.selectedOrderDates removeObject:selectSlot];
//    }
    
//    FLog(@"%@",self.selectedOrderDates);
}

- (void)scopeBtnClicked:(UIButton *)btn{
    for(UIView *v in self.vTimeScope.subviews){
        if([v isKindOfClass:[UIButton class]]){
            UIButton *btn = (UIButton *)v;
            btn.selected = NO;
        }
    }
    btn.selected = YES;
    
    self.selectedSlot = self.currentDateScopeSlots[btn.tag - 1000];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.docMorePreserveWindow.preserve_window.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF;
    
    __block NDRoomOrderLabeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NDRoomOrderLabeCell" forIndexPath:indexPath];
    
    NDPreserveWindow *preserveWindow = self.docMorePreserveWindow.preserve_window[indexPath.row];
    
    cell.preserveWindow = preserveWindow;
    cell.btnBond.callback = ^(Button *btn){
        if(btn.selected){
            [weakself startCancelBindRoomWithRoomId:weakself.roomId success:^{
                cell.btnBond.selected = !cell.btnBond.selected;
            } failure:^(NSString *error_message) {
                
            }];
        }else{
            [weakself startBindRoomWithRoomId:weakself.roomId success:^{
                cell.btnBond.selected = !cell.btnBond.selected;
            } failure:^(NSString *error_message) {
                
            }];
        }
    };
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.roomCollectionView.size;
}

- (IBAction)btnPreviousClick:(id)sender {
    
    self.currentWindowIndex--;
    
    if(self.currentWindowIndex < 0){
        self.currentWindowIndex = 0;
        return;
    }
    
    [self.roomCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentWindowIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    self.currentPreserveWindow = self.docMorePreserveWindow.preserve_window[self.currentWindowIndex];
    
    [self initWithDatePicker];
}

- (IBAction)btnNextClick:(id)sender {
    
    self.currentWindowIndex++;
    
    if(self.currentWindowIndex == self.docMorePreserveWindow.preserve_window.count){
        self.currentWindowIndex = self.docMorePreserveWindow.preserve_window.count - 1;
        return;
    }
    
    if(self.docMorePreserveWindow.preserve_window.count == 0){
        self.currentWindowIndex = 0;
        return;
    }
    
    
    [self.roomCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentWindowIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];

    self.currentPreserveWindow = self.docMorePreserveWindow.preserve_window[self.currentWindowIndex];
    
    [self initWithDatePicker];
}

- (IBAction)btnDocDetailClick:(id)sender {
    CreateVC(NDRoomDocDetail);
    vc.doctor = self.doc;
    PushVC(vc);
}

- (IBAction)btnUserCommentClick:(id)sender {
    CreateVC(NDRoomUserComment);
    vc.doc = self.doc;
    PushVC(vc);
}

- (IBAction)btnAttentionClick:(UIButton *)sender {
    WEAK_SELF;
    if(self.docMorePreserveWindow.isFocus){
        [self startCancelAttentionDoctorWithDocId:self.docMorePreserveWindow.ID success:^{
            weakself.docMorePreserveWindow.isFocus = NO;
            weakself.btnAttention.selected = NO;
            weakself.doc.isFocus = NO;
        } failure:^(NSString *error_message) {
            
        }];
    }else{
        [self startAttentionDoctorWithDocId:self.docMorePreserveWindow.ID success:^{
            weakself.docMorePreserveWindow.isFocus = YES;
            weakself.btnAttention.selected = YES;
            weakself.doc.isFocus = YES;
        } failure:^(NSString *error_message) {
            
        }];
    }
}

- (IBAction)btnOrderClicked:(id)sender {
    WEAK_SELF;
    
    if(!self.selectedSlot){
        return;
    }
    
    [self startOrderWithSlot:self.selectedSlot success:^{
        [MBProgressHUD showSuccess:@"预约成功，请进入个人中心我的预约进行查看"];
        
        [weakself.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSString *error_message) {

    }];
}


- (int)howManyDaysInThisMonth:(NSUInteger)year month:(NSUInteger)imonth {
    if((imonth == 1)||(imonth == 3)||(imonth == 5)||(imonth == 7)||(imonth == 8)||(imonth == 10)||(imonth == 12))
        return 31;
    if((imonth == 4)||(imonth == 6)||(imonth == 9)||(imonth == 11))
        return 30;
    if((year%4 == 1)||(year%4 == 2)||(year%4 == 3))
    {
        return 28;
    }
    if(year%400 == 0)
        return 29;
    if(year%100 == 0)
        return 28;
    return 29;
}
@end
