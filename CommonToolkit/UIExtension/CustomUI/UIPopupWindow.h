//
//  UIPopupWindow.h
//  CommonToolkit
//
//  Created by Ares on 13-7-1.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPopupWindow : UIView {
    // popup window root view controller
    UIViewController *_mRootViewController;
    
    // present subviews
    // subview present content view
    UIView *_mPresentContentView;
}

@property (nonatomic, retain) UIView *presentContentView;

// show at location
- (void)showAtLocation:(UIView *)view;

// dismiss
- (void)dismiss;

@end
