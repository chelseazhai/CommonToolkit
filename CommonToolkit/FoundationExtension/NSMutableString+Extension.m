//
//  NSMutableString+Extension.m
//  CommonToolkit
//
//  Created by Ares on 13-6-4.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "NSMutableString+Extension.h"

@implementation NSMutableString (Extension)

- (void)clear{
    // check self and delete all characters
    if (nil != self && self.length > 0) {
        [self deleteCharactersInRange:NSMakeRange(0, self.length)];
    }
}

- (NSMutableString *)appendFormatAndReturn:(NSString *)format, ...{
    // get format augument list
    // define format argument list
    //NSMutableArray *_formatArgList = [[NSMutableArray alloc] init];
    
    // define argument and argument list
    //id _arg;
    va_list _argList;
    va_start(_argList, format);
    
    NSString *_string = [NSString stringWithFormat:format, _argList];
    NSLog(@"string = %@, %@", format, _string);
    
//    // check argument
//    if (format) {
//        [_formatArgList addObject:format];
//        
//        // get param address
//        va_start(_argList, format);
//        
//        //
//        while ((_arg = va_arg(_argList, id))) {
//            //
//            //[_formatArgList addObject:_arg];
//        }
//        
//        //
//        va_end(_argList);
//    }
//    
//    for (id _formatArg in _formatArgList) {
//        NSLog(@"format argument = %@", _formatArg);
//    }
    
    return self;
}

@end
