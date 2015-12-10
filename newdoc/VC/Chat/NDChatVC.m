//
//  NDViewController.m
//  03-QQ聊天布局
//
//  Created by apple on 14-10-22.
//  Copyright (c) 2014年 itheima. All rights reserved.
//

#import "NDChatVC.h"
#import "NDMessage.h"
#import "NDMessageCell.h"
#import "NDMessageFrame.h"

@interface NDChatVC () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *inputView;

@property (nonatomic, strong) NSArray *talkMessages;

/**
 *  带有frame的模型 容器
 */
@property (strong, nonatomic) NSMutableArray *messageFrames;

/**
 *  plist自动回复容器
 */
@property (nonatomic, strong) NSDictionary *relayDict;

@property (nonatomic, assign) int page;

@end

@implementation NDChatVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WEAK_SELF;
    
    self.view.height -= 44;
    
    // 去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 不允许选中
    self.tableView.allowsSelection = NO;
    
    // 设置整个tableView的背景色
    self.tableView.backgroundColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f];
    
    // 添加监听器，监听键盘的位置变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification  object:nil];
    
    // 处理输入框
    self.inputView.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    self.inputView.leftViewMode = UITextFieldViewModeAlways;
    
    self.inputView.delegate = self;
    
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself onRefreshHeader];
        [weakself.tableView.header endRefreshing];
    }];
    
    // 添加上拉刷新尾部控件
    self.tableView.footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakself onRefreshFooter];
        [weakself.tableView.footer endRefreshing];
    }];
    
    [self startGet];
}

- (void)onRefreshHeader{
    self.page = 0;
    
    [self startGet];
}

- (void)onRefreshFooter{
    self.page ++;
    
    [self startGet];
}

- (void)startGet{
    WEAK_SELF;
    
    [self startGetQAWithQAId:self.qaMesaage.ID andPage:self.page success:^(NSArray *talkMessages) {
        
        FLog(@"%@", talkMessages);
        
        if(self.page){
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:weakself.talkMessages];
            [tempArr addObjectsFromArray:talkMessages];
            weakself.talkMessages = tempArr;
        }else{
            weakself.talkMessages = talkMessages;
        }
        
        //        weakself.talkMessages = talkMessages;
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NDTalkMessage *talkMessage in talkMessages) {
            NDMessage *message = [[NDMessage alloc] init];
            message.text = talkMessage.content;
            if([talkMessage.poster_name isEqualToString:[NDCoreSession coreSession].user.name]){
                message.type = NDMessageTypeMe;
                message.icon_url = [NDCoreSession coreSession].user.picture_url;
            }else{
                message.type = NDMessageTypeOther;
                message.icon_url = talkMessage.poster_img;
            }
            
            //            message.time = qaMessage
            
            // 取出上一个大的数据模型
            NDMessageFrame *lastMf = [tempArray lastObject];
            // 取出上一个小的数据模型
            NDMessage *lastMsg = lastMf.message;
            
            // 判断当前条message的时间和上一条message的时间是否一样
            message.hideTime = [message.time isEqualToString:lastMsg.time];
            
            NDMessageFrame *messageFrame = [[NDMessageFrame alloc] init];
            
            // 这个set方法结束以后，子控件的frame和cell行高计算完了
            messageFrame.message = message;
            
            [tempArray addObject:messageFrame];
        }
        weakself.messageFrames = tempArray;
        
        [weakself.tableView reloadData];
        
        [weakself scrollToLastRow];
        
    } failure:^(NSString *error_message) {
        
    }];
}

#pragma mark -输入框的代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 1. 自己发一条消息
    [self sendMessage:textField.text andType:NDMessageTypeMe];
    
    // 2. 自动回复一条
    //    [self sendMessage:[self autoRelayWithText:textField.text] andType:NDMessageTypeOther];
    
    // 3. 清空文字
    self.inputView.text = nil;
    
    return YES;
}

// 返回自动回复的内容
- (NSString *)autoRelayWithText:(NSString *)text
{
    for (int i = 0;i < text.length - 1;i++){
        // 拿到每一个字符
        NSString *word = [text substringWithRange:NSMakeRange(i, 2)];
        
        if(self.relayDict[word]){
            return self.relayDict[word];
        }
    }
    return @"滚蛋";
}

/**
 *  发送一条消息
 */
- (void)sendMessage:(NSString *)text andType:(NDMessageType)type
{
    
    [self startSendTalkMessage:text andQAID:self.qaMesaage.ID success:^(NSArray *talkMessages) {
        
    } failure:^(NSString *error_message) {
        
    }];
    
    // 1. 自己发一条消息
    // 1. 小的数据模型
    NDMessage *message = [[NDMessage alloc] init];
    message.type = type;
    message.text = text;
    message.icon_url = [NDCoreSession coreSession].user.picture_url;
    // 时间
    NSDate *now = [NSDate date];
    //    NSLog(@"now = %@", now);
    // 时间的格式化工具
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"HH:mm";
    //    yyyy-MM-dd HH:mm:ss
    NSString *nowTime = [fmt stringFromDate:now];
    //    message.time = nowTime;
    
    // 是否需要隐藏时间
    NDMessageFrame *lastMsgFrame = [self.messageFrames lastObject];
    message.hideTime = [lastMsgFrame.message.time isEqualToString:nowTime];
    
    // 1.2 把小的模型set给大的模型
    NDMessageFrame *msgFrame = [[NDMessageFrame alloc] init];
    msgFrame.message = message;
    
    // 2. 带有frame模型添加到数组
    [self.messageFrames addObject:msgFrame];
    
    // 3. 刷新
    [self.tableView reloadData];
    
    // 4. 滚到最后一行
    [self scrollToLastRow];
    
}

- (void)dealloc
{
    // 移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//键盘的位置发生变化
/**
 // 键盘弹出的通知
 // 键盘刚要弹出的那一刻的frame
 UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 480}, {320, 216}}";
 // 键盘弹出结束的那一刻的frame
 UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 264}, {320, 216}}";
 
 // 键盘收起的通知
 // 键盘刚要收起的那一刻的frame
 UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 264}, {320, 216}}";
 // 键盘隐藏结束的那一刻的frame
 UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 480}, {320, 216}}";
 */
- (void)keyboardWillChangeFrame:(NSNotification *)noti
{
    //    NSLog(@"%@", noti);
    // 键盘弹出的时候，整个self.view往上 216
    //    self.view.transform = CGAffineTransformMakeTranslation(0, -216);
    //
    //    // 键盘收起的时候，整个self.view还原位置
    //    self.view.transform = CGAffineTransformMakeTranslation(0, 0);
    
    // 0. 获取键盘变化的时间
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 1. 取出键盘变化结束的frame
    CGRect keyboardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 2. 键盘移动的y ＝ 键盘变化结束那一刻的frame.origin.y - 整个view的高度
    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
    
    if(transformY > 0){
        
        transformY -= 114;
        
    }else{
        
        transformY -= 64;
        
    }
    
    // 3. 移动整个view
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, transformY);
    }];
    
    // 4. 设置window的颜色
    self.view.window.backgroundColor = self.tableView.backgroundColor;
    
}

#pragma mark - scrollView的代理方法  一旦开始拖拽，键盘就收回
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 推出键盘
    [self.view endEditing:YES];
}

- (NSDictionary *)relayDict
{
    if (_relayDict == nil) {
        _relayDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"relay.plist" ofType:nil]];
    }
    return _relayDict;
}

- (NSMutableArray *)messageFrames
{
    if (_messageFrames == nil) {
        ////        NSArray *dictArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"messages.plist" ofType:nil]];
        //        NSMutableArray *tempArray = [NSMutableArray array];
        //        for (NDTalkMessage *talkMessage in self.talkMessages) {
        //            NDMessage *message = [[NDMessage alloc] init];
        //            message.text = talkMessage.content;
        //            if([talkMessage.poster_name isEqualToString:[NDCoreSession coreSession].user.name]){
        //                message.type = NDMessageTypeMe;
        //            }else{
        //                message.type = NDMessageTypeOther;
        //            }
        ////            message.time = qaMessage
        //
        //            // 取出上一个大的数据模型
        //            NDMessageFrame *lastMf = [tempArray lastObject];
        //            // 取出上一个小的数据模型
        //            NDMessage *lastMsg = lastMf.message;
        //
        //            // 判断当前条message的时间和上一条message的时间是否一样
        //            message.hideTime = [message.time isEqualToString:lastMsg.time];
        //
        //            NDMessageFrame *messageFrame = [[NDMessageFrame alloc] init];
        //
        //            // 这个set方法结束以后，子控件的frame和cell行高计算完了
        //            messageFrame.message = message;
        //
        //            [tempArray addObject:messageFrame];
        //        }
        //        _messageFrames = tempArray;
        _messageFrames = [NSMutableArray array];
    }
    return _messageFrames;
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1. 创建cell
    NDMessageCell *cell = [NDMessageCell cellWithTableView:tableView];
    
    // 2. 传递模型
    cell.messageframe = self.messageFrames[indexPath.row];
    
    // 3. 返回
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messageFrames[indexPath.row] cellHeight];
}

- (void)scrollToLastRow
{
    NSInteger row = self.messageFrames.count - 1;
    
    FLog(@"%zd", row);
    
    if(row <= 0){
        return;
    }
    
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    FLog(@"%@", lastPath);
    
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

@end
