//
//  NSDate+Extension.h
//  CommonToolkit
//
//  Created by Ares on 12-6-18.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

// data string with format and time zone
- (NSString *)stringWithFormat:(NSString *)pFormat timeZone:(NSTimeZone *)pTimeZone;

// data string with format
- (NSString *)stringWithFormat:(NSString *)pFormat;

// compare with date component unit flags
- (NSComparisonResult)compare:(NSDate *)pAnotherDate componentUnitFlags:(NSUInteger)pUnitFlags;

@end
