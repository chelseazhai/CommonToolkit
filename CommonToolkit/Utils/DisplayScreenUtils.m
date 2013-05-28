//
//  DisplayScreenUtils.m
//  CommonToolkit
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "DisplayScreenUtils.h"

@implementation DisplayScreenUtils

+ (CGFloat)statusBarHeight{
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

+ (CGFloat)navigationBarHeight{
    // navigation bar default height
    return 44.0;
}

+ (CGFloat)screenWidth{
    // get display screen
    UIScreen *_screen = [UIScreen mainScreen];
    
    // return display screen width
    return [_screen bounds].size.width * _screen.scale;
}

+ (CGFloat)screenHeight{
    // get display screen
    UIScreen *_screen = [UIScreen mainScreen];
    
    // return display screen width
    return [_screen bounds].size.height * _screen.scale;
}

@end
