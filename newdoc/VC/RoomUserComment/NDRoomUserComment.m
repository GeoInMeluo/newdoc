//
//  NDRoomUserComment.m
//  newdoc
//
//  Created by zzc on 15/10/18.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDRoomUserComment.h"
#import "NDRoomUserCommentCell.h"
#import "CWStarRateView.h"

@interface NDRoomUserComment ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnUserCommet;
@property (weak, nonatomic) IBOutlet UIButton *btnMineComment;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIView *startRateDiv;

@property (nonatomic, weak) CWStarRateView *starRateView;

@property (weak, nonatomic) IBOutlet UILabel *lblHeaderDocName;
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderDocTitle;
@property (weak, nonatomic) IBOutlet UIButton *lblHeaderDocIcon;
@property (weak, nonatomic) IBOutlet UIButton *btnHeaderAttetion;
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderSubroom;
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderDocGoodat;
@property (weak, nonatomic) IBOutlet UITextView *tvComment;

@property (nonatomic, assign) int page;
@end

@implementation NDRoomUserComment

- (NSArray *)docComments{
    if(_docComments == nil){
        _docComments = [NSArray array];
    }
    return _docComments;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI{
    WEAK_SELF;
    
    self.title = @"用户评价";
    
    [self.showKeyboardViews addObjectsFromArray:@[self.tvComment]];
    
    self.lblHeaderDocName.text = self.doc.name;
    self.lblHeaderDocTitle.text = self.doc.title;
    self.lblHeaderDocGoodat.text = [NSString stringWithFormat:@"擅长：%@", self.doc.goodat];
    NDSubroom *subroom = self.doc.catalog[0];
    self.lblHeaderSubroom.text = [NSString stringWithFormat:@"科室：%@",subroom.name];
    self.btnHeaderAttetion.selected = self.doc.isFocus;
    
    [self.bottomView addSubview:self.tableView];
    self.tableView.hidden = YES;
    
    [self.bottomView addSubview:self.mineCommentView];
    self.mineCommentView.hidden = YES;
    
    CWStarRateView *starRateView = [[CWStarRateView alloc] initWithFrame:self.startRateDiv.bounds numberOfStars:5];
    self.starRateView.scorePercent = 0;
    self.starRateView.scorePercent = 4;
    self.starRateView.hasAnimation = YES;
    self.starRateView = starRateView;
    [self.startRateDiv addSubview:starRateView];
    
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself onRefreshHeader];
        [weakself.tableView.header endRefreshing];
    }];
    
    self.tableView.footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakself onRefreshFooter];
        [weakself.tableView.footer endRefreshing];
    }];
}

- (void)onRefreshHeader{
    self.page = 0;
    [self startGet];
}

- (void)onRefreshFooter{
    self.page ++;
    [self startGet];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.tableView.frame = self.bottomView.bounds;
    self.tableView.hidden = NO;
    
    self.mineCommentView.frame = self.bottomView.bounds;
    
    [self startGet];

}

- (void)startGet{
    WEAK_SELF;
    
    [self startGetDoctorCommentsWithDocId:self.doc.ID andPage:self.page success:^(NSArray *docComments) {
        
        if(self.page){
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:weakself.docComments];
            [tempArr addObjectsFromArray:docComments];
            weakself.docComments = tempArr;
        }else{
            weakself.docComments = docComments;
        }
        
        [weakself.tableView reloadData];
    } failure:^(NSString *error_message) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.docComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"NDRoomUserCommentCell";
    
    NDRoomUserCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil){
        cell = [NDRoomUserCommentCell new];
//        [cell layoutSubviews];
    }
    
    cell.docComment = self.docComments[indexPath.row];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (IBAction)btnMineCommentClick:(id)sender {
    self.mineCommentView.hidden = NO;
    self.tableView.hidden = YES;
}

- (IBAction)btnUserCommentClick:(id)sender {
    self.mineCommentView.hidden = YES;
    self.tableView.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnAttentionClick:(id)sender{
    WEAK_SELF;
    
    if(self.doc.isFocus){
        [self startCancelAttentionDoctorWithDocId:self.doc.ID success:^{
            weakself.doc.isFocus = NO;
            weakself.btnHeaderAttetion.selected = NO;
        } failure:^(NSString *error_message) {
            
        }];
    }else{
        [self startAttentionDoctorWithDocId:self.doc.ID success:^{
            weakself.doc.isFocus = YES;
            weakself.btnHeaderAttetion.selected = YES;
        } failure:^(NSString *error_message) {
            
        }];
    }
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
