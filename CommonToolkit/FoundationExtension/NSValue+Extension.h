//
//  NSValue+Extension.h
//  CommonToolkit
//
//  Created by Ares on 13-6-1.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSValue (Extension)

// string value
@property (nonatomic, readonly) NSString *stringValue;

// value with c string with encoding UTF-8
+ (NSValue *)valueWithCString:(const char *)pCString;

@end
