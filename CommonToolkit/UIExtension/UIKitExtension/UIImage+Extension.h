//
//  UIImage+Extension.h
//  CommonToolkit
//
//  Created by Ares on 12-7-3.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

// get gray image
@property (nonatomic, readonly) UIImage *grayImage;

// get compatible image from main bundle with name
+ (UIImage *)compatibleImageNamed:(NSString *)name;

@end
