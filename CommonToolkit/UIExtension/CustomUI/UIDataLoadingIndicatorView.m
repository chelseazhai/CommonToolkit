//
//  UIDataLoadingIndicatorView.m
//  CommonToolkit
//
//  Created by Ares on 13-6-26.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "UIDataLoadingIndicatorView.h"

// ui data loading indicator view default background color
#define DEFAULTBACKGROUNDCOLOR  [UIColor colorWithWhite:0 alpha:0.3]

// data loading indicator view and tip label padding
#define PADDING 16.0

// data loading indicator view margin weight
#define DATALOADINGINDICATORVIEWMARGIN_WEIGHT   0.1

// data loading tip label default height
#define DATALOADINGTIPLABEL_DEFAULTHEIGHT   30.0

@implementation UIDataLoadingIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style tip:(NSString *)tipText{
    self = [super init];
    if (self) {
        // Initialization code
        // set default background color
        self.backgroundColor = DEFAULTBACKGROUNDCOLOR;
        
        // create and init subviews
        // init data loading indicator view
        _mDataLoadingIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
        
        // set its auto resizing mask, UIViewAutoresizingFlexibleWidth
        _mDataLoadingIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // start animating
        [_mDataLoadingIndicatorView startAnimating];
        
        // init data loading tip label
        _mDataLoadingTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(_mDataLoadingIndicatorView.frame.origin.x, _mDataLoadingIndicatorView.frame.origin.y + _mDataLoadingIndicatorView.frame.size.height + PADDING, _mDataLoadingIndicatorView.frame.size.width, DATALOADINGTIPLABEL_DEFAULTHEIGHT)];
        
        // set its attributes
        _mDataLoadingTipLabel.text = tipText;
        _mDataLoadingTipLabel.textColor = [UIColor whiteColor];
        _mDataLoadingTipLabel.shadowColor = [UIColor lightGrayColor];
        _mDataLoadingTipLabel.textAlignment = NSTextAlignmentCenter;
        _mDataLoadingTipLabel.backgroundColor = [UIColor clearColor];
        
        // set ui data loading indicator view frame
        [self setFrame:CGRectMake(_mDataLoadingIndicatorView.frame.origin.x, _mDataLoadingIndicatorView.frame.origin.y, _mDataLoadingIndicatorView.frame.size.width, _mDataLoadingIndicatorView.frame.size.height + (PADDING + DATALOADINGTIPLABEL_DEFAULTHEIGHT))];
        
        // add data loging indicator view and tip label as subviews of ui data loading indicator view
        [self addSubview:_mDataLoadingIndicatorView];
        [self addSubview:_mDataLoadingTipLabel];
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

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    // update data loading tip label center
    _mDataLoadingTipLabel.center = CGPointMake(_mDataLoadingIndicatorView.center.x, _mDataLoadingIndicatorView.center.y + (PADDING + DATALOADINGTIPLABEL_DEFAULTHEIGHT));
    
    // update data loading tip label frame
    [_mDataLoadingTipLabel setFrame:CGRectMake(MAX(DATALOADINGINDICATORVIEWMARGIN_WEIGHT * self.frame.size.width, _mDataLoadingTipLabel.frame.origin.x), _mDataLoadingTipLabel.frame.origin.y, (1 - 2 * DATALOADINGINDICATORVIEWMARGIN_WEIGHT) * self.frame.size.width, _mDataLoadingTipLabel.frame.size.height)];
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle{
    // set data loading indicator view style
    _mDataLoadingIndicatorView.activityIndicatorViewStyle = activityIndicatorViewStyle;
}

- (UIActivityIndicatorViewStyle)activityIndicatorViewStyle{
    // get data loading indicator view style
    return _mDataLoadingIndicatorView.activityIndicatorViewStyle;
}

- (BOOL)isAnimating{
    // return data loading indicator view is animating state
    return _mDataLoadingIndicatorView.isAnimating;
}

- (void)startAnimating{
    // start data loading indicator view animating
    [_mDataLoadingIndicatorView stopAnimating];
    
    // show ui data loading indicator view
    self.hidden = NO;
}

- (void)stopAnimating{
    // stop data loading indicator view animating
    [_mDataLoadingIndicatorView stopAnimating];
    
    // hide ui data loading indicator view
    self.hidden = YES;
}

@end
