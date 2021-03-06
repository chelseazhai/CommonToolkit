//
//  UIView+UI+ViewController.m
//  CommonToolkit
//
//  Created by Ares on 12-6-7.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "UIView+UI+ViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "UIViewExtensionManager.h"

#import "UIViewExtensionBean_Extension.h"

#import "UIDevice+Extension.h"

#import "CommonUtils.h"

#import "DisplayScreenUtils.h"

#import "CGRectMaker+Extension.h"

#import "FoundationExtensionManager.h"

// one hand five fingers
#define MAXFINGERS_COUNT    5
// at most triple taps
#define MAXTAPS_COUNT   3
// four swipe direction
#define SWIPEDIRECTION_COUNT    4

// pan gesture acceleration
#define PANGESTURE_ACCELERATION 2000.0
// pinch gesture acceleration
#define PINCHGESTURE_ACCELERATION   100.0
// rotation gesture acceleration
#define ROTATIONGESTURE_ACCELERATION    100.0

// UIView origin frame rectangle extension key
#define ORIGINFRAME_EXTENSIONKEY    @"origin_frame"

// UIView extension
@interface UIView (Private)

// handel gesture recognizer
- (void) handleGestureRecognizer:(UIGestureRecognizer*) pGestureRecognizer;

// validate view gesture recognizer delegate reference and check selector
- (BOOL)validateViewGestureRecognizerDelegate:(id<UIViewGestureRecognizerDelegate>)pGestureRecognizerDelegate andSelector:(SEL) pSelector;

// validate view supported gesture
- (BOOL)validateSupportedGesture:(GestureType)pGestureType;

// convert NSInteger to binary array(NSNumber *)
- (NSArray *)convertIntegerToBinaryArray:(NSInteger)pInteger;

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
    [[UIViewExtensionManager shareUIViewExtensionManager] setUIViewExtension:titleView withType:titleViewExt forKey:[NSNumber numberWithInteger:self.hash]];
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
    
    // set transparent, if ios system version under 5.0
    if ([UIDevice currentDevice].systemVersionNum < 5.0) {
        self.opaque = NO;
    }
    
    // save background image
    [[UIViewExtensionManager shareUIViewExtensionManager] setUIViewExtension:backgroundImg withType:backgroundImgExt forKey:[NSNumber numberWithInteger:self.hash]];
}

- (UIImage *)backgroundImg{
    return [[UIViewExtensionManager shareUIViewExtensionManager] uiViewExtensionForKey:[NSNumber numberWithInteger:self.hash]].backgroundImg;
}

- (void)setTabBarItem:(UITabBarItem *)tabBarItem{
    // set view tab bar item
    self.viewControllerRef.tabBarItem = tabBarItem;
    
    // save tab bar item
    [[UIViewExtensionManager shareUIViewExtensionManager] setUIViewExtension:tabBarItem withType:tabBarItemExt forKey:[NSNumber numberWithInteger:self.hash]];
}

- (UITabBarItem *)tabBarItem{
    return [[UIViewExtensionManager shareUIViewExtensionManager] uiViewExtensionForKey:[NSNumber numberWithInteger:self.hash]].tabBarItem;
}

@end




@implementation UIView (Draw)

- (void)setCornerRadius:(CGFloat)cornerRadius{
    // set corner radius
    if (cornerRadius > 0.0) {
        self.layer.cornerRadius = cornerRadius;
        self.layer.masksToBounds = YES;
    }
}

- (void)setBorderWithWidth:(CGFloat)borderWidth andColor:(UIColor *)borderColor{
    // set border width and color
    if (borderWidth > 0.0 && nil != borderColor) {
        self.layer.borderWidth = borderWidth;
        self.layer.borderColor = [borderColor CGColor];
    }
}

- (void)resizesSubviews{
    // get UIView all subviews
    NSArray *_allSubViews = [self subviews];
    
    // get UIView draw rectangle
    CGRect _drawRect = self.bounds;
    
    // check if there is or not subviews
    if (nil != _allSubViews) {
        for (int i = 0; i < _allSubViews.count; i++) {
            // get each subview
            UIView *_subView = [_allSubViews objectAtIndex:i];
            
            // get subview frame origin
            CGFloat _subViewOriginX = _subView.frame.origin.x;
            CGFloat _subViewOriginY = _subView.frame.origin.y;
            
            // get subview frame width and height
            CGFloat _subViewWidth = _subView.frame.size.width;
            CGFloat _subViewHeight = _subView.frame.size.height;
            
            // get foundation extension manager
            FoundationExtensionManager *_foundationExtensionManager = [FoundationExtensionManager shareFoundationExtensionManager];
            
            // check subview origin, width, height and update them
            if (_drawRect.size.width < _subViewOriginX && FILL_PARENT >= _subViewOriginX) {
                _subViewOriginX = _drawRect.size.width * (_subViewOriginX / FILL_PARENT);
            }
            else if (FILL_PARENT < _subViewOriginX) {
                _subViewOriginX = evaluateFAOE([[[[[_foundationExtensionManager foundationExtensionForKey:[NSNumber numberWithUnsignedInteger:_subView.hash]] extensionDic] objectForKey:ORIGIN_X_FEKEY] stringByReplacingOccurrencesOfString:[NSString stringWithCString:FILL_PARENT_STRING encoding:NSUTF8StringEncoding] withString:[NSString stringWithFormat:@"%d", (int)_drawRect.size.width]] cStringUsingEncoding:NSUTF8StringEncoding]);
            }
            if (_drawRect.size.height < _subViewOriginY && FILL_PARENT >= _subViewOriginY) {
                _subViewOriginY = _drawRect.size.height * (_subViewOriginY / FILL_PARENT);
            }
            else if (FILL_PARENT < _subViewOriginY) {
                _subViewOriginY = evaluateFAOE([[[[[_foundationExtensionManager foundationExtensionForKey:[NSNumber numberWithUnsignedInteger:_subView.hash]] extensionDic] objectForKey:ORIGIN_Y_FEKEY] stringByReplacingOccurrencesOfString:[NSString stringWithCString:FILL_PARENT_STRING encoding:NSUTF8StringEncoding] withString:[NSString stringWithFormat:@"%d", (int)_drawRect.size.height]] cStringUsingEncoding:NSUTF8StringEncoding]);
            }
            if (_drawRect.size.width < _subViewWidth && FILL_PARENT >= _subViewWidth) {
                _subViewWidth = _drawRect.size.width * (_subViewWidth / FILL_PARENT);
            }
            else if (FILL_PARENT < _subViewWidth) {
                _subViewWidth = evaluateFAOE([[[[[_foundationExtensionManager foundationExtensionForKey:[NSNumber numberWithUnsignedInteger:_subView.hash]] extensionDic] objectForKey:SIZE_WIDTH_FEKEY] stringByReplacingOccurrencesOfString:[NSString stringWithCString:FILL_PARENT_STRING encoding:NSUTF8StringEncoding] withString:[NSString stringWithFormat:@"%d", (int)_drawRect.size.width]] cStringUsingEncoding:NSUTF8StringEncoding]);
            }
            if (_drawRect.size.height < _subViewHeight && FILL_PARENT >= _subViewHeight) {
                _subViewHeight = _drawRect.size.height * (_subViewHeight / FILL_PARENT);
            }
            else if (FILL_PARENT < _subViewHeight) {
                _subViewHeight = evaluateFAOE([[[[[_foundationExtensionManager foundationExtensionForKey:[NSNumber numberWithUnsignedInteger:_subView.hash]] extensionDic] objectForKey:SIZE_HEIGHT_FEKEY] stringByReplacingOccurrencesOfString:[NSString stringWithCString:FILL_PARENT_STRING encoding:NSUTF8StringEncoding] withString:[NSString stringWithFormat:@"%d", (int)_drawRect.size.height]] cStringUsingEncoding:NSUTF8StringEncoding]);
            }
            
            // update subview frame
            _subView.frame = CGRectMake(_subViewOriginX, _subViewOriginY, _subViewWidth, _subViewHeight);
            
            // subview resize its subviews
            [_subView resizesSubviews];
        }
    }
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
    self.viewControllerRef.tabBarItem = self.tabBarItem;
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
    // check view gesture recognizer delegate implement methods
    if (![self validateViewGestureRecognizerDelegate:viewGestureRecognizerDelegate andSelector:@selector(supportedGestureInView:)]) {
        if (viewGestureRecognizerDelegate) {
            NSLog(@"Info: set view = %@ default supported gesture, supported all gesture type: tap, swipe, long press and pan", NSStringFromClass(self.class));
        }
        else {
            return;
        }
    }
    
    // save view gesture recognizer delegate
    [[UIViewExtensionManager shareUIViewExtensionManager] setUIViewExtension:viewGestureRecognizerDelegate withType:viewGestureRecognizerDelegateExt forKey:[NSNumber numberWithInteger:self.hash]];
    
    // set supported gesture
    // long press
    if ([self validateSupportedGesture:longPress] && [self validateViewGestureRecognizerDelegate:viewGestureRecognizerDelegate andSelector:@selector(view:longPressAtPoint:andFingerMode:)]) {
        // create and init long press finger mode
        LongPressFingerMode _longPressFingerMode = /*default finger mode*/single;
        // check long press finger mode
        if ([self validateViewGestureRecognizerDelegate:viewGestureRecognizerDelegate andSelector:@selector(longPressFingerModeInView:)]) {
            _longPressFingerMode = [viewGestureRecognizerDelegate longPressFingerModeInView:self];
        }
        
        // get long press finger mode integer binary array
        NSArray *_longPressFingerModeIBA = [[self convertIntegerToBinaryArray:_longPressFingerMode] subarrayWithRange:NSMakeRange(sizeof(int) * CHAR_BIT - MAXFINGERS_COUNT, MAXFINGERS_COUNT)];
        
        // process long press finger mode integer binary array
        for (NSInteger _index = 0; _index < [_longPressFingerModeIBA count]; _index++) {
            // check finger count
            if (1 == ((NSNumber *)[_longPressFingerModeIBA objectAtIndex:_index]).intValue) {
                // create and init long press gesture recognizer
                UILongPressGestureRecognizer *_lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
                // set number of fingers
                _lpgr.numberOfTouchesRequired = 1 << MAXFINGERS_COUNT - (_index + 1);
                // set delegate
                _lpgr.delegate = self;
                // add long press gesture recognizer
                [self addGestureRecognizer:_lpgr];
            }
        }
    }
    // swipe
    if ([self validateSupportedGesture:swipe] && [self validateViewGestureRecognizerDelegate:viewGestureRecognizerDelegate andSelector:@selector(view:swipeAtPoint:andDirection:)]) {
        // create and init swipe direction
        UISwipeGestureRecognizerDirection _swipeDirection = /*default direction*/UISwipeGestureRecognizerDirectionRight;
        // check swipe direction
        if ([self validateViewGestureRecognizerDelegate:viewGestureRecognizerDelegate andSelector:@selector(swipeDirectionInView:)]) {
            _swipeDirection = [viewGestureRecognizerDelegate swipeDirectionInView:self];
        }
        
        // get swipe direction integer binary array
        NSArray *_swipeDirectionIBA = [[self convertIntegerToBinaryArray:_swipeDirection] subarrayWithRange:NSMakeRange(sizeof(int) * CHAR_BIT - SWIPEDIRECTION_COUNT, SWIPEDIRECTION_COUNT)];
        
        // process swipe direction integer binary array
        for (NSInteger _index = 0; _index < [_swipeDirectionIBA count]; _index++) {
            // check swipe direction
            if (1 == ((NSNumber *)[_swipeDirectionIBA objectAtIndex:_index]).intValue) {
                // create and init swipe gesture recognizer
                UISwipeGestureRecognizer *_swipegr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
                // set supply derection
                _swipegr.direction = 1 << SWIPEDIRECTION_COUNT - (_index + 1);
                // set delegate
                _swipegr.delegate = self;
                // add long press gesture recognizer
                [self addGestureRecognizer:_swipegr];
            }
        }
    }
    // tap
    if ([self validateSupportedGesture:tap] && [self validateViewGestureRecognizerDelegate:viewGestureRecognizerDelegate andSelector:@selector(view:tapAtPoint:andFingerMode:andCountMode:)]) {
        // create and init tap finger mode and count mode
        TapFingerMode _tapFingerMode = /*default finger mode*/single;
        // check tap finger mode
        if ([self validateViewGestureRecognizerDelegate:viewGestureRecognizerDelegate andSelector:@selector(tapFingerModeInView:)]) {
            _tapFingerMode = [viewGestureRecognizerDelegate tapFingerModeInView:self];
        }
        TapCountMode _tapCountMode = /*default count mode*/once;
        // check tap count mode
        if ([self validateViewGestureRecognizerDelegate:viewGestureRecognizerDelegate andSelector:@selector(tapCountModeInView:)]) {
            _tapCountMode = [viewGestureRecognizerDelegate tapCountModeInView:self];
        }
        
        // get tap finger mode integer binary array and count mode integer binary array
        NSArray *_tapFingerModeIBA = [[self convertIntegerToBinaryArray:_tapFingerMode] subarrayWithRange:NSMakeRange(sizeof(int) * CHAR_BIT - MAXFINGERS_COUNT, MAXFINGERS_COUNT)];
        NSArray *_tapCountModeIBA = [[self convertIntegerToBinaryArray:_tapCountMode] subarrayWithRange:NSMakeRange(sizeof(int) * CHAR_BIT - MAXTAPS_COUNT, MAXTAPS_COUNT)];
        
        // process tap finger mode integer binary array and count mode integer binary array
        for (NSInteger _index = 0; _index < [_tapCountModeIBA count]; _index++) {
            // check tap count
            if (1 == ((NSNumber *)[_tapCountModeIBA objectAtIndex:_index]).intValue) {
                for (NSInteger __index = 0; __index < [_tapFingerModeIBA count]; __index++) {
                    // check finger count
                    if (1 == ((NSNumber *)[_tapFingerModeIBA objectAtIndex:__index]).intValue) {
                        // create and init tap gesture recognizer
                        UITapGestureRecognizer *_tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
                        // set number of fingers
                        _tapgr.numberOfTouchesRequired = 1 << MAXFINGERS_COUNT - (__index + 1);
                        // set number of tap count
                        _tapgr.numberOfTapsRequired = 1 << MAXTAPS_COUNT - (_index + 1);
                        // set delegate
                        _tapgr.delegate = self;
                        // add tap gesture recognizer
                        [self addGestureRecognizer:_tapgr];
                    }
                }
            }
        }
    }
    // pan
    if ([self validateSupportedGesture:pan]) {
        // create and init pan gesture recognizer
        UIPanGestureRecognizer *_pangr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
        // set delegate
        _pangr.delegate = self;
        // add pan gesture recognizer
        [self addGestureRecognizer:_pangr];
    }
    // pinch
    if ([self validateSupportedGesture:pinch]) {
        // create and init pinch gesture recognizer
        UIPinchGestureRecognizer *_pinchgr = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
        // set delegate
        _pinchgr.delegate = self;
        // add pinch gesture recognizer
        [self addGestureRecognizer:_pinchgr];
        
        // save view origin frame rectangle to extension dictionary
        [[UIViewExtensionManager shareUIViewExtensionManager] setUIViewExtensionExtInfoDicValue:[NSValue valueWithCGRect:self.frame] withExtInfoDicKey:ORIGINFRAME_EXTENSIONKEY forKey:[NSNumber numberWithInteger:self.hash]];
    }
    // rotation
    if ([self validateSupportedGesture:rotation]) {
        // create and init rotation gesture recognizer
        UIRotationGestureRecognizer *_rotationgr = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
        // set delegate
        _rotationgr.delegate = self;
        // add rotation gesture recognizer
        [self addGestureRecognizer:_rotationgr];
    }
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
            // validate view gesture recognizer delegate and call its method:(void)view:longPressAtPoint:andFingerMode:
            if ([self validateViewGestureRecognizerDelegate:self.viewGestureRecognizerDelegate andSelector:@selector(view:longPressAtPoint:andFingerMode:)]) {
                [self.viewGestureRecognizerDelegate view:self longPressAtPoint:[pGestureRecognizer locationInView:self] andFingerMode:((UILongPressGestureRecognizer *)pGestureRecognizer).numberOfTouchesRequired];
            }
        }
    }
    // swipe
    else if([pGestureRecognizer isMemberOfClass:[UISwipeGestureRecognizer class]]){
        // validate view gesture recognizer delegate and call its method:(void)view:swipeAtPoint:andDirection:
        if ([self validateViewGestureRecognizerDelegate:self.viewGestureRecognizerDelegate andSelector:@selector(view:swipeAtPoint:andDirection:)]) {
            [self.viewGestureRecognizerDelegate view:self swipeAtPoint:[pGestureRecognizer locationInView:self] andDirection:((UISwipeGestureRecognizer *)pGestureRecognizer).direction];
        }
    }
    // tap
    else if ([pGestureRecognizer isMemberOfClass:[UITapGestureRecognizer class]]) {
        // validate view gesture recognizer delegate and call its method:(void)view:tapAtPoint:andFingerMode:andCountMode:
        if ([self validateViewGestureRecognizerDelegate:self.viewGestureRecognizerDelegate andSelector:@selector(view:tapAtPoint:andFingerMode:andCountMode:)]) {
            [self.viewGestureRecognizerDelegate view:self tapAtPoint:[pGestureRecognizer locationInView:self] andFingerMode:((UITapGestureRecognizer *)pGestureRecognizer).numberOfTouchesRequired andCountMode:((UITapGestureRecognizer *)pGestureRecognizer).numberOfTapsRequired];
        }
    }
    // pan
    else if ([pGestureRecognizer isMemberOfClass:[UIPanGestureRecognizer class]]) {
        // get pan gesture recognizer view current frame for updating
        CGRect _updatingFrame = pGestureRecognizer.view.frame;
        
        // just process changed and ended state
        if (pGestureRecognizer.state == UIGestureRecognizerStateChanged) {
            // get translation
            CGPoint _translation = [(UIPanGestureRecognizer *)pGestureRecognizer translationInView:pGestureRecognizer.view];
            
            // set pan gesture view new frame size
            _updatingFrame.origin.x = MIN(MAX(_updatingFrame.origin.x + _translation.x, 0.0), (pGestureRecognizer.view.superview ? pGestureRecognizer.view.superview.frame.size.width : [UIScreen mainScreen].applicationFrame.size.width) - pGestureRecognizer.view.frame.size.width);
            _updatingFrame.origin.y = MIN(MAX(_updatingFrame.origin.y + _translation.y, 0.0), (pGestureRecognizer.view.superview ? pGestureRecognizer.view.superview.frame.size.height : [UIScreen mainScreen].applicationFrame.size.height) - pGestureRecognizer.view.frame.size.height);
            
            pGestureRecognizer.view.frame = _updatingFrame;
            
            // revert translation
            [(UIPanGestureRecognizer *)pGestureRecognizer setTranslation:CGPointZero inView:pGestureRecognizer.view];
        }
        else if (pGestureRecognizer.state == UIGestureRecognizerStateEnded) {
            // get velocity
            CGPoint _velocity = [(UIPanGestureRecognizer *)pGestureRecognizer velocityInView:pGestureRecognizer.view];
            
            CGFloat _combineVelocity = sqrtf(_velocity.x * _velocity.x + _velocity.y * _velocity.y);
            CGFloat _duration = _combineVelocity / PANGESTURE_ACCELERATION;
            
            // set pan gesture view new frame size
            _updatingFrame.origin.x = MIN(MAX(_updatingFrame.origin.x + _combineVelocity * _velocity.x / (2 * PANGESTURE_ACCELERATION), 0.0), (pGestureRecognizer.view.superview ? pGestureRecognizer.view.superview.frame.size.width : [UIScreen mainScreen].applicationFrame.size.width) - pGestureRecognizer.view.frame.size.width);
            _updatingFrame.origin.y = MIN(MAX(_updatingFrame.origin.y + _combineVelocity * _velocity.y / (2 * PANGESTURE_ACCELERATION), 0.0), (pGestureRecognizer.view.superview ? pGestureRecognizer.view.superview.frame.size.height : [UIScreen mainScreen].applicationFrame.size.height) - pGestureRecognizer.view.frame.size.height);
            
            // add curve ease out animation
            [UIView animateWithDuration:MIN(1 / (5 * _duration), 0.3) delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                pGestureRecognizer.view.frame = _updatingFrame;
            } completion:nil];
        }
        
        // validate view gesture recognizer delegate and call its method:(void)view: frameChanged:
        if ([self validateViewGestureRecognizerDelegate:self.viewGestureRecognizerDelegate andSelector:@selector(view:frameChanged:)]) {
            [self.viewGestureRecognizerDelegate view:self frameChanged:_updatingFrame];
        }
    }
    // pinch
    else if ([pGestureRecognizer isMemberOfClass:[UIPinchGestureRecognizer class]]) {
        // get pinch gesture scale
        CGFloat _scale = ((UIPinchGestureRecognizer *)pGestureRecognizer).scale;
        
        // just process changed and ended state
        if (pGestureRecognizer.state == UIGestureRecognizerStateChanged) {
            // set pinch gesture view new frame size
            pGestureRecognizer.view.transform = CGAffineTransformScale(pGestureRecognizer.view.transform, _scale, _scale);
        }
        else if (pGestureRecognizer.state == UIGestureRecognizerStateEnded) {
            // get velocity
            CGFloat _velocity = ((UIPinchGestureRecognizer *)pGestureRecognizer).velocity;
            
            CGFloat _duration = ABS(_velocity) / PINCHGESTURE_ACCELERATION;
            
            // update scale
            _scale = MIN(MAX(_velocity >= 0 ? (1 + (_velocity * _velocity) / (2 * PINCHGESTURE_ACCELERATION)) * _scale : (1 - (_velocity * _velocity) / (2 * PINCHGESTURE_ACCELERATION)) * _scale, ((NSValue *)[[[UIViewExtensionManager shareUIViewExtensionManager] uiViewExtensionForKey:[NSNumber numberWithInteger:self.hash]].extensionDic objectForKey:ORIGINFRAME_EXTENSIONKEY]).CGRectValue.size.width / self.frame.size.width), MIN((self.superview ? self.superview.frame.size.width : [UIScreen mainScreen].applicationFrame.size.width) / self.frame.size.width, (self.superview ? self.superview.frame.size.height : [UIScreen mainScreen].applicationFrame.size.height) / self.frame.size.height));
            
            // add curve ease out animation
            [UIView animateWithDuration:MIN(1 / (100 * _duration), 0.3) delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                // set pinch gesture view new frame size
                pGestureRecognizer.view.transform = CGAffineTransformScale(pGestureRecognizer.view.transform, _scale, _scale);
                
                pGestureRecognizer.view.frame = CGRectMake(MIN(MAX(pGestureRecognizer.view.frame.origin.x, 0.0), (pGestureRecognizer.view.superview ? pGestureRecognizer.view.superview.frame.size.width : [UIScreen mainScreen].applicationFrame.size.width) - pGestureRecognizer.view.frame.size.width), MIN(MAX(pGestureRecognizer.view.frame.origin.y, 0.0), (pGestureRecognizer.view.superview ? pGestureRecognizer.view.superview.frame.size.height : [UIScreen mainScreen].applicationFrame.size.height) - pGestureRecognizer.view.frame.size.height), pGestureRecognizer.view.frame.size.width, pGestureRecognizer.view.frame.size.height);
            } completion:nil];
        }
        
        // revert scale
        ((UIPinchGestureRecognizer *)pGestureRecognizer).scale = 1;
        
        // validate view gesture recognizer delegate and call its method:(void)view: frameChanged:
        if ([self validateViewGestureRecognizerDelegate:self.viewGestureRecognizerDelegate andSelector:@selector(view:frameChanged:)]) {
            [self.viewGestureRecognizerDelegate view:self frameChanged:pGestureRecognizer.view.frame];
        }
    }
    // rotation
    else if ([pGestureRecognizer isMemberOfClass:[UIRotationGestureRecognizer class]]) {
        // set rotation gesture view new frame size
        pGestureRecognizer.view.transform = CGAffineTransformRotate(pGestureRecognizer.view.transform, ((UIRotationGestureRecognizer *)pGestureRecognizer).rotation);
        
        // revert rotation
        ((UIRotationGestureRecognizer *)pGestureRecognizer).rotation = 0;
        
        // validate view gesture recognizer delegate and call its method:(void)view: frameChanged:
        if ([self validateViewGestureRecognizerDelegate:self.viewGestureRecognizerDelegate andSelector:@selector(view:frameChanged:)]) {
            [self.viewGestureRecognizerDelegate view:self frameChanged:pGestureRecognizer.view.frame];
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

- (BOOL)validateSupportedGesture:(GestureType)pGestureType{
    BOOL _ret = NO;
    
    // set view default supported gesture, all type
    GestureType _supportedGesture = tap | swipe | longPress | pan | pinch | rotation;
    
    // get view supported gesture
    if ([self.viewGestureRecognizerDelegate respondsToSelector:@selector(supportedGestureInView:)]) {
        _supportedGesture = [self.viewGestureRecognizerDelegate supportedGestureInView:self];
    }
    
    // check gesture type parameter
    if (pGestureType == (_supportedGesture & pGestureType)) {
        _ret = YES;
    }
    
    return _ret;
}

- (NSArray *)convertIntegerToBinaryArray:(NSInteger)pInteger{
    // get int bits count in ios
    size_t bits = sizeof(int) * CHAR_BIT;
    
    NSMutableArray *_ret = [[NSMutableArray alloc] initWithCapacity:bits];
    
    // type punning because signed shift is implementation-defined
    unsigned u = *(unsigned *)&pInteger;
    for (; bits--; u >>= 1) {
        [_ret addObject:[NSNumber numberWithInt:u & 1 ? 1 : 0]];
    }
    
    // array reverse
    return [[_ret reverseObjectEnumerator] allObjects];
}

@end
