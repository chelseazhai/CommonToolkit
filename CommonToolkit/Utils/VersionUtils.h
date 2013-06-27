//
//  VersionUtils.h
//  CommonToolkit
//
//  Created by Ares on 13-6-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionUtils : NSObject

// get current version name
+ (NSString *)versionName;

// get current build name
+ (NSString *)buildName;

@end
