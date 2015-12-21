//
//  NDQAOnlineVC.m
//  newdoc
//
//  Created by zzc on 15/10/23.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDQAOnlineVC.h"
#import "NDQAMessageCenter.h"
#import "NDChatVC.h"
#import "NDQACommonCell.h"
#import "NDQACommonVC.h"

@interface NDQAOnlineVC ()

@property (strong, nonatomic) IBOutlet UIView *vPickClass;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerSubroom;

@property (nonatomic, strong) NSArray *subrooms;

@property (nonatomic, copy) NSString *currentSubroomIndex;

@property (nonatomic, strong) NSArray *commonQAs;

@property (weak, nonatomic) IBOutlet UIButton *btnPost;

@end

@implementation NDQAOnlineVC

- (NSMutableArray *)imgs{
    if(_imgs == nil){
        _imgs = [NSMutableArray array];
    }
    return _imgs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI{
    self.title = @"在线咨询";
    
    [self.showKeyboardViews addObjectsFromArray:@[self.tfAge,self.tvQuestion]];
    
    WEAK_SELF;
    
    [self startGetCommonQAListAndSuccess:^(NSArray *qAs) {
        weakself.commonQAs = qAs;
        
        [weakself.tableView reloadData];
    } failure:^(NSString *error_message) {
        
    }];
    
    [self startAllSubroomAndSuccess:^(NSArray *subrooms) {
        weakself.subrooms = subrooms;
        
        if(subrooms.count == 0){
            return;
        }
        
        [weakself.pickerSubroom reloadComponent:0];
    } failure:^(NSString *error_message) {
        
    }];
    
    [_collectionView registerClass:[NDPhotoGridCell class] forCellWithReuseIdentifier:@"NDPhotoGridCell"];
    [self.imgs addObject:[UIImage imageNamed:@"icon_img_plus"]];
    
    UUPhotoActionSheet *photoActionSheet = [[UUPhotoActionSheet alloc] initWithMaxSelected:5 weakSuper:self];
    self.photoActionSheet = photoActionSheet;
    self.photoActionSheet.delegate = self;
    [self.navigationController.view addSubview:self.photoActionSheet];
    
    self.pickerSubroom.delegate = self;
    self.pickerSubroom.dataSource = self;
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"icon_qa_message"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.btnPost.layer.cornerRadius = 5;
    self.btnPost.layer.masksToBounds = YES;
    
    self.btnSubmit.layer.cornerRadius = 5;
    self.btnSubmit.layer.masksToBounds = YES;
    
    self.btnSubroom.layer.cornerRadius = 5;
    self.btnSubroom.layer.masksToBounds = YES;
}

- (void)rightBtnClicked:(UIButton *)btn{
    ShowVC(NDQAMessageCenter);
//    ShowVC(NDChatVC);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    WEAK_SELF;
    
    [self.vPickClass removeFromSuperview];
    
    self.vPickClass.left = self.view.left;
    self.vPickClass.top = self.view.top;
    self.vPickClass.width = self.view.width;
    self.vPickClass.bottom = self.view.bottom;
    self.vPickClass.hidden = YES;
    [self.view addSubview:self.vPickClass];
}

- (IBAction)btnSubmitClicked:(id)sender {
    
    if(self.tfAge.text.length == 0){
        ShowAlert(@"年龄不能为空");
        return;
    }
    
    if(self.tvQuestion.text.length == 0){
        ShowAlert(@"问题描述不能为空");
        return;
    }
    
    if([self.btnSubroom.titleLabel.text isEqualToString:@"点击选择科室"]){
        ShowAlert(@"请选择科室");
        return;
    }
    
    WEAK_SELF;
    
    NSMutableArray *tempArr = self.imgs;
    if(self.imgs.count >0){
        [tempArr removeLastObject];
    }
    
    [self startUploadImageWithImages:self.imgs success:^(NSArray *imgUrls) {
        [weakself startSubmitQAWithContent:weakself.tvQuestion.text andSubroomId:weakself.currentSubroomIndex andSex:[NSString stringWithFormat:@"%zd", weakself.segGender.selectedSegmentIndex] andAge:weakself.tfAge.text andImgs:imgUrls success:^() {
            [MBProgressHUD showSuccess:@"问题提交成功~"];
            [weakself.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString *error_message) {
            
        }];
    } failure:^(NSString *error_message) {
        
    }];
    
//    [MBProgressHUD showSuccess:@"问题提交成功！"];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSubroomClicked:(id)sender {
    self.vPickClass.hidden = NO;
}

- (IBAction)btnConfirmPickSubroom:(id)sender {
    self.vPickClass.hidden = YES;
    self.currentSubroomIndex = [NSString stringWithFormat:@"%zd",[self.pickerSubroom selectedRowInComponent:0]];
    [self.btnSubroom setTitle:self.subrooms[[self.pickerSubroom selectedRowInComponent:0]] forState:UIControlStateNormal];
}

#pragma pickerViewDatasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.subrooms.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.subrooms[row];
}


#pragma tableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"NDQACommonCell";
    
    NDQACommonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil){
        cell = [NDQACommonCell new];
    }
    
    NDCommonQA *qa = self.commonQAs[indexPath.row];
    
    cell.lblQuestion.text = qa.question;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commonQAs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 32;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CreateVC(NDQACommonVC);
    vc.commonQA = self.commonQAs[indexPath.row];
    PushVC(vc);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
