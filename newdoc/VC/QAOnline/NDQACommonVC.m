//
//  NDQACommonVC.m
//  newdoc
//
//  Created by zzc on 15/11/19.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import "NDQACommonVC.h"

@interface NDQACommonVC ()
@property (weak, nonatomic) IBOutlet UILabel *lblQuestion;

@end

@implementation NDQACommonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI{
    self.title = @"常见问题";
    
    _lblQuestion.text = self.commonQA.answer;
    
}

@end
