//
//  UIGroupView.h
//  CommonToolkit
//
//  Created by Ares on 13-6-28.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGroupView : UIView {
    // present subviews
    // subview border view
    UIView *_mGroupBorderView;
    // subview group header tip label
    UILabel *_mGroupHeaderTipLabel;
    // subview group content view
    UIView *_mGroupContentView;
}

@property (nonatomic, readonly) UIView *contentView;

// set group header tip label text
- (void)setTipLabelText:(NSString *)tipLabelText;

// set group header tip label text color
- (void)setTipLabelTextColor:(UIColor *)tipLabelTextColor;

// set group header tip label text font, mustn't bold
- (void)setTipLabelTextFont:(UIFont *)tipLabelTextFont;

@end
