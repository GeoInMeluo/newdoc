//  newdoc
//
//  Created by zzc on 15/11/6.
//  Copyright © 2015年 zzc. All rights reserved.

#import "NDMessageCell.h"
#import "NDMessageFrame.h"
#import "NDMessage.h"
#import "UIImage+Help.h"

#define NDTimeFont [UIFont systemFontOfSize:13]
#define NDTextFont [UIFont systemFontOfSize:15]

@interface NDMessageCell ()


/**
 *  时间
 */
@property (nonatomic, weak) UILabel *timeView;

/**
 *  头像
 */
@property (nonatomic, weak)UIImageView *iconView;

/**
 *  正文
 */
@property (nonatomic, weak)UIButton *textView;

@end

@implementation NDMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // 1. 标识符
    static NSString *ID = @"message";
    
    // 2. 缓存吃查找
    NDMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 3. 如果没有，创建
    if (cell == nil) {
        cell = [[NDMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    //  4.返回
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 添加子控件
        [self makeView];
    }
    return self;
}
- (void)makeView
{
    // 1. 时间
    UILabel *timeView = [[UILabel alloc] init];
    timeView.textAlignment = NSTextAlignmentCenter;
    timeView.font = NDTimeFont;
//    timeView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:timeView];
    self.timeView = timeView;

    // 2. 头像
    UIImageView *iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    // 3. 正文
    UIButton *textView = [[UIButton alloc] init];
    textView.titleLabel.font = NDTextFont;
    textView.titleLabel.numberOfLines = 0;
//    textView.backgroundColor = [UIColor grayColor];
    
    // 设置文字的内边距
    textView.contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
//    textView.titleLabel.backgroundColor = [UIColor orangeColor];
    
    [self.contentView addSubview:textView];
    self.textView = textView;
    
    // 4. 设置cell 的颜色
    self.backgroundColor = [UIColor clearColor];

}

- (void)setMessageframe:(NDMessageFrame *)messageframe
{
    _messageframe = messageframe;
    
    // 1. 给子控件分发数据
    [self settingData];
    
    // 2. 给子控件设置frame
    [self settingFrame];

}

- (void)settingData
{
    NDMessage *message = self.messageframe.message;
    //  时间
    self.timeView.text = message.time;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:message.icon_url] placeholderImage:[UIImage imageNamed:@"icon_placeHolder"]];
    
    // 头像和气泡和文字颜色
    if (message.type == NDMessageTypeMe) {
//        self.iconView.image = [UIImage imageNamed:@"icon01"];
        
 
        // 需要传一个拉伸好的图片
        [self.textView setBackgroundImage:[UIImage resizableImageWithImage:@"chat_send_nor"] forState:UIControlStateNormal];
        [self.textView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
//        self.iconView.image = [UIImage imageNamed:@"icon02"];
        
        // 需要传一个拉伸好的图片
        [self.textView setBackgroundImage:[UIImage resizableImageWithImage:@"chat_recive_nor"] forState:UIControlStateNormal];
        [self.textView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    //  正文
    [self.textView setTitle:message.text forState:UIControlStateNormal];
  
}

- (void)settingFrame
{
    //  时间
    self.timeView.frame = self.messageframe.timeF;
    
    // 头像
    self.iconView.frame = self.messageframe.iconF;
    
    //  正文
    self.textView.frame = self.messageframe.textF;
}

@end
