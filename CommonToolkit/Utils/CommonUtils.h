//
//  CommonUtils.h
//  CommonToolkit
//
//  Created by  on 12-6-9.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    // English
    en,
    // Simplified Chinese
    zh_Hans,
    // Traditional Chinese
    zh_Hant
} SystemLanguage;


@interface CommonUtils : NSObject

// get system current setting language
+ (SystemLanguage)systemCurrentSettingLanguage;

// validate processor and its implemetation method
+ (BOOL)validateProcessor:(id)pProcessor andSelector:(SEL)pSelector;

// get application status bar default height
+ (CGFloat)appStatusBarHeight;

// get application navigation bar default height
+ (CGFloat)appNavigationBarHeight;

@end
