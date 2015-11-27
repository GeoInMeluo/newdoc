//
//  NDDocSelfDetailViewController.m
//  newdoc
//
//  Created by zzc on 15/11/26.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDDocSelfDetailViewController.h"
#import "NDQACommonVC.h"

@interface NDDocSelfDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblZhengzhuang;
@property (weak, nonatomic) IBOutlet UILabel *lblYuanze;
@property (weak, nonatomic) IBOutlet UIView *vLike;
@property (nonatomic, strong) NSArray *commonQAs;

@end

@implementation NDDocSelfDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self setupUI];
}

- (void)setupUI{
    WEAK_SELF;
    
    self.title = self.sick.name;
    
    _lblYuanze.text = self.sick.pathology;
    _lblZhengzhuang.text = self.sick.detail;
    
    
    
    for(int i = 0; i< self.sick.like.count ; i++){
        
        CGFloat btnW = self.vLike.width / 5;
        
        CGFloat margin = 5;
        
        Button *btn = [[Button alloc] initWithFrame:CGRectMake(i * margin + i * btnW + margin, 0, btnW, 23.5)];
        [btn setTitle:self.sick.like[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = LightGray.CGColor;
        btn.layer.borderWidth = 1;
        btn.callback = ^(Button *btn){
            [weakself startQueryWithQuestion:btn.titleLabel.text];
        };
        [self.vLike addSubview:btn];
    }
    
    
    [self startGetCommonQAListAndSuccess:^(NSArray *qAs) {
        weakself.commonQAs = qAs;
        
        [weakself.tableView reloadData];
    } failure:^(NSString *error_message) {
        
    }];
}

- (void)startQueryWithQuestion:(NSString *)question{
    WEAK_SELF;
    
    [self startGetQueryCommonQAListWithQuestion:question success:^(NSArray *qAs) {
        
        CreateVC(NDQACommonVC);
        
        if(qAs == nil || qAs.count == 0){
            [MBProgressHUD showSuccess:@"没有搜索到相关资料"];
            
            return ;
        }
        
        vc.commonQA = qAs[0];
        PushVCWeak(vc);
        
    } failure:^(NSString *error_message) {
        [MBProgressHUD showSuccess:@"没有搜索到相关资料"];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"cellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    NDCommonQA *qa = self.commonQAs[indexPath.row];
    cell.textLabel.text = qa.question;
    
    cell.textLabel.font = [UIFont systemFontOfSize:11];
    
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commonQAs.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CreateVC(NDQACommonVC);
    vc.commonQA = self.commonQAs[indexPath.row];
    PushVC(vc);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25;
}
@end
