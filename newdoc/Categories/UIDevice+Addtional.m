//
//  UIDevice+Addtional.m
//  
//
//  Created by TLB on
//  Copyright (c) 2012年 dajie. All rights reserved.
//

#import "UIDevice+Addtional.h"
// for macaddress
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <net/if.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mount.h>
#import <mach/mach.h>
#import <MessageUI/MFMailComposeViewController.h>
//#import "NSString+MD5Addition.h"

@implementation UIDevice (Addtional)

- (NSString *)platform {
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}

// 是否是iPhone
+ (BOOL)isiPhone
{
    UIDevice* device = [UIDevice currentDevice];
    
    if ([device.model isEqualToString:@"iPhone"]) {
        return YES;
    }
    else {
        return NO;
    }
}

// 是否是iPad
+ (BOOL)isiPad
{
    UIDevice* device = [UIDevice currentDevice];
    
    if ([device.model isEqualToString:@"iPad"]) {
        return YES;
    }
    else {
        return NO;
    }
}

// 是否是iTouch
+ (BOOL)isiPodTouch
{
    UIDevice* device = [UIDevice currentDevice];
    
    if ([device.model isEqualToString:@"iPod touch"]) {
        return YES;
    }
    else {
        return NO;
    }
}

// 支持拔打电话
+ (BOOL)supportTelephone
{
    // 目前逻辑：iPhone支持电话，其余设备不支持 
    if ([UIDevice isiPhone]) {
        return YES;
    }
    else {
        return NO;
    }
}

// 支持发送短信
+ (BOOL)supportSendSMS
{
    // 目前逻辑：iPhone支待短信，其余设备不支待
    if ([UIDevice isiPhone]) {
        return YES;
    }
    else {
        return NO;
    }
}

// 支持发送邮件
+ (BOOL)supportSendMail
{
    if ([MFMailComposeViewController canSendMail]) {
        return YES;
    }
    else {
        return NO;
    }
}

// 支持摄像头取景
+ (BOOL)supportCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return YES;
    }
    else {
        return NO;
    }
}

// 以全小写的形式返回设备名称
- (NSString*)modelNameLowerCase
{
    return [self.model lowercaseString];
}

// 系统版本，以float形式返回
- (CGFloat)systemVersionByFloat
{
    return [self.systemVersion floatValue];
}

// 系统版本比较
- (BOOL)systemVersionLowerThan:(NSString*)version
{
    if (version == nil || version.length == 0) {
        return NO;
    }
    
    if ([self.systemVersion compare:version options:NSNumericSearch] == NSOrderedAscending) {
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)systemVersionHigherThan:(NSString*)version
{
    if (version == nil || version.length == 0) {
        return NO;
    }
    
    if ([self.systemVersion compare:version options:NSNumericSearch] == NSOrderedDescending) {
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)systemVersionNotHigherThan:(NSString*)version
{
    if (version == nil || version.length == 0) {
        return NO;
    }
    
    if ([self.systemVersion isEqualToString:version]) {
        return YES;
    }
    else {
        return [self systemVersionLowerThan:version];
    }
}

- (BOOL)systemVersionNotLowerThan:(NSString *)version
{
    if (version == nil || version.length == 0) {
        return NO;
    }
    
    if ([self.systemVersion isEqualToString:version]) {
        return YES;
    }
    else {
        return [self systemVersionHigherThan:version];
    }
}


// Return the local MAC addy
// Courtesy of FreeBSD hackers email list

- (NSString *) macaddress{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

//- (NSString *) deviceIdentifier{
//    if ([self systemVersionNotLowerThan:@"6.0"]) {
//        NSUUID* uuid = self.identifierForVendor;
//        return uuid.UUIDString;
//    }
//    else {
//        NSString *macaddress = [[UIDevice currentDevice] macaddress];
//        //NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
//        NSString *im20SecretCode = @"im20interactive.com+ajvGGILjwtZ30feLFmLn";
//        
//        NSString *stringToHash = [NSString stringWithFormat:@"%@%@",macaddress,im20SecretCode];
//        NSString *identifier = [stringToHash stringFromMD5];
//        
//        return identifier;
//    }
//}


// 内存信息
+ (unsigned int)freeMemory{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    vm_statistics_data_t vm_stat;
    
    host_page_size(host_port, &pagesize);
    (void) host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    return vm_stat.free_count * (unsigned int)pagesize;
}

+ (unsigned int)usedMemory{
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    return (kerr == KERN_SUCCESS) ? (unsigned int)info.resident_size : 0;
}

- (BOOL)hasMultitasking {
    if ([self respondsToSelector:@selector(isMultitaskingSupported)]) {
        return [self isMultitaskingSupported];
    }
    return NO;
}

- (BOOL)isIphone5
{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    return ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f);
}

+ (BOOL)is3halfInchesScreen {
    return ([[UIScreen mainScreen] bounds].size.height <= 480);
}


+ (int) getCurrentDeviceType
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone3,1"]) return iphone4;
    if ([platform isEqualToString:@"iPhone3,2"]) return iphone4;
    if ([platform isEqualToString:@"iPhone3,3"]) return iphone4;
    if ([platform isEqualToString:@"iPhone4,1"]) return iphone4s;
    if ([platform isEqualToString:@"iPhone5,1"]) return iphone5;
    if ([platform isEqualToString:@"iPhone5,2"]) return iphone5;
    if ([platform isEqualToString:@"iPhone5,3"]) return iphone5c;
    if ([platform isEqualToString:@"iPhone5,4"]) return iphone5c;
    if ([platform isEqualToString:@"iPhone6,1"]) return iphone5s;
    if ([platform isEqualToString:@"iPhone6,2"]) return iphone5s;
    if ([platform isEqualToString:@"iPhone7,1"]) return iphone6plus;
    if ([platform isEqualToString:@"iPhone7,2"]) return iphone6;
    if ([platform isEqualToString:@"iPhone8,2"]) return iphone6splus;
    
    //缺省使用iphone6s
    return iphone6s;
}

- (NSString *)platformString
{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}
@end
