//
//  UIViewGestureRecognizerDelegate.h
//  CommonToolkit
//
//  Created by  on 12-7-3.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIViewGestureRecognizerDelegate <NSObject>

@optional

// long press at view point
- (void)view:(UIView *)pView longPressAtPoint:(CGPoint) pPoint;

// swipe at view point
- (void)view:(UIView *)pView swipeAtPoint:(CGPoint) pPoint;

@end
