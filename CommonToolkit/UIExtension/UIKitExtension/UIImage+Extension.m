//
//  UIImage+Extension.m
//  CommonToolkit
//
//  Created by Ares on 12-7-3.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (GrayImage)

- (UIImage *)grayImage{
    UIImage *_ret = self;
    
    if (nil != self) {
        // get source image size
        int _width = self.size.width; 
        int _height = self.size.height; 
        
        // get device gray color space bitmap context
        CGColorSpaceRef _grayColorSpace = CGColorSpaceCreateDeviceGray(); 
        CGContextRef _context = CGBitmapContextCreate(nil, _width, _height, 8, 0, _grayColorSpace, kCGImageAlphaNone); 
        CGColorSpaceRelease(_grayColorSpace); 
        
        // check context
        if (_context != NULL) { 
            // set return gray image
            CGContextDrawImage(_context, CGRectMake(0, 0, _width, _height), self.CGImage); 
            _ret = [UIImage imageWithCGImage:CGBitmapContextCreateImage(_context)]; 
            CGContextRelease(_context); 
        } 
    }
    
    return _ret;
}

@end
