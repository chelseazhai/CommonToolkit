//
//  UIBarButtonItem+Extension.h
//  CommonToolkit
//
//  Created by Ares on 13-5-28.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

// init with title, image, action selector and response target
- (id)initWithTitle:(NSString *)title image:(UIImage *)image target:(id)target action:(SEL)action;

@end
