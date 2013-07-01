//
//  UIPopupWindow.m
//  CommonToolkit
//
//  Created by Ares on 13-7-1.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "UIPopupWindow.h"

#import "UIViewController+CompatibleView.h"

#import "UIView+UI+ViewController.h"

// ui popup window background color
#define UIPOPUPWINDOWBACKGROUNDCOLOR    [UIColor colorWithWhite:0 alpha:0.3]

@implementation UIPopupWindow

@synthesize presentContentView = _mPresentContentView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // set background color
        self.backgroundColor = UIPOPUPWINDOWBACKGROUNDCOLOR;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews{
    // resize all subviews
    [self resizesSubviews];
}

- (void)setPresentContentView:(UIView *)presentContentView{
    // save present content view and add it to popup window
    _mPresentContentView = presentContentView;
    
    [self addSubview:_mPresentContentView];
}

- (void)showAtLocation:(UIView *)view{
    // init ui popup window root view controller
    _mRootViewController = view.window.rootViewController;
    
    // set modal presentation style
    _mRootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    // show ui popup window
    [_mRootViewController presentModalViewController:[[UIViewController alloc] initWithCompatibleView:self] animated:YES];
}

- (void)dismiss{
    // dismiss ui popup window
    [_mRootViewController dismissModalViewControllerAnimated:NO];
}

@end
