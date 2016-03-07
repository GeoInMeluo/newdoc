//
//  GlobalDefine.h
//  newdoc
//
//  Created by zzc on 15/10/9.
//  Copyright © 2015年 zzc. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef GlobalDefine_h
#define GlobalDefine_h

#define todo() UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"快提醒程序员这个功能还没做。。" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];[alert show]

#define CreateVC(VcClassName) \
VcClassName * vc = [[VcClassName alloc] initWithNibName:nil bundle:nil];

#define ShowVC(VcClassName) \
VcClassName * vc = [[VcClassName alloc] init]; \
[self.navigationController pushViewController:vc animated:YES];

#define ShowVCWeak(VcClassName) \
VcClassName * vc = [[VcClassName alloc] init]; \
[weakself.navigationController pushViewController:vc animated:YES];

#define PushVC(avc) \
[self.navigationController pushViewController:vc animated:YES];

#define PushVCWeak(avc) \
[weakself.navigationController pushViewController:vc animated:YES];

#define WEAK_SELF __weak typeof (self) weakself = self; weakself
#define WEAK_CELL __weak typeof (cell) weakcell = cell; weakcell

#define LightGray [UIColor colorWithHex:@"#eeeeee"]
#define Blue [UIColor colorWithHex:@"#00AAFF"]
#define kScreenSize [UIScreen mainScreen].bounds.size

#define kRefreshHeader 0
#define kRefreshFooter 1


#define kHostStr @"http://api.xinyijk.com"
//#define kHostStr @"http://newdoc.meluo.net"

#define kVersion 1.0

void ShowAlert(NSString * text);


#endif /* GlobalDefine_h */
