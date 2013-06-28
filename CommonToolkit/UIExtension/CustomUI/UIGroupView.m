//
//  UIGroupView.m
//  CommonToolkit
//
//  Created by Ares on 13-6-28.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "UIGroupView.h"

#import <CommonToolkit/CommonToolkit.h>

// margin left, right and bottom
#define MARGINLRB   10.0

// padding
#define PADDING 8.0

// group header tip label height and margin left
#define GROUPHEADERTIPLABEL_HEIGHT  30.0
#define GROUPHEADERTIPLABEL_MARGINLEFT  20.0

// group header tip label text default font size
#define GROUPHEADERTIPLABELTEXT_DEFAULTFONTSIZE 15.0

@interface UIGroupView ()

// update group header tip label width
- (void)updateGroupHeaderTipLabelWidth;

@end

@implementation UIGroupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // create and init subviews
        // init group border view
        _mGroupBorderView = [_mGroupBorderView = [UIView alloc] initWithFrame:CGRectMakeWithFormat(_mGroupBorderView, [NSNumber numberWithFloat:self.bounds.origin.x], [NSNumber numberWithFloat:self.bounds.origin.y + GROUPHEADERTIPLABEL_HEIGHT / 2], [NSNumber numberWithFloat:FILL_PARENT], [NSValue valueWithCString:[[NSString stringWithFormat:@"%d+%s-%d", (int)self.bounds.origin.y, FILL_PARENT_STRING, (int)(GROUPHEADERTIPLABEL_HEIGHT / 2)] cStringUsingEncoding:NSUTF8StringEncoding]])];
        
        // set corner radius, border width and color
        [_mGroupBorderView setCornerRadius:6.0];
        [_mGroupBorderView setBorderWithWidth:1.0 andColor:[UIColor darkGrayColor]];
        
        // init group header tip label
        _mGroupHeaderTipLabel = [_mGroupHeaderTipLabel = [UILabel alloc] initWithFrame:CGRectMakeWithFormat(_mGroupHeaderTipLabel, [NSNumber numberWithFloat:self.bounds.origin.x + MARGINLRB + GROUPHEADERTIPLABEL_MARGINLEFT], [NSNumber numberWithFloat:self.bounds.origin.y], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-2*%d-%d", FILL_PARENT_STRING, (int)MARGINLRB, (int)GROUPHEADERTIPLABEL_MARGINLEFT] cStringUsingEncoding:NSUTF8StringEncoding]], [NSNumber numberWithFloat:GROUPHEADERTIPLABEL_HEIGHT])];
        
        // set its default attributes
        _mGroupHeaderTipLabel.textColor = [UIColor darkGrayColor];
        _mGroupHeaderTipLabel.font = [UIFont systemFontOfSize:GROUPHEADERTIPLABELTEXT_DEFAULTFONTSIZE];
        _mGroupHeaderTipLabel.backgroundColor = [UIColor clearColor];
        
        // init group content view
        _mGroupContentView = [_mGroupContentView = [UIView alloc] initWithFrame:CGRectMakeWithFormat(_mGroupContentView, [NSNumber numberWithFloat:self.bounds.origin.x + MARGINLRB], [NSNumber numberWithFloat:self.bounds.origin.y + GROUPHEADERTIPLABEL_HEIGHT + PADDING], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-2*%d", FILL_PARENT_STRING, (int)MARGINLRB] cStringUsingEncoding:NSUTF8StringEncoding]], [NSValue valueWithCString:[[NSString stringWithFormat:@"%s-%d-%d-%d", FILL_PARENT_STRING, (int)MARGINLRB, (int)PADDING, (int)GROUPHEADERTIPLABEL_HEIGHT] cStringUsingEncoding:NSUTF8StringEncoding]])];
        
        // add group border view, header tip label and content view as subviews of ui group view
        [self addSubview:_mGroupBorderView];
        [self addSubview:_mGroupHeaderTipLabel];
        [self addSubview:_mGroupContentView];
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

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    // update group header tip label background color
    _mGroupHeaderTipLabel.backgroundColor = backgroundColor;
    
    [super setBackgroundColor:backgroundColor];
}

- (void)setBorderWithWidth:(CGFloat)borderWidth andColor:(UIColor *)borderColor{
    // set group border view border width and color
    [_mGroupBorderView setBorderWithWidth:borderWidth andColor:borderColor];
}

- (UIView *)contentView{
    // return ui group view content view
    return _mGroupContentView;
}

- (void)setTipLabelText:(NSString *)tipLabelText{
    // set group header tip label text
    _mGroupHeaderTipLabel.text = tipLabelText;
    
    // update group header tip label width
    [self updateGroupHeaderTipLabelWidth];
}

- (void)setTipLabelTextColor:(UIColor *)tipLabelTextColor{
    // set group header tip label text color
    _mGroupHeaderTipLabel.textColor = tipLabelTextColor;
}

- (void)setTipLabelTextFont:(UIFont *)tipLabelTextFont{
    // set group header tip label text font
    _mGroupHeaderTipLabel.font = tipLabelTextFont;
    
    // update group header tip label width
    [self updateGroupHeaderTipLabelWidth];
}

// inner extension
- (void)updateGroupHeaderTipLabelWidth{
    // update group header tip label frame width using group header tip label text pixel length with its font size
    [_mGroupHeaderTipLabel setFrame:CGRectMake(_mGroupHeaderTipLabel.frame.origin.x, _mGroupHeaderTipLabel.frame.origin.y, MIN([_mGroupHeaderTipLabel.text stringPixelLengthByFontSize:_mGroupHeaderTipLabel.font.pointSize andIsBold:NO], _mGroupHeaderTipLabel.frame.size.width), _mGroupHeaderTipLabel.frame.size.height)];
}

@end
