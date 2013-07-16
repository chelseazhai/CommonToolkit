//
//  UIDevice+Extension.m
//  CommonToolkit
//
//  Created by Ares on 12-8-9.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "UIDevice+Extension.h"

#import <sys/utsname.h>

#import <sys/sysctl.h>
#import <sys/socket.h>

#import <net/if.h>
#import <net/if_dl.h>

#import "NSString+Extension.h"

// UIDevice extension
@interface UIDevice (Private)

// UIDevice hardware platform
@property (nonatomic, readonly) NSString *platform;

// UIDevice hardware mac address
@property (nonatomic, readonly) NSString *macAddress;

@end




@implementation UIDevice (Extension)

- (CGFloat)systemVersionNum{
    return self.systemVersion.floatValue;
}

- (NSString *)combinedUniqueId{
    // get unique id
    NSString *_uniqueId = /*self.uniqueId*/[self macAddress];
    
    NSLog(@"Info: device unique id = %@", _uniqueId);
    
    return [_uniqueId md5];
}

- (NSString *)hardwareModel{
    NSString *_ret;
    
    // get and hardware platform
    NSString *_platform = [self platform];
    if ([@"iPhone1,1" isEqualToString:_platform]) {
        _ret = @"iPhone 1G";
    }
    else if ([@"iPhone1,2" isEqualToString:_platform]) {
        _ret = @"iPhone 3G";
    }
    else if ([@"iPhone2,1" isEqualToString:_platform]) {
        _ret = @"iPhone 3GS";
    }
    else if ([@"iPhone3,1" isEqualToString:_platform]) {
        _ret = @"iPhone 4";
    }
    else if ([@"iPhone3,2" isEqualToString:_platform]) {
        _ret = @"iPhone 4S";
    }
    else if ([@"iPhone4,1" isEqualToString:_platform]) {
        _ret = @"iPhone 5";
    }
    else if ([@"iPod1,1" isEqualToString:_platform]) {
        _ret = @"iPod Touch 1G";
    }
    else if ([@"iPod2,1" isEqualToString:_platform]) {
        _ret = @"iPod Touch 2G";
    }
    else if ([@"iPod3,1" isEqualToString:_platform]) {
        _ret = @"iPod Touch 3G";
    }
    else if ([@"iPod4,1" isEqualToString:_platform]) {
        _ret = @"iPod Touch 4G";
    }
    else if ([@"x86_64" isEqualToString:_platform] || [@"i386" isEqualToString:_platform]) {
        _ret = [self model];
    }
    else {
        NSLog(@"Unknown plateform = %@", _platform);
    }
    
    return _ret;
}

- (SystemCurrentSettingLanguage)systemCurrentSettingLanguage{
    SystemCurrentSettingLanguage _ret;
    
    // get system preferred language
    NSString *_preferredLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    // english
    if ([_preferredLanguage isEqualToString:@"en"]) {
        _ret = en;
    }
    // simplified chinese
    else if ([_preferredLanguage isEqualToString:@"zh-Hans"]) {
        _ret = zh_Hans;
    }
    // traditional chinese
    else if ([_preferredLanguage isEqualToString:@"zh-Hant"]) {
        _ret = zh_Hant;
    }
    // others
    else {
        _ret = en;
    }
    
    return _ret;
}

@end




@implementation UIDevice (Private)

- (NSString *)platform{
    // define and init utsname
    struct utsname _utsname;
    uname(&_utsname);
    
    // return machine platform
    return [NSString stringWithCString:_utsname.machine encoding:NSUTF8StringEncoding];
}

- (NSString *)macAddress{
    NSString *_ret;
    
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
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    _ret = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return _ret;
}

@end
