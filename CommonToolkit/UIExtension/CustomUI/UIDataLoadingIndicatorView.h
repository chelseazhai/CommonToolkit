//
//  UIDataLoadingIndicatorView.h
//  CommonToolkit
//
//  Created by Ares on 13-6-26.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDataLoadingIndicatorView : UIView {
    // present subviews
    // subview data loading indicator view
    UIActivityIndicatorView *_mDataLoadingIndicatorView;
    // subview data loading tip label
    UILabel *_mDataLoadingTipLabel;
}

// data loading indicator view style, default is UIActivityIndicatorViewStyleWhite
@property(nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

// init with activity indicator style and tip text, sizes the view according to the data loading indicator view style
- (id)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style tip:(NSString *)tipText;

// is animating
- (BOOL)isAnimating;

// start animating
- (void)startAnimating;

// stop animating
- (void)stopAnimating;

@end
