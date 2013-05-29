//
//  UIImage+Extension.m
//  CommonToolkit
//
//  Created by Ares on 12-7-3.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "UIImage+Extension.h"

#import "DisplayScreenUtils.h"

// display screen long height
#define DISPLAYSCREEN_LONGHEIGHT    1136.0

// display screen long height compatible image suffix
#define DISPLAYSCREEN_LONGHEIGHT_COMPATIBLEIMGSUFFIX    @"-568h@2x"

@implementation UIImage (Extension)

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

+ (UIImage *)compatibleImageNamed:(NSString *)name{
    NSString *_compatibleImageName = [NSString stringWithString:name];
    
    // check display screen height and update image name
    if (DISPLAYSCREEN_LONGHEIGHT == [DisplayScreenUtils screenHeight]) {
        _compatibleImageName = [name stringByAppendingString:DISPLAYSCREEN_LONGHEIGHT_COMPATIBLEIMGSUFFIX];
    }
    
    return [self imageNamed:_compatibleImageName];
}

@end
