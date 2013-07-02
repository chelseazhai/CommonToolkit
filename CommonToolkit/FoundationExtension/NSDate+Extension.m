//
//  NSDate+Extension.m
//  CommonToolkit
//
//  Created by Ares on 12-6-18.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

- (NSString *)stringWithFormat:(NSString *)pFormat timeZone:(NSTimeZone *)pTimeZone{
    // create and init dataFormatter
    NSDateFormatter *_dateFormatter = [[NSDateFormatter alloc] init];
    
    // set time zone and data format
    [_dateFormatter setTimeZone:pTimeZone];
    [_dateFormatter setDateFormat:pFormat];
    
    // return data string
    return [_dateFormatter stringFromDate:self];
}

- (NSString *)stringWithFormat:(NSString *)pFormat{
    // return data string with date format and local time zone
    return [self stringWithFormat:pFormat timeZone:[NSTimeZone localTimeZone]];
}

-(NSComparisonResult)compare:(NSDate *)pAnotherDate componentUnitFlags:(NSUInteger)pUnitFlags{
    // define gregorian calendar
    NSCalendar *_calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    // return comparison result
    return [[_calendar dateFromComponents:[_calendar components:pUnitFlags fromDate:self]] compare:[_calendar dateFromComponents:[_calendar components:pUnitFlags fromDate:pAnotherDate]]];
}

@end
