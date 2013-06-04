//
//  CGRectMaker+Extension.m
//  CommonToolkit
//
//  Created by Ares on 13-6-1.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CGRectMaker+Extension.h"

#import "FoundationExtensionManager.h"

#import "NSValue+Extension.h"

CG_EXTERN CGRect CGRectMakeWithFormat(NSValue *xValue, NSValue *yValue, NSValue *widthValue, NSValue *heightValue){
    CGRect rect;
    
    // define origin x, y, size width and height
    CGFloat _originX, _originY, _sizeWidth, _sizeHeight;
    
    // get foundation extension manager
    FoundationExtensionManager *_foundationExtensionManager = [FoundationExtensionManager shareFoundationExtensionManager];
    
    // check x, y, width and height type
    if ([xValue isKindOfClass:[NSNumber class]]) {
        _originX = ((NSNumber *)xValue).floatValue;
    } else {
        // save origin x value string value to foundation extension with origin x value(hashcode)
        [_foundationExtensionManager setFoundationExtensionBeanExtInfoDicValue:xValue.stringValue withExtInfoDicKey:ORIGIN_X_FEKEY forKey:[NSNumber numberWithFloat:_originX = xValue.hash + USHRT_MAX]];
    }
    if ([yValue isKindOfClass:[NSNumber class]]) {
        _originY = ((NSNumber *)yValue).floatValue;
    } else {
        // save origin y value string value to foundation extension with origin y value(hashcode)
        [_foundationExtensionManager setFoundationExtensionBeanExtInfoDicValue:yValue.stringValue withExtInfoDicKey:ORIGIN_Y_FEKEY forKey:[NSNumber numberWithFloat:_originY = yValue.hash + USHRT_MAX]];
    }
    if ([widthValue isKindOfClass:[NSNumber class]]) {
        _sizeWidth = ((NSNumber *)widthValue).floatValue;
    } else {
        // save size width value string value to foundation extension with size width value(hashcode)
        [_foundationExtensionManager setFoundationExtensionBeanExtInfoDicValue:widthValue.stringValue withExtInfoDicKey:SIZE_WIDTH_FEKEY forKey:[NSNumber numberWithFloat:_sizeWidth = widthValue.hash + USHRT_MAX]];
    }
    if ([heightValue isKindOfClass:[NSNumber class]]) {
        _sizeHeight = ((NSNumber *)heightValue).floatValue;
    } else {        
        // save size height value string value to foundation extension with size height value(hashcode)
        [_foundationExtensionManager setFoundationExtensionBeanExtInfoDicValue:heightValue.stringValue withExtInfoDicKey:SIZE_HEIGHT_FEKEY forKey:[NSNumber numberWithFloat:_sizeHeight = heightValue.hash + USHRT_MAX]];
    }
    
    rect.origin.x = _originX; rect.origin.y = _originY;
    rect.size.width = _sizeWidth; rect.size.height = _sizeHeight;
    return rect;
}
