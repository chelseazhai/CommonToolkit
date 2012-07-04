//
//  UIView+UI+ViewController.m
//  CommonToolkit
//
//  Created by  on 12-6-7.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "UIView+UI+ViewController.h"

#import "UIViewExtensionManager.h"

#import "CommonUtils.h"

// UIView extension
@interface UIView (Private)

// handel gesture recognizer
- (void) handleGestureRecognizer:(UIGestureRecognizer*) pGestureRecognizer;

// validate view gesture recognizer delegate reference and check selector
- (BOOL)validateViewGestureRecognizerDelegate:(id<UIViewGestureRecognizerDelegate>)pGestureRecognizerDelegate andSelector:(SEL) pSelector;

@end




@implementation UIView (UI)

- (void)setTitle:(NSString *)title{
    // set view title
    self.viewControllerRef.title = title;
    
    // save title
    [[UIViewExtensionManager shareUIViewExtensionManager] setUIViewExtension:title withType:titleExt forKey:[NSNumber numberWithInteger:self.hash]];
}

- (NSString *)title{
    return [[UIViewExtensionManager shareUIViewExtensionManager] uiViewExtensionForKey:[NSNumber numberWithInteger:self.hash]].title;
}

- (void)setTitleView:(UIView *)titleView{
    // set view title view
    self.viewControllerRef.navigationItem.titleView = titleView;
    
    // save title view
    [[UIViewExtensionManager shareUIViewExtensionManager] setUIViewExtension:titleView withType:titleExt forKey:[NSNumber numberWithInteger:self.hash]];
}

- (UIView *)titleView{
    return [[UIViewExtensionManager shareUIViewExtensionManager] uiViewExtensionForKey:[NSNumber numberWithInteger:self.hash]].titleView;
}

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem{
    // set view left bar button item
    self.viewControllerRef.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    // save left bar button item
    [[UIViewExtensionManager shareUIViewExtensionManager] setUIViewExtension:leftBarButtonItem withType:leftBarButtonItemExt forKey:[NSNumber numberWithInteger:self.hash]];
}

- (UIBarButtonItem *)leftBarButtonItem{
    return [[UIViewExtensionManager shareUIViewExtensionManager] uiViewExtensionForKey:[NSNumber numberWithInteger:self.hash]].leftBarButtonItem;
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem{
    // set view right bar button item
    self.viewControllerRef.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    // save right bar button item
    [[UIViewExtensionManager shareUIViewExtensionManager] setUIViewExtension:rightBarButtonItem withType:rightBarButtonItemExt forKey:[NSNumber numberWithInteger:self.hash]];
}

- (UIBarButtonItem *)rightBarButtonItem{
    return [[UIViewExtensionManager shareUIViewExtensionManager] uiViewExtensionForKey:[NSNumber numberWithInteger:self.hash]].rightBarButtonItem;
}

- (void)setBackgroundImg:(UIImage *)backgroundImg{
    // set view background image
    self.backgroundColor = [UIColor colorWithPatternImage:backgroundImg];
    
    // save background image
    [[UIViewExtensionManager shareUIViewExtensionManager] setUIViewExtension:backgroundImg withType:backgroundImgExt forKey:[NSNumber numberWithInteger:self.hash]];
}

- (UIImage *)backgroundImg{
    return [[UIViewExtensionManager shareUIViewExtensionManager] uiViewExtensionForKey:[NSNumber numberWithInteger:self.hash]].backgroundImg;
}

@end




@implementation UIView (ViewController)

- (void)setViewControllerRef:(UIViewController *)viewControllerRef{
    [[UIViewExtensionManager shareUIViewExtensionManager] setUIViewExtension:viewControllerRef withType:viewControllerRefExt forKey:[NSNumber numberWithInteger:self.hash]];
    
    // update UIView UI
    self.viewControllerRef.title = self.title;
    self.viewControllerRef.navigationItem.titleView = self.titleView;
    self.viewControllerRef.navigationItem.leftBarButtonItem = self.leftBarButtonItem;
    self.viewControllerRef.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
}

- (UIViewController *)viewControllerRef{
    return [[UIViewExtensionManager shareUIViewExtensionManager] uiViewExtensionForKey:[NSNumber numberWithInteger:self.hash]].viewControllerRef;
}

- (BOOL)validateViewControllerRef:(UIViewController *)pViewControllerRef andSelector:(SEL)pSelector{
    BOOL _ret = NO;

    // validate view controller reference and check selector implemetation
    if ([CommonUtils validateProcessor:pViewControllerRef andSelector:pSelector]) {
        _ret = YES;
    }
    else {
        NSLog(@"Error : %@", pViewControllerRef ? [NSString stringWithFormat:@"%@ view controller %@ can't implement method %@", NSStringFromClass(self.class), NSStringFromClass(pViewControllerRef.class), NSStringFromSelector(pSelector)] : [NSString stringWithFormat:@"%@ view controller is nil", NSStringFromClass(self.class)]);
    }
    
    return _ret;
}

@end




@implementation UIView (GestureRecognizer)

- (void)setViewGestureRecognizerDelegate:(id<UIViewGestureRecognizerDelegate>)viewGestureRecognizerDelegate{
    // check view view gesture recognizer delegate implement methods
    if ([self validateViewGestureRecognizerDelegate:viewGestureRecognizerDelegate andSelector:@selector(view:longPressAtPoint:)]) {
        // create and init long press gesture recognizer
        UILongPressGestureRecognizer *_lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
        // set duration time: 0.5 seconds
        _lpgr.minimumPressDuration = 0.5;
        // set delegate
        _lpgr.delegate = self;
        // add long press gesture recognizer
        [self addGestureRecognizer:_lpgr];
    }
    if ([self validateViewGestureRecognizerDelegate:viewGestureRecognizerDelegate andSelector:@selector(view:swipeAtPoint:andDirection:)]) {
        // create and int swipe gesture recognizer
        // left swipe gesture recognizer
        UISwipeGestureRecognizer *_leftSwipegr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
        // set supply direction: left
        _leftSwipegr.direction = UISwipeGestureRecognizerDirectionLeft;
        // set delegate
        _leftSwipegr.delegate = self;
        // add swipe gesture recognizer
        [self addGestureRecognizer:_leftSwipegr];
        
        // right swipe gesture recognizer
        UISwipeGestureRecognizer *_rightSwipegr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
        // set supply direction: right
        _rightSwipegr.direction = UISwipeGestureRecognizerDirectionRight;
        // set delegate
        _rightSwipegr.delegate = self;
        // add swipe gesture recognizer
        [self addGestureRecognizer:_rightSwipegr];
        
        // up swipe gesture recognizer
        UISwipeGestureRecognizer *_upSwipegr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
        // set supply direction: up
        _upSwipegr.direction = UISwipeGestureRecognizerDirectionUp;
        // set delegate
        _upSwipegr.delegate = self;
        // add swipe gesture recognizer
        [self addGestureRecognizer:_upSwipegr];
        
        // down swipe gesture recognizer
        UISwipeGestureRecognizer *_downSwipegr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
        // set supply direction: down
        _downSwipegr.direction = UISwipeGestureRecognizerDirectionDown;
        // set delegate
        _downSwipegr.delegate = self;
        // add swipe gesture recognizer
        [self addGestureRecognizer:_downSwipegr];
    }
    
    // save view gesture recognizer delegate
    [[UIViewExtensionManager shareUIViewExtensionManager] setUIViewExtension:viewGestureRecognizerDelegate withType:viewGestureRecognizerDelegateExt forKey:[NSNumber numberWithInteger:self.hash]];
}

- (id<UIViewGestureRecognizerDelegate>)viewGestureRecognizerDelegate{
    return [[UIViewExtensionManager shareUIViewExtensionManager] uiViewExtensionForKey:[NSNumber numberWithInteger:self.hash]].viewGestureRecognizerDelegate;
}

@end




@implementation UIView (Private)

- (void)handleGestureRecognizer:(UIGestureRecognizer *)pGestureRecognizer{
    // check gesture recognizer type
    // long press
    if ([pGestureRecognizer isMemberOfClass:[UILongPressGestureRecognizer class]]) {
        // just process began state
        if(pGestureRecognizer.state == UIGestureRecognizerStateBegan){
            // validate view gesture recognizer delegate and call its method:(void)uiView: longPressAtPoint:
            if ([self validateViewGestureRecognizerDelegate:self.viewGestureRecognizerDelegate andSelector:@selector(view:longPressAtPoint:)]) {
                [self.viewGestureRecognizerDelegate view:self longPressAtPoint:[pGestureRecognizer locationInView:self]];
            }
        }
    }
    // swipe
    else if([pGestureRecognizer isMemberOfClass:[UISwipeGestureRecognizer class]]){
        // validate view gesture recognizer delegate and call its method:(void)uiView: swipeAtPoint:
        if ([self validateViewGestureRecognizerDelegate:self.viewGestureRecognizerDelegate andSelector:@selector(view:swipeAtPoint:andDirection:)]) {
            [self.viewGestureRecognizerDelegate view:self swipeAtPoint:[pGestureRecognizer locationInView:self] andDirection:((UISwipeGestureRecognizer *)pGestureRecognizer).direction];
        }
    }
}

- (BOOL)validateViewGestureRecognizerDelegate:(id<UIViewGestureRecognizerDelegate>)pGestureRecognizerDelegate andSelector:(SEL)pSelector{
    BOOL _ret = NO;
    
    // validate view gesture recognizer delegate reference and check selector implemetation
    if ([CommonUtils validateProcessor:pGestureRecognizerDelegate andSelector:pSelector]) {
        _ret = YES;
    }
    else {
        NSLog(@"%@ : %@", pGestureRecognizerDelegate ? @"Warning" : @"Error", pGestureRecognizerDelegate ? [NSString stringWithFormat:@"%@ view gesture recognizer delegate %@ can't implement method %@", NSStringFromClass(self.class), NSStringFromClass(pGestureRecognizerDelegate.class), NSStringFromSelector(pSelector)] : [NSString stringWithFormat:@"%@ view gesture recognizer delegate controller is nil", NSStringFromClass(self.class)]);
    }
    
    return _ret;
}

@end
