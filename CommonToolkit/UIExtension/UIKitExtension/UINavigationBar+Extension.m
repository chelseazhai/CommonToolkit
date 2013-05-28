//
//  UINavigationBar+Extension.m
//  CommonToolkit
//
//  Created by Ares on 13-5-28.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "UINavigationBar+Extension.h"

#define UINAVIGATIONBAR_BACKGROUNDIMGVIEW_TAG   333

@implementation UINavigationBar (Extension)

- (void)setBackgroundImage:(UIImage *)backgroundImage{
    // check ios version
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        // ios 5 later
        [self setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else {
        // get background image view
        UIImageView *_backgroundImgView = (UIImageView *)[self viewWithTag:UINAVIGATIONBAR_BACKGROUNDIMGVIEW_TAG];
        
        // check background image
        if (nil == backgroundImage) {
            // check background image view and remove from UINavigationBar
            if (nil != _backgroundImgView) {
                [_backgroundImgView removeFromSuperview];
            }
        }
        else {
            // check background image view
            if (nil != _backgroundImgView) {
                // set image
                _backgroundImgView.image = backgroundImage;
            }
            else {
                // create and init background image view
                _backgroundImgView = [[UIImageView alloc] initWithImage:backgroundImage];
                
                // set background image view tag and auto resizing mask
                [_backgroundImgView setTag:UINAVIGATIONBAR_BACKGROUNDIMGVIEW_TAG];
                _backgroundImgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                
                // add background image view and send to back
                [self addSubview:_backgroundImgView];
                [self sendSubviewToBack:_backgroundImgView];
            }
        }
    }
}

@end
