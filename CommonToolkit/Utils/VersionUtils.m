//
//  VersionUtils.m
//  CommonToolkit
//
//  Created by Ares on 13-6-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "VersionUtils.h"

// application version name key string
#define APPLICATION_VERSIONNAME_KEY @"CFBundleShortVersionString"

@implementation VersionUtils

+ (NSString *)versionName{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:APPLICATION_VERSIONNAME_KEY];
}

+ (NSString *)buildName{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

@end
