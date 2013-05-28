//
//  UINavigationController+Extension.m
//  CommonToolkit
//
//  Created by Ares on 13-5-24.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "UINavigationController+Extension.h"

#import "UINavigationBar+Extension.h"

@implementation UINavigationController (Extension)

- (id)initWithRootViewController:(UIViewController *)rootViewController andBarStyle:(UIBarStyle)barStyle{
    self = [self initWithRootViewController:rootViewController];
    if (self) {
        // set navigation bar style
        self.navigationBar.barStyle = barStyle;
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController andBarTintColor:(UIColor *)barTintColor{
    self = [self initWithRootViewController:rootViewController];
    if (self) {
        // set navigation bar tint color
        self.navigationBar.tintColor = barTintColor;
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController andBarBackgroundImage:(UIImage *)barBackgroundImage{
    self = [self initWithRootViewController:rootViewController];
    if (self) {
        // set navigation bar background image
        [self.navigationBar setBackgroundImage:barBackgroundImage];
    }
    return self;
}

@end
